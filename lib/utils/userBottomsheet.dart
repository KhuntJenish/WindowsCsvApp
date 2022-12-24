import 'package:csvapp/screen/users/userController.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theam/theam_constants.dart';
import 'helper_widget.dart';

class UserBottomsheet extends StatelessWidget {
  UserBottomsheet({
    Key? key,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.btnText,
    this.id,
  }) : super(key: key);

  final TextEditingController username;
  // final TextTheme _textTheme;
  final TextEditingController password;
  final TextEditingController email;
  final TextEditingController phone;
  // final UserController _userController;
  final String btnText;
  final int? id;
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.grey[100],
      // width:  Get.width * 0.5 ,
      // height: Get.height * 0.8,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(btnText.toString(),
                  style: GoogleFonts.padauk(
                    fontSize: Get.width * 0.04,
                  )),
              addVerticaleSpace(Get.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.25),
                child: TextField(
                  readOnly: username.text == 'admin' ? true : false,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  controller: username,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Enter Username',
                    counterText: '',
                    hintStyle: _textTheme.headline6?.copyWith(
                      color: Colors.grey,
                      fontSize: Get.height * 0.02,
                    ),
                  ),
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Obx(
                () => Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.height * 0.25),
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 10,
                    controller: password,
                     obscureText: !_userController.isPwdVisible.value,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _userController.isPwdVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          _userController.isPwdVisible.value =
                              !_userController.isPwdVisible.value;
                        },
                      ),
                      prefixIcon: const Icon(Icons.password),
                      hintText: 'Enter password',
                      counterText: '',
                      hintStyle: _textTheme.headline6?.copyWith(
                        color: Colors.grey,
                        fontSize: Get.height * 0.02,
                      ),
                    ),
                  ),
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.25),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 30,
                  controller: email,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Enter Email',
                    counterText: '',
                    hintStyle: _textTheme.headline6?.copyWith(
                      color: Colors.grey,
                      fontSize: Get.height * 0.02,
                    ),
                  ),
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.25),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: phone,
                  inputFormatters: <TextInputFormatter>[
                    // for below version 2 use this
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // for version 2 and greater youcan also use this
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    hintText: 'Enter Phone number',
                    counterText: '',
                    hintStyle: _textTheme.headline6?.copyWith(
                      color: Colors.grey,
                      fontSize: Get.height * 0.02,
                    ),
                  ),
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: Get.width * 0.5,
                height: Get.height * 0.06,
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
                            color: Color.fromRGBO(
                                0, 0, 0, 0.57), //shadow for button
                            blurRadius: 5) //blur radius of shadow
                      ]),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                      //make color or elevated button transparent
                    ),
                    child: Text(
                      'submit',
                      style: _textTheme.headline6?.copyWith(
                        color: Get.isDarkMode ? Colors.black : Colors.white,
                        fontSize: Get.width * 0.015,
                      ),
                    ),
                    onPressed: () {
                      if (username.text.isNotEmpty ||
                          password.text.isNotEmpty ) {
                        if (id != null && id! >= 1) {
                          if (btnText == 'Forget Password' &&
                              phone.text.isNotEmpty &&
                              email.text.isNotEmpty) {
                            _userController.forgetPassword(
                                id: id!,
                                username: username.text,
                                password: password.text,
                                mail: email.text,
                                phone: int.parse(phone.text));
                          } else if (btnText == 'Update User') {
                            _userController.updateUser(
                                id: id!,
                                username: username.text,
                                password: password.text,
                                mail: email.text,
                                phone: int.parse(phone.text));
                          } else {
                            Get.back();
                            'Fill Require Feild'.infoSnackbar;
                          }
                        } else {
                          _userController.createUser(
                              username: username.text,
                              password: password.text,
                              mail: email.text,
                              phone:
                                  phone.text != '' ? int.parse(phone.text) : 0);
                        }
                      } else {
                        Get.back();
                        'Data not Valid.'.errorSnackbar;
                      }
                      // Get.offAllNamed(Homepage.routeName);
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: Get.height * 0.01,
              left: Get.width * 0.01,
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back))),
        ],
      ),
    );
  }
}
