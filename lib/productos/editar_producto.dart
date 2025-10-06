import 'package:flutter/material.dart';
import '../database/database.dart'; // tu Drift database
import 'package:drift/drift.dart' as drift;

class EditarProductoPage extends StatefulWidget {
  final Producto producto; // Producto a editar
  final AppDatabase db; // Instancia de la base de datos

  const EditarProductoPage({super.key, required this.producto, required this.db});

  @override
  State<EditarProductoPage> createState() => _EditarProductoPageState();
}

class _EditarProductoPageState extends State<EditarProductoPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreController;
  late TextEditingController compraController;
  late TextEditingController ventaController;
  late TextEditingController proveedorController;
  late TextEditingController cantidadController;
  late TextEditingController cbController;

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los datos actuales del producto
    nombreController = TextEditingController(text: widget.producto.nombre);
    compraController = TextEditingController(text: widget.producto.precioCompra.toString());
    ventaController = TextEditingController(text: widget.producto.precioVenta.toString());
    proveedorController = TextEditingController(text: widget.producto.proveedor ?? '');
    cantidadController = TextEditingController(text: widget.producto.cantidad.toString());
    cbController = TextEditingController(text: widget.producto.codigoBarras ?? '');
  }

  @override
  void dispose() {
    nombreController.dispose();
    compraController.dispose();
    ventaController.dispose();
    proveedorController.dispose();
    cantidadController.dispose();
    cbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar producto"),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (value) => value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              TextFormField(
                controller: compraController,
                decoration: const InputDecoration(labelText: "Precio de compra"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: ventaController,
                decoration: const InputDecoration(labelText: "Precio de venta"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: proveedorController,
                decoration: const InputDecoration(labelText: "Proveedor"),
              ),
              TextFormField(
                controller: cantidadController,
                decoration: const InputDecoration(labelText: "Cantidad"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: cbController,
                decoration: const InputDecoration(labelText: "Código de barras"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final companion = ProductosCompanion(
                      nombre: drift.Value(nombreController.text),
                      precioCompra: drift.Value(double.tryParse(compraController.text) ?? 0),
                      precioVenta: drift.Value(double.tryParse(ventaController.text) ?? 0),
                      proveedor: drift.Value(proveedorController.text),
                      cantidad: drift.Value(int.tryParse(cantidadController.text) ?? 0),
                      codigoBarras: drift.Value(cbController.text),
                    );

                    // Actualizamos el registro específico
                    await (widget.db.update(widget.db.productos)
                      ..where((tbl) => tbl.id.equals(widget.producto.id)))
                        .write(companion);

                    Navigator.pop(context); // Volver al inventario
                  }
                },
                child: const Text("Guardar cambios"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
