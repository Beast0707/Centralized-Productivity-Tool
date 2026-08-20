import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  TextColumn get date => text().nullable()();

  IntColumn get isCompleted =>
      integer().withDefault(const Constant(0))();

  TextColumn get createdAt => text().nullable()();

  TextColumn get updatedAt => text().nullable()();
}

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get content => text().nullable()();

  TextColumn get createdAt => text().nullable()();

  TextColumn get updatedAt => text().nullable()();
}

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get date => text().nullable()();

  TextColumn get createdAt => text().nullable()();

  TextColumn get updatedAt => text().nullable()();
}