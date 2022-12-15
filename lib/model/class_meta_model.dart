class ClassMetaModel {
  late String name;
  late List<SemesterMetaModel> semesters;
  late List<SubjectMetaModel> subjects;

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
      print("There was an error trying to parse Class MetaData $name: $e");
      rethrow;
    }
  }
}

class SubjectMetaModel {
  late String name;
  late double coef;
  late List<SubjectMetaModel> subSubjects;

  SubjectMetaModel.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      coef = json["coef"];
      final subSubjectsList = json["subSubjects"] as List<dynamic>?;
      if (subSubjectsList != null) {
        subSubjects =
            subSubjectsList.map((s) => SubjectMetaModel.fromJson(s)).toList();
      }
    } catch (e) {
      print("There was an error trying to parse Subject MetaData $name: $e");
      rethrow;
    }
  }
}

class SemesterMetaModel {
  /// e.g. "Sem 1", "Exam"
  late String name;
  late double coef;

  SemesterMetaModel({required this.name, required this.coef});

  /// This method throws an error if something didn't parse correctly or if the
  /// data format is not met. Be sure to wrap it in a try catch
  SemesterMetaModel.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      coef = json["coef"];
    } catch (e) {
      print("There was an error trying to parse Semester MetaModel $name: $e");
      rethrow;
    }
  }
}
