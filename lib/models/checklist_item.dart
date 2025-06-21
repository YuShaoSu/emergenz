// lib/models/checklist_item.dart
import 'package:hive/hive.dart';

part 'checklist_item.g.dart';

@HiveType(typeId: 0)
class ChecklistItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String category;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  String note;

  @HiveField(5)
  bool done;

  ChecklistItem({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    this.note = '',
    this.done = false,
  });
}
