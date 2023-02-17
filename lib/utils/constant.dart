import '../database/tables.dart';

class Constantdata {
  static final db = MyDatabase();
  //database table name
  // static var partyMaster = $PartyMasterTable;
  // static var partyTypeMaster = $PartyTypeMasterTable;
  // static var user = $UserTable;

  // * Party Payment Type & Note /
  static var payment = 'payment';
  static var extraPayment = 'ExtraPayment';
  static var defualtAutoNote = 'Auto';
  static var defualtmanualNote = 'manual';

  // * Data Index /
  static var dataNo = 0;
  static var documentTypeIndex = 1;
  static var distDocDateIndex = 2;
  static var distDocumentNoIndex = 3;
  static var customerIndex = 4;
  static var custBillCityIndex = 5;
  static var matCodeIndex = 6;
  static var matNameIndex = 7;
  static var matTypeIndex = 8;
  static var quantityIndex = 9;
  static var doctorNameIndex = 10;
  static var technicianStaffIndex = 11;
  static var salesAmountIndex = 12;
  static var totalSalesIndex = 13;
  static var smtDocDateIndex = 14;
  static var smtDocNoIndex = 15;
  static var smtInvoiceNoIndex = 16;
  static var purchaseTaxableIndex = 17;
  static var totalPurchaseIndex = 18;
  static var hcomissionIndex = 19;
  static var hcAmountIndex = 20;
  static var dcomissionIndex = 21;
  static var dcAmountIndex = 22;
  static var tcomissionIndex = 23;
  static var tcAmountIndex = 24;
}
