import 'dart:convert';

import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

import 'package:datz_flutter/model/class_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLoader {
  static void saveActiveClassId(int activeId) async {
    final userDefaults = await SharedPreferences.getInstance();
    userDefaults.setInt("activeClassId", activeId);
  }

  /// to be called after launch
  static Future<Class?> loadCurrentClass() async {
    // saveClass(myClass);
    final userDefaults = await SharedPreferences.getInstance();
    final int? currentClassId = userDefaults.getInt("activeClassId");
    if (currentClassId == null) return null;
    return loadClass(currentClassId);
  }

  static Future<Class?> loadClass(int classId) async {
    try {
      final userDefaults = await SharedPreferences.getInstance();
      final classData =
          userDefaults.getString(generateClassUserDefaultsKey(classId));
      final c = Class.fromJson(json.decode(classData!));
      // print("Loaded class ${c.name} with id ${c.id}");
      return c;
    } catch (e) {
      if (kDebugMode) {
        print("Loading class $classId failed: $e");
      }
      return null;
    }
  }

  /// className needs to be escaped because user could enter
  /// a classname equal to another SharedPreferene keys
  static String generateClassUserDefaultsKey(int classId) {
    return "KEY_$classId";
  }

  /// to be called after each update on a class to make it persistent
  static void saveClass(Class c) async {
    final userDefaults = await SharedPreferences.getInstance();
    Map<String, dynamic> classJson = c.toJson();
    userDefaults.setString(
        generateClassUserDefaultsKey(c.id), json.encode(classJson).toString());
    if (kDebugMode) {
      print("Saved class ${c.name} with id ${c.id} successfully");
    }
  }

  static Future<List<ClassMetaModel>> loadAllClassMetaModels() async {
    if (kDebugMode) {
      print("Loading all classes metadata");
    }
    try {
      final String response = await rootBundle
          .loadString('assets/class_meta_data/classiqueClasses.json');
      List<ClassMetaModel> allClassMetaModels = [];
      final List<dynamic> data = await json.decode(response);
      for (Map<String, dynamic> classData in data) {
        allClassMetaModels.add(ClassMetaModel.fromJson(classData));
      }
      print(allClassMetaModels);
      return allClassMetaModels;
    } catch (e) {
      if (kDebugMode) {
        print("could not load Class Meta Models. $e");
      }
      rethrow;
    }
  }
}
