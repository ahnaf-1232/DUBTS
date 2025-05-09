import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<void> write(String key, dynamic value);
  Future<dynamic> read(String key);
  Future<bool> delete(String key);
  Future<bool> containsKey(String key);
  Future<void> clear();
}

class StorageServiceImpl implements StorageService {
  @override
  Future<void> write(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      await prefs.setString(key, json.encode(value));
    }
  }

  @override
  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(key)) {
      return null;
    }

    var value = prefs.get(key);
    if (value is String) {
      try {
        return json.decode(value);
      } catch (e) {
        return value;
      }
    }
    return value;
  }

  @override
  Future<bool> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  @override
  Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}