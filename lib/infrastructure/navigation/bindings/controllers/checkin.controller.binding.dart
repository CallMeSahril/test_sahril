import 'package:get/get.dart';

import '../../../../presentation/checkin/controllers/checkin.controller.dart';

class CheckinControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckinController>(
      () => CheckinController(),
    );
  }
}
