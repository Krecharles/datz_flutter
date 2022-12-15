import 'package:datz_flutter/components/SlidableListView.dart';
import 'package:datz_flutter/model/DataLoader.dart';
import 'package:datz_flutter/model/data.dart';
import 'package:datz_flutter/model/legacyDataLoader.dart';
import 'package:datz_flutter/model/ClassModel.dart';
import 'package:datz_flutter/pages/HomePage.dart';
import 'package:datz_flutter/providers/ClassProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // LegacyDataLoader.checkPreferences();

    // DataLoader.saveClass(myClass);

    return ChangeNotifierProvider<ClassProvider>(
      create: (_) => ClassProvider(),
      child: const CupertinoApp(
        title: 'Datz!',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        ),
        home: HomePage(),
      ),
    );
  }
}
