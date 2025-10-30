import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

class VentasPage extends StatefulWidget {
  // Se requiere la instancia de la base de datos
  final AppDatabase db;
  const VentasPage({super.key, required this.db});

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  final TextEditingController codigoController = TextEditingController();
  
  // Listas para manejar el estado del ticket actual
  final List<Producto> productosEnVenta = [];
  final Map<int, int> cantidades = {};
  double totalVenta = 0;

  // --- Método para agregar un producto al ticket ---
  Future<void> _agregarProducto() async {
    final codigo = codigoController.text.trim();
    if (codigo.isEmpty) return;

    // Busca el producto por código de barras
    final producto = await (widget.db.select(widget.db.productos)
          ..where((p) => p.codigoBarras.equals(codigo)))
        .getSingleOrNull();

    if (producto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto no encontrado")),
      );
      return;
    }

    // Verifica si hay stock disponible
    if (producto.cantidad <= (cantidades[producto.id] ?? 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay más stock para este producto")),
      );
      return;
    }

    // Actualiza el estado del ticket
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

  // --- Método para finalizar la venta y guardar en la BD ---
  Future<void> _finalizarVenta() async {
    if (productosEnVenta.isEmpty) return;

    try {
      // Usa una transacción para asegurar la integridad de los datos
      await widget.db.transaction(() async {
        // 1. Crea el registro de la venta principal
        final ventaId = await widget.db.into(widget.db.ventas).insert(
              VentasCompanion(
                fecha: drift.Value(DateTime.now()),
                total: drift.Value(totalVenta),
              ),
            );

        // 2. Guarda cada producto del ticket en los detalles de la venta
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

          // 3. Descuenta la cantidad del stock del producto
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
        const SnackBar(content: Text("Venta registrada correctamente")),
      );
      Navigator.pop(context); // Cierra la página de venta

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar la venta: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Venta'),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Fila de entrada de código ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codigoController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Escanear código de barras',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _agregarProducto(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart, size: 30),
                  onPressed: _agregarProducto,
                  color: Colors.indigo.shade700,
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // --- Lista de productos en el ticket ---
            Expanded(
              child: ListView.builder(
                itemCount: productosEnVenta.length,
                itemBuilder: (context, index) {
                  final producto = productosEnVenta[index];
                  final cantidad = cantidades[producto.id]!;
                  return ListTile(
                    title: Text(producto.nombre),
                    subtitle: Text("Cantidad: $cantidad"),
                    trailing: Text(
                        "\$${(producto.precioVenta * cantidad).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),

            // --- Total y botón de finalizar ---
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TOTAL:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text("\$${totalVenta.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _finalizarVenta,
                icon: const Icon(Icons.check),
                label: const Text("Finalizar Venta"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}