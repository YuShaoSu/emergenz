// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get homeTitle => '首頁';

  @override
  String get proceduresTitle => '守則';

  @override
  String get checklistTitle => '清單';

  @override
  String get mapTitle => '地圖';

  @override
  String get contactsTitle => '聯絡';

  @override
  String get emergencyKit => 'EmergencyKit';

  @override
  String get resetSelections => '重置選擇';

  @override
  String get clearList => '清空清單';

  @override
  String get exportShare => '匯出 / 分享';

  @override
  String quantity(String quantity) {
    return '數量: $quantity';
  }

  @override
  String get listCopiedToClipboard => '清單已複製到剪貼簿';

  @override
  String get all => '全部';

  @override
  String get search => '搜尋';

  @override
  String get searchItems => '搜尋物品...';

  @override
  String get addItem => '新增物品';

  @override
  String get editItem => '編輯物品';

  @override
  String get itemName => '物品名稱';

  @override
  String get categoryField => '類別';

  @override
  String get quantityField => '數量';

  @override
  String get save => '儲存';

  @override
  String get cancel => '取消';

  @override
  String get itemNameRequired => '物品名稱為必填';

  @override
  String get categoryRequired => '類別為必填';

  @override
  String get quantityRequired => '數量為必填';

  @override
  String get food => '食物';

  @override
  String get water => '水';

  @override
  String get medical => '醫療用品';

  @override
  String get tools => '工具';

  @override
  String get clothing => '衣物';

  @override
  String get other => '其他';

  @override
  String get emergency => '緊急';

  @override
  String get emergencyProcedures => '緊急應變程序';

  @override
  String get emergencyContacts => '緊急聯絡電話';

  @override
  String get quickActions => '快速操作';

  @override
  String get callEmergency => '撥打緊急電話';

  @override
  String get viewMap => '查看地圖';

  @override
  String get contacts => '聯絡人';

  @override
  String get responseSteps => '應變步驟';

  @override
  String get showAll => '展開全部';

  @override
  String get collapse => '收起';

  @override
  String get importantTips => '重要提醒';

  @override
  String get emergencyServices => '緊急服務';

  @override
  String get police => '警察';

  @override
  String get fire => '消防';

  @override
  String get medicalServices => '醫療';

  @override
  String get coastGuard => '海巡';

  @override
  String get weather => '氣象';

  @override
  String get utilities => '公用事業';

  @override
  String get government => '政府';

  @override
  String get ngo => '非政府組織';

  @override
  String get rescue => '搜救';

  @override
  String get civilDefense => '民防';

  @override
  String get priorityContact => '優先聯絡';

  @override
  String get priority => '優先';

  @override
  String get call => '撥打';

  @override
  String get noContactsFound => '沒有找到聯絡人';

  @override
  String get tryAdjustingSearch => '嘗試調整搜尋條件';

  @override
  String get searchContacts => '搜尋聯絡人...';

  @override
  String get priorityContacts => '優先聯絡電話';

  @override
  String get emergencyPreparednessTips => '緊急準備小貼士';

  @override
  String get prepareEmergencyKit => '準備緊急應變包';

  @override
  String get knowNearestShelter => '了解最近的避難所位置';

  @override
  String get keepPhoneCharged => '保持手機電量充足';

  @override
  String get haveFamilyPlan => '與家人制定應急計劃';

  @override
  String get areYouExperiencingEmergency => '緊急情況？';

  @override
  String get callEmergencyServices => '立即撥打緊急電話';

  @override
  String get quickActionsLabel => '快速操作：';

  @override
  String lastUpdated(String date) {
    return '最後更新：$date';
  }
}
