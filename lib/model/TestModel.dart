import 'package:datz_flutter/model/ClassModel.dart';

class Test {
  late String name;
  late double grade;
  late double maxGrade;
  late int id;
  Test(
      {required this.name,
      required this.grade,
      required this.maxGrade,
      int? id}) {
    this.id = id ?? randomId();
  }

  Test.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      grade = json["grade"];
      maxGrade = json["maxGrade"];
      id = json["id"];
    } catch (e) {
      print("There was an error trying to parse Test $name: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'grade': grade,
        'maxGrade': maxGrade,
      };
}

class FixedContributionTest extends Test {
  /// double in [0, 1] indicating how much of the final grade this test makes up
  late double contribution;
  FixedContributionTest(
      {required super.name,
      required super.grade,
      required super.maxGrade,
      required this.contribution,
      int? id})
      : super(id: id);

  FixedContributionTest.fromJson(Map<String, dynamic> json)
      : super(grade: 0, maxGrade: 0, name: "") {
    try {
      name = json["name"];
      grade = json["grade"];
      maxGrade = json["maxGrade"];
      id = json["id"];
      contribution = json["contribution"];
    } catch (e) {
      print("There was an error trying to parse Test $name: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'grade': grade,
        'maxGrade': maxGrade,
      };
}
