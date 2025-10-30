import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'tables.dart';
export 'tables.dart'; // Exporta las clases de tablas para que otros archivos las puedan usar.
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// Se registran las nuevas tablas
@DriftDatabase(tables: [Productos, Proveedores, Compras, ComprasDetalles, Ventas, VentasDetalles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  // Se incrementa la versión del esquema a 3
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },

      onUpgrade: (Migrator m, int from, int to) async {
          for (var version = from + 1; version <= to; version++) {
            switch (version) {
              case 2: // Migración de v1 a v2
                await m.addColumn(productos, productos.codigoBarras);
                await m.addColumn(productos, productos.proveedor);
                await m.createTable(ventas);
                await m.createTable(ventasDetalles);
                break;
              case 3: // Migración de v2 a v3
                await m.addColumn(ventas, ventas.cancelado);
                break;
            }
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
