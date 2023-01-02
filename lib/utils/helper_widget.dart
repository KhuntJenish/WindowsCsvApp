import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
