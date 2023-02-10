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
  int count = 0;
  double drcount = 0;
  List<double> drcountList = [];
  double crcount = 0;
  List<double> crcountList = [];
  int pid = 0;
  int isvisible = 0;

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
            bottom: bottomAppBar(homepageController: _homepageController)),
        body: SingleChildScrollView(
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
                                          LableWithCheckbox(
                                            lable: 'Select Party:',
                                            checkBoxOnchange: (value) =>
                                                _homepageController
                                                    .isAllPartySelected
                                                    .value = value!,
                                            checkBoxValue: _homepageController
                                                .isAllPartySelected.value,
                                            isCheckBoxVisible: true,
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.20,
                                            child: PartyDropDownItems(
                                              defualtValue: _homepageController
                                                  .defaultParty,
                                              itemList:
                                                  _homepageController.partyList,
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
                                              onTap: () => _homepageController
                                                  .defaultDuration
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
                                                    fontSize:
                                                        Get.height * 0.015,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Visibility(
                                              visible: _homepageController
                                                      .defaultDuration.value !=
                                                  'Custom',
                                              replacement: SizedBox(
                                                child: Container(
                                                  width: Get.width * 0.20,
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
                                                                    _homepageController
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
                                                              _homepageController
                                                                  .chooseDateRangePicker();
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .date_range),
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
                                                                    _homepageController
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
                                                width: Get.width * 0.20,
                                                child: StringDropDownItems(
                                                  homecontroller:
                                                      _homepageController,
                                                  defualtValue:
                                                      _homepageController
                                                          .defaultDuration,
                                                  itemList: _homepageController
                                                      .durationList
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
                            //**  Search button
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Button(
                                height: Get.height * 0.045,
                                width: Get.width * 0.08,
                                fontSize: Get.width * 0.010,
                                text: 'Search',
                                onPressed: () async {
                                  debugPrint('Search Button Pressed');
                                  debugPrint(_homepageController
                                      .isAllPartySelected.value
                                      .toString());
                                  debugPrint(_homepageController.defaultParty
                                      .toString());
                                  debugPrint(_homepageController.defaultDuration
                                      .toString());
                                  debugPrint(_homepageController
                                      .defaultMaterialType
                                      .toString());
                                  debugPrint(_homepageController
                                      .defaultPartyCity
                                      .toString());
                                  debugPrint(_homepageController
                                      .dateRange.value.start
                                      .toString());
                                  debugPrint(_homepageController
                                      .dateRange.value.end
                                      .toString());

                                  _homepageController.getDurationDateRange(
                                      duration: _homepageController
                                          .defaultDuration.value);
                                  // debugPrint(
                                  //     _homepageController.dateRange.value.start);
                                  // debugPrint(_homepageController.dateRange.value.end);
                                  await _homepageController.getLedgerSearchData(
                                    start: _homepageController
                                        .dateRange.value.start,
                                    end:
                                        _homepageController.dateRange.value.end,
                                    selectedParty:
                                        _homepageController.defaultParty.value,
                                    isAllPartySelected: _homepageController
                                        .isAllPartySelected.value,
                                  );
                                  // Get.offAllNamed(Homepage.routeName);
                                },
                              ),
                            ),
                            //** pdf button
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Button(
                                height: Get.height * 0.045,
                                width: Get.width * 0.05,
                                fontSize: Get.width * 0.010,
                                text: 'Pdf',
                                onPressed: () async {
                                  if (_homepageController
                                          .ledgerReportData.isEmpty ||
                                      _homepageController
                                              .ledgerReportData.length <
                                          2) {
                                    'No Data Found'.errorSnackbar;
                                    return;
                                  }
                                  debugPrint('Create Pdf');
                                  debugPrint(_homepageController
                                      .ledgerPartyWiseSet
                                      .toString());

                                  await _homepageController.createLedgerPdf(
                                      partyWiseList: _homepageController
                                          .ledgerPartyWiseSet);
                                },
                              ),
                            ),
                          ],
                        ),
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
                                        style: textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.height * 0.018,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: Text(
                                        'Type',
                                        style: textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.height * 0.018,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                      child: Text(
                                        'Debit',
                                        style: textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.height * 0.018,
                                            color: Colors.white),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.1,
                                      child: Text(
                                        'Credit',
                                        style: textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: Get.height * 0.018,
                                            color: Colors.white),
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
                                width: Get.width * 1,
                                // color: Colors.amber[50],
                                child: GroupedListView<LedgerData, String>(
                                  elements:
                                      _homepageController.ledgerReportData,
                                  groupBy: (element) {
                                    debugPrint('G : ${element.pID}');
                                    return element.pID.toString();
                                  },
                                  groupSeparatorBuilder: (String groupByValue) {
                                    debugPrint('GS : $groupByValue');
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0, top: 20),
                                          child: Card(
                                            color:
                                                lCOLOR_PRIMARY.withOpacity(0.1),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: AutoSizeText(
                                                _homepageController.partyList!
                                                    .firstWhere((item) =>
                                                        item.id ==
                                                        int.parse(groupByValue))
                                                    .name,
                                                style: textTheme.bodyLarge
                                                    ?.copyWith(
                                                  fontSize: Get.height * 0.020,
                                                ),
                                                minFontSize: 10,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  indexedItemBuilder:
                                      ((context, element, index) {
                                    // debugPrint('element: ${element}');
                                    // debugPrint('index: ${index}');

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
                                              element.ledgerDate ==
                                                      DateTime(1800, 01, 01)
                                                  ? ''
                                                  : DateFormat('dd-MM-yyyy')
                                                      .format(
                                                          element.ledgerDate),
                                              style: textTheme.bodyLarge
                                                  ?.copyWith(
                                                      fontSize:
                                                          Get.height * 0.018),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.2,
                                            child: Text(
                                              element.type,
                                              style: textTheme.bodyLarge
                                                  ?.copyWith(
                                                      fontSize:
                                                          Get.height * 0.018),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.1,
                                            child: Text(
                                              element.drAmount < 1
                                                  ? ''
                                                  : element.drAmount
                                                      .toStringAsFixed(2),
                                              style: textTheme.bodyLarge
                                                  ?.copyWith(
                                                      fontSize:
                                                          Get.height * 0.018),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.1,
                                            child: Text(
                                              element.crAmount < 1
                                                  ? ''
                                                  : element.crAmount
                                                      .toStringAsFixed(2),
                                              style: textTheme.bodyLarge
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
