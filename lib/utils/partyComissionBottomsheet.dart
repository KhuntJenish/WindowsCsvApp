import 'package:csvapp/database/tables.dart';
import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:csvapp/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screen/homepage/homecontroller.dart';
import 'dropDownItem.dart';
import 'helper_widget.dart';

class PartyComissionBottomSheet extends StatelessWidget {
  PartyComissionBottomSheet({
    Key? key,
    required this.btnText,
    required this.hospitalParty,
    required this.doctorParty,
    required this.technicianParty,
    this.oldComission,
    this.isShow = false,
    required this.materialType,
    this.homepageController,
    this.comissionPercentage,
  }) : super(key: key);

  // final UserController _userController;
  final String btnText;
  final PartyMasterData? hospitalParty;
  final PartyMasterData? doctorParty;
  final PartyMasterData? technicianParty;
  final String? comissionPercentage;
  final PartyComissionDetailData? oldComission;
  // final List<int> partyTypeIDList;
  final bool? isShow;
  final PartyController _partyController = Get.put(PartyController());
  final HomepageController? homepageController;
  TextEditingController materialType = TextEditingController(text: '');
  TextEditingController partyNameController = TextEditingController(text: '');
  TextEditingController newComissionController =
      TextEditingController(text: '');
  TextEditingController newComissionAmountController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    // materialType!.text = _partyController.defualtMaterialType.value.type;
    // print(materialType?.text);
    // print(homepageController?.materialTypeList);

    // if (_partyController.materialTypeList!.isNotEmpty &&
    //     materialType?.text != '') {
    //   _partyController.defualtMaterialType.value = _partyController
    //       .materialTypeList!
    //       .firstWhere((element) => element.type == materialType!.text);
    //   materialType!.text = '';

    //   // _partyController.getMaterialTypeList();
    // }

    partyNameController.text = hospitalParty!.name.toString();
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
              comissionParty(
                  textTheme: _textTheme,
                  pType: 'Hopsital',
                  pname: hospitalParty?.name),

              addVerticaleSpace(Get.height * 0.01),
              comissionParty(
                  textTheme: _textTheme,
                  pType: 'Doctor',
                  pname: doctorParty?.name),

              addVerticaleSpace(Get.height * 0.01),
              comissionParty(
                  textTheme: _textTheme,
                  pType: 'Technician',
                  pname: technicianParty?.name),

              addVerticaleSpace(Get.height * 0.01),
              Button(
                height: Get.height * 0.06,
                width: Get.width * 0.5,
                fontSize: Get.width * 0.015,
                text: 'submit',
                onPressed: () {
                  if (partyNameController.text.isNotEmpty &&
                      newComissionController.text.isNotEmpty &&
                      _partyController.defualtMaterialType.value.type != '') {
                    if (btnText == 'Add Comission' ||
                        btnText == 'Add New Comission') {
                      _partyController.addPartyComission(
                        pID: hospitalParty?.id,
                        mtID: _partyController.defualtMaterialType.value.id,
                        newComission: double.parse(newComissionController.text),
                      );
                      if (btnText == 'Add New Comission') {
                        List<List<dynamic>> data = [];

                        data.addAll(homepageController!.pendingReportData);
                        homepageController!.displayData.clear();
                        homepageController!.partyNaNSetData.clear();
                        homepageController!.comissionAndmatTypeNaNSetData
                            .clear();
                        homepageController!.checkInputData(fields: data);
                      }
                    } else if (btnText == 'Update Comission') {
                      _partyController.updatePartyComission(
                        oldComissionData: oldComission!,
                        pID: hospitalParty?.id,
                        mtid: _partyController.defualtMaterialType.value.id,
                        newComission: double.parse(newComissionController.text),
                      );
                    }
                  } else {
                    'Please Enter Party Name or Comission'.errorSnackbar;
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
                      print(materialType.text);
                      if (materialType.text.isNotEmpty) {
                        _partyController.addMaterialType(
                            materialType: materialType.text);
                        materialType.clear();
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

  Column comissionParty({TextTheme? textTheme, String? pType, String? pname}) {
    partyNameController.text = pname!;
    print(pname);
    print('-------');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: Get.width * 0.15),
          child: Text(
            '$pType:',
            style: textTheme?.headline6?.copyWith(
                // color: Colors.grey,
                fontSize: Get.height * 0.025,
                fontWeight: FontWeight.w600),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.2,
              // padding:
              //     EdgeInsets.symmetric(horizontal: Get.height * 0.28),
              child: TextField(
                readOnly: true,
                keyboardType: TextInputType.text,
                maxLength: 30,
                controller: partyNameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Enter Username',
                  counterText: '',
                  hintStyle: textTheme?.headline6?.copyWith(
                    color: Colors.grey,
                    fontSize: Get.height * 0.02,
                  ),
                ),
              ),
            ),
            addHorizontalSpace(Get.height * 0.01),
            Container(
              //  color: Colors.grey[400],
              width: Get.width * 0.2,
              // padding:
              //     EdgeInsets.symmetric(horizontal: Get.height * 0.25),
              child: MaterialTypeDropDownItems(
                width: Get.width * 0.9,
                defualtValue: _partyController.defualtMaterialType,
                itemList: _partyController.materialTypeList,
              ),
            ),
            addHorizontalSpace(Get.height * 0.01),
            Container(
              // padding:
              //     EdgeInsets.symmetric(horizontal: Get.height * 0.28),
              width: Get.width * 0.15,
              child: TextField(
                keyboardType: TextInputType.text,
                maxLength: 30,
                controller: newComissionController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.percent),
                  hintText: 'Add Comission',
                  counterText: '',
                  hintStyle: textTheme?.headline6?.copyWith(
                    color: Colors.grey,
                    fontSize: Get.height * 0.02,
                  ),
                ),
              ),
            ),
            // addHorizontalSpace(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.swap_horiz_outlined, color: Colors.grey[700]),
            ),
            // addHorizontalSpace(10),
            // Todo: Add trasalte Icon
            // addHorizontalSpace(Get.height * 0.01),

            Container(
              width: Get.width * 0.15,
              child: TextField(
                keyboardType: TextInputType.text,
                maxLength: 30,
                controller: newComissionAmountController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.currency_rupee_outlined),
                  hintText: 'Comission Amount',
                  counterText: '',
                  hintStyle: textTheme?.headline6?.copyWith(
                    color: Colors.grey,
                    fontSize: Get.height * 0.02,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
