import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/helper_widget.dart';
import '../../utils/partyComissionBottomsheet.dart';

class PartyComission extends StatelessWidget {
  static const routeName = '/partyComission';

  // PartyComission();
  // PartyComission({super.key});

  // final UserController _userController;
  late String btnText;
  late String partyName = 'Brijal Patel';
  late int? id;
  final PartyController _partyController = Get.put(PartyController());
  final TextEditingController partyType = TextEditingController(text: '');
  late TextEditingController newComission = TextEditingController(text: '');
  final PartyMasterData party = Get.arguments;

  PartyComission({super.key});
  @override
  Widget build(BuildContext context) {
    // print(party);
    // print(_partyController.addPartyBtnText.value);
    print(_partyController.partyTypeList);
    print(_partyController.materialTypeList);
    List<int> partyTypeIDList = [];

    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        // width:  Get.width * 0.5 ,
        // height: Get.height * 0.8,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.1,
                  width: Get.width * 0.8,
                  child: AutoSizeText(
                    '${party.name.toString()}`s Comission ',
                    style: GoogleFonts.padauk(
                      fontSize: Get.width * 0.04,
                    ),
                    minFontSize: 15,
                  ),
                ),
                addVerticaleSpace(Get.height * 0.01),
                // Text(partyName.toString(),
                //     style: GoogleFonts.padauk(
                //       fontSize: Get.height * 0.02,
                //     )),
                addVerticaleSpace(Get.height * 0.01),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder(
                          stream: (_partyController.db.select(
                                  _partyController.db.partyComissionDetail)
                                ..where((tbl) => tbl.pID.equals(party.id)))
                              .watch(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                    width: Get.width * 0.08,
                                    height: Get.height * 0.05,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    child: const Center(
                                      child: Text(
                                        'Sr. No.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: Get.width * 0.2,
                                          height: Get.height * 0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: const Center(
                                            child: Text(
                                              'Material Type',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          )),
                                      Container(
                                        width: Get.width * 0.1,
                                        height: Get.height * 0.05,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: const Center(
                                          child: Text(
                                            'Comission 1',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: Get.width * 0.1,
                                        height: Get.height * 0.05,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: const Center(
                                          child: Text(
                                            'Comission 2',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: Get.width * 0.1,
                                        height: Get.height * 0.05,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: const Center(
                                          child: Text(
                                            'Comission 3',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    width: Get.width * 0.1,
                                    height: Get.height * 0.05,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                    child: const Center(
                                      child: Text(
                                        'Action',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.7,
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        var materialType = _partyController
                                            .materialTypeList
                                            ?.firstWhere((element) =>
                                                element.id ==
                                                snapshot.data![index].mtID)
                                            .type;
                                        partyTypeIDList
                                            .add(snapshot.data![index].mtID);
                                        print(materialType);
                                        return ListTile(
                                          leading: Container(
                                            width: Get.width * 0.08,
                                            height: Get.height * 0.05,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Center(
                                              child: Text(
                                                (index + 1).toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                  width: Get.width * 0.2,
                                                  height: Get.height * 0.05,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: Center(
                                                    child: Text(
                                                      materialType.toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  )),
                                              Container(
                                                width: Get.width * 0.1,
                                                height: Get.height * 0.05,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: Center(
                                                  child: Text(
                                                    snapshot
                                                        .data![index].comission1
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: Get.width * 0.1,
                                                height: Get.height * 0.05,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: Center(
                                                  child: Text(snapshot
                                                      .data![index].comission2
                                                      .toString()),
                                                ),
                                              ),
                                              Container(
                                                width: Get.width * 0.1,
                                                height: Get.height * 0.05,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: Center(
                                                  child: Text(snapshot
                                                      .data![index].comission3
                                                      .toString()),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: SizedBox(
                                            width: Get.width * 0.1,
                                            height: Get.height * 0.05,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    // _partyController.deletePartyComission(
                                                    //     id: snapshot.data![index].id);
                                                    btnText =
                                                        'Update Comission';
                                                    _partyController
                                                            .defualtMaterialType
                                                            .value =
                                                        _partyController
                                                            .materialTypeList!
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .mtID);
                                                    Get.bottomSheet(
                                                      isScrollControlled: true,
                                                      ignoreSafeArea: false,
                                                      PartyComissionBottomSheet(
                                                        comissionPercentage: '',
                                                        party: party,
                                                        btnText: btnText,
                                                        oldComission: snapshot
                                                            .data![index],
                                                        // id: snapshot.data?[index].id,
                                                        // newComission: name,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    Get.dialog(AlertDialog(
                                                      title: const Text(
                                                          'Delete Party'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this PartyComission?'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: const Text(
                                                                'No')),
                                                        TextButton(
                                                            onPressed: () {
                                                              _partyController
                                                                  .deletePartyComission(
                                                                      id: snapshot
                                                                          .data![
                                                                              index]
                                                                          .id);
                                                            },
                                                            child: const Text(
                                                                'Yes')),
                                                      ],
                                                    ));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),

                                  // Text(snapshot.data!.length.toString()),
                                ),
                              ],
                            );
                          })
                    ],
                  ),
                ),
                addVerticaleSpace(Get.height * 0.01),
              ],
            ),
            Positioned(
              top: Get.height * 0.01,
              left: Get.width * 0.01,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _partyController.addPartyBtnText.value = 'Add Party';
          // _partyController.defualtParty.value = PartyType(id: 1, name: 'Buyer');
          // newComission.text = '';
          // Get.toNamed(PartyComission.routeName);
          // print(partyTypeIDList);
          btnText = 'Add Comission';
          Get.bottomSheet(
            isScrollControlled: true,
            ignoreSafeArea: false,
            PartyComissionBottomSheet(
              comissionPercentage: '',
              party: party,
              btnText: btnText,
              isShow: true,
              // partyTypeIDList: partyTypeIDList,
              // id: snapshot.data?[index].id,
              // newComission: name,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
