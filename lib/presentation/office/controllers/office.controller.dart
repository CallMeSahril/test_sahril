import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:test_sahril/data/local/office_local.dart';
import 'package:test_sahril/data/model/office_model.dart';

class OfficeController extends GetxController {
  final OfficeDatabase _officeDatabase = OfficeDatabase.instance;
  final MapController mapController = MapController();

  Rx<LatLng>? selectedLocation;

  // Update selected location
  void updateLocation(LatLng newLocation) {
    selectedLocation!.value = newLocation;
  }

  LatLng? userLocation; // Lokasi perangkat pengguna
  var isLoaadingUserLocation = false.obs;
  var isLoadingFetchOffices = false.obs;
  var isloadingfetchOfficeById = false.obs;
  var officeList = <Office>[].obs;
  var selectedOffice =
      Rxn<Office>(); // Office yang dipilih untuk detail atau edit
  var selectedOfficeFetchOfficeById =
      Rxn<Office>(); // Office yang dipilih untuk detail atau edit
  List<Marker> markers = []; // Set untuk menyimpan markers
  LatLng? currentLocation;

  @override
  void onInit() {
    super.onInit();
    fetchOffices();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    isLoaadingUserLocation(true);

    // Cek apakah layanan lokasi aktif
    if (!await Geolocator.isLocationServiceEnabled()) {
      // Tampilkan dialog atau pesan kepada pengguna
      print('Location services are disabled. Please enable them.');
      isLoaadingUserLocation(false);
      return;
    }

    // Cek izin lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Meminta izin lokasi
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Tampilkan dialog atau pesan kepada pengguna
        print(
            'Location permission denied. Please allow location access in settings.');
        isLoaadingUserLocation(false);
        return;
      }
    }

    // Jika izin diberikan, ambil lokasi
    try {
      Position position = await Geolocator.getCurrentPosition();
      userLocation = LatLng(position.latitude, position.longitude);
      currentLocation = userLocation;

      // Update marker lokasi pengguna
      markers.add(Marker(
        point: currentLocation!,
        width: 30,
        height: 30,
        child: Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 30,
        ),
      ));
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      isLoaadingUserLocation(false);
      update(); // Memperbarui tampilan
    }
  }

  // Fungsi untuk menambah Office baru
  Future<void> addOffice(Office office) async {
    final newOffice = await _officeDatabase.create(office);
    officeList.add(newOffice);
  }

  // Fungsi untuk mengambil semua data Office
  Future<void> fetchOffices() async {
    isLoadingFetchOffices(true);
    final offices = await _officeDatabase.readAllOffices();
    officeList.value = offices;
    isLoadingFetchOffices(false);
  }

  // Fungsi untuk mengambil data Office berdasarkan ID
  Future<void> fetchOfficeById(int id) async {
    isloadingfetchOfficeById(true);
    final office = await _officeDatabase.readOffice(1);
    selectedOfficeFetchOfficeById.value =
        office; // Menyimpan data Office yang dipilih
    isloadingfetchOfficeById(false);
  }

  // Fungsi untuk memperbarui Office berdasarkan ID
  Future<void> updateOfficeById(int id, Office updatedOffice) async {
    final updatedRows = await _officeDatabase.update(updatedOffice);

    if (updatedRows > 0) {
      print('Update berhasil: $updatedRows baris terpengaruh.');
      fetchOffices(); // Memperbarui daftar kantor di UI setelah pembaruan
      selectedOffice.value =
          updatedOffice; // Memperbarui office yang dipilih dengan data terbaru
    } else {
      print('Update gagal, tidak ada baris yang terpengaruh.');
    }
  }

  // Fungsi untuk menghapus Office berdasarkan ID
  Future<void> deleteOffice(int id) async {
    await _officeDatabase.delete(id);
    officeList.removeWhere((office) => office.id == id);
  }

  // Fungsi untuk pulang berdasarkan lokasi
  Future<void> pulang() async {
    if (userLocation == null) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Gagal Pulang'),
          content: Text('Lokasi pengguna tidak ditemukan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    // Pilih kantor dengan ID 1
    await fetchOfficeById(1);
    // Radius dalam meter
    const double radius = 100.0;

    // Cek apakah ada office yang dipilih
    if (selectedOfficeFetchOfficeById.value == null) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Gagal Pulang'),
          content: Text('Tidak ada kantor yang dipilih.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Hitung jarak antara lokasi pengguna dan lokasi office yang dipilih
    double distance = Geolocator.distanceBetween(
      userLocation!.latitude,
      userLocation!.longitude,
      selectedOfficeFetchOfficeById.value!.latitude,
      selectedOfficeFetchOfficeById.value!.longitude,
    );

    if (distance <= radius) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Berhasil Pulang'),
          content: Text('Anda berhasil pulang.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Gagal Pulang'),
          content: Text('Anda berada di luar radius pulang.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Fungsi untuk absen berdasarkan lokasi
  Future<void> absen() async {
    if (userLocation == null) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Gagal Absen'),
          content: Text('Lokasi pengguna tidak ditemukan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    // Pilih kantor dengan ID 1
    await fetchOfficeById(1);
    // Radius dalam meter
    const double radius = 100.0;

    // Cek apakah ada office yang dipilih
    if (selectedOfficeFetchOfficeById.value == null) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Gagal Absen'),
          content: Text('Tidak ada kantor yang dipilih.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Hitung jarak antara lokasi pengguna dan lokasi office yang dipilih
    double distance = Geolocator.distanceBetween(
      userLocation!.latitude,
      userLocation!.longitude,
      selectedOfficeFetchOfficeById.value!.latitude,
      selectedOfficeFetchOfficeById.value!.longitude,
    );

    if (distance <= radius) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Berhasil Absen'),
          content: Text('Anda berhasil absen.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Gagal Absen'),
          content: Text('Anda berada di luar radius absen.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
