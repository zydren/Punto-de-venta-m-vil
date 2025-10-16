import 'package:flutter/material.dart';
import 'database/database.dart';
import 'agregar_proveedor.dart';
import 'barr.dart';
import 'editar_proveedor.dart';

class Proveedores extends StatefulWidget {
  final AppDatabase db = AppDatabase();

   Proveedores({super.key});

  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proveedores"),
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<Proveedore>>(
        stream: widget.db.select(widget.db.proveedores).watch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final proveedores = snapshot.data ?? [];

          if (proveedores.isEmpty) {
            return const Center(child: Text("No hay proveedores registrados."));
          }

          return ListView.builder(
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              final proveedor = proveedores[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                color: Colors.grey.shade200,
                child: ListTile(
                  title: Text(proveedor.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tel: ${proveedor.numero ?? 'N/A'}"),
                      Text("Correo: ${proveedor.correo ?? 'N/A'}"),
                      Text("Días: ${proveedor.diasServicio ?? 'N/A'}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón Editar
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () async {
                          final actualizado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarProveedorPage(
                                db: widget.db,
                                proveedor: proveedor,
                              ),
                            ),
                          );
                          if (actualizado == true) setState(() {});
                        },
                      ),

                      // Botón Eliminar
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Eliminar proveedor"),
                              content: const Text(
                                  "¿Seguro que deseas eliminar este proveedor?"),
                              actions: [
                                TextButton(
                                  child: const Text("Cancelar"),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text("Eliminar"),
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await widget.db.delete(widget.db.proveedores)
                              ..where((tbl) => tbl.id.equals(proveedor.id))
                              ..go();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade700,
        child: const Icon(Icons.add, color: Colors.white,),
        onPressed: () async {
          final agregado = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AgregarProveedorPage(db: widget.db)),
          );
          if (agregado == true) setState(() {});
        },
      ),
      bottomNavigationBar:
      bottomNavBar(context, currentPage: "Proveedores"),
    );
  }
}
