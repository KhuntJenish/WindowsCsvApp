import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screen/homepage/ImportReport.dart';
import '../screen/homepage/generatedReport.dart';
import '../screen/homepage/homecontroller.dart';
import '../screen/homepage/partyLedger.dart';
import '../screen/homepage/partyPayment.dart';
import '../theam/theam_constants.dart';

// spacing constants For Vertical and Horizontal Layout
addVerticaleSpace(double i) {
  return SizedBox(
    height: i,
  );
}

addHorizontalSpace(double i) {
  return SizedBox(
    width: i,
  );
}

class BottomAppBar extends StatelessWidget {
  final HomepageController _homepageController = Get.put(HomepageController());

  BottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ReportLabel(
            index: 1,
            text: 'Import Report',
            icon: const Icon(Icons.insert_chart),
            onTap: () {
              _homepageController.isSelectedReport.value = 1;
              Get.toNamed(ImportReport.routeName);
            },
          ),
          ReportLabel(
            index: 2,
            text: 'Generated Report',
            icon: const Icon(Icons.auto_graph),
            onTap: () {
              _homepageController.isSelectedReport.value = 2;
              Get.toNamed(GeneratedReport.routeName);
            },
          ),
          ReportLabel(
            index: 3,
            text: 'Party Payment',
            icon: const Icon(Icons.payment),
            onTap: () {
              _homepageController.isSelectedReport.value = 3;
              // Get.toNamed(GeneratedReport.routeName);
            },
          ),
          ReportLabel(
            index: 4,
            text: 'Party Ledger',
            icon: const Icon(Icons.receipt_long),
            onTap: () {
              _homepageController.isSelectedReport.value = 4;
              Get.toNamed(PartyLedger.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class ReportLabel extends StatelessWidget {
  ReportLabel({
    super.key,
    required this.icon,
    required this.text,
    required this.index,
    required this.onTap,
  });

  //  HomepageController _homepageController;
  Icon icon;
  String text;
  int index;
  Function()? onTap;
  final HomepageController _homepageController = Get.put(HomepageController());

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Obx(
      () => GestureDetector(
        onTap: onTap,
        //  () {
        //   _homepageController.isSelectedReport.value = 1;
        //   Get.toNamed(PendingReport.routeName);
        // },
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Get.width * 0.005, vertical: Get.width * 0.005),
          // padding: EdgeInsets.all(Get.width * 0.01),
          decoration: BoxDecoration(
            color: _homepageController.isSelectedReport.value == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 200,

          child: ListTile(
            leading: icon, // Icon(Icons.insert_chart),
            title: Text(
              text, //'Import Report',
              style: textTheme.bodyLarge?.copyWith(
                color: lCOLOR_PRIMARY,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  Button({
    super.key,
    required this.height,
    required this.width,
    required this.fontSize,
    required this.text,
    required this.onPressed,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
  });

  double height; //
  double width; //
  double fontSize; //
  String text;
  EdgeInsetsGeometry? margin;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: margin,
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
                colors: Get.isDarkMode
                    ? [dCOLOR_PRIMARY, dCOLOR_ACCENT]
                    : [
                        lCOLOR_PRIMARY,
                        lCOLOR_ACCENT,
                      ]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                  blurRadius: 5) //blur radius of shadow
            ]),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.transparent.withOpacity(0.38),
            disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
            shadowColor: Colors.transparent,
            //make color or elevated button transparent
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: textTheme.titleLarge?.copyWith(
              color: Get.isDarkMode ? Colors.black : Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSize bottomAppBar({HomepageController? homepageController}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(Get.height * 0.07),
    child: Column(
      children: [
        SizedBox(
          width: Get.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ReportLabel(
                  index: 1,
                  text: 'Import Report',
                  icon: const Icon(Icons.insert_chart),
                  onTap: () {
                    if (homepageController?.isSelectedReport.value != 1) {
                      homepageController?.isSelectedReport.value = 1;
                      GetStorage('box').write('isSelectedReport', 1);
                      Get.offAndToNamed(ImportReport.routeName);
                    }
                  },
                ),
                ReportLabel(
                  index: 2,
                  text: 'Generated Report',
                  icon: const Icon(Icons.auto_graph),
                  onTap: () {
                    if (homepageController?.isSelectedReport.value != 2) {
                      homepageController?.generatedReportData.clear();
                      homepageController?.isSelectedReport.value = 2;
                      GetStorage('box').write('isSelectedReport', 2);
                      Get.offAndToNamed(GeneratedReport.routeName);
                    }
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    // });
                  },
                ),
                ReportLabel(
                  index: 3,
                  text: 'Party Payment',
                  icon: const Icon(Icons.payment),
                  onTap: () {
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    // });
                    if (homepageController?.isSelectedReport.value != 3) {
                      homepageController?.generatedReportData.clear();
                      homepageController?.isSelectedReport.value = 3;
                      GetStorage('box').write('isSelectedReport', 3);
                      Get.offAndToNamed(PartyPayment.routeName);
                    }
                  },
                ),
                ReportLabel(
                  index: 4,
                  text: 'Party Ledger',
                  icon: const Icon(Icons.receipt_long),
                  onTap: () {
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    // });
                    if (homepageController?.isSelectedReport.value != 4) {
                      GetStorage('box').write('isSelectedReport', 4);
                      homepageController?.isSelectedReport.value = 4;
                      Get.offAndToNamed(PartyLedger.routeName);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible:
              homepageController?.isSelectedReport.value == 3 ? true : false,
          child: const TabBar(
            tabs: [
              Tab(text: 'Hospital'),
              Tab(text: 'Doctor'),
              Tab(text: 'Technician Staff'),
            ],
          ),
        ),
      ],
    ),
  );
}

class LableWithCheckbox extends StatelessWidget {
  const LableWithCheckbox(
      {super.key,
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
    print('checkbox : $isCheckBoxVisible');
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: Get.width * 0.20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: AutoSizeText(
              lable,
              style: textTheme.bodyLarge?.copyWith(
                fontSize: Get.height * 0.015,
              ),
              maxLines: 1,
            ),
          ),
          Visibility(
            visible: isCheckBoxVisible == true ? true : false,
            // replacement: Container(),
            child: Checkbox(
              value: checkBoxValue ?? false,
              onChanged: checkBoxOnchange,
            ),
          ),
        ],
      ),
    );
  }
}
