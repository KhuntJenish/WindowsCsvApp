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
    this.isShowAddMt,
    required this.materialType,
    this.homepageController,
    this.comissionPercentage,
    this.itemAmount = 0.0,
    this.isShowDoctor = true,
    this.isShowHospital = true,
    this.isShowTechnician = true,
  }) : super(key: key);

  // final UserController _userController;
  final String btnText;
  double itemAmount;
  final PartyMasterData? hospitalParty;
  final PartyMasterData? doctorParty;
  final PartyMasterData? technicianParty;
  final String? comissionPercentage;
  final PartyComissionDetailData? oldComission;
  // final List<int> partyTypeIDList;
  final Rx<bool>? isShowAddMt;
  final PartyController _partyController = Get.put(PartyController());
  final HomepageController? homepageController;
  TextEditingController materialType = TextEditingController(text: '');
  TextEditingController itemAmountController = TextEditingController(text: '');
  bool? isShowDropDown = true;
  bool? isShowHospital;
  bool? isShowDoctor;
  bool? isShowTechnician;
  TextEditingController hospitalComissionController =
      TextEditingController(text: '');
  TextEditingController doctorComissionController =
      TextEditingController(text: '');
  TextEditingController technicianComissionController =
      TextEditingController(text: '');
  // TextEditingController partyNameController = TextEditingController(text: '');

  // TextEditingController materialTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (btnText == 'Add New Comission' || btnText == 'Update Comission') {
      isShowDropDown = false;
      if (btnText == 'Update Comission') {
        itemAmountController.text = itemAmount.toStringAsFixed(2);
        var pid = isShowHospital!
            ? 1
            : isShowDoctor!
                ? 2
                : 3;
        var p = double.parse(comissionPercentage.toString());
        if (pid == 1) {
          hospitalComissionController.text = p.toString();
        } else if (pid == 2) {
          doctorComissionController.text = p.toString();
        } else {
          technicianComissionController.text = p.toString();
        }
      }
    }

    TextTheme _textTheme = Theme.of(context).textTheme;
    return Container(
      color: Colors.grey[100],
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
              Visibility(
                visible: (btnText.contains('Add New Comission')),
                replacement: Container(
                  width: Get.width * 0.2,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 30,
                    controller: itemAmountController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.currency_rupee_outlined),
                      hintText: 'Add Item Amount',
                      counterText: '',
                      hintStyle: textTheme.headline6?.copyWith(
                        color: Colors.grey,
                        fontSize: Get.height * 0.02,
                      ),
                    ),
                  ),
                ),
                child: Text('Items Amount : ${itemAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.padauk(
                      fontSize: Get.width * 0.015,
                    )),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Visibility(
                visible: isShowHospital!,
                child: Column(
                  children: [
                    comissionParty(
                      textTheme: _textTheme,
                      pType: 'Hopsital',
                      pname: hospitalParty?.name,
                      isShowDropDown: isShowDropDown,
                      newComissionController: hospitalComissionController,
                    ),
                    addVerticaleSpace(Get.height * 0.01),
                  ],
                ),
              ),
              Visibility(
                visible: isShowDoctor!,
                child: Column(
                  children: [
                    comissionParty(
                      textTheme: _textTheme,
                      pType: 'Doctor',
                      pname: doctorParty?.name,
                      isShowDropDown: isShowDropDown,
                      newComissionController: doctorComissionController,
                    ),
                    addVerticaleSpace(Get.height * 0.01),
                  ],
                ),
              ),
              Visibility(
                visible: isShowTechnician!,
                child: Column(
                  children: [
                    comissionParty(
                      textTheme: _textTheme,
                      pType: 'Technician',
                      pname: technicianParty?.name,
                      isShowDropDown: isShowDropDown,
                      newComissionController: technicianComissionController,
                    ),
                    addVerticaleSpace(Get.height * 0.01),
                  ],
                ),
              ),
              addVerticaleSpace(Get.height * 0.01),
              Button(
                  height: Get.height * 0.06,
                  width: Get.width * 0.5,
                  fontSize: Get.width * 0.015,
                  text: 'submit',
                  onPressed: () async {
                    // if (hospitalParty!.name.isNotEmpty &&
                    //     // newComissionController.text.isNotEmpty &&
                    //     _partyController.defualtMaterialType.value.type != '') {
                    if (btnText == 'Add Comission' ||
                        btnText == 'Add New Comission') {
                      var partyID, partyComission;
                      if (btnText == 'Add Comission') {
                        partyComission = isShowHospital!
                            ? hospitalComissionController.text
                            : isShowDoctor!
                                ? doctorComissionController.text
                                : technicianComissionController.text;
                        partyID = isShowHospital!
                            ? hospitalParty?.id
                            : isShowDoctor!
                                ? doctorParty?.id
                                : technicianParty?.id;
                        var itemAmount =
                            double.parse(itemAmountController.text);
                        _partyController.addPartyComission(
                          pID: partyID,
                          mtID: _partyController.defualtMaterialType.value.id,
                          newComission: double.parse(partyComission),
                          materialPrice: itemAmount,
                        );
                      }
                      if (btnText == 'Add New Comission') {
                        print(_partyController.materialTypeList);
                        bool isMt = await _partyController
                            .checkMaterialType(materialType.text);

                        if (isMt) {
                          var mtID = _partyController.materialTypeList
                              ?.firstWhere((element) =>
                                  element.type.contains(materialType.text))
                              .id;
                          if (isShowHospital!) {
                            if (hospitalComissionController.text != "") {
                              partyID = hospitalParty?.id;

                              partyComission = hospitalComissionController.text;
                              await _partyController.addPartyComission(
                                pID: partyID,
                                mtID: mtID,
                                newComission: double.parse(partyComission),
                                materialPrice: itemAmount,
                              );
                            } else {
                              "Comission not found!".errorSnackbar;
                            }
                          }
                          if (isShowDoctor!) {
                            if (doctorComissionController.text != "") {
                              partyID = doctorParty?.id;

                              partyComission = doctorComissionController.text;
                              await _partyController.addPartyComission(
                                pID: partyID,
                                mtID: mtID,
                                newComission: double.parse(partyComission),
                                materialPrice: itemAmount,
                              );
                            } else {
                              "Comission not found!".errorSnackbar;
                            }
                          }
                          if (isShowTechnician!) {
                            if (technicianComissionController.text != "") {
                              partyID = technicianParty?.id;

                              partyComission =
                                  technicianComissionController.text;
                              await _partyController.addPartyComission(
                                pID: partyID,
                                mtID: mtID,
                                newComission: double.parse(partyComission),
                                materialPrice: itemAmount,
                              );
                            } else {
                              "Comission not found!".errorSnackbar;
                            }
                          }

                          List<List<dynamic>> data = [];

                          data.addAll(homepageController!.pendingReportData);
                          homepageController!.displayData.clear();
                          homepageController!.partyNaNSetData.clear();
                          homepageController!.comissionAndmatTypeNaNSetData
                              .clear();
                          homepageController!.checkInputData(fields: data);
                        } else {
                          "material Type not found!".errorSnackbar;
                        }
                      }
                    } else if (btnText == 'Update Comission') {
                      var partyID = isShowHospital!
                          ? hospitalParty?.id
                          : isShowDoctor!
                              ? doctorParty?.id
                              : technicianParty?.id;
                      var partyComission = isShowHospital!
                          ? hospitalComissionController.text
                          : isShowDoctor!
                              ? doctorComissionController.text
                              : technicianComissionController.text;
                      var mtID = _partyController.materialTypeList
                          ?.firstWhere((element) =>
                              element.type.contains(materialType.text))
                          .id;
                      _partyController.updatePartyComission(
                        oldComissionData: oldComission!,
                        pID: partyID,
                        mtid: mtID,
                        newComission: double.parse(partyComission),
                        materialPrice: double.parse(itemAmountController.text),
                      );
                    }
                  }
                  // else {
                  //   'Please Enter Party Name or Comission'.errorSnackbar;
                  // }
                  // },
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
            () => Visibility(
              visible: isShowAddMt!.value,
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
                          // materialType.clear();
                          isShowAddMt!.value = false;
                        } else {
                          'Fill Require Feild'.errorSnackbar;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column comissionParty({
    TextTheme? textTheme,
    String? pType,
    String? pname,
    bool? isShowDropDown = false,
    TextEditingController? newComissionController,
  }) {
    TextEditingController partyNameController =
        TextEditingController(text: pname);
    // TextEditingController newComissionController =
    //     TextEditingController(text: '');
    TextEditingController newComissionAmountController =
        TextEditingController(text: '');
    if (btnText == 'Update Comission' &&
        newComissionController!.text.isNotEmpty) {
      var val = newComissionController.text;

      newComissionAmountController.text =
          ((itemAmount * double.parse(newComissionController.text)) / 100)
              .toString();
    }

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
            Visibility(
              visible: isShowDropDown!,
              replacement: Container(
                width: Get.width * 0.2,
                child: TextField(
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  controller: materialType,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    counterText: '',
                    hintStyle: textTheme?.headline6?.copyWith(
                      color: Colors.grey,
                      fontSize: Get.height * 0.02,
                    ),
                  ),
                ),
              ),
              child: Container(
                width: Get.width * 0.2,
                child: MaterialTypeDropDownItems(
                  width: Get.width * 0.9,
                  defualtValue: _partyController.defualtMaterialType,
                  itemList: _partyController.materialTypeList,
                ),
              ),
            ),
            addHorizontalSpace(Get.height * 0.01),
            Container(
              width: Get.width * 0.15,
              child: TextField(
                keyboardType: TextInputType.number,
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
                onChanged: (value) {
                  print(value);
                  if (value.isNotEmpty) {
                    if (btnText == 'Add Comission' &&
                        itemAmountController.text.isNotEmpty) {
                      itemAmount = double.parse(itemAmountController.text);
                    }
                    newComissionAmountController.text =
                        ((double.parse(value) * itemAmount) / 100)
                            .toStringAsFixed(2);
                  } else {
                    newComissionAmountController.text = '';
                  }
                },
              ),
            ),
            // addHorizontalSpace(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.swap_horiz_outlined, color: Colors.grey[700]),
            ),

            Container(
              width: Get.width * 0.15,
              child: TextField(
                keyboardType: TextInputType.number,
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
                onChanged: (value) {
                  print(value);
                  if (value.isNotEmpty) {
                    if (btnText == 'Add Comission' &&
                        itemAmountController.text.isNotEmpty) {
                      itemAmount = double.parse(itemAmountController.text);
                    }
                    newComissionController?.text =
                        ((double.parse(value) * 100) / itemAmount)
                            .toStringAsFixed(2);
                  } else {
                    newComissionController?.text = '';
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
