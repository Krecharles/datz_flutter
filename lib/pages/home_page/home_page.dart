import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/custom_sliver.dart';
import 'package:datz_flutter/pages/class_picker_page/class_picker_page.dart';
import 'package:datz_flutter/pages/home_page/home_page_sliver_header.dart';
import 'package:datz_flutter/pages/home_page/subject_list.dart';
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
            HomePageSliverHeader(shrinkOffset: shrinkOffset),
        body: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
              Button(
                text: "Change Class",
                type: ButtonType.plain,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: ((context) => const ClassPickerPage()),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
