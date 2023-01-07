import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/screen/homepage/partyPayment.dart';
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

class GeneratedReport extends StatelessWidget {
  static const routeName = '/generatedReport';
  HomepageController _homepageController = Get.put(HomepageController());
  @override
  Widget build(BuildContext context) {
    // _homepageController.generatedReportData.value = [];
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
            'Generated Report',
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
                    SizedBox(
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Column(
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
                                                  .defualtParty,
                                              itemList:
                                                  _homepageController.partyList,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LableWithCheckbox(
                                            lable: 'Select Material:',
                                            checkBoxOnchange: (value) =>
                                                _homepageController
                                                    .isAllMaterialTypeSelected
                                                    .value = value!,
                                            checkBoxValue: _homepageController
                                                .isAllMaterialTypeSelected
                                                .value,
                                            isCheckBoxVisible: true,
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.20,
                                            child: MaterialTypeDropDownItems(
                                              defualtValue: _homepageController
                                                  .defualtMaterialType,
                                              itemList: _homepageController
                                                  .materialTypeList,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LableWithCheckbox(
                                          lable: 'Select City:',
                                          checkBoxOnchange: (value) =>
                                              _homepageController
                                                  .isAllPartyCitySelected
                                                  .value = value!,
                                          checkBoxValue: _homepageController
                                              .isAllPartyCitySelected.value,
                                          isCheckBoxVisible: true,
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.20,
                                          child: StringDropDownItems(
                                            defualtValue: _homepageController
                                                .defualtPartyCity,
                                            itemList: _homepageController
                                                .partyCityList
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () => _homepageController
                                                .defualtDuration
                                                .value = 'One Month',
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
                                              child: AutoSizeText(
                                                'Duration:',
                                                style: _textTheme.bodyText1
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
                                            visible: _homepageController
                                                    .defualtDuration.value !=
                                                'Custom',
                                            replacement: SizedBox(
                                              child: Container(
                                                width: Get.width * 0.20,
                                                // color: Colors.amber,
                                                margin:
                                                    EdgeInsets.only(left: 10),
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
                                                            style: _textTheme
                                                                .bodyText1
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
                                                            style: _textTheme
                                                                .bodyText1
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
                                                defualtValue:
                                                    _homepageController
                                                        .defualtDuration,
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
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            // color: Colors.amber,
                            child: Button(
                              height: Get.height * 0.045,
                              width: Get.width * 0.08,
                              fontSize: Get.width * 0.010,
                              text: 'Search',
                              onPressed: () async {
                                print('Search Button Pressed');
                                print(_homepageController
                                    .isAllPartySelected.value);
                                print(_homepageController.defualtParty);
                                print(_homepageController.defualtDuration);
                                print(_homepageController.defualtMaterialType);
                                print(_homepageController.defualtPartyCity);
                                print(
                                    _homepageController.dateRange.value.start);
                                print(_homepageController.dateRange.value.end);

                                switch (
                                    _homepageController.defualtDuration.value) {
                                  case 'One Month':
                                    DateTime last = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            1)
                                        .subtract(Duration(days: 1));
                                    DateTimeRange dateRange = DateTimeRange(
                                      start: DateTime(last.year, last.month, 1),
                                      end: last,
                                    );
                                    print(dateRange);
                                    _homepageController.dateRange.value =
                                        dateRange;
                                    break;
                                  case 'Four Month':
                                    DateTime last = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            1)
                                        .subtract(Duration(days: 1));
                                    DateTimeRange dateRange = DateTimeRange(
                                      start: DateTime(
                                          last.year, last.month - 3, 1),
                                      end: last,
                                    );
                                    print(dateRange);
                                    _homepageController.dateRange.value =
                                        dateRange;
                                    break;
                                  case 'Six Month':
                                    DateTime last = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            1)
                                        .subtract(Duration(days: 1));
                                    DateTimeRange dateRange = DateTimeRange(
                                      start: DateTime(
                                          last.year, last.month - 5, 1),
                                      end: last,
                                    );
                                    print(dateRange);
                                    _homepageController.dateRange.value =
                                        dateRange;
                                    break;
                                  case 'One Year':
                                    DateTime last = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            1)
                                        .subtract(Duration(days: 1));
                                    DateTimeRange dateRange = DateTimeRange(
                                      start: last.month == 12
                                          ? DateTime(last.year, 1, 1)
                                          : DateTime(
                                              last.year - 1, last.month, 1),
                                      end: last,
                                    );
                                    print(dateRange);
                                    _homepageController.dateRange.value =
                                        dateRange;
                                    break;
                                  default:
                                }
                                print(
                                    _homepageController.dateRange.value.start);
                                print(_homepageController.dateRange.value.end);
                                await _homepageController
                                    .getGeneratedSearchData(
                                  start:
                                      _homepageController.dateRange.value.start,
                                  end: _homepageController.dateRange.value.end,
                                  selectedParty:
                                      _homepageController.defualtParty.value,
                                  isAllPartySelected: _homepageController
                                      .isAllPartySelected.value,
                                  isAllMaterialTypeSelected: _homepageController
                                      .isAllMaterialTypeSelected.value,
                                  isAllPartyCitySelected: _homepageController
                                      .isAllPartyCitySelected.value,
                                  selectedMaterialType: _homepageController
                                      .defualtMaterialType.value,
                                  selectedPartyCity: _homepageController
                                      .defualtPartyCity.value,
                                );
                                // Get.offAllNamed(Homepage.routeName);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    //**Data Ui Part
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
                              itemCount: _homepageController
                                  .generatedReportData.length,
                              itemBuilder: (_, index) {
                                var date = index != 0
                                    ? _homepageController
                                        .generatedReportData[index][20]
                                    : DateTime.now();

                                return Visibility(
                                  visible: index != 0,
                                  replacement: Container(),
                                  child: Card(
                                    margin: const EdgeInsets.all(3),
                                    color: _homepageController.displayData
                                            .contains(_homepageController
                                                .generatedReportData[index][15])
                                        ? date.isAfter(DateTime(1800, 01, 01))
                                            ? const Color.fromARGB(
                                                255, 121, 192, 124)
                                            : Colors.white
                                        : const Color.fromARGB(
                                            255, 228, 136, 129),
                                    child: Container(
                                      width: Get.width * 1.5,
                                      height: Get.height * 0.04,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _homepageController
                                                .generatedReportData[index]
                                                .isNotEmpty
                                            ? _homepageController
                                                    .generatedReportData[index]
                                                    .length -
                                                1
                                            : 0,
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
                                            child: Visibility(
                                              visible: subIndex == 3 &&
                                                  _homepageController
                                                          .partyNaNSetData
                                                          .contains(
                                                              _homepageController
                                                                      .generatedReportData[
                                                                  index][15]) ==
                                                      true,
                                              replacement: Visibility(
                                                visible: subIndex == 7 &&
                                                    _homepageController
                                                            .comissionAndmatTypeNaNSetData
                                                            .contains(_homepageController
                                                                    .generatedReportData[
                                                                index][15]) ==
                                                        true,
                                                replacement: AutoSizeText(
                                                  (index != 0 &&
                                                          (subIndex == 1 ||
                                                              subIndex == 13))
                                                      ? DateFormat("dd-MM-yyyy")
                                                          .format(DateFormat(
                                                                  "dd.MM.yyyy")
                                                              .parse(_homepageController
                                                                  .generatedReportData[
                                                                      index]
                                                                      [subIndex]
                                                                  .toString()))
                                                          .toString()
                                                      : _homepageController
                                                          .generatedReportData[
                                                              index][subIndex]
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                  minFontSize: 10,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: Get.width * 0.06,
                                                      child: AutoSizeText(
                                                        _homepageController
                                                            .generatedReportData[
                                                                index][subIndex]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                        minFontSize: 10,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: Get.width * 0.03,
                                                      height: Get.height * 0.03,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          print(
                                                              'new material Type');
                                                          String btnText =
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
                                                                    .equals(_homepageController
                                                                            .generatedReportData[
                                                                        index][3])))
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
                                                              party: party[0],
                                                              btnText: btnText,
                                                              isShow: true,
                                                              materialType: TextEditingController(
                                                                  text: _homepageController
                                                                          .generatedReportData[
                                                                      index][7]),
                                                              // partyTypeIDList: partyTypeIDList,
                                                              // id: snapshot.data?[index].id,
                                                              // newComission: name,
                                                            ),
                                                          );
                                                        },
                                                        child: const AutoSizeText(
                                                            "Add",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                            minFontSize: 10,
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
                                                    width: Get.width * 0.15,
                                                    child: AutoSizeText(
                                                      _homepageController
                                                          .generatedReportData[
                                                              index][subIndex]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                      minFontSize: 10,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: Get.width * 0.03,
                                                    height: Get.height * 0.03,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        print(
                                                            'new customer add');
                                                        TextEditingController
                                                            name =
                                                            TextEditingController(
                                                                text: _homepageController
                                                                    .generatedReportData[
                                                                        index][
                                                                        subIndex]
                                                                    .toString());
                                                        print(name.text);
                                                        String btnText =
                                                            'Add New Party';

                                                        Get.bottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          ignoreSafeArea: false,
                                                          PartyTypeBottomsheet(
                                                            name: name,
                                                            btnText: btnText,
                                                          ),
                                                        );
                                                      },
                                                      child: const AutoSizeText(
                                                          "Add",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                          minFontSize: 10,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
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

class LableWithCheckbox extends StatelessWidget {
  LableWithCheckbox(
      {Key? key,
      required this.lable,
      this.checkBoxOnchange,
      this.checkBoxValue,
      required this.isCheckBoxVisible});

  final String lable; // = 'Select Party:';
  final bool? checkBoxValue; //= false;
  final Function(bool?)? checkBoxOnchange;
  final bool? isCheckBoxVisible; //= false

  @override
  Widget build(BuildContext context) {
    final TextTheme _textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: Get.width * 0.20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: AutoSizeText(
              lable,
              style: _textTheme.bodyText1?.copyWith(
                fontSize: Get.height * 0.015,
              ),
              maxLines: 1,
            ),
          ),
          Visibility(
            visible: isCheckBoxVisible!,
            replacement: Container(),
            child: Checkbox(
              value: checkBoxValue,
              onChanged: checkBoxOnchange,
            ),
          ),
          // Checkbox(
          //   value: homepageController.isAllPartySelected.value,
          //   onChanged: (value) =>
          //       homepageController.isAllPartySelected.value = value!,
          // ),
        ],
      ),
    );
  }
}
