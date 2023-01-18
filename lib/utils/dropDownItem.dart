import 'package:auto_size_text/auto_size_text.dart';
import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../database/tables.dart';

class PartyTypeDropDownItems extends StatelessWidget {
  PartyTypeDropDownItems({super.key, this.defualtValue, this.itemList});
  Rx<PartyTypeMasterData>? defualtValue;
  final List<PartyTypeMasterData>? itemList;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 50,
      width: Get.width * 0.9,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton<PartyTypeMasterData>(
              value: defualtValue?.value,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: itemList?.map((items) {
                return DropdownMenuItem<PartyTypeMasterData>(
                  value: items,
                  child: Text(items.type),
                );
              }).toList(),
              onChanged: (PartyTypeMasterData? newValue) {
                defualtValue?.value = newValue!;
                print(defualtValue?.value);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class PartyDropDownItems extends StatelessWidget {
  PartyDropDownItems({
    super.key,
    this.defualtValue,
    this.itemList,
    this.selectedItemList,
    this.height = 50,
    this.width,
  });
  Rx<PartyMasterData>? defualtValue;
  final List<PartyMasterData>? itemList;
  final List<PartyMasterData>? selectedItemList;
  final double height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<PartyMasterData>(
            isExpanded: true,
            value: defualtValue?.value,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: itemList?.map((items) {
              return DropdownMenuItem<PartyMasterData>(
                value: items,
                child: Text(items.name,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (PartyMasterData? newValue) {
              defualtValue?.value = newValue!;
              print(defualtValue?.value);
            },
          ),
        ),
      ),
    );
  }
}

class StringDropDownItems extends StatelessWidget {
  StringDropDownItems({
    super.key,
    this.defualtValue,
    this.itemList,
    this.selectedItemList,
    this.height = 50,
    this.width,
    this.homecontroller,
  });
  Rx<String>? defualtValue;
  final List<String>? itemList;
  final List<String>? selectedItemList;
  final double height;
  final double? width;
  HomepageController? homecontroller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: defualtValue?.value,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: itemList?.map((items) {
              return DropdownMenuItem<String>(
                value: items,
                child:
                    Text(items, maxLines: 1, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (String? newValue) {
              defualtValue?.value = newValue!;
              print(defualtValue?.value);
              if (defualtValue?.value == 'Custom') {
                homecontroller?.dateRange.value = DateTimeRange(
                  start: DateTime(DateTime.now().year, DateTime.now().month, 1),
                  end: DateTime.now(),
                );
                print('jenish');
              }
            },
          ),
        ),
      ),
    );
  }
}

class MaterialTypeDropDownItems extends StatelessWidget {
  MaterialTypeDropDownItems(
      {super.key,
      this.defualtValue,
      this.itemList,
      this.height = 50,
      this.width});
  Rx<MaterialTypeData>? defualtValue;
  final List<MaterialTypeData>? itemList;
  final double height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<MaterialTypeData>(
            isExpanded: true,
            value: defualtValue?.value,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: itemList?.map((items) {
              return DropdownMenuItem<MaterialTypeData>(
                value: items,
                child: Text(
                  items.type,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (MaterialTypeData? newValue) {
              defualtValue?.value = newValue!;
              print(defualtValue?.value);
            },
          ),
        ),
      ),
    );
  }
}
