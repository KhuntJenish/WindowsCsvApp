import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theam/theam_constants.dart';
import '../../utils/userBottomsheet.dart';
import '../../utils/helper_widget.dart';
import 'logincontroller.dart';

class Login extends StatelessWidget {
  static const routeName = '/login';

  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
    TextTheme textTheme = Theme.of(context).textTheme;
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.center,
          colors: [
            Get.isDarkMode ? Colors.grey : lCOLOR_PRIMARY,
            Get.isDarkMode ? Colors.black : Colors.white,
            // Color(0xFFD8E1EF),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height * 1,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                addVerticaleSpace(Get.height * 0.01),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: Get.isDarkMode
                            ? [dCOLOR_PRIMARY, dCOLOR_ACCENT]
                            : [
                                lCOLOR_PRIMARY,
                                lCOLOR_ACCENT,
                              ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    maxRadius: Get.width * 0.08,
                    child: CircleAvatar(
                      maxRadius: Get.width * 0.078,
                      backgroundImage: const AssetImage('assets/images/h1.png'),
                    ),
                  ),
                ),
                addVerticaleSpace(Get.height * 0.01),
                Text(
                  'Welcome',
                  style: textTheme.bodyText1?.copyWith(
                    fontSize: Get.width * 0.03,
                  ),
                ),
                addVerticaleSpace(Get.height * 0.01),
                Text(
                  '''Before enjoying Our services
Please register first''',
                  style: textTheme.headline6?.copyWith(
                    fontSize: Get.width * 0.02,
                  ),
                  textAlign: TextAlign.center,
                ),
                addVerticaleSpace(20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.25),
                  child: TextField(
                    maxLength: 30,
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      hintText: 'Enter Email or Username',
                      counterText: '',
                      hintStyle: textTheme.headline6?.copyWith(
                        color: Colors.grey,
                        fontSize: Get.height * 0.02,
                      ),
                    ),
                  ),
                ),
                addVerticaleSpace(10),
                Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.25),
                    child: TextField(
                      maxLength: 10,
                      controller: passwordController,
                      obscureText: !loginController.isPwdVisible.value,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_open),
                        hintText: 'Enter password',
                        counterText: '',
                        suffixIcon: IconButton(
                          icon: Icon(
                            loginController.isPwdVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            loginController.isPwdVisible.value =
                                !loginController.isPwdVisible.value;
                          },
                        ),
                        suffixStyle: Get.theme.textTheme.headline6,
                        hintStyle: textTheme.headline6?.copyWith(
                          color: Colors.grey,
                          fontSize: Get.height * 0.02,
                        ),
                      ),
                    ),
                  ),
                ),
                addVerticaleSpace(Get.height * 0.01),
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      isScrollControlled: true,
                      ignoreSafeArea: false,
                      UserBottomsheet(
                        id: 5,
                        btnText: 'Forget Password',
                        username: TextEditingController(text: ''),
                        password: TextEditingController(text: ''),
                        email: TextEditingController(text: ''),
                        phone: TextEditingController(text: ''),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Get.width * 0.25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forget Password?',
                          style: TextStyle(
                            color:
                                Get.isDarkMode ? Colors.white : lCOLOR_PRIMARY,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                addVerticaleSpace(Get.height * 0.02),
                Button(
                  height: Get.height * 0.06,
                  width: Get.width * 0.5,
                  fontSize: Get.width * 0.015,
                  text: 'Login',
                  onPressed: () {
                    if (usernameController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      'Enter Valid Data fields'.errorSnackbar;
                    } else {
                      loginController.login(
                          username: usernameController.text,
                          password: passwordController.text);
                    }
                    // Get.offAllNamed(Homepage.routeName);
                  },
                ),
                addVerticaleSpace(Get.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: textTheme.headline6?.copyWith(
                        fontSize: Get.height * 0.02,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        ' Register',
                        style: textTheme.headline6?.copyWith(
                          fontSize: Get.height * 0.02,
                          fontWeight: FontWeight.w700,
                          color: Get.isDarkMode ? Colors.white : lCOLOR_PRIMARY,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.black26),
          child: FloatingActionButton(
            onPressed: () {
              loginController.isDarkMode = !loginController.isDarkMode;
              Get.changeTheme(
                  loginController.isDarkMode ? darkTheme : lightTheam);
            },
            tooltip: 'Theme Change',
            child: Get.isDarkMode
                ? const Icon(Icons.light_mode_rounded)
                : const Icon(Icons.dark_mode_rounded),
          ),
        ),
      ),
    );
  }
}
