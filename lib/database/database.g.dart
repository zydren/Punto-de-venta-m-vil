// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProductosTable extends Productos
    with TableInfo<$ProductosTable, Producto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioCompraMeta = const VerificationMeta(
    'precioCompra',
  );
  @override
  late final GeneratedColumn<double> precioCompra = GeneratedColumn<double>(
    'precio_compra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioVentaMeta = const VerificationMeta(
    'precioVenta',
  );
  @override
  late final GeneratedColumn<double> precioVenta = GeneratedColumn<double>(
    'precio_venta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _codigoBarrasMeta = const VerificationMeta(
    'codigoBarras',
  );
  @override
  late final GeneratedColumn<String> codigoBarras = GeneratedColumn<String>(
    'codigo_barras',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proveedorMeta = const VerificationMeta(
    'proveedor',
  );
  @override
  late final GeneratedColumn<String> proveedor = GeneratedColumn<String>(
    'proveedor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    precioCompra,
    precioVenta,
    cantidad,
    codigoBarras,
    proveedor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Producto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('precio_compra')) {
      context.handle(
        _precioCompraMeta,
        precioCompra.isAcceptableOrUnknown(
          data['precio_compra']!,
          _precioCompraMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioCompraMeta);
    }
    if (data.containsKey('precio_venta')) {
      context.handle(
        _precioVentaMeta,
        precioVenta.isAcceptableOrUnknown(
          data['precio_venta']!,
          _precioVentaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioVentaMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    }
    if (data.containsKey('codigo_barras')) {
      context.handle(
        _codigoBarrasMeta,
        codigoBarras.isAcceptableOrUnknown(
          data['codigo_barras']!,
          _codigoBarrasMeta,
        ),
      );
    }
    if (data.containsKey('proveedor')) {
      context.handle(
        _proveedorMeta,
        proveedor.isAcceptableOrUnknown(data['proveedor']!, _proveedorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Producto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Producto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      precioCompra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_compra'],
      )!,
      precioVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_venta'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      codigoBarras: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_barras'],
      ),
      proveedor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor'],
      ),
    );
  }

  @override
  $ProductosTable createAlias(String alias) {
    return $ProductosTable(attachedDatabase, alias);
  }
}

