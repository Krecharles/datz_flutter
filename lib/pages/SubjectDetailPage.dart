import 'package:datz_flutter/components/Buttons.dart';
import 'package:datz_flutter/components/CustomeSliver.dart';
import 'package:datz_flutter/components/SlidableListView.dart';
import 'package:datz_flutter/components/SliverHeader.dart';
import 'package:datz_flutter/consts.dart';
import 'package:datz_flutter/model/ClassModel.dart';
import 'package:datz_flutter/model/TestModel.dart';
import 'package:datz_flutter/pages/AddTestPage.dart';
import 'package:datz_flutter/providers/ClassProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectDetailPage extends StatelessWidget {
  const SubjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(
        builder: (BuildContext context, ClassProvider provider, Widget? child) {
      return CupertinoPageScaffold(
        child: CustomSliver(
          minExtent: 100,
          maxExtent: 300,
          buildHeader: buildHeader,
          body: buildBody(context),
        ),
      );
    });
  }

  Widget buildHeader(BuildContext context, double shrinkOffset) {
    const maxExtent = 300;
    final shrinkRatio = clampDouble(1 - shrinkOffset / maxExtent, 0, 1);
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
        BonusStepperTile(),
        buildTestList(context),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              text: "Add Test",
              type: ButtonType.tinted,
              leadingIcon: CupertinoIcons.add,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AddTestPage(),
                  ),
                );
              },
            ),
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
    return SlidableListView(
      children: [
        for (Test t in provider.getSelectedSubject()!.tests)
          CupertinoListTile.notched(
            title: Text(t.name),
            trailing: Text(
              "${t.grade} / ${t.maxGrade}",
              style: TextStyle(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context)),
            ),
          ),
      ],
    );
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
            SizedBox(height: 12),
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

class BonusStepperTile extends StatelessWidget {
  const BonusStepperTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassProvider>(
        builder: (BuildContext context, ClassProvider provider, Widget? child) {
      if (provider.getSelectedSubject() == null) {
        return Text("todo");
      }
      double bonusPoints = provider.getSelectedSubject()!.plusPoints;
      String bonusText = bonusPoints.toStringAsFixed(0);
      Color bonusLabelColor = CupertinoColors.label.resolveFrom(context);
      if (bonusPoints > 0) {
        bonusText = "+$bonusText";
        bonusLabelColor = CupertinoColors.systemGreen.resolveFrom(context);
      }
      if (bonusPoints < 0) {
        bonusLabelColor = CupertinoColors.systemRed.resolveFrom(context);
      }
      return CupertinoListSection.insetGrouped(
        header: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "Bonus",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ),
        children: [
          CupertinoListTile.notched(
            title: Text(
              bonusText,
              style: TextStyle(color: bonusLabelColor),
            ),
            trailing: Row(
              children: [
                SizedBox(
                  height: 30,
                  child: Button(
                    text: "-",
                    onPressed: provider.decrementBonusPoints,
                    type: ButtonType.tinted,
                    padding: EdgeInsets.all(0),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 30,
                  child: Button(
                    text: "+",
                    onPressed: provider.incrementBonusPoints,
                    type: ButtonType.tinted,
                    padding: EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
