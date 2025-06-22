import 'package:hive_flutter/hive_flutter.dart';
import '../models/shelter_location.dart';

class ShelterService {
  static const String _boxName = 'shelters';
  late Box<ShelterLocation> _box;

  Future<void> initialize() async {
    _box = Hive.box<ShelterLocation>(_boxName);
    await _loadDefaultData();
  }

  Future<void> _loadDefaultData() async {
    if (_box.isEmpty) {
      final defaultShelters = [
        // Emergency Shelters - Taipei
        ShelterLocation(
          id: 'shelter_001',
          name: 'Taipei City Hall Emergency Shelter',
          nameZh: '台北市政府緊急避難所',
          description:
              'Primary emergency shelter in Taipei City Hall with full facilities',
          descriptionZh: '台北市政府主要緊急避難所，設施完善',
          latitude: 25.0330,
          longitude: 121.5654,
          category: 'emergency',
          address: 'No. 1, City Hall Road, Xinyi District, Taipei',
          addressZh: '台北市信義區市府路1號',
          phoneNumber: '02-2720-8889',
          capacity: 5000,
          facilities: [
            'water',
            'food',
            'medical',
            'electricity',
            'wifi',
            'bathroom'
          ],
          facilitiesZh: ['飲用水', '食物', '醫療', '電力', '無線網路', '洗手間'],
          isActive: true,
          lastUpdated: DateTime.now(),
          district: 'Xinyi',
          districtZh: '信義區',
          isAccessible: true,
          hasParking: true,
          operatingHours: '24/7',
          operatingHoursZh: '24小時開放',
        ),
        ShelterLocation(
          id: 'shelter_002',
          name: 'Taipei 101 Emergency Shelter',
          nameZh: '台北101緊急避難所',
          description: 'High-capacity shelter in Taipei 101 building',
          descriptionZh: '台北101大樓內高容量避難所',
          latitude: 25.0330,
          longitude: 121.5654,
          category: 'emergency',
          address: 'No. 7, Section 5, Xinyi Road, Xinyi District, Taipei',
          addressZh: '台北市信義區信義路五段7號',
          phoneNumber: '02-8101-8800',
          capacity: 3000,
          facilities: [
            'water',
            'food',
            'medical',
            'electricity',
            'wifi',
            'bathroom',
            'elevator'
          ],
          facilitiesZh: ['飲用水', '食物', '醫療', '電力', '無線網路', '洗手間', '電梯'],
          isActive: true,
          lastUpdated: DateTime.now(),
          district: 'Xinyi',
          districtZh: '信義區',
          isAccessible: true,
          hasParking: true,
          operatingHours: '24/7',
          operatingHoursZh: '24小時開放',
        ),

        // Temporary Shelters
        ShelterLocation(
          id: 'shelter_003',
          name: 'Taipei Main Station Temporary Shelter',
          nameZh: '台北車站臨時避難所',
          description:
              'Temporary shelter at Taipei Main Station for transit emergencies',
          descriptionZh: '台北車站臨時避難所，用於交通緊急情況',
          latitude: 25.0478,
          longitude: 121.5170,
          category: 'temporary',
          address: 'No. 49, Beiping West Road, Zhongzheng District, Taipei',
          addressZh: '台北市中正區北平西路49號',
          phoneNumber: '02-2371-3558',
          capacity: 2000,
          facilities: ['water', 'food', 'electricity', 'wifi', 'bathroom'],
          facilitiesZh: ['飲用水', '食物', '電力', '無線網路', '洗手間'],
          isActive: true,
          lastUpdated: DateTime.now(),
          district: 'Zhongzheng',
          districtZh: '中正區',
          isAccessible: true,
          hasParking: false,
          operatingHours: '24/7',
          operatingHoursZh: '24小時開放',
        ),

        // Medical Shelters
        ShelterLocation(
          id: 'shelter_004',
          name: 'National Taiwan University Hospital Emergency Shelter',
          nameZh: '台大醫院緊急避難所',
          description: 'Medical emergency shelter with full medical facilities',
          descriptionZh: '具備完整醫療設施的醫療緊急避難所',
          latitude: 25.0170,
          longitude: 121.5098,
          category: 'medical',
          address: 'No. 1, Changde Street, Zhongzheng District, Taipei',
          addressZh: '台北市中正區常德街1號',
          phoneNumber: '02-2312-3456',
          capacity: 1500,
          facilities: [
            'water',
            'food',
            'medical',
            'electricity',
            'wifi',
            'bathroom',
            'pharmacy',
            'emergency_room'
          ],
          facilitiesZh: ['飲用水', '食物', '醫療', '電力', '無線網路', '洗手間', '藥房', '急診室'],
          isActive: true,
          lastUpdated: DateTime.now(),
          district: 'Zhongzheng',
          districtZh: '中正區',
          isAccessible: true,
          hasParking: true,
          operatingHours: '24/7',
          operatingHoursZh: '24小時開放',
        ),

        // Community Centers
        ShelterLocation(
          id: 'shelter_005',
          name: 'Shilin Community Center Shelter',
          nameZh: '士林社區中心避難所',
          description: 'Community center converted to emergency shelter',
          descriptionZh: '社區中心改建的緊急避難所',
          latitude: 25.0928,
          longitude: 121.5207,
          category: 'community',
          address: 'No. 100, Zhongzheng Road, Shilin District, Taipei',
          addressZh: '台北市士林區中正路100號',
          phoneNumber: '02-2881-2345',
          capacity: 800,
          facilities: [
            'water',
            'food',
            'electricity',
            'wifi',
            'bathroom',
            'kitchen'
          ],
          facilitiesZh: ['飲用水', '食物', '電力', '無線網路', '洗手間', '廚房'],
          isActive: true,
          lastUpdated: DateTime.now(),
          district: 'Shilin',
          districtZh: '士林區',
          isAccessible: true,
          hasParking: true,
          operatingHours: '6:00 AM - 10:00 PM',
          operatingHoursZh: '上午6:00 - 晚上10:00',
        ),

        // Schools
        ShelterLocation(
          id: 'shelter_006',
          name: 'Taipei First Girls High School Shelter',
          nameZh: '北一女中避難所',
          description: 'School building converted to emergency shelter',
          descriptionZh: '學校建築改建的緊急避難所',
          latitude: 25.0330,
          longitude: 121.5098,
          category: 'school',
          address:
              'No. 165, Zhongxiao East Road, Section 1, Zhongzheng District, Taipei',
          addressZh: '台北市中正區忠孝東路一段165號',
          phoneNumber: '02-2321-6256',
          capacity: 1200,
          facilities: [
            'water',
            'food',
            'electricity',
            'wifi',
            'bathroom',
            'classroom',
            'gym'
          ],
          facilitiesZh: ['飲用水', '食物', '電力', '無線網路', '洗手間', '教室', '體育館'],
          isActive: true,
          lastUpdated: DateTime.now(),
          district: 'Zhongzheng',
          districtZh: '中正區',
          isAccessible: true,
          hasParking: true,
          operatingHours: '24/7',
          operatingHoursZh: '24小時開放',
        ),

        // Permanent Shelters
        ShelterLocation(
          id: 'shelter_007',
          name: 'Taipei Civil Defense Shelter',
          nameZh: '台北民防避難所',
          description:
              'Permanent civil defense shelter with reinforced structure',
          descriptionZh: '永久性民防避難所，具備強化結構',
          latitude: 25.0330,
          longitude: 121.5654,
          category: 'permanent',
          address:
              'No. 50, Section 1, Roosevelt Road, Zhongzheng District, Taipei',
          addressZh: '台北市中正區羅斯福路一段50號',
          phoneNumber: '02-2341-2345',
          capacity: 3000,
          facilities: [
            'water',
            'food',
            'medical',
            'electricity',
            'wifi',
            'bathroom',
            'generator',
            'air_filter'
          ],
          facilitiesZh: [
            '飲用水',
            '食物',
            '醫療',
            '電力',
            '無線網路',
            '洗手間',
            '發電機',
            '空氣過濾器'
          ],
          isActive: true,
          lastUpdated: DateTime.now(),
          district: 'Zhongzheng',
          districtZh: '中正區',
          isAccessible: true,
          hasParking: true,
          operatingHours: '24/7',
          operatingHoursZh: '24小時開放',
        ),
      ];

      for (final shelter in defaultShelters) {
        await _box.put(shelter.id, shelter);
      }
    }
  }

