import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

// --- ENUM para las opciones de ordenamiento ---
enum ComprasSorting { porFecha, porProveedor, porTotal, porCantidad }

// --- Clases auxiliares para combinar datos de la BD ---
class CompraDetalleConProducto {
  final ComprasDetalle detalle;
  final Producto producto;
  CompraDetalleConProducto({required this.detalle, required this.producto});
}

class CompraConDatos {
  final Compra compra;
  final Proveedore? proveedor;
  final int totalProductos;
  CompraConDatos({required this.compra, this.proveedor, required this.totalProductos});
}

class ComprasReportePage extends StatefulWidget {
  final AppDatabase db;
  const ComprasReportePage({super.key, required this.db});

  @override
  State<ComprasReportePage> createState() => _ComprasReportePageState();
}

class _ComprasReportePageState extends State<ComprasReportePage> {
  late Future<List<CompraConDatos>> _comprasFuture;
  DateTime _currentDate = DateTime.now();
  ComprasSorting _currentSorting = ComprasSorting.porFecha;

  @override
  void initState() {
    super.initState();
    _comprasFuture = _fetchCompras();
  }

  void _refreshCompras() {
    setState(() {
      _comprasFuture = _fetchCompras();
    });
  }

  // --- LÓGICA DE DATOS MEJORADA ---
  Future<List<CompraConDatos>> _fetchCompras() async {
    final db = widget.db;
    final cantidadProductos = db.comprasDetalles.cantidad.sum();

    final startOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final endOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0, 23, 59, 59);

    // --- CORRECCIÓN: Se une por el NOMBRE del proveedor, no por el ID ---
    final query = db.select(db.compras).join([
      drift.leftOuterJoin(db.proveedores, db.proveedores.nombre.equalsExp(db.compras.proveedor)),
      drift.leftOuterJoin(db.comprasDetalles, db.comprasDetalles.compraId.equalsExp(db.compras.id)),
    ])
      ..where(db.compras.fecha.isBetween(drift.Constant(startOfMonth), drift.Constant(endOfMonth)));

    switch (_currentSorting) {
      case ComprasSorting.porProveedor:
        query.orderBy([drift.OrderingTerm(expression: db.proveedores.nombre)]);
        break;
      case ComprasSorting.porTotal:
        query.orderBy([drift.OrderingTerm(expression: db.compras.total, mode: drift.OrderingMode.desc)]);
        break;
      case ComprasSorting.porCantidad:
        query.orderBy([drift.OrderingTerm(expression: cantidadProductos, mode: drift.OrderingMode.desc)]);
        break;
      case ComprasSorting.porFecha:
      default:
        query.orderBy([drift.OrderingTerm(expression: db.compras.fecha, mode: drift.OrderingMode.desc)]);
        break;
    }

    query.addColumns([cantidadProductos]);
    query.groupBy([db.compras.id]);

    final result = await query.get();

    return result.map((row) {
      return CompraConDatos(
        compra: row.readTable(db.compras),
        proveedor: row.readTableOrNull(db.proveedores),
        totalProductos: row.read(cantidadProductos) ?? 0,
      );
    }).toList();
  }

  Future<List<CompraDetalleConProducto>> _getDetallesCompra(int compraId) async {
    final query = widget.db.select(widget.db.comprasDetalles).join([
      drift.innerJoin(widget.db.productos, widget.db.productos.id.equalsExp(widget.db.comprasDetalles.productoId))
    ])..where(widget.db.comprasDetalles.compraId.equals(compraId));

    final results = await query.get();
    return results.map((row) {
      return CompraDetalleConProducto(
        detalle: row.readTable(widget.db.comprasDetalles),
        producto: row.readTable(widget.db.productos),
      );
    }).toList();
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
    });
    _refreshCompras();
  }

  void _goToNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
    });
    _refreshCompras();
  }

  void _onSort(ComprasSorting sort) {
    setState(() {
      _currentSorting = sort;
    });
    _refreshCompras();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Reporte de Compras', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
        actions: [
          PopupMenuButton<ComprasSorting>(
            onSelected: _onSort,
            icon: const Icon(Icons.sort, color: Colors.black87),
            tooltip: "Ordenar por",
            itemBuilder: (context) => [
              const PopupMenuItem(value: ComprasSorting.porFecha, child: Text("Más recientes")),
              const PopupMenuItem(value: ComprasSorting.porProveedor, child: Text("Proveedor")),
              const PopupMenuItem(value: ComprasSorting.porTotal, child: Text("Mayor total")),
              const PopupMenuItem(value: ComprasSorting.porCantidad, child: Text("Más productos")),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: Colors.green.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.chevron_left, color: Colors.green.shade800), onPressed: _goToPreviousMonth),
                Text(DateFormat.yMMMM('es_MX').format(_currentDate), style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(icon: Icon(Icons.chevron_right, color: Colors.green.shade800), onPressed: _goToNextMonth),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<CompraConDatos>>(
        future: _comprasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay compras registradas en este mes."));
          }

          final compras = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0),
            itemCount: compras.length,
            itemBuilder: (context, index) {
              final compraConDatos = compras[index];
              final compra = compraConDatos.compra;
              final proveedor = compraConDatos.proveedor;
              final totalProductos = compraConDatos.totalProductos;
              final formattedDate = DateFormat('dd/MM/yyyy').format(compra.fecha);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text("Factura #${compra.id} - $formattedDate", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(proveedor?.nombre ?? 'Proveedor no especificado', style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
                      const SizedBox(height: 4),
                      // --- CORRECCIÓN: Se elimina el 'const' de TextStyle ---
                      Text("Total: \$${compra.total.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.orange.shade800)),
                      if (totalProductos > 0) Text("$totalProductos productos", style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),
                  children: [
                    FutureBuilder<List<CompraDetalleConProducto>>(
                      future: _getDetallesCompra(compra.id),
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
                                subtitle: Text("Cant: ${d.detalle.cantidad} × \$${d.detalle.precioCompra.toStringAsFixed(2)}"),
                                trailing: Text("\$${(d.detalle.cantidad * d.detalle.precioCompra).toStringAsFixed(2)}"),
                              );
                            }).toList(),
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
