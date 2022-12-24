import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:csvapp/screen/users/userController.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theam/theam_constants.dart';
import 'constant.dart';
import 'dropDownItem.dart';
import 'helper_widget.dart';

class PartyTypeBottomsheet extends StatelessWidget {
  PartyTypeBottomsheet({
    Key? key,
    required this.btnText,
    required this.name,
    this.id,
  }) : super(key: key);

  // final UserController _userController;
  final String btnText;
  final int? id;
  final PartyController _partyController = Get.put(PartyController());
  TextEditingController partyType = TextEditingController(text: '');
  TextEditingController name;

  @override
  Widget build(BuildContext context) {
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
              Text(btnText.toString(),
                  style: GoogleFonts.padauk(
                    fontSize: Get.width * 0.04,
                  )),
              addVerticaleSpace(Get.height * 0.01),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.28),
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  controller: name,
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
                child: PartyTypeDropDownItems(
                  defualtValue: _partyController.defualtParty,
                  itemList: _partyController.partyTypeList,
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: Get.width * 0.5,
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
                            color: Color.fromRGBO(
                                0, 0, 0, 0.57), //shadow for button
                            blurRadius: 5) //blur radius of shadow
                      ]),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      onSurface: Colors.transparent,
                      shadowColor: Colors.transparent,
                      //make color or elevated button transparent
                    ),
                    child: Text(
                      'submit',
                      style: _textTheme.headline6?.copyWith(
                        color: Get.isDarkMode ? Colors.black : Colors.white,
                        fontSize: Get.width * 0.015,
                      ),
                    ),
                    onPressed: () {
                      if (name.text.isNotEmpty) {
                        if (btnText == 'Add Party') {
                          
                        _partyController.addParty(
                          name: name.text,
                          type: _partyController.defualtParty.value.id,
                        );
                     
                        } else if(btnText == 'Update Party'){
                          _partyController.updateParty(
                            id: id!,
                            name: name.text,
                            ptID: _partyController.defualtParty.value.id,
                          );
                        }
                      } else {
                        'Please Enter Party Name'.errorSnackbar;
                      }
                    },
                  ),
                ),
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
          Obx(
            () => Positioned(
              bottom: Get.height * 0.03,
              right: Get.width * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible:
                        _partyController.addPartyBtnText.value == 'Add Party'
                            ? true
                            : false,
                    replacement: Container(),
                    child: Container(
                      width: Get.width * 0.3,
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      child: TextField(
                        readOnly: name.text == 'admin' ? true : false,
                        keyboardType: TextInputType.text,
                        maxLength: 30,
                        controller: partyType,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'Enter Party Type',
                          counterText: '',
                          hintStyle: _textTheme.headline6?.copyWith(
                            color: Colors.grey,
                            fontSize: Get.height * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: Get.width * 0.09,
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
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.57), //shadow for button
                                blurRadius: 5) //blur radius of shadow
                          ]),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                            //make color or elevated button transparent
                          ),
                          child: Text(
                            _partyController.addPartyBtnText.value,
                            style: _textTheme.headline6?.copyWith(
                              color:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                              fontSize: Get.width * 0.015,
                            ),
                          ),
                          onPressed: () {
                            // if (_partyController.addPartyBtnText.value ==
                            //     'Add Party') {
                            //   _partyController.addPartyBtnText.value = 'Add';
                            //   print(_partyController.addPartyBtnText.value);
                            // }
                            if (partyType.text.isNotEmpty) {
                              _partyController.addPartyType(
                                  partyType: partyType.text);
                              // db.into(db.partyTypeMaster).insert(
                              //       PartyTypeMasterCompanion.insert(
                              //           type: partyType.text),
                              //     );
                            } else {
                              'Fill Require Feild'.errorSnackbar;
                            }
                          }),
                    ),
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
