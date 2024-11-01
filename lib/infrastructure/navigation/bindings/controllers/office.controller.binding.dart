import 'package:get/get.dart';

import '../../../../presentation/office/controllers/office.controller.dart';

class OfficeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfficeController>(
      () => OfficeController(),
    );
  }
}
