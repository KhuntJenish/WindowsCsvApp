import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../theam/theam_constants.dart';

TextTheme textTheme = Get.textTheme;

extension PaddingExtension on Widget {
  Widget get horizontal15 => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: this,
      );

  Widget get horizontal20 => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: this,
      );
  Widget get all10 => Padding(
        padding: const EdgeInsets.all(10),
        child: this,
      );
}

extension BuildContextExtension on String {
  dynamic get errorSnackbar => Get
    ..closeAllSnackbars()
    ..rawSnackbar(
      message: this,
      backgroundColor: Colors.red,
    );

  dynamic get successSnackbar => Get
    ..closeAllSnackbars()
    ..rawSnackbar(
      message: this,
      backgroundColor: Colors.green,
    );

  dynamic get infoSnackbar => Get
    ..closeAllSnackbars()
    ..rawSnackbar(
      message: this,
      backgroundColor: lCOLOR_PRIMARY,
    );

  dynamic get successDailog => Get.defaultDialog(
        content: Container(
          height: Get.height * 0.3,
          width: Get.width * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: Get.height * 0.15,
                width: Get.width * 0.15,
                // color: Colors.red,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Lottie.asset('assets/lottie/success.json'),

                  // Lottie.network(
                  //     'https://assets5.lottiefiles.com/packages/lf20_xwmj0hsk.json'),
                ),
              ),
              Container(
                child: Text(
                  this,
                  style: textTheme.bodyText1?.copyWith(
                    color: Colors.black,
                    fontSize: Get.height * 0.03,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