  // Get all shelters
  List<ShelterLocation> getAllShelters() {
    return _box.values.toList();
  }

  // Get shelters by category
  List<ShelterLocation> getSheltersByCategory(String category) {
    return _box.values
        .where((shelter) => shelter.category == category)
        .toList();
  }

  // Get shelters by district
  List<ShelterLocation> getSheltersByDistrict(String district) {
    return _box.values
        .where((shelter) => shelter.district == district)
        .toList();
  }

  // Get active shelters
  List<ShelterLocation> getActiveShelters() {
    return _box.values.where((shelter) => shelter.isActive).toList();
  }

  // Get shelter by ID
  ShelterLocation? getShelterById(String id) {
    return _box.get(id);
  }

  // Search shelters
  List<ShelterLocation> searchShelters(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _box.values.where((shelter) {
      return shelter.name.toLowerCase().contains(lowercaseQuery) ||
          shelter.nameZh.contains(query) ||
          shelter.description.toLowerCase().contains(lowercaseQuery) ||
          shelter.descriptionZh.contains(query) ||
          shelter.address.toLowerCase().contains(lowercaseQuery) ||
          shelter.addressZh.contains(query) ||
          shelter.district.toLowerCase().contains(lowercaseQuery) ||
          shelter.districtZh.contains(query);
    }).toList();
  }

  // Get shelters with specific facilities
  List<ShelterLocation> getSheltersWithFacility(String facility) {
    return _box.values
        .where((shelter) => shelter.facilities.contains(facility))
        .toList();
  }

  // Get accessible shelters
  List<ShelterLocation> getAccessibleShelters() {
    return _box.values.where((shelter) => shelter.isAccessible).toList();
  }

  // Get shelters with parking
  List<ShelterLocation> getSheltersWithParking() {
    return _box.values.where((shelter) => shelter.hasParking).toList();
  }

  // Add new shelter
  Future<void> addShelter(ShelterLocation shelter) async {
    await _box.put(shelter.id, shelter);
  }

  // Update shelter
  Future<void> updateShelter(ShelterLocation shelter) async {
    await _box.put(shelter.id, shelter);
  }

  // Delete shelter
  Future<void> deleteShelter(String id) async {
    await _box.delete(id);
  }

  // Get categories
  List<String> getCategories() {
    return _box.values.map((shelter) => shelter.category).toSet().toList();
  }

  // Get districts
  List<String> getDistricts() {
    return _box.values.map((shelter) => shelter.district).toSet().toList();
  }

  // Get facilities
  List<String> getAllFacilities() {
    final allFacilities = <String>{};
    for (final shelter in _box.values) {
      allFacilities.addAll(shelter.facilities);
    }
    return allFacilities.toList();
  }

  // Clear all data
  Future<void> clearAll() async {
    await _box.clear();
  }
}
