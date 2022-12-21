// import 'dart:io';

// import 'package:csvapp/entities/materialType.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:isar/isar.dart';

// class IsarService {
//   late Future<Isar> db;

//   IsarService() {
//     db = openDB();
//   }
//   Future<Isar> openDB() async {
//     if (Isar.instanceNames.isEmpty) {
//       var dbPath = Directory.current.path + '\\backupData';
//       print(dbPath);
//       print(Directory.current.path + '\\dbtemp');
//       return await Isar.open(
//         [DemoSchema],
//         // inspector: true,
//         name: 'demo_db',
//         directory: dbPath,
//         relaxedDurability: false,
//       );
//     }

//     return Future.value(Isar.getInstance());
//   }

//   Future<void> cleanDb() async {
//     final isar = await db;
//     await isar.writeTxn(() => isar.clear());
//   }

//   Stream<List<Demo>> listenToCourses() async* {
//     final isar = await db;
//     yield* isar.demos.filter().partyEqualTo('brijal').watch(initialReturn: true);
//   }

//   Future<void> saveData(Demo newDemos) async {
//     final isar = await db;
//     isar.writeTxnSync<int>(() => isar.demos.putSync(newDemos));
//   }
// }
