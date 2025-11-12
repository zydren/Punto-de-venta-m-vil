import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

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

  final List<String> dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  final Set<String> seleccionados = {};

  // Widget reutilizable para los campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
      ),
    );
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
        title: const Text('Agregar Proveedor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: nombreController,
                label: "Nombre del Proveedor",
                icon: Icons.business_center_outlined,
                validator: (value) => value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              _buildTextField(
                controller: numeroController,
                label: "Número de Teléfono",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: correoController,
                label: "Correo Electrónico",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Text(
                "Días de servicio",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: dias.map((dia) {
                  final isSelected = seleccionados.contains(dia);
                  return FilterChip(
                    label: Text(dia),
                    selected: isSelected,
                    selectedColor: primaryColor.withOpacity(0.2),
                    checkmarkColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: isSelected ? primaryColor : Colors.grey.shade400),
                    ),
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
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final diasSeleccionados = seleccionados.join(", ");

                    await widget.db.into(widget.db.proveedores).insert(
                          ProveedoresCompanion(
                            nombre: drift.Value(nombreController.text),
                            numero: drift.Value(numeroController.text),
                            correo: drift.Value(correoController.text),
                            diasServicio: drift.Value(diasSeleccionados),
                          ),
                        );

                    Navigator.pop(context, true);
                  }
                },
                child: const Text(
                  "Guardar Proveedor",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
