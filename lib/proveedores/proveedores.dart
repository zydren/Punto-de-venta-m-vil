import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import 'agregar_proveedor.dart';
import '../barr.dart';
import 'editar_proveedor.dart';

// --- ENUM para las opciones de ordenamiento ---
enum ProveedorSorting { porNombre, porMasProductos }

// --- Clase auxiliar para combinar datos de la BD ---
class ProveedorConConteo {
  final Proveedore proveedor;
  final int totalProductos;
  ProveedorConConteo({required this.proveedor, required this.totalProductos});
}

class Proveedores extends StatefulWidget {
  final AppDatabase db = AppDatabase();

  Proveedores({super.key});

  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
  late Future<List<ProveedorConConteo>> _proveedoresFuture;
  ProveedorSorting _currentSorting = ProveedorSorting.porNombre;
  List<String> _selectedDays = [];

  @override
  void initState() {
    super.initState();
    _proveedoresFuture = _fetchProveedores();
  }

  void _refreshProveedores() {
    setState(() {
      _proveedoresFuture = _fetchProveedores();
    });
  }

  Future<List<ProveedorConConteo>> _fetchProveedores() async {
    final db = widget.db;
    final cantidadProductos = db.productos.id.count();

    final query = db.select(db.proveedores).join([
      drift.leftOuterJoin(
        db.productos,
        db.productos.proveedor.equalsExp(db.proveedores.nombre),
      )
    ]);

    if (_selectedDays.isNotEmpty) {
      final conditions = _selectedDays.map((day) => db.proveedores.diasServicio.like('%$day%'));
      query.where(conditions.reduce((a, b) => a | b));
    }

    switch (_currentSorting) {
      case ProveedorSorting.porMasProductos:
        query.orderBy([drift.OrderingTerm(expression: cantidadProductos, mode: drift.OrderingMode.desc)]);
        break;
      case ProveedorSorting.porNombre:
      default:
        query.orderBy([drift.OrderingTerm(expression: db.proveedores.nombre)]);
        break;
    }

    query.addColumns([cantidadProductos]);
    query.groupBy([db.proveedores.id]);

    final result = await query.get();

    return result.map((row) {
      return ProveedorConConteo(
        proveedor: row.readTable(db.proveedores),
        totalProductos: row.read(cantidadProductos) ?? 0,
      );
    }).toList();
  }

  Future<void> _showDaysFilterDialog() async {
    final daysOfWeek = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    List<String> tempSelectedDays = List.from(_selectedDays);

    final result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filtrar por Día de Servicio'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    final day = daysOfWeek[index];
                    return CheckboxListTile(
                      title: Text(day),
                      value: tempSelectedDays.contains(day),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelectedDays.add(day);
                          } else {
                            tempSelectedDays.remove(day);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancelar')),
                TextButton(
                  onPressed: () => Navigator.pop(context, tempSelectedDays),
                  child: const Text('Aplicar'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedDays = result;
      });
      _refreshProveedores();
    }
  }

  void _onSort(ProveedorSorting sort) {
    setState(() {
      _currentSorting = sort;
    });
    _refreshProveedores();
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
        title: const Text('Proveedores', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
        automaticallyImplyLeading: false,
        // --- AÑADIDO: Línea divisoria ---
        shape: const Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: .5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.black87),
            tooltip: 'Filtrar por día de servicio',
            onPressed: _showDaysFilterDialog,
          ),
          PopupMenuButton<ProveedorSorting>(
            onSelected: _onSort,
            icon: const Icon(Icons.sort, color: Colors.black87),
            tooltip: "Ordenar por",
            itemBuilder: (context) => [
              const PopupMenuItem(value: ProveedorSorting.porNombre, child: Text("Ordenar por nombre")),
              const PopupMenuItem(value: ProveedorSorting.porMasProductos, child: Text("Con más productos")),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87, size: 28),
            tooltip: 'Agregar Proveedor',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarProveedorPage(db: widget.db)),
              ).then((_) => _refreshProveedores());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedDays.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _selectedDays.map((day) {
                  return Chip(
                    label: Text(day, style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.indigo.shade400,
                    onDeleted: () {
                      setState(() {
                        _selectedDays.remove(day);
                      });
                      _refreshProveedores();
                    },
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<ProveedorConConteo>>(
              future: _proveedoresFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error al cargar proveedores: ${snapshot.error}"));
                }
                final proveedores = snapshot.data ?? [];
                if (proveedores.isEmpty) {
                  return const Center(child: Text("No se encontraron proveedores con los filtros seleccionados."));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: proveedores.length,
                  itemBuilder: (context, index) {
                    final proveedorConConteo = proveedores[index];
                    final proveedor = proveedorConConteo.proveedor;
                    final totalProductos = proveedorConConteo.totalProductos;

                    return Card(
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        title: Text(proveedor.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            (totalProductos == 1 ? "1 producto" : "$totalProductos productos") + 
                            (proveedor.diasServicio != null && proveedor.diasServicio!.isNotEmpty ? " | Días: ${proveedor.diasServicio}" : ""),
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const SizedBox(height: 8),
                                _buildDetailRow(Icons.phone_outlined, "Teléfono", proveedor.numero ?? 'N/A'),
                                _buildDetailRow(Icons.email_outlined, "Correo", proveedor.correo ?? 'N/A'),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                                      label: const Text('Editar', style: TextStyle(color: Colors.blueAccent)),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => EditarProveedorPage(db: widget.db, proveedor: proveedor)),
                                        );
                                        _refreshProveedores();
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                      label: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Eliminar proveedor"),
                                            content: Text('¿Seguro que deseas eliminar a "${proveedor.nombre}"? Esto no se puede deshacer.'),
                                            actions: [
                                              TextButton(child: const Text("Cancelar"), onPressed: () => Navigator.pop(context, false)),
                                              TextButton(child: const Text("Eliminar", style: TextStyle(color: Colors.red)), onPressed: () => Navigator.pop(context, true)),
                                            ],
                                          ),
                                        );
                                        if (confirm == true) {
                                          await (widget.db.delete(widget.db.proveedores)..where((tbl) => tbl.id.equals(proveedor.id))).go();
                                          _refreshProveedores();
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
      bottomNavigationBar: bottomNavBar(context, currentPage: "Proveedores"),
    );
  }
}
