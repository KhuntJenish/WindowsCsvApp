import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:csvapp/theam/theam_constants.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:drift/drift.dart' as d;
// import 'package:drift/drift.dart';
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
  RxList<String> durationList = RxList<String>([
    'One Month',
    'Four Month',
    'Six Month',
    'One Year',
    'Custom',
  ]);
  RxSet<String> partyCityList = RxSet<String>();
  RxSet<int> checkLumpsumPaymentData = RxSet<int>();
  RxSet<List<int>> partyNaNSetDetailData = RxSet<List<int>>();
  RxSet<int> partyNaNSetData = RxSet<int>();
  RxList<int> comissionAndmatTypeNaNSetData = RxList<int>();
  RxSet<int> displayData = RxSet<int>();
  List<MaterialTypeData>? materialTypeList = [];
  List<PartyMasterData>? partyList = [];
  List<PartyMasterData>? hpartyList = [];
  List<PartyMasterData>? dpartyList = [];
  List<PartyMasterData>? tpartyList = [];
  Set ledgerPartyWiseSet = {};
  RxList<String> smtInvNoSet = RxList<String>();
  RxSet<int> dataNoSet = RxSet<int>();
  Rx<PartyMasterData> defaultParty =
      const PartyMasterData(id: 0, name: '', ptID: 0).obs;
  Rx<String> defaultPartyCity = ''.obs;
  Rx<String> defaultDuration = 'One Month'.obs;
  Rx<MaterialTypeData> defaultMaterialType =
      const MaterialTypeData(id: 0, type: '').obs;
  String? filePath;
  RxBool isLoading = false.obs;
  RxBool isAllPartySelected = true.obs;
  RxBool isAllMaterialTypeSelected = true.obs;
  RxBool isAllPartyCitySelected = true.obs;
  RxBool isAllPendingPayement = false.obs;
  RxBool isReversePayment1 = true.obs;
  RxBool isReversePayment2 = false.obs;
  RxDouble partyWiseTotalAmount = 0.0.obs;
  RxDouble partyWisePaidAmount = 0.0.obs;
  RxDouble partyWisePayableAmount = 0.0.obs;
  RxDouble partyWisePendingPaidAmount = 0.0.obs;
  var db = Constantdata.db;
  var dateRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime.now(),
  ).obs;
  List<int> rightalign = [
    Constantdata.salesAmountIndex,
    Constantdata.totalSalesIndex,
    Constantdata.totalPurchaseIndex,
    Constantdata.purchaseTaxableIndex,
    Constantdata.hcAmountIndex,
    Constantdata.dcAmountIndex,
    Constantdata.tcAmountIndex,
  ];
  List<int> centeralign = [
    Constantdata.hcomissionIndex,
    Constantdata.dcomissionIndex,
    Constantdata.tcomissionIndex,
    Constantdata.dataNoIndex,
    Constantdata.quantityIndex,
    Constantdata.smtDocDateIndex,
    Constantdata.distDocDateIndex,
  ];
  List<int> hospitalComissionList = [
    Constantdata.hcomissionIndex,
    Constantdata.hcAmountIndex,
  ];
  List<int> doctorComissionList = [
    Constantdata.dcomissionIndex,
    Constantdata.dcAmountIndex,
  ];
  List<int> technicianComissionList = [
    Constantdata.tcomissionIndex,
    Constantdata.tcAmountIndex,
  ];

  // scrollwork

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getPartyList();
    // getMaterialTypeList();
    // getPartyCityList();

    if (GetStorage('box').read('isSelectedReport') != null) {
      isSelectedReport.value = GetStorage('box').read('isSelectedReport');
    } else {
      isSelectedReport.value = 0;
      GetStorage('box').write('isSelectedReport', 0);
    }
    //
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

        dateRange.value = tempDateRange;
        break;
      case 'Four Month':
        DateTime last = DateTime(DateTime.now().year, DateTime.now().month, 1)
            .subtract(const Duration(days: 1));
        DateTimeRange tempDateRange = DateTimeRange(
          start: DateTime(last.year, last.month - 3, 1),
          end: last,
        );

        dateRange.value = tempDateRange;
        break;
      case 'Six Month':
        DateTime last = DateTime(DateTime.now().year, DateTime.now().month, 1)
            .subtract(const Duration(days: 1));
        DateTimeRange tempDateRange = DateTimeRange(
          start: DateTime(last.year, last.month - 5, 1),
          end: last,
        );

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

        dateRange.value = tempDateRange;
        break;
      default:
    }
  }

  createPartyPaymentReportPdf() async {
    try {
      isLoading.value = true;
      final pdf = pw.Document();
      List<List<dynamic>> list = [];
      var partyType = defaultParty.value.ptID;
      for (var i = 0; i < generatedReportData.length; i++) {
        List subList = [];
        subList.add(generatedReportData[i][Constantdata.smtDocDateIndex]
            .toString()); //smt Date
        subList.add(generatedReportData[i][Constantdata.smtInvoiceNoIndex]
            .toString()); //smt inv no
        // subList.add(generatedReportData[i][6].toString());//material name
        subList.add(generatedReportData[i][Constantdata.matTypeIndex]
            .toString()); //material type
        subList.add(generatedReportData[i][Constantdata.custBillCityIndex]
            .toString()); //customer billcity
        subList.add(generatedReportData[i][Constantdata.totalSalesIndex]
            .toString()); //total sale

        if (partyType == 1) {
          subList.add(generatedReportData[i][Constantdata.customerIndex]
              .toString()); //h name
          subList.add(generatedReportData[i][Constantdata.hcomissionIndex]
              .toString()); //h comission
          subList.add(generatedReportData[i][Constantdata.hcAmountIndex]
              .toString()); //h comission amount
        } else if (partyType == 2) {
          subList.add(generatedReportData[i][Constantdata.doctorNameIndex]
              .toString()); //d name
          subList.add(generatedReportData[i][Constantdata.dcomissionIndex]
              .toString()); //d comission
          subList.add(generatedReportData[i][Constantdata.dcAmountIndex]
              .toString()); //d comission amount
        } else {
          subList.add(generatedReportData[i][Constantdata.technicianStaffIndex]
              .toString()); //t name

          subList.add(generatedReportData[i][Constantdata.tcomissionIndex]
              .toString()); //t comission
          subList.add(generatedReportData[i][Constantdata.tcAmountIndex]
              .toString()); //t comission amount
        }

        //
        list.add(subList);
      }

      int a = 0;
      List<List<dynamic>> newList = [];
      List<List<List<dynamic>>> mainList = [];
      double saletotal = 0;
      List<double> saletotalList = [];

      double comissiontotal = 0;
      double hComissiontotal = 0;
      double dComissiontotal = 0;
      double tComissiontotal = 0;
      List<double> comissiontotalList = [];
      List<double> hComissiontotalList = [];
      List<double> dComissiontotalList = [];
      List<double> tComissiontotalList = [];

      for (var i = 0; i < list.length; i++) {
        if (a < 15) {
          newList.add(list[i]);
          if (i > 0) {
            saletotal = saletotal + double.parse(list[i][4].toString());
            // comissiontotal =
            //     comissiontotal + double.parse(list[i][8].toString());
            if (partyType == 1) {
              hComissiontotal += double.parse(list[i][7].toString());
            } else if (partyType == 2) {
              dComissiontotal += double.parse(list[i][7].toString());
            } else {
              tComissiontotal += double.parse(list[i][7].toString());
            }
          }
          a++;
          if (a >= list.length) {
            saletotalList.add(saletotal);
            // comissiontotalList.add(comissiontotal);
            hComissiontotalList.add(hComissiontotal);
            dComissiontotalList.add(dComissiontotal);
            tComissiontotalList.add(tComissiontotal);
            newList.add([
              'Total',
              '',
              '',
              '',
              saletotal.toStringAsFixed(2),
              '',
              '',
              partyType == 1
                  ? hComissiontotal.toStringAsFixed(2)
                  : partyType == 2
                      ? dComissiontotal.toStringAsFixed(2)
                      : tComissiontotal.toStringAsFixed(2),
            ]);

            mainList.add(newList);

            saletotal = 0;
            // comissiontotal = 0;
            hComissiontotal = 0;
            dComissiontotal = 0;
            tComissiontotal = 0;
            saletotalList = [];
            // comissiontotalList = [];
            hComissiontotalList = [];
            dComissiontotalList = [];
            tComissiontotalList = [];
          }
        } else {
          saletotalList.add(saletotal);
          // comissiontotalList.add(comissiontotal);
          hComissiontotalList.add(hComissiontotal);
          dComissiontotalList.add(dComissiontotal);
          tComissiontotalList.add(tComissiontotal);
          newList.add([
            'Total',
            '',
            '',
            '',
            saletotal.toStringAsFixed(2),
            '',
            '',
            partyType == 1
                ? hComissiontotal.toStringAsFixed(2)
                : partyType == 2
                    ? dComissiontotal.toStringAsFixed(2)
                    : tComissiontotal.toStringAsFixed(2),
          ]);

          mainList.add(newList);
          saletotal = 0;
          // saletotalList = [];
          // comissiontotalList = [];
          // comissiontotal = 0;
          hComissiontotal = 0;
          dComissiontotal = 0;
          tComissiontotal = 0;

          newList = [];

          a = 0;
        }
      }
      if (mainList.length > 1) {
        List<List<dynamic>> lastList = [];
        lastList.addAll(mainList.elementAt(mainList.length - 1));

        //
        for (var i = 0; i < saletotalList.length; i++) {
          saletotal += saletotalList[i];
          // comissiontotal = comissiontotal + comissiontotalList[i];
          hComissiontotal += hComissiontotalList[i];
          dComissiontotal += dComissiontotalList[i];
          tComissiontotal += tComissiontotalList[i];
        }

        lastList.add([
          'Grant_Total',
          '',
          '',
          '',
          saletotal.toStringAsFixed(2),
          '',
          '',
          partyType == 1
              ? hComissiontotal.toStringAsFixed(2)
              : partyType == 2
                  ? dComissiontotal.toStringAsFixed(2)
                  : tComissiontotal.toStringAsFixed(2),
        ]);

        mainList.removeLast();

        mainList.add(lastList);
      }

      for (var i = 0; i < mainList.length; i++) {
        pdf.addPage(
          pw.Page(
            orientation: pw.PageOrientation.landscape,
            margin:
                const pw.EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Table.fromTextArray(
                    columnWidths: {
                      0: const pw.FlexColumnWidth(1.2),
                      1: const pw.FlexColumnWidth(1),
                      2: const pw.FlexColumnWidth(1),
                      3: const pw.FlexColumnWidth(1),
                      4: const pw.FlexColumnWidth(1),
                      5: const pw.FlexColumnWidth(2),
                      6: const pw.FlexColumnWidth(1),
                      7: const pw.FlexColumnWidth(1),
                    },
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.centerLeft,
                      3: pw.Alignment.centerLeft,
                      4: pw.Alignment.centerRight,
                      5: pw.Alignment.centerLeft,
                      6: pw.Alignment.centerRight,
                      7: pw.Alignment.centerRight,
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
                    },
                    context: context,
                    data: mainList[i],
                    cellStyle: const pw.TextStyle(fontSize: 7),
                    headerStyle: pw.TextStyle(
                        fontSize: 8, fontWeight: pw.FontWeight.bold),
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

      // final file = File("example.pdf");
      await file.writeAsBytes(await pdf.save());

      // 'pdf Download SuccessFull.😀'.successSnackbar;
      'pdf Download SuccessFull.😀'.successDailog;
      Timer(const Duration(seconds: 2), () {
        Get.back();
      });
      // final String filePath = testFile.absolute.path;
      final Uri uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        //
        await launchUrl(uri);
      } else {}
      isNumber.value++;
      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  createReportPdf() async {
    try {
      isLoading.value = true;
      final pdf = pw.Document();
      List<List<dynamic>> list = [];
      for (var i = 0; i < generatedReportData.length; i++) {
        List subList = [];
        subList.add(generatedReportData[i][Constantdata.smtDocDateIndex]
            .toString()); //smt Date
        subList.add(generatedReportData[i][Constantdata.smtInvoiceNoIndex]
            .toString()); //smt inv no
        // subList.add(generatedReportData[i][6].toString());//material name
        subList.add(generatedReportData[i][Constantdata.matTypeIndex]
            .toString()); //material type
        subList.add(generatedReportData[i][Constantdata.custBillCityIndex]
            .toString()); //customer billcity
        subList.add(generatedReportData[i][Constantdata.totalSalesIndex]
            .toString()); //total sale
        subList.add(generatedReportData[i][Constantdata.customerIndex]
            .toString()); //h name
        subList.add(generatedReportData[i][Constantdata.hcomissionIndex]
            .toString()); //h comission
        subList.add(generatedReportData[i][Constantdata.hcAmountIndex]
            .toString()); //h comission amount
        subList.add(generatedReportData[i][Constantdata.doctorNameIndex]
            .toString()); //d name
        subList.add(generatedReportData[i][Constantdata.dcomissionIndex]
            .toString()); //d comission
        subList.add(generatedReportData[i][Constantdata.dcAmountIndex]
            .toString()); //d comission amount
        subList.add(generatedReportData[i][Constantdata.technicianStaffIndex]
            .toString()); //t name
        subList.add(generatedReportData[i][Constantdata.tcomissionIndex]
            .toString()); //t comission
        subList.add(generatedReportData[i][Constantdata.tcAmountIndex]
            .toString()); //t comission amount
        //
        list.add(subList);
      }

      int a = 0;
      List<List<dynamic>> newList = [];
      List<List<List<dynamic>>> mainList = [];
      double saletotal = 0;
      List<double> saletotalList = [];

      double comissiontotal = 0;
      double hComissiontotal = 0;
      double dComissiontotal = 0;
      double tComissiontotal = 0;
      List<double> comissiontotalList = [];
      List<double> hComissiontotalList = [];
      List<double> dComissiontotalList = [];
      List<double> tComissiontotalList = [];

      for (var i = 0; i < list.length; i++) {
        if (a < 15) {
          newList.add(list[i]);
          if (i > 0) {
            saletotal = saletotal + double.parse(list[i][4].toString());
            // comissiontotal =
            //     comissiontotal + double.parse(list[i][8].toString());
            hComissiontotal += double.parse(list[i][7].toString());
            dComissiontotal += double.parse(list[i][10].toString());
            tComissiontotal += double.parse(list[i][13].toString());
          }
          a++;
          if (a >= list.length) {
            saletotalList.add(saletotal);
            // comissiontotalList.add(comissiontotal);
            hComissiontotalList.add(hComissiontotal);
            dComissiontotalList.add(dComissiontotal);
            tComissiontotalList.add(tComissiontotal);
            newList.add([
              'Total',
              '',
              '',
              '',
              saletotal.toStringAsFixed(2),
              '',
              '',
              hComissiontotal.toStringAsFixed(2),
              '',
              '',
              dComissiontotal.toStringAsFixed(2),
              '',
              '',
              tComissiontotal.toStringAsFixed(2),
            ]);

            mainList.add(newList);

            saletotal = 0;
            // comissiontotal = 0;
            hComissiontotal = 0;
            dComissiontotal = 0;
            tComissiontotal = 0;
            saletotalList = [];
            // comissiontotalList = [];
            hComissiontotalList = [];
            dComissiontotalList = [];
            tComissiontotalList = [];
          }
        } else {
          saletotalList.add(saletotal);
          // comissiontotalList.add(comissiontotal);
          hComissiontotalList.add(hComissiontotal);
          dComissiontotalList.add(dComissiontotal);
          tComissiontotalList.add(tComissiontotal);
          newList.add([
            'Total',
            '',
            '',
            '',
            saletotal.toStringAsFixed(2),
            '',
            '',
            hComissiontotal.toStringAsFixed(2),
            '',
            '',
            dComissiontotal.toStringAsFixed(2),
            '',
            '',
            tComissiontotal.toStringAsFixed(2),
          ]);

          mainList.add(newList);
          saletotal = 0;
          // saletotalList = [];
          // comissiontotalList = [];
          // comissiontotal = 0;
          hComissiontotal = 0;
          dComissiontotal = 0;
          tComissiontotal = 0;

          newList = [];

          a = 0;
        }
      }
      if (mainList.length > 1) {
        List<List<dynamic>> lastList = [];
        lastList.addAll(mainList.elementAt(mainList.length - 1));

        //
        for (var i = 0; i < saletotalList.length; i++) {
          saletotal += saletotalList[i];
          // comissiontotal = comissiontotal + comissiontotalList[i];
          hComissiontotal += hComissiontotalList[i];
          dComissiontotal += dComissiontotalList[i];
          tComissiontotal += tComissiontotalList[i];
        }

        lastList.add([
          'Grant_Total',
          '',
          '',
          '',
          saletotal.toStringAsFixed(2),
          '',
          '',
          hComissiontotal.toStringAsFixed(2),
          '',
          '',
          dComissiontotal.toStringAsFixed(2),
          '',
          '',
          tComissiontotal.toStringAsFixed(2),
        ]);

        mainList.removeLast();

        mainList.add(lastList);
      }

      for (var i = 0; i < mainList.length; i++) {
        pdf.addPage(
          pw.Page(
            orientation: pw.PageOrientation.landscape,
            margin:
                const pw.EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Table.fromTextArray(
                    columnWidths: {
                      0: const pw.FlexColumnWidth(1.2),
                      1: const pw.FlexColumnWidth(1),
                      2: const pw.FlexColumnWidth(1),
                      3: const pw.FlexColumnWidth(1),
                      4: const pw.FlexColumnWidth(1),
                      5: const pw.FlexColumnWidth(2),
                      6: const pw.FlexColumnWidth(1),
                      7: const pw.FlexColumnWidth(1),
                      8: const pw.FlexColumnWidth(2),
                      9: const pw.FlexColumnWidth(1),
                      10: const pw.FlexColumnWidth(1),
                      11: const pw.FlexColumnWidth(2),
                      12: const pw.FlexColumnWidth(1),
                      13: const pw.FlexColumnWidth(1),
                    },
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.centerLeft,
                      3: pw.Alignment.centerLeft,
                      4: pw.Alignment.centerRight,
                      5: pw.Alignment.centerLeft,
                      6: pw.Alignment.centerRight,
                      7: pw.Alignment.centerRight,
                      8: pw.Alignment.centerLeft,
                      9: pw.Alignment.centerRight,
                      10: pw.Alignment.centerRight,
                      11: pw.Alignment.centerLeft,
                      12: pw.Alignment.centerRight,
                      13: pw.Alignment.centerRight,
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
                      9: pw.Alignment.center,
                      10: pw.Alignment.center,
                      11: pw.Alignment.center,
                      12: pw.Alignment.center,
                    },
                    context: context,
                    data: mainList[i],
                    cellStyle: const pw.TextStyle(fontSize: 7),
                    headerStyle: pw.TextStyle(
                        fontSize: 8, fontWeight: pw.FontWeight.bold),
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

      // final file = File("example.pdf");
      await file.writeAsBytes(await pdf.save());

      // 'pdf Download SuccessFull.😀'.successSnackbar;
      'pdf Download SuccessFull.😀'.successDailog;
      Timer(const Duration(seconds: 2), () {
        Get.back();
      });
      // final String filePath = testFile.absolute.path;
      final Uri uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        //
        await launchUrl(uri);
      } else {}
      isNumber.value++;
      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  createLedgerPdf({required Set partyWiseList}) async {
    try {
      isLoading.value = true;
      final pdf = pw.Document();

      List<List<List<dynamic>>> superMainList = [];
      List<List<dynamic>> newMainList = [];
      List<List<dynamic>> tempMainList = [];
      for (var i = 0; i < partyWiseList.length; i++) {
        //
        var partyName = partyList
            ?.firstWhere((element) =>
                element.id.isEqual(partyWiseList.elementAt(i)[0].pID))
            .name;
        var ptID = partyList
            ?.firstWhere((element) =>
                element.id.isEqual(partyWiseList.elementAt(i)[0].pID))
            .ptID;
        var partyType = ptID == 1
            ? 'Hospital'
            : ptID == 2
                ? 'Doctor'
                : 'Technician';

        List newList = [];
        List<List<dynamic>> newsubList = [];
        newList.addAll(partyWiseList.elementAt(i));
        newsubList.add([
          partyType.toString(),
          '$partyName',
          '',
          '',
        ]);
        newsubList.add([
          'Date',
          'Type',
          'Dr Amount',
          'Cr Amount',
          'Extra Pay',
        ]);
        for (var j = 0; j < newList.length; j++) {
          var drAmount = newList[j].drAmount.toDouble();
          var crAmount = newList[j].crAmount.toDouble();
          var extraCrAmount = newList[j].extracrAmount.toDouble();
          var date = DateTime.parse(newList[j].ledgerDate.toString());

          newsubList.add([
            date == DateTime(1800, 01, 01)
                ? ''
                : DateFormat('dd-MM-yyyy').format(date),
            newList[j].type == Constantdata.extraPayment
                ? "${newList[j].type.substring(0, 8)}-${newList[j].ledgerNote.toString()}"
                : newList[j].type == Constantdata.payment
                    ? "${newList[j].type.substring(0, 3)}-${newList[j].ledgerNote.toString()}"
                    : newList[j].type.toString(),
            drAmount < 1 ? '' : drAmount.toStringAsFixed(2),
            crAmount < 1 ? '' : crAmount.toStringAsFixed(2),
            extraCrAmount < 1 ? '' : extraCrAmount.toStringAsFixed(2),
          ]);
        }

        newList.clear();
        newMainList.addAll(newsubList);
      }

      tempMainList.addAll(newMainList);
      int a = 0;
      newMainList.clear();
      for (var i = 0; i < tempMainList.length; i++) {
        if (((i + 1) % 26) == 0) {
          // a++;

          newMainList.add(tempMainList[i]);

          List<List<dynamic>> temp = [];
          temp.addAll(newMainList);
          superMainList.add(temp);
          newMainList.clear();
        } else {
          newMainList.add(tempMainList[i]);
          if (i == (tempMainList.length - 1)) {
            List<List<dynamic>> temp = [];
            temp.addAll(newMainList);
            superMainList.add(temp);
            newMainList.clear();
          }
        }
      }

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
                          4: const pw.FlexColumnWidth(1),
                        },
                        cellAlignments: {
                          0: pw.Alignment.centerLeft,
                          1: pw.Alignment.centerLeft,
                          2: pw.Alignment.centerRight,
                          3: pw.Alignment.centerRight,
                          4: pw.Alignment.centerRight,
                        },
                        // headerAlignments: {
                        //   0: pw.Alignment.center,
                        //   1: pw.Alignment.center,
                        //   2: pw.Alignment.center,
                        //   3: pw.Alignment.center,
                        // },

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

      // final file = File("example.pdf");
      await file.writeAsBytes(await pdf.save());

      // 'pdf Download SuccessFull.😀'.successSnackbar;
      'pdf Download SuccessFull.😀'.successDailog;
      Timer(const Duration(seconds: 2), () {
        Get.back();
      });
      final Uri uri = Uri.file(file.path);
      if (await canLaunchUrl(uri)) {
        //
        await launchUrl(uri);
      } else {}
      isNumber.value++;
      isLoading.value = false;
    } catch (e) {
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

      // getPendingData();
    }
  }

  getPartyList() async {
    partyList?.clear();
    var data = await db.select(db.partyMaster).get();

    partyList?.addAll(data);

    //
    if (partyList!.isNotEmpty) {
      //
      var defualt = partyList![0].obs;
      defaultParty.value = defualt.value;
      defaultParty.refresh();

      for (var party in partyList!) {
        if (party.ptID == 1) {
          hpartyList?.add(party);
        } else if (party.ptID == 2) {
          dpartyList?.add(party);
        } else {
          tpartyList?.add(party);
        }
      }
    }

    //
    await getMaterialTypeList();
  }

  getPartyCityList() async {
    try {
      partyCityList.clear();
      // List<InputDataData> data = await db.select(db.inputData).get();
      var res = await db.select(db.inputData).get();
      //

      for (var element in res) {
        partyCityList.add(element.custBillCity);
      }

      //
      if (partyCityList.isNotEmpty) {
        //
        var defualt = partyCityList.toList();
        defaultPartyCity.value = defualt[0];
        defaultPartyCity.refresh();
      }

      //
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  getMaterialTypeList() async {
    materialTypeList?.clear();
    var data = await db.select(db.materialType).get();

    materialTypeList?.addAll(data);

    //
    if (materialTypeList!.isNotEmpty) {
      //

      defaultMaterialType.value = materialTypeList![0];
      defaultMaterialType.refresh();
    }

    //
    await getPartyCityList();
  }

  reversePaymentProcess(
      {bool? isPayment1, int? pID, List<dynamic>? paymentbackRecord}) async {
    try {
      //
      double? crAmount;
      var ptID = defaultParty.value.ptID;
      var matCode = paymentbackRecord?[Constantdata.matCodeIndex];
      var smtInvoiceNo = paymentbackRecord?[Constantdata.smtInvoiceNoIndex];

      var data = await (db.select(db.inputData)
            ..where((tbl) =>
                tbl.smtInvNo.equals(smtInvoiceNo) &
                tbl.matCode.equals(matCode)))
          .getSingle();

      var paymentLedgerID = 0;
      DateTime comissionPaidDate;
      // int comissionLedgerID;
      if (pID == 1) {
        // crAmount = paymentbackRecord?[Constantdata.hcAmountIndex];
        paymentLedgerID = data.hospitalPaymentLedgerId;

        // comissionPaidDate = data.hospitalComissionPaidDate;
        // comissionLedgerID = data.hospitalPaymentLedgerId;
        var hospital = await (db.select(db.inputData)
              ..where(
                  (tbl) => tbl.hospitalPaymentLedgerId.equals(paymentLedgerID)))
            .get();
        for (var element in hospital) {
          // print(element.hospitalPaymentLedgerId);
          var updateInputData = await (db.update(db.inputData)
                ..where((tbl) => tbl.id.equals(element.id)))
              .write(
            element.copyWith(
              hospitalComissionPaidDate: DateTime(1800, 01, 01),
              hospitalPaymentLedgerId: 0,
            ),
          );
        }
      } else if (pID == 2) {
        // crAmount = paymentbackRecord?[Constantdata.dcAmountIndex];
        paymentLedgerID = data.doctorPaymentLedgerId;
        // comissionPaidDate = data.doctorComissionPaidDate;
        // comissionLedgerID = data.doctorPaymentLedgerId;

        var doctor = await (db.select(db.inputData)
              ..where(
                  (tbl) => tbl.doctorPaymentLedgerId.equals(paymentLedgerID)))
            .get();
        for (var element in doctor) {
          // print(element.hospitalPaymentLedgerId);
          var updateInputData = await (db.update(db.inputData)
                ..where((tbl) => tbl.id.equals(element.id)))
              .write(
            element.copyWith(
              doctorComissionPaidDate: DateTime(1800, 01, 01),
              doctorPaymentLedgerId: 0,
            ),
          );
        }
      } else {
        // crAmount = paymentbackRecord?[Constantdata.tcAmountIndex];
        paymentLedgerID = data.techniqalStaffPaymentLedgerId;
        // comissionPaidDate = data.techniqalStaffComissionPaidDate;
        // comissionLedgerID = data.techniqalStaffPaymentLedgerId;
        var techniqalStaff = await (db.select(db.inputData)
              ..where((tbl) =>
                  tbl.techniqalStaffPaymentLedgerId.equals(paymentLedgerID)))
            .get();
        for (var element in techniqalStaff) {
          // print(element.hospitalPaymentLedgerId);
          var updateInputData = await (db.update(db.inputData)
                ..where((tbl) => tbl.id.equals(element.id)))
              .write(
            element.copyWith(
              techniqalStaffComissionPaidDate: DateTime(1800, 01, 01),
              techniqalStaffPaymentLedgerId: 0,
            ),
          );
        }

        // var updateInputData = await (db.update(db.inputData)
        //       ..where((tbl) => tbl.id.equals(data.id)))
        //     .write(data.copyWith(
        //   techniqalStaffComissionPaidDate: DateTime(1800, 01, 01),
        // ));
      }
      //
      if (paymentLedgerID != 0) {
        // delete latest Advance payment ledger
        var ledgerData = await (db.select(db.ledger)
              ..where((tbl) => tbl.id.equals(paymentLedgerID)))
            .getSingle();
        var ledgerAdvancePaymentData = await (db.select(db.ledger)
              ..where((tbl) =>
                  tbl.pID.equals(defaultParty.value.id) &
                  tbl.ledgerNote.equals(Constantdata.pendingPaymentNote)))
            .getSingle();

        var deleteAdvancePaymentLedgerData =
            await db.delete(db.ledger).delete(ledgerAdvancePaymentData);

        // update second last oldAdvance payment ledger
        var oldPendingPaymentNote = await (db.select(db.ledger)
              ..where((tbl) =>
                  tbl.pID.equals(defaultParty.value.id) &
                  tbl.ledgerNote.equals(Constantdata.oldPendingPaymentNote)))
            .get();
        if (oldPendingPaymentNote.isNotEmpty) {
          (db.update(db.ledger)
                ..where((tbl) => tbl.id.equals(
                    oldPendingPaymentNote[oldPendingPaymentNote.length - 1]
                        .id)))
              .write(
            oldPendingPaymentNote[oldPendingPaymentNote.length - 1]
                .copyWith(ledgerNote: Constantdata.pendingPaymentNote),
          );
        }
        var deletePaymentLedger = await db.delete(db.ledger).delete(ledgerData);

        await getGeneratedSearchData(
            start: dateRange.value.start,
            end: dateRange.value.end,
            selectedParty: defaultParty.value,
            isAllPartySelected: false,
            isAllMaterialTypeSelected: isAllMaterialTypeSelected.value,
            isAllPartyCitySelected: isAllPartyCitySelected.value,
            selectedMaterialType: defaultMaterialType.value,
            selectedPartyCity: defaultPartyCity.value,
            isAllPendingPayement: isAllPendingPayement.value,
            ptID: pID);

        'Payment Rejected Successfully'.successDailog;
        Timer(const Duration(seconds: 2), () {
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
      List<InputDataData> serachData = [];

      if (isAllPartySelected!) {
        serachData = await (db.select(db.inputData)
              ..where((tbl) =>
                  tbl.smtDocDate.isBetweenValues(start!, end!) &
                  tbl.logId.equals(0)))
            .get();
        //
      } else {
        serachData = await (db.select(db.inputData)
              ..where((tbl) =>
                  tbl.smtDocDate.isBetweenValues(start!, end!) &
                  tbl.hospitalID.equals(selectedParty!.id) &
                  tbl.logId.equals(0)))
            .get();
      }

      pendingReportData.clear();
      List sublist = [];
      sublist.add('No');
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

      for (var i = 0; i < serachData.length; i++) {
        // var checkParty = await (db.select(db.partyMaster)
        //       ..where((tbl) => tbl.id.equals(serachData[i].pID)))
        //     .get();
        bool isShowHospital;
        bool isShowDoctor;
        bool isShowTechnician;

        List<PartyMasterData>? checkHospitalParty,
            checkDoctorParty,
            checkTechnicianParty;
        if (serachData[i].hospitalID != 0) {
          checkHospitalParty = await (db.select(db.partyMaster)
                ..where((tbl) =>
                    tbl.id.equals(serachData[i].hospitalID) &
                    tbl.ptID.equals(1)))
              .get();
          isShowHospital = checkHospitalParty.isNotEmpty ? true : false;
        } else {
          isShowHospital = true;
        }
        if (serachData[i].doctorID != 0) {
          checkDoctorParty = await (db.select(db.partyMaster)
                ..where((tbl) =>
                    tbl.id.equals(serachData[i].doctorID) & tbl.ptID.equals(2)))
              .get();
          isShowDoctor = checkDoctorParty.isNotEmpty ? true : false;
        } else {
          isShowDoctor = true;
        }
        if (serachData[i].techniqalStaffID != 0) {
          checkTechnicianParty = await (db.select(db.partyMaster)
                ..where((tbl) =>
                    tbl.id.equals(serachData[i].techniqalStaffID) &
                    tbl.ptID.equals(3)))
              .get();
          isShowTechnician = checkTechnicianParty.isNotEmpty ? true : false;
        } else {
          isShowTechnician = true;
        }

        if (isShowHospital && isShowDoctor && isShowTechnician) {
          var checkMaterialType = await (db.select(db.materialType)
                ..where((tbl) => tbl.id.equals(serachData[i].mtID)))
              .get();
          if (checkMaterialType.isNotEmpty) {
            displayData.add(serachData[i].id);
            List sublist = [];

            //
            sublist.add(i + 1);
            sublist.add(serachData[i].documentType);
            sublist.add(
                DateFormat('dd.MM.yyyy').format(serachData[i].distDocDate));
            sublist.add(serachData[i].distDocNo);
            sublist.add(checkHospitalParty?.first.name ?? '');
            sublist.add(serachData[i].custBillCity);
            sublist.add(serachData[i].matCode);
            sublist.add(serachData[i].matName);
            sublist.add(checkMaterialType.first.type);
            sublist.add(serachData[i].qty);
            sublist.add(checkDoctorParty?.first.name ?? '');
            sublist.add(checkTechnicianParty?.first.name ?? '');
            sublist.add(serachData[i].saleAmount);
            sublist.add(serachData[i].totalSale);
            sublist
                .add(DateFormat('dd.MM.yyyy').format(serachData[i].smtDocDate));
            sublist.add(serachData[i].smtDocNo);
            sublist.add(serachData[i].smtInvNo);
            sublist.add(serachData[i].purchaseTaxableAmount);
            sublist.add(serachData[i].totalPurchaseAmount);

            //

            pendingReportData.add(sublist);
          } else {
            comissionAndmatTypeNaNSetData.add(serachData[i].id);
          }
        } else {
          partyNaNSetData.add(serachData[i].id);
        }
      }

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
      ledgerPartyWiseSet.clear();

      List<LedgerData> ledgerData = [];
      d.Expression<bool> party = isAllPartySelected!
          ? db.ledger.pID.isNotNull()
          : db.ledger.pID.equals(selectedParty!.id);
      d.Expression<bool> duration =
          db.ledger.ledgerDate.isBetweenValues(start!, end!);

      ledgerData = await (db.select(db.ledger)
            ..where((tbl) =>
                party &
                duration &
                tbl.ledgerNote.isNotIn([Constantdata.oldPendingPaymentNote]))
            ..orderBy([(t) => d.OrderingTerm(expression: t.ledgerDate)]))
          .get();

      ledgerReportData.addAll(ledgerData);

      Set ledgerPartySet = {};

      List<List<double>> drcrAmountList = [];
      double dramount = 0;
      double cramount = 0;
      double extraCrAmount = 0;
      for (var element in ledgerReportData) {
        bool data = ledgerPartySet.add(element.pID);

        if (data == false) {
          var index =
              ledgerPartySet.toList().indexWhere((pid) => pid == element.pID);

          drcrAmountList[index][0] += element.drAmount;
          drcrAmountList[index][1] += element.crAmount;
          drcrAmountList[index][2] += element.extracrAmount;

          //**add Record at old position */
          List tempPartyList = ledgerPartyWiseSet.toList()[index];

          // tempPartyList.add(element);
          ledgerPartyWiseSet.toList()[index].add(element);

          // ledgerPartyWiseSet.add(element);
        } else {
          dramount = 0;
          cramount = 0;
          extraCrAmount = 0;

          dramount += element.drAmount;
          cramount += element.crAmount;
          extraCrAmount += element.extracrAmount;
          List<double> sublist = [];
          sublist.addAll([dramount, cramount, extraCrAmount]);
          drcrAmountList.add(sublist);
          //**add Record at new position */
          List tempPartyList = [];
          tempPartyList.add(element);
          ledgerPartyWiseSet.add(tempPartyList);
        }
      }
      ledgerPartySet.toList().sort();
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
        extraCrAmount = drcrAmountList[i][2];

        ledgerReportData.add(
          LedgerData(
            id: 0,
            pID: ledgerPartySet.toList()[i],
            ledgerDate: DateTime(1800, 01, 01),
            ledgerNote: '',
            type: 'Total',
            drAmount: drAmount,
            crAmount: crAmount,
            extracrAmount: extraCrAmount,
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
                extracrAmount: extraCrAmount,
                extradrAmount: 0,
              ),
            );
      }
      debugPrint(ledgerReportData.toString());

      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;

      e.toString().printError;
    }
  }

  Future<void> checkLumpsumPaymen({
    PartyMasterData? selectedParty,
    RxList<List<dynamic>>? generatedReportData,
    int? ptID,
    double? lumpsumAmount,
  }) async {
    try {
      if (generatedReportData!.isEmpty) {
        "Payment not found".errorSnackbar();
      }
      var advanceAmount = await (db.select(db.ledger)
            ..where((tbl) =>
                tbl.pID.equals(selectedParty!.id) &
                tbl.ledgerNote.equals(Constantdata.pendingPaymentNote)))
          .get();
      if (advanceAmount.isNotEmpty) {
        print(advanceAmount[0].crAmount);
        lumpsumAmount = lumpsumAmount! + advanceAmount[0].crAmount;
      }

      var pName, pCommission = 0.0, totalPayAmount = 0.0;
      bool isReturn = true;
      smtInvNoSet.clear();
      dataNoSet.clear();

      // RxList<List<dynamic>>? data ;

      // List list = [];
      checkLumpsumPaymentData.clear();
      if (isReturn) {
        for (var i = 1; i < generatedReportData.length; i++) {
          if (ptID == 1) {
            // isHospital = true;
            //
            //
            pName = generatedReportData[i][Constantdata.customerIndex];
            pCommission = generatedReportData[i][Constantdata.hcAmountIndex];
            totalPayAmount += pCommission;
          } else if (ptID == 2) {
            // isDoctor = true;
            //
            //
            pName = generatedReportData[i][Constantdata.doctorNameIndex];
            pCommission = generatedReportData[i][Constantdata.dcAmountIndex];
            totalPayAmount += pCommission;
          } else {
            // isTechnician = true;
            //
            //
            pName = generatedReportData[i][Constantdata.technicianStaffIndex];
            pCommission = generatedReportData[i][Constantdata.tcAmountIndex];
            totalPayAmount += pCommission;
          }
          if (totalPayAmount <= lumpsumAmount!) {
            checkLumpsumPaymentData
                .add(generatedReportData[i][Constantdata.dataNoIndex]);
            smtInvNoSet
                .add(generatedReportData[i][Constantdata.smtInvoiceNoIndex]);
            dataNoSet.add(generatedReportData[i][Constantdata.dataNoIndex]);
            partyWisePayableAmount.value = totalPayAmount;
            partyWisePendingPaidAmount.value =
                (lumpsumAmount - totalPayAmount).abs();
          } else {
            isReturn = false;

            // generatedReportData.clear();
          }
        }
        partyWiseTotalAmount.value = totalPayAmount;

        //
        //

        //
        // if (!isReturn) {
        //   "amount of lumpsum payment is not enough".errorSnackbar();
        // }
      }

      //
      await getGeneratedSearchData(
          isAllPendingPayement: true,
          start: dateRange.value.start,
          end: dateRange.value.end,
          selectedParty: defaultParty.value,
          isAllPartySelected: false,
          isAllMaterialTypeSelected: isAllMaterialTypeSelected.value,
          isAllPartyCitySelected: isAllPartyCitySelected.value,
          selectedMaterialType: defaultMaterialType.value,
          selectedPartyCity: defaultPartyCity.value,
          ptID: ptID,
          isLumpsumPaymentSearch: true);
      //
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  Future<void> getGeneratedSearchData({
    DateTime? start,
    DateTime? end,
    bool? isAllPartySelected,
    bool? isAllPartyCitySelected,
    bool? isAllMaterialTypeSelected,
    bool? isAllPendingPayement = false,
    PartyMasterData? selectedParty,
    String? selectedPartyCity,
    MaterialTypeData? selectedMaterialType,
    int? ptID,
    bool? isLumpsumPaymentSearch = false,
  }) async {
    try {
      isLoading.value = true;

      displayData.clear();
      comissionAndmatTypeNaNSetData.clear();
      partyNaNSetData.clear();
      var serachData = [];

      ptID = selectedParty?.ptID;

      //*Duration declaraion/
      d.Expression<bool> comissionPaidDate = ptID == 1
          ? db.inputData.hospitalComissionPaidDate
              .equals(DateTime(1800, 01, 01))
          : ptID == 2
              ? db.inputData.doctorComissionPaidDate
                  .equals(DateTime(1800, 01, 01))
              : db.inputData.techniqalStaffComissionPaidDate
                  .equals(DateTime(1800, 01, 01));

      d.Expression<bool> duration = isAllPendingPayement!
          ? comissionPaidDate
          : db.inputData.smtDocDate.isBetweenValues(start!, end!);
      d.Expression<bool> partyCity = isAllPartyCitySelected!
          ? db.inputData.custBillCity.isNotNull()
          : db.inputData.custBillCity.equals(selectedPartyCity!);
      //**party declaration */
      d.Expression<bool> hospitalParty = isAllPartySelected!
          ? db.inputData.hospitalID.isNotNull()
          : db.inputData.hospitalID.equals(selectedParty!.id);
      d.Expression<bool> doctorParty = isAllPartySelected
          ? db.inputData.doctorID.isNotNull()
          : db.inputData.doctorID.equals(selectedParty!.id);
      d.Expression<bool> techniqalStaffParty = isAllPartySelected
          ? db.inputData.techniqalStaffID.isNotNull()
          : db.inputData.techniqalStaffID.equals(selectedParty!.id);

      d.Expression<bool> party = ptID == 1
          ? hospitalParty
          : ptID == 2
              ? doctorParty
              : techniqalStaffParty;

      //**LedgerParty declaration */
      // d.Expression<bool> ledgerParty = !isAllPartySelected
      //     ? db.ledger.pID.equals(selectedParty!.id)
      //     : db.ledger.pID.isNotNull();
      if (partyList!.isNotEmpty && !isLumpsumPaymentSearch!) {
        var ledgerdata = await (db.select(db.ledger)
              ..where((tbl) =>
                  tbl.pID.equals(selectedParty!.id) &
                  tbl.ledgerNote.equals(Constantdata.pendingPaymentNote)))
            .get();

        if (ledgerdata.isNotEmpty) {
          partyWisePendingPaidAmount.value = ledgerdata[0].crAmount;
        } else {
          partyWisePendingPaidAmount.value = 0;
        }
      }

      //**material declaration */
      d.Expression<bool> materialType = isAllMaterialTypeSelected!
          ? db.inputData.mtID.isNotNull()
          : db.inputData.mtID.equals(selectedMaterialType!.id);
      //

      serachData = await (db.select(db.inputData)
            ..where((tbl) =>
                duration &
                partyCity &
                party &
                materialType &
                tbl.logId.isBiggerThanValue(0))
            ..orderBy([(t) => d.OrderingTerm(expression: t.smtDocDate)]))
          .get();

      //

      generatedReportData.clear();
      List sublist = [];
      sublist.add('No');
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
      sublist.add('H(%)');
      sublist.add('H-cAmount');
      sublist.add('D(%)');
      sublist.add('D-cAmount');
      sublist.add('T(%)');
      sublist.add('T-cAmount');
      generatedReportData.add(sublist);
      //
      //
      if (!isAllPartySelected && !isLumpsumPaymentSearch!) {
        Timer(Duration.zero, () {
          partyWiseTotalAmount.value = 0.0;
          partyWisePaidAmount.value = 0.0;
          partyWisePayableAmount.value = 0.0;
        });
      }

      for (var i = 0; i < serachData.length; i++) {
        bool isShowHospital;
        bool isShowDoctor;
        bool isShowTechnician;

        List<PartyMasterData>? checkHospitalParty,
            checkDoctorParty,
            checkTechnicianParty;

        if (serachData[i].hospitalID != 0) {
          checkHospitalParty = await (db.select(db.partyMaster)
                ..where((tbl) =>
                    tbl.id.equals(serachData[i].hospitalID) &
                    tbl.ptID.equals(1)))
              .get();
          isShowHospital = checkHospitalParty.isNotEmpty ? true : false;
        } else {
          isShowHospital = true;
        }
        if (serachData[i].doctorID != 0) {
          checkDoctorParty = await (db.select(db.partyMaster)
                ..where((tbl) =>
                    tbl.id.equals(serachData[i].doctorID) & tbl.ptID.equals(2)))
              .get();
          isShowDoctor = checkDoctorParty.isNotEmpty ? true : false;
        } else {
          isShowDoctor = true;
        }
        if (serachData[i].techniqalStaffID != 0) {
          checkTechnicianParty = await (db.select(db.partyMaster)
                ..where((tbl) =>
                    tbl.id.equals(serachData[i].techniqalStaffID) &
                    tbl.ptID.equals(3)))
              .get();
          isShowTechnician = checkTechnicianParty.isNotEmpty ? true : false;
        } else {
          isShowTechnician = true;
        }

        if (isShowHospital && isShowDoctor && isShowTechnician) {
          var checkMaterialType = await (db.select(db.materialType)
                ..where((tbl) => tbl.id.equals(serachData[i].mtID)))
              .get();
          if (checkMaterialType.isNotEmpty) {
            displayData.add(i + 1);
            List sublist = [];

            //
            sublist.add(i + 1);
            sublist.add(serachData[i].documentType);
            sublist.add(
                DateFormat('dd.MM.yyyy').format(serachData[i].distDocDate));
            sublist.add(serachData[i].distDocNo);
            sublist.add(checkHospitalParty?.first.name ?? "");
            sublist.add(serachData[i].custBillCity);
            sublist.add(serachData[i].matCode);
            sublist.add(serachData[i].matName);
            sublist.add(checkMaterialType.first.type);
            sublist.add(serachData[i].qty);
            sublist.add(checkDoctorParty?.first.name ?? "");
            sublist.add(checkTechnicianParty?.first.name ?? "");
            sublist.add(serachData[i].saleAmount);
            sublist.add(serachData[i].totalSale);
            sublist
                .add(DateFormat('dd.MM.yyyy').format(serachData[i].smtDocDate));
            sublist.add(serachData[i].smtDocNo);
            sublist.add(serachData[i].smtInvNo);
            sublist.add(serachData[i].purchaseTaxableAmount);
            sublist.add(serachData[i].totalPurchaseAmount);
            sublist.add(serachData[i].hospitalComission);
            sublist.add(serachData[i].hospitalComissionAmount);
            sublist.add(serachData[i].doctorComission);
            sublist.add(serachData[i].doctorComissionAmount);
            sublist.add(serachData[i].techniqalStaffComission);
            sublist.add(serachData[i].techniqalStaffComissionAmount);
            sublist.add(serachData[i].hospitalComissionPaidDate);
            sublist.add(serachData[i].doctorComissionPaidDate);
            sublist.add(serachData[i].techniqalStaffComissionPaidDate);

            //

            generatedReportData.add(sublist);

            if (!isAllPartySelected) {
              var date = ptID == 1
                  ? serachData[i].hospitalComissionPaidDate
                  : ptID == 2
                      ? serachData[i].doctorComissionPaidDate
                      : serachData[i].techniqalStaffComissionPaidDate;
              var cAmount = ptID == 1
                  ? serachData[i].hospitalComissionAmount
                  : ptID == 2
                      ? serachData[i].doctorComissionAmount
                      : serachData[i].techniqalStaffComissionAmount;

              if (!isLumpsumPaymentSearch!) {
                if (date.isAfter(DateTime(1800, 01, 01))) {
                  partyWiseTotalAmount.value = partyWiseTotalAmount.value +
                      double.parse(cAmount.toString());
                  partyWisePaidAmount.value = partyWisePaidAmount.value +
                      double.parse(cAmount.toString());
                  partyWisePayableAmount.value =
                      partyWiseTotalAmount.value - partyWisePaidAmount.value;
                } else {
                  partyWiseTotalAmount.value = partyWiseTotalAmount.value +
                      double.parse(cAmount.toString());

                  partyWisePayableAmount.value =
                      partyWiseTotalAmount.value - partyWisePaidAmount.value;
                }
              }
            }
          } else {
            comissionAndmatTypeNaNSetData.add(i + 1);
          }
        } else {
          partyNaNSetData.add(i + 1);
        }
      }

      //
      //
      //
      isLoading.value = false;
    } catch (e) {
      // e.toString().printError;
      e.toString().errorSnackbar;
    }
  }

  Future<void> partyWisePayment({
    required PartyMasterData? selectedParty,
    required double? crAmount,
    required double? pendingPaidAmount,
    int? ptID,
    bool? isAllPendingPayement = false,
    String ledgerNote = "",
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
            ledgerNote: ledgerNote,
            extradrAmount: 0,
            extracrAmount: 0,
            // ledgerNote: ledgerNote
          ));

      //

      var pendingPaidPayemnt = await (db.select(db.ledger)
            ..where((tbl) =>
                tbl.pID.equals(selectedParty.id) &
                tbl.ledgerNote.equals(Constantdata.pendingPaymentNote)))
          .get();
      if (pendingPaidPayemnt.isNotEmpty) {
        print(pendingPaidPayemnt);

        db.update(db.ledger)
          ..where((tbl) =>
              tbl.pID.equals(selectedParty.id) &
              tbl.ledgerNote.equals(Constantdata.pendingPaymentNote))
          ..write(pendingPaidPayemnt[pendingPaidPayemnt.length - 1]
              .copyWith(ledgerNote: Constantdata.oldPendingPaymentNote));
      }
      var pendingPaidPayment =
          await db.into(db.ledger).insert(LedgerCompanion.insert(
                type: Constantdata.payment,
                pID: selectedParty.id,
                ledgerDate: currentDate,
                drAmount: 0,
                crAmount: pendingPaidAmount!,
                ledgerNote: Constantdata.pendingPaymentNote,
                extradrAmount: 0,
                extracrAmount: 0,
                // ledgerNote: ledgerNote
              ));

      //
      if (ledgerData > 0) {
        List<String> smtInvNoList = [];
        List<InputDataData> inputDatadata = [];
        for (var i = 1; i < generatedReportData.length; i++) {
          var no = generatedReportData[i][Constantdata.dataNoIndex];
          if (dataNoSet.contains(no)) {
            var smtInvoiceNo = generatedReportData[i]
                    [Constantdata.smtInvoiceNoIndex]
                .toString();
            var matCode =
                generatedReportData[i][Constantdata.matCodeIndex].toString();
            var inputData = await (db.select(db.inputData)
                  ..where((tbl) =>
                      tbl.smtInvNo.equals(smtInvoiceNo) &
                      tbl.matCode.equals(matCode)))
                .getSingle();
            inputDatadata.add(inputData);
          }
        }

        for (var i = 0; i < inputDatadata.length; i++) {
          var hinputData = inputDatadata[i].copyWith(
            hospitalComissionPaidDate: currentDate,
            hospitalPaymentLedgerId: ledgerData,
          );
          var dinputData = inputDatadata[i].copyWith(
              doctorComissionPaidDate: currentDate,
              doctorPaymentLedgerId: ledgerData);
          var tinputData = inputDatadata[i].copyWith(
            techniqalStaffComissionPaidDate: currentDate,
            techniqalStaffPaymentLedgerId: ledgerData,
          );
          var inputData = ptID == 1
              ? hinputData
              : ptID == 2
                  ? dinputData
                  : tinputData;

          var updateRes = await (db.update(db.inputData)
                ..where((tbl) => tbl.id.equals(inputDatadata[i].id)))
              .write(inputData);
        }
        // Get.back();
        // 'Payment Added Successfully'.successSnackbar;
        checkLumpsumPaymentData.clear();
        await getGeneratedSearchData(
          isAllPendingPayement: isAllPendingPayement,
          start: dateRange.value.start,
          end: dateRange.value.end,
          selectedParty: defaultParty.value,
          isAllPartySelected: false,
          isAllMaterialTypeSelected: isAllMaterialTypeSelected.value,
          isAllPartyCitySelected: isAllPartyCitySelected.value,
          selectedMaterialType: defaultMaterialType.value,
          selectedPartyCity: defaultPartyCity.value,
          ptID: ptID,
        );
        'Payment Added Successfully'.successDailog;
        Timer(const Duration(seconds: 2), () {
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

  Future<void> partyWiseExtraPayment({
    required PartyMasterData? selectedParty,
    required double? crAmount,
    // int? ptID,
    required String? ledgerNote,
  }) async {
    try {
      isLoading.value = true;
      var currentDate = DateTime.now();
      var ledgerData = await db.into(db.ledger).insert(LedgerCompanion.insert(
            type: Constantdata.extraPayment,
            pID: selectedParty!.id,
            ledgerDate: currentDate,
            drAmount: 0,
            crAmount: 0,
            ledgerNote: ledgerNote!,
            extradrAmount: 0,
            extracrAmount: crAmount!,

            // ledgerNote: ledgerNote
          ));
      //
      //

      //
      if (ledgerData > 0) {
        'Payment Added Successfully'.successDailog;
        Timer(const Duration(seconds: 2), () {
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

      filePath = result.files.first.path!;

      final input = File(filePath!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();
      //

      if (fields[0].length != 18) {
        'Invalid File'.errorSnackbar;
        isLoading.value = false;
        return;
      }
      // displyaData.addAll(fields);
      //
      List tempList = [];
      tempList.add("No.");
      tempList.addAll(fields[0]);
      fields[0].clear();
      fields[0].addAll(tempList);
      for (var i = 1; i < fields.length; i++) {
        List<dynamic> field = fields[i];
        tempList.clear();
        tempList.add(i);
        tempList.addAll(field);

        fields[i].clear();
        fields[i].addAll(tempList);
      }

      await checkInputData(fields: fields);
    } catch (e) {
      isLoading.value = false;
      'Invalid File'.toString().errorSnackbar;

      e.toString().printError;
    }
  }

  Future<void> addAllPartyData(
      {List<List<dynamic>>? fields, int? index}) async {
    try {
      isLoading.value = true;
      List<List<dynamic>> data = [];
      data.addAll(fields!);
      // displayData.clear();
      // partyNaNSetData.clear();
      // comissionAndmatTypeNaNSetData.clear();
      fields.clear();
      fields.addAll(data);

      Set<String> partyNameList = {};
      for (var i = 0; i < fields.length; i++) {
        if (i != 0 && fields[i][index!].toString().isNotEmpty) {
          partyNameList.add(fields[i][index].toString());
        }
      }

      index = index == Constantdata.customerIndex
          ? 1
          : index == Constantdata.doctorNameIndex
              ? 2
              : 3;
      var partydata = await (db.select(db.partyMaster)
            ..where((tbl) =>
                tbl.name.isIn(partyNameList) & tbl.ptID.equals(index!)))
          .get();
      for (var element in partydata) {
        partyNameList.remove(element.name);
      }

      String party = index == 1
          ? 'Hospital'
          : index == 2
              ? 'Doctor'
              : 'Technician';
      if (partyNameList.isNotEmpty) {
        Get.defaultDialog(
          content: Column(
            children: [
              Text(
                '${partyNameList.length} Party Missing',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.height * 0.02,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  height: Get.height * 0.2,
                  width: Get.width * 0.6,
                  color: lCOLOR_PRIMARY.withOpacity(0.1),
                  child: ListView.builder(
                    itemCount: partyNameList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          partyNameList.toList()[index],
                          style: TextStyle(fontSize: Get.height * 0.02),
                        ),
                        leading: const Icon(Icons.person),
                      );
                    },
                  ),
                ),
              ),
              Text(
                'Are you want to add All $party Party',
                style: TextStyle(fontSize: Get.height * 0.02),
              ),
            ],
          ),
          textConfirm: 'Ok',
          confirmTextColor: Colors.white,
          onConfirm: () async {
            if (index == 1) {
              await db.batch((batch) {
                for (var element in partyNameList) {
                  batch.insert(
                      db.partyMaster,
                      PartyMasterCompanion.insert(
                        name: element,
                        ptID: 1,
                      ));
                }
              });
            } else if (index == 2) {
              await db.batch((batch) {
                for (var element in partyNameList) {
                  batch.insert(
                      db.partyMaster,
                      PartyMasterCompanion.insert(
                        name: element,
                        ptID: 2,
                      ));
                }
              });
            } else {
              await db.batch((batch) {
                for (var element in partyNameList) {
                  batch.insert(
                      db.partyMaster,
                      PartyMasterCompanion.insert(
                        name: element,
                        ptID: 3,
                      ));
                }
              });
            }
            //
            var pdata = await db.select(db.partyMaster).get();
            partyList?.clear();
            partyList?.addAll(pdata);
            defaultParty.value = pdata[0];
            defaultParty.refresh();

            Get.back();

            'All ${partyNameList.length} Party Added Successfully'
                .successDailog;
            Timer(const Duration(seconds: 2), () {
              Get.back();
              checkInputData(
                fields: pendingReportData,
              );
            });
          },
          textCancel: 'Cancel',
          cancelTextColor: lCOLOR_PRIMARY,
          onCancel: () {
            Get.back();
          },
        );
      } else {
        if (index == 3) {
          await checkInputData(
            fields: pendingReportData,
          );
        }
        '$party Party already added.'.errorSnackbar;
      }

      isLoading.value = false;
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  Future<void> checkInputData({List<List<dynamic>>? fields}) async {
    isLoading.value = true;
    List<List<dynamic>> data = [];
    data.addAll(fields!);
    displayData.clear();
    partyNaNSetData.clear();
    comissionAndmatTypeNaNSetData.clear();
    fields.clear();
    fields.addAll(data);
    partyList = await db.select(db.partyMaster).get();
    if (partyList!.isNotEmpty) {
      defaultParty.value = partyList![0];
    }
    materialTypeList = await db.select(db.materialType).get();
    if (materialTypeList!.isNotEmpty) {
      defaultMaterialType.value = materialTypeList![0];
    }
    for (var i = 1; i < data.length; i++) {
      await addInputData(data[i]);
    }

    pendingReportData.clear();
    pendingReportData.addAll(data);

    isLoading.value = false;
  }

  Future<bool> checkMaterialType(String materialType) async {
    var res = await (db.select(db.materialType)
          ..where((tbl) => tbl.type.equals(materialType)))
        .get();

    if (res.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<void> addInputData(List<dynamic> data) async {
    try {
      bool isShowHospital;
      bool isShowDoctor;
      bool isShowTechnician;

      List<PartyMasterData>? resHospitalParty,
          resDoctorParty,
          resTechnicianParty;
      if (data[Constantdata.customerIndex] != "") {
        resHospitalParty = await (db.select(db.partyMaster)
              ..where((tbl) =>
                  tbl.name.equals(data[Constantdata.customerIndex]) &
                  tbl.ptID.equals(1)))
            .get();
        isShowHospital = resHospitalParty.isNotEmpty ? true : false;
      } else {
        isShowHospital = true;
      }
      if (data[Constantdata.doctorNameIndex] != "") {
        resDoctorParty = await (db.select(db.partyMaster)
              ..where((tbl) =>
                  tbl.name.equals(data[Constantdata.doctorNameIndex]) &
                  tbl.ptID.equals(2)))
            .get();
        isShowDoctor = resDoctorParty.isNotEmpty ? true : false;
      } else {
        isShowDoctor = true;
      }
      if (data[Constantdata.technicianStaffIndex] != "") {
        resTechnicianParty = await (db.select(db.partyMaster)
              ..where((tbl) =>
                  tbl.name.equals(data[Constantdata.technicianStaffIndex]) &
                  tbl.ptID.equals(3)))
            .get();
        isShowTechnician = resTechnicianParty.isNotEmpty ? true : false;
      } else {
        isShowTechnician = true;
      }

      if (isShowTechnician && isShowDoctor && isShowHospital) {
        materialTypeList?.clear();
        materialTypeList = await (db.select(db.materialType)
              ..where((tbl) => tbl.type.equals(
                  "${data[Constantdata.matTypeIndex]}~${data[Constantdata.matNameIndex]}")))
            .get();

        if (materialTypeList!.isNotEmpty) {
          isShowDoctor = false;
          isShowHospital = false;
          isShowTechnician = false;
          List<PartyComissionDetailData>? resTechnicianPartyComission,
              resDoctorPartyComission,
              resHospitalPartyComission;
          if (data[Constantdata.customerIndex] != "") {
            resHospitalPartyComission =
                await (db.select(db.partyComissionDetail)
                      ..where((tbl) =>
                          tbl.pID.equals(resHospitalParty![0].id) &
                          tbl.mtID.equals(materialTypeList![0].id)))
                    .get();

            isShowHospital =
                resHospitalPartyComission.isNotEmpty ? true : false;
          } else {
            isShowHospital = true;
          }
          if (data[Constantdata.doctorNameIndex] != "") {
            resDoctorPartyComission = await (db.select(db.partyComissionDetail)
                  ..where((tbl) =>
                      tbl.pID.equals(resDoctorParty![0].id) &
                      tbl.mtID.equals(materialTypeList![0].id)))
                .get();

            isShowDoctor = resDoctorPartyComission.isNotEmpty ? true : false;
          } else {
            isShowDoctor = true;
          }
          if (data[Constantdata.technicianStaffIndex] != "") {
            resTechnicianPartyComission =
                await (db.select(db.partyComissionDetail)
                      ..where((tbl) =>
                          tbl.pID.equals(resTechnicianParty![0].id) &
                          tbl.mtID.equals(materialTypeList![0].id)))
                    .get();

            isShowTechnician =
                resTechnicianPartyComission.isNotEmpty ? true : false;
          } else {
            isShowTechnician = true;
          }

          if (isShowTechnician && isShowDoctor && isShowHospital) {
            displayData.add(data[Constantdata.dataNoIndex]);
            var hcomission = resHospitalPartyComission?[0].comission1;
            // var dcomission = resHospitalPartyComission[0].comission1;
            // var tcomission = resTechnicianPartyComission[0].comission1;
          } else {
            comissionAndmatTypeNaNSetData.add(data[Constantdata.dataNoIndex]);
            'Comission Not Found'.errorSnackbar;
          }
        } else {
          comissionAndmatTypeNaNSetData.add(data[Constantdata.dataNoIndex]);
          'Material Type Not Found'.errorSnackbar;
        }
      } else {
        partyNaNSetData.add(data[Constantdata.dataNoIndex]);
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
      List<String> smtInvNoList = [];

      for (var i = 1; i < data!.length; i++) {
        smtInvNoList.add(data[i][Constantdata.smtInvoiceNoIndex]);
      }

      var res = await (db.select(db.inputData)
            ..where(
                (tbl) => tbl.smtInvNo.isIn(smtInvNoList) & tbl.logId.equals(0)))
          .get();
      if (res.isNotEmpty) {
        //
        Set<int> hospitalPartySet = {}; //{1,2,3}
        List hospitalPartyTotalComissionSet = []; //[100,200,300]
        List<List<int>> hospitalPartyWiseList = [];
        Set<int> doctorPartySet = {}; //{1,2,3}
        List doctorPartyTotalComissionSet = []; //[100,200,300]
        List<List<int>> doctorPartyWiseList = [];
        Set<int> technicianPartySet = {}; //{1,2,3}
        List technicianPartyTotalComissionSet = []; //[100,200,300]
        List<List<int>> technicianPartyWiseList = [];
        // GetStorage('box').write('logID', 0);
        var logID = GetStorage('box').read('logID') ?? 0;

        GetStorage('box').write('logID', logID + 1);

        var pendingData = await (db.select(db.inputData)
              ..where((tbl) => tbl.logId.equals(0)))
            .get();

        for (var element in pendingData) {
          bool isShowHospital;
          bool isShowDoctor;
          bool isShowTechnician;

          List<PartyMasterData>? checkHospitalParty,
              checkDoctorParty,
              checkTechnicianParty;
          if (element.hospitalID != 0) {
            checkHospitalParty = await (db.select(db.partyMaster)
                  ..where((tbl) =>
                      tbl.id.equals(element.hospitalID) & tbl.ptID.equals(1)))
                .get();
            isShowHospital = checkHospitalParty.isNotEmpty ? true : false;
          } else {
            isShowHospital = true;
          }
          if (element.doctorID != 0) {
            checkDoctorParty = await (db.select(db.partyMaster)
                  ..where((tbl) =>
                      tbl.id.equals(element.doctorID) & tbl.ptID.equals(2)))
                .get();
            isShowDoctor = checkDoctorParty.isNotEmpty ? true : false;
          } else {
            isShowDoctor = true;
          }
          if (element.techniqalStaffID != 0) {
            checkTechnicianParty = await (db.select(db.partyMaster)
                  ..where((tbl) =>
                      tbl.id.equals(element.techniqalStaffID) &
                      tbl.ptID.equals(3)))
                .get();
            isShowTechnician = checkTechnicianParty.isNotEmpty ? true : false;
          } else {
            isShowTechnician = true;
          }

          if (isShowHospital && isShowDoctor && isShowTechnician) {
            var checkMaterialType = await (db.select(db.materialType)
                  ..where((tbl) => tbl.id.equals(element.mtID)))
                .get();
            if (checkMaterialType.isNotEmpty) {
              isShowDoctor = false;
              isShowHospital = false;
              isShowTechnician = false;
              List<PartyComissionDetailData>? checkTechnicianPartyComission,
                  checkDoctorPartyComission,
                  checkHospitalPartyComission;
              if (element.hospitalID != 0) {
                checkHospitalPartyComission =
                    await (db.select(db.partyComissionDetail)
                          ..where((tbl) =>
                              tbl.pID.equals(checkHospitalParty![0].id) &
                              tbl.mtID.equals(checkMaterialType[0].id)))
                        .get();

                isShowHospital =
                    checkHospitalPartyComission.isNotEmpty ? true : false;
              } else {
                isShowHospital = true;
              }
              if (element.doctorID != 0) {
                checkDoctorPartyComission =
                    await (db.select(db.partyComissionDetail)
                          ..where((tbl) =>
                              tbl.pID.equals(checkDoctorParty![0].id) &
                              tbl.mtID.equals(checkMaterialType[0].id)))
                        .get();

                isShowDoctor =
                    checkDoctorPartyComission.isNotEmpty ? true : false;
              } else {
                isShowDoctor = true;
              }
              if (element.techniqalStaffID != 0) {
                checkTechnicianPartyComission =
                    await (db.select(db.partyComissionDetail)
                          ..where((tbl) =>
                              tbl.pID.equals(checkTechnicianParty![0].id) &
                              tbl.mtID.equals(checkMaterialType[0].id)))
                        .get();

                isShowTechnician =
                    checkTechnicianPartyComission.isNotEmpty ? true : false;
              } else {
                isShowTechnician = true;
              }

              if (isShowTechnician && isShowDoctor && isShowHospital) {
                isShowDoctor = false;
                isShowHospital = false;
                isShowTechnician = false;
                // displayData.add(data[15].toString());
                var logID = GetStorage('box').read('logID');

                //For Hospital
                double hospitalComission, hospitalComissionAmount;
                //For Doctor
                double docotorComission, doctorComissionAmount;
                //For Technician
                double technicianComission, technicianComissionAmount;
                if (element.hospitalID != 0) {
                  hospitalComission =
                      checkHospitalPartyComission![0].comission1;
                  hospitalComissionAmount = double.parse(
                      ((hospitalComission * element.totalSale) / 100)
                          .toStringAsFixed(2));

                  if (hospitalPartySet.contains(element.hospitalID)) {
                    int index = hospitalPartySet
                        .toList()
                        .indexWhere((item) => item.isEqual(element.hospitalID));

                    var oldCommision =
                        hospitalPartyTotalComissionSet.elementAt(index);

                    hospitalPartyTotalComissionSet[index] =
                        oldCommision + hospitalComissionAmount;
                    hospitalPartyWiseList[index].add(element.id);

                    // partyTotalComissionSet.add(comissionAmount);
                  } else {
                    hospitalPartySet.add(element.hospitalID);
                    int index = hospitalPartySet
                        .toList()
                        .indexWhere((item) => item.isEqual(element.hospitalID));

                    hospitalPartyTotalComissionSet.insert(
                        index, hospitalComissionAmount);
                    List<int> party = [];
                    party.add(element.id);
                    hospitalPartyWiseList.insert(index, party);
                    // partyTotalComissionSet.elementAt(index);
                  }
                  isShowHospital = true;
                } else {
                  hospitalComission = 0;
                  hospitalComissionAmount = 0;
                  isShowHospital = true;
                }
                if (element.doctorID != 0) {
                  docotorComission = checkDoctorPartyComission![0].comission1;
                  doctorComissionAmount = double.parse(
                      ((docotorComission * element.totalSale) / 100)
                          .toStringAsFixed(2));

                  if (doctorPartySet.contains(element.doctorID)) {
                    int index = doctorPartySet
                        .toList()
                        .indexWhere((item) => item.isEqual(element.doctorID));

                    var oldCommision =
                        doctorPartyTotalComissionSet.elementAt(index);

                    doctorPartyTotalComissionSet[index] =
                        oldCommision + doctorComissionAmount;
                    doctorPartyWiseList[index].add(element.id);

                    // partyTotalComissionSet.add(comissionAmount);
                  } else {
                    doctorPartySet.add(element.doctorID);
                    int index = doctorPartySet
                        .toList()
                        .indexWhere((item) => item.isEqual(element.doctorID));

                    doctorPartyTotalComissionSet.insert(
                        index, doctorComissionAmount);
                    List<int> party = [];
                    party.add(element.id);
                    doctorPartyWiseList.insert(index, party);
                    // partyTotalComissionSet.elementAt(index);
                  }
                  isShowDoctor = true;
                } else {
                  docotorComission = 0;
                  doctorComissionAmount = 0;
                  isShowDoctor = true;
                }
                if (element.techniqalStaffID != 0) {
                  technicianComission =
                      checkTechnicianPartyComission![0].comission1;
                  technicianComissionAmount = double.parse(
                      ((technicianComission * element.totalSale) / 100)
                          .toStringAsFixed(2));
                  if (technicianPartySet.contains(element.techniqalStaffID)) {
                    int index = technicianPartySet.toList().indexWhere(
                        (item) => item.isEqual(element.techniqalStaffID));

                    var oldCommision =
                        technicianPartyTotalComissionSet.elementAt(index);

                    technicianPartyTotalComissionSet[index] =
                        oldCommision + technicianComissionAmount;
                    technicianPartyWiseList[index].add(element.id);

                    // partyTotalComissionSet.add(comissionAmount);
                  } else {
                    technicianPartySet.add(element.techniqalStaffID);
                    int index = technicianPartySet.toList().indexWhere(
                        (item) => item.isEqual(element.techniqalStaffID));

                    technicianPartyTotalComissionSet.insert(
                        index, technicianComissionAmount);
                    List<int> party = [];
                    party.add(element.id);
                    technicianPartyWiseList.insert(index, party);
                    // partyTotalComissionSet.elementAt(index);
                  }
                  isShowTechnician = true;
                } else {
                  technicianComission = 0;
                  technicianComissionAmount = 0;
                  isShowTechnician = true;
                }
                if (isShowHospital == true &&
                    isShowDoctor == true &&
                    isShowTechnician == true) {
                  var resComissionUpdate = await (db.update(db.inputData)
                        ..where((tbl) => tbl.id.equals(element.id)))
                      .write(
                    element.copyWith(
                        hospitalComission:
                            double.parse(hospitalComission.toString()),
                        hospitalComissionAmount:
                            double.parse(hospitalComissionAmount.toString()),
                        doctorComission:
                            double.parse(docotorComission.toString()),
                        doctorComissionAmount:
                            double.parse(doctorComissionAmount.toString()),
                        techniqalStaffComission:
                            double.parse(technicianComission.toString()),
                        techniqalStaffComissionAmount:
                            double.parse(technicianComissionAmount.toString()),
                        // technicianComission: technicianComission,
                        // technicianComissionAmount: technicianComissionAmount,
                        logId: logID),
                  );
                }
              }
            } else {
              comissionAndmatTypeNaNSetData.add(element.id);
            }
          } else {
            partyNaNSetData.add(element.id);
          }
        }

        // List ledgerIDList = [];

        // for (var i = 0; i < hospitalPartySet.length; i++) {
        //
        //   var pID = hospitalPartySet.elementAt(i);
        //
        //   var totalComission = hospitalPartyTotalComissionSet.elementAt(i);
        //
        //   var resLedger =
        //       await db.into(db.ledger).insert(LedgerCompanion.insert(
        //             type: 'sale commission',
        //             pID: pID,
        //             ledgerDate: DateTime.now(),
        //             drAmount: totalComission,
        //             crAmount: 0,
        //             extracrAmount: 0,
        //             extradrAmount: 0,
        //             ledgerNote: Constantdata.defualtNote,
        //           ));
        //
        //   ledgerIDList.add(resLedger);
        // }

        // for (var i = 0; i < hospitalPartyWiseList.length; i++) {
        //   var element = hospitalPartyWiseList[i];
        //   for (var j = 0; j < element.length; j++) {
        //     var data = await (db.select(db.inputData)
        //           ..where((tbl) => tbl.smtInvNo.equals(element[j])))
        //         .get();
        //
        //
        //
        //     var resUpdate = await (db.update(db.inputData)
        //           ..where((tbl) => tbl.smtInvNo.equals(element[j])))
        //         .write(data[0].copyWith(
        //       hospitalGenerateLedgerId: ledgerIDList[i],
        //     ));
        //
        //
        //   }
        // }
        await generateComission(
            partySet: doctorPartySet,
            partyTotalComissionSet: doctorPartyTotalComissionSet,
            partyWiseList: doctorPartyWiseList,
            partyType: 2);
        await generateComission(
            partySet: hospitalPartySet,
            partyTotalComissionSet: hospitalPartyTotalComissionSet,
            partyWiseList: hospitalPartyWiseList,
            partyType: 1);
        await generateComission(
            partySet: technicianPartySet,
            partyTotalComissionSet: technicianPartyTotalComissionSet,
            partyWiseList: technicianPartyWiseList,
            partyType: 3);

        // var data = db.select(db.inputData).get();
        pendingReportData.clear();
        isLoading.value = false;
        // 'Generate Report Successfully'.successSnackbar;
        'Generate Report Successfully'.successDailog;
        Timer(const Duration(seconds: 2), () {
          Get.back();
        });
      } else {
        isLoading.value = false;
        'No Data Found'.errorSnackbar;
      }
    } catch (e) {
      printError(info: e.toString());
      e.toString().errorSnackbar;
    }
  }

  Future<void> generateComission({
    Set<int>? partySet,
    List? partyTotalComissionSet,
    List<List<int>>? partyWiseList,
    int? partyType,
  }) async {
    List ledgerIDList = [];
    for (var i = 0; i < partySet!.length; i++) {
      var pID = partySet.elementAt(i);

      var totalComission = partyTotalComissionSet!.elementAt(i);

      var resLedger = await db.into(db.ledger).insert(LedgerCompanion.insert(
            type: Constantdata.generateComission,
            pID: pID,
            ledgerDate: DateTime.now(),
            drAmount: totalComission,
            crAmount: 0,
            extracrAmount: 0,
            extradrAmount: 0,
            ledgerNote: Constantdata.defualtAutoNote,
          ));

      ledgerIDList.add(resLedger);
    }

    for (var i = 0; i < partyWiseList!.length; i++) {
      var element = partyWiseList[i];
      for (var j = 0; j < element.length; j++) {
        var data = await (db.select(db.inputData)
              ..where((tbl) => tbl.id.equals(element[j])))
            .getSingle();

        if (partyType == 1) {
          data = data.copyWith(
            hospitalGenerateLedgerId: ledgerIDList[i],
          );
        } else if (partyType == 2) {
          data = data.copyWith(
            doctorGenerateLedgerId: ledgerIDList[i],
          );
        } else {
          data = data.copyWith(
            techniqalStaffGenerateLedgerId: ledgerIDList[i],
          );
        }
        var resUpdate = await (db.update(db.inputData)
              ..where((tbl) => tbl.id.equals(element[j])))
            .write(data);
      }
    }
  }

  Future<void> insertData(List<List<dynamic>> data) async {
    try {
      partyList = await (db.select(db.partyMaster)).get();
      materialTypeList = await (db.select(db.materialType)).get();
      if (materialTypeList!.isNotEmpty) {
        defaultMaterialType.value = materialTypeList![0];
      }

      var tempList = [];
      // TODO: insert data Duaring check already exist or not
      List smtInvNoList = [];
      for (var i = 1; i < data.length; i++) {
        String smtInvNo = (data[i][Constantdata.smtInvoiceNoIndex]).toString();
        // String smtDocDateIndex = (data[i][Constantdata.smtDocDateIndex]).toString();

        var res = await (db.select(db.inputData)
              ..where((tbl) => tbl.smtInvNo.equals(smtInvNo)))
            .get();
        if (res.isNotEmpty) {
          // 'already exist'.errorSnackbar;

          smtInvNoList.add(smtInvNo);
        }
      }

      if (smtInvNoList.isNotEmpty) {
        String smtInvNoListString = '';
        for (var i = 0; i < smtInvNoList.length; i++) {
          smtInvNoListString += '${smtInvNoList[i]}, ';
        }
        Get.defaultDialog(
          content: Column(
            children: [
              Text(
                'Duplicate Invoice No',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.height * 0.02,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  color: lCOLOR_PRIMARY.withOpacity(0.1),
                  child: Text(
                    smtInvNoListString.toString(),
                    style: TextStyle(fontSize: Get.height * 0.02),
                  ),
                ),
              ),
              Text(
                'Are you want to Remove Duplicate Invoice No',
                style: TextStyle(fontSize: Get.height * 0.02),
              ),
            ],
          ),
          textConfirm: 'Ok',
          confirmTextColor: Colors.white,
          onConfirm: () async {
            Get.back();
            List<List<dynamic>> tempdata = [];
            // tempdata.addAll(data);

            for (var i = 1; i < data.length; i++) {
              String smtInvNo =
                  (data[i][Constantdata.smtInvoiceNoIndex]).toString();
              if (!smtInvNoList.contains(smtInvNo)) {
                tempdata.add(data[i]);
              }
            }

            List<dynamic> dataHeader = [];
            dataHeader.addAll(data[0]);
            data.clear();
            data.add(dataHeader);
            data.addAll(tempdata);

            pendingReportData.clear();
            pendingReportData.addAll(data);
            if (data.isEmpty) {
              'Duplicate Invoice Number Removed'.successSnackbar;
              return;
            } else {
              for (var i = 1; i < data.length; i++) {
                String documentType = data[i][Constantdata.documentTypeIndex];
                DateTime distDocDate = DateFormat("dd.MM.yyyy")
                    .parse(data[i][Constantdata.distDocDateIndex].toString());
                String distDocNo = data[i][Constantdata.distDocumentNoIndex];
                var customer = data[i][Constantdata.customerIndex];
                String custBillCity = data[i][Constantdata.custBillCityIndex];
                String matCode = data[i][Constantdata.matCodeIndex];
                String matName = data[i][Constantdata.matNameIndex];
                String matType =
                    "${data[i][Constantdata.matTypeIndex]}~${data[i][Constantdata.matNameIndex]}";
                int qty = data[i][Constantdata.quantityIndex];
                String doctorName = data[i][Constantdata.doctorNameIndex];
                String techniqalStaff =
                    data[i][Constantdata.technicianStaffIndex];
                double saleAmount = double.parse(
                    (data[i][Constantdata.salesAmountIndex]).toString());
                double totalSale = double.parse(
                    (data[i][Constantdata.totalSalesIndex]).toString());
                DateTime smtDocDate = DateFormat("dd.MM.yyyy")
                    .parse(data[i][Constantdata.smtDocDateIndex].toString());
                String smtDocNo =
                    (data[i][Constantdata.smtDocNoIndex]).toString();
                String smtInvNo =
                    (data[i][Constantdata.smtInvoiceNoIndex]).toString();
                double purchaseTaxableAmount = double.parse(
                    data[i][Constantdata.purchaseTaxableIndex].toString());
                double totalPurchaseAmount = double.parse(
                    data[i][Constantdata.totalPurchaseIndex].toString());
                int logId = 0;
                int ledgerId = 0;
                double comission = 0;
                double comissionAmount = 0;
                DateTime comissionPaidDate = DateTime(1800, 01, 01);
                double adjustComissionAmount = 0;

                var hpID = customer != ""
                    ? partyList!
                        .firstWhere((element) => element.name == customer)
                        .id
                    : 0;
                var dpID = doctorName != ""
                    ? partyList!
                        .firstWhere((element) => element.name == doctorName)
                        .id
                    : 0;
                var tpID = techniqalStaff != ""
                    ? partyList!
                        .firstWhere((element) => element.name == techniqalStaff)
                        .id
                    : 0;
                var mtID = materialTypeList!
                    .firstWhere((element) => element.type == matType)
                    .id;

                var result = await db.into(db.inputData).insert(
                      InputDataCompanion.insert(
                        documentType: documentType,
                        distDocDate: distDocDate,
                        distDocNo: distDocNo,
                        hospitalID: hpID,
                        custBillCity: custBillCity,
                        matCode: matCode,
                        matName: matName,
                        mtID: mtID,
                        qty: qty,
                        doctorID: dpID,
                        techniqalStaffID: tpID,
                        saleAmount: saleAmount,
                        totalSale: totalSale,
                        smtDocDate: smtDocDate,
                        smtDocNo: smtDocNo,
                        smtInvNo: smtInvNo,
                        purchaseTaxableAmount: purchaseTaxableAmount,
                        totalPurchaseAmount: totalPurchaseAmount,
                        logId: logId,
                        hospitalGenerateLedgerId: ledgerId,
                        hospitalPaymentLedgerId: ledgerId,
                        hospitalComission: comission,
                        hospitalComissionAmount: comissionAmount,
                        hospitalComissionPaidDate: comissionPaidDate,
                        hospitalAdjustComissionAmount: adjustComissionAmount,
                        doctorGenerateLedgerId: ledgerId,
                        doctorPaymentLedgerId: ledgerId,
                        doctorComission: comission,
                        doctorComissionAmount: comissionAmount,
                        doctorComissionPaidDate: comissionPaidDate,
                        doctorAdjustComissionAmount: adjustComissionAmount,
                        techniqalStaffGenerateLedgerId: ledgerId,
                        techniqalStaffPaymentLedgerId: ledgerId,
                        techniqalStaffComission: comission,
                        techniqalStaffComissionAmount: comissionAmount,
                        techniqalStaffComissionPaidDate: comissionPaidDate,
                        techniqalStaffAdjustComissionAmount:
                            adjustComissionAmount,
                      ),
                    );

                // 'data insert Successful'.successSnackbar;
              }
              'data Updated Successful'.successDailog;
              Timer(const Duration(seconds: 2), () {
                Get.back();
              });
            }
          },
          textCancel: 'Cancel',
          cancelTextColor: lCOLOR_PRIMARY,
          onCancel: () {
            Get.back();
          },
        );
      } else {
        for (var i = 1; i < data.length; i++) {
          String documentType = data[i][Constantdata.documentTypeIndex];
          DateTime distDocDate = DateFormat("dd.MM.yyyy")
              .parse(data[i][Constantdata.distDocDateIndex].toString());
          String distDocNo = data[i][Constantdata.distDocumentNoIndex];
          var customer = data[i][Constantdata.customerIndex];
          String custBillCity = data[i][Constantdata.custBillCityIndex];
          String matCode = data[i][Constantdata.matCodeIndex];
          String matName = data[i][Constantdata.matNameIndex];
          String matType =
              "${data[i][Constantdata.matTypeIndex]}~${data[i][Constantdata.matNameIndex]}";
          int qty = data[i][Constantdata.quantityIndex];
          String doctorName = data[i][Constantdata.doctorNameIndex];
          String techniqalStaff = data[i][Constantdata.technicianStaffIndex];
          double saleAmount =
              double.parse((data[i][Constantdata.salesAmountIndex]).toString());
          double totalSale =
              double.parse((data[i][Constantdata.totalSalesIndex]).toString());
          DateTime smtDocDate = DateFormat("dd.MM.yyyy")
              .parse(data[i][Constantdata.smtDocDateIndex].toString());
          String smtDocNo = (data[i][Constantdata.smtDocNoIndex]).toString();
          String smtInvNo =
              (data[i][Constantdata.smtInvoiceNoIndex]).toString();
          double purchaseTaxableAmount = double.parse(
              data[i][Constantdata.purchaseTaxableIndex].toString());
          double totalPurchaseAmount =
              double.parse(data[i][Constantdata.totalPurchaseIndex].toString());
          int logId = 0;
          int ledgerId = 0;
          double comission = 0;
          double comissionAmount = 0;
          DateTime comissionPaidDate = DateTime(1800, 01, 01);
          double adjustComissionAmount = 0;

          var hpID = customer != ""
              ? partyList!.firstWhere((element) => element.name == customer).id
              : 0;
          var dpID = doctorName != ""
              ? partyList!
                  .firstWhere((element) => element.name == doctorName)
                  .id
              : 0;
          var tpID = techniqalStaff != ""
              ? partyList!
                  .firstWhere((element) => element.name == techniqalStaff)
                  .id
              : 0;
          var mtID = materialTypeList!
              .firstWhere((element) => element.type == matType)
              .id;

          var result = await db.into(db.inputData).insert(
                InputDataCompanion.insert(
                  documentType: documentType,
                  distDocDate: distDocDate,
                  distDocNo: distDocNo,
                  hospitalID: hpID,
                  custBillCity: custBillCity,
                  matCode: matCode,
                  matName: matName,
                  mtID: mtID,
                  qty: qty,
                  doctorID: dpID,
                  techniqalStaffID: tpID,
                  saleAmount: saleAmount,
                  totalSale: totalSale,
                  smtDocDate: smtDocDate,
                  smtDocNo: smtDocNo,
                  smtInvNo: smtInvNo,
                  purchaseTaxableAmount: purchaseTaxableAmount,
                  totalPurchaseAmount: totalPurchaseAmount,
                  logId: logId,
                  hospitalGenerateLedgerId: ledgerId,
                  hospitalPaymentLedgerId: ledgerId,
                  hospitalComission: comission,
                  hospitalComissionAmount: comissionAmount,
                  hospitalComissionPaidDate: comissionPaidDate,
                  hospitalAdjustComissionAmount: adjustComissionAmount,
                  doctorGenerateLedgerId: ledgerId,
                  doctorPaymentLedgerId: ledgerId,
                  doctorComission: comission,
                  doctorComissionAmount: comissionAmount,
                  doctorComissionPaidDate: comissionPaidDate,
                  doctorAdjustComissionAmount: adjustComissionAmount,
                  techniqalStaffGenerateLedgerId: ledgerId,
                  techniqalStaffPaymentLedgerId: ledgerId,
                  techniqalStaffComission: comission,
                  techniqalStaffComissionAmount: comissionAmount,
                  techniqalStaffComissionPaidDate: comissionPaidDate,
                  techniqalStaffAdjustComissionAmount: adjustComissionAmount,
                ),
              );

          // 'data insert Successful'.successSnackbar;
          'data insert Successful'.successDailog;
          Timer(const Duration(seconds: 2), () {
            Get.back();
          });
        }
      }
      // var res = await db.select(db.inputData).get();

      //
    } catch (e) {
      printError(info: e.toString());
      e.toString().errorSnackbar;
    }
  }

  reversePayment1Onchnage({bool? val}) {
    print(val);
    isReversePayment1.value = val!;
    if (val) {
      isReversePayment2.value = false;
    }
  }

  reversePayment2Onchnage({bool? val}) {
    print(val);
    isReversePayment2.value = val!;
    if (val) {
      isReversePayment1.value = false;
    }
  }
}
