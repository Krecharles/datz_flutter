import 'package:datz_flutter/components/Buttons.dart';
import 'package:datz_flutter/components/CustomeSliver.dart';
import 'package:datz_flutter/components/SlidableListView.dart';
import 'package:datz_flutter/components/SliverHeader.dart';
import 'package:datz_flutter/components/SubjectList.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomSliver(
        minExtent: 100,
        maxExtent: 300,
        buildHeader: (BuildContext context, double shrinkOffset) =>
            SliverHeader(shrinkOffset: shrinkOffset),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[
        SubjectList(),
        const SizedBox(height: 64),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<SlidableListProvider>(builder: (BuildContext context,
                SlidableListProvider provider, Widget? child) {
              return Button(
                text: provider.isInEditMode ? "Finish" : "Edit Class",
                leadingIcon: CupertinoIcons.pen,
                type: ButtonType.tinted,
                onPressed: provider.toggleEditMode,
              );
            }),
            // Button(
            //   text: "more",
            //   type: ButtonType.plain,
            //   onPressed: () {},
            // ),
          ],
        ),
      ],
    );
  }
}
