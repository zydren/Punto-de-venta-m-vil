import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

// --- Clase auxiliar para mantener los datos del análisis ---
class ProductoSugerencia {
  final Producto producto;
  final int vendidos30dias;
  final double velocidadVenta; // Unidades por día
  final double? diasStockRestantes;
  final int cantidadSugerida; // Cuántas unidades comprar

  ProductoSugerencia({
    required this.producto,
    required this.vendidos30dias,
    required this.velocidadVenta,
    this.diasStockRestantes,
    required this.cantidadSugerida,
  });
}

class SugerenciasCompraPage extends StatefulWidget {
  final AppDatabase db;
  const SugerenciasCompraPage({super.key, required this.db});

  @override
  State<SugerenciasCompraPage> createState() => _SugerenciasCompraPageState();
}

class _SugerenciasCompraPageState extends State<SugerenciasCompraPage> {
  late Future<List<ProductoSugerencia>> _sugerenciasFuture;

  @override
  void initState() {
    super.initState();
    _sugerenciasFuture = _fetchSugerencias();
  }

  // --- LÓGICA DE ANÁLISIS DE VENTAS (CORREGIDA Y ROBUSTA) ---
  Future<List<ProductoSugerencia>> _fetchSugerencias() async {
    final db = widget.db;
    final treintaDiasAtras = DateTime.now().subtract(const Duration(days: 30));

    final allProducts = await db.select(db.productos).get();

    final ventaQuery = db.select(db.ventasDetalles).join([
      drift.innerJoin(db.ventas, db.ventas.id.equalsExp(db.ventasDetalles.ventaId))
    ])
      ..where(db.ventas.fecha.isBiggerOrEqual(drift.Constant(treintaDiasAtras)));

    final detallesVentas = await ventaQuery.get();

    final Map<int, int> ventasPorProducto = {};
    for (final row in detallesVentas) {
      final detalle = row.readTable(db.ventasDetalles);
      ventasPorProducto.update(
        detalle.productoId,
        (value) => value + detalle.cantidad,
        ifAbsent: () => detalle.cantidad,
      );
    }

    List<ProductoSugerencia> sugerencias = [];
    for (final producto in allProducts) {
      final vendidos = ventasPorProducto[producto.id] ?? 0;

      if (vendidos > 0) {
        final double velocidadVenta = vendidos / 30.0;
        final double diasRestantes = producto.cantidad / velocidadVenta;

        if (diasRestantes <= 15) {
          // --- NUEVO: Cálculo de la cantidad a comprar ---
          const int diasDeStockDeseados = 30;
          final double cantidadACubrir = (diasDeStockDeseados - diasRestantes) * velocidadVenta;
          final int cantidadSugerida = cantidadACubrir.ceil();

          sugerencias.add(ProductoSugerencia(
            producto: producto,
            vendidos30dias: vendidos,
            velocidadVenta: velocidadVenta,
            diasStockRestantes: diasRestantes,
            // Se sugiere comprar al menos 1 unidad.
            cantidadSugerida: cantidadSugerida > 0 ? cantidadSugerida : 1,
          ));
        }
      }
    }

    sugerencias.sort((a, b) => a.diasStockRestantes!.compareTo(b.diasStockRestantes!));

    return sugerencias;
  }

  Color _getUrgencyColor(double? dias) {
    if (dias == null) return Colors.grey.shade400;
    if (dias <= 7) return Colors.red.shade600;
    if (dias <= 15) return Colors.orange.shade600;
    return Colors.green.shade600;
  }

  Widget _buildDataPoint(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
        ),
      ],
    );
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
        title: const Text('Sugerencias de Compra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87)),
      ),
      body: FutureBuilder<List<ProductoSugerencia>>(
        future: _sugerenciasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error al generar sugerencias: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "¡Todo en orden! No hay productos con bajo stock que requieran reposición urgente.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            );
          }

          final sugerencias = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            itemCount: sugerencias.length,
            itemBuilder: (context, index) {
              final sug = sugerencias[index];
              final dias = sug.diasStockRestantes;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: _getUrgencyColor(dias).withOpacity(0.7), width: 1.2),
                  borderRadius: BorderRadius.circular(12)
                ),
                elevation: 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sug.producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                      const SizedBox(height: 12),
                      
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 16, height: 1.4),
                          children: <TextSpan>[
                            const TextSpan(text: 'Te queda inventario para solo '),
                            TextSpan(
                                text: '${dias!.toStringAsFixed(0)} días',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _getUrgencyColor(dias),
                                    fontSize: 17)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- NUEVO: Llamada a la acción para comprar ---
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _getUrgencyColor(dias).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_checkout, color: _getUrgencyColor(dias), size: 22),
                            const SizedBox(width: 12),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black87, fontSize: 16),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Comprar: '),
                                  TextSpan(
                                    text: '${sug.cantidadSugerida} unidades',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: _getUrgencyColor(dias), fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Datos de Soporte ---
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDataPoint("Stock Actual", "${sug.producto.cantidad} und."),
                            _buildDataPoint("Vendido (30d)", "${sug.vendidos30dias} und."),
                            _buildDataPoint("Venta / día", sug.velocidadVenta.toStringAsFixed(1)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
