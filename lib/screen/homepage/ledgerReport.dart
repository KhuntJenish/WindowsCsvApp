import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../../database/tables.dart';
import '../../theam/theam_constants.dart';
import '../../utils/dropDownItem.dart';
import '../../utils/helper_widget.dart';
import '../../utils/partyComissionBottomsheet.dart';
import '../../utils/partyMasterBottomsheet.dart';

class LedgerReport extends StatelessWidget {
  static const routeName = '/ledgerReport';
  HomepageController _homepageController = Get.put(HomepageController());
  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    final ScrollController horizontalScroll = ScrollController();
    final ScrollController verticalScroll = ScrollController();
    final double width = 20;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ledger Report',
          style: _textTheme.bodyText1?.copyWith(
            color: Colors.white,
            fontSize: Get.height * 0.03,
          ),
        ),
        centerTitle: true,
      ),
      body: AdaptiveScrollbar(
        controller: verticalScroll,
        width: width,
        child: AdaptiveScrollbar(
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
                    //**Search UI Part
                    Container(
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Get.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 8),
                                      child: AutoSizeText(
                                        'Select All Party:',
                                        style: _textTheme.bodyText1?.copyWith(
                                          fontSize: Get.height * 0.015,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    // SizedBox(width: 5), //SizedBox

                                    /** Checkbox Widget **/

                                    Checkbox(
                                      value: _homepageController
                                          .isAllPartySelected.value,
                                      onChanged: (value) => _homepageController
                                          .isAllPartySelected.value = value!,
                                    ),
                                  ],
                                ),
                                PartyDropDownItems(
                                  width: Get.width * 0.28,
                                  defualtValue:
                                      _homepageController.defualtParty,
                                  itemList: _homepageController.partyList,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            // width: Get.width * 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.07,
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
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            _homepageController
                                                .dateRange.value.start),
                                        style: _textTheme.bodyText1?.copyWith(
                                          fontSize: Get.height * 0.020,
                                        ),
                                      ),
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
                                  width: Get.width * 0.07,
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
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            _homepageController
                                                .dateRange.value.end),
                                        style: _textTheme.bodyText1?.copyWith(
                                          fontSize: Get.height * 0.020,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                              if (_homepageController.defualtParty.value.id ==
                                  0) {
                                '😀Please Select Party'.errorSnackbar;
                              } else {
                                await _homepageController.getLedgerSearchData(
                                    start: _homepageController
                                        .dateRange.value.start,
                                    end:
                                        _homepageController.dateRange.value.end,
                                    selectedParty:
                                        _homepageController.defualtParty.value,
                                    isAllPartySelected: _homepageController
                                        .isAllPartySelected.value);
                              }
                              // Get.offAllNamed(Homepage.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                    //**Data UI Part

                    Obx(
                      () => Column(
                        children: [
                          Visibility(
                            visible:
                                _homepageController.ledgerReportData.isNotEmpty,
                            child: Container(
                              height: Get.height * 0.04,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: Get.width * 0.1,
                                    child: Text(
                                      'Date',
                                      style: _textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Get.height * 0.018,
                                          color: Colors.red),
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.2,
                                    child: Text(
                                      'Type',
                                      style: _textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Get.height * 0.018,
                                          color: Colors.red),
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.1,
                                    child: Text(
                                      'Debit',
                                      style: _textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Get.height * 0.018,
                                          color: Colors.red),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: Get.width * 0.1,
                                    child: Text(
                                      'Credit',
                                      style: _textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Get.height * 0.018,
                                          color: Colors.red),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: Get.height * 0.8,
                            width: Get.width,
                            // color: Colors.amber[50],
                            child: GroupedListView<LedgerData, String>(
                              elements:
                                  _homepageController.ledgerReportData.value,
                              groupBy: (element) => element.pID.toString(),
                              groupSeparatorBuilder: (String groupByValue) =>
                                  Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20),
                                child: Card(
                                  color: Colors.grey[400],
                                  child: AutoSizeText(
                                    _homepageController.partyList!
                                        .firstWhere((item) =>
                                            item.id == int.parse(groupByValue))
                                        .name,
                                    style: _textTheme.bodyText1?.copyWith(
                                      fontSize: Get.height * 0.020,
                                    ),
                                    minFontSize: 10,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),

                              itemBuilder: (context, LedgerData element) {
                                return Container(
                                  height: Get.height * 0.04,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: Get.width * 0.1,
                                        child: Text(
                                          DateFormat('dd-MM-yyyy')
                                              .format(element.ledgerDate)
                                              .toString(),
                                          style: _textTheme.bodyText1?.copyWith(
                                            fontSize: Get.height * 0.015,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: Get.width * 0.2,
                                        child: Text(
                                          element.type,
                                          style: _textTheme.bodyText1?.copyWith(
                                            fontSize: Get.height * 0.015,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: Get.width * 0.1,
                                        child: Text(
                                          element.drAmount != 0
                                              ? element.drAmount
                                                  .toStringAsFixed(2)
                                              : '',
                                          style: _textTheme.bodyText1?.copyWith(
                                            fontSize: Get.height * 0.015,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      Container(
                                        width: Get.width * 0.1,
                                        child: Text(
                                          element.crAmount != 0
                                              ? element.crAmount
                                                  .toStringAsFixed(2)
                                              : '',
                                          style: _textTheme.bodyText1?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: Get.height * 0.015,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              // optional
                              useStickyGroupSeparators: true, // optional
                              // floatingHeader: true, // optional
                              // order: GroupedListOrder.ASC, // optional
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Obx(
                    //   () => Container(
                    //     height: Get.height * 0.8,
                    //     width: Get.width,
                    //     color: Colors.amber[50],
                    //     child: ListView.builder(
                    //         itemCount:
                    //             _homepageController.ledgerReportData.length,
                    //         itemBuilder: (context, index) {
                    //           var data = _homepageController.ledgerReportData;
                    //           return Card(
                    //             child: Row(
                    //               mainAxisSize: MainAxisSize.min,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceAround,
                    //               children: [
                    //                 Text(_homepageController.partyList!
                    //                     .firstWhere((element) =>
                    //                         element.id == data[index].pID)
                    //                     .name),
                    //                 Text(DateFormat('dd-MM-yyyy')
                    //                     .format(data[index].ledgerDate)
                    //                     .toString()),
                    //                 Text(data[index].type),
                    //                 Text(data[index].drAmount.toString()),
                    //                 Text(data[index].crAmount.toString()),
                    //               ],
                    //             ),
                    //           );
                    //         }),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      //
      // floatingActionButton: Obx(
      //   () => Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Visibility(
      //         visible: _homepageController.pendingReportData.isNotEmpty &&
      //             _homepageController.comissionAndmatTypeNaNSetData.isEmpty,
      //         child: Button(
      //             height: Get.height * 0.05,
      //             width: Get.width * 0.1,
      //             fontSize: Get.width * 0.012,
      //             text: 'Generate',
      //             onPressed: () async {
      //               print('Generate Report');
      //               await _homepageController.generateComissionReport(
      //                   data: _homepageController.pendingReportData);
      //             }),
      //       ),
      //       FloatingActionButton(
      //         tooltip: _homepageController.pendingReportData.isEmpty
      //             ? 'Add CSV'
      //             : 'Add Data in Database', //child widget inside this button
      //         onPressed: () async {
      //           print("Button is pressed.");
      //           if (_homepageController.isLoading.value == false) {
      //             if (_homepageController.pendingReportData.length > 1 &&
      //                 _homepageController
      //                     .comissionAndmatTypeNaNSetData.isEmpty &&
      //                 _homepageController.partyNaNSetData.isEmpty) {
      //               print(_homepageController.pendingReportData);
      //               List<List<dynamic>> data = [];
      //               data.addAll(_homepageController.pendingReportData);
      //               await _homepageController.checkInputData(fields: data);
      //               if (_homepageController
      //                       .comissionAndmatTypeNaNSetData.isEmpty &&
      //                   _homepageController.partyNaNSetData.isEmpty) {
      //                 await _homepageController.insertData(data);
      //               } else {
      //                 Get.defaultDialog(
      //                   title: 'Error',
      //                   middleText: 'Please check the data',
      //                   textConfirm: 'Ok',
      //                   confirmTextColor: Colors.white,
      //                   onConfirm: () {
      //                     Get.back();
      //                   },
      //                 );
      //               }
      //             } else {
      //               if (_homepageController.pendingReportData.length < 2 &&
      //                   _homepageController
      //                       .comissionAndmatTypeNaNSetData.isEmpty &&
      //                   _homepageController.partyNaNSetData.isEmpty) {
      //                 _homepageController.pickFile();
      //               } else {
      //                 Get.defaultDialog(
      //                   title: 'Error',
      //                   middleText: 'Please check the data',
      //                   textConfirm: 'Ok',
      //                   confirmTextColor: Colors.white,
      //                   onConfirm: () {
      //                     Get.back();
      //                   },
      //                 );
      //               }
      //             }
      //           } else {
      //             'Data is processing'.infoSnackbar;
      //           }

      //           //task to execute when this button is pressed
      //         },
      //         child: _homepageController.isLoading.value
      //             ? Center(
      //                 child: CupertinoActivityIndicator(
      //                   radius: Get.height * 0.02,
      //                   color: Colors.white,
      //                 ),
      //               )
      //             : (_homepageController.pendingReportData.length < 2 &&
      //                     _homepageController
      //                         .comissionAndmatTypeNaNSetData.isEmpty &&
      //                     _homepageController.partyNaNSetData.isEmpty)
      //                 ? const Icon(Icons.add)
      //                 : const Icon(Icons.arrow_forward_ios),
      //       ),
      //     ],
      //   ),
      // ),
      // drawer: drawer(),
    );
  }
}
