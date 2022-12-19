import 'package:datz_flutter/model/class_model.dart';
import 'package:flutter/foundation.dart';

class ClassMetaModel {
  late String name;
  late List<SemesterMetaModel> semesters;
  late List<SubjectMetaModel> subjects;

  ClassMetaModel({
    required this.name,
    required this.semesters,
    required this.subjects,
  });

  /// This method throws an error if something didn't parse correctly or if the
  /// data format is not met. Be sure to wrap it in a try catch
  ClassMetaModel.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      final semestersList = json["semesters"] as List<dynamic>?;
      if (semestersList == null) {
        semesters = [
          SemesterMetaModel(name: "Sem 1", coef: 1),
          SemesterMetaModel(name: "Sem 2", coef: 1),
        ];
      } else {
        semesters =
            semestersList.map((s) => SemesterMetaModel.fromJson(s)).toList();
      }
      final subjectsList = json["subjects"] as List<dynamic>;
      subjects = subjectsList.map((s) => SubjectMetaModel.fromJson(s)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse Class MetaData $name: $e");
      }
      rethrow;
    }
  }
}

class SubjectMetaModel {
  late String name;
  late double coef;
  late List<SubjectMetaModel>? subSubjects;
  late int id; // needed to have every subject in each semesters the same id

  SubjectMetaModel({
    required this.name,
    required this.coef,
    this.subSubjects,
  }) {
    id = randomId();
  }

  SubjectMetaModel.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      coef = json["coef"];
      id = randomId();
      final subSubjectsList = json["subSubjects"] as List<dynamic>?;
      if (subSubjectsList != null) {
        subSubjects =
            subSubjectsList.map((s) => SubjectMetaModel.fromJson(s)).toList();
      } else {
        subSubjects = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse Subject MetaData $name: $e");
      }
      rethrow;
    }
  }
}

class SemesterMetaModel {
  /// e.g. "Sem 1", "Exam"
  late String name;
  late double coef;

  SemesterMetaModel({
    required this.name,
    required this.coef,
  });

  /// This method throws an error if something didn't parse correctly or if the
  /// data format is not met. Be sure to wrap it in a try catch
  SemesterMetaModel.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      coef = json["coef"];
    } catch (e) {
      if (kDebugMode) {
        print(
            "There was an error trying to parse Semester MetaModel $name: $e");
      }
      rethrow;
    }
  }
}
