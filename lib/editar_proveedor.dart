import 'package:flutter/material.dart';
import 'database/database.dart'; // tu Drift database
import 'package:drift/drift.dart' as drift;
import 'proveedores.dart';

class EditarProveedorPage extends StatefulWidget {
  final AppDatabase db;
  final Proveedore proveedor;

  const EditarProveedorPage({
    super.key,
    required this.db,
    required this.proveedor,
  });

  @override
  State<EditarProveedorPage> createState() => _EditarProveedorPageState();
}

class _EditarProveedorPageState extends State<EditarProveedorPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreController;
  late TextEditingController numeroController;
  late TextEditingController correoController;

  // Lista fija de días
  final List<String> dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  // Días seleccionados (Set para evitar duplicados)
  late Set<String> seleccionados;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(text: widget.proveedor.nombre);
    numeroController = TextEditingController(text: widget.proveedor.numero);
    correoController = TextEditingController(text: widget.proveedor.correo);

    // Convertimos el string de días guardados a un Set
    final diasGuardados = widget.proveedor.diasServicio ?? '';
    seleccionados = diasGuardados.isNotEmpty
        ? diasGuardados.split(',').map((e) => e.trim()).toSet()
        : <String>{};
  }

  @override
  void dispose() {
    nombreController.dispose();
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
                    // Unimos los días seleccionados en una cadena separada por comas
                    final diasSeleccionados = seleccionados.join(', ');

                    await widget.db.update(widget.db.proveedores).replace(
                      ProveedoresCompanion(
                        id: drift.Value(widget.proveedor.id),
                        nombre: drift.Value(nombreController.text),
                        numero: drift.Value(numeroController.text),
                        correo: drift.Value(correoController.text),
                        diasServicio: drift.Value(diasSeleccionados),
                      ),
                    );

                    Navigator.pop(context, true);
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
