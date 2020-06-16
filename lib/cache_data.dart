import 'model/date_model.dart';

/**
 * 保存一些缓存数据，不用再次去计算日子
 */
class CacheData {
  //私有构造函数
  CacheData._();

  static CacheData _instance;

  static CacheData get instance => _instance;

  Map<DateModel, List<DateModel>> monthListCache = Map();

  Map<DateModel, List<DateModel>> weekListCache = Map();

  static CacheData getInstance() {
    if (_instance == null) {
      _instance = new CacheData._();
    }
    return _instance;
  }

  void clearData() {
    monthListCache.clear();
    weekListCache.clear();
  }
}
