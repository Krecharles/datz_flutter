import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/custom_sliver.dart';
import 'package:datz_flutter/components/sliver_header.dart';
import 'package:datz_flutter/components/subject_list.dart';
import 'package:flutter/cupertino.dart';

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
        const SubjectList(),
        const SizedBox(height: 64),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              text: "Edit Class",
              leadingIcon: CupertinoIcons.pen,
              type: ButtonType.tinted,
              onPressed: () {
                print("TODO edit class");
              },
            ),
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
