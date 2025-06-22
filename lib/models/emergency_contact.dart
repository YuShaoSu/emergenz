import 'package:hive/hive.dart';

part 'emergency_contact.g.dart';

@HiveType(typeId: 3)
class EmergencyContact extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String nameZh;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String category; // police, fire, medical, government, etc.

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String descriptionZh;

  @HiveField(7)
  final String iconPath;

  @HiveField(8)
  final bool isPriority;

  @HiveField(9)
  final bool isOffline;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.nameZh,
    required this.phoneNumber,
    required this.category,
    required this.description,
    required this.descriptionZh,
    required this.iconPath,
    this.isPriority = false,
    this.isOffline = true,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      name: json['name'],
      nameZh: json['nameZh'],
      phoneNumber: json['phoneNumber'],
      category: json['category'],
      description: json['description'],
      descriptionZh: json['descriptionZh'],
      iconPath: json['iconPath'],
      isPriority: json['isPriority'] ?? false,
      isOffline: json['isOffline'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameZh': nameZh,
      'phoneNumber': phoneNumber,
      'category': category,
      'description': description,
      'descriptionZh': descriptionZh,
      'iconPath': iconPath,
      'isPriority': isPriority,
      'isOffline': isOffline,
    };
  }
}
