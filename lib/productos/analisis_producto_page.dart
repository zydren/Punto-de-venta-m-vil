import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

// Clase auxiliar para el resultado del análisis
class AnalisisProducto {
  final int vendidos30dias;
  final double velocidadVenta;
  final double? diasStockRestantes;
  final int cantidadSugerida;

  AnalisisProducto({
    required this.vendidos30dias,
    required this.velocidadVenta,
    this.diasStockRestantes,
    required this.cantidadSugerida,
  });
}

class AnalisisProductoPage extends StatefulWidget {
  final AppDatabase db;
  final Producto producto;

  const AnalisisProductoPage({
    super.key,
    required this.db,
    required this.producto,
  });

  @override
  State<AnalisisProductoPage> createState() => _AnalisisProductoPageState();
}

class _AnalisisProductoPageState extends State<AnalisisProductoPage> {
  late Future<AnalisisProducto> _analisisFuture;

  @override
  void initState() {
    super.initState();
    _analisisFuture = _fetchAnalisis();
  }

  Future<AnalisisProducto> _fetchAnalisis() async {
    final db = widget.db;
    final producto = widget.producto;
    final treintaDiasAtras = DateTime.now().subtract(const Duration(days: 30));

    // Obtener ventas de los últimos 30 días para ESTE producto.
    final query = db.select(db.ventasDetalles).join([
      drift.innerJoin(db.ventas, db.ventas.id.equalsExp(db.ventasDetalles.ventaId))
    ])
      ..where(db.ventasDetalles.productoId.equals(producto.id) &
          db.ventas.fecha.isBiggerOrEqual(drift.Constant(treintaDiasAtras)));

    final detallesVentas = await query.get();

    int vendidos30dias = 0;
    for (final row in detallesVentas) {
      vendidos30dias += row.readTable(db.ventasDetalles).cantidad;
    }

    double velocidadVenta = vendidos30dias / 30.0;
    double? diasRestantes;
    int cantidadSugerida = 0;

    if (velocidadVenta > 0) {
      diasRestantes = producto.cantidad / velocidadVenta;
      const int diasDeStockDeseados = 30;
      if (diasRestantes < diasDeStockDeseados) {
        final double cantidadACubrir = (diasDeStockDeseados - diasRestantes) * velocidadVenta;
        cantidadSugerida = cantidadACubrir.ceil();
      }
    }

    return AnalisisProducto(
      vendidos30dias: vendidos30dias,
      velocidadVenta: velocidadVenta,
      diasStockRestantes: diasRestantes,
      cantidadSugerida: cantidadSugerida > 0 ? cantidadSugerida : 0, 
    );
  }
  
  Color _getUrgencyColor(double? dias) {
    if (dias == null) return Colors.grey.shade500;
    if (dias <= 7) return Colors.red.shade600;
    if (dias <= 15) return Colors.orange.shade600;
    if (dias <= 30) return Colors.amber.shade700;
    return Colors.green.shade600;
  }

  Widget _buildDataPoint(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        title: Text('Análisis: ${widget.producto.nombre}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87), overflow: TextOverflow.ellipsis),
      ),
      body: FutureBuilder<AnalisisProducto>(
        future: _analisisFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error al generar análisis: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No se pudo generar el análisis."));
          }

          final analisis = snapshot.data!;
          final dias = analisis.diasStockRestantes;
          final color = _getUrgencyColor(dias);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: color.withOpacity(0.7), width: 1.5),
                borderRadius: BorderRadius.circular(12)
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dias != null) ...[
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 18, height: 1.4),
                          children: <TextSpan>[
                            const TextSpan(text: 'A este ritmo, te queda stock para '),
                            TextSpan(
                                text: '${dias.toStringAsFixed(0)} días',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    fontSize: 19)),
                          ],
                        ),
                      ),
                    ] else ...[
                       Text(
                        "Este producto no ha registrado ventas en los últimos 30 días.",
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 17, height: 1.4),
                      ),
                    ],
                    const SizedBox(height: 24),

                    if (analisis.cantidadSugerida > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_checkout, color: color, size: 22),
                            const SizedBox(width: 12),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black87, fontSize: 16),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Sugerencia: Comprar '),
                                  TextSpan(
                                    text: '${analisis.cantidadSugerida} unidades',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 22),
                            const SizedBox(width: 12),
                            Text(
                              "No requiere reposición urgente.",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade800, fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ],

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDataPoint("Stock Actual", "${widget.producto.cantidad} und."),
                          _buildDataPoint("Vendido (30d)", "${analisis.vendidos30dias} und."),
                          _buildDataPoint("Venta / día", analisis.velocidadVenta.toStringAsFixed(1)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
