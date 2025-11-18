import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

// --- ENUM para las opciones de ordenamiento ---
enum VentasSorting { porFecha, porTotal, porCantidad, soloCancelados }

// --- Clases auxiliares para combinar datos de la BD ---
class VentaDetalleConProducto {
  final VentasDetalle detalle;
  final Producto producto;
  VentaDetalleConProducto({required this.detalle, required this.producto});
}

class VentaConteoProductos {
  final Venta venta;
  final int totalProductos;
  VentaConteoProductos({required this.venta, required this.totalProductos});
}


// --- Página para mostrar el reporte de ventas ---
class VentasReportePage extends StatefulWidget {
  final AppDatabase db;
  const VentasReportePage({super.key, required this.db});

  @override
  State<VentasReportePage> createState() => _VentasReportePageState();
}

class _VentasReportePageState extends State<VentasReportePage> {
  late Future<List<VentaConteoProductos>> _ventasFuture;
  DateTime _currentDate = DateTime.now();
  VentasSorting _currentSorting = VentasSorting.porFecha;

  @override
  void initState() {
    super.initState();
    _ventasFuture = _fetchVentas();
  }

  void _refreshVentas() {
    setState(() {
      _ventasFuture = _fetchVentas();
    });
  }

  // --- LÓGICA DE DATOS CORREGIDA Y ROBUSTA ---
  Future<List<VentaConteoProductos>> _fetchVentas() async {
    final db = widget.db;
    final cantidadProductos = db.ventasDetalles.cantidad.sum();

    final startOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final endOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0, 23, 59, 59);

    // 1. Se crea una lista de todas las condiciones de filtrado.
    final List<drift.Expression<bool>> whereClauses = [
      db.ventas.fecha.isBiggerOrEqual(drift.Constant(startOfMonth)),
      db.ventas.fecha.isSmallerOrEqual(drift.Constant(endOfMonth)),
    ];

    // 2. Se añade el filtro de cancelados a la misma lista.
    if (_currentSorting == VentasSorting.soloCancelados) {
      whereClauses.add(db.ventas.cancelado.equals(true));
    } else {
      whereClauses.add(db.ventas.cancelado.equals(false) | db.ventas.cancelado.isNull());
    }

    // 3. Se construye la consulta principal.
    final query = db.select(db.ventas).join([
      drift.leftOuterJoin(
        db.ventasDetalles,
        db.ventasDetalles.ventaId.equalsExp(db.ventas.id),
      )
    ])
    // 4. Se combinan TODAS las cláusulas de la lista en un solo `where`.
    ..where(whereClauses.reduce((a, b) => a & b));

    // 5. Se aplica el ordenamiento.
    switch (_currentSorting) {
      case VentasSorting.porTotal:
        query.orderBy([drift.OrderingTerm(expression: db.ventas.total, mode: drift.OrderingMode.desc)]);
        break;
      case VentasSorting.porCantidad:
        query.orderBy([drift.OrderingTerm(expression: cantidadProductos, mode: drift.OrderingMode.desc)]);
        break;
      case VentasSorting.porFecha:
      case VentasSorting.soloCancelados:
      default:
        query.orderBy([drift.OrderingTerm(expression: db.ventas.fecha, mode: drift.OrderingMode.desc)]);
        break;
    }

    // Se agrupa por venta para que el SUM funcione correctamente.
    query.addColumns([cantidadProductos]);
    query.groupBy([db.ventas.id]);

    final result = await query.get();

