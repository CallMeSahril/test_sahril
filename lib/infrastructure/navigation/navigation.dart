import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../presentation/screens.dart';
import 'bindings/controllers/controllers_bindings.dart';
import 'routes.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
    ),
    GetPage(
      name: Routes.OFFICE,
      page: () => const OfficeScreen(),
      binding: OfficeControllerBinding(),
    ),
    GetPage(
      name: Routes.OFFICEADD,
      page: () => const OfficeaddScreen(),
      binding: OfficeControllerBinding(),
    ),
    GetPage(
      name: Routes.OFFICEDETAIL,
      page: () => const OfficedetailScreen(),
      binding: OfficeControllerBinding(),
    ),
    GetPage(
      name: Routes.OFFICEEDIT,
      page: () => const OfficeeditScreen(),
      binding: OfficeeditControllerBinding(),
    ),
    GetPage(
      name: Routes.CHECKIN,
      page: () => const CheckinScreen(),
      binding: OfficeControllerBinding(),
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => const CheckoutScreen(),
      binding: OfficeControllerBinding(),
    ),
  ];
}
