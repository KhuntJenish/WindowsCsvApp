import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theam/theam_constants.dart';
import '../../utils/partyMasterBottomsheet.dart';
import 'partyComission.dart';
import 'partyController.dart';

class PartyMasterPage extends StatelessWidget {
  static const routeName = '/partyMaster';
  const PartyMasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    PartyController _partyController = Get.put(PartyController());
    String btnText = 'Add User';
    TextEditingController name = TextEditingController(text: '');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Party Master',
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
              stream: _partyController.db
                  .select(_partyController.db.partyMaster)
                  .watch(),
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
                      // print(snapshot.data?[index].ptID);
                      var data = _partyController.partyTypeList?.firstWhere(
                          (element) =>
                              element.id == snapshot.data?[index].ptID);
                      // print(data?.type);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading:
                              CircleAvatar(child: Text((index + 1).toString())),
                          title: Text(
                              '${(snapshot.data?[index].name).toString()}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text((data?.type).toString()),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: Get.width * 0.1,
                                height: Get.height * 0.06,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      gradient: LinearGradient(
                                          colors: Get.isDarkMode
                                              ? [dCOLOR_PRIMARY, dCOLOR_ACCENT]
                                              : [
                                                  lCOLOR_PRIMARY,
                                                  lCOLOR_ACCENT,
                                                ]),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0,
                                                0.57), //shadow for button
                                            blurRadius:
                                                5) //blur radius of shadow
                                      ]),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      onSurface: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      //make color or elevated button transparent
                                    ),
                                    child: Text(
                                      'Comission',
                                      style: _textTheme.headline6?.copyWith(
                                        color: Get.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: Get.width * 0.015,
                                      ),
                                    ),
                                    onPressed: () {
                                      btnText = 'Add Comission';
                                      name.text = 0.toString();

                                      Get.toNamed(PartyComission.routeName,
                                          arguments: snapshot.data?[index]);
                                      // Get.bottomSheet(
                                      //   isScrollControlled: true,
                                      //   ignoreSafeArea: false,
                                      //   PartyComissionBottomsheet(
                                      //     partyName: '${(snapshot.data?[index].name).toString()}',
                                      //     btnText: btnText,
                                      //     id: snapshot.data?[index].id,
                                      //     newComission: name,
                                      //   ),
                                      // );
                                      // Get.offAllNamed(Homepage.routeName);
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: (() {
                                  btnText = 'Update Party';
                                  name.text =
                                      (snapshot.data?[index].name).toString();
                                  _partyController.defualtParty.value = data!;
                                  Get.bottomSheet(
                                    isScrollControlled: true,
                                    ignoreSafeArea: false,
                                    PartyTypeBottomsheet(
                                      name: name,
                                      btnText: btnText,
                                      id: snapshot.data?[index].id,
                                    ),
                                  );
                                }),
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: (() {
                                  Get.dialog(AlertDialog(
                                    title: const Text('Delete Party'),
                                    content: const Text(
                                        'Are you sure you want to delete this Party?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            _partyController.deleteParty(
                                                id: snapshot.data?[index].id);
                                          },
                                          child: const Text('Yes')),
                                    ],
                                  ));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // password.text = '';
          // phone.text = '';
          name.text = '';
          btnText = 'Add Party';
          Get.bottomSheet(
            isScrollControlled: true,
            ignoreSafeArea: false,
            PartyTypeBottomsheet(
              name: name,
              btnText: btnText,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
