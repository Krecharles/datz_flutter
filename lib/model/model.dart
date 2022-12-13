import 'dart:math';

class Class {
  late String name;
  late List<Semester> semesters;
  late int id;

  Class({required this.name, required this.semesters, int? id}) {
    this.id = id ?? randomId();
  }

  Class.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];

    try {
      final semesterList = json["semesters"] as List<dynamic>;
      semesters = semesterList.map((s) => Semester.fromJson(s)).toList();
    } catch (e) {
      semesters = [];
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
    name = json["name"];
    coef = json["coef"];
    id = json["id"];
    subjects = [];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'semesters': [],
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

class Subject {
  String name;
  double coef; // double or int?
  late int id;
  Subject({required this.name, required this.coef, int? id}) {
    this.id = id ?? randomId();
  }

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
  List<Test> tests;
  List<FixedContributionTest> fixedContributionTests;
  double plusPoints;
  SimpleSubject({
    required super.name,
    required super.coef,
    this.plusPoints = 0,
    required this.tests,
    this.fixedContributionTests = const [],
    int? id,
  }) : super(id: id);

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
  List<SimpleSubject> subSubjects;

  CombiSubject(
      {required super.name,
      required super.coef,
      required this.subSubjects,
      int? id})
      : super(id: id);

  @override
  bool isAvgCalculable() {
    return subSubjects.any((SimpleSubject s) => s.isAvgCalculable());
  }

  /// the average without rounding but with bonus
  @override
  double calcExactAvg() {
    double gradeSum = 0;
    double coefSum = 0;

    for (SimpleSubject s in subSubjects) {
      if (!s.isAvgCalculable()) continue;
      gradeSum += s.coef * s.calcExactAvg();
      coefSum += s.coef;
    }

    final calcableSubjects =
        subSubjects.where((s) => s.isAvgCalculable()).toList();

    // not + bonus as it is usually not the case for combisubjects
    return weightedAvg(
      calcableSubjects.map((s) => s.calcExactAvg()).toList(),
      calcableSubjects.map((s) => s.coef).toList(),
    );
  }
}

class Test {
  String name;
  double grade;
  double maxGrade;
  late int id;
  Test(
      {required this.name,
      required this.grade,
      required this.maxGrade,
      int? id}) {
    this.id = id ?? randomId();
  }
}

class FixedContributionTest extends Test {
  /// double in [0, 1] indicating how much of the final grade this test makes up
  final double contribution;
  FixedContributionTest(
      {required super.name,
      required super.grade,
      required super.maxGrade,
      required this.contribution,
      int? id})
      : super(id: id);
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
