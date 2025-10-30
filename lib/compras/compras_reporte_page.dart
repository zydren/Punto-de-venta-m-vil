import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'package:drift/drift.dart' as drift; // Import para OrderingTerm
import '../database/database.dart';

// Clase para agrupar el detalle de una compra con la información del producto.
class CompraDetalleConProducto {
  final ComprasDetalle detalle;
  final Producto producto;

  CompraDetalleConProducto({required this.detalle, required this.producto});
}

// --- Página para mostrar el reporte de compras ---
class ComprasReportePage extends StatefulWidget {
  final AppDatabase db;
  const ComprasReportePage({super.key, required this.db});

  @override
  State<ComprasReportePage> createState() => _ComprasReportePageState();
}

class _ComprasReportePageState extends State<ComprasReportePage> {
  // Future para cargar la lista de compras desde la BD.
  late Future<List<Compra>> _comprasFuture;

  @override
  void initState() {
    super.initState();
    // Se inicia la carga de las compras al crear la pantalla.
    _comprasFuture = _getCompras();
  }

  // Método para obtener todas las compras, ordenadas de la más reciente a la más antigua.
  Future<List<Compra>> _getCompras() {
    return (widget.db.select(widget.db.compras)
          // Corregido se usa OrderingTerm para ordenar, no funciona con desc
          ..orderBy([(t) => drift.OrderingTerm(expression: t.fecha, mode: drift.OrderingMode.desc)]))
        .get();
  }

  // Método para obtener el desglose de productos de una compra específica.
  Future<List<CompraDetalleConProducto>> _getDetallesCompra(int compraId) async {
    // Se hace un "join" para combinar la tabla de detalles con la de productos.
    final query = widget.db.select(widget.db.comprasDetalles).join([
      drift.innerJoin(
        widget.db.productos,
        widget.db.productos.id.equalsExp(widget.db.comprasDetalles.productoId),
      )
    ])
      ..where(widget.db.comprasDetalles.compraId.equals(compraId));

    final results = await query.get();

    // Se convierte el resultado de la consulta en una lista de objetos manejables.
    return results.map((row) {
      return CompraDetalleConProducto(
        detalle: row.readTable(widget.db.comprasDetalles),
        producto: row.readTable(widget.db.productos),
      );
    }).toList();
  }

  // --- Construcción de la Interfaz de Usuario ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reporte de Compras"),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: FutureBuilder<List<Compra>>(
        future: _comprasFuture,
        builder: (context, snapshot) {
          // Muestra un indicador de carga mientras se obtienen los datos.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Muestra un mensaje si no hay compras registradas.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay compras registradas."));
          }

          final compras = snapshot.data!;

          // Construye la lista de compras. Cada compra es un botón desplegable.
          return ListView.builder(
            itemCount: compras.length,
            itemBuilder: (context, index) {
              final compra = compras[index];
              final formattedDate =
                  DateFormat('dd/MM/yyyy, hh:mm a').format(compra.fecha);

              // ExpansionTile es el widget que crea el efecto de "botón desplegable".
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ExpansionTile(
                  title: Text("Compra #${compra.id} - $formattedDate"),
                  subtitle: Text(
                    "Total: \$${compra.total.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Los "children" son los widgets que aparecen al desplegar.
                  children: [
                    // Se usa otro FutureBuilder para cargar los detalles solo cuando el usuario los pide.
                    FutureBuilder<List<CompraDetalleConProducto>>(
                      future: _getDetallesCompra(compra.id),
                      builder: (context, detalleSnapshot) {
                        if (detalleSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (!detalleSnapshot.hasData ||
                            detalleSnapshot.data!.isEmpty) {
                          return const ListTile(title: Text("No hay detalles."));
                        }

                        final detalles = detalleSnapshot.data!;

                        // Mapea la lista de detalles a una lista de widgets para mostrarlos.
                        return Column(
                          children: detalles.map((d) {
                            return ListTile(
                              title: Text(d.producto.nombre),
                              subtitle: Text(
                                  "Cant: ${d.detalle.cantidad} × \$${d.detalle.precioCompra.toStringAsFixed(2)}"),
                              trailing: Text(
                                  "\$${(d.detalle.cantidad * d.detalle.precioCompra).toStringAsFixed(2)}"),
                            );
                          }).toList(),
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
