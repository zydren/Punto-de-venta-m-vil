import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../barr.dart';
import 'agregar_producto.dart';
import 'editar_producto.dart';
import 'analisis_producto_page.dart'; // Importar la nueva página

enum ProductSorting { porNombre, porCosto, porCantidad }

class Inventario extends StatefulWidget {
  final AppDatabase db = AppDatabase();

  Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  ProductSorting _currentSorting = ProductSorting.porNombre;
  String? _selectedProvider;
  late Stream<List<Producto>> _productsStream;

  @override
  void initState() {
    super.initState();
    _productsStream = _getProductsStream();
  }

  Stream<List<Producto>> _getProductsStream() {
    final query = widget.db.select(widget.db.productos);

    if (_selectedProvider != null) {
      query.where((p) => p.proveedor.equals(_selectedProvider!));
    }

    switch (_currentSorting) {
      case ProductSorting.porNombre:
        query.orderBy([(p) => drift.OrderingTerm(expression: p.nombre)]);
        break;
      case ProductSorting.porCosto:
        query.orderBy([(p) => drift.OrderingTerm(expression: p.precioCompra, mode: drift.OrderingMode.desc)]);
        break;
      case ProductSorting.porCantidad:
        query.orderBy([(p) => drift.OrderingTerm(expression: p.cantidad)]);
        break;
    }
    return query.watch();
  }

  Future<void> _showProviderFilterDialog() async {
    final query = widget.db.selectOnly(widget.db.productos, distinct: true)
      ..addColumns([widget.db.productos.proveedor])
      ..where(widget.db.productos.proveedor.isNotNull());
    
    final providers = await query.map((row) => row.read(widget.db.productos.proveedor)!).get();
    
    final String? chosenProvider = await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Filtrar por Proveedor'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Mostrar Todos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
            ),
            ...providers.map((provider) {
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(context, provider),
                child: Text(provider),
              );
            }).toList(),
          ],
        );
      },
    );

    if (chosenProvider != _selectedProvider) {
      setState(() {
        _selectedProvider = chosenProvider;
        _productsStream = _getProductsStream();
      });
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey.shade800), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Inventario',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            tooltip: 'Filtrar por Proveedor',
            onPressed: _showProviderFilterDialog,
          ),
          PopupMenuButton<ProductSorting>(
            icon: const Icon(Icons.sort, color: Colors.black87),
            tooltip: 'Ordenar Productos',
            onSelected: (ProductSorting result) {
              setState(() {
                _currentSorting = result;
                _productsStream = _getProductsStream();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ProductSorting>>[
              const PopupMenuItem<ProductSorting>(value: ProductSorting.porNombre, child: Text('Ordenar por Nombre')),
              const PopupMenuItem<ProductSorting>(value: ProductSorting.porCosto, child: Text('Ordenar por Costo (Mayor)')),
              const PopupMenuItem<ProductSorting>(value: ProductSorting.porCantidad, child: Text('Ordenar por Cantidad (Menor)')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87, size: 28),
            tooltip: 'Agregar Producto',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarProductoPage(db: widget.db)),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedProvider != null)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Chip(
                label: Text('Proveedor: $_selectedProvider', style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.indigo,
                onDeleted: () {
                  setState(() {
                    _selectedProvider = null;
                    _productsStream = _getProductsStream();
                  });
                },
              ),
            ),
          Expanded(
            child: StreamBuilder<List<Producto>>(
              stream: _productsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final productos = snapshot.data ?? [];
                final bool isFiltered = _selectedProvider != null;

                if (productos.isEmpty) {
                  return Center(
                    child: Text(
                      isFiltered 
                        ? "No hay productos del proveedor \"$_selectedProvider\""
                        : "No hay productos en el inventario.",
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    return Card(
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        title: Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text("Stock: ${producto.cantidad} | Venta: \$${producto.precioVenta.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const SizedBox(height: 8),
                                _buildDetailRow(Icons.monetization_on_outlined, "Compra", "\$${producto.precioCompra.toStringAsFixed(2)}"),
                                _buildDetailRow(Icons.business_center_outlined, "Proveedor", producto.proveedor ?? 'N/A'),
                                _buildDetailRow(Icons.qr_code, "Código", producto.codigoBarras ?? 'N/A'),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // --- NUEVO: Botón de Análisis ---
                                    TextButton.icon(
                                      icon: const Icon(Icons.analytics_outlined, color: Colors.purple, size: 20),
                                      label: const Text('Analizar', style: TextStyle(color: Colors.purple)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => AnalisisProductoPage(db: widget.db, producto: producto)),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                                      label: const Text('Editar', style: TextStyle(color: Colors.blueAccent)),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => EditarProductoPage(producto: producto, db: widget.db)),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                      label: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirmar Eliminación'),
                                              content: Text('¿Estás seguro de que quieres eliminar "${producto.nombre}"?'),
                                              actions: <Widget>[
                                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                                                TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm == true) {
                                          await widget.db.delete(widget.db.productos).delete(producto);
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavBar(context, currentPage: "Inventario"),
    );
  }
}
