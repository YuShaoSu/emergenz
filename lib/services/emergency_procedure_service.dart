import 'package:hive_flutter/hive_flutter.dart';
import '../models/emergency_procedure.dart';

class EmergencyProcedureService {
  static const String _boxName = 'procedures';
  late Box<EmergencyProcedure> _box;

  Future<void> initialize() async {
    _box = Hive.box<EmergencyProcedure>(_boxName);
    await _loadDefaultData();
  }

  Future<void> _loadDefaultData() async {
    if (_box.isEmpty) {
      final defaultProcedures = [
        EmergencyProcedure(
          id: 'earthquake_1',
          title: 'Earthquake Emergency Response',
          titleZh: '地震緊急應變',
          description:
              'Immediate actions to take during and after an earthquake',
          descriptionZh: '地震發生時和發生後應立即採取的應變措施',
          category: 'earthquake',
          iconPath: 'assets/icons/earthquake.png',
          isOffline: true,
          lastUpdated: DateTime.now(),
          steps: [
            ProcedureStep(
              order: 1,
              title: 'Drop, Cover, and Hold On',
              titleZh: '趴下、掩護、穩住',
              description:
                  'Drop to your hands and knees, cover your head and neck, and hold on to a sturdy piece of furniture',
              descriptionZh: '雙手雙膝著地，保護頭部和頸部，並抓住穩固的家具',
              tips: [
                'Stay away from windows and glass',
                'If you\'re in bed, stay there and cover your head',
                'Don\'t run outside during shaking'
              ],
              tipsZh: ['遠離窗戶和玻璃', '如果在床上，請留在原地並保護頭部', '搖晃時不要跑到室外'],
            ),
            ProcedureStep(
              order: 2,
              title: 'Check for Injuries',
              titleZh: '檢查傷勢',
              description:
                  'After the shaking stops, check yourself and others for injuries',
              descriptionZh: '搖晃停止後，檢查自己和他人是否有受傷',
              tips: [
                'Don\'t move seriously injured people',
                'Call emergency services if needed',
                'Check for gas leaks and electrical hazards'
              ],
              tipsZh: ['不要移動重傷者', '如有需要請撥打緊急電話', '檢查瓦斯洩漏和電氣危險'],
            ),
            ProcedureStep(
              order: 3,
              title: 'Evacuate if Necessary',
              titleZh: '必要時撤離',
              description:
                  'Evacuate to a safe location if your building is damaged',
              descriptionZh: '如果建築物受損，請撤離到安全地點',
              tips: [
                'Use stairs, not elevators',
                'Bring emergency supplies',
                'Stay away from damaged buildings'
              ],
              tipsZh: ['使用樓梯，不要使用電梯', '攜帶緊急用品', '遠離受損建築物'],
            ),
          ],
        ),
        EmergencyProcedure(
          id: 'typhoon_1',
          title: 'Typhoon Preparedness',
          titleZh: '颱風防災準備',
          description: 'How to prepare for and stay safe during a typhoon',
          descriptionZh: '如何為颱風做準備並在颱風期間保持安全',
          category: 'typhoon',
          iconPath: 'assets/icons/typhoon.png',
          isOffline: true,
          lastUpdated: DateTime.now(),
          steps: [
            ProcedureStep(
              order: 1,
              title: 'Secure Your Home',
              titleZh: '加固房屋',
              description:
                  'Secure loose objects and reinforce windows and doors',
              descriptionZh: '固定鬆動物品，加固門窗',
              tips: [
                'Bring outdoor furniture inside',
                'Cover windows with plywood',
                'Clear gutters and drains'
              ],
              tipsZh: ['將戶外家具搬入室內', '用夾板覆蓋窗戶', '清理排水溝和排水管'],
            ),
            ProcedureStep(
              order: 2,
              title: 'Prepare Emergency Kit',
              titleZh: '準備緊急包',
              description: 'Gather essential supplies for at least 72 hours',
              descriptionZh: '準備至少72小時的基本用品',
              tips: [
                'Include food, water, and medicine',
                'Pack important documents',
                'Have flashlights and batteries ready'
              ],
              tipsZh: ['包含食物、水和藥品', '打包重要文件', '準備手電筒和電池'],
            ),
            ProcedureStep(
              order: 3,
              title: 'Stay Informed',
              titleZh: '保持資訊暢通',
              description:
                  'Monitor weather updates and follow official instructions',
              descriptionZh: '監控天氣更新並遵循官方指示',
              tips: [
                'Listen to radio or TV updates',
                'Follow government announcements',
                'Know your evacuation route'
              ],
              tipsZh: ['收聽廣播或電視更新', '遵循政府公告', '了解撤離路線'],
            ),
          ],
        ),
        EmergencyProcedure(
          id: 'war_1',
          title: 'Civil Defense Procedures',
          titleZh: '民防程序',
          description: 'Emergency procedures for civil defense situations',
          descriptionZh: '民防情況的緊急程序',
          category: 'war',
          iconPath: 'assets/icons/civil_defense.png',
          isOffline: true,
          lastUpdated: DateTime.now(),
          steps: [
            ProcedureStep(
              order: 1,
              title: 'Seek Shelter Immediately',
              titleZh: '立即尋求庇護',
              description: 'Move to the nearest bomb shelter or safe location',
              descriptionZh: '前往最近的防空洞或安全地點',
              tips: [
                'Follow emergency broadcasts',
                'Stay away from windows',
                'Bring essential supplies'
              ],
              tipsZh: ['遵循緊急廣播', '遠離窗戶', '攜帶基本用品'],
            ),
            ProcedureStep(
              order: 2,
              title: 'Stay Calm and Informed',
              titleZh: '保持冷靜並獲取資訊',
              description: 'Remain calm and listen for official instructions',
              descriptionZh: '保持冷靜並聽取官方指示',
              tips: [
                'Don\'t spread rumors',
                'Follow official channels',
                'Help others if possible'
              ],
              tipsZh: ['不要散播謠言', '遵循官方管道', '如可能請幫助他人'],
            ),
            ProcedureStep(
              order: 3,
              title: 'Prepare for Extended Stay',
              titleZh: '準備長期停留',
              description:
                  'Be prepared to stay in shelter for extended periods',
              descriptionZh: '準備在庇護所長期停留',
              tips: [
                'Conserve food and water',
                'Maintain hygiene',
                'Stay connected with family'
              ],
              tipsZh: ['節約食物和水', '保持衛生', '與家人保持聯繫'],
            ),
          ],
        ),
      ];

      for (final procedure in defaultProcedures) {
        await _box.put(procedure.id, procedure);
      }
    }
  }

