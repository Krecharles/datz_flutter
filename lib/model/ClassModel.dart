import 'dart:math';

import 'package:datz_flutter/model/SemesterModel.dart';

class Class {
  late String name;

  /// Semesters is ensured to be at least 2, otherwise the segmented control
  /// selected semester throws an error
  late List<Semester> semesters;
  late int id;

  Class({required this.name, required this.semesters, int? id}) {
    this.id = id ?? randomId();
  }

  /// This method throws an error if something didn't parse correctly or if the
  /// data format is not met. Be sure to wrap it in a try catch
  Class.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      id = json["id"];
      final semesterList = json["semesters"] as List<dynamic>;
      semesters = semesterList.map((s) => Semester.fromJson(s)).toList();
    } catch (e) {
      print("There was an error trying to parse Class $name: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'semesters': semesters.map((s) => s.toJson()).toList(),
      };

  List<String> getSemesterNames() {
    return semesters.map((Semester sem) => sem.name).toList();
  }

  bool isAvgCalculable() {
    return semesters.any((s) => s.isAvgCalculable());
  }

  /// the average without rounding
  double calcExactAvg() {
    final calcableSemesters =
        semesters.where((s) => s.isAvgCalculable()).toList();

    // not + bonus as it is usually not the case for combisubjects
    return weightedAvg(
      calcableSemesters.map((s) => s.calcExactAvg()).toList(),
      calcableSemesters.map((s) => s.coef).toList(),
    );
  }

  /// the average ceiled
  int calcFinalAvg() {
    return calcExactAvg().ceil();
  }

  String formattedAvg() {
    if (!isAvgCalculable()) return "";
    return formatDecimal(calcExactAvg());
  }
}

double weightedAvg(List<double> vals, List<double> coefs) {
  double avg = 0;
  double coefSum = 0;
  assert(vals.length == coefs.length);
  for (int i = 0; i < vals.length; i++) {
    avg += coefs[i] * vals[i];
    coefSum += coefs[i];
  }
  return avg / coefSum;
}

String formatDecimal(double val) {
  return val.toStringAsFixed(2);
}

int randomId() => Random().nextInt(0x7fffffff);
