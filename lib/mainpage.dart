import 'package:csvapp/utils/drawer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screen/homepage/homecontroller.dart';

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
          child: BottomAppBar(),
        ),
      ),
      drawer: drawer(),
    );
  }
}
