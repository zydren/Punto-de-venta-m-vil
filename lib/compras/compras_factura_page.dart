
// Importaciones necesarias para la UI de Flutter, Drift para la base de datos, y la propia base de datos.
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

// Define un StatefulWidget para la página de la factura de compras, que necesita manejar estado.
class ComprasFacturaPage extends StatefulWidget {
  // Instancia de la base de datos que se pasa desde la página anterior.
  final AppDatabase db;

  // Constructor que requiere la instancia de la base de datos.
  const ComprasFacturaPage({super.key, required this.db});

  @override
  State<ComprasFacturaPage> createState() => _ComprasFacturaPageState();
}

// Clase que maneja el estado de ComprasFacturaPage.
class _ComprasFacturaPageState extends State<ComprasFacturaPage> {
  // Controladores para los campos de texto de código y cantidad.
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController(text: '1');

  // Listas para manejar los productos agregados a la factura actual.
  List<Producto> productosAgregados = [];
  Map<int, int> cantidades = {}; // Mapa para asociar el ID del producto con su cantidad.

  // Variable para almacenar el total de la compra.
  double totalCompra = 0;

  // --- Método para agregar un producto a la factura ---
  Future<void> agregarProducto() async {
    final codigo = codigoController.text.trim();
    if (codigo.isEmpty) return; // Si no hay código, no hace nada.

    // Busca el producto en la base de datos usando el código de barras.
    final producto = await (widget.db.select(widget.db.productos)
      ..where((tbl) => tbl.codigoBarras.equals(codigo)))
        .getSingleOrNull();

    // Si el producto no se encuentra, muestra un mensaje.
    if (producto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto no encontrado")),
      );
      return;
    }

    final cantidad = int.tryParse(cantidadController.text) ?? 1;

    // Actualiza el estado de la UI.
    setState(() {
      // Si el producto ya está en la lista, solo suma la cantidad.
      if (cantidades.containsKey(producto.id)) {
        cantidades[producto.id] = (cantidades[producto.id]! + cantidad);
      } else {
        // Si es un producto nuevo, lo agrega a la lista.
        productosAgregados.add(producto);
        cantidades[producto.id] = cantidad;
      }
      // Recalcula el total de la compra.
      totalCompra += producto.precioCompra * cantidad;
    });

    // Limpia los campos de texto para el siguiente producto.
    codigoController.clear();
    cantidadController.text = '1';
  }

  // --- Método para finalizar y registrar la compra en la base de datos ---
  Future<void> finalizarCompra() async {
    if (productosAgregados.isEmpty) return; // Si no hay productos, no hace nada.

    // 1. Inserta el encabezado de la compra en la tabla `compras`.
    final compraId = await widget.db.into(widget.db.compras).insert(
      ComprasCompanion(
        fecha: drift.Value(DateTime.now()),
        total: drift.Value(totalCompra),
      ),
    );

    // 2. Itera sobre los productos agregados para guardarlos en el detalle y actualizar el inventario.
    for (var p in productosAgregados) {
      final cantidad = cantidades[p.id]!;

      // 2a. Inserta cada producto en la tabla `comprasDetalles` (CORREGIDO).
      await widget.db.into(widget.db.comprasDetalles).insert(
        ComprasDetallesCompanion(
          compraId: drift.Value(compraId),
          productoId: drift.Value(p.id),
          cantidad: drift.Value(cantidad),
          precioCompra: drift.Value(p.precioCompra),
        ),
      );

      // 2b. Actualiza la cantidad de stock del producto en la tabla `productos`.
      await (widget.db.update(widget.db.productos)
        ..where((tbl) => tbl.id.equals(p.id)))
          .write(
        ProductosCompanion(
          cantidad: drift.Value(p.cantidad + cantidad),
        ),
      );
    }

    // Muestra un mensaje de confirmación y cierra la pantalla de factura.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Compra registrada correctamente")),
    );

    Navigator.pop(context);
  }

  // --- Construcción de la interfaz de usuario ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior.
      appBar: AppBar(
        title: const Text("Nueva Compra"),
        backgroundColor: Colors.indigo.shade700,
      ),
      // Cuerpo principal.
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Sección de entrada para agregar productos ---
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: codigoController,
                    decoration: const InputDecoration(labelText: "Código de barras"),
                    onSubmitted: (_) => agregarProducto(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: cantidadController,
                    decoration: const InputDecoration(labelText: "Cant."),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_box, color: Colors.indigo),
                  onPressed: agregarProducto,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // --- Lista de productos agregados a la factura ---
            Expanded(
              child: ListView.builder(
                itemCount: productosAgregados.length,
                itemBuilder: (context, index) {
                  final p = productosAgregados[index];
                  final cantidad = cantidades[p.id]!;
                  return ListTile(
                    title: Text(p.nombre),
                    subtitle: Text("Cantidad: $cantidad × \$${p.precioCompra}"),
                    trailing: Text("\$${(p.precioCompra * cantidad).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // --- Total de la compra ---
            Text(
              "Total: \$${totalCompra.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            // --- Botón para finalizar la compra ---
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              icon: const Icon(Icons.check),
              label: const Text("Finalizar Compra"),
              onPressed: finalizarCompra,
            )
          ],
        ),
      ),
    );
  }
}
