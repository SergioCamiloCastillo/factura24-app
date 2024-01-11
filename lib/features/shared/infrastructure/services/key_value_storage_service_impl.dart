import 'package:factura24/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getKeyValue<T>(String key) async {
    final prefs = await getSharedPrefs();
    switch (T) {
      case int:
        return prefs.getInt(key) as T?;

      case double:
        return prefs.getDouble(key) as T?;
        {}

      case String:
        return prefs.getString(key) as T?;
        {}

      case bool:
        return prefs.getBool(key) as T?;
        {}

      case List:
        return prefs.getStringList(key) as T?;
        {}

      default:
        throw Exception('Get Type not supported ${T.runtimeType}');
    }
    return null;
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();
    switch (T) {
      case int:
        prefs.setInt(key, value as int);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
      case String:
        prefs.setString(key, value as String);
        break;
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case List:
        prefs.setStringList(key, value as List<String>);
        break;
      default:
        throw Exception('Set Type not supported ${T.runtimeType}');
    }
  }
}
