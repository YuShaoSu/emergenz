import 'package:flutter/material.dart';
import 'package:emergency_app_flutter/l10n/app_localizations.dart';
import 'home_screen.dart';
import 'procedure_screen.dart';
import 'checklist_screen.dart';
import 'map_screen.dart';
import 'contact_screen.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ProcedureScreen(),
    ChecklistScreen(),
    MapScreen(),
    ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: localizations.homeTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book_outlined),
            label: localizations.proceduresTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.checklist_outlined),
            label: localizations.checklistTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map_outlined),
            label: localizations.mapTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.phone_in_talk_outlined),
            label: localizations.contactsTitle,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF001F3F),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
