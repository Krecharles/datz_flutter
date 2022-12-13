import 'package:datz_flutter/model/ClassModel.dart';
import 'package:datz_flutter/model/SubjectModel.dart';

class Semester {
  late String name;
  late double coef;
  late List<Subject> subjects;
  late int id;

  Semester(
      {required this.name,
      required this.coef,
      required this.subjects,
      int? id}) {
    this.id = id ?? randomId();
  }

  Semester.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      coef = json["coef"];
      id = json["id"];
      final subjectsList = json["subjects"] as List<dynamic>;
      subjects = subjectsList.map((s) {
        if (s.keys.contains("subSubjects")) return CombiSubject.fromJson(s);
        return SimpleSubject.fromJson(s);
      }).toList();
    } catch (e) {
      print("There was an error trying to parse Semester $name: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'coef': coef,
        'subjects': subjects.map((s) => s.toJson()).toList(),
      };

  bool isAvgCalculable() {
    return subjects.any((s) => s.isAvgCalculable());
  }

  /// the average without rounding
  double calcExactAvg() {
    final calcableSubjects =
        subjects.where((s) => s.isAvgCalculable()).toList();

    // not + bonus as it is usually not the case for combisubjects
    return weightedAvg(
      calcableSubjects.map((s) => s.calcExactAvg()).toList(),
      calcableSubjects.map((s) => s.coef).toList(),
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
