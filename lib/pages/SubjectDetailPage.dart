import 'package:datz_flutter/components/BonusStepperTile.dart';
import 'package:datz_flutter/components/Buttons.dart';
import 'package:datz_flutter/components/CustomeSliver.dart';
import 'package:datz_flutter/components/SlidableListView.dart';
import 'package:datz_flutter/consts.dart';
import 'package:datz_flutter/model/TestModel.dart';
import 'package:datz_flutter/pages/EditTestPage.dart';
import 'package:datz_flutter/providers/ClassProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SubjectDetailPage extends StatelessWidget {
  const SubjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SlidableListProvider>(
      create: (_) => SlidableListProvider(),
      child: Consumer<ClassProvider>(builder:
          (BuildContext context, ClassProvider provider, Widget? child) {
        return CupertinoPageScaffold(
          child: CustomSliver(
            minExtent: 100,
            maxExtent: 300,
            buildHeader: buildHeader,
            body: buildBody(context),
          ),
        );
      }),
    );
  }

  Widget buildHeader(BuildContext context, double shrinkOffset) {
    const maxExtent = 300;
    // final shrinkRatio = clampDouble(1 - shrinkOffset / maxExtent, 0, 1);
    final opacity = clampDouble(1 - 2 * shrinkOffset / maxExtent, 0, 1);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: CustomDecorations.primaryGradientDecoration(context),
        ),
        const Positioned(
          left: 12.0,
          top: 0,
          child: SafeArea(
              child: CupertinoNavigationBarBackButton(
            color: CupertinoColors.white,
            // previousPageTitle: "Back",
          )),
        ),
        Positioned(
          left: 12.0,
          right: 12.0,
          bottom: 12.0 + opacity * 64,
          child: Consumer<ClassProvider>(builder:
              (BuildContext context, ClassProvider provider, Widget? child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  provider.getSelectedSubject()?.name ?? "",
                  style: TextStyle(
                    fontSize: (1 - opacity) * 32,
                    color: CupertinoColors.white.withOpacity(1 - opacity),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  provider.getSelectedSubject()?.formattedAvg() ?? "",
                  style: TextStyle(
                    fontSize: 32 + opacity * 64,
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        buildSubjectInfoCard(context),
        const BonusStepperTile(),
        buildTestList(context),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<ClassProvider>(builder:
                (BuildContext context, ClassProvider provider, Widget? child) {
              return Button(
                text: "Add Test",
                type: ButtonType.tinted,
                leadingIcon: CupertinoIcons.add,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TestEditPage(
                        onSubmit: (Test newTest) => provider.addTest(newTest),
                      ),
                    ),
                  );
                },
              );
            }),
            Consumer<SlidableListProvider>(
              builder: (context, provider, child) {
                return Button(
                  text: provider.isInEditMode ? "Finish" : "Edit",
                  type: ButtonType.plain,
                  onPressed: provider.toggleEditMode,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTestList(BuildContext context) {
    ClassProvider provider = Provider.of<ClassProvider>(context, listen: false);
    if (provider.getSelectedSubject()?.tests == null) {
      return const Text("no tests");
    }
    if (provider.getSelectedSubject()!.tests.isEmpty) {
      return const Text("no tests");
    }
    return CupertinoListSection.insetGrouped(
      children: [
        for (Test t in provider.getSelectedSubject()!.tests)
          Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => TestEditPage(
                          editTest: t,
                          onSubmit: (Test newTest) =>
                              provider.editTest(newTest),
                        ),
                      ),
                    );
                  },
                  backgroundColor: CupertinoColors.systemBlue,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (BuildContext context) {
                    provider.deleteTest(t.id);
                  },
                  backgroundColor: CupertinoColors.systemRed,
                  label: 'Delete',
                ),
              ],
            ),
            child: CupertinoListTile.notched(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => TestEditPage(
                      editTest: t,
                      onSubmit: (Test newTest) => provider.editTest(newTest),
                    ),
                  ),
                );
              },
              title: Text(t.name),
              trailing: Row(
                children: [
                  Text(
                    "${t.grade} / ${t.maxGrade}",
                    style: TextStyle(
                        color: CupertinoColors.secondaryLabel
                            .resolveFrom(context)),
                  ),
                  const SizedBox(width: 4),
                  Icon(CupertinoIcons.chevron_right,
                      color: CupertinoColors.systemFill.resolveFrom(context)),
                ],
              ),
            ),
          ),
      ],
    );

    // return SlidableListView(
    //   children: [
    //     for (Test t in provider.getSelectedSubject()!.tests)
    //       CupertinoListTile.notched(
    //         title: Text(t.name),
    //         trailing: Text(
    //           "${t.grade} / ${t.maxGrade}",
    //           style: TextStyle(
    //               color: CupertinoColors.secondaryLabel.resolveFrom(context)),
    //         ),
    //       ),
    //   ],
    // );
  }

  Widget buildSubjectInfoCard(BuildContext context) {
    return Consumer<ClassProvider>(
        builder: (BuildContext context, ClassProvider provider, Widget? child) {
      return Container(
        // height: 100,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(20),
        decoration: CustomDecorations.primaryContainer(context),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              provider.getSelectedSubject()?.name ?? "",
              style: TextStyle(
                color: CupertinoColors.label.resolveFrom(context),
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Coefficient: ${provider.getSelectedSubject()?.coef ?? ""}",
              style: TextStyle(
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          ],
        ),
      );
    });
  }
}
