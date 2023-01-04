import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theam/theam_constants.dart';

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
}
