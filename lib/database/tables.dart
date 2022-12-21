import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'tables.g.dart';

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(max: 32)();
  TextColumn get password => text()();
  IntColumn get phone => integer()();
  TextColumn get mail => text()();
}

class MaterialType extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
}

class PartyTypeMaster extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
}

class PartyMaster extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get ptID => integer().references(PartyTypeMaster, #id)();
}

@DriftDatabase(tables: [User, MaterialType, PartyTypeMaster, PartyMaster])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    print('database Created');
    final dbFolder = Directory.current.path + '\\backupData';
    final file = File(p.join(dbFolder, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
