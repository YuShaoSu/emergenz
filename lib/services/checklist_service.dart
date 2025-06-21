import 'package:hive/hive.dart';
import '../models/checklist_item.dart';

class ChecklistService {
  static final Box<ChecklistItem> _box = Hive.box<ChecklistItem>('checklist');

  static List<ChecklistItem> loadItems() {
    return _box.values.toList();
  }

  static Future<void> addItem(ChecklistItem item) async {
    await _box.put(item.id, item);
  }

  static Future<void> updateItem(ChecklistItem item) async {
    await item.save();
  }

  static Future<void> deleteItem(String id) async {
    await _box.delete(id);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }
}
