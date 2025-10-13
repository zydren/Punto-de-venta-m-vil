import 'package:flutter/material.dart';
import 'database/database.dart'; // tu Drift database
import 'package:drift/drift.dart' as drift;
import 'proveedores.dart';

class EditarProveedorPage extends StatefulWidget {
  final AppDatabase db;
  final Proveedore proveedor;

  const EditarProveedorPage({super.key, required this.db, required this.proveedor});

  @override
  State<EditarProveedorPage> createState() => _EditarProveedorPageState();
}

class _EditarProveedorPageState extends State<EditarProveedorPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreController;
  late TextEditingController diasController;
  late TextEditingController numeroController;
  late TextEditingController correoController;

  @override
  void initState() {
    super.initState();
    // 🔹 Inicializamos los controladores con los valores existentes
    nombreController = TextEditingController(text: widget.proveedor.nombre);
    diasController = TextEditingController(text: widget.proveedor.diasServicio);
    numeroController = TextEditingController(text: widget.proveedor.numero);
    correoController = TextEditingController(text: widget.proveedor.correo);
  }

  @override
  void dispose() {
    nombreController.dispose();
    diasController.dispose();
    numeroController.dispose();
    correoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar proveedor"),
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
                controller: diasController,
                decoration: const InputDecoration(labelText: "Días de servicio (ej: Lunes, Jueves)"),
              ),
              TextFormField(
                controller: numeroController,
                decoration: const InputDecoration(labelText: "Número"),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: correoController,
                decoration: const InputDecoration(labelText: "Correo"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // 🔹 Actualizamos el registro en Drift
                    await widget.db.update(widget.db.proveedores).replace(
                      ProveedoresCompanion(
                        id: drift.Value(widget.proveedor.id), // mantenemos el ID
                        nombre: drift.Value(nombreController.text),
                        diasServicio: drift.Value(diasController.text),
                        numero: drift.Value(numeroController.text),
                        correo: drift.Value(correoController.text),
                      ),
                    );

                    Navigator.pop(context, true); // Regresamos a la lista
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
