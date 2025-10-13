import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'database/database.dart';

class AgregarProveedorPage extends StatefulWidget {
  final AppDatabase db;

  const AgregarProveedorPage({super.key, required this.db});

  @override
  State<AgregarProveedorPage> createState() => _AgregarProveedorPageState();
}

class _AgregarProveedorPageState extends State<AgregarProveedorPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController correoController = TextEditingController();

  // Lista de días de servicio disponibles
  final List<String> dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];

  // Días seleccionados por el usuario
  final Set<String> seleccionados = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Proveedor"),
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

              // --- Selector de días de servicio ---
              const Text(
                "Días de servicio",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: dias.map((dia) {
                  final seleccionado = seleccionados.contains(dia);
                  return FilterChip(
                    label: Text(dia),
                    selected: seleccionado,
                    selectedColor: Colors.indigo.shade100,
                    checkmarkColor: Colors.indigo,
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          seleccionados.add(dia);
                        } else {
                          seleccionados.remove(dia);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Unir los días seleccionados en una sola cadena
                    final diasSeleccionados = seleccionados.join(", ");

                    await widget.db.into(widget.db.proveedores).insert(
                      ProveedoresCompanion(
                        nombre: drift.Value(nombreController.text),
                        numero: drift.Value(numeroController.text),
                        correo: drift.Value(correoController.text),
                        diasServicio: drift.Value(diasSeleccionados),
                      ),
                    );

                    Navigator.pop(context, true); // regresar al listado
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
