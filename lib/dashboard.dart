import 'dart:async';

import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/screen/loginpage/loginpage.dart';
import 'package:csvapp/screen/partyMaster/partyMaster.dart';
import 'package:csvapp/screen/users/user.dart';
import 'package:csvapp/utils/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class Dashboard extends StatelessWidget {
  static const routeName = '/dashboard';

  final HomepageController _homepageController = Get.put(HomepageController());

  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    // print(_homepageController.isSelectedReport.value);
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: textTheme.bodyText1?.copyWith(
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
              print('logOut');
              GetStorage('box').erase();
              print('data earased');
              print(GetStorage('box').read('user'));
              Get.offAllNamed(Login.routeName);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.2),
            Container(
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
                'Developed by Versatile IT Management @2023.',
                style: textTheme.bodyText1?.copyWith(
                  color: Colors.grey[700],
                  fontSize: Get.height * 0.012,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            content: Container(
              height: Get.height * 0.5,
              width: Get.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: Get.height * 0.15,
                    width: Get.width * 0.15,
                    // color: Colors.red,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Lottie.asset('assets/lottie/techinfo.json'),

                      // Lottie.network(
                      //     'https://assets5.lottiefiles.com/packages/lf20_xwmj0hsk.json'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      infoItem(textTheme, 'Info', 'Versatile IT Management'),
                      infoItem(textTheme, 'Web', 'www.versatileit.in'),
                      infoItem(textTheme, 'e-mail',
                          'rakesh@versatileitservices.com'),
                      infoItem(textTheme, 'Phone', '+91 70435 49040'),
                    ],
                  ),
                ],
              ),
            ),
          );
          // Phone : +91 70435 49040
          // We make software for you
          // e-mail: rakesh@versatileitservices.com
          // Web : www.versatileit.in

          Timer(Duration(seconds: 8), () {
            print('done');
            Get.back();
          });
        },
        child: const Icon(Icons.home),
      ),
      // drawer: DrawerWidget(),
    );
  }

  Padding infoItem(TextTheme textTheme, String title, String info) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Get.width * 0.1,
            child: Text(
              '$title: ',
              style: textTheme.bodyText1?.copyWith(
                color: Colors.black,
                fontSize: Get.height * 0.018,
              ),
            ),
          ),
          Container(
            width: Get.width * 0.2,
            child: Text(
              info.toString(),
              style: textTheme.bodyText1?.copyWith(
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
