import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_sahril/data/model/office_model.dart';
import 'package:test_sahril/presentation/office/controllers/office.controller.dart';

class OfficeaddScreen extends GetView<OfficeController> {
  const OfficeaddScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Office Add Screen'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          return controller.isLoaadingUserLocation.value
              ? Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: MapController(),
                  options: MapOptions(
                    initialCenter: controller.userLocation!,
                    initialZoom: 13.0,
                    onTap: (tapPosition, point) {
                      print(
                          'Tapped location: ${point.latitude}, ${point.longitude}');

                      // Menyiapkan controller untuk input
                      TextEditingController nameController =
                          TextEditingController();
                      TextEditingController waktuMasukController =
                          TextEditingController();
                      TextEditingController waktuPulangController =
                          TextEditingController();
                      TextEditingController radiusController =
                          TextEditingController();

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

                                // Menambahkan office baru
                                controller.addOffice(Office(
                                  radius: int.parse(radius),
                                  name: name,
                                  waktuMasuk: waktuMasuk,
                                  waktuPulang: waktuPulang,
                                  latitude: latitude,
                                  longitude: longitude,
                                  createdAt: createdAt,
                                ));
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
                    MarkerLayer(
                      markers: [
                        controller.markers[0],
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}
