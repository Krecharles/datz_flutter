import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/test_model.dart';
import 'package:flutter/foundation.dart';

/// parent class for SimpeSubject and CombiSubject
/// not intended to be instatiated
class Subject {
  late String name;
  late double coef; // double or int?
  late int id;
  Subject({required this.name, required this.coef, int? id}) {
    this.id = id ?? randomId();
  }

  Map<String, dynamic> toJson() =>
      {"some key": "Subject.toJson() should never be called on parent class"};

  bool isAvgCalculable() {
    return false;
  }

  /// the average without rounding but with bonus
  double calcExactAvg() {
    return 0;
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

class SimpleSubject extends Subject {
  late List<Test> tests;
  late List<FixedContributionTest> fixedContributionTests;
  late double plusPoints;
  SimpleSubject({
    required super.name,
    required super.coef,
    this.plusPoints = 0,
    required this.tests,
    this.fixedContributionTests = const [],
    int? id,
  }) : super(id: id);

  SimpleSubject.fromMetaModel(SubjectMetaModel subjectMetaModel)
      : super(name: subjectMetaModel.name, coef: subjectMetaModel.coef) {
    tests = [];
    fixedContributionTests = [];
    plusPoints = 0;
  }

  SimpleSubject.fromJson(Map<String, dynamic> json) : super(name: "", coef: 0) {
    try {
      id = json["id"];
      name = json["name"];
      coef = json["coef"];
      plusPoints = json["plusPoints"];
      final testsList = json["tests"] as List<dynamic>;
      tests = testsList.map((s) => Test.fromJson(s)).toList();
      final fixedContributionTestsList =
          json["fixedContributionTests"] as List<dynamic>;
      fixedContributionTests = fixedContributionTestsList
          .map((s) => FixedContributionTest.fromJson(s))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse SimpleSubject $name: $e");
      }
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'coef': coef,
        'plusPoints': plusPoints,
        'tests': tests.map((s) => s.toJson()).toList(),
        'fixedContributionTests':
            fixedContributionTests.map((s) => s.toJson()).toList(),
      };

  @override
  bool isAvgCalculable() {
    return tests.isNotEmpty || fixedContributionTests.isNotEmpty;
  }

  double calcExactAvgOfSimpleTests() {
    double gradeSum = tests.fold(0, (prevVal, test) => prevVal + test.grade);
    double maxGradeSum =
        tests.fold(0, (prevVal, test) => prevVal + test.maxGrade);
    return gradeSum / maxGradeSum * 60;
  }

  @override
  double calcExactAvg() {
    double avg = 0;
    double contribution = 1;
    for (FixedContributionTest test in fixedContributionTests) {
      contribution -= test.contribution;
      avg += test.contribution * (test.grade / test.maxGrade);
    }

    if (tests.isNotEmpty) {
      avg += contribution * calcExactAvgOfSimpleTests() / 60;
    } else {
      // if no simple test exists, still display the average
      // TODO is this correct?
      avg = avg / (1 - contribution);
    }

    return avg * 60 + plusPoints;
  }
}

class CombiSubject extends Subject {
  late List<SimpleSubject> subSubjects;

  CombiSubject(
      {required super.name,
      required super.coef,
      required this.subSubjects,
      int? id})
      : super(id: id);

  CombiSubject.fromMetaModel(SubjectMetaModel subjectMetaModel)
      : super(name: subjectMetaModel.name, coef: subjectMetaModel.coef) {
    for (SubjectMetaModel subModels in subjectMetaModel.subSubjects) {
      if (subModels.subSubjects.isNotEmpty) {
        if (kDebugMode) {
          print("Multiple nested subSubjects not allowed");
        }
      } else {
        subSubjects = [];
        subSubjects.add(SimpleSubject.fromMetaModel(subModels));
      }
    }
  }

  CombiSubject.fromJson(Map<String, dynamic> json) : super(name: "", coef: 0) {
    try {
      id = json["id"];
      name = json["name"];
      coef = json["coef"];
      final subSubjectsList = json["subSubjects"] as List<dynamic>;
      subSubjects =
          subSubjectsList.map((s) => SimpleSubject.fromJson(s)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse SimpleSubject $name: $e");
      }
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'coef': coef,
        'subSubjects': subSubjects.map((s) => s.toJson()).toList(),
      };

  @override
  bool isAvgCalculable() {
    return subSubjects.any((SimpleSubject s) => s.isAvgCalculable());
  }

  /// the average without rounding but with bonus
  @override
  double calcExactAvg() {
    // double gradeSum = 0;
    // double coefSum = 0;

    // for (SimpleSubject s in subSubjects) {
    //   if (!s.isAvgCalculable()) continue;
    //   gradeSum += s.coef * s.calcExactAvg();
    //   coefSum += s.coef;
    // }

    final calcableSubjects =
        subSubjects.where((s) => s.isAvgCalculable()).toList();

    // not + bonus as it is usually not the case for combisubjects
    return weightedAvg(
      calcableSubjects.map((s) => s.calcExactAvg()).toList(),
      calcableSubjects.map((s) => s.coef).toList(),
    );
  }
}
