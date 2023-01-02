import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:csvapp/database/tables.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:drift/drift.dart' as d;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';

import '../../utils/constant.dart';

class HomepageController extends GetxController {
  int abc = 0;
  RxList<List<dynamic>> pendingReportData = RxList<List<dynamic>>();
  RxList<String> displayData = RxList<String>();
  RxList<String> partyNaNSetData = RxList<String>();
  RxList<String> comissionAndmatTypeNaNSetData = RxList<String>();
  List<MaterialTypeData>? materialTypeList = [];
  List<PartyMasterData>? partyList = [];
  Rx<PartyMasterData> defualtParty =
      PartyMasterData(id: 0, name: '', ptID: 0).obs;
  String? filePath;
  RxBool isLoading = false.obs;
  RxBool isAllPartySelected = true.obs;
  var db = Constantdata.db;
  var dateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  ).obs;
  // scrollcon

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // getPendingData();
    getPartyList();
  }

  chooseDateRangePicker() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: Get.context!,
        firstDate: DateTime(DateTime.now().year - 2),
        lastDate: DateTime(DateTime.now().year + 2),
        initialDateRange: dateRange.value);

    if (picked != null) {
      dateRange.value = picked;
      print(dateRange.value);
      // getPendingData();
    }
  }

  getPartyList() async {
    partyList?.clear();
    var data = await db.select(db.partyMaster).get();

    partyList?.addAll(data);

    // print(data);
    if (partyList!.isNotEmpty) {
      // print(partyTypeList![0]);
      var defualt = partyList![0].obs;
      defualtParty.value = defualt.value;
      print('defualtParty: ${defualtParty.value}');
    }

    print(partyList);
  }

  Future<void> getSearchData(
      {DateTime? start,
      DateTime? end,
      bool? isAllPartySelected,
      PartyMasterData? selectedParty}) async {
    try {
      isLoading.value = true;
      displayData.clear();
      comissionAndmatTypeNaNSetData.clear();
      partyNaNSetData.clear();
      var serachData = [];
      print('isAllPartySelected: $isAllPartySelected');
      if (isAllPartySelected!) {
        serachData = await (db.select(db.inputData)
              ..where((tbl) => tbl.smtDocDate.isBetweenValues(start!, end!)))
            .get();
        // print(serachData);
      } else {
        serachData = await (db.select(db.inputData)
              ..where((tbl) =>
                  tbl.smtDocDate.isBetweenValues(start!, end!) &
                  tbl.pID.equals(selectedParty!.id)))
            .get();
      }
      print('searchData length');

      pendingReportData.clear();
      List sublist = [];
      sublist.add('Document Type');
      sublist.add('Dist Doc. Date');
      sublist.add('Dist. Document No.');
      sublist.add('Customer');
      sublist.add('Cust. Bill City');
      sublist.add('Mat. Code');
      sublist.add('Mat. Name');
      sublist.add('Mat. Type');
      sublist.add('Quantity');
      sublist.add('Doctor Name');
      sublist.add('Technical Staff');
      sublist.add('Sales Amount');
      sublist.add('Total Sales');
      sublist.add('SMT Doc. Date.');
      sublist.add('SMT Document No.');
      sublist.add('SMT Invoice No.');
      sublist.add('Purchase Taxable');
      sublist.add('Total Purchase');
      pendingReportData.add(sublist);
      print(serachData.length);
      print(pendingReportData.length);

      for (var i = 0; i < serachData.length; i++) {
        var checkParty = await (db.select(db.partyMaster)
              ..where((tbl) => tbl.id.equals(serachData[i].pID)))
            .get();

        if (checkParty.isNotEmpty) {
          var checkMaterialType = await (db.select(db.materialType)
                ..where((tbl) => tbl.id.equals(serachData[i].mtID)))
              .get();
          if (checkMaterialType.isNotEmpty) {
            displayData.add(serachData[i].smtInvNo.toString());
            List sublist = [];

            // print(pendingData[i]);
            sublist.add(serachData[i].documentType);
            sublist.add(
                DateFormat('dd.MM.yyyy').format(serachData[i].distDocDate));
            sublist.add(serachData[i].distDocNo);
            sublist.add(checkParty.first.name);
            sublist.add(serachData[i].custBillCity);
            sublist.add(serachData[i].matCode);
            sublist.add(serachData[i].matName);
            sublist.add(checkMaterialType.first.type);
            sublist.add(serachData[i].qty);
            sublist.add(serachData[i].doctorName);
            sublist.add(serachData[i].techniqalStaff);
            sublist.add(serachData[i].saleAmount);
            sublist.add(serachData[i].totalSale);
            sublist
                .add(DateFormat('dd.MM.yyyy').format(serachData[i].smtDocDate));
            sublist.add(serachData[i].smtDocNo);
            sublist.add(serachData[i].smtInvNo);
            sublist.add(serachData[i].purchaseTaxableAmount);
            sublist.add(serachData[i].totalPurchaseAmount);

            // print(sublist);

            pendingReportData.add(sublist);
          } else {
            comissionAndmatTypeNaNSetData
                .add(serachData[i].smtInvNo.toString());
          }
        } else {
          partyNaNSetData.add(serachData[i].smtInvNo.toString());
        }
      }
      print('Serch Data');
      print(displayData);
      print(partyNaNSetData);
      print(comissionAndmatTypeNaNSetData);
      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;

      e.toString().printError;
    }
  }

  void getPendingData() async {
    // isLoading.value = true;

    displayData.clear();
    comissionAndmatTypeNaNSetData.clear();
    partyNaNSetData.clear();
    var pendingData = await db.select(db.inputData).get();

    print('pendingData length');
    print(pendingData.length);
    List sublist = [];
    sublist.add('Document Type');
    sublist.add('Dist Doc. Date');
    sublist.add('Dist. Document No.');
    sublist.add('Customer');
    sublist.add('Cust. Bill City');
    sublist.add('Mat. Code');
    sublist.add('Mat. Name');
    sublist.add('Mat. Type');
    sublist.add('Quantity');
    sublist.add('Doctor Name');
    sublist.add('Technical Staff');
    sublist.add('Sales Amount');
    sublist.add('Total Sales');
    sublist.add('SMT Doc. Date.');
    sublist.add('SMT Document No.');
    sublist.add('SMT Invoice No.');
    sublist.add('Purchase Taxable');
    sublist.add('Total Purchase');
    pendingReportData.add(sublist);

    for (var i = 0; i < pendingData.length; i++) {
      var checkParty = await (db.select(db.partyMaster)
            ..where((tbl) => tbl.id.equals(pendingData[i].pID)))
          .get();

      if (checkParty.isNotEmpty) {
        var checkMaterialType = await (db.select(db.materialType)
              ..where((tbl) => tbl.id.equals(pendingData[i].mtID)))
            .get();
        if (checkMaterialType.isNotEmpty) {
          displayData.add(pendingData[i].smtInvNo.toString());
          List sublist = [];

          // print(pendingData[i]);
          sublist.add(pendingData[i].documentType);
          sublist
              .add(DateFormat('dd.MM.yyyy').format(pendingData[i].distDocDate));
          sublist.add(pendingData[i].distDocNo);
          sublist.add(checkParty.first.name);
          sublist.add(pendingData[i].custBillCity);
          sublist.add(pendingData[i].matCode);
          sublist.add(pendingData[i].matName);
          sublist.add(checkMaterialType.first.type);
          sublist.add(pendingData[i].qty);
          sublist.add(pendingData[i].doctorName);
          sublist.add(pendingData[i].techniqalStaff);
          sublist.add(pendingData[i].saleAmount);
          sublist.add(pendingData[i].totalSale);
          sublist
              .add(DateFormat('dd.MM.yyyy').format(pendingData[i].smtDocDate));
          sublist.add(pendingData[i].smtDocNo);
          sublist.add(pendingData[i].smtInvNo);
          sublist.add(pendingData[i].purchaseTaxableAmount);
          sublist.add(pendingData[i].totalPurchaseAmount);

          // print(sublist);

          pendingReportData.add(sublist);
        } else {
          comissionAndmatTypeNaNSetData.add(pendingData[i].smtInvNo.toString());
        }
      } else {
        partyNaNSetData.add(pendingData[i].smtInvNo.toString());
      }
    }
    // print(data);
    if (pendingReportData.length == 1) {
      pendingReportData.clear();
    }
    print(displayData);
    print(partyNaNSetData);
    print(comissionAndmatTypeNaNSetData);
    // data.addAll(pendingData);
    // isLoading.value = false;
  }

  void pickFile() async {
    isLoading.value = true;
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) {
      isLoading.value = false;
      return;
    }
    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    filePath = result.files.first.path!;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    // print(fields[0].length);
    print(fields.length);
    if (fields[0].length != 18) {
      'Invalid File'.errorSnackbar;
      isLoading.value = false;
      return;
    }
    // displyaData.addAll(fields);
    // print(displyaData);
    await checkInputData(fields: fields);
  }

  Future<void> checkInputData({List<List<dynamic>>? fields}) async {
    isLoading.value = true;
    partyList = await db.select(db.partyMaster).get();
    defualtParty.value = partyList![0];
    materialTypeList = await db.select(db.materialType).get();
    // .value = materialTypeList![0];

    for (var i = 1; i < fields!.length; i++) {
      await addInputData(fields[i]);
    }
    // addInputData(fields[1]);
    // displayData.clear();
    // partyNaNSetData.clear();
    // comissionAndmatTypeNaNSetData.clear();
    print('Display Data');
    print(displayData.length);
    print(displayData);
    print('Party NaN Data');
    print(partyNaNSetData.length);
    print(partyNaNSetData);
    print('comission & matType Data');
    print(comissionAndmatTypeNaNSetData.length);
    print(comissionAndmatTypeNaNSetData);
    print('data assigend');
    pendingReportData.clear();
    pendingReportData.addAll(fields);
    print(pendingReportData.length);
    isLoading.value = false;
  }

  Future<void> addInputData(List<dynamic> data) async {
    try {
      print('******************new data******************');
      var resParty = await (db.select(db.partyMaster)
            ..where((tbl) => tbl.name.equals(data[3])))
          .get();

      if (resParty.isNotEmpty) {
        materialTypeList?.clear();
        materialTypeList = await (db.select(db.materialType)
              ..where((tbl) => tbl.type.equals(data[7])))
            .get();
        print(data[7]);
        if (materialTypeList!.isNotEmpty) {
          var resPartyComission = await (db.select(db.partyComissionDetail)
                ..where((tbl) =>
                    tbl.pID.equals(resParty[0].id) &
                    tbl.mtID.equals(materialTypeList![0].id)))
              .get();
          if (resPartyComission.isNotEmpty) {
            displayData.add(data[15].toString());
            var comission = resPartyComission[0].comission1;
            print('comission(%): $comission');
            print('TotalAmount(%): ${data[12]}');
            print('comissionAmount(%): ${(comission * data[12]) / 100}');
          } else {
            // print(displyaData.length);
            // displyaData.remove(data);

            // print(displyaData.length);
            comissionAndmatTypeNaNSetData.add(data[15].toString());
            'Comission Not Found'.errorSnackbar;
            print('Comission Not Found');
          }
        } else {
          // print(displyaData.length);
          // displyaData.remove(data);
          // print(displyaData.length);
          comissionAndmatTypeNaNSetData.add(data[15].toString());
          'Material Type Not Found'.errorSnackbar;
          print('Material Type Not Found');
        }
      } else {
        // print(displyaData.length);
        // displyaData.remove(data);
        // print(displyaData.length);
        partyNaNSetData.add(data[15].toString());
        print('${data[3]} Party Not Found');
        '${data[3]} Party Not Found'.errorSnackbar;
      }
    } catch (e) {
      printError(info: e.toString());
      e.toString().errorSnackbar;
    }
  }

  Future<void> generateComissionReport(
      {List<List<dynamic>>? data, DateTime? start, DateTime? end}) async {
    try {
      print('generateComissionReport');
      print(data);
      print(data?.length);
      var data1 = await db.select(db.inputData).get();
      print(data1);

      final count = (db.inputData.saleAmount.count());
      print('count');
      print(count);
      final sum = db.inputData.saleAmount.sum();
      print('sum');
      print(sum);
      final avgLength = db.inputData.saleAmount.max();
      print('avg');
      print(avgLength);
      var data2 = await (db.select(db.inputData)
            ..addColumns([count, sum, avgLength]))
          .get();
      print(data2);

      // var data = db.select(db.inputData).get();

      print('done');
    } catch (e) {
      printError(info: e.toString());
      e.toString().errorSnackbar;
    }
  }

  Future<void> insertData(List<List<dynamic>> data) async {
    try {
      print(data.length);
      partyList = await (db.select(db.partyMaster)).get();
      materialTypeList = await (db.select(db.materialType)).get();
      print(partyList);
      print(materialTypeList);

      for (var i = 1; i < data.length; i++) {
        print(i);
        String documentType = data[i][0];
        DateTime distDocDate =
            DateFormat("dd.MM.yyyy").parse(data[i][1].toString());
        String distDocNo = data[i][2];
        var customer = data[i][3];
        String custBillCity = data[i][4];
        String matCode = data[i][5];
        String matName = data[i][6];
        String matType = data[i][7];
        int qty = data[i][8];
        String doctorName = data[i][9];
        String techniqalStaff = data[i][10];
        double saleAmount = double.parse((data[i][11]).toString());
        double totalSale = double.parse((data[i][12]).toString());
        DateTime smtDocDate =
            DateFormat("dd.MM.yyyy").parse(data[i][13].toString());
        String smtDocNo = (data[i][14]).toString();
        String smtInvNo = (data[i][15]).toString();
        double purchaseTaxableAmount = double.parse(data[i][16].toString());
        double totalPurchaseAmount = double.parse(data[i][17].toString());
        int logId = 0;
        int ledgerId = 0;
        double comission = 0;
        double comissionAmount = 0;
        DateTime comissionPaidDate = DateTime.now();
        double adjustComissionAmount = 0;
        // int? logId ;
        // print(distDocDate);
        // print(smtDocDate);

        var pID =
            partyList!.firstWhere((element) => element.name == customer).id;
        var mtID = materialTypeList!
            .firstWhere((element) => element.type == matType)
            .id;
        // print(pID);
        // print(mtID);
        var res = await (db.select(db.inputData)
              ..where((tbl) => tbl.smtInvNo.equals(smtInvNo)))
            .get();
        if (res.isEmpty) {
          var result =
              await db.into(db.inputData).insert(InputDataCompanion.insert(
                    documentType: documentType,
                    distDocDate: distDocDate,
                    distDocNo: distDocNo,
                    pID: pID,
                    custBillCity: custBillCity,
                    matCode: matCode,
                    matName: matName,
                    mtID: mtID,
                    qty: qty,
                    doctorName: doctorName,
                    techniqalStaff: techniqalStaff,
                    saleAmount: saleAmount,
                    totalSale: totalSale,
                    smtDocDate: smtDocDate,
                    smtDocNo: smtDocNo,
                    smtInvNo: smtInvNo,
                    purchaseTaxableAmount: purchaseTaxableAmount,
                    totalPurchaseAmount: totalPurchaseAmount,
                    logId: logId,
                    ledgerId: ledgerId,
                    comission: comission,
                    comissionAmount: comissionAmount,
                    comissionPaidDate: comissionPaidDate,
                    adjustComissionAmount: adjustComissionAmount,
                  ));
          print(result);
        } else {
          print('already exist');
          print(smtInvNo);
        }
      }
      // var res = await db.select(db.inputData).get();

      print('done');

      //
    } catch (e) {
      printError(info: e.toString());
      e.toString().errorSnackbar;
    }
  }
}
