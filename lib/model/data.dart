import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/semester_model.dart';
import 'package:datz_flutter/model/subject_model.dart';
import 'package:datz_flutter/model/test_model.dart';

final myClass = Class(
  name: "3MB",
  semesters: [
    Semester(
      name: "Sem1",
      coef: 1,
      subjects: [
        SimpleSubject(
          name: "Français",
          coef: 3,
          tests: [
            Test(name: "Test 1", grade: 45.5, maxGrade: 60),
          ],
          plusPoints: 2,
        ),
        CombiSubject(
          name: "Mathematique/Informatique",
          coef: 4,
          subSubjects: [
            SimpleSubject(
              name: "Mathe",
              coef: 3,
              tests: [
                Test(name: "Test 1", grade: 55.5, maxGrade: 60),
              ],
              plusPoints: 0,
            ),
            SimpleSubject(
              name: "Info",
              coef: 1,
              tests: [
                Test(name: "Test 1", grade: 53, maxGrade: 60),
              ],
              plusPoints: 2,
            ),
          ],
        ),
      ],
    ),
    Semester(
      name: "Sem 2",
      coef: 1,
      subjects: [
        SimpleSubject(
          name: "Français",
          coef: 3,
          tests: [
            Test(name: "Test 1", grade: 47.5, maxGrade: 60),
          ],
          plusPoints: 2,
        ),
        CombiSubject(
          name: "Mathematique/Informatique",
          coef: 4,
          subSubjects: [
            SimpleSubject(
              name: "Mathe",
              coef: 3,
              tests: [
                Test(name: "Test 1", grade: 12, maxGrade: 60),
              ],
              plusPoints: 0,
            ),
            SimpleSubject(
              name: "Info",
              coef: 1,
              tests: [
                Test(name: "Test 1", grade: 60.0, maxGrade: 60),
              ],
              plusPoints: 2,
            ),
          ],
        ),
      ],
    ),
    Semester(
      name: "Exam",
      coef: 1,
      subjects: [
        SimpleSubject(
          name: "Français",
          coef: 3,
          tests: [],
          plusPoints: 2,
        ),
        CombiSubject(
          name: "Mathematique/Informatique",
          coef: 4,
          subSubjects: [
            SimpleSubject(
              name: "Mathe",
              coef: 3,
              tests: [],
              plusPoints: 0,
            ),
            SimpleSubject(
              name: "Info",
              coef: 1,
              tests: [],
              plusPoints: 2,
            ),
          ],
        ),
      ],
    ),
  ],
);
