
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class AppPrefs {
  static const String _keyDeviceId = "key.device.id";
  AppPrefs();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> saveAndroidDeviceId(String id) async {
    final SharedPreferences prefs = await _prefs;
    String uuidValue = prefs.getString(_keyDeviceId) ?? '';
    if (uuidValue.isEmpty) {
      var uuid = const Uuid();
      final deviceId = uuid.v5(Uuid.NAMESPACE_OID, id);
      prefs.setString(_keyDeviceId, deviceId);
      return deviceId;
    }
    return uuidValue;
  }

  Future<String> saveDeviceId(String deviceId) async {
    final SharedPreferences prefs = await _prefs;
    String uuidValue = prefs.getString(_keyDeviceId) ?? '';
    if (uuidValue.isEmpty) {
      prefs.setString(_keyDeviceId, deviceId);
    }
    return uuidValue;
  }

  Future<String> getDeviceId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_keyDeviceId) ?? '';
  }
}
