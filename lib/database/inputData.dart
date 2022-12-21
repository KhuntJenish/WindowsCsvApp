// import 'package:csvapp/database/ledger.dart';
// import 'package:csvapp/database/materialType.dart';

// import 'package:isar/isar.dart';

// import 'partymaster.dart';

// part '../entities/inputData.g.dart';

// @Collection()
// class InputData {
//   // InputData({
//   //   required this.documentType,
//   //   required this.distDocDate,
//   //   required this.distDocNo,
//   //   required this.partyMasterID,
//   //   required this.custBillCity,
//   //   required this.matCode,
//   //   required this.matName,
//   //   required this.materialTypeID,
//   //   required this.qty,
//   //   required this.doctorName,
//   //   required this.techniqalStaff,
//   //   required this.saleAmount,
//   //   required this.totalSale,
//   //   required this.smtDocDate,
//   //   required this.smtDocNo,
//   //   required this.smtInvNo,
//   //   required this.purchaseTaxableAmount,
//   //   this.logId,
//   //   this.ledgerId,
//   //   this.comission,
//   //   this.comissionAmount,
//   //   this.comissionPaidDate,
//   //   this.adjustComissionAmount,
//   // });
//   Id id = Isar.autoIncrement;
//   late String documentType;
//   late DateTime distDocDate;
//   late int distDocNo;
//   var pID = IsarLink<PartyMaster>();
//   late String custBillCity;
//   late int? matCode;
//   late String? matName;
//   var mtID = IsarLink<MaterialType>();
//   late int? qty;
//   late String? doctorName;
//   late double? techniqalStaff;
//   late double? saleAmount;
//   late double? totalSale;
//   late DateTime? smtDocDate;
//   late String? smtDocNo;
//   late String? smtInvNo;
//   late double? purchaseTaxableAmount;
//   late String? logId;
//   var lId = IsarLink<Ledger>();
//   late double? comission;
//   late double? comissionAmount;
//   late DateTime? comissionPaidDate;
//   late double? adjustComissionAmount;

//   // var partyMaster = IsarLinks<PartyMaster>();
//   // var materialType = IsarLinks<MaterialType>();
//   // var ledger = IsarLinks<Ledger>();
// }
