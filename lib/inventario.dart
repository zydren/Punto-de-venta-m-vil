import 'package:flutter/material.dart';
import 'database/database.dart'; // tu Drift database
import 'barr.dart';
import 'productos/agregar_producto.dart';
import 'productos/editar_producto.dart';

class Inventario extends StatefulWidget {
  final AppDatabase db = AppDatabase(); // Instancia única de la base de datos


  Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventario"),
        centerTitle: true,
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
            return const Center(child: Text("No hay productos en el inventario."));
          }

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return ListTile(
                title: Text(producto.nombre),
                subtitle: Text(
                    "Compra: \$${producto.precioCompra} - Venta: \$${producto.precioVenta} - Cantidad: ${producto.cantidad}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.indigo),
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
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await widget.db.delete(widget.db.productos).delete(producto);
                        // No es necesario setState, StreamBuilder se actualiza solo
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade700,
        child: const Icon(Icons.add),
        onPressed: () async {
          // Navegar a la página de agregar producto pasando la misma instancia de DB
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarProductoPage(db: widget.db),
            ),
          );
          setState(() {});
        },
      ),
      bottomNavigationBar: bottomNavBar(
          context,
          currentPage: "Inventario"
      ),
    );
  }
}
