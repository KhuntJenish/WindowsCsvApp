import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/screen/loginpage/logincontroller.dart';
import 'package:csvapp/screen/loginpage/loginpage.dart';
import 'package:csvapp/screen/partyMaster/partyMaster.dart';
import 'package:csvapp/screen/users/user.dart';
import 'package:csvapp/utils/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import 'theam/theam_constants.dart';

class Dashboard extends StatelessWidget {
  static const routeName = '/dashboard';

  final HomepageController _homepageController = Get.put(HomepageController());

  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    //
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontSize: Get.height * 0.03,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // _homepageController.isSelectedReport.value = 0;
            // GetStorage('box').write('isSelectedReport', 0);
            Get.toNamed(PartyMasterPage.routeName);
          },
          icon: const Icon(Icons.home),
        ),
        centerTitle: true,
        bottom: bottomAppBar(homepageController: _homepageController),
        actions: [
          IconButton(
            tooltip: 'User',
            onPressed: () {
              Get.toNamed(Userspage.routeName);
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            tooltip: 'LogOut',
            onPressed: () {
              GetStorage('box').erase();

              Get.offAllNamed(Login.routeName);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Get.height * 0.2),
              SizedBox(
                height: Get.height * 0.5,
                width: Get.width * 0.5,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Lottie.asset('assets/lottie/dashboard.json'),
                  // Lottie.network(
                  //     'https://assets1.lottiefiles.com/packages/lf20_mKMcjgVTY6.json'),
                ),
              ),
              SizedBox(height: Get.height * 0.13),
              Container(
                child: Text(
                  'Comission System App @${DateTime.now().year}.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                    fontSize: Get.height * 0.012,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.black26),
        child: FloatingActionButton(
          onPressed: () {
            LoginController loginController = Get.put(LoginController());
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
    );
  }

  Padding infoItem(TextTheme textTheme, String title, String info) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width * 0.1,
            child: Text(
              '$title: ',
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.black,
                fontSize: Get.height * 0.018,
              ),
            ),
          ),
          SizedBox(
            width: Get.width * 0.2,
            child: Text(
              info.toString(),
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
                fontSize: Get.height * 0.018,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
