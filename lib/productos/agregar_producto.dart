import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../ventas/scanner_page.dart'; // Importar la página del escáner

class AgregarProductoPage extends StatefulWidget {
  final AppDatabase db;
  const AgregarProductoPage({super.key, required this.db});

  @override
  State<AgregarProductoPage> createState() => _AgregarProductoPageState();
}

class _AgregarProductoPageState extends State<AgregarProductoPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController compraController = TextEditingController();
  final TextEditingController ventaController = TextEditingController();
  // Se elimina cantidadController
  final TextEditingController cbController = TextEditingController();

  List<Proveedore> _proveedores = [];
  Proveedore? _proveedorSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    final proveedoresList = await widget.db.select(widget.db.proveedores).get();
    if (mounted) {
      setState(() {
        _proveedores = proveedoresList;
      });
    }
  }

  // --- Método para navegar al escáner y recibir el código ---
  Future<void> _escanearCodigo() async {
    final String? codigo = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const ScannerPage()),
    );

    if (codigo != null && codigo.isNotEmpty) {
      setState(() {
        cbController.text = codigo;
      });
    }
  }

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
        title: const Text('Agregar Producto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
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
                label: "Nombre del Producto",
                icon: Icons.shopping_basket_outlined,
                validator: (value) => value!.isEmpty ? "Ingrese un nombre" : null,
              ),
              _buildTextField(
                controller: compraController,
                label: "Precio de Compra",
                icon: Icons.attach_money_outlined,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: ventaController,
                label: "Precio de Venta",
                icon: Icons.price_check_outlined,
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<Proveedore>(
                  value: _proveedorSeleccionado,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Proveedor (Opcional)",
                    prefixIcon: Icon(Icons.local_shipping_outlined, color: Colors.grey.shade600),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  ),
                  hint: const Text('Seleccione un proveedor'),
                  items: _proveedores.map((proveedor) {
                    return DropdownMenuItem<Proveedore>(
                      value: proveedor,
                      child: Text(proveedor.nombre, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (Proveedore? newValue) {
                    setState(() {
                      _proveedorSeleccionado = newValue;
                    });
                  },
                ),
              ),
              // Se eliminó el campo de texto de cantidad
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: cbController,
                        decoration: InputDecoration(
                          labelText: "Código de Barras (Opcional)",
                          prefixIcon: Icon(Icons.qr_code_scanner_outlined, color: Colors.grey.shade600),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 50,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt_outlined, size: 30),
                        onPressed: _escanearCodigo,
                        color: primaryColor,
                        tooltip: 'Escanear código',
                      ),
                    ),
                  ],
                ),
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
                    await widget.db.into(widget.db.productos).insert(
                          ProductosCompanion(
                            nombre: drift.Value(nombreController.text),
                            precioCompra: drift.Value(double.tryParse(compraController.text) ?? 0),
                            precioVenta: drift.Value(double.tryParse(ventaController.text) ?? 0),
                            proveedor: drift.Value(_proveedorSeleccionado?.nombre),
                            // Cantidad siempre es 0 al crear
                            cantidad: const drift.Value(0), 
                            codigoBarras: drift.Value(cbController.text.isEmpty ? null : cbController.text),
                          ),
                        );

                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Guardar Producto",
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
