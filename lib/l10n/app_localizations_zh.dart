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
}
