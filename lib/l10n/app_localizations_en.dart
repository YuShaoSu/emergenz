// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeTitle => 'Home';

  @override
  String get proceduresTitle => 'Procedures';

  @override
  String get checklistTitle => 'Checklist';

  @override
  String get mapTitle => 'Shelter Map';

  @override
  String get contactsTitle => 'Contacts';

  @override
  String get emergencyKit => 'Emergency Kit';

  @override
  String get resetSelections => 'Reset selections';

  @override
  String get clearList => 'Clear list';

  @override
  String get exportShare => 'Export / Share';

  @override
  String quantity(String quantity) {
    return 'Qty: $quantity';
  }

  @override
  String get listCopiedToClipboard => 'List copied to clipboard';

  @override
  String get all => 'All';

  @override
  String get search => 'Search';

  @override
  String get searchItems => 'Search items...';

  @override
  String get addItem => 'Add Item';

  @override
  String get editItem => 'Edit Item';

  @override
  String get itemName => 'Item Name';

  @override
  String get categoryField => 'Category';

  @override
  String get quantityField => 'Quantity';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get itemNameRequired => 'Item name is required';

  @override
  String get categoryRequired => 'Category is required';

  @override
  String get quantityRequired => 'Quantity is required';

  @override
  String get food => 'Food';

  @override
  String get water => 'Water';

  @override
  String get medical => 'Medical';

  @override
  String get tools => 'Tools';

  @override
  String get clothing => 'Clothing';

  @override
  String get other => 'Other';
}
