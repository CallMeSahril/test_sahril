import 'package:get/get.dart';

import '../../../../presentation/officedetail/controllers/officedetail.controller.dart';

class OfficedetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfficedetailController>(
      () => OfficedetailController(),
    );
  }
}
