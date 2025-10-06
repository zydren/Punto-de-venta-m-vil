import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables.dart';

part 'database.g.dart'; // Drift genera este archivo

// Base de datos que incluye la tabla Productos
@DriftDatabase(tables: [Productos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

// Conexión con SQLite en el dispositivo
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}


// Metodos para ABC

extension ProductosDao on AppDatabase {
  Future<int> insertarProducto(ProductosCompanion producto) =>
      into(productos).insert(producto);

  Future<List<Producto>> obtenerProductos() =>
      select(productos).get();

  Future<int> borrarProducto(int id) =>
      (delete(productos)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> actualizarCantidad(int id, int nuevaCantidad) {
    return (update(productos)..where((tbl) => tbl.id.equals(id)))
        .write(ProductosCompanion(cantidad: Value(nuevaCantidad)));
  }
}
