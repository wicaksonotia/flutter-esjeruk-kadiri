import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get serverId => integer().named('server_id')();

  IntColumn get idKios => integer().named('id_kios')();

  IntColumn get categoryId => integer().named('category_id').nullable()();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  IntColumn get price => integer().withDefault(const Constant(0))();

  TextColumn get photo => text().nullable()();

  BoolColumn get favorite => boolean().withDefault(const Constant(false))();

  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();
}
