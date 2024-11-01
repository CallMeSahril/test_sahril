import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_sahril/presentation/office/controllers/office.controller.dart';

import 'controllers/checkin.controller.dart';

class CheckinScreen extends GetView<OfficeController> {
  const CheckinScreen({super.key});
  @override
  Widget build(BuildContext context) {
    controller.getCurrentLocation();
    controller.fetchOfficeById(1);
    return Scaffold(
        appBar: AppBar(
          title: const Text('CheckinScreen'),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoaadingUserLocation.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(
                          controller
                              .selectedOfficeFetchOfficeById.value!.latitude,
                          controller
                              .selectedOfficeFetchOfficeById.value!.longitude),
                      // initialCenter: LatLng(double.parse("${office.latitude}"),
                      //     double.parse("${office.longitude}")),
                      // onTap: (tapPosition, point) {
                      //   Get.toNamed(Routes.OFFICEEDIT, arguments: office);
                      // },
                      initialZoom: 18.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.drag |
                            InteractiveFlag.flingAnimation |
                            InteractiveFlag.pinchZoom |
                            InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c', 'd'],
                      ),
                      MarkerLayer(markers: [
                        Marker(
                          point: controller.currentLocation!,
                          width: 30,
                          height: 30,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(
                              controller.selectedOfficeFetchOfficeById.value!
                                  .latitude,
                              controller.selectedOfficeFetchOfficeById.value!
                                  .longitude),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ]),
                      CircleLayer(circles: [
                        CircleMarker(
                          point: LatLng(
                              controller.selectedOfficeFetchOfficeById.value!
                                  .latitude,
                              controller.selectedOfficeFetchOfficeById.value!
                                  .longitude),
                          color: Colors.redAccent.withOpacity(0.3),
                          radius: controller
                              .selectedOfficeFetchOfficeById.value!.radius
                              .toDouble(),
                          useRadiusInMeter: true,
                          borderStrokeWidth: 2.0,
                          borderColor: Colors.redAccent,
                        )
                      ]),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your check-in logic here
                    controller.absen();
                  },
                  child: Text('Check In'),
                )
              ],
            );
          }
        }));
  }
}
