import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_sahril/data/model/office_model.dart';
import 'package:test_sahril/infrastructure/navigation/routes.dart';
import 'package:test_sahril/presentation/office/controllers/office.controller.dart';

class OfficedetailScreen extends GetView<OfficeController> {
  const OfficedetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Office office = Get.arguments;
    return Scaffold(
        appBar: AppBar(
          title: const Text('OfficedetailScreen'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama: ${office.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Waktu Masuk: ${office.waktuMasuk}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Waktu Pulang: ${office.waktuPulang}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(double.parse("${office.latitude}"),
                        double.parse("${office.longitude}")),
                    onTap: (tapPosition, point) {
                      Get.toNamed(Routes.OFFICEEDIT, arguments: office);
                    },
                    initialZoom: 18.0,
                    interactionOptions:
                        const InteractionOptions(flags: InteractiveFlag.none),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                    ),
                    MarkerLayer(markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(double.parse("${office.latitude}"),
                            double.parse("${office.longitude}")),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ]),
                    CircleLayer(circles: [
                      CircleMarker(
                        point: LatLng(double.parse("${office.latitude}"),
                            double.parse("${office.longitude}")),
                        color: Colors.redAccent.withOpacity(0.3),
                        radius: office.radius.toDouble(),
                        useRadiusInMeter: true,
                        borderStrokeWidth: 2.0,
                        borderColor: Colors.redAccent,
                      )
                    ]),
                  ],
                ),
              )
              // Expanded(
              //   child: GoogleMap(
              //     initialCameraPosition: CameraPosition(
              //       target: LatLng(controller.officeDetail.latitude,
              //           controller.officeDetail.longitude),
              //       zoom: 14.0,
              //     ),
              //     markers: {
              //       Marker(
              //         markerId: MarkerId('officeLocation'),
              //         position: LatLng(controller.officeDetail.latitude,
              //             controller.officeDetail.longitude),
              //       ),
              //     },
              //   ),
              // ),
            ],
          ),
        ));
  }
}
