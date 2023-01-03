import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:csvapp/screen/users/userController.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/homepage/homecontroller.dart';
import '../theam/theam_constants.dart';
import 'constant.dart';
import 'dropDownItem.dart';
import 'helper_widget.dart';

class PartyComissionBottomSheet extends StatelessWidget {
  PartyComissionBottomSheet({
    Key? key,
    required this.btnText,
    required this.party,
    this.oldComission,
    this.isShow = false,
    this.materialType,
    // this.partyTypeIDList = const [],
    // required this.newComission,
    // this.id,
    this.comissionPercentage,
  }) : super(key: key);

  // final UserController _userController;
  final String btnText;
  final PartyMasterData? party;
  final String? comissionPercentage;
  final PartyComissionDetailData? oldComission;
  // final List<int> partyTypeIDList;
  final bool? isShow;
  final PartyController _partyController = Get.put(PartyController());
  final HomepageController _homepageController = Get.put(HomepageController());
  TextEditingController? materialType = TextEditingController(text: '');
  TextEditingController partyNameController = TextEditingController(text: '');
  TextEditingController newComissionController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    partyNameController.text = party!.name.toString();
    newComissionController.text = comissionPercentage.toString();
    // print(_partyController.addPartyBtnText.value);
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.grey[100],
      // width:  Get.width * 0.5 ,
      // height: Get.height * 0.8,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${btnText}',
                  style: GoogleFonts.padauk(
                    fontSize: Get.width * 0.04,
                  )),
              addVerticaleSpace(Get.height * 0.01),
              // Text(partyName.toString(),
              //     style: GoogleFonts.padauk(
              //       fontSize: Get.height * 0.02,
              //     )),
              addVerticaleSpace(Get.height * 0.01),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.28),
                child: TextField(
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  controller: partyNameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Enter Username',
                    counterText: '',
                    hintStyle: _textTheme.headline6?.copyWith(
                      color: Colors.grey,
                      fontSize: Get.height * 0.02,
                    ),
                  ),
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Container(
                //  color: Colors.grey[400],
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.25),
                child: MaterialTypeDropDownItems(
                  width: Get.width * 0.9,
                  defualtValue: _partyController.defualtMaterialType,
                  itemList: _partyController.materialTypeList,
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.28),
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  controller: newComissionController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.percent),
                    hintText: 'Add New Comission',
                    counterText: '',
                    hintStyle: _textTheme.headline6?.copyWith(
                      color: Colors.grey,
                      fontSize: Get.height * 0.02,
                    ),
                  ),
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Button(
                height: Get.height * 0.06,
                width: Get.width * 0.5,
                fontSize: Get.width * 0.015,
                text: 'submit',
                onPressed: () {
                  if (partyNameController.text.isNotEmpty) {
                    if (btnText == 'Add Comission' ||
                        btnText == 'Add New Comission') {
                      _partyController.addPartyComission(
                        pID: party?.id,
                        mtID: _partyController.defualtMaterialType.value.id,
                        newComission: double.parse(newComissionController.text),
                      );
                      if (btnText == 'Add New Comission') {
                        List<List<dynamic>> data = [];

                        data.addAll(_homepageController.pendingReportData);
                        _homepageController.displayData.clear();
                        _homepageController.partyNaNSetData.clear();
                        _homepageController.comissionAndmatTypeNaNSetData
                            .clear();
                        _homepageController.checkInputData(fields: data);
                      }
                    } else if (btnText == 'Update Comission') {
                      _partyController.updatePartyComission(
                        oldComissionData: oldComission!,
                        pID: party?.id,
                        mtid: _partyController.defualtMaterialType.value.id,
                        newComission: double.parse(newComissionController.text),
                      );
                    }
                  } else {
                    'Please Enter Party Name'.errorSnackbar;
                  }
                },
              ),
            ],
          ),
          Positioned(
            top: Get.height * 0.01,
            left: Get.width * 0.01,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Visibility(
            visible: isShow!,
            child: Positioned(
              bottom: Get.height * 0.03,
              right: Get.width * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: Get.width * 0.3,
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                    child: TextField(
                      // readOnly: newComission.text == 'admin' ? true : false,
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                      controller: materialType,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Enter Material Type',
                        counterText: '',
                        hintStyle: _textTheme.headline6?.copyWith(
                          color: Colors.grey,
                          fontSize: Get.height * 0.02,
                        ),
                      ),
                    ),
                  ),
                  Button(
                    height: Get.height * 0.06,
                    width: Get.width * 0.09,
                    fontSize: Get.width * 0.015,
                    text: _partyController.addPartyBtnText.value,
                    onPressed: () {
                      if (materialType!.text.isNotEmpty) {
                        _partyController.addMaterialType(
                            materialType: materialType!.text);
                        materialType!.clear();
                      } else {
                        'Fill Require Feild'.errorSnackbar;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
