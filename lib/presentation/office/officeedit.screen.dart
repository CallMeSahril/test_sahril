import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_sahril/data/model/office_model.dart';
import 'package:test_sahril/infrastructure/navigation/routes.dart';
import 'package:test_sahril/presentation/office/controllers/office.controller.dart';

import '../officeedit/controllers/officeedit.controller.dart';

class OfficeeditScreen extends GetView<OfficeController> {
  const OfficeeditScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Office office = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('OfficeeditScreen'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return controller.isLoaadingUserLocation.value
              ? Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: MapController(),
                  options: MapOptions(
                    initialCenter: LatLng(double.parse("${office.latitude}"),
                        double.parse("${office.longitude}")),
                    initialZoom: 18.0,
                    onTap: (tapPosition, point) {
                      print(
                          'Tapped location: ${office.latitude}, ${office.longitude}');

                      // Menyiapkan controller untuk input
                      TextEditingController nameController =
                          TextEditingController(text: "${office.name}");
                      TextEditingController waktuMasukController =
                          TextEditingController(text: "${office.waktuMasuk}");
                      TextEditingController waktuPulangController =
                          TextEditingController(text: "${office.waktuPulang}");
                      TextEditingController radiusController =
                          TextEditingController(text: "${office.radius}");

                      // Menampilkan dialog input
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Add Office Location'),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration:
                                      InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: radiusController,
                                  decoration:
                                      InputDecoration(labelText: 'Radius'),
                                ),
                                TextField(
                                  controller: waktuMasukController,
                                  decoration: InputDecoration(
                                      labelText: 'Waktu Masuk (HH:MM)'),
                                ),
                                TextField(
                                  controller: waktuPulangController,
                                  decoration: InputDecoration(
                                      labelText: 'Waktu Pulang (HH:MM)'),
                                ),
                                Text('Latitude: ${point.latitude}'),
                                Text('Longitude: ${point.longitude}'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Mendapatkan nilai dari TextEditingController
                                String name = nameController.text;
                                String radius = radiusController.text;
                                String waktuMasuk = waktuMasukController.text;
                                String waktuPulang = waktuPulangController.text;
                                double latitude = point.latitude;
                                double longitude = point.longitude;
                                DateTime createdAt = DateTime.now();
                                print("ini id ${office.id}");
                                // Menambahkan office baru
                                controller.updateOfficeById(
                                    office.id,
                                    Office(
                                      id: office.id,
                                      radius: int.parse(radius),
                                      name: name,
                                      waktuMasuk: waktuMasuk,
                                      waktuPulang: waktuPulang,
                                      latitude: latitude,
                                      longitude: longitude,
                                      createdAt: createdAt,
                                    ));
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.drag |
                          InteractiveFlag.flingAnimation |
                          InteractiveFlag.pinchZoom |
                          InteractiveFlag.doubleTapZoom,
                    ),
                  ),
                  // Menambahkan fungsi onTap untuk menangkap lokasi baru

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
                    // MarkerLayer(
                    //   markers: [
                    //     controller.markers[0],
                    //   ],
                    // ),
                  ],
                );
        },
      ),
    );
  }
}
