import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'database/database.dart';


class ComprasFacturaPage extends StatefulWidget {
  final AppDatabase db;

  const ComprasFacturaPage({super.key, required this.db});

  @override
  State<ComprasFacturaPage> createState() => _ComprasFacturaPageState();
}

class _ComprasFacturaPageState extends State<ComprasFacturaPage> {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController(text: '1');

  List<Producto> productosAgregados = [];
  Map<int, int> cantidades = {}; // productoId -> cantidad

  double totalCompra = 0;

  Future<void> agregarProducto() async {
    final codigo = codigoController.text.trim();
    if (codigo.isEmpty) return;

    final producto = await (widget.db.select(widget.db.productos)
      ..where((tbl) => tbl.codigoBarras.equals(codigo)))
        .getSingleOrNull();

    if (producto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Producto no encontrado")),
      );
      return;
    }

    final cantidad = int.tryParse(cantidadController.text) ?? 1;

    setState(() {
      if (cantidades.containsKey(producto.id)) {
        cantidades[producto.id] = (cantidades[producto.id]! + cantidad);
      } else {
        productosAgregados.add(producto);
        cantidades[producto.id] = cantidad;
      }
      totalCompra += producto.precioCompra * cantidad;
    });

    codigoController.clear();
    cantidadController.text = '1';
  }

  Future<void> finalizarCompra() async {
    print("Mensaje de gato depurador");
    if (productosAgregados.isEmpty) return;

    // Insertar encabezado de compra
    final compraId = await widget.db.into(widget.db.compras).insert(
      ComprasCompanion(
        fecha: drift.Value(DateTime.now()),
        total: drift.Value(totalCompra),
      ),
    );

    // Insertar detalle y actualizar inventario
    for (var p in productosAgregados) {
      final cantidad = cantidades[p.id]!;

      // Insertar detalle
      await widget.db.into(widget.db.comprasDetalle).insert(
        ComprasDetalleCompanion(
          compraId: drift.Value(compraId),
          productoId: drift.Value(p.id),
          cantidad: drift.Value(cantidad),
          precioCompra: drift.Value(p.precioCompra),
        ),
      );

      // Actualizar inventario
      await (widget.db.update(widget.db.productos)
        ..where((tbl) => tbl.id.equals(p.id)))
          .write(
        ProductosCompanion(
          cantidad: drift.Value(p.cantidad + cantidad),
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Compra registrada correctamente")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Compra"),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: codigoController,
                    decoration: const InputDecoration(
                      labelText: "Código de barras",
                    ),
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
            Expanded(
              child: ListView.builder(
                itemCount: productosAgregados.length,
                itemBuilder: (context, index) {
                  final p = productosAgregados[index];
                  final cantidad = cantidades[p.id]!;
                  return ListTile(
                    title: Text(p.nombre),
                    subtitle: Text("Cantidad: $cantidad × \$${p.precioCompra}"),
                    trailing:
                    Text("\$${(p.precioCompra * cantidad).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Total: \$${totalCompra.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              icon: const Icon(Icons.check),
              label: const Text("Finalizar Compra"),
              onPressed:() {
                print("depuracion");
                finalizarCompra();
              }
            )
          ],
        ),
      ),
    );
  }
}