  // Get all procedures
  List<EmergencyProcedure> getAllProcedures() {
    return _box.values.toList();
  }

  // Get procedures by category
  List<EmergencyProcedure> getProceduresByCategory(String category) {
    return _box.values
        .where((procedure) => procedure.category == category)
        .toList();
  }

  // Get procedure by ID
  EmergencyProcedure? getProcedureById(String id) {
    return _box.get(id);
  }

  // Search procedures
  List<EmergencyProcedure> searchProcedures(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _box.values.where((procedure) {
      return procedure.title.toLowerCase().contains(lowercaseQuery) ||
          procedure.titleZh.contains(query) ||
          procedure.description.toLowerCase().contains(lowercaseQuery) ||
          procedure.descriptionZh.contains(query);
    }).toList();
  }

  // Add new procedure
  Future<void> addProcedure(EmergencyProcedure procedure) async {
    await _box.put(procedure.id, procedure);
  }

  // Update procedure
  Future<void> updateProcedure(EmergencyProcedure procedure) async {
    await _box.put(procedure.id, procedure);
  }

  // Delete procedure
  Future<void> deleteProcedure(String id) async {
    await _box.delete(id);
  }

  // Get categories
  List<String> getCategories() {
    return _box.values.map((procedure) => procedure.category).toSet().toList();
  }

  // Clear all data
  Future<void> clearAll() async {
    await _box.clear();
  }
}
