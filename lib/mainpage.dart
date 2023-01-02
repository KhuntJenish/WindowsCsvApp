import 'package:csvapp/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/userBottomsheet.dart';

class Mainpage extends StatelessWidget {
  static const routeName = '/mainPage';
  const Mainpage({super.key});

  @override
  Widget build(BuildContext context) {
     TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mainpage',
          style: _textTheme.bodyText1?.copyWith(
            color: Colors.white,
            fontSize: Get.height * 0.03,
          ),
        ),
        centerTitle: true,
      ),
      drawer: drawer(),
    );
  }
}
