import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/utils/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

class Homepage extends StatelessWidget {
  ScrollController _scrollControllerH = ScrollController();
  ScrollController _scrollControllerV = ScrollController();
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
        () => Column(
          children: [
            _homepageController.data.isEmpty
                ? Container()
                : Scrollbar(
                  child: SingleChildScrollView(
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        primary: true,
                        scrollDirection: Axis.horizontal,
                        child: Card(
                            margin: const EdgeInsets.all(3),
                            color: Colors.amber,
                            child: SizedBox(
                              width: Get.width * 1.5,
                              height: Get.height * 0.05,
                              child: ListView.builder(
                                  itemCount: _homepageController.data[0].length,
                                  scrollDirection: Axis.horizontal,
                                  // shrinkWrap: true,
                                  itemBuilder: (_, subIndex) {
                                    return Container(
                                      width: subIndex == 3
                                          ? Get.width * 0.2
                                          : (subIndex == 6 || subIndex == 9)
                                              ? Get.width * 0.1
                                              : Get.width * 0.06,
                                      // height: Get.height * 0.05,
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(
                                        _homepageController.data[0][subIndex]
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
                      ),
                    ),
                  ),
                ),
            Container(
              // height: Get.height * 0.88,
              // width: Get.width *.7,
              // color: Color.fromRGBO(244, 67, 54, 1),
              child: SingleChildScrollView(
                primary: true,
              scrollDirection: Axis.horizontal,
                child: Container(
                  height: Get.height * 0.88,
                  width: Get.width * 1.5,
                  child: ListView.builder(
                    itemCount: _homepageController.data.isEmpty ? 0 : 30,
                    // itemCount: _homepageController.data.length,
                    // scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return Card(
                        margin: const EdgeInsets.all(3),
                        color: Colors.white,
                        child: Visibility(
                          visible: index != 0,
                          replacement: Container(),
                          child: Container(
                            width: Get.width * 1.5,
                            height: Get.height * 0.04,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _homepageController.data[index].length,
                              // shrinkWrap: true,
                              itemBuilder: (_, subIndex) {
                                DateTime tempDate = DateFormat("dd.MM.yyyy").parse(
                                    _homepageController.data[index][1].toString());
                            
                                // tempDate = DateFormat("dd-MM-yyyy").format(tempDate);
                                print(DateFormat("dd-MM-yyyy").format(tempDate));
                                return Container(
                                  width: subIndex == 3
                                      ? Get.width * 0.2
                                      : (subIndex == 6 || subIndex == 9)
                                          ? Get.width * 0.1
                                          : Get.width * 0.06,
                                  // height: Get.height * 0.05,
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    (index != 0 &&
                                            (subIndex == 1 || subIndex == 11))
                                        ? DateFormat("dd-MM-yyyy")
                                            .format(tempDate)
                                            .toString()
                                        : _homepageController.data[index][subIndex]
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: index == 0 ? 18 : 15,
                                        fontWeight: index == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color:
                                            index == 0 ? Colors.red : Colors.black),
                                    minFontSize: 10,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
            ),
          ],
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
