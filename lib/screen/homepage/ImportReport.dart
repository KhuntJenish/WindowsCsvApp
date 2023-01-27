import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/dashboard.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../theam/theam_constants.dart';
import '../../utils/dropDownItem.dart';
import '../../utils/helper_widget.dart';
import '../../utils/partyComissionBottomsheet.dart';
import '../../utils/partyMasterBottomsheet.dart';

class ImportReport extends StatelessWidget {
  static const routeName = '/importReport';
  final HomepageController _homepageController = Get.put(HomepageController());

  ImportReport({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final ScrollController horizontalScroll = ScrollController();
    final ScrollController verticalScroll = ScrollController();
    const double width = 20;
    // print(_homepageController.isSelectedReport.value);
    return WillPopScope(
      onWillPop: () async {
        _homepageController.isSelectedReport.value = 0;

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Import Report',
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
                                        onChanged: (value) =>
                                            _homepageController
                                                .isAllPartySelected
                                                .value = value!,
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
                                print('Search Button Pressed');
                                print(_homepageController
                                    .isAllPartySelected.value);
                                print(_homepageController.defualtParty);
                                print(
                                    _homepageController.dateRange.value.start);
                                print(_homepageController.dateRange.value.end);
                                if (_homepageController.defualtParty.value.id ==
                                    0) {
                                  '😀Please Select Party'.errorSnackbar;
                                } else {
                                  await _homepageController
                                      .getPendingSearchData(
                                          start: _homepageController
                                              .dateRange.value.start,
                                          end: _homepageController
                                              .dateRange.value.end,
                                          selectedParty: _homepageController
                                              .defualtParty.value,
                                          isAllPartySelected:
                                              _homepageController
                                                  .isAllPartySelected.value);
                                }
                                // Get.offAllNamed(Homepage.routeName);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: _homepageController.isLoading.value,
                                  replacement: Button(
                                      height: Get.height * 0.04,
                                      width: Get.width * 0.08,
                                      fontSize: Get.width * 0.010,
                                      text: ((_homepageController
                                                          .pendingReportData
                                                          .length <
                                                      2 ||
                                                  _homepageController
                                                      .pendingReportData
                                                      .isEmpty) &&
                                              _homepageController
                                                  .comissionAndmatTypeNaNSetData
                                                  .isEmpty &&
                                              _homepageController
                                                  .partyNaNSetData.isEmpty)
                                          ? 'Add CSV'
                                          : 'Add Data',
                                      onPressed: () async {
                                        print("Button is pressed.");
                                        if (_homepageController
                                                .isLoading.value ==
                                            false) {
                                          if (((_homepageController
                                                      .pendingReportData.length >=
                                                  2) &&
                                              _homepageController
                                                  .comissionAndmatTypeNaNSetData
                                                  .isEmpty &&
                                              _homepageController
                                                  .partyNaNSetData.isEmpty)) {
                                            print(_homepageController
                                                .pendingReportData);
                                            List<List<dynamic>> data = [];
                                            data.addAll(_homepageController
                                                .pendingReportData);
                                            await _homepageController
                                                .checkInputData(fields: data);
                                            if (_homepageController
                                                    .comissionAndmatTypeNaNSetData
                                                    .isEmpty &&
                                                _homepageController
                                                    .partyNaNSetData.isEmpty) {
                                              // !TODO: Add Data to Database
                                              // await _homepageController
                                              //     .insertData(data);
                                            } else {
                                              Get.defaultDialog(
                                                title: 'Error',
                                                middleText:
                                                    'Please check the data',
                                                textConfirm: 'Ok',
                                                confirmTextColor: Colors.white,
                                                onConfirm: () {
                                                  Get.back();
                                                },
                                              );
                                            }
                                          } else {
                                            if (_homepageController
                                                        .pendingReportData
                                                        .length <
                                                    2 &&
                                                _homepageController
                                                    .comissionAndmatTypeNaNSetData
                                                    .isEmpty &&
                                                _homepageController
                                                    .partyNaNSetData.isEmpty) {
                                              _homepageController.pickFile();
                                            } else {
                                              Get.defaultDialog(
                                                title: 'Error',
                                                middleText:
                                                    'Please check the data',
                                                textConfirm: 'Ok',
                                                confirmTextColor: Colors.white,
                                                onConfirm: () {
                                                  Get.back();
                                                },
                                              );
                                            }
                                          }
                                        } else {
                                          'Data is processing'.infoSnackbar;
                                        }

                                        //task to execute when this button is pressed
                                      }),
                                  child: Center(
                                    child: CupertinoActivityIndicator(
                                      radius: Get.height * 0.02,
                                      // color: Colors.white,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _homepageController
                                          .pendingReportData.isNotEmpty &&
                                      _homepageController
                                          .comissionAndmatTypeNaNSetData
                                          .isEmpty,
                                  child: Button(
                                      height: Get.height * 0.04,
                                      width: Get.width * 0.08,
                                      fontSize: Get.width * 0.010,
                                      text: 'Generate',
                                      onPressed: () async {
                                        print('Generate Report');
                                        // TODO: Generate Report With Data
                                        // await _homepageController
                                        //     .generateComissionReport(
                                        //         data: _homepageController
                                        //             .pendingReportData);
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //**Data Ui Part
                      _homepageController.pendingReportData.isEmpty
                          ? Container()
                          : Card(
                              margin: const EdgeInsets.all(3),
                              color: lCOLOR_ACCENT,
                              child: SizedBox(
                                width: Get.width * 2,
                                height: Get.height * 0.05,
                                child: ListView.builder(
                                    itemCount: _homepageController
                                        .pendingReportData[0].length,
                                    scrollDirection: Axis.horizontal,
                                    // shrinkWrap: true,
                                    itemBuilder: (_, subIndex) {
                                      return Container(
                                        // color: Colors.red,
                                        width: (subIndex == 3 ||
                                                subIndex == 9 ||
                                                subIndex == 10)
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
                                          child: Row(
                                            children: [
                                              Text(
                                                _homepageController
                                                    .pendingReportData[0]
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
                                              Visibility(
                                                visible: (subIndex == 3 ||
                                                        subIndex == 9 ||
                                                        subIndex == 10) &&
                                                    _homepageController
                                                        .partyNaNSetData
                                                        .isNotEmpty,
                                                child: SizedBox(
                                                  // width: Get.width * 0.03,
                                                  height: Get.height * 0.03,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      //Add Party Data According Index like Hospital,Doctor,technician
                                                      print('Add Party Data');
                                                      await _homepageController
                                                          .addAllPartyData(
                                                              fields: _homepageController
                                                                  .pendingReportData,
                                                              index: subIndex);

                                                      // print('Add Party Data');
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
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                      AdaptiveScrollbar(
                        controller: verticalScroll,
                        width: width,
                        child: SizedBox(
                          height: Get.height * 0.70,
                          width: Get.width * 2,
                          child: ListView.builder(
                            // itemCount: _homepageController.data.isEmpty ? 0 : 3,
                            itemCount:
                                _homepageController.pendingReportData.length,
                            // scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            itemBuilder: (_, index) {
                              // print(_homepageController.displayData
                              //     .contains(_homepageController.data[index][15]));
                              return Visibility(
                                visible: index != 0,
                                replacement: Container(),
                                child: Card(
                                  margin: const EdgeInsets.all(3),
                                  color: _homepageController.displayData
                                          .contains(_homepageController
                                              .pendingReportData[index][15])
                                      ? Colors.white
                                      : const Color.fromARGB(
                                          255, 228, 136, 129),
                                  child: SizedBox(
                                    width: Get.width * 2,
                                    height: Get.height * 0.04,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _homepageController
                                          .pendingReportData[index].length,
                                      itemBuilder: (_, subIndex) {
                                        return Container(
                                          width: (subIndex == 3 ||
                                                  subIndex == 9 ||
                                                  subIndex == 10)
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
                                          child: Visibility(
                                            visible: (subIndex == 3 ||
                                                    subIndex == 9 ||
                                                    subIndex == 10) &&
                                                _homepageController
                                                        .partyNaNSetData
                                                        .contains(
                                                            _homepageController
                                                                    .pendingReportData[
                                                                index][15]) ==
                                                    true,
                                            replacement: Visibility(
                                              visible: subIndex == 7 &&
                                                  _homepageController
                                                          .comissionAndmatTypeNaNSetData
                                                          .contains(
                                                              _homepageController
                                                                      .pendingReportData[
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
                                                                .pendingReportData[
                                                                    index]
                                                                    [subIndex]
                                                                .toString()))
                                                        .toString()
                                                    : _homepageController
                                                        .pendingReportData[
                                                            index][subIndex]
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ),
                                                textAlign: _homepageController
                                                        .rightalign
                                                        .contains(subIndex)
                                                    ? TextAlign.right
                                                    : TextAlign.left,
                                                minFontSize: 10,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: Get.width * 0.05,
                                                    child: AutoSizeText(
                                                      _homepageController
                                                          .pendingReportData[
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
                                                  SizedBox(
                                                    width: Get.width * 0.03,
                                                    height: Get.height * 0.03,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        print(
                                                            'new material Type');
                                                        String btnText =
                                                            'Add New Comission';
                                                        var hospital =
                                                            _homepageController
                                                                    .pendingReportData[
                                                                index][3];
                                                        var doctor =
                                                            _homepageController
                                                                    .pendingReportData[
                                                                index][9];
                                                        var technician =
                                                            _homepageController
                                                                    .pendingReportData[
                                                                index][10];
                                                        print(hospital +
                                                            "-" +
                                                            doctor +
                                                            "-" +
                                                            technician);
                                                        print(
                                                            _homepageController
                                                                .partyList);
                                                        print(_homepageController
                                                            .partyList!
                                                            .firstWhere((element) =>
                                                                element.name
                                                                    .contains(
                                                                        hospital))
                                                            .name);
                                                        var hospitalParty =
                                                            _homepageController
                                                                .partyList!
                                                                .firstWhere((element) =>
                                                                    element.name
                                                                        .contains(
                                                                            hospital));
                                                        var docotrParty =
                                                            _homepageController
                                                                .partyList!
                                                                .firstWhere((element) =>
                                                                    element.name
                                                                        .contains(
                                                                            doctor));

                                                        var technicianParty =
                                                            _homepageController
                                                                .partyList!
                                                                .firstWhere((element) =>
                                                                    element.name
                                                                        .contains(
                                                                            technician));
                                                        var itemAmount =
                                                            _homepageController
                                                                    .pendingReportData[
                                                                index][12];

                                                        print(hospitalParty);

                                                        Get.bottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          ignoreSafeArea: false,
                                                          PartyComissionBottomSheet(
                                                            itemAmount:
                                                                itemAmount,
                                                            comissionPercentage:
                                                                '',
                                                            doctorParty:
                                                                docotrParty,
                                                            technicianParty:
                                                                technicianParty,
                                                            hospitalParty:
                                                                hospitalParty,
                                                            btnText: btnText,
                                                            isShowAddMt: true,
                                                            materialType:
                                                                TextEditingController(
                                                                    text:
                                                                        "${_homepageController.pendingReportData[index][7]}~${_homepageController.pendingReportData[index][6]}"),
                                                            homepageController:
                                                                _homepageController,
                                                          ),
                                                        );
                                                      },
                                                      child: const AutoSizeText(
                                                          "Add",
                                                          // style: TextStyle(
                                                          //   fontSize: 15,
                                                          // ),
                                                          minFontSize: 10,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            child: SizedBox(
                                              width: Get.width * 0.15,
                                              child: AutoSizeText(
                                                _homepageController
                                                    .pendingReportData[index]
                                                        [subIndex]
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                                minFontSize: 10,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
