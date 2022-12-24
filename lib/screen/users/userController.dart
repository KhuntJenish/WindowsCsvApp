import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/homepage/homepage.dart';
import 'package:csvapp/utils/constant.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:drift/drift.dart';
// import 'package:drift/drift.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  // var isDarkMode = false;
  // var isPwdVisible = false.obs;
  // var isLoginStep = '1'.obs;
  var db = Constantdata.db;
  var isPwdVisible = false.obs;

  createUser({
    required String username,
    required String password,
    int? phone,
    String? mail,
  }) async {
    try {
      var user = await (db.select(db.user)
            ..where((tbl) => (tbl.username.equals(username))))
          .get();
      if (user.isEmpty) {
        var data = await db.into(db.user).insert(UserCompanion.insert(
            username: username,
            password: password,
            phone: phone ?? 0,
            mail: mail ?? ''));
        // print(data.length);
        if (data > 0) {
          Get.back();
          'User Add Successful'.successSnackbar;
          // print('user not exist');
        } else {
          // print(data);
          Get.back();
          'something went wrong!'.errorSnackbar;
        }
      } else {
        Get.back();
        'User already exist'.errorSnackbar;
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  updateUser({
    required int id,
    required String username,
    required String password,
    int? phone,
    String? mail,
  }) async {
    try {
      // Value<String> username =  Value(username);
      if (username == 'admin') {
        Get.offAllNamed(Homepage.routeName);
        'Admin can not be updated'.errorSnackbar;
      } else {
        var data = await (db.update(db.user)..where((tbl) => tbl.id.equals(id)))
            .write(UserData(
                id: id,
                username: username,
                password: password,
                phone: phone ?? 0,
                mail: mail ?? ''));
        // print(data.length);
        if (data > 0) {
          if (GetStorage('box').read('cuser').username != 'admin') {
            var user = UserData(
                id: id,
                username: username,
                password: password,
                phone: phone ?? 0,
                mail: mail ?? '');
            await GetStorage('box').write('cuser', user);
            print(GetStorage('box').read('cuser'));
            Get.offAllNamed(Homepage.routeName);
          } else {
            Get.back();
          }
          'User update Successful'.successSnackbar;
          // print('user not exist');

        } else {
          // print(data);
          Get.back();
          'something went wrong!'.errorSnackbar;
        }
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  forgetPassword({
    required int id,
    required String username,
    required String password,
    int? phone,
    String? mail,
  }) async {
    try {
      // Value<String> username =  Value(username);
      if (username == 'admin') {
        Get.back();
        'Admin can not be updated'.errorSnackbar;
      } else {
        var data = await (db.update(db.user)
              ..where(
                  (tbl) => tbl.phone.equals(phone!) | tbl.mail.equals(mail!)))
            .write(UserData(
                id: id,
                username: username,
                password: password,
                phone: phone ?? 0,
                mail: mail ?? ''));
        // print(data.length);
        if (data > 0) {
          Get.back();

          'User update Successful'.successSnackbar;
          // print('user not exist');

        } else {
          // print(data);
          Get.back();
          'something went wrong!'.errorSnackbar;
        }
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }

  deleteUser({
    required int? id,
  }) async {
    try {
      // Value<String> username =  Value(username);
      var data =
          await (db.delete(db.user)..where((tbl) => tbl.id.equals(id!))).go();
      // print(data.length);
      if (data > 0) {
        'User delete Successful'.successSnackbar;
        // print('user not exist');
      } else {
        // print(data);
        'something went wrong!'.errorSnackbar;
      }
    } catch (e) {
      e.toString().errorSnackbar;
    }
  }
}
