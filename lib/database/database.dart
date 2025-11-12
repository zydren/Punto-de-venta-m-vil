import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'tables.dart';
export 'tables.dart'; // Exporta las clases de tablas para que otros archivos las puedan usar.
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// --- Clases de datos para las estadísticas (NO son tablas) ---
class MonthlyFinancials {
  final int year;
  final int month;
  final double totalSales;
  final double totalPurchases;

  MonthlyFinancials({
    required this.year,
    required this.month,
    this.totalSales = 0.0,
    this.totalPurchases = 0.0,
  });
}

class SupplierSales {
  final String supplierName;
  final double totalSales;

  SupplierSales({required this.supplierName, required this.totalSales});
}

@DriftDatabase(tables: [Productos, Proveedores, Compras, ComprasDetalles, Ventas, VentasDetalles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
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
            case 2:
              await m.addColumn(productos, productos.codigoBarras);
              await m.addColumn(productos, productos.proveedor);
              await m.createTable(ventas);
              await m.createTable(ventasDetalles);
              break;
            case 3:
              await m.addColumn(ventas, ventas.cancelado);
              break;
          }
        }
      },
    );
  }

  // --- NUEVOS MÉTODOS PARA ESTADÍSTICAS ---

  Future<List<Map<String, dynamic>>> _getMonthlySales() async {
    final year = ventas.fecha.year;
    final month = ventas.fecha.month;
    final total = ventas.total.sum();

    final query = selectOnly(ventas)
      ..where(ventas.cancelado.equals(false) | ventas.cancelado.isNull())
      ..addColumns([year, month, total])
      ..groupBy([year, month]);

    return await query.map((row) => {
      'year': row.read(year)!,
      'month': row.read(month)!,
      'sales': row.read(total) ?? 0.0,
    }).get();
  }

  Future<List<Map<String, dynamic>>> _getMonthlyPurchases() async {
    final year = compras.fecha.year;
    final month = compras.fecha.month;
    final total = compras.total.sum();

    final query = selectOnly(compras)
      ..addColumns([year, month, total])
      ..groupBy([year, month]);

    return await query.map((row) => {
      'year': row.read(year)!,
      'month': row.read(month)!,
      'purchases': row.read(total) ?? 0.0,
    }).get();
  }

  Future<List<MonthlyFinancials>> getMonthlyFinancials() async {
    final salesData = await _getMonthlySales();
    final purchasesData = await _getMonthlyPurchases();

    final Map<String, MonthlyFinancials> financialsMap = {};

    for (var row in salesData) {
      final key = '${row['year']}-${row['month']}';
      financialsMap[key] = MonthlyFinancials(
        year: row['year']!,
        month: row['month']!,
        totalSales: row['sales']!,
      );
    }

    for (var row in purchasesData) {
      final key = '${row['year']}-${row['month']}';
      if (financialsMap.containsKey(key)) {
        final existing = financialsMap[key]!;
        financialsMap[key] = MonthlyFinancials(
          year: existing.year,
          month: existing.month,
          totalSales: existing.totalSales,
          totalPurchases: row['purchases']!,
        );
      } else {
        financialsMap[key] = MonthlyFinancials(
          year: row['year']!,
          month: row['month']!,
          totalPurchases: row['purchases']!,
        );
      }
    }

    final result = financialsMap.values.toList();
    result.sort((a, b) {
      if (a.year != b.year) return b.year.compareTo(a.year);
      return b.month.compareTo(a.month);
    });

    return result;
  }

  Future<List<SupplierSales>> getTopSuppliers() async {
    final vd = ventasDetalles;
    final p = productos;
    final v = ventas;

    final query = selectOnly(vd).join([
      innerJoin(p, p.id.equalsExp(vd.productoId)),
      innerJoin(v, v.id.equalsExp(vd.ventaId)),
    ]);

    final supplierName = p.proveedor;
    const totalRevenue = CustomExpression<double>('SUM(ventas_detalles.cantidad * ventas_detalles.precio_venta)');

    query
        ..addColumns([supplierName, totalRevenue])
        // --- CORRECCIÓN FINAL: Se usa el operador & para combinar condiciones AND ---
        ..where(p.proveedor.isNotNull() & (v.cancelado.equals(false) | v.cancelado.isNull()))
        ..groupBy([supplierName])
        ..orderBy([OrderingTerm.desc(totalRevenue)])
        ..limit(5);

    return await query.map((row) {
      return SupplierSales(
        supplierName: row.read(supplierName)!,
        totalSales: row.read(totalRevenue) ?? 0.0,
      );
    }).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
