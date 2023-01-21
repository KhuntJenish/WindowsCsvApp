import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:csvapp/theam/theam_constants.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:drift/drift.dart' as d;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constant.dart';

class HomepageController extends GetxController {
  PageController pageController = PageController(initialPage: 0);
  PartyController partyController = Get.put(PartyController());
  RxInt isSelectedReport = 0.obs;
  RxInt isNumber = 0.obs;

  RxList<List<dynamic>> pendingReportData = RxList<List<dynamic>>();
  RxList<List<dynamic>> generatedReportData = RxList<List<dynamic>>();
  RxList<LedgerData> ledgerReportData = RxList<LedgerData>();
  RxList<String> displayData = RxList<String>();
  RxList<String> partyNaNSetData = RxList<String>();
  RxList<String> durationList = RxList<String>([
    'One Month',
    'Four Month',
    'Six Month',
    'One Year',
    'Custom',
  ]);
  RxSet<String> partyCityList = RxSet<String>();
  RxList<String> comissionAndmatTypeNaNSetData = RxList<String>();
  List<MaterialTypeData>? materialTypeList = [];
  List<PartyMasterData>? partyList = [];
  Set ledgerPartyWiseSet = Set();
  RxSet<String> smtInvNoSet = RxSet<String>();
  Rx<PartyMasterData> defualtParty =
      const PartyMasterData(id: 0, name: '', ptID: 0).obs;
  Rx<String> defualtPartyCity = ''.obs;
  Rx<String> defualtDuration = 'One Month'.obs;
  Rx<MaterialTypeData> defualtMaterialType =
      const MaterialTypeData(id: 0, type: '').obs;
  String? filePath;
  RxBool isLoading = false.obs;
  RxBool isAllPartySelected = true.obs;
  RxBool isAllMaterialTypeSelected = true.obs;
  RxBool isAllPartyCitySelected = true.obs;
  RxDouble partyWiseTotalAmount = 0.0.obs;
  RxDouble partyWisePaidAmount = 0.0.obs;
  RxDouble partyWisePayableAmount = 0.0.obs;
  var db = Constantdata.db;
  var dateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  ).obs;
  List<int> rightalign = [8, 11, 12, 16, 17, 18, 19];
  // scrollcon

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getPartyList();
    getMaterialTypeList();
    getPartyCityList();
    print('Report val: ${GetStorage('box').read('isSelectedReport')}');
    if (GetStorage('box').read('isSelectedReport') != null) {
      isSelectedReport.value = GetStorage('box').read('isSelectedReport');
    } else {
      isSelectedReport.value = 0;
      GetStorage('box').write('isSelectedReport', 0);
    }
    // print('Homecontroller onInit');
  }

  getDurationDateRange({required String? duration}) {
    switch (duration) {
      case 'One Month':
        DateTime last = DateTime(DateTime.now().year, DateTime.now().month, 1)
            .subtract(const Duration(days: 1));
        DateTimeRange tempDateRange = DateTimeRange(
          start: DateTime(last.year, last.month, 1),
          end: last,
        );
        print(tempDateRange);
        dateRange.value = tempDateRange;
        break;
      case 'Four Month':
        DateTime last = DateTime(DateTime.now().year, DateTime.now().month, 1)
            .subtract(const Duration(days: 1));
        DateTimeRange tempDateRange = DateTimeRange(
          start: DateTime(last.year, last.month - 3, 1),
          end: last,
        );
        print(tempDateRange);
        dateRange.value = tempDateRange;
        break;
      case 'Six Month':
        DateTime last = DateTime(DateTime.now().year, DateTime.now().month, 1)
            .subtract(const Duration(days: 1));
        DateTimeRange tempDateRange = DateTimeRange(
          start: DateTime(last.year, last.month - 5, 1),
          end: last,
        );
        print(tempDateRange);
        dateRange.value = tempDateRange;
        break;
      case 'One Year':
        DateTime last = DateTime(DateTime.now().year, DateTime.now().month, 1)
            .subtract(const Duration(days: 1));
        DateTimeRange tempDateRange = DateTimeRange(
          start: last.month == 12
              ? DateTime(last.year, 1, 1)
              : DateTime(last.year - 1, last.month, 1),
          end: last,
        );
        print(tempDateRange);
        dateRange.value = tempDateRange;
        break;
      default:
    }
  }

  createReportPdf() async {
    try {
      isLoading.value = true;
      final pdf = pw.Document();
      List<List<dynamic>> list = [];
      for (var i = 0; i < generatedReportData.length; i++) {
        List subList = [];
        subList.add(generatedReportData[i][3].toString());
        subList.add(generatedReportData[i][4].toString());
        subList.add(generatedReportData[i][6].toString());
        subList.add(generatedReportData[i][7].toString());
        subList.add(generatedReportData[i][12].toString());
        subList.add(generatedReportData[i][13].toString());
        subList.add(generatedReportData[i][15].toString());
        subList.add(generatedReportData[i][18].toString());
        subList.add(generatedReportData[i][19].toString());
        // print(subList);
        list.add(subList);
      }
      print(list);
      print(list.length);

      int a = 0;
      List<List<dynamic>> newList = [];
      List<List<List<dynamic>>> mainList = [];
      double saletotal = 0;
      List<double> saletotalList = [];

      double comissiontotal = 0;
      List<double> comissiontotalList = [];
      for (var i = 0; i < list.length; i++) {
        if (a < 15) {
          newList.add(list[i]);
          if (i > 0) {
            saletotal = saletotal + double.parse(list[i][4].toString());
            comissiontotal =
                comissiontotal + double.parse(list[i][8].toString());
            print(saletotal);
            print(comissiontotal);
          }
          a++;
          if (a >= list.length) {
            saletotalList.add(saletotal);
            comissiontotalList.add(comissiontotal);
            newList.add([
              'Total',
              '',
              '',
              '',
              saletotal.toStringAsFixed(2),
              '',
              '',
              '',
              comissiontotal.toStringAsFixed(2)
            ]);
            print(newList);
            print(newList.length);
            mainList.add(newList);

            saletotal = 0;
            comissiontotal = 0;
            saletotalList = [];
            comissiontotalList = [];
            print('half record');
          }
        } else {
          saletotalList.add(saletotal);
          comissiontotalList.add(comissiontotal);
          newList.add([
            'Total',
            '',
            '',
            '',
            saletotal.toStringAsFixed(2),
            '',
            '',
            '',
            comissiontotal.toStringAsFixed(2)
          ]);
          print(newList);
          print(newList.length);

          mainList.add(newList);
          saletotal = 0;
          // saletotalList = [];
          // comissiontotalList = [];
          comissiontotal = 0;
          newList = [];

          a = 0;
        }
      }
      if (mainList.length > 1) {
        print(mainList);
        List<List<dynamic>> lastList = [];
        lastList.addAll(mainList.elementAt(mainList.length - 1));
        print(saletotalList);
        print(comissiontotalList);
        for (var i = 0; i < saletotalList.length; i++) {
          saletotal = saletotal + saletotalList[i];
          comissiontotal = comissiontotal + comissiontotalList[i];
        }

        lastList.add([
          'Grant_Total',
          '',
          '',
          '',
          saletotal.toStringAsFixed(2),
          '',
          '',
          '',
          comissiontotal.toStringAsFixed(2)
        ]);
        print(mainList);
        mainList.removeLast();
        print(mainList);
        mainList.add(lastList);
        print(mainList);
      }

      for (var i = 0; i < mainList.length; i++) {
        pdf.addPage(
          pw.Page(
            margin:
                const pw.EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Table.fromTextArray(
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(1),
                      2: const pw.FlexColumnWidth(1),
                      3: const pw.FlexColumnWidth(1),
                      4: const pw.FlexColumnWidth(1),
                      5: const pw.FlexColumnWidth(1),
                      6: const pw.FlexColumnWidth(1.2),
                      7: const pw.FlexColumnWidth(1),
                      8: const pw.FlexColumnWidth(1),
                    },
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.centerLeft,
                      3: pw.Alignment.centerLeft,
                      4: pw.Alignment.centerRight,
                      5: pw.Alignment.centerLeft,
                      6: pw.Alignment.centerLeft,
                      7: pw.Alignment.centerRight,
                      8: pw.Alignment.centerRight,
                    },
                    headerAlignments: {
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                      4: pw.Alignment.center,
                      5: pw.Alignment.center,
                      6: pw.Alignment.center,
                      7: pw.Alignment.center,
                      8: pw.Alignment.center,
                    },
                    context: context,
                    data: mainList[i],
                    cellStyle: const pw.TextStyle(fontSize: 7),
                    headerStyle: pw.TextStyle(
                        fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ); // Center
            },
          ),
        );
      }

      final filename = "invoice_${DateTime.now().microsecond}_$isNumber.pdf";
      final output = await getDownloadsDirectory();
      final file = File("${output?.path}\\$filename");
      print(file.path);
      // final file = File("example.pdf");
      await file.writeAsBytes(await pdf.save());
      print('save');
      // 'pdf Download SuccessFull.😀'.successSnackbar;
      'pdf Download SuccessFull.😀'.successDailog;
      Timer(Duration(seconds: 2), () {
        Get.back();
      });
      // final String filePath = testFile.absolute.path;
      final Uri uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        // print("launch url : $uri");
        await launchUrl(uri);
      } else {
        print("cannot launch url : $uri");
      }
      isNumber.value++;
      isLoading.value = false;
    } catch (e) {
      print(e);
      e.toString().errorSnackbar;
    }
  }

  createLedgerPdf({required Set partyWiseList}) async {
    try {
      isLoading.value = true;
      final pdf = pw.Document();
      print(partyWiseList);
      debugPrint(partyWiseList.length.toString());
      List<List<List<dynamic>>> superMainList = [];
      List<List<dynamic>> newMainList = [];
      List<List<dynamic>> tempMainList = [];
      for (var i = 0; i < partyWiseList.length; i++) {
        print(partyWiseList.elementAt(i));
        print(partyWiseList.elementAt(i)[0].pID);
        // print(partyList);
        var partyName = partyList
            ?.firstWhere((element) =>
                element.id.isEqual(partyWiseList.elementAt(i)[0].pID))
            .name;
        print(partyName);
        List newList = [];
        List<List<dynamic>> newsubList = [];
        newList.addAll(partyWiseList.elementAt(i));
        newsubList.add([
          '$partyName',
          '',
          '',
          '',
        ]);
        newsubList.add([
          'Date',
          'Type',
          'Dr Amount',
          'Cr Amount',
        ]);
        for (var j = 0; j < newList.length; j++) {
          print(newList[j]);

          var drAmount = newList[j].drAmount.toDouble();
          var crAmount = newList[j].crAmount.toDouble();
          var date = DateTime.parse(newList[j].ledgerDate.toString());
          print(newList[j].drAmount);
          newsubList.add([
            date == DateTime(1800, 01, 01)
                ? ''
                : DateFormat('dd-MM-yyyy').format(date),
            newList[j].type.toString(),
            drAmount < 1 ? '' : drAmount.toStringAsFixed(2),
            crAmount < 1 ? '' : crAmount.toStringAsFixed(2)
          ]);
        }
        print(newsubList);
        newList.clear();
        newMainList.addAll(newsubList);
      }
      print(newMainList);
      tempMainList.addAll(newMainList);
      int a = 0;
      newMainList.clear();
      for (var i = 0; i < tempMainList.length; i++) {
        if (((i + 1) % 26) == 0) {
          // a++;
          print(i);
          newMainList.add(tempMainList[i]);

          print(newMainList.length);
          List<List<dynamic>> temp = [];
          temp.addAll(newMainList);
          superMainList.add(temp);
          newMainList.clear();

          print('hello');
        } else {
          newMainList.add(tempMainList[i]);
          if (i == (tempMainList.length - 1)) {
            List<List<dynamic>> temp = [];
            temp.addAll(newMainList);
            superMainList.add(temp);
            newMainList.clear();
          }
          print('$i --');
        }
      }
      print(superMainList);
      for (var i = 0; i < superMainList.length; i++) {
        pdf.addPage(
          pw.Page(
            margin: const pw.EdgeInsets.all(8),
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  // pw.Text('Party Name: $partyName'),
                  pw.SizedBox(height: Get.height * 0.01),

                  pw.SizedBox(height: Get.height * 0.01),
                  pw.Container(
                    // color: PdfColors.grey,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: pw.Table.fromTextArray(
                        columnWidths: {
                          0: const pw.FlexColumnWidth(1),
                          1: const pw.FlexColumnWidth(1.5),
                          2: const pw.FlexColumnWidth(1),
                          3: const pw.FlexColumnWidth(1),
                        },
                        cellAlignments: {
                          0: pw.Alignment.centerLeft,
                          1: pw.Alignment.centerLeft,
                          2: pw.Alignment.centerRight,
                          3: pw.Alignment.centerRight,
                        },
                        headerAlignments: {
                          0: pw.Alignment.center,
                          1: pw.Alignment.center,
                          2: pw.Alignment.center,
                          3: pw.Alignment.center,
                        },
                        context: context,
                        data: superMainList[i],
                        cellStyle: const pw.TextStyle(fontSize: 10),
                        headerStyle: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ); // Center
            },
          ),
        );
      }

      final output = await getDownloadsDirectory();
      final file = File(
          "${output?.path}\\ledgerReport_${DateTime.now().microsecond}_$isNumber.pdf");
      print(file.path);
      // final file = File("example.pdf");
      await file.writeAsBytes(await pdf.save());
      print('save');
      // 'pdf Download SuccessFull.😀'.successSnackbar;
      'pdf Download SuccessFull.😀'.successDailog;
      Timer(Duration(seconds: 2), () {
        Get.back();
      });
      final Uri uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        // print("launch url : $uri");
        await launchUrl(uri);
      } else {
        print("cannot launch url : $uri");
      }
      isNumber.value++;
      isLoading.value = false;
    } catch (e) {
      print(e);
      e.toString().errorSnackbar;
    }
  }

  chooseDateRangePicker() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: Get.context!,
        firstDate: DateTime(DateTime.now().year - 2),
        lastDate: DateTime(DateTime.now().year + 2),
        initialDateRange: dateRange.value,
        initialEntryMode: DatePickerEntryMode.input,
        locale: const Locale('en', 'IN'),
        builder: (context, child) {
          return Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500.0,
                  // maxHeight: 400.0,
                ),
                child: child,
              )
            ],
          );
        });
    // );

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

  getPartyCityList() async {
    partyCityList.clear();
    var data = await db.select(db.inputData).get();

    for (var element in data) {
      partyCityList.add(element.custBillCity);
    }

    // print(data);
    if (partyCityList.isNotEmpty) {
      // print(partyTypeList![0]);
      var defualt = partyCityList.toList();
      defualtPartyCity.value = defualt[0];
      print('defualtParty: ${defualtParty.value}');
    }

    print(partyCityList);
  }

  getMaterialTypeList() async {
    materialTypeList?.clear();
    var data = await db.select(db.materialType).get();

    materialTypeList?.addAll(data);

    // print(data);
    if (materialTypeList!.isNotEmpty) {
      // print(partyTypeList![0]);

      defualtMaterialType.value = materialTypeList![0];
      print('defualtParty: ${defualtMaterialType.value}');
    }

    print(materialTypeList);
  }

  reversePaymentProcess(String smtInvNo, double crAmount) async {
    try {
      print('smtInvNo: $smtInvNo');
      print('amount: $crAmount');
      var data = await (db.select(db.inputData)
            ..where((tbl) => tbl.smtInvNo.equals(smtInvNo)))
          .getSingle();

      print('logID : ${data.logId}');
      print('ledgerID : ${data.generateLedgerId}');
      if (data.generateLedgerId != 0) {
        var ledgerData2 = await (db.select(db.ledger)
              ..where((tbl) => tbl.ledgerDate.equals(data.comissionPaidDate)))
            .getSingle();

        // print('ledgerData: $ledgerData1');
        print('ledgerData: $ledgerData2');
        if (ledgerData2.crAmount != crAmount) {
          var updateLedgerData = await (db.update(db.ledger)
                ..where((tbl) => tbl.id.equals(ledgerData2.id)))
              .write(
            ledgerData2.copyWith(
              crAmount: ledgerData2.crAmount - crAmount,
            ),
          );
        } else {
          var deletePaymentLedger =
              await db.delete(db.ledger).delete(ledgerData2);
          print(deletePaymentLedger);
        }
        var updateInputData = await (db.update(db.inputData)
              ..where((tbl) => tbl.id.equals(data.id)))
            .write(
          data.copyWith(
            comissionPaidDate: DateTime(1800, 01, 01),
          ),
        );
        print('updateInputData: $updateInputData');

        await getGeneratedSearchData(
          start: dateRange.value.start,
          end: dateRange.value.end,
          selectedParty: defualtParty.value,
          isAllPartySelected: isAllPartySelected.value,
          isAllMaterialTypeSelected: isAllMaterialTypeSelected.value,
          isAllPartyCitySelected: isAllPartyCitySelected.value,
          selectedMaterialType: defualtMaterialType.value,
          selectedPartyCity: defualtPartyCity.value,
        );

        'Payment Rejected Successfully'.successDailog;
        Timer(Duration(seconds: 2), () {
          Get.back();
        });
      } else {
        'Payment not found!'.errorSnackbar;
      }
    } catch (e) {
      e.toString().errorSnackbar;

      e.toString().printError;
    }
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
                  tbl.hospitalID.equals(selectedParty!.id) &
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

  Future<void> getLedgerSearchData({
    DateTime? start,
    DateTime? end,
    bool? isAllPartySelected,
    PartyMasterData? selectedParty,
  }) async {
    try {
      isLoading.value = true;
      ledgerReportData.clear();
      print('ledgerSearchData : ');
      List<LedgerData> ledgerData = [];
      d.Expression<bool> party = isAllPartySelected!
          ? db.ledger.pID.isNotNull()
          : db.ledger.pID.equals(selectedParty!.id);
      d.Expression<bool> duration =
          db.ledger.ledgerDate.isBetweenValues(start!, end!);

      ledgerData =
          await (db.select(db.ledger)..where((tbl) => party & duration)).get();

      ledgerReportData.addAll(ledgerData);

      print(ledgerReportData);
      print(ledgerReportData.length);
      Set ledgerPartySet = Set();

      List<List<double>> drcrAmountList = [];
      double dramount = 0;
      double cramount = 0;
      for (var element in ledgerReportData) {
        bool data = ledgerPartySet.add(element.pID);
        print(data);
        if (data == false) {
          print('Duplicate Party ID : $data');
          var index =
              ledgerPartySet.toList().indexWhere((pid) => pid == element.pID);
          print(index);
          drcrAmountList[index][0] += element.drAmount;
          drcrAmountList[index][1] += element.crAmount;
          print(ledgerPartySet.toList().indexOf(element.pID));
          //**add Record at old position */
          List tempPartyList = ledgerPartyWiseSet.toList()[index];
          print(tempPartyList);
          // tempPartyList.add(element);
          ledgerPartyWiseSet.toList()[index].add(element);
          print(ledgerPartyWiseSet.toList()[index]);
          // ledgerPartyWiseSet.add(element);
        } else {
          dramount = 0;
          cramount = 0;
          dramount += element.drAmount;
          cramount += element.crAmount;
          List<double> sublist = [];
          sublist.addAll([dramount, cramount]);
          drcrAmountList.add(sublist);
          //**add Record at new position */
          List tempPartyList = [];
          tempPartyList.add(element);
          ledgerPartyWiseSet.add(tempPartyList);

          print('Unique Party ID : $data');
        }
      }
      print(ledgerPartySet);
      print(drcrAmountList);
      print(ledgerPartyWiseSet);
      print(ledgerPartyWiseSet.length);
      for (var i = 0; i < ledgerPartySet.length; i++) {
        double drAmount = (drcrAmountList[i][0] < drcrAmountList[i][1])
            ? drcrAmountList[i][1] - drcrAmountList[i][0]
            : 0;
        double crAmount = (drcrAmountList[i][1] < drcrAmountList[i][0])
            ? drcrAmountList[i][0] - drcrAmountList[i][1]
            : 0;
        ledgerReportData.add(
          LedgerData(
            id: 0,
            pID: ledgerPartySet.toList()[i],
            ledgerDate: DateTime(1800, 01, 01),
            ledgerNote: '',
            type: 'Closing Balance',
            drAmount: drAmount,
            crAmount: crAmount,
            extracrAmount: 0,
            extradrAmount: 0,
          ),
        );
        ledgerPartyWiseSet.toList()[i].add(
              LedgerData(
                id: 0,
                pID: ledgerPartySet.toList()[i],
                ledgerDate: DateTime(1800, 01, 01),
                ledgerNote: '',
                type: 'Closing Balance',
                drAmount: drAmount,
                crAmount: crAmount,
                extracrAmount: 0,
                extradrAmount: 0,
              ),
            );
        drAmount = drcrAmountList[i][0] + drAmount;
        crAmount = drcrAmountList[i][1] + crAmount;

        ledgerReportData.add(
          LedgerData(
            id: 0,
            pID: ledgerPartySet.toList()[i],
            ledgerDate: DateTime(1800, 01, 01),
            ledgerNote: '',
            type: 'Total',
            drAmount: drAmount,
            crAmount: crAmount,
            extracrAmount: 0,
            extradrAmount: 0,
          ),
        );
        ledgerPartyWiseSet.toList()[i].add(
              LedgerData(
                id: 0,
                pID: ledgerPartySet.toList()[i],
                ledgerDate: DateTime(1800, 01, 01),
                ledgerNote: '',
                type: 'Total',
                drAmount: drAmount,
                crAmount: crAmount,
                extracrAmount: 0,
                extradrAmount: 0,
              ),
            );
      }

      print(ledgerReportData);
      print(ledgerPartyWiseSet);
      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;

      e.toString().printError;
    }
  }

  Future<void> getGeneratedSearchData({
    DateTime? start,
    DateTime? end,
    bool? isAllPartySelected,
    bool? isAllPartyCitySelected,
    bool? isAllMaterialTypeSelected,
    PartyMasterData? selectedParty,
    String? selectedPartyCity,
    MaterialTypeData? selectedMaterialType,
    int? ptID,
  }) async {
    try {
      print('Searching Generated Report Start....');
      isLoading.value = true;

      displayData.clear();
      comissionAndmatTypeNaNSetData.clear();
      partyNaNSetData.clear();
      var serachData = [];
      d.Expression<bool> duration =
          db.inputData.smtDocDate.isBetweenValues(start!, end!);
      d.Expression<bool> partyCity = isAllPartyCitySelected!
          ? db.inputData.custBillCity.isNotNull()
          : db.inputData.custBillCity.equals(selectedPartyCity!);
      d.Expression<bool> hospitalParty = isAllPartySelected!
          ? db.inputData.hospitalID.isNotNull()
          : db.inputData.hospitalID.equals(selectedParty!.id);
      d.Expression<bool> doctorParty = isAllPartySelected
          ? db.inputData.doctorID.isNotNull()
          : db.inputData.doctorID.equals(selectedParty!.id);
      d.Expression<bool> techniqalStaffParty = isAllPartySelected
          ? db.inputData.techniqalStaffID.isNotNull()
          : db.inputData.techniqalStaffID.equals(selectedParty!.id);
      d.Expression<bool> materialType = isAllMaterialTypeSelected!
          ? db.inputData.mtID.isNotNull()
          : db.inputData.mtID.equals(selectedMaterialType!.id);
      // print('isAllPartySelected: $isAllPartySelected');
      d.Expression<bool> party = ptID == 1
          ? hospitalParty
          : ptID == 2
              ? doctorParty
              : techniqalStaffParty;

      serachData = await (db.select(db.inputData)
            ..where((tbl) =>
                duration &
                partyCity &
                party &
                materialType &
                tbl.logId.isBiggerThanValue(0)))
          .get();

      print(serachData.length);

      // print('Generated searchData length');

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
      // print(serachData.length);
      // print(generatedReportData.length);
      if (!isAllPartySelected) {
        partyWiseTotalAmount.value = 0.0;
        partyWisePaidAmount.value = 0.0;
        partyWiseTotalAmount.value = 0.0;
      }

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
              var date = serachData[i].comissionPaidDate;
              // date.isAfter(DateTime(1800, 01, 01));
              print(date.isAfter(DateTime(1800, 01, 01)));
              print('partyPaidDate: ${serachData[i].comissionPaidDate}');
              if (date.isAfter(DateTime(1800, 01, 01))) {
                partyWiseTotalAmount.value = partyWiseTotalAmount.value +
                    double.parse(serachData[i].comissionAmount.toString());
                partyWisePaidAmount.value = partyWisePaidAmount.value +
                    double.parse(serachData[i].comissionAmount.toString());
                partyWisePayableAmount.value =
                    partyWiseTotalAmount.value - partyWisePaidAmount.value;
              } else {
                partyWiseTotalAmount.value = partyWiseTotalAmount.value +
                    double.parse(serachData[i].comissionAmount.toString());

                partyWisePayableAmount.value =
                    partyWiseTotalAmount.value - partyWisePaidAmount.value;
              }
            }
          } else {
            comissionAndmatTypeNaNSetData
                .add(serachData[i].smtInvNo.toString());
          }
        } else {
          partyNaNSetData.add(serachData[i].smtInvNo.toString());
        }
      }

      // print(displayData);
      // print(partyNaNSetData);
      // print(comissionAndmatTypeNaNSetData);
      isLoading.value = false;
      print('End Searching Generated Report Data ......');
    } catch (e) {
      e.toString().errorSnackbar;

      e.toString().printError;
    }
  }

  Future<void> partyWisePayment({
    required PartyMasterData? selectedParty,
    required double? crAmount,
    int? ptID,
    // String? ledgerNote,
  }) async {
    try {
      isLoading.value = true;
      var currentDate = DateTime.now();
      var ledgerData = await db.into(db.ledger).insert(LedgerCompanion.insert(
            type: Constantdata.payment,
            pID: selectedParty!.id,
            ledgerDate: currentDate,
            drAmount: 0,
            crAmount: crAmount!,
            ledgerNote: Constantdata.defualtNote,
            extradrAmount: 0,
            extracrAmount: 0,
            // ledgerNote: ledgerNote
          ));
      print('Generated Report Data Length');
      print(generatedReportData);

      // print(data);
      if (ledgerData > 0) {
        List<String> smtInvNoList = [];
        // for (var i = 1; i < generatedReportData.length; i++) {
        //   smtInvNoList.add(generatedReportData[i][15].toString());
        // }
        smtInvNoList.addAll(smtInvNoSet.toList());

        print(smtInvNoList);

        var inputDatadata = await (db.select(db.inputData)
              ..where((tbl) => tbl.smtInvNo.isIn(smtInvNoList)))
            .get();
        print(inputDatadata);
        for (var i = 0; i < inputDatadata.length; i++) {
          var inputData = inputDatadata[i];
          print(inputDatadata[i].smtInvNo);
          var updateRes = await (db.update(db.inputData)
                ..where((tbl) => tbl.id.equals(inputDatadata[i].id)))
              .write(
            inputData.copyWith(
              comissionPaidDate: currentDate,
            ),
          );
          print(updateRes);
        }
        // Get.back();
        // 'Payment Added Successfully'.successSnackbar;
        await getGeneratedSearchData(
          start: dateRange.value.start,
          end: dateRange.value.end,
          selectedParty: defualtParty.value,
          isAllPartySelected: isAllPartySelected.value,
          isAllMaterialTypeSelected: isAllMaterialTypeSelected.value,
          isAllPartyCitySelected: isAllPartyCitySelected.value,
          selectedMaterialType: defualtMaterialType.value,
          selectedPartyCity: defualtPartyCity.value,
          ptID: ptID,
        );
        'Payment Added Successfully'.successDailog;
        Timer(Duration(seconds: 2), () {
          Get.back();
        });
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
    try {
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
    } catch (e) {
      'Invalid File'.toString().errorSnackbar;

      e.toString().printError;
    }
  }

  Future<void> checkInputData({List<List<dynamic>>? fields}) async {
    isLoading.value = true;
    partyList = await db.select(db.partyMaster).get();
    if (partyList!.isNotEmpty) {
      defualtParty.value = partyList![0];
    }
    materialTypeList = await db.select(db.materialType).get();
    if (materialTypeList!.isNotEmpty) {
      defualtMaterialType.value = materialTypeList![0];
    }
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

  

  // Future<void> generateComissionReport(
  //     {List<List<dynamic>>? data, DateTime? start, DateTime? end}) async {
  //   try {
  //     isLoading.value = true;
  //     List<String> smtInvNoList = [];
  //     // for (var element in data!) {
  //     //   smtInvNoList.add(element[15]);
  //     // }
  //     for (var i = 1; i < data!.length; i++) {
  //       smtInvNoList.add(data[i][15]);
  //     }
  //     print(smtInvNoList);
  //     var res = await (db.select(db.inputData)
  //           ..where(
  //               (tbl) => tbl.smtInvNo.isIn(smtInvNoList) & tbl.logId.equals(0)))
  //         .get();
  //     if (res.isNotEmpty) {
  //       print('generateComissionReport');
  //       print(data);
  //       // print(data?.length);
  //       Set<int> partySet = {};
  //       List partyTotalComissionSet = [];
  //       List<List<String>> partyWiseList = [];
  //       // GetStorage('box').write('logID', 0);
  //       var logID = GetStorage('box').read('logID') ?? 0;
  //       print('prevID :' + logID.toString());
  //       GetStorage('box').write('logID', logID + 1);
  //       print(dateRange.value.start);
  //       print(dateRange.value.end);
  //       var pendingData = await (db.select(db.inputData)
  //             ..where((tbl) => tbl.logId.equals(0)))
  //           .get();
  //       print(pendingData);
  //       for (var element in pendingData) {
  //         var checkParty = await (db.select(db.partyMaster)
  //               ..where((tbl) => tbl.id.isIn([
  //                     element.hospitalID,
  //                     element.doctorID,
  //                     element.techniqalStaffID
  //                   ])))
  //             .get();

  //         if (checkParty.isNotEmpty) {
  //           var checkMaterialType = await (db.select(db.materialType)
  //                 ..where((tbl) => tbl.id.equals(element.mtID)))
  //               .get();
  //           if (checkMaterialType.isNotEmpty) {
  //             var resPartyComission = await (db.select(db.partyComissionDetail)
  //                   ..where((tbl) =>
  //                       tbl.pID.equals(checkParty[0].id) &
  //                       tbl.mtID.equals(checkMaterialType[0].id)))
  //                 .get();
  //             if (resPartyComission.isNotEmpty) {
  //               // displayData.add(data[15].toString());
  //               var comission = resPartyComission[0].comission1;
  //               var comissionAmount = double.parse(
  //                   ((comission * element.totalSale) / 100).toStringAsFixed(2));
  //               var logID = GetStorage('box').read('logID');
  //               print('logID: $logID');
  //               print('pname: ${checkParty[0].name}');
  //               if (partySet.contains(element.hospitalID)) {
  //                 int index = partySet
  //                     .toList()
  //                     .indexWhere((item) => item.isEqual(element.pID));
  //                 print(index);
  //                 var oldCommision = partyTotalComissionSet.elementAt(index);
  //                 print(oldCommision);
  //                 partyTotalComissionSet[index] =
  //                     oldCommision + comissionAmount;
  //                 partyWiseList[index].add(element.smtInvNo);

  //                 print(partyWiseList);
  //                 print(partyTotalComissionSet.toList());
  //                 // partyTotalComissionSet.add(comissionAmount);
  //               } else {
  //                 partySet.add(element.pID);
  //                 int index = partySet
  //                     .toList()
  //                     .indexWhere((item) => item.isEqual(element.pID));
  //                 print(index);
  //                 partyTotalComissionSet.insert(index, comissionAmount);
  //                 List<String> party = [];
  //                 party.add(element.smtInvNo);
  //                 partyWiseList.insert(index, party);
  //                 // partyTotalComissionSet.elementAt(index);
  //                 print(partyWiseList);
  //                 print(partyTotalComissionSet.toList());
  //                 print(partySet);
  //               }
  //               var resComissionUpdate = await (db.update(db.inputData)
  //                     ..where((tbl) => tbl.id.equals(element.id)))
  //                   .write(InputDataData(
  //                       id: element.id,
  //                       documentType: element.documentType,
  //                       distDocDate: element.distDocDate,
  //                       distDocNo: element.distDocNo,
  //                       hospitalID: element.hospitalID,
  //                       custBillCity: element.custBillCity,
  //                       matCode: element.matCode,
  //                       matName: element.matName,
  //                       mtID: element.mtID,
  //                       qty: element.qty,
  //                       doctorName: element.doctorName,
  //                       techniqalStaff: element.techniqalStaff,
  //                       saleAmount: element.saleAmount,
  //                       totalSale: element.totalSale,
  //                       smtDocDate: element.smtDocDate,
  //                       smtDocNo: element.smtDocNo,
  //                       smtInvNo: element.smtInvNo,
  //                       purchaseTaxableAmount: element.purchaseTaxableAmount,
  //                       totalPurchaseAmount: element.totalPurchaseAmount,
  //                       logId: logID,
  //                       ledgerId: element.ledgerId,
  //                       comission: comission,
  //                       comissionAmount: comissionAmount,
  //                       comissionPaidDate: element.comissionPaidDate,
  //                       adjustComissionAmount: element.adjustComissionAmount));
  //               print(resComissionUpdate);
  //               print('comission(%): $comission');
  //               print('TotalAmount(%): ${element.totalSale}');
  //               print('comissionAmount(%): ${comissionAmount}');
  //               print('************');
  //             }
  //           } else {
  //             comissionAndmatTypeNaNSetData.add(element.smtInvNo.toString());
  //           }
  //         } else {
  //           partyNaNSetData.add(element.smtInvNo.toString());
  //         }
  //       }
  //       print('done');
  //       List ledgerIDList = [];

  //       for (var i = 0; i < partySet.length; i++) {
  //         print('ledgerID: ${i + 1}');
  //         var pID = partySet.elementAt(i);
  //         print(partySet.elementAt(i));
  //         var totalComission = partyTotalComissionSet.elementAt(i);
  //         print(partyTotalComissionSet.elementAt(i));
  //         var resLedger =
  //             await db.into(db.ledger).insert(LedgerCompanion.insert(
  //                   type: 'sale commission',
  //                   pID: pID,
  //                   ledgerDate: DateTime.now(),
  //                   drAmount: totalComission,
  //                   crAmount: 0,
  //                   ledgerNote: Constantdata.defualtNote,
  //                 ));
  //         print(resLedger);
  //         ledgerIDList.add(resLedger);
  //       }

  //       for (var i = 0; i < partyWiseList.length; i++) {
  //         var element = partyWiseList[i];
  //         for (var j = 0; j < element.length; j++) {
  //           var data = await (db.select(db.inputData)
  //                 ..where((tbl) => tbl.smtInvNo.equals(element[j])))
  //               .get();
  //           print(element[j]); //smtInvNo
  //           print(data[0]); // smtInvNo-data
  //           print(ledgerIDList[i]); //ledgerID
  //           var resUpdate = await (db.update(db.inputData)
  //                 ..where((tbl) => tbl.smtInvNo.equals(element[j])))
  //               .write(InputDataData(
  //                   id: data[0].id,
  //                   documentType: data[0].documentType,
  //                   distDocDate: data[0].distDocDate,
  //                   distDocNo: data[0].distDocNo,
  //                   pID: data[0].pID,
  //                   custBillCity: data[0].custBillCity,
  //                   matCode: data[0].matCode,
  //                   matName: data[0].matName,
  //                   mtID: data[0].mtID,
  //                   qty: data[0].qty,
  //                   doctorName: data[0].doctorName,
  //                   techniqalStaff: data[0].techniqalStaff,
  //                   saleAmount: data[0].saleAmount,
  //                   totalSale: data[0].totalSale,
  //                   smtDocDate: data[0].smtDocDate,
  //                   smtDocNo: data[0].smtDocNo,
  //                   smtInvNo: data[0].smtInvNo,
  //                   purchaseTaxableAmount: data[0].purchaseTaxableAmount,
  //                   totalPurchaseAmount: data[0].totalPurchaseAmount,
  //                   logId: data[0].logId,
  //                   ledgerId: ledgerIDList[i],
  //                   comission: data[0].comission,
  //                   comissionAmount: data[0].comissionAmount,
  //                   comissionPaidDate: data[0].comissionPaidDate,
  //                   adjustComissionAmount: data[0].adjustComissionAmount));
  //           print(resUpdate);
  //           print('update record');
  //         }
  //       }

  //       // var data = db.select(db.inputData).get();
  //       pendingReportData.clear();
  //       isLoading.value = false;
  //       // 'Generate Report Successfully'.successSnackbar;
  //       'Generate Report Successfully'.successDailog;
  //       Timer(Duration(seconds: 2), () {
  //         Get.back();
  //       });
  //     } else {
  //       isLoading.value = false;
  //       'No Data Found'.errorSnackbar;
  //     }
  //   } catch (e) {
  //     printError(info: e.toString());
  //     e.toString().errorSnackbar;
  //   }
  // }

  // Future<void> insertData(List<List<dynamic>> data) async {
  //   try {
  //     print(data.length);
  //     partyList = await (db.select(db.partyMaster)).get();
  //     materialTypeList = await (db.select(db.materialType)).get();
  //     if (materialTypeList!.isNotEmpty) {
  //       defualtMaterialType.value = materialTypeList![0];
  //     }
  //     print(partyList);
  //     print(materialTypeList);
  //     var tempList = [];
  //     // TODO: insert data Duaring check already exist or not
  //     List smtInvNoList = [];
  //     for (var i = 1; i < data.length; i++) {
  //       print(i);

  //       String smtInvNo = (data[i][15]).toString();

  //       var res = await (db.select(db.inputData)
  //             ..where((tbl) => tbl.smtInvNo.equals(smtInvNo)))
  //           .get();
  //       if (res.isNotEmpty) {
  //         // 'already exist'.errorSnackbar;
  //         print('already exist');
  //         smtInvNoList.add(smtInvNo);
  //         print(smtInvNo);
  //       }
  //     }
  //     print(smtInvNoList);
  //     if (smtInvNoList.length > 1) {
  //       String smtInvNoListString = '';
  //       for (var i = 0; i < smtInvNoList.length; i++) {
  //         smtInvNoListString += smtInvNoList[i].toString() + ', ';
  //       }
  //       Get.defaultDialog(
  //         content: Column(
  //           children: [
  //             Text(
  //               'Duplicate Invoice No',
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: Get.height * 0.02,
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
  //               child: Container(
  //                 color: lCOLOR_PRIMARY.withOpacity(0.1),
  //                 child: Text(
  //                   smtInvNoListString.toString(),
  //                   style: TextStyle(fontSize: Get.height * 0.02),
  //                 ),
  //               ),
  //             ),
  //             Text(
  //               'Are you want to Remove Duplicate Invoice No',
  //               style: TextStyle(fontSize: Get.height * 0.02),
  //             ),
  //           ],
  //         ),
  //         textConfirm: 'Ok',
  //         confirmTextColor: Colors.white,
  //         onConfirm: () async {
  //           Get.back();
  //           List<List<dynamic>> tempdata = [];
  //           // tempdata.addAll(data);

  //           for (var i = 1; i < data.length; i++) {
  //             String smtInvNo = (data[i][15]).toString();
  //             if (!smtInvNoList.contains(smtInvNo)) {
  //               tempdata.add(data[i]);
  //             }
  //           }

  //           print(tempdata);
  //           List<dynamic> dataHeader = [];
  //           dataHeader.addAll(data[0]);
  //           data.clear();
  //           data.add(dataHeader);
  //           data.addAll(tempdata);
  //           print(data);
  //           pendingReportData.clear();
  //           pendingReportData.addAll(data);
  //           if (data.length < 1) {
  //             'Duplicate Invoice Number Removed'.successSnackbar;
  //             return;
  //           } else {
  //             for (var i = 1; i < data.length; i++) {
  //               String documentType = data[i][0];
  //               DateTime distDocDate =
  //                   DateFormat("dd.MM.yyyy").parse(data[i][1].toString());
  //               String distDocNo = data[i][2];
  //               var customer = data[i][3];
  //               String custBillCity = data[i][4];
  //               String matCode = data[i][5];
  //               String matName = data[i][6];
  //               String matType = data[i][7];
  //               int qty = data[i][8];
  //               String doctorName = data[i][9];
  //               String techniqalStaff = data[i][10];
  //               double saleAmount = double.parse((data[i][11]).toString());
  //               double totalSale = double.parse((data[i][12]).toString());
  //               DateTime smtDocDate =
  //                   DateFormat("dd.MM.yyyy").parse(data[i][13].toString());
  //               String smtDocNo = (data[i][14]).toString();
  //               String smtInvNo = (data[i][15]).toString();
  //               double purchaseTaxableAmount =
  //                   double.parse(data[i][16].toString());
  //               double totalPurchaseAmount =
  //                   double.parse(data[i][17].toString());
  //               int logId = 0;
  //               int ledgerId = 0;
  //               double comission = 0;
  //               double comissionAmount = 0;
  //               DateTime comissionPaidDate = DateTime(1800, 01, 01);
  //               double adjustComissionAmount = 0;

  //               var pID = partyList!
  //                   .firstWhere((element) => element.name == customer)
  //                   .id;
  //               var mtID = materialTypeList!
  //                   .firstWhere((element) => element.type == matType)
  //                   .id;

  //               var result = await db.into(db.inputData).insert(
  //                     InputDataCompanion.insert(
  //                       documentType: documentType,
  //                       distDocDate: distDocDate,
  //                       distDocNo: distDocNo,
  //                       pID: pID,
  //                       custBillCity: custBillCity,
  //                       matCode: matCode,
  //                       matName: matName,
  //                       mtID: mtID,
  //                       qty: qty,
  //                       doctorName: doctorName,
  //                       techniqalStaff: techniqalStaff,
  //                       saleAmount: saleAmount,
  //                       totalSale: totalSale,
  //                       smtDocDate: smtDocDate,
  //                       smtDocNo: smtDocNo,
  //                       smtInvNo: smtInvNo,
  //                       purchaseTaxableAmount: purchaseTaxableAmount,
  //                       totalPurchaseAmount: totalPurchaseAmount,
  //                       logId: logId,
  //                       ledgerId: ledgerId,
  //                       comission: comission,
  //                       comissionAmount: comissionAmount,
  //                       comissionPaidDate: comissionPaidDate,
  //                       adjustComissionAmount: adjustComissionAmount,
  //                     ),
  //                   );
  //               print(result);
  //               // 'data insert Successful'.successSnackbar;
  //             }
  //             'data insert Successful'.successDailog;
  //             Timer(Duration(seconds: 2), () {
  //               Get.back();
  //             });
  //           }
  //         },
  //         textCancel: 'Cancel',
  //         cancelTextColor: lCOLOR_PRIMARY,
  //         onCancel: () {
  //           Get.back();
  //         },
  //       );
  //     } else {
  //       for (var i = 1; i < data.length; i++) {
  //         String documentType = data[i][0];
  //         DateTime distDocDate =
  //             DateFormat("dd.MM.yyyy").parse(data[i][1].toString());
  //         String distDocNo = data[i][2];
  //         var customer = data[i][3];
  //         String custBillCity = data[i][4];
  //         String matCode = data[i][5];
  //         String matName = data[i][6];
  //         String matType = data[i][7];
  //         int qty = data[i][8];
  //         String doctorName = data[i][9];
  //         String techniqalStaff = data[i][10];
  //         double saleAmount = double.parse((data[i][11]).toString());
  //         double totalSale = double.parse((data[i][12]).toString());
  //         DateTime smtDocDate =
  //             DateFormat("dd.MM.yyyy").parse(data[i][13].toString());
  //         String smtDocNo = (data[i][14]).toString();
  //         String smtInvNo = (data[i][15]).toString();
  //         double purchaseTaxableAmount = double.parse(data[i][16].toString());
  //         double totalPurchaseAmount = double.parse(data[i][17].toString());
  //         int logId = 0;
  //         int ledgerId = 0;
  //         double comission = 0;
  //         double comissionAmount = 0;
  //         DateTime comissionPaidDate = DateTime(1800, 01, 01);
  //         double adjustComissionAmount = 0;

  //         var pID =
  //             partyList!.firstWhere((element) => element.name == customer).id;
  //         var mtID = materialTypeList!
  //             .firstWhere((element) => element.type == matType)
  //             .id;

  //         var result = await db.into(db.inputData).insert(
  //               InputDataCompanion.insert(
  //                 documentType: documentType,
  //                 distDocDate: distDocDate,
  //                 distDocNo: distDocNo,
  //                 pID: pID,
  //                 custBillCity: custBillCity,
  //                 matCode: matCode,
  //                 matName: matName,
  //                 mtID: mtID,
  //                 qty: qty,
  //                 doctorName: doctorName,
  //                 techniqalStaff: techniqalStaff,
  //                 saleAmount: saleAmount,
  //                 totalSale: totalSale,
  //                 smtDocDate: smtDocDate,
  //                 smtDocNo: smtDocNo,
  //                 smtInvNo: smtInvNo,
  //                 purchaseTaxableAmount: purchaseTaxableAmount,
  //                 totalPurchaseAmount: totalPurchaseAmount,
  //                 logId: logId,
  //                 ledgerId: ledgerId,
  //                 comission: comission,
  //                 comissionAmount: comissionAmount,
  //                 comissionPaidDate: comissionPaidDate,
  //                 adjustComissionAmount: adjustComissionAmount,
  //               ),
  //             );
  //         print(result);
  //         // 'data insert Successful'.successSnackbar;
  //         'data insert Successful'.successDailog;
  //         Timer(Duration(seconds: 2), () {
  //           Get.back();
  //         });
  //       }
  //     }
  //     // var res = await db.select(db.inputData).get();

  //     print('done');

  //     //
  //   } catch (e) {
  //     printError(info: e.toString());
  //     e.toString().errorSnackbar;
  //   }
  // }
}
