import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/loginpage/loginpage.dart';
import 'package:csvapp/screen/users/user.dart';
import 'package:csvapp/utils/constant.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'homepage1.dart';
import 'screen/homepage/homepage.dart';
import 'theam/theam_constants.dart';

Future<void> main() async {
  //  static final db = MyDatabase();

  // final id = await Constantdata.db
  //     .into(Constantdata.db.user)
  //     .insert(UserCompanion.insert(username: 'admin', password: 'admin',mail: 'admin@gmail.com',phone: 9624891105));

// await db
//       .into(db.partyMaster)
//       .insert(PartyMasterCompanion.insert(name: 'brijal patel',ptID: id));
//   print(id);
  // (await db.select(db.partyTypeMaster).get()).forEach((element) {
  //   print(element);
  // });
  // (await db.select(db.partyMaster).get()).forEach((element) {
  //   print(element);
  // });
  // print( (db.delete(db.partyTypeMaster)..where((tbl) => tbl.id.isSmallerThanValue(7))).go());
  await GetStorage.init('box');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    if (GetStorage('box').read('cuser') != null) {
      var userData = GetStorage('box').read('cuser');
      var user = UserData(
          id: userData['id'],
          username: userData['username'],
          password: userData['password'],
          phone: userData['phone'],
          mail: userData['mail']);
      print(user);
      GetStorage('box').write('cuser', user);
    }

    print('current User');
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheam, // lightTheam,
          darkTheme: darkTheme, //darkTheme,
          themeMode: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: (GetStorage('box').read('cuser')) == null
              ? Login.routeName
              : Homepage.routeName, //themeMode,
          defaultTransition: Transition.cupertino,
          title: 'First Method',

          getPages: [
            GetPage(
              name: Homepage.routeName,
              page: () => Homepage(),
            ),
            GetPage(
              name: Login.routeName,
              page: () => Login(),
            ),
            GetPage(
              name: Userspage.routeName,
              page: () => Userspage(),
            ),
          ],
        );
      },
      // child: const HomePage(title: 'First Method'),
    );
  }
}
