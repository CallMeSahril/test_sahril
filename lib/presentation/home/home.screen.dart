import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:test_sahril/infrastructure/navigation/routes.dart';

import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahril Test Attandance'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          items.length,
          (index) {
            return GestureDetector(
              onTap: items[index]['onTap'],
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items[index]['icon'], size: 50),
                    SizedBox(height: 10),
                    Text('Item ${items[index]['title']}',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> items = [
  {
    'title': 'Office',
    'icon': Icons.business,
    'onTap': () {
      Get.toNamed(Routes.OFFICE);
    },
  },
  {
    'title': 'Check In',
    'icon': Icons.login,
    'onTap': () {
      Get.toNamed(Routes.CHECKIN);
    },
  },
  {
    'title': 'Check Out',
    'icon': Icons.logout,
    'onTap': () {
      // Handle Check Out tap
    },
  },
];
