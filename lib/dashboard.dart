import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/screen/loginpage/loginpage.dart';
import 'package:csvapp/screen/partyMaster/partyMaster.dart';
import 'package:csvapp/screen/users/user.dart';
import 'package:csvapp/utils/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Dashboard extends StatelessWidget {
  static const routeName = '/dashboard';

  final HomepageController _homepageController = Get.put(HomepageController());

  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    // print(_homepageController.isSelectedReport.value);
    return Scaffold(
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
      // drawer: DrawerWidget(),
    );
  }
}
