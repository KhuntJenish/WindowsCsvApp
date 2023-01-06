import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/homepage/generatedReport.dart';
import '../screen/homepage/homecontroller.dart';
import '../screen/homepage/partyLedger.dart';
import '../screen/homepage/ImportReport.dart';
import '../theam/theam_constants.dart';

// spacing constants For Vertical and Horizontal Layout
addVerticaleSpace(double i) {
  return SizedBox(
    height: i,
  );
}

addHorizontalSpace(double i) {
  return SizedBox(
    height: i,
  );
}


class BottomAppBar extends StatelessWidget {
  final HomepageController _homepageController = Get.put(HomepageController());

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Get.toNamed(ImportReport.routeName);
            },
          ),
          ReportLabel(
            index: 2,
            text: 'Generated Report',
            icon: Icon(Icons.auto_graph),
            onTap: () {
              _homepageController.isSelectedReport.value = 2;
              Get.toNamed(GeneratedReport.routeName);
            },
          ),
          ReportLabel(
            index: 3,
            text: 'Party Payment',
            icon: Icon(Icons.payment),
            onTap: () {
              _homepageController.isSelectedReport.value = 3;
              // Get.toNamed(GeneratedReport.routeName);
            },
          ),
          ReportLabel(
            index: 4,
            text: 'Party Ledger',
            icon: Icon(Icons.receipt_long),
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
  HomepageController _homepageController = Get.put(HomepageController());

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
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
              style: _textTheme.bodyText1?.copyWith(
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
    required this.height,
    required this.width,
    required this.fontSize,
    required this.text,
    required this.onPressed,
  });

  double height; //
  double width; //
  double fontSize; //
  String text;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            primary: Colors.transparent,
            onSurface: Colors.transparent,
            shadowColor: Colors.transparent,
            //make color or elevated button transparent
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: _textTheme.headline6?.copyWith(
              color: Get.isDarkMode ? Colors.black : Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
