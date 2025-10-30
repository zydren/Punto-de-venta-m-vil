import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

// Clase auxiliar para combinar el detalle de la venta con los datos del producto.
class VentaDetalleConProducto {
  final VentasDetalle detalle;
  final Producto producto;

  VentaDetalleConProducto({required this.detalle, required this.producto});
}

// --- Página para mostrar el reporte de ventas ---
class VentasReportePage extends StatefulWidget {
  final AppDatabase db;
  const VentasReportePage({super.key, required this.db});

  @override
  State<VentasReportePage> createState() => _VentasReportePageState();
}

class _VentasReportePageState extends State<VentasReportePage> {
  late Future<List<Venta>> _ventasFuture;

  @override
  void initState() {
    super.initState();
    _ventasFuture = _getVentas();
  }

  void _refreshVentas() {
    setState(() {
      _ventasFuture = _getVentas();
    });
  }

  // Método para obtener todos los encabezados de venta, ordenados por fecha.
  Future<List<Venta>> _getVentas() {
    return (widget.db.select(widget.db.ventas)
          ..orderBy([
            (v) => drift.OrderingTerm(expression: v.fecha, mode: drift.OrderingMode.desc)
          ]))
        .get();
  }

  // Método para obtener los detalles (productos) de una venta específica.
  Future<List<VentaDetalleConProducto>> _getDetallesVenta(int ventaId) async {
    final query = widget.db.select(widget.db.ventasDetalles).join([
      drift.innerJoin(
        widget.db.productos,
        widget.db.productos.id.equalsExp(widget.db.ventasDetalles.productoId),
      )
    ])
      ..where(widget.db.ventasDetalles.ventaId.equals(ventaId));

    final results = await query.get();

    return results.map((row) {
      return VentaDetalleConProducto(
        detalle: row.readTable(widget.db.ventasDetalles),
        producto: row.readTable(widget.db.productos),
      );
    }).toList();
  }

  // Lógica para cancelar un ticket
  Future<void> _cancelarTicket(Venta venta, List<VentaDetalleConProducto> detalles) async {
    try {
      await widget.db.transaction(() async {
        // 1. Marca la venta como cancelada
        await (widget.db.update(widget.db.ventas)..where((v) => v.id.equals(venta.id)))
            .write(const VentasCompanion(cancelado: drift.Value(true)));

        // 2. Devuelve los productos al inventario
        for (final detalle in detalles) {
          await (widget.db.update(widget.db.productos)..where((p) => p.id.equals(detalle.producto.id)))
              .write(ProductosCompanion(
            cantidad: drift.Value(detalle.producto.cantidad + detalle.detalle.cantidad),
          ));
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ticket cancelado y stock restaurado")),
      );
      _refreshVentas(); // Actualiza la lista para reflejar el cambio

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cancelar el ticket: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reporte de Ventas"),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: FutureBuilder<List<Venta>>(
        future: _ventasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay ventas registradas."));
          }

          final ventas = snapshot.data!;

          return ListView.builder(
            itemCount: ventas.length,
            itemBuilder: (context, index) {
              final venta = ventas[index];
              final formattedDate = DateFormat('dd/MM/yyyy, hh:mm a').format(venta.fecha);
              final isCancelled = venta.cancelado;

              return Card(
                // Cambia el color si el ticket está cancelado
                color: isCancelled ? Colors.red.shade100 : null,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ExpansionTile(
                  title: Text("Ticket #${venta.id} - $formattedDate", style: TextStyle(decoration: isCancelled ? TextDecoration.lineThrough : null)),
                  subtitle: Text(
                    "Total: \$${venta.total.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  children: [
                    FutureBuilder<List<VentaDetalleConProducto>>(
                      future: _getDetallesVenta(venta.id),
                      builder: (context, detalleSnapshot) {
                        if (detalleSnapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (!detalleSnapshot.hasData || detalleSnapshot.data!.isEmpty) {
                          return const ListTile(title: Text("No se encontraron detalles para esta venta."));
                        }

                        final detalles = detalleSnapshot.data!;
                        final totalProductos = detalles.fold<int>(0, (sum, item) => sum + item.detalle.cantidad);

                        return Column(
                          children: [
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                               child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Total de productos: $totalProductos", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),)
                               ),
                             ),
                             ...detalles.map((d) {
                              return ListTile(
                                title: Text(d.producto.nombre),
                                subtitle: Text(
                                    "Cant: ${d.detalle.cantidad} × \$${d.detalle.precioVenta.toStringAsFixed(2)}"),
                                trailing: Text(
                                    "\$${(d.detalle.cantidad * d.detalle.precioVenta).toStringAsFixed(2)}"),
                              );
                            }).toList(),
                            // Botón de cancelar, solo si no está ya cancelado
                            if (!isCancelled)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  icon: const Icon(Icons.cancel),
                                  label: const Text("Cancelar Ticket"),
                                  onPressed: () => _cancelarTicket(venta, detalles),
                                ),
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
