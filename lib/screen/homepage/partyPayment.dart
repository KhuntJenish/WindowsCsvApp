import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/generatedReport.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:csvapp/utils/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../dashboard.dart';
import '../../theam/theam_constants.dart';
import '../../utils/dropDownItem.dart';
import '../../utils/partyComissionBottomsheet.dart';
import '../../utils/partyMasterBottomsheet.dart';

class PartyPayment extends StatelessWidget {
  static const routeName = '/partyPayment';
  final HomepageController _homepageController = Get.put(HomepageController());

  PartyPayment({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final ScrollController horizontalScroll = ScrollController();
    final ScrollController verticalScroll = ScrollController();
    const double width = 20;
    RxBool? isAllPartyChecked = true.obs;
    // Set smtInvNo = {};

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
          bottom: bottomAppBar(homepageController: _homepageController),
        ),
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
                                                  .defualtParty,
                                              itemList:
                                                  _homepageController.partyList,
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
                                      //** Select party-City menu */
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
                                      //** Duration menu */
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
                                                  style: textTheme.bodyText1
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
                                                      .defualtDuration.value !=
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
                            //**  Search button
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Button(
                                height: Get.height * 0.045,
                                width: Get.width * 0.08,
                                fontSize: Get.width * 0.010,
                                text: 'Search',
                                onPressed: () async {
                                  _homepageController.smtInvNoSet.clear();
                                  print('Search Button Pressed');
                                  print(_homepageController
                                      .isAllPartySelected.value);
                                  print(_homepageController.defualtParty);
                                  print(_homepageController.defualtDuration);
                                  print(
                                      _homepageController.defualtMaterialType);
                                  print(_homepageController.defualtPartyCity);
                                  print(_homepageController
                                      .dateRange.value.start);
                                  print(
                                      _homepageController.dateRange.value.end);
                                  _homepageController.getDurationDateRange(
                                      duration: _homepageController
                                          .defualtDuration.value);

                                  await _homepageController
                                      .getGeneratedSearchData(
                                    start: _homepageController
                                        .dateRange.value.start,
                                    end:
                                        _homepageController.dateRange.value.end,
                                    selectedParty:
                                        _homepageController.defualtParty.value,
                                    isAllPartySelected: _homepageController
                                        .isAllPartySelected.value,
                                    isAllMaterialTypeSelected:
                                        _homepageController
                                            .isAllMaterialTypeSelected.value,
                                    isAllPartyCitySelected: _homepageController
                                        .isAllPartyCitySelected.value,
                                    selectedMaterialType: _homepageController
                                        .defualtMaterialType.value,
                                    selectedPartyCity: _homepageController
                                        .defualtPartyCity.value,
                                  );
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
                                          .generatedReportData.isEmpty ||
                                      _homepageController
                                              .generatedReportData.length <
                                          2) {
                                    'No Data Found'.errorSnackbar;
                                    return;
                                  }
                                  print('Create Pdf');
                                  print(
                                      _homepageController.generatedReportData);

                                  await _homepageController.createReportPdf();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //**Data Ui Part

                    _homepageController.generatedReportData.isEmpty
                        ? Container()
                        : Card(
                            margin: const EdgeInsets.all(3),
                            color: lCOLOR_ACCENT,
                            child: SizedBox(
                              width: Get.width * 1.5,
                              height: Get.height * 0.05,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: ListView.builder(
                                        itemCount: _homepageController
                                            .generatedReportData[0].length,
                                        scrollDirection: Axis.horizontal,
                                        // shrinkWrap: true,
                                        itemBuilder: (_, subIndex) {
                                          return Container(
                                            // color: Colors.red,
                                            width: subIndex == 3
                                                ? Get.width * 0.2
                                                : (subIndex == 6 ||
                                                        subIndex == 7 ||
                                                        subIndex == 9)
                                                    ? Get.width * 0.1
                                                    : Get.width * 0.06,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            // height: Get.height * 0.05,
                                            padding: const EdgeInsets.all(8.0),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                _homepageController
                                                    .generatedReportData[0]
                                                        [subIndex]
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                // minFontSize: 10,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  Obx(
                                    () => Visibility(
                                      visible: !_homepageController
                                          .isAllPartySelected.value,
                                      child: Container(
                                        width: Get.width * 0.033,
                                        // color: Colors.red,
                                        child: Checkbox(
                                          value: isAllPartyChecked.value,
                                          onChanged: (value) {
                                            isAllPartyChecked.value = value!;
                                            print(value);
                                            // _homepageController.isAllPartySelected.refresh();
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
                                RxBool? isPartyChecked = true.obs;
                                index != 0
                                    ? _homepageController.smtInvNoSet.add(
                                        _homepageController
                                            .generatedReportData[index][15]
                                            .toString())
                                    : null;
                                // var isPartyChecked = true;
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
                                    child: SizedBox(
                                      width: Get.width * 1.5,
                                      height: Get.height * 0.04,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _homepageController
                                                      .generatedReportData[
                                                          index]
                                                      .isNotEmpty
                                                  ? _homepageController
                                                          .generatedReportData[
                                                              index]
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
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Visibility(
                                                    visible: subIndex == 3 &&
                                                        _homepageController
                                                                .partyNaNSetData
                                                                .contains(_homepageController
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
                                                                (subIndex ==
                                                                        1 ||
                                                                    subIndex ==
                                                                        13))
                                                            ? DateFormat(
                                                                    "dd-MM-yyyy")
                                                                .format(DateFormat(
                                                                        "dd.MM.yyyy")
                                                                    .parse(_homepageController
                                                                        .generatedReportData[index]
                                                                            [
                                                                            subIndex]
                                                                        .toString()))
                                                                .toString()
                                                            : _homepageController
                                                                .generatedReportData[
                                                                    index]
                                                                    [subIndex]
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
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: Get.width *
                                                                0.06,
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
                                                          SizedBox(
                                                            width: Get.width *
                                                                0.03,
                                                            height: Get.height *
                                                                0.03,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
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
                                                                          .equals(_homepageController.generatedReportData[index]
                                                                              [
                                                                              3])))
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
                                                                            text:
                                                                                _homepageController.generatedReportData[index][7]),
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
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.15,
                                                          child: AutoSizeText(
                                                            _homepageController
                                                                .generatedReportData[
                                                                    index]
                                                                    [subIndex]
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
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
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.03,
                                                          height:
                                                              Get.height * 0.03,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              print(
                                                                  'new customer add');
                                                              TextEditingController
                                                                  name =
                                                                  TextEditingController(
                                                                      text: _homepageController
                                                                          .generatedReportData[
                                                                              index]
                                                                              [
                                                                              subIndex]
                                                                          .toString());
                                                              print(name.text);
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
                                                );
                                              },
                                            ),
                                          ),
                                          Obx(
                                            () => Visibility(
                                              visible: !isAllPartyChecked.value,
                                              child: Container(
                                                width: Get.width * 0.025,
                                                // color: Colors.red,
                                                child: Visibility(
                                                  visible: date.isAfter(
                                                      DateTime(1800, 01, 01)),
                                                  replacement: Checkbox(
                                                    value: isPartyChecked.value,
                                                    onChanged: (value) {
                                                      isPartyChecked.value =
                                                          value!;
                                                      print(value);
                                                      if (value) {
                                                        _homepageController
                                                            .smtInvNoSet
                                                            .add(_homepageController
                                                                .generatedReportData[
                                                                    index][15]
                                                                .toString());
                                                        _homepageController
                                                                .partyWiseTotalAmount
                                                                .value +=
                                                            double.parse(
                                                                _homepageController
                                                                    .generatedReportData[
                                                                        index]
                                                                        [19]
                                                                    .toString());
                                                        _homepageController
                                                            .partyWisePayableAmount
                                                            .value = _homepageController
                                                                .partyWiseTotalAmount
                                                                .value -
                                                            _homepageController
                                                                .partyWisePaidAmount
                                                                .value;
                                                      } else {
                                                        _homepageController
                                                            .smtInvNoSet
                                                            .remove(_homepageController
                                                                .generatedReportData[
                                                                    index][15]
                                                                .toString());
                                                        _homepageController
                                                                .partyWiseTotalAmount
                                                                .value -=
                                                            double.parse(
                                                                _homepageController
                                                                    .generatedReportData[
                                                                        index]
                                                                        [19]
                                                                    .toString());
                                                        _homepageController
                                                            .partyWisePayableAmount
                                                            .value = _homepageController
                                                                .partyWiseTotalAmount
                                                                .value -
                                                            _homepageController
                                                                .partyWisePaidAmount
                                                                .value;
                                                      }
                                                      print(_homepageController
                                                          .partyWiseTotalAmount
                                                          .value);

                                                      print(_homepageController
                                                          .smtInvNoSet);
                                                      // _homepageController.isAllPartySelected.refresh();
                                                    },
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      print('payment Back');
                                                      print(_homepageController
                                                          .generatedReportData[
                                                              index][15]
                                                          .toString());
                                                      _homepageController
                                                          .reversePaymentProcess(
                                                              _homepageController
                                                                  .generatedReportData[
                                                                      index][15]
                                                                  .toString());
                                                    },
                                                    icon: const Icon(
                                                        Icons.arrow_back_ios),
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
                              child: SizedBox(
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
                                              amount: _homepageController
                                                  .partyWisePayableAmount
                                                  .toString()),
                                          Button(
                                            text: 'Pay',
                                            onPressed: () {
                                              print('payment');
                                              if (_homepageController
                                                      .partyWisePayableAmount >
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
        style: textTheme.bodyText1?.copyWith(
          // color: Colors.white,
          fontSize: Get.height * 0.02,
        ),
      ),
      Text(
        amount,
        style: textTheme.headline6?.copyWith(
          // color: Colors.white,
          fontSize: Get.height * 0.015,
        ),
      ),
    ]);
  }
}
