import 'dart:async';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:csvapp/utils/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../dashboard.dart';
import '../../database/tables.dart';
import '../../theam/theam_constants.dart';
import '../../utils/constant.dart';
import '../../utils/dropDownItem.dart';

class PartyPayment extends StatelessWidget {
  static const routeName = '/partyPayment';
  // final HomepageController _homepageController = Get.put(HomepageController());
  final HomepageController _homepageController = Get.find<HomepageController>();

  PartyPayment({super.key});
  @override
  Widget build(BuildContext context) {
    // _homepageController.isAllPartySelected.value = false;
    TextTheme textTheme = Theme.of(context).textTheme;
    // final ScrollController horizontalScroll = ScrollController();
    // final ScrollController verticalScroll = ScrollController();
    // const double width = 20;
    // RxBool? isAllPartyChecked = true.obs;
    // Set smtInvNo = {};
    print(_homepageController.partyList);
    // _homepageController.getPartyList();
    return WillPopScope(
      onWillPop: () async {
        _homepageController.isSelectedReport.value = 0;
        // Get.offAndToNamed(PendingReport.routeName);
        return true;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(Get.height * 0.18),
            child: AppBar(
              // toolbarHeight: Get.height * 0.08,
              title: Text(
                'Party Payment',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: Get.height * 0.03,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  _homepageController.isSelectedReport.value = 0;
                  GetStorage('box').write('isSelectedReport', 0);
                  Get.offAndToNamed(Dashboard.routeName);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              centerTitle: true,
              bottom: bottomAppBar(homepageController: _homepageController),
            ),
          ),
          body: TabBarView(
            children: [
              PartyPaymentView(
                  homepageController: _homepageController, partyTypeID: 1),
              PartyPaymentView(
                  homepageController: _homepageController, partyTypeID: 2),
              PartyPaymentView(
                  homepageController: _homepageController, partyTypeID: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class LableText extends StatelessWidget {
  const LableText({
    super.key,
    required this.name,
    required this.amount,
  });
  final String name;
  final String amount;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        name,
        style: textTheme.bodyLarge?.copyWith(
          // color: Colors.white,
          fontSize: Get.height * 0.02,
        ),
      ),
      Text(
        amount,
        style: textTheme.titleLarge?.copyWith(
          // color: Colors.white,
          fontSize: Get.height * 0.015,
        ),
      ),
    ]);
  }
}

class PartyPaymentView extends StatelessWidget {
  PartyPaymentView({
    super.key,
    required this.homepageController,
    required this.partyTypeID,
  });
  HomepageController? homepageController;
  final int? partyTypeID;
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();
  final double width = 20;
  RxBool? isAllPartyChecked = true.obs;

  @override
  Widget build(BuildContext context) {
    // homepageController?.isAllPartySelected.value = false;

    List<PartyMasterData>? partyList = [];
    TextEditingController amountController = TextEditingController();
    TextEditingController extraNoteController = TextEditingController();
    TextEditingController pnameController = TextEditingController();
    // homepageController?.defualtParty.refresh();
    Timer(Duration.zero, () {
      if (partyTypeID == 1) {
        partyList = homepageController?.hpartyList;
      } else if (partyTypeID == 2) {
        partyList = homepageController?.dpartyList;
      } else if (partyTypeID == 3) {
        partyList = homepageController?.tpartyList;
      }
      if (partyList!.isNotEmpty) {
        homepageController?.defaultParty.value = partyList![0];

        homepageController?.defaultParty.refresh();
      }

      // for (var party in homepageController!.partyList!) {
      //   if (party.ptID == partyTypeID) {
      //     partyList.add(party);
      //   }
      // }
      // if (partyList.isNotEmpty) {
      //   // homepageController?.generatedReportData.value = [];

      //   homepageController?.defaultParty = partyList[0].obs;
      //   homepageController?.defaultParty.refresh();
      // }
      homepageController?.generatedReportData.clear();
    });
    // homepageController?.isAllPartySelected.value = false;
    TextTheme textTheme = Theme.of(context).textTheme;
    return AdaptiveScrollbar(
      controller: horizontalScroll,
      width: width,
      position: ScrollbarPosition.bottom,
      underSpacing: EdgeInsets.only(bottom: width),
      child: SingleChildScrollView(
        controller: horizontalScroll,
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => SizedBox(
            // width: Get.width * 1.5,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //**Search Ui Part
                  SizedBox(
                    width: Get.width * 1.5,
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    //** Select Party menu */
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const LableWithCheckbox(
                                          lable: 'Select Party:',
                                          isCheckBoxVisible: false,
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.20,
                                          child: PartyDropDownItems(
                                            defualtValue: homepageController
                                                ?.defaultParty,
                                            itemList: partyList,
                                          ),
                                        ),
                                      ],
                                    ),
                                    //** Select Material menu */
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LableWithCheckbox(
                                          lable: 'Select Material:',
                                          checkBoxOnchange: (value) =>
                                              homepageController
                                                  ?.isAllMaterialTypeSelected
                                                  .value = value!,
                                          checkBoxValue: homepageController
                                              ?.isAllMaterialTypeSelected.value,
                                          isCheckBoxVisible: true,
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.20,
                                          child: MaterialTypeDropDownItems(
                                            defualtValue: homepageController
                                                ?.defaultMaterialType,
                                            itemList: homepageController
                                                ?.materialTypeList,
                                          ),
                                        ),
                                      ],
                                    ),
                                    //** Select party-City menu */
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LableWithCheckbox(
                                          lable: 'Select City:',
                                          checkBoxOnchange: (value) =>
                                              homepageController
                                                  ?.isAllPartyCitySelected
                                                  .value = value!,
                                          checkBoxValue: homepageController
                                              ?.isAllPartyCitySelected.value,
                                          isCheckBoxVisible: true,
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.20,
                                          child: StringDropDownItems(
                                            defualtValue: homepageController
                                                ?.defaultPartyCity,
                                            itemList: homepageController
                                                ?.partyCityList
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //** Duration menu */
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () => homepageController
                                                ?.defaultDuration
                                                .value = 'One Month',
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                              child: AutoSizeText(
                                                'Duration:',
                                                style: textTheme.bodyLarge
                                                    ?.copyWith(
                                                  fontSize: Get.height * 0.015,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Visibility(
                                            visible: homepageController
                                                    ?.defaultDuration.value !=
                                                'Custom',
                                            replacement: SizedBox(
                                              child: Container(
                                                width: Get.width * 0.15,
                                                // color: Colors.amber,
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      // width: Get.width * 0.05,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Start:',
                                                            style: textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                              fontSize:
                                                                  Get.height *
                                                                      0.015,
                                                            ),
                                                          ),
                                                          Text(DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(
                                                                  homepageController!
                                                                      .dateRange
                                                                      .value
                                                                      .start)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.05,
                                                      child: CircleAvatar(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            homepageController
                                                                ?.chooseDateRangePicker();
                                                          },
                                                          icon: const Icon(
                                                              Icons.date_range),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      // width: Get.width * 0.05,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'End:',
                                                            style: textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                              fontSize:
                                                                  Get.height *
                                                                      0.015,
                                                            ),
                                                          ),
                                                          Text(DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(
                                                                  homepageController!
                                                                      .dateRange
                                                                      .value
                                                                      .end)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            child: SizedBox(
                                              width: Get.width * 0.15,
                                              child: StringDropDownItems(
                                                homecontroller:
                                                    homepageController,
                                                defualtValue: homepageController
                                                    ?.defaultDuration,
                                                itemList: homepageController
                                                    ?.durationList
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //**  isAll Pending
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width * 0.10,
                                margin: const EdgeInsets.only(left: 10),
                                child: LableWithCheckbox(
                                  lable: 'isAll Pending:',
                                  checkBoxOnchange: (value) =>
                                      homepageController
                                          ?.isAllPendingPayement.value = value!,
                                  checkBoxValue: homepageController
                                      ?.isAllPendingPayement.value,
                                  isCheckBoxVisible: true,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                children: [
                                  //** Search button
                                  Container(
                                    // margin: const EdgeInsets.only(top: 30),
                                    child: Button(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      height: Get.height * 0.045,
                                      width: Get.width * 0.08,
                                      fontSize: Get.width * 0.010,
                                      text: 'Search',
                                      onPressed: () async {
                                        homepageController?.dataNoSet.clear();
                                        print('Search Button Pressed');

                                        homepageController
                                            ?.getDurationDateRange(
                                                duration: homepageController
                                                    ?.defaultDuration.value);

                                        homepageController
                                            ?.checkLumpsumPaymentData
                                            .clear();
                                        amountController.clear();
                                        if (partyList!.isNotEmpty) {
                                          await homepageController
                                              ?.getGeneratedSearchData(
                                            start: homepageController
                                                ?.dateRange.value.start,
                                            end: homepageController
                                                ?.dateRange.value.end,
                                            selectedParty: homepageController
                                                ?.defaultParty.value,
                                            isAllPartySelected: false,
                                            isAllMaterialTypeSelected:
                                                homepageController
                                                    ?.isAllMaterialTypeSelected
                                                    .value,
                                            isAllPartyCitySelected:
                                                homepageController
                                                    ?.isAllPartyCitySelected
                                                    .value,
                                            selectedMaterialType:
                                                homepageController
                                                    ?.defaultMaterialType.value,
                                            selectedPartyCity:
                                                homepageController
                                                    ?.defaultPartyCity.value,
                                            isAllPendingPayement:
                                                homepageController
                                                    ?.isAllPendingPayement
                                                    .value,
                                          );
                                        } else {
                                          "No Party Found".errorSnackbar;
                                        }
                                      },
                                    ),
                                  ),
                                  //** pdf button
                                  Container(
                                    // margin: const EdgeInsets.only(top: 30),
                                    child: Button(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      height: Get.height * 0.045,
                                      width: Get.width * 0.05,
                                      fontSize: Get.width * 0.010,
                                      text: 'Pdf',
                                      onPressed: () async {
                                        if (homepageController!
                                                .generatedReportData.isEmpty ||
                                            homepageController!
                                                    .generatedReportData
                                                    .length <
                                                2) {
                                          'No Data Found'.errorSnackbar;
                                          return;
                                        }
                                        print('Create Pdf');
                                        print(homepageController
                                            ?.generatedReportData);

                                        await homepageController
                                            ?.createPartyPaymentReportPdf();
                                      },
                                    ),
                                  ),
                                  //** Extra Pay button
                                  Container(
                                    // margin: const EdgeInsets.all(0),
                                    child: Button(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      height: Get.height * 0.045,
                                      width: Get.width * 0.09,
                                      fontSize: Get.width * 0.010,
                                      text: 'Extra Pay',
                                      onPressed: () async {
                                        amountController.clear();
                                        pnameController.text =
                                            homepageController!
                                                .defaultParty.value.name;

                                        Get.defaultDialog(
                                          content: SizedBox(
                                            width: Get.width * 0.3,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Extra Payemnt',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: Get.height * 0.03,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: TextField(
                                                    controller: pnameController,
                                                    readOnly: true,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons.person),
                                                      hintText:
                                                          'Party Not Found',
                                                      hintStyle: textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                        color: Colors.grey,
                                                        fontSize:
                                                            Get.height * 0.02,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: TextField(
                                                    maxLength: 30,
                                                    controller:
                                                        amountController,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Icon(Icons
                                                          .currency_rupee_sharp),
                                                      hintText:
                                                          'Enter Extra Amount',
                                                      counterText: '',
                                                      hintStyle: textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                        color: Colors.grey,
                                                        fontSize:
                                                            Get.height * 0.02,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: TextField(
                                                    maxLength: 30,
                                                    controller:
                                                        extraNoteController,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Icon(
                                                          Icons.note_add),
                                                      hintText: 'Enter Note...',
                                                      counterText: '',
                                                      hintStyle: textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                        color: Colors.grey,
                                                        fontSize:
                                                            Get.height * 0.02,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Are you want to pay Party',
                                                  style: TextStyle(
                                                      fontSize:
                                                          Get.height * 0.02),
                                                ),
                                              ],
                                            ),
                                          ),
                                          textConfirm: 'Payment',
                                          confirmTextColor: Colors.white,
                                          onConfirm: () async {
                                            Get.back();
                                            if (amountController
                                                .text.isNumericOnly) {
                                              var amount = double.parse(
                                                  amountController.text);

                                              homepageController
                                                  ?.partyWiseExtraPayment(
                                                crAmount: amount,
                                                ledgerNote:
                                                    extraNoteController.text,
                                                selectedParty:
                                                    homepageController
                                                        ?.defaultParty.value,
                                              );
                                            } else {
                                              'Enter Valid Amount'
                                                  .errorSnackbar;
                                            }
                                          },
                                          textCancel: 'Cancel',
                                          cancelTextColor: lCOLOR_PRIMARY,
                                          onCancel: () {
                                            amountController.clear();
                                            Get.back();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  //**Data Ui Part

                  homepageController!.generatedReportData.isEmpty
                      ? Container()
                      : Card(
                          margin: const EdgeInsets.all(3),
                          color: lCOLOR_ACCENT,
                          child: SizedBox(
                            width: Get.width * 1.8,
                            height: Get.height * 0.05,
                            child: Row(
                              children: [
                                Flexible(
                                  child: ListView.builder(
                                      itemCount: homepageController
                                          ?.generatedReportData[0].length,
                                      scrollDirection: Axis.horizontal,
                                      // shrinkWrap: true,
                                      itemBuilder: (_, subIndex) {
                                        return (partyTypeID == 1
                                                ? (!homepageController!
                                                        .doctorComissionList
                                                        .contains(subIndex) &&
                                                    !homepageController!
                                                        .technicianComissionList
                                                        .contains(subIndex))
                                                : partyTypeID == 2
                                                    ? (!homepageController!
                                                            .hospitalComissionList
                                                            .contains(
                                                                subIndex) &&
                                                        !homepageController!
                                                            .technicianComissionList
                                                            .contains(subIndex))
                                                    : (!homepageController!
                                                            .hospitalComissionList
                                                            .contains(
                                                                subIndex) &&
                                                        !homepageController!
                                                            .doctorComissionList
                                                            .contains(
                                                                subIndex)))
                                            ? Container(
                                                // color: Colors.red,
                                                width: (subIndex == Constantdata.customerIndex ||
                                                        subIndex ==
                                                            Constantdata
                                                                .doctorNameIndex ||
                                                        subIndex ==
                                                            Constantdata
                                                                .technicianStaffIndex)
                                                    ? Get.width * 0.2
                                                    : (subIndex ==
                                                                Constantdata
                                                                    .matNameIndex ||
                                                            subIndex ==
                                                                Constantdata
                                                                    .matTypeIndex)
                                                        ? Get.width * 0.1
                                                        : Get.width * 0.06,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                // height: Get.height * 0.05,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    homepageController!
                                                        .generatedReportData[0]
                                                            [subIndex]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                    // minFontSize: 10,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            : Container();
                                      }),
                                ),
                                Obx(
                                  () => Visibility(
                                    // visible: !homepageController!
                                    //     .isAllPartySelected.value,
                                    visible: isAllPartyChecked!.value,
                                    child: SizedBox(
                                      width: Get.width * 0.033,
                                      // color: Colors.red,
                                      child: Checkbox(
                                        value: isAllPartyChecked?.value,
                                        onChanged: (value) {
                                          isAllPartyChecked?.value = value!;
                                          print(value);
                                          // homepageController?.isAllPartySelected.refresh();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  Stack(
                    children: [
                      AdaptiveScrollbar(
                        controller: verticalScroll,
                        width: width,
                        child: SizedBox(
                          // color: Colors.red,
                          height: Get.height * 0.70,
                          width: Get.width * 1.8,
                          child: Column(
                            children: [
                              SizedBox(
                                // color: Colors.yellow,
                                height: Get.height * 0.59,
                                width: Get.width * 1.8,
                                child: ListView.builder(
                                  itemCount: homepageController
                                      ?.generatedReportData.length,
                                  itemBuilder: (_, index) {
                                    var hospitalCommissionPaidDate = index != 0
                                        ? homepageController
                                                ?.generatedReportData[index]
                                            [Constantdata.hcAmountPaidDateIndex]
                                        : null;
                                    var doctorCommissionPaidDate = index != 0
                                        ? homepageController
                                                ?.generatedReportData[index]
                                            [Constantdata.dcAmountPaidDateIndex]
                                        : null;
                                    var technicianCommissionPaidDate = index !=
                                            0
                                        ? homepageController
                                                ?.generatedReportData[index]
                                            [Constantdata.tcAmountPaidDateIndex]
                                        : null;
                                    var date = index != 0
                                        ? partyTypeID == 1
                                            ? hospitalCommissionPaidDate
                                            : partyTypeID == 2
                                                ? doctorCommissionPaidDate
                                                : technicianCommissionPaidDate
                                        : DateTime.now();
                                    RxBool? isPartyChecked = true.obs;
                                    if (homepageController!
                                            .isAllPendingPayement.value &&
                                        homepageController!
                                            .checkLumpsumPaymentData
                                            .isNotEmpty) {
                                      print(homepageController!
                                          .checkLumpsumPaymentData);
                                      homepageController?.dataNoSet.clear();
                                      homepageController?.dataNoSet.addAll(
                                          homepageController!
                                              .checkLumpsumPaymentData);
                                    } else {
                                      index != 0
                                          ? homepageController?.dataNoSet.add(
                                              homepageController!
                                                          .generatedReportData[
                                                      index]
                                                  [Constantdata.dataNoIndex])
                                          : null;
                                    }
                                    // var isPartyChecked = true;
                                    return Visibility(
                                      visible: index != 0,
                                      replacement: Container(),
                                      child: Card(
                                        margin: const EdgeInsets.all(3),
                                        color: homepageController!
                                                .checkLumpsumPaymentData
                                                .contains(homepageController
                                                        ?.generatedReportData[index]
                                                    [Constantdata.dataNoIndex])
                                            ? Colors.amber[100]
                                            : homepageController!.displayData
                                                    .contains(homepageController
                                                            ?.generatedReportData[index]
                                                        [Constantdata
                                                            .dataNoIndex])
                                                ? date.isAfter(DateTime(1800, 01, 01))
                                                    ? const Color.fromARGB(255, 121, 192, 124)
                                                    : Colors.white
                                                : const Color.fromARGB(255, 228, 136, 129),
                                        child: SizedBox(
                                          width: Get.width * 2,
                                          height: Get.height * 0.04,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: homepageController!
                                                          .generatedReportData[
                                                              index]
                                                          .isNotEmpty
                                                      ? homepageController!
                                                              .generatedReportData[
                                                                  index]
                                                              .length -
                                                          3
                                                      : 0,
                                                  itemBuilder: (_, subIndex) {
                                                    return (partyTypeID == 1
                                                            ? (!homepageController!
                                                                    .doctorComissionList
                                                                    .contains(
                                                                        subIndex) &&
                                                                !homepageController!
                                                                    .technicianComissionList
                                                                    .contains(
                                                                        subIndex))
                                                            : partyTypeID == 2
                                                                ? (!homepageController!
                                                                        .hospitalComissionList
                                                                        .contains(
                                                                            subIndex) &&
                                                                    !homepageController!
                                                                        .technicianComissionList
                                                                        .contains(
                                                                            subIndex))
                                                                : (!homepageController!
                                                                        .hospitalComissionList
                                                                        .contains(
                                                                            subIndex) &&
                                                                    !homepageController!
                                                                        .doctorComissionList
                                                                        .contains(
                                                                            subIndex)))
                                                        ? Container(
                                                            width: (subIndex == Constantdata.customerIndex ||
                                                                    subIndex ==
                                                                        Constantdata
                                                                            .doctorNameIndex ||
                                                                    subIndex ==
                                                                        Constantdata
                                                                            .technicianStaffIndex)
                                                                ? Get.width *
                                                                    0.2
                                                                : (subIndex ==
                                                                            Constantdata
                                                                                .matNameIndex ||
                                                                        subIndex ==
                                                                            Constantdata
                                                                                .matTypeIndex)
                                                                    ? Get.width *
                                                                        0.1
                                                                    : Get.width *
                                                                        0.06,
                                                            // height: Get.height * 0.05,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Visibility(
                                                              visible: (subIndex == Constantdata.customerIndex ||
                                                                      subIndex ==
                                                                          Constantdata
                                                                              .doctorNameIndex ||
                                                                      subIndex ==
                                                                          Constantdata
                                                                              .technicianStaffIndex) &&
                                                                  homepageController
                                                                          ?.partyNaNSetData
                                                                          .contains(homepageController?.generatedReportData[index]
                                                                              [
                                                                              Constantdata.dataNoIndex]) ==
                                                                      true,
                                                              replacement:
                                                                  Visibility(
                                                                visible: subIndex ==
                                                                        Constantdata
                                                                            .matTypeIndex &&
                                                                    homepageController
                                                                            ?.comissionAndmatTypeNaNSetData
                                                                            .contains(homepageController?.generatedReportData[index][Constantdata.dataNoIndex]) ==
                                                                        true,
                                                                replacement:
                                                                    AutoSizeText(
                                                                  (subIndex == Constantdata.smtDocDateIndex ||
                                                                          subIndex ==
                                                                              Constantdata
                                                                                  .distDocDateIndex)
                                                                      ? DateFormat(
                                                                              "dd-MM-yyyy")
                                                                          .format(DateFormat("dd.MM.yyyy").parse(homepageController!.generatedReportData[index][subIndex]
                                                                              .toString()))
                                                                          .toString()
                                                                      : homepageController!
                                                                          .generatedReportData[
                                                                              index]
                                                                              [
                                                                              subIndex]
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                  textAlign: homepageController!
                                                                          .rightalign
                                                                          .contains(
                                                                              subIndex)
                                                                      ? TextAlign
                                                                          .right
                                                                      : homepageController!.centeralign.contains(
                                                                              subIndex)
                                                                          ? TextAlign
                                                                              .center
                                                                          : TextAlign
                                                                              .left,
                                                                  minFontSize:
                                                                      10,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: Get
                                                                              .width *
                                                                          0.06,
                                                                      child:
                                                                          AutoSizeText(
                                                                        homepageController!
                                                                            .generatedReportData[index][subIndex]
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black),
                                                                        minFontSize:
                                                                            10,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        Get.width *
                                                                            0.15,
                                                                    child:
                                                                        AutoSizeText(
                                                                      homepageController!
                                                                          .generatedReportData[
                                                                              index]
                                                                              [
                                                                              subIndex]
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                      minFontSize:
                                                                          10,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : Container();
                                                  },
                                                ),
                                              ),
                                              Obx(
                                                () => Visibility(
                                                  visible:
                                                      !isAllPartyChecked!.value,
                                                  child: SizedBox(
                                                    width: Get.width * 0.025,
                                                    // color: Colors.red,
                                                    child: Visibility(
                                                      visible: date.isAfter(
                                                          DateTime(
                                                              1800, 01, 01)),
                                                      replacement: Checkbox(
                                                        value: isPartyChecked
                                                            .value,
                                                        onChanged: (value) {
                                                          isPartyChecked.value =
                                                              value!;
                                                          print(value);
                                                          if (value) {
                                                            homepageController
                                                                ?.dataNoSet
                                                                .add(homepageController!
                                                                            .generatedReportData[
                                                                        index][
                                                                    Constantdata
                                                                        .dataNoIndex]);
                                                            homepageController
                                                                    ?.partyWiseTotalAmount
                                                                    .value +=
                                                                double.parse(homepageController!
                                                                    .generatedReportData[
                                                                        index]
                                                                        [19]
                                                                    .toString());
                                                            homepageController
                                                                ?.partyWisePayableAmount
                                                                .value = homepageController!
                                                                    .partyWiseTotalAmount
                                                                    .value -
                                                                homepageController!
                                                                    .partyWisePaidAmount
                                                                    .value;
                                                          } else {
                                                            homepageController
                                                                ?.dataNoSet
                                                                .remove(homepageController
                                                                    ?.generatedReportData[
                                                                        index][
                                                                        Constantdata
                                                                            .dataNoIndex]
                                                                    .toString());
                                                            homepageController
                                                                    ?.partyWiseTotalAmount
                                                                    .value -=
                                                                double.parse(homepageController!
                                                                    .generatedReportData[
                                                                        index]
                                                                        [19]
                                                                    .toString());
                                                            homepageController
                                                                ?.partyWisePayableAmount
                                                                .value = homepageController!
                                                                    .partyWiseTotalAmount
                                                                    .value -
                                                                homepageController!
                                                                    .partyWisePaidAmount
                                                                    .value;
                                                          }
                                                          print(homepageController
                                                              ?.partyWiseTotalAmount
                                                              .value);

                                                          print(
                                                              homepageController
                                                                  ?.dataNoSet);
                                                          // homepageController?.isAllPartySelected.refresh();
                                                        },
                                                      ),
                                                      child: IconButton(
                                                        onPressed: () {
                                                          print('payment Back');
                                                          print(homepageController
                                                              ?.generatedReportData[
                                                                  index][
                                                                  Constantdata
                                                                      .smtInvoiceNoIndex]
                                                              .toString());
                                                          var smtInvNo =
                                                              homepageController
                                                                  ?.generatedReportData[
                                                                      index][
                                                                      Constantdata
                                                                          .smtInvoiceNoIndex]
                                                                  .toString();
                                                          Get.defaultDialog(
                                                            title:
                                                                'Payment Back',
                                                            middleText:
                                                                'Are you sure you want to back payment?',
                                                            textConfirm: 'Yes',
                                                            textCancel: 'No',
                                                            confirmTextColor:
                                                                Colors.white,
                                                            content: Container(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Payment Back',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          Get.height *
                                                                              0.02,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    'Are you want to Process $smtInvNo smtInvNo?',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            Get.height *
                                                                                0.02),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onConfirm: () {
                                                              Get.back();
                                                              // !Todo: Payment Back
                                                              homepageController!.reversePaymentProcess(
                                                                  pID:
                                                                      partyTypeID,
                                                                  paymentbackRecord:
                                                                      homepageController!
                                                                              .generatedReportData[
                                                                          index]);
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(Icons
                                                            .arrow_back_ios),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible:
                              homepageController!.generatedReportData.length > 1
                                  ? true
                                  : false,
                          child: Positioned(
                            // width: Get.width,
                            bottom: Get.height * 0.05,
                            left: Get.width * 0.05,
                            right: Get.width * 0.9,
                            child: SizedBox(
                              height: Get.height * 0.1,
                              // width: Get.width * 0.7,
                              child: Card(
                                color: lCOLOR_ACCENT.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Visibility(
                                      visible: homepageController!
                                          .isAllPendingPayement.value,
                                      child: Container(
                                        width: Get.width * 0.2,
                                        height: Get.height * 0.1,
                                        margin: EdgeInsets.only(
                                            top: Get.height * 0.018),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.01),
                                        child: TextField(
                                          maxLength: 10,
                                          controller: amountController,
                                          decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                                Icons.currency_rupee_sharp),
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons.search),
                                              onPressed: () {
                                                print(amountController.text);
                                                homepageController!
                                                    .checkLumpsumPaymen(
                                                  ptID: partyTypeID,
                                                  generatedReportData:
                                                      homepageController
                                                          ?.generatedReportData,
                                                  lumpsumAmount: double.parse(
                                                      amountController.text),
                                                  selectedParty:
                                                      homepageController
                                                          ?.defaultParty.value,
                                                );
                                              },
                                            ),
                                            hintText: 'Enter Payment Amount',
                                            counterText: '',
                                            hintStyle:
                                                textTheme.titleLarge?.copyWith(
                                              color: Colors.grey[700],
                                              fontSize: Get.height * 0.02,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    LableText(
                                        name: 'Total Amount',
                                        amount: homepageController!
                                            .partyWiseTotalAmount.value
                                            .toStringAsFixed(2)),
                                    LableText(
                                        name: 'Paid Amount',
                                        amount: homepageController!
                                            .partyWisePaidAmount.value
                                            .toStringAsFixed(2)),
                                    LableText(
                                        name: 'Pending Paid Amount',
                                        amount: homepageController!
                                            .partyWisePendingPaidAmount.value
                                            .toStringAsFixed(2)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        LableText(
                                            name: 'Payable Amount',
                                            amount: homepageController!
                                                .partyWisePayableAmount
                                                .toStringAsFixed(2)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Button(
                                          text: 'Pay',
                                          onPressed: () {
                                            print('payment');
                                            if (homepageController!
                                                    .partyWisePayableAmount >
                                                0) {
                                              Get.defaultDialog(
                                                content: SizedBox(
                                                  width: Get.width * 0.3,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Total Amount : ${(homepageController!.partyWisePayableAmount.value + homepageController!.partyWisePendingPaidAmount.value).toString()}₹ ',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              Get.height * 0.03,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                        child: TextField(
                                                          maxLength: 30,
                                                          controller:
                                                              extraNoteController,
                                                          decoration:
                                                              InputDecoration(
                                                            prefixIcon:
                                                                const Icon(Icons
                                                                    .note_add),
                                                            hintText:
                                                                'Enter Note...',
                                                            counterText: '',
                                                            hintStyle: textTheme
                                                                .titleLarge
                                                                ?.copyWith(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  Get.height *
                                                                      0.02,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        'Are you want to pay Party',
                                                        style: TextStyle(
                                                            fontSize:
                                                                Get.height *
                                                                    0.02),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                textConfirm: 'Payment',
                                                confirmTextColor: Colors.white,
                                                onConfirm: () async {
                                                  Get.back();
                                                  if (amountController
                                                      .text.isNumericOnly) {
                                                    var amount = double.parse(
                                                        amountController.text);

                                                    homepageController
                                                        ?.partyWiseExtraPayment(
                                                      crAmount: amount,
                                                      ledgerNote:
                                                          extraNoteController
                                                              .text,
                                                      selectedParty:
                                                          homepageController
                                                              ?.defaultParty
                                                              .value,
                                                    );
                                                  } else {
                                                    'Enter Valid Amount'
                                                        .errorSnackbar;
                                                  }
                                                },
                                                textCancel: 'Cancel',
                                                cancelTextColor: lCOLOR_PRIMARY,
                                                onCancel: () {
                                                  amountController.clear();
                                                  Get.back();
                                                },
                                              );
                                              // Get.defaultDialog(
                                              //   title: 'payment',
                                              //   middleText:
                                              //       'Are you sure you want to pay  ${(homepageController!.partyWisePayableAmount).toString()}₹ ?',
                                              //   textConfirm: 'Ok',
                                              //   confirmTextColor: Colors.white,
                                              //   onConfirm: () {
                                              //     print('payment');
                                              //     Get.back();
                                              //     var crAmount =
                                              //         homepageController!
                                              //             .partyWisePayableAmount
                                              //             .value;
                                              //     print(homepageController!
                                              //         .defaultParty.value);
                                              //     // !todo: payment

                                              //     homepageController!
                                              //         .partyWisePayment(
                                              //             isAllPendingPayement:
                                              //                 homepageController
                                              //                     ?.isAllPendingPayement
                                              //                     .value,
                                              //             crAmount: crAmount,
                                              //             selectedParty:
                                              //                 homepageController!
                                              //                     .defaultParty
                                              //                     .value,
                                              //             ptID: partyTypeID);
                                              //   },
                                              // );
                                            } else {
                                              'No amount to pay😀'.infoSnackbar;
                                            }
                                          },
                                          fontSize: Get.height * 0.02,
                                          height: Get.height * 0.04,
                                          width: Get.width * 0.06,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
