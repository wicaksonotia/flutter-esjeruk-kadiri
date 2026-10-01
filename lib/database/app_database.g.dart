// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idKiosMeta = const VerificationMeta('idKios');
  @override
  late final GeneratedColumn<int> idKios = GeneratedColumn<int>(
    'id_kios',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, serverId, idKios, name, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id_kios')) {
      context.handle(
        _idKiosMeta,
        idKios.isAcceptableOrUnknown(data['id_kios']!, _idKiosMeta),
      );
    } else if (isInserting) {
      context.missing(_idKiosMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      serverId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}server_id'],
          )!,
      idKios:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id_kios'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final int serverId;
  final int idKios;
  final String name;
  final DateTime? updatedAt;
  const Category({
    required this.id,
    required this.serverId,
    required this.idKios,
    required this.name,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_id'] = Variable<int>(serverId);
    map['id_kios'] = Variable<int>(idKios);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      serverId: Value(serverId),
      idKios: Value(idKios),
      name: Value(name),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int>(json['serverId']),
      idKios: serializer.fromJson<int>(json['idKios']),
      name: serializer.fromJson<String>(json['name']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int>(serverId),
      'idKios': serializer.toJson<int>(idKios),
      'name': serializer.toJson<String>(name),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Category copyWith({
    int? id,
    int? serverId,
    int? idKios,
    String? name,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    serverId: serverId ?? this.serverId,
    idKios: idKios ?? this.idKios,
    name: name ?? this.name,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      idKios: data.idKios.present ? data.idKios.value : this.idKios,
      name: data.name.present ? data.name.value : this.name,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idKios: $idKios, ')
          ..write('name: $name, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverId, idKios, name, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.idKios == this.idKios &&
          other.name == this.name &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<int> serverId;
  final Value<int> idKios;
  final Value<String> name;
  final Value<DateTime?> updatedAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.idKios = const Value.absent(),
    this.name = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int serverId,
    required int idKios,
    required String name,
    this.updatedAt = const Value.absent(),
  }) : serverId = Value(serverId),
       idKios = Value(idKios),
       name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<int>? idKios,
    Expression<String>? name,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (idKios != null) 'id_kios': idKios,
      if (name != null) 'name': name,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? serverId,
    Value<int>? idKios,
    Value<String>? name,
    Value<DateTime?>? updatedAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      idKios: idKios ?? this.idKios,
      name: name ?? this.name,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (idKios.present) {
      map['id_kios'] = Variable<int>(idKios.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idKios: $idKios, ')
          ..write('name: $name, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idKiosMeta = const VerificationMeta('idKios');
  @override
  late final GeneratedColumn<int> idKios = GeneratedColumn<int>(
    'id_kios',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String> photo = GeneratedColumn<String>(
    'photo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    idKios,
    categoryId,
    name,
    description,
    price,
    photo,
    favorite,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('id_kios')) {
      context.handle(
        _idKiosMeta,
        idKios.isAcceptableOrUnknown(data['id_kios']!, _idKiosMeta),
      );
    } else if (isInserting) {
      context.missing(_idKiosMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    }
    if (data.containsKey('photo')) {
      context.handle(
        _photoMeta,
        photo.isAcceptableOrUnknown(data['photo']!, _photoMeta),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      serverId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}server_id'],
          )!,
      idKios:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id_kios'],
          )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      price:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}price'],
          )!,
      photo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo'],
      ),
      favorite:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}favorite'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final int serverId;
  final int idKios;
  final int? categoryId;
  final String name;
  final String? description;
  final int price;
  final String? photo;
  final bool favorite;
  final DateTime? updatedAt;
  const Product({
    required this.id,
    required this.serverId,
    required this.idKios,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.photo,
    required this.favorite,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_id'] = Variable<int>(serverId);
    map['id_kios'] = Variable<int>(idKios);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price'] = Variable<int>(price);
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
    }
    map['favorite'] = Variable<bool>(favorite);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      serverId: Value(serverId),
      idKios: Value(idKios),
      categoryId:
          categoryId == null && nullToAbsent
              ? const Value.absent()
              : Value(categoryId),
      name: Value(name),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      price: Value(price),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
      favorite: Value(favorite),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int>(json['serverId']),
      idKios: serializer.fromJson<int>(json['idKios']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      price: serializer.fromJson<int>(json['price']),
      photo: serializer.fromJson<String?>(json['photo']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int>(serverId),
      'idKios': serializer.toJson<int>(idKios),
      'categoryId': serializer.toJson<int?>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'price': serializer.toJson<int>(price),
      'photo': serializer.toJson<String?>(photo),
      'favorite': serializer.toJson<bool>(favorite),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    int? serverId,
    int? idKios,
    Value<int?> categoryId = const Value.absent(),
    String? name,
    Value<String?> description = const Value.absent(),
    int? price,
    Value<String?> photo = const Value.absent(),
    bool? favorite,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Product(
    id: id ?? this.id,
    serverId: serverId ?? this.serverId,
    idKios: idKios ?? this.idKios,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    price: price ?? this.price,
    photo: photo.present ? photo.value : this.photo,
    favorite: favorite ?? this.favorite,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      idKios: data.idKios.present ? data.idKios.value : this.idKios,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      price: data.price.present ? data.price.value : this.price,
      photo: data.photo.present ? data.photo.value : this.photo,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idKios: $idKios, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('photo: $photo, ')
          ..write('favorite: $favorite, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    idKios,
    categoryId,
    name,
    description,
    price,
    photo,
    favorite,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.idKios == this.idKios &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.price == this.price &&
          other.photo == this.photo &&
          other.favorite == this.favorite &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<int> serverId;
  final Value<int> idKios;
  final Value<int?> categoryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> price;
  final Value<String?> photo;
  final Value<bool> favorite;
  final Value<DateTime?> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.idKios = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.photo = const Value.absent(),
    this.favorite = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required int serverId,
    required int idKios,
    this.categoryId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.photo = const Value.absent(),
    this.favorite = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : serverId = Value(serverId),
       idKios = Value(idKios),
       name = Value(name);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<int>? idKios,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? price,
    Expression<String>? photo,
    Expression<bool>? favorite,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (idKios != null) 'id_kios': idKios,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (photo != null) 'photo': photo,
      if (favorite != null) 'favorite': favorite,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<int>? serverId,
    Value<int>? idKios,
    Value<int?>? categoryId,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? price,
    Value<String?>? photo,
    Value<bool>? favorite,
    Value<DateTime?>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      idKios: idKios ?? this.idKios,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      photo: photo ?? this.photo,
      favorite: favorite ?? this.favorite,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (idKios.present) {
      map['id_kios'] = Variable<int>(idKios.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('idKios: $idKios, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('photo: $photo, ')
          ..write('favorite: $favorite, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _localUuidMeta = const VerificationMeta(
    'localUuid',
  );
  @override
  late final GeneratedColumn<String> localUuid = GeneratedColumn<String>(
    'local_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _serverTransactionIdMeta =
      const VerificationMeta('serverTransactionId');
  @override
  late final GeneratedColumn<int> serverTransactionId = GeneratedColumn<int>(
    'server_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idKiosMeta = const VerificationMeta('idKios');
  @override
  late final GeneratedColumn<int> idKios = GeneratedColumn<int>(
    'id_kios',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idCabangMeta = const VerificationMeta(
    'idCabang',
  );
  @override
  late final GeneratedColumn<int> idCabang = GeneratedColumn<int>(
    'id_cabang',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idKasirMeta = const VerificationMeta(
    'idKasir',
  );
  @override
  late final GeneratedColumn<int> idKasir = GeneratedColumn<int>(
    'id_kasir',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchCodeMeta = const VerificationMeta(
    'branchCode',
  );
  @override
  late final GeneratedColumn<String> branchCode = GeneratedColumn<String>(
    'branch_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _localNumberMeta = const VerificationMeta(
    'localNumber',
  );
  @override
  late final GeneratedColumn<int> localNumber = GeneratedColumn<int>(
    'local_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numeratorMeta = const VerificationMeta(
    'numerator',
  );
  @override
  late final GeneratedColumn<int> numerator = GeneratedColumn<int>(
    'numerator',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subTotalMeta = const VerificationMeta(
    'subTotal',
  );
  @override
  late final GeneratedColumn<int> subTotal = GeneratedColumn<int>(
    'sub_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalBayarMeta = const VerificationMeta(
    'totalBayar',
  );
  @override
  late final GeneratedColumn<int> totalBayar = GeneratedColumn<int>(
    'total_bayar',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalQuantityMeta = const VerificationMeta(
    'totalQuantity',
  );
  @override
  late final GeneratedColumn<int> totalQuantity = GeneratedColumn<int>(
    'total_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCancelledMeta = const VerificationMeta(
    'isCancelled',
  );
  @override
  late final GeneratedColumn<bool> isCancelled = GeneratedColumn<bool>(
    'is_cancelled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_cancelled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cancelReasonMeta = const VerificationMeta(
    'cancelReason',
  );
  @override
  late final GeneratedColumn<String> cancelReason = GeneratedColumn<String>(
    'cancel_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localUuid,
    serverTransactionId,
    idKios,
    idCabang,
    idKasir,
    branchCode,
    localNumber,
    numerator,
    subTotal,
    discount,
    totalBayar,
    totalQuantity,
    paymentMethod,
    transactionDate,
    syncStatus,
    isCancelled,
    cancelReason,
    createdAt,
    syncedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('local_uuid')) {
      context.handle(
        _localUuidMeta,
        localUuid.isAcceptableOrUnknown(data['local_uuid']!, _localUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_localUuidMeta);
    }
    if (data.containsKey('server_transaction_id')) {
      context.handle(
        _serverTransactionIdMeta,
        serverTransactionId.isAcceptableOrUnknown(
          data['server_transaction_id']!,
          _serverTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('id_kios')) {
      context.handle(
        _idKiosMeta,
        idKios.isAcceptableOrUnknown(data['id_kios']!, _idKiosMeta),
      );
    } else if (isInserting) {
      context.missing(_idKiosMeta);
    }
    if (data.containsKey('id_cabang')) {
      context.handle(
        _idCabangMeta,
        idCabang.isAcceptableOrUnknown(data['id_cabang']!, _idCabangMeta),
      );
    } else if (isInserting) {
      context.missing(_idCabangMeta);
    }
    if (data.containsKey('id_kasir')) {
      context.handle(
        _idKasirMeta,
        idKasir.isAcceptableOrUnknown(data['id_kasir']!, _idKasirMeta),
      );
    } else if (isInserting) {
      context.missing(_idKasirMeta);
    }
    if (data.containsKey('branch_code')) {
      context.handle(
        _branchCodeMeta,
        branchCode.isAcceptableOrUnknown(data['branch_code']!, _branchCodeMeta),
      );
    }
    if (data.containsKey('local_number')) {
      context.handle(
        _localNumberMeta,
        localNumber.isAcceptableOrUnknown(
          data['local_number']!,
          _localNumberMeta,
        ),
      );
    }
    if (data.containsKey('numerator')) {
      context.handle(
        _numeratorMeta,
        numerator.isAcceptableOrUnknown(data['numerator']!, _numeratorMeta),
      );
    }
    if (data.containsKey('sub_total')) {
      context.handle(
        _subTotalMeta,
        subTotal.isAcceptableOrUnknown(data['sub_total']!, _subTotalMeta),
      );
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('total_bayar')) {
      context.handle(
        _totalBayarMeta,
        totalBayar.isAcceptableOrUnknown(data['total_bayar']!, _totalBayarMeta),
      );
    }
    if (data.containsKey('total_quantity')) {
      context.handle(
        _totalQuantityMeta,
        totalQuantity.isAcceptableOrUnknown(
          data['total_quantity']!,
          _totalQuantityMeta,
        ),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('is_cancelled')) {
      context.handle(
        _isCancelledMeta,
        isCancelled.isAcceptableOrUnknown(
          data['is_cancelled']!,
          _isCancelledMeta,
        ),
      );
    }
    if (data.containsKey('cancel_reason')) {
      context.handle(
        _cancelReasonMeta,
        cancelReason.isAcceptableOrUnknown(
          data['cancel_reason']!,
          _cancelReasonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      localUuid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}local_uuid'],
          )!,
      serverTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_transaction_id'],
      ),
      idKios:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id_kios'],
          )!,
      idCabang:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id_cabang'],
          )!,
      idKasir:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id_kasir'],
          )!,
      branchCode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}branch_code'],
          )!,
      localNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_number'],
      ),
      numerator: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numerator'],
      ),
      subTotal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sub_total'],
          )!,
      discount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}discount'],
          )!,
      totalBayar:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_bayar'],
          )!,
      totalQuantity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_quantity'],
          )!,
      paymentMethod:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}payment_method'],
          )!,
      transactionDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}transaction_date'],
          )!,
      syncStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sync_status'],
          )!,
      isCancelled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_cancelled'],
          )!,
      cancelReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancel_reason'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  /// Primary key lokal SQLite
  final int id;

  /// UUID transaksi dari device.
  /// Dipakai sebagai idempotency key ketika sync ke server.
  final String localUuid;

  /// ID transaksi dari server setelah berhasil sync.
  final int? serverTransactionId;

  /// ID kios / brand
  final int idKios;

  /// ID cabang / outlet
  final int idCabang;

  /// ID kasir
  final int idKasir;

  /// Kode outlet, contoh:
  /// BGSN
  /// STG
  /// NMBN
  final String branchCode;

  /// Nomor transaksi lokal sebelum mendapatkan
  /// nomor resmi dari server.
  ///
  /// Contoh:
  /// LOCAL-0001
  /// LOCAL-0002
  final int? localNumber;

  /// Nomor transaksi resmi dari server.
  ///
  /// Contoh:
  /// 5644
  /// 5645
  final int? numerator;

  /// Sub total transaksi
  final int subTotal;

  /// Diskon
  final int discount;

  /// Total pembayaran
  final int totalBayar;

  /// Total quantity item
  final int totalQuantity;

  /// Metode pembayaran
  final String paymentMethod;

  /// Tanggal transaksi
  final DateTime transactionDate;

  /// Status sinkronisasi
  ///
  /// PENDING
  /// SYNCED
  final String syncStatus;

  /// Status pembatalan
  final bool isCancelled;

  /// Alasan pembatalan
  final String? cancelReason;

  /// Waktu dibuat di device
  final DateTime createdAt;

  /// Waktu berhasil sync
  final DateTime? syncedAt;

  /// Waktu terakhir berubah
  final DateTime updatedAt;
  const Transaction({
    required this.id,
    required this.localUuid,
    this.serverTransactionId,
    required this.idKios,
    required this.idCabang,
    required this.idKasir,
    required this.branchCode,
    this.localNumber,
    this.numerator,
    required this.subTotal,
    required this.discount,
    required this.totalBayar,
    required this.totalQuantity,
    required this.paymentMethod,
    required this.transactionDate,
    required this.syncStatus,
    required this.isCancelled,
    this.cancelReason,
    required this.createdAt,
    this.syncedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['local_uuid'] = Variable<String>(localUuid);
    if (!nullToAbsent || serverTransactionId != null) {
      map['server_transaction_id'] = Variable<int>(serverTransactionId);
    }
    map['id_kios'] = Variable<int>(idKios);
    map['id_cabang'] = Variable<int>(idCabang);
    map['id_kasir'] = Variable<int>(idKasir);
    map['branch_code'] = Variable<String>(branchCode);
    if (!nullToAbsent || localNumber != null) {
      map['local_number'] = Variable<int>(localNumber);
    }
    if (!nullToAbsent || numerator != null) {
      map['numerator'] = Variable<int>(numerator);
    }
    map['sub_total'] = Variable<int>(subTotal);
    map['discount'] = Variable<int>(discount);
    map['total_bayar'] = Variable<int>(totalBayar);
    map['total_quantity'] = Variable<int>(totalQuantity);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_cancelled'] = Variable<bool>(isCancelled);
    if (!nullToAbsent || cancelReason != null) {
      map['cancel_reason'] = Variable<String>(cancelReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      localUuid: Value(localUuid),
      serverTransactionId:
          serverTransactionId == null && nullToAbsent
              ? const Value.absent()
              : Value(serverTransactionId),
      idKios: Value(idKios),
      idCabang: Value(idCabang),
      idKasir: Value(idKasir),
      branchCode: Value(branchCode),
      localNumber:
          localNumber == null && nullToAbsent
              ? const Value.absent()
              : Value(localNumber),
      numerator:
          numerator == null && nullToAbsent
              ? const Value.absent()
              : Value(numerator),
      subTotal: Value(subTotal),
      discount: Value(discount),
      totalBayar: Value(totalBayar),
      totalQuantity: Value(totalQuantity),
      paymentMethod: Value(paymentMethod),
      transactionDate: Value(transactionDate),
      syncStatus: Value(syncStatus),
      isCancelled: Value(isCancelled),
      cancelReason:
          cancelReason == null && nullToAbsent
              ? const Value.absent()
              : Value(cancelReason),
      createdAt: Value(createdAt),
      syncedAt:
          syncedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(syncedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      localUuid: serializer.fromJson<String>(json['localUuid']),
      serverTransactionId: serializer.fromJson<int?>(
        json['serverTransactionId'],
      ),
      idKios: serializer.fromJson<int>(json['idKios']),
      idCabang: serializer.fromJson<int>(json['idCabang']),
      idKasir: serializer.fromJson<int>(json['idKasir']),
      branchCode: serializer.fromJson<String>(json['branchCode']),
      localNumber: serializer.fromJson<int?>(json['localNumber']),
      numerator: serializer.fromJson<int?>(json['numerator']),
      subTotal: serializer.fromJson<int>(json['subTotal']),
      discount: serializer.fromJson<int>(json['discount']),
      totalBayar: serializer.fromJson<int>(json['totalBayar']),
      totalQuantity: serializer.fromJson<int>(json['totalQuantity']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isCancelled: serializer.fromJson<bool>(json['isCancelled']),
      cancelReason: serializer.fromJson<String?>(json['cancelReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'localUuid': serializer.toJson<String>(localUuid),
      'serverTransactionId': serializer.toJson<int?>(serverTransactionId),
      'idKios': serializer.toJson<int>(idKios),
      'idCabang': serializer.toJson<int>(idCabang),
      'idKasir': serializer.toJson<int>(idKasir),
      'branchCode': serializer.toJson<String>(branchCode),
      'localNumber': serializer.toJson<int?>(localNumber),
      'numerator': serializer.toJson<int?>(numerator),
      'subTotal': serializer.toJson<int>(subTotal),
      'discount': serializer.toJson<int>(discount),
      'totalBayar': serializer.toJson<int>(totalBayar),
      'totalQuantity': serializer.toJson<int>(totalQuantity),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isCancelled': serializer.toJson<bool>(isCancelled),
      'cancelReason': serializer.toJson<String?>(cancelReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Transaction copyWith({
    int? id,
    String? localUuid,
    Value<int?> serverTransactionId = const Value.absent(),
    int? idKios,
    int? idCabang,
    int? idKasir,
    String? branchCode,
    Value<int?> localNumber = const Value.absent(),
    Value<int?> numerator = const Value.absent(),
    int? subTotal,
    int? discount,
    int? totalBayar,
    int? totalQuantity,
    String? paymentMethod,
    DateTime? transactionDate,
    String? syncStatus,
    bool? isCancelled,
    Value<String?> cancelReason = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => Transaction(
    id: id ?? this.id,
    localUuid: localUuid ?? this.localUuid,
    serverTransactionId:
        serverTransactionId.present
            ? serverTransactionId.value
            : this.serverTransactionId,
    idKios: idKios ?? this.idKios,
    idCabang: idCabang ?? this.idCabang,
    idKasir: idKasir ?? this.idKasir,
    branchCode: branchCode ?? this.branchCode,
    localNumber: localNumber.present ? localNumber.value : this.localNumber,
    numerator: numerator.present ? numerator.value : this.numerator,
    subTotal: subTotal ?? this.subTotal,
    discount: discount ?? this.discount,
    totalBayar: totalBayar ?? this.totalBayar,
    totalQuantity: totalQuantity ?? this.totalQuantity,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    transactionDate: transactionDate ?? this.transactionDate,
    syncStatus: syncStatus ?? this.syncStatus,
    isCancelled: isCancelled ?? this.isCancelled,
    cancelReason: cancelReason.present ? cancelReason.value : this.cancelReason,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      localUuid: data.localUuid.present ? data.localUuid.value : this.localUuid,
      serverTransactionId:
          data.serverTransactionId.present
              ? data.serverTransactionId.value
              : this.serverTransactionId,
      idKios: data.idKios.present ? data.idKios.value : this.idKios,
      idCabang: data.idCabang.present ? data.idCabang.value : this.idCabang,
      idKasir: data.idKasir.present ? data.idKasir.value : this.idKasir,
      branchCode:
          data.branchCode.present ? data.branchCode.value : this.branchCode,
      localNumber:
          data.localNumber.present ? data.localNumber.value : this.localNumber,
      numerator: data.numerator.present ? data.numerator.value : this.numerator,
      subTotal: data.subTotal.present ? data.subTotal.value : this.subTotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      totalBayar:
          data.totalBayar.present ? data.totalBayar.value : this.totalBayar,
      totalQuantity:
          data.totalQuantity.present
              ? data.totalQuantity.value
              : this.totalQuantity,
      paymentMethod:
          data.paymentMethod.present
              ? data.paymentMethod.value
              : this.paymentMethod,
      transactionDate:
          data.transactionDate.present
              ? data.transactionDate.value
              : this.transactionDate,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isCancelled:
          data.isCancelled.present ? data.isCancelled.value : this.isCancelled,
      cancelReason:
          data.cancelReason.present
              ? data.cancelReason.value
              : this.cancelReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('localUuid: $localUuid, ')
          ..write('serverTransactionId: $serverTransactionId, ')
          ..write('idKios: $idKios, ')
          ..write('idCabang: $idCabang, ')
          ..write('idKasir: $idKasir, ')
          ..write('branchCode: $branchCode, ')
          ..write('localNumber: $localNumber, ')
          ..write('numerator: $numerator, ')
          ..write('subTotal: $subTotal, ')
          ..write('discount: $discount, ')
          ..write('totalBayar: $totalBayar, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isCancelled: $isCancelled, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    localUuid,
    serverTransactionId,
    idKios,
    idCabang,
    idKasir,
    branchCode,
    localNumber,
    numerator,
    subTotal,
    discount,
    totalBayar,
    totalQuantity,
    paymentMethod,
    transactionDate,
    syncStatus,
    isCancelled,
    cancelReason,
    createdAt,
    syncedAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.localUuid == this.localUuid &&
          other.serverTransactionId == this.serverTransactionId &&
          other.idKios == this.idKios &&
          other.idCabang == this.idCabang &&
          other.idKasir == this.idKasir &&
          other.branchCode == this.branchCode &&
          other.localNumber == this.localNumber &&
          other.numerator == this.numerator &&
          other.subTotal == this.subTotal &&
          other.discount == this.discount &&
          other.totalBayar == this.totalBayar &&
          other.totalQuantity == this.totalQuantity &&
          other.paymentMethod == this.paymentMethod &&
          other.transactionDate == this.transactionDate &&
          other.syncStatus == this.syncStatus &&
          other.isCancelled == this.isCancelled &&
          other.cancelReason == this.cancelReason &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String> localUuid;
  final Value<int?> serverTransactionId;
  final Value<int> idKios;
  final Value<int> idCabang;
  final Value<int> idKasir;
  final Value<String> branchCode;
  final Value<int?> localNumber;
  final Value<int?> numerator;
  final Value<int> subTotal;
  final Value<int> discount;
  final Value<int> totalBayar;
  final Value<int> totalQuantity;
  final Value<String> paymentMethod;
  final Value<DateTime> transactionDate;
  final Value<String> syncStatus;
  final Value<bool> isCancelled;
  final Value<String?> cancelReason;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<DateTime> updatedAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.localUuid = const Value.absent(),
    this.serverTransactionId = const Value.absent(),
    this.idKios = const Value.absent(),
    this.idCabang = const Value.absent(),
    this.idKasir = const Value.absent(),
    this.branchCode = const Value.absent(),
    this.localNumber = const Value.absent(),
    this.numerator = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.totalBayar = const Value.absent(),
    this.totalQuantity = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isCancelled = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String localUuid,
    this.serverTransactionId = const Value.absent(),
    required int idKios,
    required int idCabang,
    required int idKasir,
    this.branchCode = const Value.absent(),
    this.localNumber = const Value.absent(),
    this.numerator = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.totalBayar = const Value.absent(),
    this.totalQuantity = const Value.absent(),
    required String paymentMethod,
    required DateTime transactionDate,
    required String syncStatus,
    this.isCancelled = const Value.absent(),
    this.cancelReason = const Value.absent(),
    required DateTime createdAt,
    this.syncedAt = const Value.absent(),
    required DateTime updatedAt,
  }) : localUuid = Value(localUuid),
       idKios = Value(idKios),
       idCabang = Value(idCabang),
       idKasir = Value(idKasir),
       paymentMethod = Value(paymentMethod),
       transactionDate = Value(transactionDate),
       syncStatus = Value(syncStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? localUuid,
    Expression<int>? serverTransactionId,
    Expression<int>? idKios,
    Expression<int>? idCabang,
    Expression<int>? idKasir,
    Expression<String>? branchCode,
    Expression<int>? localNumber,
    Expression<int>? numerator,
    Expression<int>? subTotal,
    Expression<int>? discount,
    Expression<int>? totalBayar,
    Expression<int>? totalQuantity,
    Expression<String>? paymentMethod,
    Expression<DateTime>? transactionDate,
    Expression<String>? syncStatus,
    Expression<bool>? isCancelled,
    Expression<String>? cancelReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localUuid != null) 'local_uuid': localUuid,
      if (serverTransactionId != null)
        'server_transaction_id': serverTransactionId,
      if (idKios != null) 'id_kios': idKios,
      if (idCabang != null) 'id_cabang': idCabang,
      if (idKasir != null) 'id_kasir': idKasir,
      if (branchCode != null) 'branch_code': branchCode,
      if (localNumber != null) 'local_number': localNumber,
      if (numerator != null) 'numerator': numerator,
      if (subTotal != null) 'sub_total': subTotal,
      if (discount != null) 'discount': discount,
      if (totalBayar != null) 'total_bayar': totalBayar,
      if (totalQuantity != null) 'total_quantity': totalQuantity,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isCancelled != null) 'is_cancelled': isCancelled,
      if (cancelReason != null) 'cancel_reason': cancelReason,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<String>? localUuid,
    Value<int?>? serverTransactionId,
    Value<int>? idKios,
    Value<int>? idCabang,
    Value<int>? idKasir,
    Value<String>? branchCode,
    Value<int?>? localNumber,
    Value<int?>? numerator,
    Value<int>? subTotal,
    Value<int>? discount,
    Value<int>? totalBayar,
    Value<int>? totalQuantity,
    Value<String>? paymentMethod,
    Value<DateTime>? transactionDate,
    Value<String>? syncStatus,
    Value<bool>? isCancelled,
    Value<String?>? cancelReason,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
    Value<DateTime>? updatedAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      localUuid: localUuid ?? this.localUuid,
      serverTransactionId: serverTransactionId ?? this.serverTransactionId,
      idKios: idKios ?? this.idKios,
      idCabang: idCabang ?? this.idCabang,
      idKasir: idKasir ?? this.idKasir,
      branchCode: branchCode ?? this.branchCode,
      localNumber: localNumber ?? this.localNumber,
      numerator: numerator ?? this.numerator,
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      totalBayar: totalBayar ?? this.totalBayar,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionDate: transactionDate ?? this.transactionDate,
      syncStatus: syncStatus ?? this.syncStatus,
      isCancelled: isCancelled ?? this.isCancelled,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (localUuid.present) {
      map['local_uuid'] = Variable<String>(localUuid.value);
    }
    if (serverTransactionId.present) {
      map['server_transaction_id'] = Variable<int>(serverTransactionId.value);
    }
    if (idKios.present) {
      map['id_kios'] = Variable<int>(idKios.value);
    }
    if (idCabang.present) {
      map['id_cabang'] = Variable<int>(idCabang.value);
    }
    if (idKasir.present) {
      map['id_kasir'] = Variable<int>(idKasir.value);
    }
    if (branchCode.present) {
      map['branch_code'] = Variable<String>(branchCode.value);
    }
    if (localNumber.present) {
      map['local_number'] = Variable<int>(localNumber.value);
    }
    if (numerator.present) {
      map['numerator'] = Variable<int>(numerator.value);
    }
    if (subTotal.present) {
      map['sub_total'] = Variable<int>(subTotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (totalBayar.present) {
      map['total_bayar'] = Variable<int>(totalBayar.value);
    }
    if (totalQuantity.present) {
      map['total_quantity'] = Variable<int>(totalQuantity.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isCancelled.present) {
      map['is_cancelled'] = Variable<bool>(isCancelled.value);
    }
    if (cancelReason.present) {
      map['cancel_reason'] = Variable<String>(cancelReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('localUuid: $localUuid, ')
          ..write('serverTransactionId: $serverTransactionId, ')
          ..write('idKios: $idKios, ')
          ..write('idCabang: $idCabang, ')
          ..write('idKasir: $idKasir, ')
          ..write('branchCode: $branchCode, ')
          ..write('localNumber: $localNumber, ')
          ..write('numerator: $numerator, ')
          ..write('subTotal: $subTotal, ')
          ..write('discount: $discount, ')
          ..write('totalBayar: $totalBayar, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isCancelled: $isCancelled, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionDetailsTable extends TransactionDetails
    with TableInfo<$TransactionDetailsTable, TransactionDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionDetailsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _transactionLocalUuidMeta =
      const VerificationMeta('transactionLocalUuid');
  @override
  late final GeneratedColumn<String> transactionLocalUuid =
      GeneratedColumn<String>(
        'transaction_local_uuid',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _idProductMeta = const VerificationMeta(
    'idProduct',
  );
  @override
  late final GeneratedColumn<int> idProduct = GeneratedColumn<int>(
    'id_product',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionLocalUuid,
    idProduct,
    productName,
    quantity,
    unitPrice,
    subtotal,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_local_uuid')) {
      context.handle(
        _transactionLocalUuidMeta,
        transactionLocalUuid.isAcceptableOrUnknown(
          data['transaction_local_uuid']!,
          _transactionLocalUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionLocalUuidMeta);
    }
    if (data.containsKey('id_product')) {
      context.handle(
        _idProductMeta,
        idProduct.isAcceptableOrUnknown(data['id_product']!, _idProductMeta),
      );
    } else if (isInserting) {
      context.missing(_idProductMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionDetail(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      transactionLocalUuid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}transaction_local_uuid'],
          )!,
      idProduct:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id_product'],
          )!,
      productName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}product_name'],
          )!,
      quantity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}quantity'],
          )!,
      unitPrice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}unit_price'],
          )!,
      subtotal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}subtotal'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $TransactionDetailsTable createAlias(String alias) {
    return $TransactionDetailsTable(attachedDatabase, alias);
  }
}

class TransactionDetail extends DataClass
    implements Insertable<TransactionDetail> {
  final int id;
  final String transactionLocalUuid;
  final int idProduct;
  final String productName;
  final int quantity;
  final int unitPrice;
  final int subtotal;
  final DateTime createdAt;
  const TransactionDetail({
    required this.id,
    required this.transactionLocalUuid,
    required this.idProduct,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_local_uuid'] = Variable<String>(transactionLocalUuid);
    map['id_product'] = Variable<int>(idProduct);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price'] = Variable<int>(unitPrice);
    map['subtotal'] = Variable<int>(subtotal);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionDetailsCompanion toCompanion(bool nullToAbsent) {
    return TransactionDetailsCompanion(
      id: Value(id),
      transactionLocalUuid: Value(transactionLocalUuid),
      idProduct: Value(idProduct),
      productName: Value(productName),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      subtotal: Value(subtotal),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionDetail(
      id: serializer.fromJson<int>(json['id']),
      transactionLocalUuid: serializer.fromJson<String>(
        json['transactionLocalUuid'],
      ),
      idProduct: serializer.fromJson<int>(json['idProduct']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionLocalUuid': serializer.toJson<String>(transactionLocalUuid),
      'idProduct': serializer.toJson<int>(idProduct),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<int>(quantity),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'subtotal': serializer.toJson<int>(subtotal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionDetail copyWith({
    int? id,
    String? transactionLocalUuid,
    int? idProduct,
    String? productName,
    int? quantity,
    int? unitPrice,
    int? subtotal,
    DateTime? createdAt,
  }) => TransactionDetail(
    id: id ?? this.id,
    transactionLocalUuid: transactionLocalUuid ?? this.transactionLocalUuid,
    idProduct: idProduct ?? this.idProduct,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    subtotal: subtotal ?? this.subtotal,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionDetail copyWithCompanion(TransactionDetailsCompanion data) {
    return TransactionDetail(
      id: data.id.present ? data.id.value : this.id,
      transactionLocalUuid:
          data.transactionLocalUuid.present
              ? data.transactionLocalUuid.value
              : this.transactionLocalUuid,
      idProduct: data.idProduct.present ? data.idProduct.value : this.idProduct,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionDetail(')
          ..write('id: $id, ')
          ..write('transactionLocalUuid: $transactionLocalUuid, ')
          ..write('idProduct: $idProduct, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('subtotal: $subtotal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionLocalUuid,
    idProduct,
    productName,
    quantity,
    unitPrice,
    subtotal,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionDetail &&
          other.id == this.id &&
          other.transactionLocalUuid == this.transactionLocalUuid &&
          other.idProduct == this.idProduct &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.subtotal == this.subtotal &&
          other.createdAt == this.createdAt);
}

class TransactionDetailsCompanion extends UpdateCompanion<TransactionDetail> {
  final Value<int> id;
  final Value<String> transactionLocalUuid;
  final Value<int> idProduct;
  final Value<String> productName;
  final Value<int> quantity;
  final Value<int> unitPrice;
  final Value<int> subtotal;
  final Value<DateTime> createdAt;
  const TransactionDetailsCompanion({
    this.id = const Value.absent(),
    this.transactionLocalUuid = const Value.absent(),
    this.idProduct = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionDetailsCompanion.insert({
    this.id = const Value.absent(),
    required String transactionLocalUuid,
    required int idProduct,
    required String productName,
    required int quantity,
    required int unitPrice,
    this.subtotal = const Value.absent(),
    required DateTime createdAt,
  }) : transactionLocalUuid = Value(transactionLocalUuid),
       idProduct = Value(idProduct),
       productName = Value(productName),
       quantity = Value(quantity),
       unitPrice = Value(unitPrice),
       createdAt = Value(createdAt);
  static Insertable<TransactionDetail> custom({
    Expression<int>? id,
    Expression<String>? transactionLocalUuid,
    Expression<int>? idProduct,
    Expression<String>? productName,
    Expression<int>? quantity,
    Expression<int>? unitPrice,
    Expression<int>? subtotal,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionLocalUuid != null)
        'transaction_local_uuid': transactionLocalUuid,
      if (idProduct != null) 'id_product': idProduct,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (subtotal != null) 'subtotal': subtotal,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionDetailsCompanion copyWith({
    Value<int>? id,
    Value<String>? transactionLocalUuid,
    Value<int>? idProduct,
    Value<String>? productName,
    Value<int>? quantity,
    Value<int>? unitPrice,
    Value<int>? subtotal,
    Value<DateTime>? createdAt,
  }) {
    return TransactionDetailsCompanion(
      id: id ?? this.id,
      transactionLocalUuid: transactionLocalUuid ?? this.transactionLocalUuid,
      idProduct: idProduct ?? this.idProduct,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      subtotal: subtotal ?? this.subtotal,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionLocalUuid.present) {
      map['transaction_local_uuid'] = Variable<String>(
        transactionLocalUuid.value,
      );
    }
    if (idProduct.present) {
      map['id_product'] = Variable<int>(idProduct.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionDetailsCompanion(')
          ..write('id: $id, ')
          ..write('transactionLocalUuid: $transactionLocalUuid, ')
          ..write('idProduct: $idProduct, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('subtotal: $subtotal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionDetailsTable transactionDetails =
      $TransactionDetailsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    products,
    transactions,
    transactionDetails,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required int serverId,
      required int idKios,
      required String name,
      Value<DateTime?> updatedAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<int> serverId,
      Value<int> idKios,
      Value<String> name,
      Value<DateTime?> updatedAt,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idKios => $composableBuilder(
    column: $table.idKios,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idKios => $composableBuilder(
    column: $table.idKios,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get idKios =>
      $composableBuilder(column: $table.idKios, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> serverId = const Value.absent(),
                Value<int> idKios = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                serverId: serverId,
                idKios: idKios,
                name: name,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int serverId,
                required int idKios,
                required String name,
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                serverId: serverId,
                idKios: idKios,
                name: name,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$CategoriesTable, Category>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $CategoriesTable,
                            Category
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required int serverId,
      required int idKios,
      Value<int?> categoryId,
      required String name,
      Value<String?> description,
      Value<int> price,
      Value<String?> photo,
      Value<bool> favorite,
      Value<DateTime?> updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<int> serverId,
      Value<int> idKios,
      Value<int?> categoryId,
      Value<String> name,
      Value<String?> description,
      Value<int> price,
      Value<String?> photo,
      Value<bool> favorite,
      Value<DateTime?> updatedAt,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idKios => $composableBuilder(
    column: $table.idKios,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idKios => $composableBuilder(
    column: $table.idKios,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photo => $composableBuilder(
    column: $table.photo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get idKios =>
      $composableBuilder(column: $table.idKios, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get photo =>
      $composableBuilder(column: $table.photo, builder: (column) => column);

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> serverId = const Value.absent(),
                Value<int> idKios = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<String?> photo = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                serverId: serverId,
                idKios: idKios,
                categoryId: categoryId,
                name: name,
                description: description,
                price: price,
                photo: photo,
                favorite: favorite,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int serverId,
                required int idKios,
                Value<int?> categoryId = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<String?> photo = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                serverId: serverId,
                idKios: idKios,
                categoryId: categoryId,
                name: name,
                description: description,
                price: price,
                photo: photo,
                favorite: favorite,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$ProductsTable, Product>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $ProductsTable,
                            Product
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required String localUuid,
      Value<int?> serverTransactionId,
      required int idKios,
      required int idCabang,
      required int idKasir,
      Value<String> branchCode,
      Value<int?> localNumber,
      Value<int?> numerator,
      Value<int> subTotal,
      Value<int> discount,
      Value<int> totalBayar,
      Value<int> totalQuantity,
      required String paymentMethod,
      required DateTime transactionDate,
      required String syncStatus,
      Value<bool> isCancelled,
      Value<String?> cancelReason,
      required DateTime createdAt,
      Value<DateTime?> syncedAt,
      required DateTime updatedAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<String> localUuid,
      Value<int?> serverTransactionId,
      Value<int> idKios,
      Value<int> idCabang,
      Value<int> idKasir,
      Value<String> branchCode,
      Value<int?> localNumber,
      Value<int?> numerator,
      Value<int> subTotal,
      Value<int> discount,
      Value<int> totalBayar,
      Value<int> totalQuantity,
      Value<String> paymentMethod,
      Value<DateTime> transactionDate,
      Value<String> syncStatus,
      Value<bool> isCancelled,
      Value<String?> cancelReason,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<DateTime> updatedAt,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<String> get localUuid => $composableBuilder(
    column: $table.localUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverTransactionId => $composableBuilder(
    column: $table.serverTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idKios => $composableBuilder(
    column: $table.idKios,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idCabang => $composableBuilder(
    column: $table.idCabang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idKasir => $composableBuilder(
    column: $table.idKasir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branchCode => $composableBuilder(
    column: $table.branchCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localNumber => $composableBuilder(
    column: $table.localNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subTotal => $composableBuilder(
    column: $table.subTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalBayar => $composableBuilder(
    column: $table.totalBayar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCancelled => $composableBuilder(
    column: $table.isCancelled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get localUuid => $composableBuilder(
    column: $table.localUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverTransactionId => $composableBuilder(
    column: $table.serverTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idKios => $composableBuilder(
    column: $table.idKios,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idCabang => $composableBuilder(
    column: $table.idCabang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idKasir => $composableBuilder(
    column: $table.idKasir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branchCode => $composableBuilder(
    column: $table.branchCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localNumber => $composableBuilder(
    column: $table.localNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numerator => $composableBuilder(
    column: $table.numerator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subTotal => $composableBuilder(
    column: $table.subTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalBayar => $composableBuilder(
    column: $table.totalBayar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCancelled => $composableBuilder(
    column: $table.isCancelled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localUuid =>
      $composableBuilder(column: $table.localUuid, builder: (column) => column);

  GeneratedColumn<int> get serverTransactionId => $composableBuilder(
    column: $table.serverTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get idKios =>
      $composableBuilder(column: $table.idKios, builder: (column) => column);

  GeneratedColumn<int> get idCabang =>
      $composableBuilder(column: $table.idCabang, builder: (column) => column);

  GeneratedColumn<int> get idKasir =>
      $composableBuilder(column: $table.idKasir, builder: (column) => column);

  GeneratedColumn<String> get branchCode => $composableBuilder(
    column: $table.branchCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localNumber => $composableBuilder(
    column: $table.localNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numerator =>
      $composableBuilder(column: $table.numerator, builder: (column) => column);

  GeneratedColumn<int> get subTotal =>
      $composableBuilder(column: $table.subTotal, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get totalBayar => $composableBuilder(
    column: $table.totalBayar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuantity => $composableBuilder(
    column: $table.totalQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCancelled => $composableBuilder(
    column: $table.isCancelled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cancelReason => $composableBuilder(
    column: $table.cancelReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> localUuid = const Value.absent(),
                Value<int?> serverTransactionId = const Value.absent(),
                Value<int> idKios = const Value.absent(),
                Value<int> idCabang = const Value.absent(),
                Value<int> idKasir = const Value.absent(),
                Value<String> branchCode = const Value.absent(),
                Value<int?> localNumber = const Value.absent(),
                Value<int?> numerator = const Value.absent(),
                Value<int> subTotal = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> totalBayar = const Value.absent(),
                Value<int> totalQuantity = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<bool> isCancelled = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                localUuid: localUuid,
                serverTransactionId: serverTransactionId,
                idKios: idKios,
                idCabang: idCabang,
                idKasir: idKasir,
                branchCode: branchCode,
                localNumber: localNumber,
                numerator: numerator,
                subTotal: subTotal,
                discount: discount,
                totalBayar: totalBayar,
                totalQuantity: totalQuantity,
                paymentMethod: paymentMethod,
                transactionDate: transactionDate,
                syncStatus: syncStatus,
                isCancelled: isCancelled,
                cancelReason: cancelReason,
                createdAt: createdAt,
                syncedAt: syncedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String localUuid,
                Value<int?> serverTransactionId = const Value.absent(),
                required int idKios,
                required int idCabang,
                required int idKasir,
                Value<String> branchCode = const Value.absent(),
                Value<int?> localNumber = const Value.absent(),
                Value<int?> numerator = const Value.absent(),
                Value<int> subTotal = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> totalBayar = const Value.absent(),
                Value<int> totalQuantity = const Value.absent(),
                required String paymentMethod,
                required DateTime transactionDate,
                required String syncStatus,
                Value<bool> isCancelled = const Value.absent(),
                Value<String?> cancelReason = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> syncedAt = const Value.absent(),
                required DateTime updatedAt,
              }) => TransactionsCompanion.insert(
                id: id,
                localUuid: localUuid,
                serverTransactionId: serverTransactionId,
                idKios: idKios,
                idCabang: idCabang,
                idKasir: idKasir,
                branchCode: branchCode,
                localNumber: localNumber,
                numerator: numerator,
                subTotal: subTotal,
                discount: discount,
                totalBayar: totalBayar,
                totalQuantity: totalQuantity,
                paymentMethod: paymentMethod,
                transactionDate: transactionDate,
                syncStatus: syncStatus,
                isCancelled: isCancelled,
                cancelReason: cancelReason,
                createdAt: createdAt,
                syncedAt: syncedAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<$TransactionsTable, Transaction>(table),
                          BaseReferences<
                            _$AppDatabase,
                            $TransactionsTable,
                            Transaction
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$TransactionDetailsTableCreateCompanionBuilder =
    TransactionDetailsCompanion Function({
      Value<int> id,
      required String transactionLocalUuid,
      required int idProduct,
      required String productName,
      required int quantity,
      required int unitPrice,
      Value<int> subtotal,
      required DateTime createdAt,
    });
typedef $$TransactionDetailsTableUpdateCompanionBuilder =
    TransactionDetailsCompanion Function({
      Value<int> id,
      Value<String> transactionLocalUuid,
      Value<int> idProduct,
      Value<String> productName,
      Value<int> quantity,
      Value<int> unitPrice,
      Value<int> subtotal,
      Value<DateTime> createdAt,
    });

class $$TransactionDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionDetailsTable> {
  $$TransactionDetailsTableFilterComposer({
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

  ColumnFilters<String> get transactionLocalUuid => $composableBuilder(
    column: $table.transactionLocalUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get idProduct => $composableBuilder(
    column: $table.idProduct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionDetailsTable> {
  $$TransactionDetailsTableOrderingComposer({
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

  ColumnOrderings<String> get transactionLocalUuid => $composableBuilder(
    column: $table.transactionLocalUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get idProduct => $composableBuilder(
    column: $table.idProduct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionDetailsTable> {
  $$TransactionDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionLocalUuid => $composableBuilder(
    column: $table.transactionLocalUuid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get idProduct =>
      $composableBuilder(column: $table.idProduct, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransactionDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionDetailsTable,
          TransactionDetail,
          $$TransactionDetailsTableFilterComposer,
          $$TransactionDetailsTableOrderingComposer,
          $$TransactionDetailsTableAnnotationComposer,
          $$TransactionDetailsTableCreateCompanionBuilder,
          $$TransactionDetailsTableUpdateCompanionBuilder,
          (
            TransactionDetail,
            BaseReferences<
              _$AppDatabase,
              $TransactionDetailsTable,
              TransactionDetail
            >,
          ),
          TransactionDetail,
          PrefetchHooks Function()
        > {
  $$TransactionDetailsTableTableManager(
    _$AppDatabase db,
    $TransactionDetailsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TransactionDetailsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TransactionDetailsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TransactionDetailsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> transactionLocalUuid = const Value.absent(),
                Value<int> idProduct = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionDetailsCompanion(
                id: id,
                transactionLocalUuid: transactionLocalUuid,
                idProduct: idProduct,
                productName: productName,
                quantity: quantity,
                unitPrice: unitPrice,
                subtotal: subtotal,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String transactionLocalUuid,
                required int idProduct,
                required String productName,
                required int quantity,
                required int unitPrice,
                Value<int> subtotal = const Value.absent(),
                required DateTime createdAt,
              }) => TransactionDetailsCompanion.insert(
                id: id,
                transactionLocalUuid: transactionLocalUuid,
                idProduct: idProduct,
                productName: productName,
                quantity: quantity,
                unitPrice: unitPrice,
                subtotal: subtotal,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable<
                            $TransactionDetailsTable,
                            TransactionDetail
                          >(table),
                          BaseReferences<
                            _$AppDatabase,
                            $TransactionDetailsTable,
                            TransactionDetail
                          >(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionDetailsTable,
      TransactionDetail,
      $$TransactionDetailsTableFilterComposer,
      $$TransactionDetailsTableOrderingComposer,
      $$TransactionDetailsTableAnnotationComposer,
      $$TransactionDetailsTableCreateCompanionBuilder,
      $$TransactionDetailsTableUpdateCompanionBuilder,
      (
        TransactionDetail,
        BaseReferences<
          _$AppDatabase,
          $TransactionDetailsTable,
          TransactionDetail
        >,
      ),
      TransactionDetail,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionDetailsTableTableManager get transactionDetails =>
      $$TransactionDetailsTableTableManager(_db, _db.transactionDetails);
}
