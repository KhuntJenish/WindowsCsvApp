import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../../dashboard.dart';
import '../../database/tables.dart';
import '../../theam/theam_constants.dart';
import '../../utils/dropDownItem.dart';
import '../../utils/helper_widget.dart';

class PartyLedger extends StatelessWidget {
  static const routeName = '/partyLedger';
  final HomepageController _homepageController = Get.put(HomepageController());

  PartyLedger({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final ScrollController horizontalScroll = ScrollController();
    final ScrollController verticalScroll = ScrollController();
    const double width = 20;

    return WillPopScope(
      onWillPop: () async {
        _homepageController.isSelectedReport.value = 0;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Ledger Report',
              style: textTheme.bodyText1?.copyWith(
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
            bottom: bottomAppBar(homepageController: _homepageController)),
        body: AdaptiveScrollbar(
          controller: horizontalScroll,
          width: width,
          position: ScrollbarPosition.bottom,
          underSpacing: const EdgeInsets.only(bottom: width),
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
                    SizedBox(
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
                                        style: textTheme.bodyText1?.copyWith(
                                          fontSize: Get.height * 0.015,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
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
                                        style: textTheme.bodyText1?.copyWith(
                                          fontSize: Get.height * 0.015,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            _homepageController
                                                .dateRange.value.start),
                                        style: textTheme.bodyText1?.copyWith(
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
                                        style: textTheme.bodyText1?.copyWith(
                                          fontSize: Get.height * 0.015,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            _homepageController
                                                .dateRange.value.end),
                                        style: textTheme.bodyText1?.copyWith(
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
                              // print('Search Button Pressed');
                              // print(
                              //     _homepageController.isAllPartySelected.value);
                              // print(_homepageController.defualtParty);
                              // print(_homepageController.dateRange.value.start);
                              // print(_homepageController.dateRange.value.end);
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
                      () => SingleChildScrollView(
                        child: Column(
                          children: [
                            Visibility(
                              visible: _homepageController
                                  .ledgerReportData.isNotEmpty,
                              child: Container(
                                height: Get.height * 0.04,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: lCOLOR_ACCENT,
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.1,
                                      child: Text(
                                        'Date',
                                        style: textTheme.bodyText1?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.height * 0.018,
                                            color: Colors.red),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: Text(
                                        'Type',
                                        style: textTheme.bodyText1?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.height * 0.018,
                                            color: Colors.red),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                      child: Text(
                                        'Debit',
                                        style: textTheme.bodyText1?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.height * 0.018,
                                            color: Colors.red),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                      child: Text(
                                        'Credit',
                                        style: textTheme.bodyText1?.copyWith(
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
                            AdaptiveScrollbar(
                              controller: verticalScroll,
                              width: width,
                              child: SizedBox(
                                height: Get.height * 0.7,
                                width: Get.width,
                                // color: Colors.amber[50],
                                child: GroupedListView<LedgerData, String>(
                                  elements: _homepageController
                                      .ledgerReportData,
                                  groupBy: (element) => element.pID.toString(),
                                  groupSeparatorBuilder:
                                      (String groupByValue) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, top: 20),
                                    child: Card(
                                      color: lCOLOR_PRIMARY.withOpacity(0.1),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AutoSizeText(
                                          _homepageController.partyList!
                                              .firstWhere((item) =>
                                                  item.id ==
                                                  int.parse(groupByValue))
                                              .name,
                                          style: textTheme.bodyText1?.copyWith(
                                            fontSize: Get.height * 0.020,
                                          ),
                                          minFontSize: 10,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  indexedItemBuilder:
                                      ((context, element, index) {
                                    print('element: ${element}');
                                    print('index: ${index}');
                                    return Container(
                                      height: Get.height * 0.04,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        // borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.1,
                                            child: Text(
                                              DateFormat('dd-MM-yyyy')
                                                  .format(element.ledgerDate),
                                              style: textTheme.bodyText1
                                                  ?.copyWith(
                                                      fontSize:
                                                          Get.height * 0.018),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.2,
                                            child: Text(
                                              element.type,
                                              style: textTheme.bodyText1
                                                  ?.copyWith(
                                                      fontSize:
                                                          Get.height * 0.018),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.1,
                                            child: Text(
                                              element.drAmount.toString(),
                                              style: textTheme.bodyText1
                                                  ?.copyWith(
                                                      fontSize:
                                                          Get.height * 0.018),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.1,
                                            child: Text(
                                              element.crAmount.toString(),
                                              style: textTheme.bodyText1
                                                  ?.copyWith(
                                                      fontSize:
                                                          Get.height * 0.018),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),

                                  // itemBuilder: (context, LedgerData element) {
                                  //   return Container(
                                  //     height: Get.height * 0.04,
                                  //     margin: const EdgeInsets.symmetric(
                                  //         horizontal: 8, vertical: 0),
                                  //     decoration: BoxDecoration(
                                  //       border: Border.all(
                                  //           color: Colors.grey, width: 1),
                                  //       // borderRadius: BorderRadius.circular(5),
                                  //     ),
                                  //     child: Row(
                                  //       mainAxisSize: MainAxisSize.min,
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceEvenly,
                                  //       children: [
                                  //         Container(
                                  //           width: Get.width * 0.1,
                                  //           child: Text(
                                  //             DateFormat('dd-MM-yyyy')
                                  //                 .format(element.ledgerDate)
                                  //                 .toString(),
                                  //             style:
                                  //                 _textTheme.bodyText1?.copyWith(
                                  //               fontSize: Get.height * 0.015,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           width: Get.width * 0.2,
                                  //           child: Text(
                                  //             element.type,
                                  //             style:
                                  //                 _textTheme.bodyText1?.copyWith(
                                  //               fontSize: Get.height * 0.015,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           width: Get.width * 0.1,
                                  //           child: Text(
                                  //             element.drAmount != 0
                                  //                 ? element.drAmount
                                  //                     .toStringAsFixed(2)
                                  //                 : '',
                                  //             style:
                                  //                 _textTheme.bodyText1?.copyWith(
                                  //               fontSize: Get.height * 0.015,
                                  //             ),
                                  //             textAlign: TextAlign.right,
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           width: Get.width * 0.1,
                                  //           child: Text(
                                  //             element.crAmount != 0
                                  //                 ? element.crAmount
                                  //                     .toStringAsFixed(2)
                                  //                 : '',
                                  //             style:
                                  //                 _textTheme.bodyText1?.copyWith(
                                  //               fontWeight: FontWeight.w400,
                                  //               fontSize: Get.height * 0.015,
                                  //             ),
                                  //             textAlign: TextAlign.right,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   );
                                  // },
                                  // optional
                                  useStickyGroupSeparators: true, // optional
                                  // floatingHeader: true, // optional
                                  // order: GroupedListOrder.ASC, // optional
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
