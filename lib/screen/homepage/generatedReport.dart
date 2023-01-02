import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/helper_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../theam/theam_constants.dart';
import '../../utils/dropDownItem.dart';
import '../../utils/partyComissionBottomsheet.dart';
import '../../utils/partyMasterBottomsheet.dart';

class GeneratedReport extends StatelessWidget {
  static const routeName = '/generatedReport';
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
          'Homepage',
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
                    //**Search Ui Part
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
                                  defualtValue:
                                      _homepageController.defualtParty,
                                  itemList: _homepageController.partyList,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.20,
                            child: Container(
                              // color: Colors.amber,
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
                              await _homepageController.getSearchData(
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
                    _homepageController.pendingReportData.isEmpty
                        ? Container()
                        : Card(
                            margin: const EdgeInsets.all(3),
                            color: Colors.amber,
                            child: SizedBox(
                              width: Get.width * 1.5,
                              height: Get.height * 0.05,
                              child: ListView.builder(
                                  itemCount: _homepageController
                                      .pendingReportData[0].length,
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
                                        _homepageController.pendingReportData[0]
                                                [subIndex]
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
                    Container(
                      height: Get.height * 0.78,
                      width: Get.width * 1.5,
                      child: ListView.builder(
                        // itemCount: _homepageController.data.isEmpty ? 0 : 3,
                        itemCount: _homepageController.pendingReportData.length,
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
                              color: _homepageController.displayData.contains(
                                      _homepageController
                                          .pendingReportData[index][15])
                                  ? Colors.white
                                  : Color.fromARGB(255, 228, 136, 129),
                              child: Container(
                                width: Get.width * 1.5,
                                height: Get.height * 0.04,
                                child: AnimationLimiter(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,

                                    itemCount: _homepageController
                                        .pendingReportData[index].length,
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
                                        duration:
                                            const Duration(milliseconds: 375),
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
                                                  const EdgeInsets.all(8.0),
                                              child: Visibility(
                                                visible: subIndex == 3 &&
                                                    _homepageController
                                                            .partyNaNSetData
                                                            .contains(_homepageController
                                                                    .pendingReportData[
                                                                index][15]) ==
                                                        true,
                                                replacement: Visibility(
                                                  visible: subIndex == 7 &&
                                                      _homepageController
                                                              .comissionAndmatTypeNaNSetData
                                                              .contains(_homepageController
                                                                      .pendingReportData[
                                                                  index][15]) ==
                                                          true,
                                                  replacement: AutoSizeText(
                                                    (index != 0 &&
                                                            (subIndex == 1 ||
                                                                subIndex == 13))
                                                        ? DateFormat(
                                                                "dd-MM-yyyy")
                                                            .format(DateFormat(
                                                                    "dd.MM.yyyy")
                                                                .parse(_homepageController
                                                                    .pendingReportData[
                                                                        index][
                                                                        subIndex]
                                                                    .toString()))
                                                            .toString()
                                                        : _homepageController
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
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: Get.width * 0.06,
                                                        child: AutoSizeText(
                                                          _homepageController
                                                              .pendingReportData[
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
                                                      ),
                                                      Container(
                                                        width: Get.width * 0.03,
                                                        height:
                                                            Get.height * 0.03,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            print(
                                                                'new material Type');
                                                            String btnText =
                                                                'Add New Comission';
                                                            print(_homepageController
                                                                    .pendingReportData[
                                                                index][3]);
                                                            var party = await (_homepageController
                                                                    .db
                                                                    .select(_homepageController
                                                                        .db
                                                                        .partyMaster)
                                                                  ..where((tbl) => tbl
                                                                      .name
                                                                      .equals(_homepageController
                                                                              .pendingReportData[index]
                                                                          [3])))
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
                                                                btnText:
                                                                    btnText,
                                                                isShow: true,
                                                                materialType: TextEditingController(
                                                                    text: _homepageController
                                                                            .pendingReportData[
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
                                                            .pendingReportData[
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
                                                        onPressed: () {
                                                          print(
                                                              'new customer add');
                                                          TextEditingController
                                                              name =
                                                              TextEditingController(
                                                                  text: _homepageController
                                                                      .pendingReportData[
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // drawer: drawer(),
    );
  }
}
