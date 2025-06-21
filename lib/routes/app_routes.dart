import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/procedure_screen.dart';
import '../screens/checklist_screen.dart';
import '../screens/map_screen.dart';
import '../screens/contact_screen.dart';

class AppRoutes {
  static const home = '/';
  static const procedures = '/procedures';
  static const checklist = '/checklist';
  static const map = '/map';
  static const contacts = '/contacts';

  static final routes = {
    home: (_) => const HomeScreen(),
    procedures: (_) => const ProcedureScreen(),
    checklist: (_) => const ChecklistScreen(),
    map: (_) => const MapScreen(),
    contacts: (_) => const ContactScreen(),
  };
}
