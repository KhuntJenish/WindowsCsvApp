import '../database/tables.dart';

class Constantdata {
  static final db = MyDatabase();
  //database table name
  // static var partyMaster = $PartyMasterTable;
  // static var partyTypeMaster = $PartyTypeMasterTable;
  // static var user = $UserTable;
  static var payment = 'payment';
  static var extraPayment = 'ExtraPayment';
  static var defualtAutoNote = 'Auto';
  static var defualtmanualNote = 'manual';
}
