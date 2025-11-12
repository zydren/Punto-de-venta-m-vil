import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'compras_scanner_page.dart';
import '../database/database.dart';

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
  Map<int, int> cantidades = {};
  double totalCompra = 0;

  Future<void> escanearCodigo() async {
    final codigo = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ComprasScannerPage()),
    );

    if (codigo != null && codigo.isNotEmpty) {
      codigoController.text = codigo;
      await agregarProducto();
    }
  }

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
    FocusScope.of(context).unfocus(); // Oculta el teclado
  }

  Future<void> finalizarCompra() async {
    if (productosAgregados.isEmpty) return;

    final compraId = await widget.db.into(widget.db.compras).insert(
      ComprasCompanion(
        fecha: drift.Value(DateTime.now()),
        total: drift.Value(totalCompra),
      ),
    );

    for (var p in productosAgregados) {
      final cantidad = cantidades[p.id]!;

      await widget.db.into(widget.db.comprasDetalles).insert(
        ComprasDetallesCompanion(
          compraId: drift.Value(compraId),
          productoId: drift.Value(p.id),
          cantidad: drift.Value(cantidad),
          precioCompra: drift.Value(p.precioCompra),
        ),
      );

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
    // --- CORRECCIÓN: Se cambia el color a indigo para consistencia ---
    final Color primaryColor = Colors.indigo.shade700;
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text('Nueva Compra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
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
            _buildInputSection(primaryColor),
            const SizedBox(height: 20),
            _buildProductList(),
            _buildTotalsSection(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(Color primaryColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: codigoController,
                decoration: const InputDecoration(labelText: "Código de Barras", border: InputBorder.none),
                onSubmitted: (_) => agregarProducto(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.camera_alt_outlined, color: primaryColor, size: 30),
              onPressed: escanearCodigo,
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 60,
              child: TextField(
                controller: cantidadController,
                decoration: const InputDecoration(labelText: "Cant.", border: InputBorder.none),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: agregarProducto,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: productosAgregados.isEmpty
          ? const Center(child: Text('Aún no hay productos en la factura.', style: TextStyle(fontSize: 16, color: Colors.black54)))
          : ListView.builder(
              itemCount: productosAgregados.length,
              itemBuilder: (context, index) {
                final p = productosAgregados[index];
                final cantidad = cantidades[p.id]!;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Colors.grey.shade200, child: const Icon(Icons.shopping_basket_outlined, color: Colors.grey)),
                    title: Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Cantidad: $cantidad @ \$${p.precioCompra.toStringAsFixed(2)} c/u"),
                    trailing: Text("\$${(p.precioCompra * cantidad).toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTotalsSection(Color primaryColor) {
    return Column(
      children: [
        const Divider(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TOTAL:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
              Text("\$${totalCompra.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: primaryColor)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: finalizarCompra,
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            label: const Text("Finalizar Compra", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
