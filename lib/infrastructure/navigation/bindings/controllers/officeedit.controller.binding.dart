import 'package:get/get.dart';

import '../../../../presentation/officeedit/controllers/officeedit.controller.dart';

class OfficeeditControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfficeeditController>(
      () => OfficeeditController(),
    );
  }
}
