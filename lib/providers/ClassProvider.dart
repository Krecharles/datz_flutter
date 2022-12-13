import 'package:datz_flutter/model/model.dart';
import 'package:flutter/cupertino.dart';

class ClassProvider extends ChangeNotifier {
  Class? selectedClass;
  int selectedSemester;

  /// must be the id of a simpleSubject
  int? selectedSubjectId;

  ClassProvider({this.selectedClass, this.selectedSemester = 0});

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

  bool isDisplayingTotalAvg() {
    return selectedSemester >= selectedClass.semesters.length;
  }

  Semester? getSelectedSemester() {
    if (isDisplayingTotalAvg()) return null;
    return selectedClass.semesters[selectedSemester];
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
