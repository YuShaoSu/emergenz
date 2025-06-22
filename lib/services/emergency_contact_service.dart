import 'package:hive_flutter/hive_flutter.dart';
import '../models/emergency_contact.dart';

class EmergencyContactService {
  static const String _boxName = 'contacts';
  late Box<EmergencyContact> _box;

  Future<void> initialize() async {
    _box = Hive.box<EmergencyContact>(_boxName);
    await _loadDefaultData();
  }

  Future<void> _loadDefaultData() async {
    if (_box.isEmpty) {
      final defaultContacts = [
        // Police
        EmergencyContact(
          id: 'police_110',
          name: 'Police Emergency',
          nameZh: '警察緊急電話',
          phoneNumber: '110',
          category: 'police',
          description: 'Emergency police assistance',
          descriptionZh: '緊急警察協助',
          iconPath: 'assets/icons/police.png',
          isPriority: true,
          isOffline: true,
        ),
        EmergencyContact(
          id: 'police_taipei',
          name: 'Taipei Police Department',
          nameZh: '台北市警察局',
          phoneNumber: '02-2341-6100',
          category: 'police',
          description: 'Taipei City Police Department main line',
          descriptionZh: '台北市警察局總機',
          iconPath: 'assets/icons/police.png',
          isPriority: false,
          isOffline: true,
        ),

        // Fire
        EmergencyContact(
          id: 'fire_119',
          name: 'Fire Emergency',
          nameZh: '消防緊急電話',
          phoneNumber: '119',
          category: 'fire',
          description: 'Emergency fire and rescue services',
          descriptionZh: '緊急消防和救援服務',
          iconPath: 'assets/icons/fire.png',
          isPriority: true,
          isOffline: true,
        ),
        EmergencyContact(
          id: 'fire_taipei',
          name: 'Taipei Fire Department',
          nameZh: '台北市消防局',
          phoneNumber: '02-2729-7668',
          category: 'fire',
          description: 'Taipei City Fire Department main line',
          descriptionZh: '台北市消防局總機',
          iconPath: 'assets/icons/fire.png',
          isPriority: false,
          isOffline: true,
        ),

        // Medical
        EmergencyContact(
          id: 'medical_119',
          name: 'Medical Emergency',
          nameZh: '醫療緊急電話',
          phoneNumber: '119',
          category: 'medical',
          description: 'Emergency medical services and ambulance',
          descriptionZh: '緊急醫療服務和救護車',
          iconPath: 'assets/icons/medical.png',
          isPriority: true,
          isOffline: true,
        ),
        EmergencyContact(
          id: 'medical_1922',
          name: 'CDC Hotline',
          nameZh: '疾病管制署專線',
          phoneNumber: '1922',
          category: 'medical',
          description: 'Centers for Disease Control hotline',
          descriptionZh: '疾病管制署專線',
          iconPath: 'assets/icons/medical.png',
          isPriority: false,
          isOffline: true,
        ),

        // Government
        EmergencyContact(
          id: 'gov_1999',
          name: 'Government Service Hotline',
          nameZh: '政府服務專線',
          phoneNumber: '1999',
          category: 'government',
          description: 'Government information and services',
          descriptionZh: '政府資訊和服務',
          iconPath: 'assets/icons/government.png',
          isPriority: false,
          isOffline: true,
        ),
        EmergencyContact(
          id: 'gov_emergency',
          name: 'Emergency Management Center',
          nameZh: '緊急應變中心',
          phoneNumber: '02-8195-9119',
          category: 'government',
          description: 'National Emergency Management Center',
          descriptionZh: '國家緊急應變中心',
          iconPath: 'assets/icons/government.png',
          isPriority: true,
          isOffline: true,
        ),

        // Utilities
        EmergencyContact(
          id: 'power_taiwan',
          name: 'Taiwan Power Company',
          nameZh: '台灣電力公司',
          phoneNumber: '1911',
          category: 'utilities',
          description: 'Power outage and electrical emergencies',
          descriptionZh: '停電和電氣緊急情況',
          iconPath: 'assets/icons/power.png',
          isPriority: false,
          isOffline: true,
        ),
        EmergencyContact(
          id: 'water_taipei',
          name: 'Taipei Water Department',
          nameZh: '台北自來水事業處',
          phoneNumber: '02-8733-5678',
          category: 'utilities',
          description: 'Water service and emergencies',
          descriptionZh: '供水服務和緊急情況',
          iconPath: 'assets/icons/water.png',
          isPriority: false,
          isOffline: true,
        ),
        EmergencyContact(
          id: 'gas_taipei',
          name: 'Taipei Gas Company',
          nameZh: '台北瓦斯公司',
          phoneNumber: '02-2772-3456',
          category: 'utilities',
          description: 'Gas service and emergencies',
          descriptionZh: '瓦斯服務和緊急情況',
          iconPath: 'assets/icons/gas.png',
          isPriority: false,
          isOffline: true,
        ),

        // Transportation
        EmergencyContact(
          id: 'transport_mrt',
          name: 'Taipei MRT',
          nameZh: '台北捷運',
          phoneNumber: '02-2181-2345',
          category: 'transportation',
          description: 'Taipei Metro Rapid Transit',
          descriptionZh: '台北大眾捷運',
          iconPath: 'assets/icons/transport.png',
          isPriority: false,
          isOffline: true,
        ),
        EmergencyContact(
          id: 'transport_bus',
          name: 'Taipei Bus',
          nameZh: '台北公車',
          phoneNumber: '02-2729-1181',
          category: 'transportation',
          description: 'Taipei Bus Company',
          descriptionZh: '台北市公車處',
          iconPath: 'assets/icons/transport.png',
          isPriority: false,
          isOffline: true,
        ),

        // NGOs
        EmergencyContact(
          id: 'redcross',
          name: 'Red Cross Society',
          nameZh: '紅十字會',
          phoneNumber: '02-2362-8232',
          category: 'ngo',
          description: 'Taiwan Red Cross Society',
          descriptionZh: '中華民國紅十字會',
          iconPath: 'assets/icons/ngo.png',
          isPriority: false,
          isOffline: true,
        ),
        EmergencyContact(
          id: 'worldvision',
          name: 'World Vision Taiwan',
          nameZh: '世界展望會',
          phoneNumber: '02-2175-1995',
          category: 'ngo',
          description: 'World Vision Taiwan',
          descriptionZh: '台灣世界展望會',
          iconPath: 'assets/icons/ngo.png',
          isPriority: false,
          isOffline: true,
        ),

        // Weather
        EmergencyContact(
          id: 'weather_cwb',
          name: 'Central Weather Bureau',
          nameZh: '中央氣象局',
          phoneNumber: '02-2349-1000',
          category: 'weather',
          description: 'Weather information and forecasts',
          descriptionZh: '天氣資訊和預報',
          iconPath: 'assets/icons/weather.png',
          isPriority: false,
          isOffline: true,
        ),
      ];

      for (final contact in defaultContacts) {
        await _box.put(contact.id, contact);
      }
    }
  }

