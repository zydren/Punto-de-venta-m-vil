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


/*
  Provedores,
    nombre
    Dias de servicio
    telefono,
    correo
*/