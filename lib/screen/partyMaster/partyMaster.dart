import 'package:csvapp/utils/helper_widget.dart';
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
                              Button(
                                height: Get.height * 0.06,
                                width: Get.width * 0.1,
                                fontSize: Get.width * 0.015,
                                text: 'Comission',
                                onPressed: () {
                                  btnText = 'Add Comission';
                                  name.text = 0.toString();

                                  Get.toNamed(PartyComission.routeName,
                                      arguments: snapshot.data?[index]);
                                },
                              ),
                              IconButton(
                                onPressed: (() {
                                  btnText = 'Update Party';
                                  name.text =
                                      (snapshot.data?[index].name).toString();
                                  _partyController.defualtPartyType.value =
                                      data!;
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
