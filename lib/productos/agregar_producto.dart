import 'package:flutter/material.dart';
import '../database/database.dart'; // tu Drift database
import 'package:drift/drift.dart' as drift;

class AgregarProductoPage extends StatefulWidget {
  final AppDatabase db; // misma instancia de DB
  const AgregarProductoPage({super.key, required this.db});

  @override
  State<AgregarProductoPage> createState() => _AgregarProductoPageState();
}

class _AgregarProductoPageState extends State<AgregarProductoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController compraController = TextEditingController();
  final TextEditingController ventaController = TextEditingController();
  final TextEditingController proveedorController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController cbController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar producto"),
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
                validator: (value) =>
                value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              TextFormField(
                controller: compraController,
                decoration:
                const InputDecoration(labelText: "Precio de compra"),
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
                decoration:
                const InputDecoration(labelText: "Código de barras"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await widget.db.into(widget.db.productos).insert(
                      ProductosCompanion(
                        nombre: drift.Value(nombreController.text),
                        precioCompra: drift.Value(
                            double.tryParse(compraController.text) ?? 0),
                        precioVenta: drift.Value(
                            double.tryParse(ventaController.text) ?? 0),
                        proveedor:
                        drift.Value(proveedorController.text.isEmpty ? null : proveedorController.text),
                        cantidad: drift.Value(
                            int.tryParse(cantidadController.text) ?? 0),
                        codigoBarras: drift.Value(cbController.text.isEmpty ? null : cbController.text),
                      ),
                    );

                    Navigator.pop(context); // vuelve a Inventario
                  }
                },
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
