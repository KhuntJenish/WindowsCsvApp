import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/dashboard.dart';
import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/constant.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../theam/theam_constants.dart';
import '../../utils/dropDownItem.dart';
import '../../utils/helper_widget.dart';
import '../../utils/partyComissionBottomsheet.dart';

class ImportReport extends StatelessWidget {
  static const routeName = '/importReport';
  final HomepageController _homepageController = Get.put(HomepageController());
  // final HomepageController _homepageController = Get.find<HomepageController>();

  ImportReport({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final ScrollController horizontalScroll = ScrollController();
    final ScrollController verticalScroll = ScrollController();
    const double width = 20;
    //
    return WillPopScope(
      onWillPop: () async {
        _homepageController.isSelectedReport.value = 0;

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              'Import Report',
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
                                          style: textTheme.bodyLarge?.copyWith(
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
                                        _homepageController.defaultParty,
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
                                          style: textTheme.bodyLarge?.copyWith(
                                            fontSize: Get.height * 0.015,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              _homepageController
                                                  .dateRange.value.start),
                                          style: textTheme.bodyLarge?.copyWith(
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
                                          style: textTheme.bodyLarge?.copyWith(
                                            fontSize: Get.height * 0.015,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd-MM-yyyy').format(
                                              _homepageController
                                                  .dateRange.value.end),
                                          style: textTheme.bodyLarge?.copyWith(
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: Get.height * 0.04,
                              width: Get.width * 0.08,
                              fontSize: Get.width * 0.010,
                              text: 'Search',
                              onPressed: () async {
                                if (_homepageController.defaultParty.value.id ==
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
                                              .defaultParty.value,
                                          isAllPartySelected:
                                              _homepageController
                                                  .isAllPartySelected.value);
                                }
                                // Get.offAllNamed(Homepage.routeName);
                              },
                            ),
                            Button(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              height: Get.height * 0.04,
                              width: Get.width * 0.08,
                              fontSize: Get.width * 0.010,
                              text: 'Reset',
                              onPressed: () async {
                                if (_homepageController
                                    .pendingReportData.isNotEmpty) {
                                  _homepageController.pendingReportData.clear();
                                  _homepageController
                                      .comissionAndmatTypeNaNSetData
                                      .clear();
                                  _homepageController.partyNaNSetData.clear();
                                  _homepageController.displayData.clear();
                                  _homepageController.isLoading.value = false;
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                                              await _homepageController
                                                  .insertData(data);
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: Get.height * 0.04,
                                      width: Get.width * 0.08,
                                      fontSize: Get.width * 0.010,
                                      text: 'Generate',
                                      onPressed: () async {
                                        // TODO: Generate Report With Data
                                        await _homepageController
                                            .generateComissionReport(
                                                data: _homepageController
                                                    .pendingReportData);
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //**Data Ui Part
                      _homepageController.pendingReportData.isEmpty
                          ? Container(
                              margin: EdgeInsets.only(
                                  left: Get.width * 0.25,
                                  top: Get.width * 0.05),
                              height: Get.height * 0.5,
                              width: Get.width * 0.5,
                              // color: Colors.red,
                              child: Center(
                                  child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/suggestion_1.png',
                                    fit: BoxFit.cover,
                                  ),
                                  // const Text('Empty Report'),
                                ],
                              )),
                            )
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
                                        width: (subIndex ==
                                                    Constantdata
                                                        .customerIndex ||
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
                                                visible: (subIndex ==
                                                            Constantdata
                                                                .customerIndex ||
                                                        subIndex ==
                                                            Constantdata
                                                                .doctorNameIndex ||
                                                        subIndex ==
                                                            Constantdata
                                                                .technicianStaffIndex) &&
                                                    _homepageController
                                                        .partyNaNSetData
                                                        .isNotEmpty,
                                                child: SizedBox(
                                                  // width: Get.width * 0.03,
                                                  height: Get.height * 0.035,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      //Add Party Data According Index like Hospital,Doctor,technician

                                                      await _homepageController
                                                          .addAllPartyData(
                                                              fields: _homepageController
                                                                  .pendingReportData,
                                                              index: subIndex);

                                                      //
                                                    },
                                                    child: const AutoSizeText(
                                                        "Add",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                        minFontSize: 7,
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
                              //
                              //     .contains(_homepageController.data[index][15]));
                              return Visibility(
                                visible: index != 0,
                                replacement: Container(),
                                child: Card(
                                  margin: const EdgeInsets.all(3),
                                  color: _homepageController.displayData
                                          .contains(_homepageController
                                                  .pendingReportData[index]
                                              [Constantdata.dataNoIndex])
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
                                          width: (subIndex ==
                                                      Constantdata
                                                          .customerIndex ||
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Visibility(
                                            visible: (subIndex == Constantdata.customerIndex ||
                                                    subIndex ==
                                                        Constantdata
                                                            .doctorNameIndex ||
                                                    subIndex ==
                                                        Constantdata
                                                            .technicianStaffIndex) &&
                                                _homepageController
                                                        .partyNaNSetData
                                                        .contains(_homepageController
                                                                    .pendingReportData[
                                                                index][
                                                            Constantdata
                                                                .dataNoIndex]) ==
                                                    true,
                                            replacement: Visibility(
                                              visible: subIndex ==
                                                      Constantdata
                                                          .matTypeIndex &&
                                                  _homepageController
                                                          .comissionAndmatTypeNaNSetData
                                                          .contains(_homepageController
                                                                      .pendingReportData[
                                                                  index][
                                                              Constantdata
                                                                  .dataNoIndex]) ==
                                                      true,
                                              replacement: AutoSizeText(
                                                (subIndex ==
                                                            Constantdata
                                                                .smtDocDateIndex ||
                                                        subIndex ==
                                                            Constantdata
                                                                .distDocDateIndex)
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
                                                    : _homepageController
                                                            .centeralign
                                                            .contains(subIndex)
                                                        ? TextAlign.center
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
                                                        String btnText =
                                                            'Add New Comission';
                                                        var hospital =
                                                            _homepageController
                                                                        .pendingReportData[
                                                                    index][
                                                                Constantdata
                                                                    .customerIndex];
                                                        var doctor = _homepageController
                                                                    .pendingReportData[
                                                                index][
                                                            Constantdata
                                                                .doctorNameIndex];
                                                        var technician =
                                                            _homepageController
                                                                        .pendingReportData[
                                                                    index][
                                                                Constantdata
                                                                    .technicianStaffIndex];

                                                        //
                                                        //     _homepageController
                                                        //         .partyList);
                                                        //
                                                        //         .pendingReportData[
                                                        //     index][10]);
                                                        //
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
                                                        PartyMasterData
                                                            technicianParty =
                                                            _homepageController
                                                                .partyList!
                                                                .firstWhere((element) =>
                                                                    element.name
                                                                        .contains(
                                                                            technician));
                                                        if (technician != "") {
                                                          technicianParty =
                                                              _homepageController
                                                                  .partyList!
                                                                  .firstWhere((element) => element
                                                                      .name
                                                                      .contains(
                                                                          technician));
                                                        }
                                                        var itemAmount = double.parse(
                                                            _homepageController
                                                                .pendingReportData[
                                                                    index][
                                                                    Constantdata
                                                                        .totalSalesIndex]
                                                                .toString());
                                                        var materialType =
                                                            "${_homepageController.pendingReportData[index][Constantdata.matTypeIndex]}~${_homepageController.pendingReportData[index][Constantdata.matNameIndex]}";
                                                        var isShowAddMt =
                                                            await _homepageController
                                                                .checkMaterialType(
                                                                    materialType);

                                                        //

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
                                                                doctor != ""
                                                                    ? docotrParty
                                                                    : null,
                                                            technicianParty:
                                                                technician != ""
                                                                    ? technicianParty
                                                                    : null,
                                                            hospitalParty:
                                                                hospital != ""
                                                                    ? hospitalParty
                                                                    : null,
                                                            btnText: btnText,
                                                            isShowAddMt:
                                                                isShowAddMt.obs,
                                                            materialType:
                                                                TextEditingController(
                                                                    text:
                                                                        materialType),
                                                            homepageController:
                                                                _homepageController,
                                                            isShowTechnician:
                                                                technician != ""
                                                                    ? true
                                                                    : false,
                                                            isShowHospital:
                                                                hospital != ""
                                                                    ? true
                                                                    : false,
                                                            isShowDoctor:
                                                                doctor != ""
                                                                    ? true
                                                                    : false,
                                                          ),
                                                        );
                                                      },
                                                      child: const AutoSizeText(
                                                          "Add",
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
