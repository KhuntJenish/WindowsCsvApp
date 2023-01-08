import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/homepage/partyLedger.dart';
import 'package:csvapp/screen/homepage/partyPayment.dart';
import 'package:csvapp/screen/loginpage/loginpage.dart';
import 'package:csvapp/screen/partyMaster/partyComission.dart';
import 'package:csvapp/screen/partyMaster/partyMaster.dart';
import 'package:csvapp/screen/users/user.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dashboard.dart';
import 'screen/homepage/generatedReport.dart';
import 'screen/homepage/ImportReport.dart';
import 'theam/theam_constants.dart';

Future<void> main() async {
  //  static final db = MyDatabase();

  // final id = await Constantdata.db.into(Constantdata.db.user).insert(
  //     UserCompanion.insert(
  //         username: 'admin',
  //         password: 'admin',
  //         mail: 'admin@gmail.com',
  //         phone: 9624891105));
  // print(id);

  // final id = await (Constantdata.db.delete(Constantdata.db.materialType)
  //       ..where((tbl) => tbl.id.equals(2)))
  //     .go();
  // print(id);

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
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   setWindowTitle('Flutter Demo');
  //   setWindowMinSize(const Size(400, 300));
  //   setWindowMaxSize(Size.infinite);
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Future testWindowFunctions() async {
    Size size = await DesktopWindow.getWindowSize();
    print(size);
    await DesktopWindow.setWindowSize(const Size(1000, 800));

    await DesktopWindow.setMinWindowSize(const Size(1000, 800));
    // await DesktopWindow.setMaxWindowSize(Size(800, 800));

    // await DesktopWindow.resetMaxWindowSize();
    // await DesktopWindow.toggleFullScreen();
    await DesktopWindow.setFullScreen(true);
    // await DesktopWindow.setFullScreen(false);
  }

  @override
  Widget build(BuildContext context) {
    testWindowFunctions();
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    if (GetStorage('box').read('cuser') != null) {
      var userData = GetStorage('box').read('cuser');
      print(userData);
      var user = UserData(
          id: userData['id'],
          username: userData['username'],
          password: userData['password'],
          phone: userData['phone'],
          mail: userData['mail']);
      // print(user);
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
              : Dashboard.routeName, //themeMode,
          defaultTransition: Transition.cupertino,
          title: 'First Method',

          getPages: [
            GetPage(
              name: PartyLedger.routeName,
              page: () => PartyLedger(),
            ),
            GetPage(
              name: ImportReport.routeName,
              page: () => ImportReport(),
            ),
            GetPage(
              name: GeneratedReport.routeName,
              page: () => GeneratedReport(),
            ),
            GetPage(
              name: PartyPayment.routeName,
              page: () => PartyPayment(),
            ),
            GetPage(
              name: Login.routeName,
              page: () => const Login(),
            ),
            GetPage(
              name: Userspage.routeName,
              page: () => Userspage(),
            ),
            GetPage(
              name: PartyMasterPage.routeName,
              page: () => const PartyMasterPage(),
            ),
            GetPage(
              name: PartyComission.routeName,
              page: () => PartyComission(),
            ),
            GetPage(
              name: Dashboard.routeName,
              page: () => Dashboard(),
              transition: Transition.native),
            // GetPage(
            //   name: MaterialTypeMasterPage.routeName,
            //   page: () => MaterialTypeMasterPage(),
            // ),
          ],
        );
      },
      // child: const HomePage(title: 'First Method'),
    );
  }
}
