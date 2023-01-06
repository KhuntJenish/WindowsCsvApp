import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/homepage/partyLedger.dart';
import 'package:csvapp/screen/homepage/ImportReport.dart';
import 'package:csvapp/screen/loginpage/loginpage.dart';
import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:csvapp/screen/partyMaster/partyMaster.dart';
import 'package:csvapp/screen/users/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screen/homepage/generatedReport.dart';
import 'userBottomsheet.dart';

class drawer extends StatelessWidget {
  drawer({
    Key? key,
  }) : super(key: key);

  final PartyController _partyController = Get.put(PartyController());
  @override
  Widget build(BuildContext context) {
    UserData currentUser = GetStorage('box').read('cuser');
    print(currentUser);
    // print(currentUser.username);
    // print(currentUser.mail);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(currentUser.username),
                  accountEmail: Text(currentUser.mail),
                  currentAccountPicture: const CircleAvatar(
                    radius: 10,
                    backgroundImage: AssetImage('assets/images/h1.png'),
                  ),
                ),
                Visibility(
                  visible: currentUser.username != 'admin',
                  child: Positioned(
                    bottom: Get.height * 0.02,
                    right: Get.width * 0.02,
                    child: IconButton(
                      onPressed: () {
                        var id = currentUser.id.toInt();
                        Get.bottomSheet(
                          isScrollControlled: true,
                          ignoreSafeArea: false,
                          UserBottomsheet(
                            id: id,
                            btnText: 'Update User',
                            username: TextEditingController(
                                text: currentUser.username),
                            password: TextEditingController(
                                text: currentUser.password),
                            email:
                                TextEditingController(text: currentUser.mail),
                            phone: TextEditingController(
                                text: currentUser.phone.toString()),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Pending Report"),
              onTap: () {
                Get.back();
                Get.toNamed(ImportReport.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Generated Report"),
              onTap: () {
                Get.back();
                Get.toNamed(GeneratedReport.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Ledger Report"),
              onTap: () {
                Get.back();
                Get.toNamed(PartyLedger.routeName);
              },
            ),
            Visibility(
              visible: currentUser.username == 'admin',
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("User"),
                onTap: () {
                  Get.back();
                  // Get.toNamed('/subuserpage');
                  Get.toNamed(Userspage.routeName);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text("PartyMaster"),
              onTap: () async {
                var partyTypeList = await _partyController.db
                    .select(_partyController.db.partyTypeMaster)
                    .get();
                print(partyTypeList);
                Get.back();
                Get.toNamed(PartyMasterPage.routeName);
              },
            ),

            // ListTile(
            //   leading: Icon(Icons.party_mode),
            //   title: Text("PartyMaster"),
            //   onTap: () {
            //     Get.toNamed(PartyMasterPage.routeName);
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                // Get.toNamed(SettingPage.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text("Contact Us"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Get.back();
                GetStorage('box').erase();
                print('data earased');
                print(GetStorage('box').read('user'));
                Get.offAllNamed(Login.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