  // Get all contacts
  List<EmergencyContact> getAllContacts() {
    return _box.values.toList();
  }

  // Get contacts by category
  List<EmergencyContact> getContactsByCategory(String category) {
    return _box.values
        .where((contact) => contact.category == category)
        .toList();
  }

  // Get priority contacts
  List<EmergencyContact> getPriorityContacts() {
    return _box.values.where((contact) => contact.isPriority).toList();
  }

  // Get contact by ID
  EmergencyContact? getContactById(String id) {
    return _box.get(id);
  }

  // Search contacts
  List<EmergencyContact> searchContacts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _box.values.where((contact) {
      return contact.name.toLowerCase().contains(lowercaseQuery) ||
          contact.nameZh.contains(query) ||
          contact.description.toLowerCase().contains(lowercaseQuery) ||
          contact.descriptionZh.contains(query) ||
          contact.phoneNumber.contains(query);
    }).toList();
  }

  // Add new contact
  Future<void> addContact(EmergencyContact contact) async {
    await _box.put(contact.id, contact);
  }

  // Update contact
  Future<void> updateContact(EmergencyContact contact) async {
    await _box.put(contact.id, contact);
  }

  // Delete contact
  Future<void> deleteContact(String id) async {
    await _box.delete(id);
  }

  // Get categories
  List<String> getCategories() {
    return _box.values.map((contact) => contact.category).toSet().toList();
  }

  // Clear all data
  Future<void> clearAll() async {
    await _box.clear();
  }
}
