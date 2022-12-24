import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
      body: Obx(
        () => Container(
          child: ListView.builder(
            itemCount: _homepageController.data.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              DateTime tempDate = index != 0
                  ? DateFormat("dd.MM.yyyy")
                      .parse(_homepageController.data[index][1].toString())
                  : DateTime.now();
              // tempDate = DateFormat("dd-MM-yyyy").format(tempDate);
              print(DateFormat("dd-MM-yyyy").format(tempDate));
              return Card(
                margin: const EdgeInsets.all(3),
                color: index == 0 ? Colors.amber : Colors.white,
                child: ListTile(
                  leading: Text(
                    _homepageController.data[index][0].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: index == 0 ? 18 : 15,
                        fontWeight:
                            index == 0 ? FontWeight.bold : FontWeight.normal,
                        color: index == 0 ? Colors.red : Colors.black),
                  ),
                  title: Text(
                    _homepageController.data[index][3],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: index == 0 ? 18 : 15,
                        fontWeight:
                            index == 0 ? FontWeight.bold : FontWeight.normal,
                        color: index == 0 ? Colors.red : Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _homepageController.data[index][9].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: index == 0 ? 18 : 15,
                            fontWeight: index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: index == 0 ? Colors.red : Colors.black),
                      ),
                      const SizedBox(width: 50),
                      Text(
                        DateFormat("dd-MM-yyyy").format(tempDate).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: index == 0 ? 18 : 15,
                            fontWeight: index == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: index == 0 ? Colors.red : Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add), //child widget inside this button
        onPressed: () {
          print("Button is pressed.");
          _homepageController.pickFile();
          //task to execute when this button is pressed
        },
      ),
      drawer: drawer(),
    );
  }
}
