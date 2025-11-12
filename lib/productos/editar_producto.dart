import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../ventas/scanner_page.dart'; // Importar la página del escáner

class EditarProductoPage extends StatefulWidget {
  final Producto producto;
  final AppDatabase db;

  const EditarProductoPage({super.key, required this.producto, required this.db});

  @override
  State<EditarProductoPage> createState() => _EditarProductoPageState();
}

class _EditarProductoPageState extends State<EditarProductoPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreController;
  late TextEditingController compraController;
  late TextEditingController ventaController;
  late TextEditingController cantidadController;
  late TextEditingController cbController;

  List<Proveedore> _proveedores = [];
  Proveedore? _proveedorSeleccionado;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.producto.nombre);
    compraController = TextEditingController(text: widget.producto.precioCompra.toString());
    ventaController = TextEditingController(text: widget.producto.precioVenta.toString());
    cantidadController = TextEditingController(text: widget.producto.cantidad.toString());
    cbController = TextEditingController(text: widget.producto.codigoBarras ?? '');
    
    _cargarYSeleccionarProveedor();
  }
  
  Future<void> _cargarYSeleccionarProveedor() async {
    final proveedoresList = await widget.db.select(widget.db.proveedores).get();
    if (!mounted) return;

    Proveedore? proveedorActual;
    if (widget.producto.proveedor != null) {
      try {
        proveedorActual = proveedoresList.firstWhere((p) => p.nombre == widget.producto.proveedor);
      } catch (e) {
        proveedorActual = null;
      }
    }

    setState(() {
      _proveedores = proveedoresList;
      _proveedorSeleccionado = proveedorActual;
    });
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

  @override
  void dispose() {
    nombreController.dispose();
    compraController.dispose();
    ventaController.dispose();
    cantidadController.dispose();
    cbController.dispose();
    super.dispose();
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
        title: const Text('Editar Producto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
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
              _buildTextField(
                controller: cantidadController,
                label: "Cantidad en Stock",
                icon: Icons.inventory_2_outlined,
                keyboardType: TextInputType.number,
              ),
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
                    final companion = ProductosCompanion(
                      nombre: drift.Value(nombreController.text),
                      precioCompra: drift.Value(double.tryParse(compraController.text) ?? 0),
                      precioVenta: drift.Value(double.tryParse(ventaController.text) ?? 0),
                      proveedor: drift.Value(_proveedorSeleccionado?.nombre),
                      cantidad: drift.Value(int.tryParse(cantidadController.text) ?? 0),
                      codigoBarras: drift.Value(cbController.text.isEmpty ? null : cbController.text),
                    );

                    await (widget.db.update(widget.db.productos)
                          ..where((tbl) => tbl.id.equals(widget.producto.id)))
                        .write(companion);

                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Guardar Cambios",
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
