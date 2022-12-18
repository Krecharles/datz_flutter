import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ClassCreationModel {
  late TextEditingController nameController;
  bool useSemesters;
  bool hasExams;
  late List<SubjectCreationModel> subjects;
  ClassCreationModel({
    required this.useSemesters,
    required this.hasExams,
  }) {
    nameController = TextEditingController();
    subjects = [];
  }

  String? validate() {
    if (nameController.value.text == "") {
      return "Classname cannot be empty.";
    }
    if (subjects.isEmpty) {
      return "Add at least one sujects.";
    }

    for (SubjectCreationModel s in subjects) {
      if (s.nameController.value.text == "") {
        return "Subjectname cannot be empty.";
      }
      if (s.subSubjects == null) continue;

      for (SubjectCreationModel sub in s.subSubjects!) {
        if (sub.nameController.value.text == "") {
          return "Subjectname cannot be empty.";
        }
      }
    }
    return null;
  }

  ClassMetaModel parseToMetaModel() {
    return ClassMetaModel(
      name: nameController.value.text,
      semesters: parseToSemesterMetaModel(),
      subjects: parseToSubjectMetaModel(),
    );
  }

  List<SemesterMetaModel> parseToSemesterMetaModel() {
    if (useSemesters && !hasExams) {
      return [
        SemesterMetaModel(name: "Sem 1", coef: 1),
        SemesterMetaModel(name: "Sem 2", coef: 1),
      ];
    }
    if (useSemesters && hasExams) {
      return [
        SemesterMetaModel(name: "Sem 1", coef: 1),
        SemesterMetaModel(name: "Sem 2", coef: 1),
        // exam counts as 2/3
        SemesterMetaModel(name: "Exam", coef: 4),
      ];
    }
    if (!useSemesters && !hasExams) {
      return [
        SemesterMetaModel(name: "Trim 1", coef: 1),
        SemesterMetaModel(name: "Trim 2", coef: 1),
        SemesterMetaModel(name: "Trim 3", coef: 1),
      ];
    }
    if (kDebugMode) {
      print("Invalid semester config in class creation");
    }
    throw Error();
  }

  List<SubjectMetaModel> parseToSubjectMetaModel() {
    List<SubjectMetaModel> subjectModels = [];
    for (SubjectCreationModel s in subjects) {
      subjectModels.add(s.parseToSubjectMetaModel());
    }
    return subjectModels;
  }

  void removeSubject(int subjectId) {
    subjects.removeWhere((s) => s.id == subjectId);
  }

  void addSimpleSubject() {
    subjects.add(
      SubjectCreationModel(),
    );
  }

  void addCombiSubject() {
    subjects.add(
      SubjectCreationModel(
        subSubjects: [
          SubjectCreationModel(),
        ],
      ),
    );
  }
}

class SubjectCreationModel {
  late int id;
  late TextEditingController nameController;
  int coef;
  List<SubjectCreationModel>? subSubjects;

  SubjectCreationModel(
      {int? id,
      TextEditingController? nameController,
      this.coef = 1,
      this.subSubjects}) {
    this.id = id ?? randomId();
    this.nameController = nameController ?? TextEditingController();
  }

  SubjectMetaModel parseToSubjectMetaModel() {
    if (subSubjects == null) {
      return SubjectMetaModel(
        name: nameController.value.text,
        coef: coef.toDouble(),
      );
    } else {
      List<SubjectMetaModel> subSubjectsModels = [];
      for (SubjectCreationModel subModel in subSubjects!) {
        subSubjectsModels.add(SubjectMetaModel(
          name: subModel.nameController.value.text,
          coef: subModel.coef.toDouble(),
        ));
      }
      return (SubjectMetaModel(
        name: nameController.value.text,
        coef: coef.toDouble(),
        subSubjects: subSubjectsModels,
      ));
    }
  }

  void addSubSubject() {
    if (subSubjects == null) return;
    subSubjects!.add(SubjectCreationModel(
      nameController: TextEditingController(),
    ));
  }

  void removeSubSubject() {
    if (subSubjects == null) return;
    subSubjects!.removeLast();
  }
}
