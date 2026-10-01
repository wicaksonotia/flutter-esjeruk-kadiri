import 'package:drift/drift.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get serverId => integer().named('server_id')();

  IntColumn get idKios => integer().named('id_kios')();

  TextColumn get name => text()();

  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();
}
