import 'dart:convert';

import 'package:datz_flutter/model/data.dart';
import 'package:datz_flutter/model/ClassModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLoader {
  static Future<Class?> loadCurrentClass() async {
    // saveClass(myClass);
    return loadClass("3MB");
  }

  static Future<Class?> loadClass(String className) async {
    try {
      final userDefaults = await SharedPreferences.getInstance();
      final classData =
          userDefaults.getString(generateClassUserDefaultsKey(className));
      final c = Class.fromJson(json.decode(classData!));
      print("Loaded class ${c.name} with id ${c.id}");
      return c;
    } catch (e) {
      print("Loading class with name $className failed");
      print(e);
      return null;
    }
  }

  static String generateClassUserDefaultsKey(String className) {
    return "KEY_$className";
  }

  static void saveClass(Class c) async {
    final userDefaults = await SharedPreferences.getInstance();
    Map<String, dynamic> classJson = c.toJson();
    print(json.encode(classJson).toString());
    userDefaults.setString(generateClassUserDefaultsKey(c.name),
        json.encode(classJson).toString());
    print("Saved class successfully");
  }
}
