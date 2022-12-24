import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  static const routeName = '/homepage';
  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    HomepageController _homepageController = Get.put(HomepageController());

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
      body: Container(
          child: Column(
        children: [],
      )),
      floatingActionButton: SizedBox(
        height: 100,
        width: 100,
        child: FloatingActionButton(
          child: Icon(Icons.add), //child widget inside this button
          onPressed: () {
            print("Button is pressed.");
            //task to execute when this button is pressed
          },
        ),
      ),
      drawer: drawer(),
    );
  }
}
