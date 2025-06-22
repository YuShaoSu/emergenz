import 'package:hive/hive.dart';

part 'emergency_procedure.g.dart';

@HiveType(typeId: 1)
class EmergencyProcedure extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String titleZh;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String descriptionZh;

  @HiveField(5)
  final String category; // earthquake, typhoon, war, fire, etc.

  @HiveField(6)
  final List<ProcedureStep> steps;

  @HiveField(7)
  final String iconPath;

  @HiveField(8)
  final bool isOffline;

  @HiveField(9)
  final DateTime lastUpdated;

  EmergencyProcedure({
    required this.id,
    required this.title,
    required this.titleZh,
    required this.description,
    required this.descriptionZh,
    required this.category,
    required this.steps,
    required this.iconPath,
    this.isOffline = true,
    required this.lastUpdated,
  });

  factory EmergencyProcedure.fromJson(Map<String, dynamic> json) {
    return EmergencyProcedure(
      id: json['id'],
      title: json['title'],
      titleZh: json['titleZh'],
      description: json['description'],
      descriptionZh: json['descriptionZh'],
      category: json['category'],
      steps: (json['steps'] as List)
          .map((step) => ProcedureStep.fromJson(step))
          .toList(),
      iconPath: json['iconPath'],
      isOffline: json['isOffline'] ?? true,
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'titleZh': titleZh,
      'description': description,
      'descriptionZh': descriptionZh,
      'category': category,
      'steps': steps.map((step) => step.toJson()).toList(),
      'iconPath': iconPath,
      'isOffline': isOffline,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

@HiveType(typeId: 2)
class ProcedureStep extends HiveObject {
  @HiveField(0)
  final int order;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String titleZh;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String descriptionZh;

  @HiveField(5)
  final String? imagePath;

  @HiveField(6)
  final List<String>? tips;

  @HiveField(7)
  final List<String>? tipsZh;

  ProcedureStep({
    required this.order,
    required this.title,
    required this.titleZh,
    required this.description,
    required this.descriptionZh,
    this.imagePath,
    this.tips,
    this.tipsZh,
  });

  factory ProcedureStep.fromJson(Map<String, dynamic> json) {
    return ProcedureStep(
      order: json['order'],
      title: json['title'],
      titleZh: json['titleZh'],
      description: json['description'],
      descriptionZh: json['descriptionZh'],
      imagePath: json['imagePath'],
      tips: json['tips'] != null ? List<String>.from(json['tips']) : null,
      tipsZh: json['tipsZh'] != null ? List<String>.from(json['tipsZh']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'title': title,
      'titleZh': titleZh,
      'description': description,
      'descriptionZh': descriptionZh,
      'imagePath': imagePath,
      'tips': tips,
      'tipsZh': tipsZh,
    };
  }
}
