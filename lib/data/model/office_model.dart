class Office {
  final int id;
  final String name;
  final String waktuMasuk;
  final String waktuPulang;
  final double latitude;
  final double longitude;
  final int radius; // Ubah ini ke int untuk mencocokkan dengan database
  final DateTime createdAt;

  Office({
    this.id = 0, // Default id as 0; it will be ignored for new entries.
    required this.name,
    required this.waktuMasuk,
    required this.waktuPulang,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.createdAt,
  });

  // Convert Office object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id > 0 ? id : null, // id is null for new entries to auto-generate
      'name': name,
      'radius': radius, // Pastikan radius di sini
      'waktuMasuk': waktuMasuk,
      'waktuPulang': waktuPulang,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create an Office object from a Map
  factory Office.fromMap(Map<String, dynamic> map) {
    return Office(
      id: map['id'],
      name: map['name'],
      radius: map['radius'], // Pastikan radius diambil dari map
      waktuMasuk: map['waktuMasuk'],
      waktuPulang: map['waktuPulang'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Create a copy of an Office object with optional new values
  Office copy({
    int? id,
    String? name,
    String? waktuMasuk,
    String? waktuPulang,
    int? radius,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  }) {
    return Office(
      id: id ?? this.id,
      name: name ?? this.name,
      radius: radius ?? this.radius,
      waktuMasuk: waktuMasuk ?? this.waktuMasuk,
      waktuPulang: waktuPulang ?? this.waktuPulang,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
