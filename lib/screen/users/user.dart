import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/users/userController.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../utils/userBottomsheet.dart';
import '../../utils/constant.dart';

class Userspage extends StatelessWidget {
  static const routeName = '/users';
  var db = Constantdata.db;
  TextEditingController username = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');
  TextEditingController phone = TextEditingController(text: '');
  TextEditingController email = TextEditingController(text: '');
  final UserController _userController = Get.put(UserController());
  String btnText = 'Add User';
  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Users',
          style: _textTheme.bodyText1?.copyWith(
            color: Colors.white,
            fontSize: Get.height * 0.03,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
              stream: db.select(db.user).watch(),
              builder: ((context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // print(snapshot.data);
                return Container(
                  height: Get.height * 0.8,
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      // print(snapshot.data?[index].username);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading:
                              CircleAvatar(child: Text((index + 1).toString())),
                          title: Text(
                              '${(snapshot.data?[index].username).toString()} _ _ ${(snapshot.data?[index].password).toString()}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text((snapshot.data?[index].mail).toString()),
                              Text(snapshot.data?[index].phone != 0
                                  ? (snapshot.data?[index].phone).toString()
                                  : ''),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: (() {
                                  username.text =
                                      (snapshot.data?[index].username)
                                          .toString();
                                  password.text =
                                      (snapshot.data?[index].password)
                                          .toString();
                                  email.text =
                                      (snapshot.data?[index].mail).toString();
                                  phone.text =
                                      (snapshot.data?[index].phone).toString();
                                  btnText = 'Update User';
                                  var id = snapshot.data?[index].id.toInt();
                                  Get.bottomSheet(
                                      isScrollControlled: true,
                                      ignoreSafeArea: false,
                                      UserBottomsheet(
                                        id: id!,
                                        btnText: 'Update User',
                                        username: username,
                                        password: password,
                                        email: email,
                                        phone: phone,
                                      ));
                                }),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: (() {
                                  UserData user =
                                      GetStorage('box').read('cuser');
                                  if (snapshot.data?[index].username != 'admin') {
                                    var id = snapshot.data?[index].id.toInt();
                                    Get.dialog(AlertDialog(
                                      title: const Text('Delete User'),
                                      content: const Text(
                                          'Are you sure you want to delete this user?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Get.back();
                                             
                                            },
                                            child: const Text('No')),
                                        TextButton(
                                            onPressed: () {
                                              _userController.deleteUser(
                                                  id: id);
                                              Get.back();
                                            },
                                            child: const Text('Yes')),
                                      ],
                                    ));
                                  } else {
                                    'You can not delete admin user'
                                        .errorSnackbar;

                                    print('You can not delete admin user');
                                    // Get.snackbar('don`t do', 'You can not delete admin user');
                                  }
                                }),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      // drawer: drawer(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            username.text = '';
            password.text = '';
            phone.text = '';
            email.text = '';
            btnText = 'Add User';
            Get.bottomSheet(
              isScrollControlled: true,
              ignoreSafeArea: false,
              UserBottomsheet(
                btnText: btnText,
                username: username,
                password: password,
                email: email,
                phone: phone,
              ),
            );
          },
          child: Icon(Icons.add)),
    );
  }
}
