import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/checklist_item.dart';
import 'app.dart'; // 你的 MyApp 入口

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();
  // 註冊 Adapter
  Hive.registerAdapter(ChecklistItemAdapter());
  // 開啟 Box
  await Hive.openBox<ChecklistItem>('checklist');

  runApp(MyApp());
}