class Producto extends DataClass implements Insertable<Producto> {
  final int id;
  final String nombre;
  final double precioCompra;
  final double precioVenta;
  final int cantidad;
  final String? codigoBarras;
  final String? proveedor;
  const Producto({
    required this.id,
    required this.nombre,
    required this.precioCompra,
    required this.precioVenta,
    required this.cantidad,
    this.codigoBarras,
    this.proveedor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['precio_compra'] = Variable<double>(precioCompra);
    map['precio_venta'] = Variable<double>(precioVenta);
    map['cantidad'] = Variable<int>(cantidad);
    if (!nullToAbsent || codigoBarras != null) {
      map['codigo_barras'] = Variable<String>(codigoBarras);
    }
    if (!nullToAbsent || proveedor != null) {
      map['proveedor'] = Variable<String>(proveedor);
    }
    return map;
  }

  ProductosCompanion toCompanion(bool nullToAbsent) {
    return ProductosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      precioCompra: Value(precioCompra),
      precioVenta: Value(precioVenta),
      cantidad: Value(cantidad),
      codigoBarras: codigoBarras == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoBarras),
      proveedor: proveedor == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedor),
    );
  }

  factory Producto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Producto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      precioCompra: serializer.fromJson<double>(json['precioCompra']),
      precioVenta: serializer.fromJson<double>(json['precioVenta']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      codigoBarras: serializer.fromJson<String?>(json['codigoBarras']),
      proveedor: serializer.fromJson<String?>(json['proveedor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'precioCompra': serializer.toJson<double>(precioCompra),
      'precioVenta': serializer.toJson<double>(precioVenta),
      'cantidad': serializer.toJson<int>(cantidad),
      'codigoBarras': serializer.toJson<String?>(codigoBarras),
      'proveedor': serializer.toJson<String?>(proveedor),
    };
  }

  Producto copyWith({
    int? id,
    String? nombre,
    double? precioCompra,
    double? precioVenta,
    int? cantidad,
    Value<String?> codigoBarras = const Value.absent(),
    Value<String?> proveedor = const Value.absent(),
  }) => Producto(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    precioCompra: precioCompra ?? this.precioCompra,
    precioVenta: precioVenta ?? this.precioVenta,
    cantidad: cantidad ?? this.cantidad,
    codigoBarras: codigoBarras.present ? codigoBarras.value : this.codigoBarras,
    proveedor: proveedor.present ? proveedor.value : this.proveedor,
  );
  Producto copyWithCompanion(ProductosCompanion data) {
    return Producto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      precioCompra: data.precioCompra.present
          ? data.precioCompra.value
          : this.precioCompra,
      precioVenta: data.precioVenta.present
          ? data.precioVenta.value
          : this.precioVenta,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      codigoBarras: data.codigoBarras.present
          ? data.codigoBarras.value
          : this.codigoBarras,
      proveedor: data.proveedor.present ? data.proveedor.value : this.proveedor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Producto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('precioCompra: $precioCompra, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('cantidad: $cantidad, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('proveedor: $proveedor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    precioCompra,
    precioVenta,
    cantidad,
    codigoBarras,
    proveedor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Producto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.precioCompra == this.precioCompra &&
          other.precioVenta == this.precioVenta &&
          other.cantidad == this.cantidad &&
          other.codigoBarras == this.codigoBarras &&
          other.proveedor == this.proveedor);
}

class ProductosCompanion extends UpdateCompanion<Producto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<double> precioCompra;
  final Value<double> precioVenta;
  final Value<int> cantidad;
  final Value<String?> codigoBarras;
  final Value<String?> proveedor;
  const ProductosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.precioCompra = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.proveedor = const Value.absent(),
  });
  ProductosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required double precioCompra,
    required double precioVenta,
    this.cantidad = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.proveedor = const Value.absent(),
  }) : nombre = Value(nombre),
       precioCompra = Value(precioCompra),
       precioVenta = Value(precioVenta);
  static Insertable<Producto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<double>? precioCompra,
    Expression<double>? precioVenta,
    Expression<int>? cantidad,
    Expression<String>? codigoBarras,
    Expression<String>? proveedor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (precioCompra != null) 'precio_compra': precioCompra,
      if (precioVenta != null) 'precio_venta': precioVenta,
      if (cantidad != null) 'cantidad': cantidad,
      if (codigoBarras != null) 'codigo_barras': codigoBarras,
      if (proveedor != null) 'proveedor': proveedor,
    });
  }

  ProductosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<double>? precioCompra,
    Value<double>? precioVenta,
    Value<int>? cantidad,
    Value<String?>? codigoBarras,
    Value<String?>? proveedor,
  }) {
    return ProductosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precioCompra: precioCompra ?? this.precioCompra,
      precioVenta: precioVenta ?? this.precioVenta,
      cantidad: cantidad ?? this.cantidad,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      proveedor: proveedor ?? this.proveedor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (precioCompra.present) {
      map['precio_compra'] = Variable<double>(precioCompra.value);
    }
    if (precioVenta.present) {
      map['precio_venta'] = Variable<double>(precioVenta.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (codigoBarras.present) {
      map['codigo_barras'] = Variable<String>(codigoBarras.value);
    }
    if (proveedor.present) {
      map['proveedor'] = Variable<String>(proveedor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('precioCompra: $precioCompra, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('cantidad: $cantidad, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('proveedor: $proveedor')
          ..write(')'))
        .toString();
  }
}

class $ProveedoresTable extends Proveedores
    with TableInfo<$ProveedoresTable, Proveedore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProveedoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diasServicioMeta = const VerificationMeta(
    'diasServicio',
  );
  @override
  late final GeneratedColumn<String> diasServicio = GeneratedColumn<String>(
    'dias_servicio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correoMeta = const VerificationMeta('correo');
  @override
  late final GeneratedColumn<String> correo = GeneratedColumn<String>(
    'correo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    diasServicio,
    numero,
    correo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proveedores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Proveedore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('dias_servicio')) {
      context.handle(
        _diasServicioMeta,
        diasServicio.isAcceptableOrUnknown(
          data['dias_servicio']!,
          _diasServicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diasServicioMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('correo')) {
      context.handle(
        _correoMeta,
        correo.isAcceptableOrUnknown(data['correo']!, _correoMeta),
      );
    } else if (isInserting) {
      context.missing(_correoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Proveedore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Proveedore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      diasServicio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dias_servicio'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero'],
      )!,
      correo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correo'],
      )!,
    );
  }

  @override
  $ProveedoresTable createAlias(String alias) {
    return $ProveedoresTable(attachedDatabase, alias);
  }
}

class Proveedore extends DataClass implements Insertable<Proveedore> {
  final int id;
  final String nombre;
  final String diasServicio;
  final String numero;
  final String correo;
  const Proveedore({
    required this.id,
    required this.nombre,
    required this.diasServicio,
    required this.numero,
    required this.correo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['dias_servicio'] = Variable<String>(diasServicio);
    map['numero'] = Variable<String>(numero);
    map['correo'] = Variable<String>(correo);
    return map;
  }

  ProveedoresCompanion toCompanion(bool nullToAbsent) {
    return ProveedoresCompanion(
      id: Value(id),
      nombre: Value(nombre),
      diasServicio: Value(diasServicio),
      numero: Value(numero),
      correo: Value(correo),
    );
  }

  factory Proveedore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Proveedore(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      diasServicio: serializer.fromJson<String>(json['diasServicio']),
      numero: serializer.fromJson<String>(json['numero']),
      correo: serializer.fromJson<String>(json['correo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'diasServicio': serializer.toJson<String>(diasServicio),
      'numero': serializer.toJson<String>(numero),
      'correo': serializer.toJson<String>(correo),
    };
  }

  Proveedore copyWith({
    int? id,
    String? nombre,
    String? diasServicio,
    String? numero,
    String? correo,
  }) => Proveedore(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    diasServicio: diasServicio ?? this.diasServicio,
    numero: numero ?? this.numero,
    correo: correo ?? this.correo,
  );
  Proveedore copyWithCompanion(ProveedoresCompanion data) {
    return Proveedore(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      diasServicio: data.diasServicio.present
          ? data.diasServicio.value
          : this.diasServicio,
      numero: data.numero.present ? data.numero.value : this.numero,
      correo: data.correo.present ? data.correo.value : this.correo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Proveedore(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('diasServicio: $diasServicio, ')
          ..write('numero: $numero, ')
          ..write('correo: $correo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, diasServicio, numero, correo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Proveedore &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.diasServicio == this.diasServicio &&
          other.numero == this.numero &&
          other.correo == this.correo);
}

class ProveedoresCompanion extends UpdateCompanion<Proveedore> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> diasServicio;
  final Value<String> numero;
  final Value<String> correo;
  const ProveedoresCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.diasServicio = const Value.absent(),
    this.numero = const Value.absent(),
    this.correo = const Value.absent(),
  });
  ProveedoresCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String diasServicio,
    required String numero,
    required String correo,
  }) : nombre = Value(nombre),
       diasServicio = Value(diasServicio),
       numero = Value(numero),
       correo = Value(correo);
  static Insertable<Proveedore> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? diasServicio,
    Expression<String>? numero,
    Expression<String>? correo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (diasServicio != null) 'dias_servicio': diasServicio,
      if (numero != null) 'numero': numero,
      if (correo != null) 'correo': correo,
    });
  }

  ProveedoresCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? diasServicio,
    Value<String>? numero,
    Value<String>? correo,
  }) {
    return ProveedoresCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      diasServicio: diasServicio ?? this.diasServicio,
      numero: numero ?? this.numero,
      correo: correo ?? this.correo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (diasServicio.present) {
      map['dias_servicio'] = Variable<String>(diasServicio.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (correo.present) {
      map['correo'] = Variable<String>(correo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProveedoresCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('diasServicio: $diasServicio, ')
          ..write('numero: $numero, ')
          ..write('correo: $correo')
          ..write(')'))
        .toString();
  }
}

class $ComprasTable extends Compras with TableInfo<$ComprasTable, Compra> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComprasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _proveedorMeta = const VerificationMeta(
    'proveedor',
  );
  @override
  late final GeneratedColumn<String> proveedor = GeneratedColumn<String>(
    'proveedor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, fecha, proveedor, total];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compras';
  @override
  VerificationContext validateIntegrity(
    Insertable<Compra> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('proveedor')) {
      context.handle(
        _proveedorMeta,
        proveedor.isAcceptableOrUnknown(data['proveedor']!, _proveedorMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Compra map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Compra(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      proveedor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proveedor'],
      ),
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
    );
  }

  @override
  $ComprasTable createAlias(String alias) {
    return $ComprasTable(attachedDatabase, alias);
  }
}

class Compra extends DataClass implements Insertable<Compra> {
  final int id;
  final DateTime fecha;
  final String? proveedor;
  final double total;
  const Compra({
    required this.id,
    required this.fecha,
    this.proveedor,
    required this.total,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || proveedor != null) {
      map['proveedor'] = Variable<String>(proveedor);
    }
    map['total'] = Variable<double>(total);
    return map;
  }

  ComprasCompanion toCompanion(bool nullToAbsent) {
    return ComprasCompanion(
      id: Value(id),
      fecha: Value(fecha),
      proveedor: proveedor == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedor),
      total: Value(total),
    );
  }

  factory Compra.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Compra(
      id: serializer.fromJson<int>(json['id']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      proveedor: serializer.fromJson<String?>(json['proveedor']),
      total: serializer.fromJson<double>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fecha': serializer.toJson<DateTime>(fecha),
      'proveedor': serializer.toJson<String?>(proveedor),
      'total': serializer.toJson<double>(total),
    };
  }

  Compra copyWith({
    int? id,
    DateTime? fecha,
    Value<String?> proveedor = const Value.absent(),
    double? total,
  }) => Compra(
    id: id ?? this.id,
    fecha: fecha ?? this.fecha,
    proveedor: proveedor.present ? proveedor.value : this.proveedor,
    total: total ?? this.total,
  );
  Compra copyWithCompanion(ComprasCompanion data) {
    return Compra(
      id: data.id.present ? data.id.value : this.id,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      proveedor: data.proveedor.present ? data.proveedor.value : this.proveedor,
      total: data.total.present ? data.total.value : this.total,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Compra(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('proveedor: $proveedor, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fecha, proveedor, total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Compra &&
          other.id == this.id &&
          other.fecha == this.fecha &&
          other.proveedor == this.proveedor &&
          other.total == this.total);
}

class ComprasCompanion extends UpdateCompanion<Compra> {
  final Value<int> id;
  final Value<DateTime> fecha;
  final Value<String?> proveedor;
  final Value<double> total;
  const ComprasCompanion({
    this.id = const Value.absent(),
    this.fecha = const Value.absent(),
    this.proveedor = const Value.absent(),
    this.total = const Value.absent(),
  });
  ComprasCompanion.insert({
    this.id = const Value.absent(),
    this.fecha = const Value.absent(),
    this.proveedor = const Value.absent(),
    this.total = const Value.absent(),
  });
  static Insertable<Compra> custom({
    Expression<int>? id,
    Expression<DateTime>? fecha,
    Expression<String>? proveedor,
    Expression<double>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fecha != null) 'fecha': fecha,
      if (proveedor != null) 'proveedor': proveedor,
      if (total != null) 'total': total,
    });
  }

  ComprasCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? fecha,
    Value<String?>? proveedor,
    Value<double>? total,
  }) {
    return ComprasCompanion(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      proveedor: proveedor ?? this.proveedor,
      total: total ?? this.total,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (proveedor.present) {
      map['proveedor'] = Variable<String>(proveedor.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComprasCompanion(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('proveedor: $proveedor, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

class $ComprasDetallesTable extends ComprasDetalles
    with TableInfo<$ComprasDetallesTable, ComprasDetalle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComprasDetallesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _compraIdMeta = const VerificationMeta(
    'compraId',
  );
  @override
  late final GeneratedColumn<int> compraId = GeneratedColumn<int>(
    'compra_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES compras (id)',
    ),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioCompraMeta = const VerificationMeta(
    'precioCompra',
  );
  @override
  late final GeneratedColumn<double> precioCompra = GeneratedColumn<double>(
    'precio_compra',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    compraId,
    productoId,
    cantidad,
    precioCompra,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compras_detalles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComprasDetalle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('compra_id')) {
      context.handle(
        _compraIdMeta,
        compraId.isAcceptableOrUnknown(data['compra_id']!, _compraIdMeta),
      );
    } else if (isInserting) {
      context.missing(_compraIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_compra')) {
      context.handle(
        _precioCompraMeta,
        precioCompra.isAcceptableOrUnknown(
          data['precio_compra']!,
          _precioCompraMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioCompraMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComprasDetalle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComprasDetalle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      compraId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}compra_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioCompra: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_compra'],
      )!,
    );
  }

  @override
  $ComprasDetallesTable createAlias(String alias) {
    return $ComprasDetallesTable(attachedDatabase, alias);
  }
}

class ComprasDetalle extends DataClass implements Insertable<ComprasDetalle> {
  final int id;
  final int compraId;
  final int productoId;
  final int cantidad;
  final double precioCompra;
  const ComprasDetalle({
    required this.id,
    required this.compraId,
    required this.productoId,
    required this.cantidad,
    required this.precioCompra,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['compra_id'] = Variable<int>(compraId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_compra'] = Variable<double>(precioCompra);
    return map;
  }

  ComprasDetallesCompanion toCompanion(bool nullToAbsent) {
    return ComprasDetallesCompanion(
      id: Value(id),
      compraId: Value(compraId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      precioCompra: Value(precioCompra),
    );
  }

  factory ComprasDetalle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComprasDetalle(
      id: serializer.fromJson<int>(json['id']),
      compraId: serializer.fromJson<int>(json['compraId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioCompra: serializer.fromJson<double>(json['precioCompra']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'compraId': serializer.toJson<int>(compraId),
      'productoId': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioCompra': serializer.toJson<double>(precioCompra),
    };
  }

  ComprasDetalle copyWith({
    int? id,
    int? compraId,
    int? productoId,
    int? cantidad,
    double? precioCompra,
  }) => ComprasDetalle(
    id: id ?? this.id,
    compraId: compraId ?? this.compraId,
    productoId: productoId ?? this.productoId,
    cantidad: cantidad ?? this.cantidad,
    precioCompra: precioCompra ?? this.precioCompra,
  );
  ComprasDetalle copyWithCompanion(ComprasDetallesCompanion data) {
    return ComprasDetalle(
      id: data.id.present ? data.id.value : this.id,
      compraId: data.compraId.present ? data.compraId.value : this.compraId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioCompra: data.precioCompra.present
          ? data.precioCompra.value
          : this.precioCompra,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComprasDetalle(')
          ..write('id: $id, ')
          ..write('compraId: $compraId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioCompra: $precioCompra')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, compraId, productoId, cantidad, precioCompra);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComprasDetalle &&
          other.id == this.id &&
          other.compraId == this.compraId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.precioCompra == this.precioCompra);
}

class ComprasDetallesCompanion extends UpdateCompanion<ComprasDetalle> {
  final Value<int> id;
  final Value<int> compraId;
  final Value<int> productoId;
  final Value<int> cantidad;
  final Value<double> precioCompra;
  const ComprasDetallesCompanion({
    this.id = const Value.absent(),
    this.compraId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioCompra = const Value.absent(),
  });
  ComprasDetallesCompanion.insert({
    this.id = const Value.absent(),
    required int compraId,
    required int productoId,
    required int cantidad,
    required double precioCompra,
  }) : compraId = Value(compraId),
       productoId = Value(productoId),
       cantidad = Value(cantidad),
       precioCompra = Value(precioCompra);
  static Insertable<ComprasDetalle> custom({
    Expression<int>? id,
    Expression<int>? compraId,
    Expression<int>? productoId,
    Expression<int>? cantidad,
    Expression<double>? precioCompra,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (compraId != null) 'compra_id': compraId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioCompra != null) 'precio_compra': precioCompra,
    });
  }

  ComprasDetallesCompanion copyWith({
    Value<int>? id,
    Value<int>? compraId,
    Value<int>? productoId,
    Value<int>? cantidad,
    Value<double>? precioCompra,
  }) {
    return ComprasDetallesCompanion(
      id: id ?? this.id,
      compraId: compraId ?? this.compraId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioCompra: precioCompra ?? this.precioCompra,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (compraId.present) {
      map['compra_id'] = Variable<int>(compraId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioCompra.present) {
      map['precio_compra'] = Variable<double>(precioCompra.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComprasDetallesCompanion(')
          ..write('id: $id, ')
          ..write('compraId: $compraId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioCompra: $precioCompra')
          ..write(')'))
        .toString();
  }
}

class $VentasTable extends Ventas with TableInfo<$VentasTable, Venta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _canceladoMeta = const VerificationMeta(
    'cancelado',
  );
  @override
  late final GeneratedColumn<bool> cancelado = GeneratedColumn<bool>(
    'cancelado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cancelado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, fecha, total, cancelado];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Venta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('cancelado')) {
      context.handle(
        _canceladoMeta,
        cancelado.isAcceptableOrUnknown(data['cancelado']!, _canceladoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Venta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Venta(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      cancelado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cancelado'],
      )!,
    );
  }

  @override
  $VentasTable createAlias(String alias) {
    return $VentasTable(attachedDatabase, alias);
  }
}

class Venta extends DataClass implements Insertable<Venta> {
  final int id;
  final DateTime fecha;
  final double total;
  final bool cancelado;
  const Venta({
    required this.id,
    required this.fecha,
    required this.total,
    required this.cancelado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha'] = Variable<DateTime>(fecha);
    map['total'] = Variable<double>(total);
    map['cancelado'] = Variable<bool>(cancelado);
    return map;
  }

  VentasCompanion toCompanion(bool nullToAbsent) {
    return VentasCompanion(
      id: Value(id),
      fecha: Value(fecha),
      total: Value(total),
      cancelado: Value(cancelado),
    );
  }

  factory Venta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Venta(
      id: serializer.fromJson<int>(json['id']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      total: serializer.fromJson<double>(json['total']),
      cancelado: serializer.fromJson<bool>(json['cancelado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fecha': serializer.toJson<DateTime>(fecha),
      'total': serializer.toJson<double>(total),
      'cancelado': serializer.toJson<bool>(cancelado),
    };
  }

  Venta copyWith({int? id, DateTime? fecha, double? total, bool? cancelado}) =>
      Venta(
        id: id ?? this.id,
        fecha: fecha ?? this.fecha,
        total: total ?? this.total,
        cancelado: cancelado ?? this.cancelado,
      );
  Venta copyWithCompanion(VentasCompanion data) {
    return Venta(
      id: data.id.present ? data.id.value : this.id,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      total: data.total.present ? data.total.value : this.total,
      cancelado: data.cancelado.present ? data.cancelado.value : this.cancelado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Venta(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('total: $total, ')
          ..write('cancelado: $cancelado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fecha, total, cancelado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Venta &&
          other.id == this.id &&
          other.fecha == this.fecha &&
          other.total == this.total &&
          other.cancelado == this.cancelado);
}

class VentasCompanion extends UpdateCompanion<Venta> {
  final Value<int> id;
  final Value<DateTime> fecha;
  final Value<double> total;
  final Value<bool> cancelado;
  const VentasCompanion({
    this.id = const Value.absent(),
    this.fecha = const Value.absent(),
    this.total = const Value.absent(),
    this.cancelado = const Value.absent(),
  });
  VentasCompanion.insert({
    this.id = const Value.absent(),
    this.fecha = const Value.absent(),
    this.total = const Value.absent(),
    this.cancelado = const Value.absent(),
  });
  static Insertable<Venta> custom({
    Expression<int>? id,
    Expression<DateTime>? fecha,
    Expression<double>? total,
    Expression<bool>? cancelado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fecha != null) 'fecha': fecha,
      if (total != null) 'total': total,
      if (cancelado != null) 'cancelado': cancelado,
    });
  }

  VentasCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? fecha,
    Value<double>? total,
    Value<bool>? cancelado,
  }) {
    return VentasCompanion(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      total: total ?? this.total,
      cancelado: cancelado ?? this.cancelado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (cancelado.present) {
      map['cancelado'] = Variable<bool>(cancelado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasCompanion(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('total: $total, ')
          ..write('cancelado: $cancelado')
          ..write(')'))
        .toString();
  }
}

class $VentasDetallesTable extends VentasDetalles
    with TableInfo<$VentasDetallesTable, VentasDetalle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VentasDetallesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  @override
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ventas (id)',
    ),
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos (id)',
    ),
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioVentaMeta = const VerificationMeta(
    'precioVenta',
  );
  @override
  late final GeneratedColumn<double> precioVenta = GeneratedColumn<double>(
    'precio_venta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    productoId,
    cantidad,
    precioVenta,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ventas_detalles';
  @override
  VerificationContext validateIntegrity(
    Insertable<VentasDetalle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_venta')) {
      context.handle(
        _precioVentaMeta,
        precioVenta.isAcceptableOrUnknown(
          data['precio_venta']!,
          _precioVentaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioVentaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VentasDetalle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VentasDetalle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioVenta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_venta'],
      )!,
    );
  }

  @override
  $VentasDetallesTable createAlias(String alias) {
    return $VentasDetallesTable(attachedDatabase, alias);
  }
}

class VentasDetalle extends DataClass implements Insertable<VentasDetalle> {
  final int id;
  final int ventaId;
  final int productoId;
  final int cantidad;
  final double precioVenta;
  const VentasDetalle({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.precioVenta,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_venta'] = Variable<double>(precioVenta);
    return map;
  }

  VentasDetallesCompanion toCompanion(bool nullToAbsent) {
    return VentasDetallesCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      precioVenta: Value(precioVenta),
    );
  }

  factory VentasDetalle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VentasDetalle(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['ventaId']),
      productoId: serializer.fromJson<int>(json['productoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioVenta: serializer.fromJson<double>(json['precioVenta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ventaId': serializer.toJson<int>(ventaId),
      'productoId': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioVenta': serializer.toJson<double>(precioVenta),
    };
  }

  VentasDetalle copyWith({
    int? id,
    int? ventaId,
    int? productoId,
    int? cantidad,
    double? precioVenta,
  }) => VentasDetalle(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    productoId: productoId ?? this.productoId,
    cantidad: cantidad ?? this.cantidad,
    precioVenta: precioVenta ?? this.precioVenta,
  );
  VentasDetalle copyWithCompanion(VentasDetallesCompanion data) {
    return VentasDetalle(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioVenta: data.precioVenta.present
          ? data.precioVenta.value
          : this.precioVenta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VentasDetalle(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioVenta: $precioVenta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ventaId, productoId, cantidad, precioVenta);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VentasDetalle &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.precioVenta == this.precioVenta);
}

class VentasDetallesCompanion extends UpdateCompanion<VentasDetalle> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<int> productoId;
  final Value<int> cantidad;
  final Value<double> precioVenta;
  const VentasDetallesCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioVenta = const Value.absent(),
  });
  VentasDetallesCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required int productoId,
    required int cantidad,
    required double precioVenta,
  }) : ventaId = Value(ventaId),
       productoId = Value(productoId),
       cantidad = Value(cantidad),
       precioVenta = Value(precioVenta);
  static Insertable<VentasDetalle> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<int>? productoId,
    Expression<int>? cantidad,
    Expression<double>? precioVenta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioVenta != null) 'precio_venta': precioVenta,
    });
  }

  VentasDetallesCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<int>? productoId,
    Value<int>? cantidad,
    Value<double>? precioVenta,
  }) {
    return VentasDetallesCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioVenta: precioVenta ?? this.precioVenta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioVenta.present) {
      map['precio_venta'] = Variable<double>(precioVenta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentasDetallesCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioVenta: $precioVenta')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductosTable productos = $ProductosTable(this);
  late final $ProveedoresTable proveedores = $ProveedoresTable(this);
  late final $ComprasTable compras = $ComprasTable(this);
  late final $ComprasDetallesTable comprasDetalles = $ComprasDetallesTable(
    this,
  );
  late final $VentasTable ventas = $VentasTable(this);
  late final $VentasDetallesTable ventasDetalles = $VentasDetallesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productos,
    proveedores,
    compras,
    comprasDetalles,
    ventas,
    ventasDetalles,
  ];
}

typedef $$ProductosTableCreateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      required String nombre,
      required double precioCompra,
      required double precioVenta,
      Value<int> cantidad,
      Value<String?> codigoBarras,
      Value<String?> proveedor,
    });
typedef $$ProductosTableUpdateCompanionBuilder =
    ProductosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<double> precioCompra,
      Value<double> precioVenta,
      Value<int> cantidad,
      Value<String?> codigoBarras,
      Value<String?> proveedor,
    });

final class $$ProductosTableReferences
    extends BaseReferences<_$AppDatabase, $ProductosTable, Producto> {
  $$ProductosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComprasDetallesTable, List<ComprasDetalle>>
  _comprasDetallesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.comprasDetalles,
    aliasName: $_aliasNameGenerator(
      db.productos.id,
      db.comprasDetalles.productoId,
    ),
  );

  $$ComprasDetallesTableProcessedTableManager get comprasDetallesRefs {
    final manager = $$ComprasDetallesTableTableManager(
      $_db,
      $_db.comprasDetalles,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _comprasDetallesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VentasDetallesTable, List<VentasDetalle>>
  _ventasDetallesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasDetalles,
    aliasName: $_aliasNameGenerator(
      db.productos.id,
      db.ventasDetalles.productoId,
    ),
  );

  $$VentasDetallesTableProcessedTableManager get ventasDetallesRefs {
    final manager = $$VentasDetallesTableTableManager(
      $_db,
      $_db.ventasDetalles,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventasDetallesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductosTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedor => $composableBuilder(
    column: $table.proveedor,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> comprasDetallesRefs(
    Expression<bool> Function($$ComprasDetallesTableFilterComposer f) f,
  ) {
    final $$ComprasDetallesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comprasDetalles,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasDetallesTableFilterComposer(
            $db: $db,
            $table: $db.comprasDetalles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventasDetallesRefs(
    Expression<bool> Function($$VentasDetallesTableFilterComposer f) f,
  ) {
    final $$VentasDetallesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasDetalles,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetallesTableFilterComposer(
            $db: $db,
            $table: $db.ventasDetalles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedor => $composableBuilder(
    column: $table.proveedor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosTable> {
  $$ProductosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => column,
  );

  GeneratedColumn<String> get proveedor =>
      $composableBuilder(column: $table.proveedor, builder: (column) => column);

  Expression<T> comprasDetallesRefs<T extends Object>(
    Expression<T> Function($$ComprasDetallesTableAnnotationComposer a) f,
  ) {
    final $$ComprasDetallesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comprasDetalles,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasDetallesTableAnnotationComposer(
            $db: $db,
            $table: $db.comprasDetalles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ventasDetallesRefs<T extends Object>(
    Expression<T> Function($$VentasDetallesTableAnnotationComposer a) f,
  ) {
    final $$VentasDetallesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasDetalles,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetallesTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasDetalles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosTable,
          Producto,
          $$ProductosTableFilterComposer,
          $$ProductosTableOrderingComposer,
          $$ProductosTableAnnotationComposer,
          $$ProductosTableCreateCompanionBuilder,
          $$ProductosTableUpdateCompanionBuilder,
          (Producto, $$ProductosTableReferences),
          Producto,
          PrefetchHooks Function({
            bool comprasDetallesRefs,
            bool ventasDetallesRefs,
          })
        > {
  $$ProductosTableTableManager(_$AppDatabase db, $ProductosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<double> precioCompra = const Value.absent(),
                Value<double> precioVenta = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> proveedor = const Value.absent(),
              }) => ProductosCompanion(
                id: id,
                nombre: nombre,
                precioCompra: precioCompra,
                precioVenta: precioVenta,
                cantidad: cantidad,
                codigoBarras: codigoBarras,
                proveedor: proveedor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required double precioCompra,
                required double precioVenta,
                Value<int> cantidad = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> proveedor = const Value.absent(),
              }) => ProductosCompanion.insert(
                id: id,
                nombre: nombre,
                precioCompra: precioCompra,
                precioVenta: precioVenta,
                cantidad: cantidad,
                codigoBarras: codigoBarras,
                proveedor: proveedor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({comprasDetallesRefs = false, ventasDetallesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (comprasDetallesRefs) db.comprasDetalles,
                    if (ventasDetallesRefs) db.ventasDetalles,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (comprasDetallesRefs)
                        await $_getPrefetchedData<
                          Producto,
                          $ProductosTable,
                          ComprasDetalle
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._comprasDetallesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).comprasDetallesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ventasDetallesRefs)
                        await $_getPrefetchedData<
                          Producto,
                          $ProductosTable,
                          VentasDetalle
                        >(
                          currentTable: table,
                          referencedTable: $$ProductosTableReferences
                              ._ventasDetallesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductosTableReferences(
                                db,
                                table,
                                p0,
                              ).ventasDetallesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosTable,
      Producto,
      $$ProductosTableFilterComposer,
      $$ProductosTableOrderingComposer,
      $$ProductosTableAnnotationComposer,
      $$ProductosTableCreateCompanionBuilder,
      $$ProductosTableUpdateCompanionBuilder,
      (Producto, $$ProductosTableReferences),
      Producto,
      PrefetchHooks Function({
        bool comprasDetallesRefs,
        bool ventasDetallesRefs,
      })
    >;
typedef $$ProveedoresTableCreateCompanionBuilder =
    ProveedoresCompanion Function({
      Value<int> id,
      required String nombre,
      required String diasServicio,
      required String numero,
      required String correo,
    });
typedef $$ProveedoresTableUpdateCompanionBuilder =
    ProveedoresCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> diasServicio,
      Value<String> numero,
      Value<String> correo,
    });

class $$ProveedoresTableFilterComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diasServicio => $composableBuilder(
    column: $table.diasServicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProveedoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diasServicio => $composableBuilder(
    column: $table.diasServicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correo => $composableBuilder(
    column: $table.correo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProveedoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProveedoresTable> {
  $$ProveedoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get diasServicio => $composableBuilder(
    column: $table.diasServicio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get correo =>
      $composableBuilder(column: $table.correo, builder: (column) => column);
}

class $$ProveedoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProveedoresTable,
          Proveedore,
          $$ProveedoresTableFilterComposer,
          $$ProveedoresTableOrderingComposer,
          $$ProveedoresTableAnnotationComposer,
          $$ProveedoresTableCreateCompanionBuilder,
          $$ProveedoresTableUpdateCompanionBuilder,
          (
            Proveedore,
            BaseReferences<_$AppDatabase, $ProveedoresTable, Proveedore>,
          ),
          Proveedore,
          PrefetchHooks Function()
        > {
  $$ProveedoresTableTableManager(_$AppDatabase db, $ProveedoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProveedoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProveedoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProveedoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> diasServicio = const Value.absent(),
                Value<String> numero = const Value.absent(),
                Value<String> correo = const Value.absent(),
              }) => ProveedoresCompanion(
                id: id,
                nombre: nombre,
                diasServicio: diasServicio,
                numero: numero,
                correo: correo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String diasServicio,
                required String numero,
                required String correo,
              }) => ProveedoresCompanion.insert(
                id: id,
                nombre: nombre,
                diasServicio: diasServicio,
                numero: numero,
                correo: correo,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProveedoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProveedoresTable,
      Proveedore,
      $$ProveedoresTableFilterComposer,
      $$ProveedoresTableOrderingComposer,
      $$ProveedoresTableAnnotationComposer,
      $$ProveedoresTableCreateCompanionBuilder,
      $$ProveedoresTableUpdateCompanionBuilder,
      (
        Proveedore,
        BaseReferences<_$AppDatabase, $ProveedoresTable, Proveedore>,
      ),
      Proveedore,
      PrefetchHooks Function()
    >;
typedef $$ComprasTableCreateCompanionBuilder =
    ComprasCompanion Function({
      Value<int> id,
      Value<DateTime> fecha,
      Value<String?> proveedor,
      Value<double> total,
    });
typedef $$ComprasTableUpdateCompanionBuilder =
    ComprasCompanion Function({
      Value<int> id,
      Value<DateTime> fecha,
      Value<String?> proveedor,
      Value<double> total,
    });

final class $$ComprasTableReferences
    extends BaseReferences<_$AppDatabase, $ComprasTable, Compra> {
  $$ComprasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComprasDetallesTable, List<ComprasDetalle>>
  _comprasDetallesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.comprasDetalles,
    aliasName: $_aliasNameGenerator(db.compras.id, db.comprasDetalles.compraId),
  );

  $$ComprasDetallesTableProcessedTableManager get comprasDetallesRefs {
    final manager = $$ComprasDetallesTableTableManager(
      $_db,
      $_db.comprasDetalles,
    ).filter((f) => f.compraId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _comprasDetallesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ComprasTableFilterComposer
    extends Composer<_$AppDatabase, $ComprasTable> {
  $$ComprasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proveedor => $composableBuilder(
    column: $table.proveedor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> comprasDetallesRefs(
    Expression<bool> Function($$ComprasDetallesTableFilterComposer f) f,
  ) {
    final $$ComprasDetallesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comprasDetalles,
      getReferencedColumn: (t) => t.compraId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasDetallesTableFilterComposer(
            $db: $db,
            $table: $db.comprasDetalles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComprasTableOrderingComposer
    extends Composer<_$AppDatabase, $ComprasTable> {
  $$ComprasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proveedor => $composableBuilder(
    column: $table.proveedor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComprasTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComprasTable> {
  $$ComprasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get proveedor =>
      $composableBuilder(column: $table.proveedor, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  Expression<T> comprasDetallesRefs<T extends Object>(
    Expression<T> Function($$ComprasDetallesTableAnnotationComposer a) f,
  ) {
    final $$ComprasDetallesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comprasDetalles,
      getReferencedColumn: (t) => t.compraId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasDetallesTableAnnotationComposer(
            $db: $db,
            $table: $db.comprasDetalles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComprasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComprasTable,
          Compra,
          $$ComprasTableFilterComposer,
          $$ComprasTableOrderingComposer,
          $$ComprasTableAnnotationComposer,
          $$ComprasTableCreateCompanionBuilder,
          $$ComprasTableUpdateCompanionBuilder,
          (Compra, $$ComprasTableReferences),
          Compra,
          PrefetchHooks Function({bool comprasDetallesRefs})
        > {
  $$ComprasTableTableManager(_$AppDatabase db, $ComprasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComprasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComprasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComprasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> proveedor = const Value.absent(),
                Value<double> total = const Value.absent(),
              }) => ComprasCompanion(
                id: id,
                fecha: fecha,
                proveedor: proveedor,
                total: total,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String?> proveedor = const Value.absent(),
                Value<double> total = const Value.absent(),
              }) => ComprasCompanion.insert(
                id: id,
                fecha: fecha,
                proveedor: proveedor,
                total: total,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ComprasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({comprasDetallesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (comprasDetallesRefs) db.comprasDetalles,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (comprasDetallesRefs)
                    await $_getPrefetchedData<
                      Compra,
                      $ComprasTable,
                      ComprasDetalle
                    >(
                      currentTable: table,
                      referencedTable: $$ComprasTableReferences
                          ._comprasDetallesRefsTable(db),
                      managerFromTypedResult: (p0) => $$ComprasTableReferences(
                        db,
                        table,
                        p0,
                      ).comprasDetallesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.compraId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ComprasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComprasTable,
      Compra,
      $$ComprasTableFilterComposer,
      $$ComprasTableOrderingComposer,
      $$ComprasTableAnnotationComposer,
      $$ComprasTableCreateCompanionBuilder,
      $$ComprasTableUpdateCompanionBuilder,
      (Compra, $$ComprasTableReferences),
      Compra,
      PrefetchHooks Function({bool comprasDetallesRefs})
    >;
typedef $$ComprasDetallesTableCreateCompanionBuilder =
    ComprasDetallesCompanion Function({
      Value<int> id,
      required int compraId,
      required int productoId,
      required int cantidad,
      required double precioCompra,
    });
typedef $$ComprasDetallesTableUpdateCompanionBuilder =
    ComprasDetallesCompanion Function({
      Value<int> id,
      Value<int> compraId,
      Value<int> productoId,
      Value<int> cantidad,
      Value<double> precioCompra,
    });

final class $$ComprasDetallesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ComprasDetallesTable, ComprasDetalle> {
  $$ComprasDetallesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ComprasTable _compraIdTable(_$AppDatabase db) =>
      db.compras.createAlias(
        $_aliasNameGenerator(db.comprasDetalles.compraId, db.compras.id),
      );

  $$ComprasTableProcessedTableManager get compraId {
    final $_column = $_itemColumn<int>('compra_id')!;

    final manager = $$ComprasTableTableManager(
      $_db,
      $_db.compras,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_compraIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductosTable _productoIdTable(_$AppDatabase db) =>
      db.productos.createAlias(
        $_aliasNameGenerator(db.comprasDetalles.productoId, db.productos.id),
      );

  $$ProductosTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ComprasDetallesTableFilterComposer
    extends Composer<_$AppDatabase, $ComprasDetallesTable> {
  $$ComprasDetallesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => ColumnFilters(column),
  );

  $$ComprasTableFilterComposer get compraId {
    final $$ComprasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compraId,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableFilterComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComprasDetallesTableOrderingComposer
    extends Composer<_$AppDatabase, $ComprasDetallesTable> {
  $$ComprasDetallesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => ColumnOrderings(column),
  );

  $$ComprasTableOrderingComposer get compraId {
    final $$ComprasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compraId,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableOrderingComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComprasDetallesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComprasDetallesTable> {
  $$ComprasDetallesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioCompra => $composableBuilder(
    column: $table.precioCompra,
    builder: (column) => column,
  );

  $$ComprasTableAnnotationComposer get compraId {
    final $$ComprasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compraId,
      referencedTable: $db.compras,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComprasTableAnnotationComposer(
            $db: $db,
            $table: $db.compras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComprasDetallesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComprasDetallesTable,
          ComprasDetalle,
          $$ComprasDetallesTableFilterComposer,
          $$ComprasDetallesTableOrderingComposer,
          $$ComprasDetallesTableAnnotationComposer,
          $$ComprasDetallesTableCreateCompanionBuilder,
          $$ComprasDetallesTableUpdateCompanionBuilder,
          (ComprasDetalle, $$ComprasDetallesTableReferences),
          ComprasDetalle,
          PrefetchHooks Function({bool compraId, bool productoId})
        > {
  $$ComprasDetallesTableTableManager(
    _$AppDatabase db,
    $ComprasDetallesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComprasDetallesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComprasDetallesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComprasDetallesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> compraId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioCompra = const Value.absent(),
              }) => ComprasDetallesCompanion(
                id: id,
                compraId: compraId,
                productoId: productoId,
                cantidad: cantidad,
                precioCompra: precioCompra,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int compraId,
                required int productoId,
                required int cantidad,
                required double precioCompra,
              }) => ComprasDetallesCompanion.insert(
                id: id,
                compraId: compraId,
                productoId: productoId,
                cantidad: cantidad,
                precioCompra: precioCompra,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ComprasDetallesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({compraId = false, productoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (compraId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.compraId,
                                referencedTable:
                                    $$ComprasDetallesTableReferences
                                        ._compraIdTable(db),
                                referencedColumn:
                                    $$ComprasDetallesTableReferences
                                        ._compraIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productoId,
                                referencedTable:
                                    $$ComprasDetallesTableReferences
                                        ._productoIdTable(db),
                                referencedColumn:
                                    $$ComprasDetallesTableReferences
                                        ._productoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ComprasDetallesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComprasDetallesTable,
      ComprasDetalle,
      $$ComprasDetallesTableFilterComposer,
      $$ComprasDetallesTableOrderingComposer,
      $$ComprasDetallesTableAnnotationComposer,
      $$ComprasDetallesTableCreateCompanionBuilder,
      $$ComprasDetallesTableUpdateCompanionBuilder,
      (ComprasDetalle, $$ComprasDetallesTableReferences),
      ComprasDetalle,
      PrefetchHooks Function({bool compraId, bool productoId})
    >;
typedef $$VentasTableCreateCompanionBuilder =
    VentasCompanion Function({
      Value<int> id,
      Value<DateTime> fecha,
      Value<double> total,
      Value<bool> cancelado,
    });
typedef $$VentasTableUpdateCompanionBuilder =
    VentasCompanion Function({
      Value<int> id,
      Value<DateTime> fecha,
      Value<double> total,
      Value<bool> cancelado,
    });

final class $$VentasTableReferences
    extends BaseReferences<_$AppDatabase, $VentasTable, Venta> {
  $$VentasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VentasDetallesTable, List<VentasDetalle>>
  _ventasDetallesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ventasDetalles,
    aliasName: $_aliasNameGenerator(db.ventas.id, db.ventasDetalles.ventaId),
  );

  $$VentasDetallesTableProcessedTableManager get ventasDetallesRefs {
    final manager = $$VentasDetallesTableTableManager(
      $_db,
      $_db.ventasDetalles,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventasDetallesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VentasTableFilterComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cancelado => $composableBuilder(
    column: $table.cancelado,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ventasDetallesRefs(
    Expression<bool> Function($$VentasDetallesTableFilterComposer f) f,
  ) {
    final $$VentasDetallesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasDetalles,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetallesTableFilterComposer(
            $db: $db,
            $table: $db.ventasDetalles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cancelado => $composableBuilder(
    column: $table.cancelado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VentasTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasTable> {
  $$VentasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<bool> get cancelado =>
      $composableBuilder(column: $table.cancelado, builder: (column) => column);

  Expression<T> ventasDetallesRefs<T extends Object>(
    Expression<T> Function($$VentasDetallesTableAnnotationComposer a) f,
  ) {
    final $$VentasDetallesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ventasDetalles,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasDetallesTableAnnotationComposer(
            $db: $db,
            $table: $db.ventasDetalles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VentasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasTable,
          Venta,
          $$VentasTableFilterComposer,
          $$VentasTableOrderingComposer,
          $$VentasTableAnnotationComposer,
          $$VentasTableCreateCompanionBuilder,
          $$VentasTableUpdateCompanionBuilder,
          (Venta, $$VentasTableReferences),
          Venta,
          PrefetchHooks Function({bool ventasDetallesRefs})
        > {
  $$VentasTableTableManager(_$AppDatabase db, $VentasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<bool> cancelado = const Value.absent(),
              }) => VentasCompanion(
                id: id,
                fecha: fecha,
                total: total,
                cancelado: cancelado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<bool> cancelado = const Value.absent(),
              }) => VentasCompanion.insert(
                id: id,
                fecha: fecha,
                total: total,
                cancelado: cancelado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VentasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({ventasDetallesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ventasDetallesRefs) db.ventasDetalles,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ventasDetallesRefs)
                    await $_getPrefetchedData<
                      Venta,
                      $VentasTable,
                      VentasDetalle
                    >(
                      currentTable: table,
                      referencedTable: $$VentasTableReferences
                          ._ventasDetallesRefsTable(db),
                      managerFromTypedResult: (p0) => $$VentasTableReferences(
                        db,
                        table,
                        p0,
                      ).ventasDetallesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ventaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VentasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasTable,
      Venta,
      $$VentasTableFilterComposer,
      $$VentasTableOrderingComposer,
      $$VentasTableAnnotationComposer,
      $$VentasTableCreateCompanionBuilder,
      $$VentasTableUpdateCompanionBuilder,
      (Venta, $$VentasTableReferences),
      Venta,
      PrefetchHooks Function({bool ventasDetallesRefs})
    >;
typedef $$VentasDetallesTableCreateCompanionBuilder =
    VentasDetallesCompanion Function({
      Value<int> id,
      required int ventaId,
      required int productoId,
      required int cantidad,
      required double precioVenta,
    });
typedef $$VentasDetallesTableUpdateCompanionBuilder =
    VentasDetallesCompanion Function({
      Value<int> id,
      Value<int> ventaId,
      Value<int> productoId,
      Value<int> cantidad,
      Value<double> precioVenta,
    });

final class $$VentasDetallesTableReferences
    extends BaseReferences<_$AppDatabase, $VentasDetallesTable, VentasDetalle> {
  $$VentasDetallesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VentasTable _ventaIdTable(_$AppDatabase db) => db.ventas.createAlias(
    $_aliasNameGenerator(db.ventasDetalles.ventaId, db.ventas.id),
  );

  $$VentasTableProcessedTableManager get ventaId {
    final $_column = $_itemColumn<int>('venta_id')!;

    final manager = $$VentasTableTableManager(
      $_db,
      $_db.ventas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductosTable _productoIdTable(_$AppDatabase db) =>
      db.productos.createAlias(
        $_aliasNameGenerator(db.ventasDetalles.productoId, db.productos.id),
      );

  $$ProductosTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $$ProductosTableTableManager(
      $_db,
      $_db.productos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VentasDetallesTableFilterComposer
    extends Composer<_$AppDatabase, $VentasDetallesTable> {
  $$VentasDetallesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnFilters(column),
  );

  $$VentasTableFilterComposer get ventaId {
    final $$VentasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableFilterComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableFilterComposer get productoId {
    final $$ProductosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableFilterComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetallesTableOrderingComposer
    extends Composer<_$AppDatabase, $VentasDetallesTable> {
  $$VentasDetallesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => ColumnOrderings(column),
  );

  $$VentasTableOrderingComposer get ventaId {
    final $$VentasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableOrderingComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableOrderingComposer get productoId {
    final $$ProductosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableOrderingComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetallesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VentasDetallesTable> {
  $$VentasDetallesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioVenta => $composableBuilder(
    column: $table.precioVenta,
    builder: (column) => column,
  );

  $$VentasTableAnnotationComposer get ventaId {
    final $$VentasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.ventas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VentasTableAnnotationComposer(
            $db: $db,
            $table: $db.ventas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductosTableAnnotationComposer get productoId {
    final $$ProductosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosTableAnnotationComposer(
            $db: $db,
            $table: $db.productos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VentasDetallesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VentasDetallesTable,
          VentasDetalle,
          $$VentasDetallesTableFilterComposer,
          $$VentasDetallesTableOrderingComposer,
          $$VentasDetallesTableAnnotationComposer,
          $$VentasDetallesTableCreateCompanionBuilder,
          $$VentasDetallesTableUpdateCompanionBuilder,
          (VentasDetalle, $$VentasDetallesTableReferences),
          VentasDetalle,
          PrefetchHooks Function({bool ventaId, bool productoId})
        > {
  $$VentasDetallesTableTableManager(
    _$AppDatabase db,
    $VentasDetallesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VentasDetallesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VentasDetallesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VentasDetallesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioVenta = const Value.absent(),
              }) => VentasDetallesCompanion(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                cantidad: cantidad,
                precioVenta: precioVenta,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required int productoId,
                required int cantidad,
                required double precioVenta,
              }) => VentasDetallesCompanion.insert(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                cantidad: cantidad,
                precioVenta: precioVenta,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VentasDetallesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventaId = false, productoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ventaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ventaId,
                                referencedTable: $$VentasDetallesTableReferences
                                    ._ventaIdTable(db),
                                referencedColumn:
                                    $$VentasDetallesTableReferences
                                        ._ventaIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (productoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productoId,
                                referencedTable: $$VentasDetallesTableReferences
                                    ._productoIdTable(db),
                                referencedColumn:
                                    $$VentasDetallesTableReferences
                                        ._productoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VentasDetallesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VentasDetallesTable,
      VentasDetalle,
      $$VentasDetallesTableFilterComposer,
      $$VentasDetallesTableOrderingComposer,
      $$VentasDetallesTableAnnotationComposer,
      $$VentasDetallesTableCreateCompanionBuilder,
      $$VentasDetallesTableUpdateCompanionBuilder,
      (VentasDetalle, $$VentasDetallesTableReferences),
      VentasDetalle,
      PrefetchHooks Function({bool ventaId, bool productoId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductosTableTableManager get productos =>
      $$ProductosTableTableManager(_db, _db.productos);
  $$ProveedoresTableTableManager get proveedores =>
      $$ProveedoresTableTableManager(_db, _db.proveedores);
  $$ComprasTableTableManager get compras =>
      $$ComprasTableTableManager(_db, _db.compras);
  $$ComprasDetallesTableTableManager get comprasDetalles =>
      $$ComprasDetallesTableTableManager(_db, _db.comprasDetalles);
  $$VentasTableTableManager get ventas =>
      $$VentasTableTableManager(_db, _db.ventas);
  $$VentasDetallesTableTableManager get ventasDetalles =>
      $$VentasDetallesTableTableManager(_db, _db.ventasDetalles);
}
