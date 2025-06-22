import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/checklist_item.dart';
import 'models/emergency_procedure.dart';
import 'models/emergency_contact.dart';
import 'models/shelter_location.dart';
import 'app.dart'; // 你的 MyApp 入口

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 註冊 Adapters
  Hive.registerAdapter(ChecklistItemAdapter());
  Hive.registerAdapter(EmergencyProcedureAdapter());
  Hive.registerAdapter(ProcedureStepAdapter());
  Hive.registerAdapter(EmergencyContactAdapter());
  Hive.registerAdapter(ShelterLocationAdapter());

  // 開啟 Boxes
  await Hive.openBox<ChecklistItem>('checklist');
  await Hive.openBox<EmergencyProcedure>('procedures');
  await Hive.openBox<EmergencyContact>('contacts');
  await Hive.openBox<ShelterLocation>('shelters');

  runApp(MyApp());
}
