import 'package:datz_flutter/consts.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class SliverHeader extends StatelessWidget {
  final double shrinkOffset;
  const SliverHeader({super.key, required this.shrinkOffset});

  @override
  Widget build(BuildContext context) {
    const maxExtent = 300;
    // final shrinkRatio = clampDouble(1 - shrinkOffset / maxExtent, 0, 1);
    final opacity = clampDouble(1 - 2 * shrinkOffset / maxExtent, 0, 1);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: CustomDecorations.primaryGradientDecoration(context),
        ),
        Positioned(
          left: 12.0,
          right: 12.0,
          bottom: 12.0 + opacity * 64,
          child: Consumer<ClassProvider>(builder:
              (BuildContext context, ClassProvider provider, Widget? child) {
            return Text(
              calcMainHeaderNumber(provider),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32 + opacity * 64,
                color: CupertinoColors.white,
              ),
            );
          }),
        ),
        Positioned(
          left: 12.0,
          right: 12.0,
          bottom: 12.0 - shrinkOffset / 2,
          child: Opacity(
            opacity: opacity,
            child: Consumer<ClassProvider>(builder:
                (BuildContext context, ClassProvider provider, Widget? child) {
              if (provider.selectedClass == null) return Container();

              List<String> semesterNames =
                  provider.selectedClass!.getSemesterNames();
              Map<int, Widget> options = {};
              for (int i = 0; i < semesterNames.length; i++) {
                options[i] = Text(
                  semesterNames[i],
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                );
              }
              options[semesterNames.length] = Text(
                "Total",
                style: CupertinoTheme.of(context).textTheme.textStyle,
              );
              return CupertinoSlidingSegmentedControl(
                groupValue: provider.selectedSemester,
                children: options,
                onValueChanged: (int? value) {
                  provider.selectSemester(value ?? 0);
                },
              );
            }),
          ),
        )
      ],
    );
  }

  String calcMainHeaderNumber(ClassProvider provider) {
    if (provider.selectedClass == null) return "";
    if (provider.isDisplayingTotalAvg()) {
      return provider.selectedClass!.formattedAvg();
    }
    return provider.getSelectedSemester()?.formattedAvg() ?? "";
  }
}
