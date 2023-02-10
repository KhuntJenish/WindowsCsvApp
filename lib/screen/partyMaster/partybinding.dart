import 'package:csvapp/screen/partyMaster/partyController.dart';
import 'package:get/get.dart';

class PartyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartyController>(
      () => PartyController(),
    );
  }
}
