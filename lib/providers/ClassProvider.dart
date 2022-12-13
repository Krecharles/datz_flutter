import 'package:datz_flutter/model/DataLoader.dart';
import 'package:datz_flutter/model/SubjectModel.dart';
import 'package:datz_flutter/model/data.dart';
import 'package:datz_flutter/model/ClassModel.dart';
import 'package:flutter/cupertino.dart';

import '../model/SemesterModel.dart';
import '../model/TestModel.dart';

class ClassProvider with ChangeNotifier {
  Class? selectedClass;
  int selectedSemester;

  /// must be the id of a simpleSubject
  int? selectedSubjectId;

  @override
  void notifyListeners() {
    if (selectedClass != null) DataLoader.saveClass(selectedClass!);
    super.notifyListeners();
  }

  void loadCurrentClass() async {
    Class? loadedClass = await DataLoader.loadCurrentClass();
    selectedClass = loadedClass;
    notifyListeners();
  }

  ClassProvider({this.selectedClass, this.selectedSemester = 0}) {
    loadCurrentClass();
  }

  void selectSemester(int sem) {
    selectedSemester = sem;
    notifyListeners();
  }

  void selectSubjectWithId(int subjectId) {
    selectedSubjectId = subjectId;
    notifyListeners();
  }

  void unSelectSubject() {
    selectedSubjectId = null;
    notifyListeners();
  }

  SimpleSubject? getSelectedSubject() {
    if (getSelectedSemester() == null) return null;
    if (selectedSubjectId == null) return null;

    for (Subject s in getSelectedSemester()!.subjects) {
      if (s is SimpleSubject && s.id == selectedSubjectId!) return s;
      if (s is CombiSubject) {
        for (SimpleSubject subSubject in s.subSubjects) {
          if (subSubject.id == selectedSubjectId) return subSubject;
        }
      }
    }
    return null;
  }

  /// is true if the global avg over all semesters is selected
  /// selectedClass == null, false is returned
  bool isDisplayingTotalAvg() {
    if (selectedClass == null) return false;
    return selectedSemester >= selectedClass!.semesters.length;
  }

  Semester? getSelectedSemester() {
    if (selectedClass == null || isDisplayingTotalAvg()) return null;
    return selectedClass!.semesters[selectedSemester];
  }

  void incrementBonusPoints() {
    if (getSelectedSubject() == null) return;
    getSelectedSubject()!.plusPoints += 1;
    notifyListeners();
  }

  void decrementBonusPoints() {
    if (getSelectedSubject() == null) return;
    getSelectedSubject()!.plusPoints -= 1;
    notifyListeners();
  }

  void addTest(Test newTest) {
    if (getSelectedSubject() == null) return;
    getSelectedSubject()!.tests.add(newTest);
    notifyListeners();
  }
}
