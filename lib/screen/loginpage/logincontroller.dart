import 'package:csvapp/database/tables.dart';
import 'package:csvapp/dashboard.dart';
import 'package:csvapp/utils/constant.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:drift/drift.dart';
// import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  var isDarkMode = false;
  var isPwdVisible = false.obs;
  var isLoginStep = '1'.obs;
  var db = Constantdata.db;

  login({required String username, required String password}) async {
    try {
      var data = await (db.select(db.user)
            ..where((tbl) {
              return (tbl.username.equals(username) &
                  tbl.password.equals(password));
            }))
          .get();
      // print(data[0]);

      if (data.isEmpty) {
        'User not found'.errorSnackbar;
        // print('user not exist');
      } else {
        UserData user = data[0] as UserData;
        GetStorage('box').write('cuser', user);
        print('current User');
        UserData currentUser = GetStorage('box').read('cuser');
        print(currentUser.username);
        // print(data);
        Get.offAllNamed(Dashboard.routeName);
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }
}
