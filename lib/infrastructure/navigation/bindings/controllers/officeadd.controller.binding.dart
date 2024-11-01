import 'package:get/get.dart';

import '../../../../presentation/officeadd/controllers/officeadd.controller.dart';

class OfficeaddControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfficeaddController>(
      () => OfficeaddController(),
    );
  }
}
