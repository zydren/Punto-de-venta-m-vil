import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'tables.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Productos, Proveedores, Compras, ComprasDetalle])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // 👈 DEBES AÑADIR ESTO
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        // Crea todas las tablas si no existen (ejecutado solo en la v1)
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Lógica para actualizar de una versión a otra (ejecutado cuando from < to)
        if (from == 1) {
          // Si vienes de la versión 1, crea las tablas que faltaban (si aplicara)
          // O, si modificaste una tabla existente (ej: Productos), usa ALTER TABLE

          // Por ejemplo, si en la versión 1 Productos NO tenía 'codigoBarras' y 'proveedor',
          // debes agregar esas columnas aquí:
          await m.addColumn(productos, productos.codigoBarras);
          await m.addColumn(productos, productos.proveedor);

          // Si creaste Compras o ComprasDetalle en la v2:
          // await m.createTable(compras);
          // await m.createTable(comprasDetalle);
        }
      },
    );
  }
// ------------------------------------
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
