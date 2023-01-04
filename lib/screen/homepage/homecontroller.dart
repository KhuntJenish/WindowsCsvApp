import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csvapp/database/tables.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:drift/drift.dart' as d;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../utils/constant.dart';

class HomepageController extends GetxController {
  int abc = 0;
  RxList<List<dynamic>> pendingReportData = RxList<List<dynamic>>();
  RxList<List<dynamic>> generatedReportData = RxList<List<dynamic>>();
  RxList<LedgerData> ledgerReportData = RxList<LedgerData>();
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
  RxDouble partyWiseTotalAmount = 0.0.obs;
  RxDouble partyWisePaidAmount = 0.0.obs;
  RxDouble partyWisePayableAmount = 0.0.obs;
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

  Future<void> getPendingSearchData(
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
              ..where((tbl) =>
                  tbl.smtDocDate.isBetweenValues(start!, end!) &
                  tbl.logId.equals(0)))
            .get();
        // print(serachData);
      } else {
        serachData = await (db.select(db.inputData)
              ..where((tbl) =>
                  tbl.smtDocDate.isBetweenValues(start!, end!) &
                  tbl.pID.equals(selectedParty!.id) &
                  tbl.logId.equals(0)))
            .get();
      }
      print('Pending searchData length');

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

  Future<void> getLedgerSearchData(
      {DateTime? start,
      DateTime? end,
      bool? isAllPartySelected,
      PartyMasterData? selectedParty}) async {
    try {
      isLoading.value = true;
      ledgerReportData.clear();
      print('ledgerSearchData : ');
      List<LedgerData> ledgerData = [];
      if (isAllPartySelected!) {
        ledgerData = await (db.select(db.ledger)
              ..where((tbl) => tbl.ledgerDate.isBetweenValues(start!, end!)))
            .get();
      } else {
        ledgerData = await (db.select(db.ledger)
              ..where((tbl) =>
                  tbl.ledgerDate.isBetweenValues(start!, end!) &
                  tbl.pID.equals(selectedParty!.id)))
            .get();
      }

      ledgerReportData.addAll(ledgerData);
      print(ledgerReportData);
      print(ledgerReportData.length);

      // print(ledgerReportData.value.length);
      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;

      e.toString().printError;
    }
  }

  Future<void> getGeneratedSearchData(
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
              ..where((tbl) =>
                  tbl.smtDocDate.isBetweenValues(start!, end!) &
                  tbl.logId.isBiggerThanValue(0)))
            .get();
        // print(serachData);
      } else {
        serachData = await (db.select(db.inputData)
              ..where((tbl) =>
                  tbl.smtDocDate.isBetweenValues(start!, end!) &
                  tbl.pID.equals(selectedParty!.id) &
                  tbl.logId.isBiggerThanValue(0)))
            .get();
        var ledger = await (db.select(db.inputData)
              ..where((tbl) =>
                  tbl.comissionPaidDate
                      .isBiggerThanValue(DateTime(1800, 01, 01)) &
                  tbl.pID.equals(selectedParty!.id) &
                  tbl.logId.isBiggerThanValue(0)))
            .get();
        partyWisePaidAmount.value = 0;
        partyWiseTotalAmount.value = 0;
        partyWisePayableAmount.value = 0;
        for (var element in ledger) {
          partyWisePaidAmount.value += element.comissionAmount;
        }
        print(ledger);
        print(partyWisePaidAmount.value);
      }
      print('Generated searchData length');

      generatedReportData.clear();
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
      sublist.add('Comission(%)');
      sublist.add('Comission Amount');
      generatedReportData.add(sublist);
      print(serachData.length);
      print(generatedReportData.length);

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
            sublist.add(serachData[i].comission);
            sublist.add(serachData[i].comissionAmount);
            sublist.add(serachData[i].comissionPaidDate);

            // print(sublist);

            generatedReportData.add(sublist);

            if (!isAllPartySelected) {
              partyWiseTotalAmount.value = partyWiseTotalAmount.value +
                  double.parse(serachData[i].comissionAmount.toString());
            }
          } else {
            comissionAndmatTypeNaNSetData
                .add(serachData[i].smtInvNo.toString());
          }
        } else {
          partyNaNSetData.add(serachData[i].smtInvNo.toString());
        }
      }
      print('Serch Data');
      // print('PartyWiseTotalAmount' + partyWiseTotalAmount.value.toString());
      print(displayData);
      print(partyNaNSetData);
      print(comissionAndmatTypeNaNSetData);
      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;

      e.toString().printError;
    }
  }

  Future<void> partyWisePayment({
    required PartyMasterData? selectedParty,
    required double? crAmount,
    // String? ledgerNote,
  }) async {
    try {
      isLoading.value = true;

      var ledgerData = await db.into(db.ledger).insert(LedgerCompanion.insert(
          type: Constantdata.payment,
          pID: selectedParty!.id,
          ledgerDate: DateTime.now(),
          drAmount: 0,
          crAmount: crAmount!,
          ledgerNote: Constantdata.defualtNote));
      print('Generated Report Data Length');
      print(generatedReportData);

      // print(data);
      if (ledgerData > 0) {
        List<String> smtInvNoList = [];
        for (var i = 1; i < generatedReportData.length; i++) {
          smtInvNoList.add(generatedReportData[i][15].toString());
        }
        print(smtInvNoList);
        var inputDatadata = await (db.select(db.inputData)
              ..where((tbl) => tbl.smtInvNo.isIn(smtInvNoList)))
            .get();
        print(inputDatadata);
        for (var i = 0; i < inputDatadata.length; i++) {
          print(inputDatadata[i].smtInvNo);
          var updateRes = await (db.update(db.inputData)
                ..where((tbl) => tbl.id.equals(inputDatadata[i].id)))
              .write(InputDataData(
                  id: inputDatadata[i].id,
                  documentType: inputDatadata[i].documentType,
                  distDocDate: inputDatadata[i].distDocDate,
                  distDocNo: inputDatadata[i].distDocNo,
                  pID: inputDatadata[i].pID,
                  custBillCity: inputDatadata[i].custBillCity,
                  matCode: inputDatadata[i].matCode,
                  matName: inputDatadata[i].matName,
                  mtID: inputDatadata[i].mtID,
                  qty: inputDatadata[i].qty,
                  doctorName: inputDatadata[i].doctorName,
                  techniqalStaff: inputDatadata[i].techniqalStaff,
                  saleAmount: inputDatadata[i].saleAmount,
                  totalSale: inputDatadata[i].totalSale,
                  smtDocDate: inputDatadata[i].smtDocDate,
                  smtDocNo: inputDatadata[i].smtDocNo,
                  smtInvNo: inputDatadata[i].smtInvNo,
                  purchaseTaxableAmount: inputDatadata[i].purchaseTaxableAmount,
                  totalPurchaseAmount: inputDatadata[i].totalPurchaseAmount,
                  logId: inputDatadata[i].logId,
                  ledgerId: inputDatadata[i].ledgerId,
                  comission: inputDatadata[i].comission,
                  comissionAmount: inputDatadata[i].comissionAmount,
                  comissionPaidDate: DateTime.now(),
                  adjustComissionAmount:
                      inputDatadata[i].adjustComissionAmount));
          print(updateRes);
        }
        // Get.back();
        'Payment Added Successfully'.successSnackbar;
      } else {
        // Get.back();
        'Payment Not Added'.errorSnackbar;
      }

      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;

      e.toString().printError;
    }
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
    if (partyList!.isNotEmpty) {
      defualtParty.value = partyList![0];
    }
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
      isLoading.value = true;
      print('generateComissionReport');
      print(data);
      // print(data?.length);
      Set<int> partySet = {};
      List partyTotalComissionSet = [];
      List<List<String>> partyWiseList = [];
      GetStorage('box').write('logID', 0);
      var logID = GetStorage('box').read('logID') ?? 0;
      print('prevID :' + logID.toString());
      GetStorage('box').write('logID', logID + 1);
      print(dateRange.value.start);
      print(dateRange.value.end);
      var pendingData = await (db.select(db.inputData)
            ..where((tbl) => tbl.logId.equals(0)))
          .get();
      print(pendingData);
      var totalComission = 0;
      for (var element in pendingData) {
        var checkParty = await (db.select(db.partyMaster)
              ..where((tbl) => tbl.id.equals(element.pID)))
            .get();

        if (checkParty.isNotEmpty) {
          var checkMaterialType = await (db.select(db.materialType)
                ..where((tbl) => tbl.id.equals(element.mtID)))
              .get();
          if (checkMaterialType.isNotEmpty) {
            var resPartyComission = await (db.select(db.partyComissionDetail)
                  ..where((tbl) =>
                      tbl.pID.equals(checkParty[0].id) &
                      tbl.mtID.equals(checkMaterialType[0].id)))
                .get();
            if (resPartyComission.isNotEmpty) {
              // displayData.add(data[15].toString());
              var comission = resPartyComission[0].comission1;
              var comissionAmount = double.parse(
                  ((comission * element.totalSale) / 100).toStringAsFixed(2));
              var logID = GetStorage('box').read('logID');
              print('logID: $logID');
              print('pname: ${checkParty[0].name}');
              if (partySet.contains(element.pID)) {
                int index = partySet
                    .toList()
                    .indexWhere((item) => item.isEqual(element.pID));
                print(index);
                var oldCommision = partyTotalComissionSet.elementAt(index);
                print(oldCommision);
                partyTotalComissionSet[index] = oldCommision + comissionAmount;
                partyWiseList[index].add(element.smtInvNo);

                print(partyWiseList);
                print(partyTotalComissionSet.toList());
                // partyTotalComissionSet.add(comissionAmount);
              } else {
                partySet.add(element.pID);
                int index = partySet
                    .toList()
                    .indexWhere((item) => item.isEqual(element.pID));
                print(index);
                partyTotalComissionSet.insert(index, comissionAmount);
                List<String> party = [];
                party.add(element.smtInvNo);
                partyWiseList.insert(index, party);
                // partyTotalComissionSet.elementAt(index);
                print(partyWiseList);
                print(partyTotalComissionSet.toList());
                print(partySet);
              }
              var resComissionUpdate = await (db.update(db.inputData)
                    ..where((tbl) => tbl.id.equals(element.id)))
                  .write(InputDataData(
                      id: element.id,
                      documentType: element.documentType,
                      distDocDate: element.distDocDate,
                      distDocNo: element.distDocNo,
                      pID: element.pID,
                      custBillCity: element.custBillCity,
                      matCode: element.matCode,
                      matName: element.matName,
                      mtID: element.mtID,
                      qty: element.qty,
                      doctorName: element.doctorName,
                      techniqalStaff: element.techniqalStaff,
                      saleAmount: element.saleAmount,
                      totalSale: element.totalSale,
                      smtDocDate: element.smtDocDate,
                      smtDocNo: element.smtDocNo,
                      smtInvNo: element.smtInvNo,
                      purchaseTaxableAmount: element.purchaseTaxableAmount,
                      totalPurchaseAmount: element.totalPurchaseAmount,
                      logId: logID,
                      ledgerId: element.ledgerId,
                      comission: comission,
                      comissionAmount: comissionAmount,
                      comissionPaidDate: element.comissionPaidDate,
                      adjustComissionAmount: element.adjustComissionAmount));
              print(resComissionUpdate);
              print('comission(%): $comission');
              print('TotalAmount(%): ${element.totalSale}');
              print('comissionAmount(%): ${comissionAmount}');
              print('************');
            }
          } else {
            comissionAndmatTypeNaNSetData.add(element.smtInvNo.toString());
          }
        } else {
          partyNaNSetData.add(element.smtInvNo.toString());
        }
      }
      print('done');
      List ledgerIDList = [];

      for (var i = 0; i < partySet.length; i++) {
        print('ledgerID: ${i + 1}');
        var pID = partySet.elementAt(i);
        print(partySet.elementAt(i));
        var totalComission = partyTotalComissionSet.elementAt(i);
        print(partyTotalComissionSet.elementAt(i));
        var resLedger = await db.into(db.ledger).insert(LedgerCompanion.insert(
              type: 'sale commission',
              pID: pID,
              ledgerDate: DateTime.now(),
              drAmount: totalComission,
              crAmount: 0,
              ledgerNote: Constantdata.defualtNote,
            ));
        print(resLedger);
        ledgerIDList.add(resLedger);
      }

      for (var i = 0; i < partyWiseList.length; i++) {
        var element = partyWiseList[i];
        for (var j = 0; j < element.length; j++) {
          var data = await (db.select(db.inputData)
                ..where((tbl) => tbl.smtInvNo.equals(element[j])))
              .get();
          print(element[j]); //smtInvNo
          print(data[0]); // smtInvNo-data
          print(ledgerIDList[i]); //ledgerID
          var resUpdate = await (db.update(db.inputData)
                ..where((tbl) => tbl.smtInvNo.equals(element[j])))
              .write(InputDataData(
                  id: data[0].id,
                  documentType: data[0].documentType,
                  distDocDate: data[0].distDocDate,
                  distDocNo: data[0].distDocNo,
                  pID: data[0].pID,
                  custBillCity: data[0].custBillCity,
                  matCode: data[0].matCode,
                  matName: data[0].matName,
                  mtID: data[0].mtID,
                  qty: data[0].qty,
                  doctorName: data[0].doctorName,
                  techniqalStaff: data[0].techniqalStaff,
                  saleAmount: data[0].saleAmount,
                  totalSale: data[0].totalSale,
                  smtDocDate: data[0].smtDocDate,
                  smtDocNo: data[0].smtDocNo,
                  smtInvNo: data[0].smtInvNo,
                  purchaseTaxableAmount: data[0].purchaseTaxableAmount,
                  totalPurchaseAmount: data[0].totalPurchaseAmount,
                  logId: data[0].logId,
                  ledgerId: ledgerIDList[i],
                  comission: data[0].comission,
                  comissionAmount: data[0].comissionAmount,
                  comissionPaidDate: data[0].comissionPaidDate,
                  adjustComissionAmount: data[0].adjustComissionAmount));
          print(resUpdate);
          print('update record');
        }
      }

      // var data = db.select(db.inputData).get();
      pendingReportData.clear();
      isLoading.value = true;
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
