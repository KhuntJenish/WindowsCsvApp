import 'package:csvapp/screen/homepage/generatedReport.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/screen/homepage/ledgerReport.dart';
import 'package:csvapp/screen/homepage/pendingReport.dart';
import 'package:csvapp/utils/drawer.dart';
import 'package:csvapp/utils/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'theam/theam_constants.dart';
import 'utils/userBottomsheet.dart';

class Mainpage extends StatelessWidget {
  static const routeName = '/mainPage';

  HomepageController _homepageController = Get.put(HomepageController());

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    print(_homepageController.isSelectedReport.value);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
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
                    Get.toNamed(PendingReport.routeName);
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
                    Get.toNamed(LedgerReport.routeName);
                  },
                ),

                // ListTile(
                //   leading: Icon(Icons.receipt_long),
                //   title: Text(
                //     'Party Ledger',
                //     style: _textTheme.bodyText1?.copyWith(
                //       color: Colors.white,
                //       fontSize: Get.height * 0.02,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      drawer: drawer(),
    );
  }
}
