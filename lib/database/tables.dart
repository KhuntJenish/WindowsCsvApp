import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

class PartyComissionDetail extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pID => integer().references(PartyMaster, #id)();
  IntColumn get mtID => integer().references(MaterialType, #id)();
  RealColumn get comission1 => real()();
  RealColumn get comission2 => real()();
  RealColumn get comission3 => real()();
}

class InputData extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get documentType => text()();
  DateTimeColumn get distDocDate => dateTime()();
  TextColumn get distDocNo => text()();
  IntColumn get hospitalID => integer().references(PartyMaster, #id)();
  TextColumn get custBillCity => text()();
  TextColumn get matCode => text()();
  TextColumn get matName => text()();
  IntColumn get mtID => integer().references(MaterialType, #id)();
  IntColumn get qty => integer()();
  IntColumn get doctorID => integer().references(PartyMaster, #id)();
  IntColumn get techniqalStaffID => integer().references(PartyMaster, #id)();
  RealColumn get saleAmount => real()();
  RealColumn get totalSale => real()();
  DateTimeColumn get smtDocDate => dateTime()();
  TextColumn get smtDocNo => text()();
  TextColumn get smtInvNo => text()();
  RealColumn get purchaseTaxableAmount => real()();
  RealColumn get totalPurchaseAmount => real()();
  IntColumn get logId => integer()();
  IntColumn get generateLedgerId => integer()();
  IntColumn get paymentLedgerId => integer()();
  RealColumn get comission => real()();
  RealColumn get comissionAmount => real()();
  DateTimeColumn get comissionPaidDate => dateTime()();
  RealColumn get adjustComissionAmount => real()();
}

class Ledger extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  IntColumn get pID => integer().references(PartyMaster, #id)();
  DateTimeColumn get ledgerDate => dateTime()();
  RealColumn get drAmount => real()();
  RealColumn get crAmount => real()();
  RealColumn get extradrAmount => real()();
  RealColumn get extracrAmount => real()();
  TextColumn get ledgerNote => text()();
}

@DriftDatabase(tables: [
  User,
  MaterialType,
  PartyTypeMaster,
  PartyMaster,
  PartyComissionDetail,
  InputData,
  Ledger
])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onCreate: (Migrator m) async {
  //       await m.createAll();
  //     },
  //     onUpgrade: (Migrator m, int from, int to) async {
  //       if (from < 2) {
  //         // we added the dueDate property in the change from version 1 to
  //         // version 2
  //         partyComissionDetail;
  //         user;
  //         materialType;
  //         partyTypeMaster;
  //         partyMaster;
  //         inputData;
  //         ledger;
  //       }
  //       // if (from < 3) {
  //       //   // we added the priority property in the change from version 1 or 2
  //       //   // to version 3
  //       //   await m.addColumn(todos, todos.priority);
  //       // }
  //     },
  //   );
  // }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    print('database Created');
    final dbFolder = '${Directory.current.path}\\backup';
    final file = File(p.join(dbFolder, 'backup.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
