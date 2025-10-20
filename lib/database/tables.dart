import 'package:drift/drift.dart';

// --------- Tabla Productos ---------
class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 50)();
  RealColumn get precioCompra => real()();
  RealColumn get precioVenta => real()();
  IntColumn get cantidad => integer().withDefault(const Constant(0))();
  TextColumn get codigoBarras => text().nullable()();
  TextColumn get proveedor => text().nullable()();
}


//-------------Tabla Proveedores-------------------------

class Proveedores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get diasServicio => text()(); // Usamos JSON
  TextColumn get numero => text()();
  TextColumn get correo => text()();
}

// --------- Tabla Compras (Encabezado) ---------
class Compras extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get proveedor => text().nullable()();
  RealColumn get total => real().withDefault(const Constant(0.0))();
}

// --------- Tabla ComprasDetalles (Productos por compra) ---------
class ComprasDetalles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get compraId => integer().references(Compras, #id)();
  IntColumn get productoId => integer().references(Productos, #id)();
  IntColumn get cantidad => integer()();
  RealColumn get precioCompra => real()();
}
