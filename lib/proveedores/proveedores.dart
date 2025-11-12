import 'package:flutter/material.dart';
import '../database/database.dart';
import 'agregar_proveedor.dart';
import '../barr.dart';
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
    final Color primaryColor = Colors.indigo.shade700;
    final Color backgroundColor = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          'Proveedores',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
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
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              final proveedor = proveedores[index];
              return Card(
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  title: Text(proveedor.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text("Tel: ${proveedor.numero ?? 'N/A'}"),
                      Text("Correo: ${proveedor.correo ?? 'N/A'}"),
                      Text("Días de servicio: ${proveedor.diasServicio ?? 'N/A'}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarProveedorPage(
                                db: widget.db,
                                proveedor: proveedor,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Eliminar proveedor"),
                              content: Text(
                                  '¿Seguro que deseas eliminar a "${proveedor.nombre}"?'),
                              actions: [
                                TextButton(
                                  child: const Text("Cancelar"),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                TextButton(
                                  child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await (widget.db.delete(widget.db.proveedores)..where((tbl) => tbl.id.equals(proveedor.id))).go();
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
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AgregarProveedorPage(db: widget.db)),
          );
        },
      ),
      bottomNavigationBar:
      bottomNavBar(context, currentPage: "Proveedores"),
    );
  }
}
