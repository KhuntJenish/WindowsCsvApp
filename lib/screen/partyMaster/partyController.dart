import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../database/tables.dart';
import '../../utils/constant.dart';

class PartyController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPartyList();
    getMaterialTypeList();
    // getcomissionDetail();
  }

  Rx<PartyTypeMasterData> defualtParty =
      PartyTypeMasterData(id: 0, type: '').obs;
  Rx<MaterialTypeData> defualtMaterialType =
      MaterialTypeData(id: 0, type: '').obs;
  final addPartyBtnText = 'Add Party'.obs;
  List<PartyTypeMasterData>? partyTypeList = [];
  List<MaterialTypeData>? materialTypeList = [];
  var dataRowList = [].obs;
  var db = Constantdata.db;
  // getcomissionDetail() async {
  //   var datap = await db.select(db.partyMaster).get();
  //   print(datap);
  //   var datam = await db.select(db.materialType).get();
  //   print(datam);
  //   var data = await db.select(db.partyComissionDetail).get();
  //   print('partyComissionDetail');
  //   print(data);
  //   //   var date = DateTime.now();
  //   //   var ldata = await db.into(db.ledger).insert(LedgerCompanion.insert(type: 'sales', pID: 3, ledgerDate: date, drAmount: 100 , crAmount: 100, ledgerNote: 'test'));
  //   //   print('comissionDetail');
  //   //  print(ldata);
  // }

  getPartyList() async {
    partyTypeList?.clear();
    var data = await db.select(db.partyTypeMaster).get();
    // .then((value) {
    //   value.forEach((element) {
    //     partyList?.add(element);
    //   });
    // });
    partyTypeList?.addAll(data);

    // print(data);
    if (partyTypeList!.isNotEmpty) {
      // print(partyTypeList![0]);
      var defualt = partyTypeList![0].obs;
      defualtParty.value = defualt.value;
      print('defualtParty: ${defualtParty.value}');
    }

    print(partyTypeList);
  }

  getMaterialTypeList() async {
    partyTypeList?.clear();
    var data = await db.select(db.materialType).get();

    materialTypeList?.addAll(data);

    // print(data);
    if (materialTypeList!.isNotEmpty) {
      // print(materialTypeList![0]);
      var defualt = materialTypeList![0].obs;
      defualtMaterialType.value = defualt.value;
      print('defualtMaterialType: ${defualtMaterialType.value}');
    }

    print(materialTypeList);
  }

  getPartyComissionList({int? pID}) async {
    // partyTypeList?.clear();
    var data = await db.select(db.partyComissionDetail).get();
    // List<DataRow> list = [];
    if (data.isNotEmpty) {
      data.forEach((element) {
        var material =
            materialTypeList?.firstWhere((m) => m.id == element.mtID).type;

        var dataRow = DataRow(cells: [
          DataCell(Text(element.id.toString())),
          DataCell(Text(material.toString())),
          DataCell(Text(element.comission1.toString())),
          DataCell(Text(element.comission2.toString())),
          DataCell(Text(element.comission3.toString())),
        ]);
        dataRowList.add(dataRow);
      });
    }
    print(dataRowList);
    // return list;
  }

  addPartyType({String? partyType}) {
    var data = db.into(db.partyTypeMaster).insert(
          PartyTypeMasterCompanion.insert(type: partyType.toString()),
        );
    print(data);
    // partyList?.add(partyType!);
    getPartyList();
    "party type added".successSnackbar;
  }

  addMaterialType({String? materialType}) async {
    var data = await db.into(db.materialType).insert(
          MaterialTypeCompanion.insert(type: materialType.toString()),
        );
    //  var data = await (db.delete(db.materialType)).go();
    //   ..where((tbl) => tbl.id.equals(1)))
    // .go();
    print(data);
    // partyList?.add(partyType!);
    getMaterialTypeList();

    "Material type added".successSnackbar;
  }

  addParty({String? name, int? type}) async {
    var data = await (db.select(db.partyMaster)
          ..where((tbl) => (tbl.name.equals(name!))))
        .get();
    if (data.isEmpty) {
      var data = await db.into(db.partyMaster).insert(
          PartyMasterCompanion.insert(
              name: name.toString(), ptID: type!.toInt()));
      print(data);
      Get.back();
      "party added".successSnackbar;
    } else {
      Get.back();
      "party already exist".errorSnackbar;
    }
  }

  addPartyComission({int? pID, int? mtID, double? newComission}) async {
    print('comissionDetail');

    var data = await db.into(db.partyComissionDetail).insert(
        PartyComissionDetailCompanion.insert(
            pID: pID!.toInt(),
            mtID: mtID!.toInt(),
            comission1: newComission!.toDouble(),
            comission2: 0,
            comission3: 0));

    print(data);
    Get.back();
    "party added".successSnackbar;
  }

  deleteParty({int? id}) async {
    var data = await (db.delete(db.partyMaster)
          ..where((tbl) => tbl.id.equals(id!)))
        .go();

    if (data > 0) {
      Get.back();
      'Party delete Successful'.successSnackbar;
      // print('user not exist');
    } else {
      // print(data);
      'something went wrong!'.errorSnackbar;
    }
  }

  deletePartyComission({int? id}) async {
    var data = await (db.delete(db.partyComissionDetail)
          ..where((tbl) => tbl.id.equals(id!)))
        .go();

    if (data > 0) {
      Get.back();
      'PartyComission delete Successful'.successSnackbar;
      // print('user not exist');
    } else {
      // print(data);
      Get.back();
      'something went wrong!'.errorSnackbar;
    }
  }

  updateParty({
    required int id,
    required String name,
    required int ptID,
    int? phone,
    String? mail,
  }) async {
    try {
      var data = await (db.update(db.partyMaster)
            ..where((tbl) => tbl.id.equals(id)))
          .write(
        PartyMasterData(id: id, name: name, ptID: ptID),
      );
      // print(data.length);
      if (data > 0) {
        'User update Successful'.successSnackbar;
        // print('user not exist');

      } else {
        // print(data);
        Get.back();
        'something went wrong!'.errorSnackbar;
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  updatePartyComission({
    required int mtid,
    required PartyComissionDetailData oldComissionData,
    required int? pID,
    required double newComission,
  }) async {
    try {
      // var data =1;
      var data = await (db.update(db.partyComissionDetail)
            ..where((tbl) => tbl.id.equals(oldComissionData.id)))
          .write(PartyComissionDetailData(
              id: oldComissionData.id,
              pID: pID!,
              mtID: mtid,
              comission1: newComission,
              comission2: oldComissionData.comission1,
              comission3: oldComissionData.comission2));
      // print(data.length);
      if (data > 0) {
        Get.back();
        'PartyComission update Successful'.successSnackbar;
        // print('user not exist');

      } else {
        // print(data);
        Get.back();
        'something went wrong!'.errorSnackbar;
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }
}
