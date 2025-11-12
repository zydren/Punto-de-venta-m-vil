import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import 'scanner_page.dart'; // Importar la nueva página de escáner

class VentasPage extends StatefulWidget {
  final AppDatabase db;
  const VentasPage({super.key, required this.db});

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  final TextEditingController codigoController = TextEditingController();
  
  final List<Producto> productosEnVenta = [];
  final Map<int, int> cantidades = {};
  double totalVenta = 0;

  // --- Método para navegar al escáner y recibir el código ---
  Future<void> _escanearProducto() async {
    final String? codigo = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    if (codigo != null && codigo.isNotEmpty) {
      // Una vez que se recibe un código, se lo procesa automáticamente
      codigoController.text = codigo;
      await _agregarProducto();
    }
  }

  Future<void> _agregarProducto() async {
    final codigo = codigoController.text.trim();
    if (codigo.isEmpty) return;

    final producto = await (widget.db.select(widget.db.productos)
          ..where((p) => p.codigoBarras.equals(codigo)))
        .getSingleOrNull();

    if (producto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto no encontrado")),
      );
      return;
    }

    if (producto.cantidad <= (cantidades[producto.id] ?? 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay más stock para este producto")),
      );
      return;
    }

    setState(() {
      if (cantidades.containsKey(producto.id)) {
        cantidades[producto.id] = cantidades[producto.id]! + 1;
      } else {
        productosEnVenta.add(producto);
        cantidades[producto.id] = 1;
      }
      totalVenta += producto.precioVenta;
    });

    codigoController.clear();
  }

  Future<void> _finalizarVenta() async {
    if (productosEnVenta.isEmpty) return;

    try {
      await widget.db.transaction(() async {
        final ventaId = await widget.db.into(widget.db.ventas).insert(
              VentasCompanion(
                fecha: drift.Value(DateTime.now()),
                total: drift.Value(totalVenta),
              ),
            );

        for (final producto in productosEnVenta) {
          final cantidadVendida = cantidades[producto.id]!;
          
          await widget.db.into(widget.db.ventasDetalles).insert(
                VentasDetallesCompanion(
                  ventaId: drift.Value(ventaId),
                  productoId: drift.Value(producto.id),
                  cantidad: drift.Value(cantidadVendida),
                  precioVenta: drift.Value(producto.precioVenta),
                ),
              );

          final stockActual = producto.cantidad;
          await (widget.db.update(widget.db.productos)..where((p) => p.id.equals(producto.id)))
              .write(
            ProductosCompanion(
              cantidad: drift.Value(stockActual - cantidadVendida),
            ),
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Venta registrada correctamente", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
      );
      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar la venta: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.indigo.shade700;
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Realizar Venta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Fila de entrada de código con escáner ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codigoController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Código de barras",
                      prefixIcon: const Icon(Icons.qr_code_scanner_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _agregarProducto(),
                  ),
                ),
                const SizedBox(width: 10),
                // --- Botón para abrir el escáner ---
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, size: 32),
                  onPressed: _escanearProducto,
                  color: primaryColor,
                  tooltip: 'Escanear código',
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // --- Lista de productos en el ticket ---
            Expanded(
              child: productosEnVenta.isEmpty
                ? const Center(
                    child: Text('Aún no hay productos en la venta.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  )
                : ListView.builder(
                  itemCount: productosEnVenta.length,
                  itemBuilder: (context, index) {
                    final producto = productosEnVenta[index];
                    final cantidad = cantidades[producto.id]!;
                    return Card(
                       margin: const EdgeInsets.symmetric(vertical: 4.0),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                       child: ListTile(
                        title: Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Cantidad: $cantidad"),
                        trailing: Text("\$${(producto.precioVenta * cantidad).toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
            ),

            // --- Total y botón de finalizar ---
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TOTAL:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
                  Text("\$${totalVenta.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.green.shade700)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _finalizarVenta,
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text("Finalizar Venta", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}