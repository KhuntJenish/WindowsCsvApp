import 'package:csvapp/screen/homepage/homecontroller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageController>(
      () => HomepageController(),
    );
  }
}
