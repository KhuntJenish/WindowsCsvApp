import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dropDownItem.dart';
import 'helper_widget.dart';

class PartyTypeBottomsheet extends StatelessWidget {
  PartyTypeBottomsheet({
    Key? key,
    required this.btnText,
    required this.name,
    this.homepageController,
    this.id,
  }) : super(key: key);

  // final UserController _userController;
  final String btnText;
  final int? id;
  final PartyController _partyController = Get.put(PartyController());
  final HomepageController? homepageController;
  TextEditingController partyType = TextEditingController(text: '');
  TextEditingController name;

  @override
  Widget build(BuildContext context) {
    // print(_partyController.addPartyBtnText.value);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.grey[100],
      // width:  Get.width * 0.5 ,
      // height: Get.height * 0.8,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(btnText.toString(),
                  style: GoogleFonts.padauk(
                    fontSize: Get.width * 0.04,
                  )),
              addVerticaleSpace(Get.height * 0.01),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.28),
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  controller: name,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Enter Username',
                    counterText: '',
                    hintStyle: textTheme.headline6?.copyWith(
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
                child: PartyTypeDropDownItems(
                  defualtValue: _partyController.defualtPartyType,
                  itemList: _partyController.partyTypeList,
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Button(
                height: Get.height * 0.06,
                width: Get.width * 0.5,
                fontSize: Get.width * 0.015,
                text: 'submit',
                onPressed: () {
                  if (name.text.isNotEmpty &&
                      _partyController.defualtPartyType.value.type != '') {
                    if (btnText == 'Add Party' || btnText == 'Add New Party') {
                      _partyController.addParty(
                        name: name.text,
                        type: _partyController.defualtPartyType.value.id,
                      );
                      if (btnText == 'Add New Party') {
                        List<List<dynamic>> data = [];
                        data.addAll(homepageController!.pendingReportData);
                        homepageController!.displayData.clear();
                        homepageController!.partyNaNSetData.clear();
                        homepageController!.comissionAndmatTypeNaNSetData
                            .clear();
                        homepageController!.checkInputData(fields: data);
                      }
                    } else if (btnText == 'Update Party') {
                      _partyController.updateParty(
                        id: id!,
                        name: name.text,
                        ptID: _partyController.defualtPartyType.value.id,
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
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