    return result.map((row) {
      return VentaConteoProductos(
        venta: row.readTable(db.ventas),
        totalProductos: row.read(cantidadProductos) ?? 0,
      );
    }).toList();
  }

  Future<List<VentaDetalleConProducto>> _getDetallesVenta(int ventaId) async {
    final query = widget.db.select(widget.db.ventasDetalles).join([
      drift.innerJoin(widget.db.productos, widget.db.productos.id.equalsExp(widget.db.ventasDetalles.productoId))
    ])..where(widget.db.ventasDetalles.ventaId.equals(ventaId));

    final results = await query.get();
    return results.map((row) {
      return VentaDetalleConProducto(
        detalle: row.readTable(widget.db.ventasDetalles),
        producto: row.readTable(widget.db.productos),
      );
    }).toList();
  }

  Future<void> _cancelarTicket(Venta venta) async {
    final detalles = await _getDetallesVenta(venta.id);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await widget.db.transaction(() async {
        await (widget.db.update(widget.db.ventas)..where((v) => v.id.equals(venta.id))).write(const VentasCompanion(cancelado: drift.Value(true)));
        for (final detalle in detalles) {
          final productoActual = await (widget.db.select(widget.db.productos)..where((p) => p.id.equals(detalle.producto.id))).getSingle();
          await (widget.db.update(widget.db.productos)..where((p) => p.id.equals(detalle.producto.id))).write(ProductosCompanion(cantidad: drift.Value(productoActual.cantidad + detalle.detalle.cantidad)));
        }
      });

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text("Ticket cancelado y stock restaurado"), backgroundColor: Colors.green,));
      _refreshVentas();
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(SnackBar(content: Text("Error al cancelar el ticket: $e")));
    }
  }
  
  void _goToPreviousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
    });
    _refreshVentas();
  }

  void _goToNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
    });
    _refreshVentas();
  }

  void _onSort(VentasSorting sort) {
    setState(() {
      _currentSorting = sort;
    });
    _refreshVentas();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.blueGrey.shade50;
    final Color primaryColor = Colors.indigo.shade700;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor, // Color de fondo integrado
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87), // Icono oscuro
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Reporte de Ventas",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87), // Texto oscuro
        ),
        actions: [
          PopupMenuButton<VentasSorting>(
            onSelected: _onSort,
            icon: Icon(Icons.sort, color: Colors.black87), // Icono oscuro
            tooltip: "Ordenar por",
            itemBuilder: (context) => [
              const PopupMenuItem(value: VentasSorting.porFecha, child: Text("Más recientes")),
              const PopupMenuItem(value: VentasSorting.porTotal, child: Text("Mayor total")),
              const PopupMenuItem(value: VentasSorting.porCantidad, child: Text("Más productos")),
              const PopupMenuItem(value: VentasSorting.soloCancelados, child: Text("Mostrar cancelados")),
            ],
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: Colors.indigo.shade100, // Color suave que combina
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.chevron_left, color: primaryColor), onPressed: _goToPreviousMonth), // Icono oscuro
                Text(
                  DateFormat.yMMMM('es_MX').format(_currentDate),
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16), // Texto oscuro
                ),
                IconButton(icon: Icon(Icons.chevron_right, color: primaryColor), onPressed: _goToNextMonth), // Icono oscuro
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<VentaConteoProductos>>(
        future: _ventasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay ventas registradas en este mes."));
          }

          final ventas = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0),
            itemCount: ventas.length,
            itemBuilder: (context, index) {
              final ventaAgregada = ventas[index];
              final venta = ventaAgregada.venta;
              final totalProductos = ventaAgregada.totalProductos;
              final formattedDate = DateFormat('dd/MM/yyyy, hh:mm a').format(venta.fecha);
              final isCancelled = venta.cancelado;

              return Card(
                color: isCancelled ? Colors.red.shade100 : Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text("Ticket #${venta.id} - $formattedDate", style: TextStyle(fontWeight: FontWeight.bold, decoration: isCancelled ? TextDecoration.lineThrough : null)),
                  subtitle: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        Text("Total: \$${venta.total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green)),
                        if(totalProductos > 0) Text("$totalProductos productos", style: const TextStyle(color: Colors.black54, fontSize: 13)),
                     ],
                  ),
                  children: [
                    FutureBuilder<List<VentaDetalleConProducto>>(
                      future: _getDetallesVenta(venta.id),
                      builder: (context, detalleSnapshot) {
                        if (detalleSnapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator()));
                        }
                        if (!detalleSnapshot.hasData || detalleSnapshot.data!.isEmpty) {
                          return const ListTile(title: Text("No se encontraron detalles."));
                        }

                        final detalles = detalleSnapshot.data!;

                        return Column(
                          children: [
                             const Divider(height: 1),
                             ...detalles.map((d) {
                              return ListTile(
                                dense: true,
                                title: Text(d.producto.nombre),
                                subtitle: Text("Cant: ${d.detalle.cantidad} × \$${d.detalle.precioVenta.toStringAsFixed(2)}"),
                                trailing: Text("\$${(d.detalle.cantidad * d.detalle.precioVenta).toStringAsFixed(2)}"),
                              );
                            }).toList(),
                            if (!isCancelled)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                                    icon: const Icon(Icons.cancel, size: 18),
                                    label: const Text("Cancelar Ticket"),
                                    onPressed: () => _cancelarTicket(venta),
                                  ),
                                )
                              )
                          ],
                        );
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
