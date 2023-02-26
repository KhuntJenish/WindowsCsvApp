import 'package:csvapp/screen/users/userController.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[100],
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
                    hintStyle: textTheme.titleLarge?.copyWith(
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
                      hintStyle: textTheme.titleLarge?.copyWith(
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
                    hintStyle: textTheme.titleLarge?.copyWith(
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
                    hintStyle: textTheme.titleLarge?.copyWith(
                      color: Colors.grey,
                      fontSize: Get.height * 0.02,
                    ),
                  ),
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Button(
                height: Get.height * 0.06,
                width: Get.width * 0.5,
                fontSize: Get.width * 0.015,
                text: 'submit',
                onPressed: () {
                  if (username.text.isNotEmpty || password.text.isNotEmpty) {
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
                          phone: phone.text != '' ? int.parse(phone.text) : 0);
                    }
                  } else {
                    Get.back();
                    'Data not Valid.'.errorSnackbar;
                  }
                  // Get.offAllNamed(Homepage.routeName);
                },
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
                  icon: const Icon(Icons.arrow_back))),
        ],
      ),
    );
  }
}
