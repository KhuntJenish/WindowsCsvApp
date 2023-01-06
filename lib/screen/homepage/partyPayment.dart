import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/generatedReport.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:csvapp/utils/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../utils/dropDownItem.dart';
import '../../utils/partyComissionBottomsheet.dart';
import '../../utils/partyMasterBottomsheet.dart';
import 'partyLedger.dart';
import 'ImportReport.dart';

class PartyPayment extends StatelessWidget {
  static const routeName = '/partyPayment';
  HomepageController _homepageController = Get.put(HomepageController());
  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    final ScrollController horizontalScroll = ScrollController();
    final ScrollController verticalScroll = ScrollController();
    final double width = 20;

    return WillPopScope(
      onWillPop: () async {
        _homepageController.isSelectedReport.value = 0;
        // Get.offAndToNamed(PendingReport.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Party Payment',
            style: _textTheme.bodyText1?.copyWith(
              color: Colors.white,
              fontSize: Get.height * 0.03,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(Get.width * 0.03),
            child: Container(
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ReportLabel(
                    index: 1,
                    text: 'Import Report',
                    icon: Icon(Icons.insert_chart),
                    onTap: () {
                      _homepageController.isSelectedReport.value = 1;
                      Get.offAndToNamed(ImportReport.routeName);
                    },
                  ),
                  ReportLabel(
                    index: 2,
                    text: 'Generated Report',
                    icon: Icon(Icons.auto_graph),
                    onTap: () {
                      _homepageController.generatedReportData.clear();
                      _homepageController.isSelectedReport.value = 2;
                      Get.offAndToNamed(GeneratedReport.routeName);
                    },
                  ),
                  ReportLabel(
                    index: 3,
                    text: 'Party Payment',
                    icon: Icon(Icons.payment),
                    onTap: () {
                      _homepageController.generatedReportData.clear();
                      _homepageController.isSelectedReport.value = 3;
                      Get.offAndToNamed(PartyPayment.routeName);
                    },
                  ),
                  ReportLabel(
                    index: 4,
                    text: 'Party Ledger',
                    icon: Icon(Icons.receipt_long),
                    onTap: () {
                      _homepageController.isSelectedReport.value = 4;
                      Get.offAndToNamed(PartyLedger.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: AdaptiveScrollbar(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //**Search Ui Part
                    Container(
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.red,
                            // width: Get.width * 0.30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: AutoSizeText(
                                    'Select Party:',
                                    style: _textTheme.bodyText1?.copyWith(
                                      fontSize: Get.height * 0.015,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.20,
                                  child: PartyDropDownItems(
                                    defualtValue:
                                        _homepageController.defualtParty,
                                    itemList: _homepageController.partyList,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.green,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: AutoSizeText(
                                    'Select Material:',
                                    style: _textTheme.bodyText1?.copyWith(
                                      fontSize: Get.height * 0.015,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.20,
                                  child: MaterialTypeDropDownItems(
                                    defualtValue:
                                        _homepageController.defualtMaterialType,
                                    itemList:
                                        _homepageController.materialTypeList,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.green,
                            // width: Get.width * 0.30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: AutoSizeText(
                                    'Select City:',
                                    style: _textTheme.bodyText1?.copyWith(
                                      fontSize: Get.height * 0.015,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.20,
                                  child: StringDropDownItems(
                                    defualtValue:
                                        _homepageController.defualtPartyCity,
                                    itemList: _homepageController.partyCityList
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.20,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.05,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Start:',
                                          style: _textTheme.bodyText1?.copyWith(
                                            fontSize: Get.height * 0.015,
                                          ),
                                        ),
                                        Text(DateFormat('dd-MM-yyyy').format(
                                            _homepageController
                                                .dateRange.value.start)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.05,
                                    child: CircleAvatar(
                                      child: IconButton(
                                        onPressed: () {
                                          _homepageController
                                              .chooseDateRangePicker();
                                        },
                                        icon: const Icon(Icons.date_range),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.05,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'End:',
                                          style: _textTheme.bodyText1?.copyWith(
                                            fontSize: Get.height * 0.015,
                                          ),
                                        ),
                                        Text(DateFormat('dd-MM-yyyy').format(
                                            _homepageController
                                                .dateRange.value.end)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Button(
                            height: Get.height * 0.04,
                            width: Get.width * 0.08,
                            fontSize: Get.width * 0.010,
                            text: 'Search',
                            onPressed: () async {
                              print('Search Button Pressed');
                              print(
                                  _homepageController.isAllPartySelected.value);
                              print(_homepageController.defualtParty);
                              print(_homepageController.dateRange.value.start);
                              print(_homepageController.dateRange.value.end);
                              await _homepageController.getGeneratedSearchData(
                                  start:
                                      _homepageController.dateRange.value.start,
                                  end: _homepageController.dateRange.value.end,
                                  selectedParty:
                                      _homepageController.defualtParty.value,
                                  isAllPartySelected: _homepageController
                                      .isAllPartySelected.value);
                              // Get.offAllNamed(Homepage.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                    _homepageController.generatedReportData.isEmpty
                        ? Container()
                        : Card(
                            margin: const EdgeInsets.all(3),
                            color: Colors.amber,
                            child: SizedBox(
                              width: Get.width * 1.5,
                              height: Get.height * 0.05,
                              child: ListView.builder(
                                  itemCount: _homepageController
                                      .generatedReportData[0].length,
                                  scrollDirection: Axis.horizontal,
                                  // shrinkWrap: true,
                                  itemBuilder: (_, subIndex) {
                                    return Container(
                                      width: subIndex == 3
                                          ? Get.width * 0.2
                                          : (subIndex == 6 ||
                                                  subIndex == 7 ||
                                                  subIndex == 9)
                                              ? Get.width * 0.1
                                              : Get.width * 0.06,
                                      // height: Get.height * 0.05,
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(
                                        _homepageController
                                            .generatedReportData[0][subIndex]
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                        minFontSize: 10,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }),
                            ),
                          ),
                    Stack(
                      children: [
                        AdaptiveScrollbar(
                          controller: verticalScroll,
                          width: width,
                          child: Container(
                            height: Get.height * 0.70,
                            width: Get.width * 1.5,
                            child: ListView.builder(
                              // itemCount: _homepageController.data.isEmpty ? 0 : 3,
                              itemCount: _homepageController
                                  .generatedReportData.length,
                              // scrollDirection: Axis.vertical,
                              // shrinkWrap: true,
                              itemBuilder: (_, index) {
                                print(index != 0
                                    ? _homepageController
                                        .generatedReportData[index][20]
                                    : 0);
                                var date = index != 0
                                    ? _homepageController
                                        .generatedReportData[index][20]
                                    : DateTime.now();

                                print(date.isAfter(DateTime(1800, 01, 01)));
                                return Visibility(
                                  visible: index != 0,
                                  replacement: Container(),
                                  child: Card(
                                    margin: const EdgeInsets.all(3),
                                    color: _homepageController.displayData
                                            .contains(_homepageController
                                                .generatedReportData[index][15])
                                        ? date.isAfter(DateTime(1800, 01, 01))
                                            ? Color.fromARGB(255, 121, 192, 124)
                                            : Colors.white
                                        : Color.fromARGB(255, 228, 136, 129),
                                    child: Container(
                                      width: Get.width * 1.5,
                                      height: Get.height * 0.04,
                                      child: AnimationLimiter(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,

                                          itemCount: _homepageController
                                                  .generatedReportData[index]
                                                  .isNotEmpty
                                              ? _homepageController
                                                      .generatedReportData[
                                                          index]
                                                      .length -
                                                  1
                                              : 0,
                                          // shrinkWrap: true,
                                          itemBuilder: (_, subIndex) {
                                            // DateTime tempDate = DateFormat("dd.MM.yyyy")
                                            //     .parse(_homepageController.data[index][1]
                                            //         .toString());

                                            // tempDate = DateFormat("dd-MM-yyyy").format(tempDate);
                                            // print(_homepageController.data[index][15]
                                            //     .toString());
                                            return AnimationConfiguration
                                                .staggeredList(
                                              position: index,
                                              duration: const Duration(
                                                  milliseconds: 375),
                                              child: SlideAnimation(
                                                verticalOffset: 50.0,
                                                child: FadeInAnimation(
                                                  child: Container(
                                                    width: subIndex == 3
                                                        ? Get.width * 0.2
                                                        : (subIndex == 6 ||
                                                                subIndex == 7 ||
                                                                subIndex == 9)
                                                            ? Get.width * 0.1
                                                            : Get.width * 0.06,
                                                    // height: Get.height * 0.05,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Visibility(
                                                      visible: subIndex == 3 &&
                                                          _homepageController
                                                                  .partyNaNSetData
                                                                  .contains(_homepageController
                                                                          .generatedReportData[
                                                                      index][15]) ==
                                                              true,
                                                      replacement: Visibility(
                                                        visible: subIndex ==
                                                                7 &&
                                                            _homepageController
                                                                    .comissionAndmatTypeNaNSetData
                                                                    .contains(_homepageController
                                                                            .generatedReportData[index]
                                                                        [15]) ==
                                                                true,
                                                        replacement:
                                                            AutoSizeText(
                                                          (index != 0 &&
                                                                  (subIndex ==
                                                                          1 ||
                                                                      subIndex ==
                                                                          13))
                                                              ? DateFormat(
                                                                      "dd-MM-yyyy")
                                                                  .format(DateFormat("dd.MM.yyyy").parse(_homepageController
                                                                      .generatedReportData[
                                                                          index]
                                                                          [
                                                                          subIndex]
                                                                      .toString()))
                                                                  .toString()
                                                              : _homepageController
                                                                  .generatedReportData[
                                                                      index]
                                                                      [subIndex]
                                                                  .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                          minFontSize: 10,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: Get.width *
                                                                  0.06,
                                                              child:
                                                                  AutoSizeText(
                                                                _homepageController
                                                                    .generatedReportData[
                                                                        index][
                                                                        subIndex]
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                                minFontSize: 10,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: Get.width *
                                                                  0.03,
                                                              height:
                                                                  Get.height *
                                                                      0.03,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  print(
                                                                      'new material Type');
                                                                  String
                                                                      btnText =
                                                                      'Add New Comission';
                                                                  print(_homepageController
                                                                          .generatedReportData[
                                                                      index][3]);
                                                                  var party = await (_homepageController
                                                                          .db
                                                                          .select(_homepageController
                                                                              .db
                                                                              .partyMaster)
                                                                        ..where((tbl) => tbl
                                                                            .name
                                                                            .equals(_homepageController.generatedReportData[index][3])))
                                                                      .get();

                                                                  print(party);

                                                                  Get.bottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    ignoreSafeArea:
                                                                        false,
                                                                    PartyComissionBottomSheet(
                                                                      comissionPercentage:
                                                                          '',
                                                                      party:
                                                                          party[
                                                                              0],
                                                                      btnText:
                                                                          btnText,
                                                                      isShow:
                                                                          true,
                                                                      materialType:
                                                                          TextEditingController(
                                                                              text: _homepageController.generatedReportData[index][7]),
                                                                      // partyTypeIDList: partyTypeIDList,
                                                                      // id: snapshot.data?[index].id,
                                                                      // newComission: name,
                                                                    ),
                                                                  );
                                                                },
                                                                child: const AutoSizeText(
                                                                    "Add",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                    minFontSize:
                                                                        10,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: Get.width *
                                                                0.15,
                                                            child: AutoSizeText(
                                                              _homepageController
                                                                  .generatedReportData[
                                                                      index]
                                                                      [subIndex]
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                              minFontSize: 10,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: Get.width *
                                                                0.03,
                                                            height: Get.height *
                                                                0.03,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                print(
                                                                    'new customer add');
                                                                TextEditingController name = TextEditingController(
                                                                    text: _homepageController
                                                                        .generatedReportData[
                                                                            index]
                                                                            [
                                                                            subIndex]
                                                                        .toString());
                                                                print(
                                                                    name.text);
                                                                String btnText =
                                                                    'Add New Party';

                                                                Get.bottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  ignoreSafeArea:
                                                                      false,
                                                                  PartyTypeBottomsheet(
                                                                    name: name,
                                                                    btnText:
                                                                        btnText,
                                                                  ),
                                                                );
                                                              },
                                                              child: const AutoSizeText(
                                                                  "Add",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                  minFontSize:
                                                                      10,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible:
                                _homepageController.isAllPartySelected.value ==
                                            false &&
                                        _homepageController
                                                .generatedReportData.length >
                                            1
                                    ? true
                                    : false,
                            child: Positioned(
                              // width: Get.width,
                              bottom: Get.height * 0.03,
                              left: Get.width * 0.20,
                              right: Get.width * 0.70,
                              child: Container(
                                height: Get.height * 0.1,
                                width: Get.width * 0.5,
                                child: Card(
                                  // color: lCOLOR_ACCENT.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      LableText(
                                          name: 'Total Amount',
                                          amount: _homepageController
                                              .partyWiseTotalAmount.value
                                              .toString()),
                                      LableText(
                                          name: 'Paid Amount',
                                          amount: _homepageController
                                              .partyWisePaidAmount.value
                                              .toString()),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          LableText(
                                              name: 'Payable Amount',
                                              amount: (_homepageController
                                                          .partyWiseTotalAmount
                                                          .value -
                                                      _homepageController
                                                          .partyWisePaidAmount
                                                          .value)
                                                  .toString()),
                                          Button(
                                            text: 'Pay',
                                            onPressed: () {
                                              print('payment');
                                              if ((_homepageController
                                                          .partyWiseTotalAmount
                                                          .value -
                                                      _homepageController
                                                          .partyWisePaidAmount
                                                          .value) >
                                                  0) {
                                                Get.defaultDialog(
                                                  title: 'payment',
                                                  middleText:
                                                      'Are you sure you want to pay  ${(_homepageController.partyWiseTotalAmount.value - _homepageController.partyWisePaidAmount.value).toString()}₹ ?',
                                                  textConfirm: 'Ok',
                                                  confirmTextColor:
                                                      Colors.white,
                                                  onConfirm: () {
                                                    print('payment');
                                                    Get.back();
                                                    var crAmount = (_homepageController
                                                            .partyWiseTotalAmount
                                                            .value -
                                                        _homepageController
                                                            .partyWisePaidAmount
                                                            .value);
                                                    print(_homepageController
                                                        .defualtParty.value);
                                                    _homepageController
                                                        .partyWisePayment(
                                                            crAmount: crAmount,
                                                            selectedParty:
                                                                _homepageController
                                                                    .defualtParty
                                                                    .value);
                                                  },
                                                );
                                              } else {
                                                'No amount to pay😀'
                                                    .infoSnackbar;
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

        // drawer: drawer(),
      ),
    );
  }
}

class LableText extends StatelessWidget {
  LableText({
    Key? key,
    required this.name,
    required this.amount,
  });
  String name;
  String amount;
  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        name,
        style: _textTheme.bodyText1?.copyWith(
          // color: Colors.white,
          fontSize: Get.height * 0.02,
        ),
      ),
      Text(
        amount,
        style: _textTheme.headline6?.copyWith(
          // color: Colors.white,
          fontSize: Get.height * 0.015,
        ),
      ),
    ]);
  }
}
