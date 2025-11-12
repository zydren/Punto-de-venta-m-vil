import 'package:flutter/material.dart';
import '../database/database.dart'; //
import '../barr.dart';
import 'agregar_producto.dart';
import 'editar_producto.dart';

class Inventario extends StatefulWidget {
  final AppDatabase db = AppDatabase(); // Instancia única de la base de datos

  Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  @override
  Widget build(BuildContext context) {
    // Paleta de colores profesional y cohesiva
    final Color primaryColor = Colors.indigo.shade700;
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      // --- AppBar Rediseñada ---
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Inventario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        // Borde inferior sutil para separar la barra del contenido
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        automaticallyImplyLeading: false, // sin flecha de regreso
      ),
      body: StreamBuilder<List<Producto>>(
        stream: widget.db.select(widget.db.productos).watch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final productos = snapshot.data ?? [];

          if (productos.isEmpty) {
            return const Center(
              child: Text(
                "No hay productos en el inventario.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Añadir un poco de espacio
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return Card(
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                // --- MODIFICACIÓN: Se usa ExpansionTile en lugar de ListTile ---
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  title: Text(
                    producto.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "Stock: ${producto.cantidad} | Venta: \$${producto.precioVenta.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarProductoPage(producto: producto, db: widget.db),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmar Eliminación'),
                                content: Text('¿Estás seguro de que quieres eliminar "${producto.nombre}"?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                  ),
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
                  ),
                  // --- Contenido que se expande ---
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           const Divider(),
                           const SizedBox(height: 8),
                           Text("Precio Compra: \$${producto.precioCompra.toStringAsFixed(2)}"),
                           const SizedBox(height: 8),
                           Text("Proveedor: ${producto.proveedor ?? 'N/A'}"),
                           const SizedBox(height: 8),
                           Text("Código de Barras: ${producto.codigoBarras ?? 'N/A'}"),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarProductoPage(db: widget.db),
            ),
          );
        },
      ),
      bottomNavigationBar: bottomNavBar(
        context,
        currentPage: "Inventario",
      ),
    );
  }
}
