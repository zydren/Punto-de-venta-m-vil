import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'tables.dart';
export 'tables.dart'; // Exporta las clases de tablas para que otros archivos las puedan usar. No es obligatorio pero mejor no lo toquen.
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Productos, Proveedores, Compras, ComprasDetalles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          await m.addColumn(productos, productos.codigoBarras);
          await m.addColumn(productos, productos.proveedor);

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
