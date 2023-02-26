import 'dart:async';

import 'package:csvapp/utils/extensions.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../database/tables.dart';
import '../../utils/constant.dart';

class PartyController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPartyTypeList();
    getMaterialTypeList();
    // getcomissionDetail();
  }

  Rx<PartyTypeMasterData> defualtPartyType =
      const PartyTypeMasterData(id: 0, type: '').obs;
  Rx<MaterialTypeData> defualtMaterialType =
      const MaterialTypeData(id: 0, type: '').obs;
  final addPartyBtnText = 'Add Party'.obs;
  List<PartyTypeMasterData>? partyTypeList = [];
  List<MaterialTypeData>? materialTypeList = [];
  var dataRowList = [].obs;
  var db = Constantdata.db;

  getPartyTypeList() async {
    partyTypeList?.clear();
    var data = await db.select(db.partyTypeMaster).get();

    partyTypeList?.addAll(data);

    if (partyTypeList!.isNotEmpty) {
      defualtPartyType.value = partyTypeList![0];
    }
  }

  getMaterialTypeList() async {
    materialTypeList?.clear();
    var data = await db.select(db.materialType).get();

    materialTypeList?.addAll(data);

    if (materialTypeList!.isNotEmpty) {
      defualtMaterialType.value = materialTypeList![0];
    }
  }

  Future<bool> checkMaterialType(String mt) async {
    // materialTypeList?.clear();
    var data = await (db.select(db.materialType)
          ..where((tbl) => tbl.type.contains(mt)))
        .get();

    // materialTypeList?.addAll(data);

    if (data.isNotEmpty) {
      return true;
    }
    return false;
  }

  getPartyComissionList({int? pID}) async {
    // partyTypeList?.clear();
    var data = await db.select(db.partyComissionDetail).get();
    // List<DataRow> list = [];
    if (data.isNotEmpty) {
      for (var element in data) {
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
      }
    }
    // return list;
  }

  addPartyType({String? partyType}) async {
    var checkPartyType = await (db.select(db.partyTypeMaster)
          ..where((tbl) => tbl.type.equals(partyType!)))
        .get();
    if (checkPartyType.isNotEmpty) {
      "Party type already exist".errorSnackbar;
      return;
    }
    var data = await db.into(db.partyTypeMaster).insert(
          PartyTypeMasterCompanion.insert(type: partyType.toString()),
        );
    // partyList?.add(partyType!);
    await getPartyTypeList();
    // "party type added".successSnackbar;
    defualtPartyType.refresh();
    'party type added.'.successDailog;
    // "party added".successSnackbar;.
    Timer(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  addMaterialType({String? materialType}) async {
    var checkMaterialType = await (db.select(db.materialType)
          ..where((tbl) => tbl.type.equals(materialType!)))
        .get();
    if (checkMaterialType.isNotEmpty) {
      "Material type already exist".errorSnackbar;
      return;
    }
    var data = await db.into(db.materialType).insert(
          MaterialTypeCompanion.insert(type: materialType.toString()),
        );

    // partyList?.add(partyType!);
    await getMaterialTypeList();

    defualtMaterialType.refresh();

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

      Get.back();
      'party Added.'.successDailog;
      // "party added".successSnackbar;.
      Timer(const Duration(seconds: 2), () {
        Get.back();
      });
    } else {
      Get.back();
      "party already exist".errorSnackbar;
    }
  }

  Future<void> addPartyComission(
      {int? pID,
      int? mtID,
      double? newComission,
      double? materialPrice}) async {
    var data = await (db.select(db.partyComissionDetail)
          ..where((tbl) => tbl.pID.equals(pID!) & tbl.mtID.equals(mtID!)))
        .get();

    if (data.isEmpty) {
      var data = await db
          .into(db.partyComissionDetail)
          .insert(PartyComissionDetailCompanion.insert(
            pID: pID!.toInt(),
            mtID: mtID!.toInt(),
            comission1: newComission!.toDouble(),
            comission2: 0,
            comission3: 0,
            mprice: materialPrice!,
          ));

      Get.back();
      "party added".successSnackbar;
    } else {
      Get.back();

      "partyComission already exist".errorSnackbar;
    }
  }

  deleteParty({int? id}) async {
    var data = await (db.delete(db.partyMaster)
          ..where((tbl) => tbl.id.equals(id!)))
        .go();

    if (data > 0) {
      Get.back();
      'Party delete Successful'.successSnackbar;
      //
    } else {
      //
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
      //
    } else {
      //
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
      //
      if (data > 0) {
        Get.back();
        'User update Successful.'.successDailog;
        // "party added".successSnackbar;.
        Timer(const Duration(seconds: 2), () {
          Get.back();
        });
        // 'User update Successful'.successSnackbar;
        //
      } else {
        //
        Get.back();
        'something went wrong!'.errorSnackbar;
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  updatePartyComission(
      {required int? mtid,
      required PartyComissionDetailData oldComissionData,
      required int? pID,
      required double newComission,
      required double materialPrice}) async {
    try {
      // var data =1;
      var data = await (db.update(db.partyComissionDetail)
            ..where((tbl) => tbl.id.equals(oldComissionData.id)))
          .write(PartyComissionDetailData(
        id: oldComissionData.id,
        pID: pID!,
        mtID: mtid!,
        comission1: newComission,
        comission2: oldComissionData.comission1,
        comission3: oldComissionData.comission2,
        mprice: materialPrice,
      ));
      //
      if (data > 0) {
        Get.back();
        'PartyComission update Successful'.successSnackbar;
        //
      } else {
        //
        Get.back();
        'something went wrong!'.errorSnackbar;
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }
}
