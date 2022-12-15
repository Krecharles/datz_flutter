import 'package:datz_flutter/model/semester_model.dart';
import 'package:datz_flutter/model/subject_model.dart';
import 'package:datz_flutter/pages/subject_detail_page/subject_detail_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SubjectList extends StatelessWidget {
  const SubjectList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(
        builder: (BuildContext context, ClassProvider provider, Widget? child) {
      if (provider.selectedClass == null) return const Text("Loading");
      if (provider.isDisplayingTotalAvg()) return const Text("Todo");

      Semester sem = provider.getSelectedSemester()!;

      return Column(
        children: [
          for (Subject subject in sem.subjects) ...[
            if (subject is SimpleSubject)
              SimpleSubjectListTile(subject: subject),
            if (subject is CombiSubject) CombiSubjectListTile(subject: subject)
          ]
        ],
      );
    });
  }
}

/// a simple subject is displayed as a list with a single tile
class SimpleSubjectListTile extends StatelessWidget {
  const SimpleSubjectListTile({
    super.key,
    required this.subject,
  });

  final SimpleSubject subject;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(
        builder: (BuildContext context, ClassProvider provider, Widget? child) {
      return CupertinoListSection.insetGrouped(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        children: [
          CupertinoListTile.notched(
            title: Text(
              subject.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              provider.selectSubjectWithId(subject.id);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: ((context) => const SubjectDetailPage()),
                ),
              ).then((_) => provider.unSelectSubject());
            },
            trailing: Row(
              children: [
                Text(
                  subject.formattedAvg(),
                  style: TextStyle(
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
                const SizedBox(width: 4),
                Icon(CupertinoIcons.chevron_right,
                    color: CupertinoColors.systemFill.resolveFrom(context)),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class CombiSubjectListTile extends StatelessWidget {
  final CombiSubject subject;

  const CombiSubjectListTile({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(children: [
      CupertinoListTile.notched(
        title: Text(
          subject.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          children: [
            Text(
              subject.formattedAvg(),
              style: TextStyle(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context)),
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
      for (SimpleSubject sub in subject.subSubjects)
        Consumer<ClassProvider>(builder:
            (BuildContext context, ClassProvider provider, Widget? child) {
          return CupertinoListTile(
            title: Text(sub.name),
            onTap: () {
              provider.selectSubjectWithId(sub.id);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: ((context) => const SubjectDetailPage()),
                ),
              ).then((_) => provider.unSelectSubject());
            },
            trailing: Row(
              children: [
                Text(
                  sub.formattedAvg(),
                  style: TextStyle(
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
                const SizedBox(width: 4),
                Icon(CupertinoIcons.chevron_right,
                    color: CupertinoColors.systemFill.resolveFrom(context)),
              ],
            ),
          );
        }),
    ]);
  }
}