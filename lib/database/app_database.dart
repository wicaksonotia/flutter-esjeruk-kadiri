import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/categories.dart';
import 'tables/products.dart';
import 'tables/transactions.dart';
import 'tables/transaction_details.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Categories, Products, Transactions, TransactionDetails])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // ============================================================
      // CREATE DATABASE
      // ============================================================

      onCreate: (Migrator m) async {
        await m.createAll();
      },

      // ============================================================
      // UPGRADE DATABASE
      // ============================================================
      onUpgrade: (Migrator m, int from, int to) async {
        // ----------------------------------------------------------
        // VERSION 1 -> 2
        // ----------------------------------------------------------

        if (from < 2) {
          await m.createTable(transactions);
          await m.createTable(transactionDetails);
        }

        // ----------------------------------------------------------
        // VERSION 2 -> 3
        // ----------------------------------------------------------
        //
        // Jangan menggunakan m.addColumn() di sini karena
        // Drift 2.28.x pada project ini mengalami generic mismatch
        // antara TextColumn / GeneratedColumn<Object>.
        //
        // Gunakan SQL langsung.
        // ----------------------------------------------------------

        if (from < 3) {
          await m.database.customStatement('''
            ALTER TABLE transactions
            ADD COLUMN branch_code TEXT NOT NULL DEFAULT ''
          ''');

          await m.database.customStatement('''
            ALTER TABLE transactions
            ADD COLUMN local_number INTEGER
          ''');

          await m.database.customStatement('''
            ALTER TABLE transactions
            ADD COLUMN numerator INTEGER
          ''');
        }

        if (from < 4) {
          await m.database.customStatement('''
          ALTER TABLE transactions
          ADD COLUMN cashier_name TEXT NOT NULL DEFAULT ''
        ''');
        }
      },
    );
  }
}

// ==================================================================
// DATABASE CONNECTION
// ==================================================================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/kasira.sqlite');

    return NativeDatabase.createInBackground(file);
  });
}
