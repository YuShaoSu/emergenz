import 'package:hive/hive.dart';

part 'shelter_location.g.dart';

@HiveType(typeId: 4)
class ShelterLocation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String nameZh;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String descriptionZh;

  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  @HiveField(7)
  final String category; // emergency, temporary, permanent, medical, etc.

  @HiveField(8)
  final String address;

  @HiveField(9)
  final String addressZh;

  @HiveField(10)
  final String phoneNumber;

  @HiveField(11)
  final int capacity;

  @HiveField(12)
  final List<String> facilities; // water, food, medical, electricity, etc.

  @HiveField(13)
  final List<String> facilitiesZh;

  @HiveField(14)
  final bool isActive;

  @HiveField(15)
  final DateTime lastUpdated;

  @HiveField(16)
  final String district; // Taipei districts

  @HiveField(17)
  final String districtZh;

  @HiveField(18)
  final bool isAccessible; // wheelchair accessible

  @HiveField(19)
  final bool hasParking;

  @HiveField(20)
  final String operatingHours;

  @HiveField(21)
  final String operatingHoursZh;

  ShelterLocation({
    required this.id,
    required this.name,
    required this.nameZh,
    required this.description,
    required this.descriptionZh,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.address,
    required this.addressZh,
    required this.phoneNumber,
    required this.capacity,
    required this.facilities,
    required this.facilitiesZh,
    this.isActive = true,
    required this.lastUpdated,
    required this.district,
    required this.districtZh,
    this.isAccessible = false,
    this.hasParking = false,
    required this.operatingHours,
    required this.operatingHoursZh,
  });

  factory ShelterLocation.fromJson(Map<String, dynamic> json) {
    return ShelterLocation(
      id: json['id'],
      name: json['name'],
      nameZh: json['nameZh'],
      description: json['description'],
      descriptionZh: json['descriptionZh'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      category: json['category'],
      address: json['address'],
      addressZh: json['addressZh'],
      phoneNumber: json['phoneNumber'],
      capacity: json['capacity'],
      facilities: List<String>.from(json['facilities']),
      facilitiesZh: List<String>.from(json['facilitiesZh']),
      isActive: json['isActive'] ?? true,
      lastUpdated: DateTime.parse(json['lastUpdated']),
      district: json['district'],
      districtZh: json['districtZh'],
      isAccessible: json['isAccessible'] ?? false,
      hasParking: json['hasParking'] ?? false,
      operatingHours: json['operatingHours'],
      operatingHoursZh: json['operatingHoursZh'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameZh': nameZh,
      'description': description,
      'descriptionZh': descriptionZh,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'address': address,
      'addressZh': addressZh,
      'phoneNumber': phoneNumber,
      'capacity': capacity,
      'facilities': facilities,
      'facilitiesZh': facilitiesZh,
      'isActive': isActive,
      'lastUpdated': lastUpdated.toIso8601String(),
      'district': district,
      'districtZh': districtZh,
      'isAccessible': isAccessible,
      'hasParking': hasParking,
      'operatingHours': operatingHours,
      'operatingHoursZh': operatingHoursZh,
    };
  }
}
