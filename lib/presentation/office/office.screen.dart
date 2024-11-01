import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:test_sahril/infrastructure/navigation/routes.dart';

import 'controllers/office.controller.dart';

class OfficeScreen extends GetView<OfficeController> {
  const OfficeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Office'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.isLoadingFetchOffices.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (controller.officeList.isEmpty) {
              return Center(child: Text('No data'));
            } else {
              return ListView.builder(
                itemCount: controller.officeList.length,
                itemBuilder: (context, index) {
                  final office = controller.officeList[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.OFFICEDETAIL, arguments: office);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(office.name),
                        trailing: IconButton(
                            onPressed: () {
                              controller.deleteOffice(office.id);
                            },
                            icon: Icon(Icons.delete)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Masuk: ${office.waktuMasuk}'),
                            Text('Pulang: ${office.waktuPulang}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.OFFICEADD);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
