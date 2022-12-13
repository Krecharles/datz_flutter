import 'package:datz_flutter/components/SlidableListView.dart';
import 'package:datz_flutter/model/legacyDataLoader.dart';
import 'package:datz_flutter/model/model.dart';
import 'package:datz_flutter/pages/HomePage.dart';
import 'package:datz_flutter/providers/ClassProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Class? _selectedClass;

  @override
  Widget build(BuildContext context) {
    LegacyDataLoader.checkPreferences();

    return ChangeNotifierProvider<ClassProvider>(
      create: (_) => ClassProvider(selectedClass: _selectedClass),
      child: ChangeNotifierProvider<SlidableListProvider>(
        create: (_) => SlidableListProvider(),
        child: const CupertinoApp(
          title: 'Datz!',
          debugShowCheckedModeBanner: false,
          theme: CupertinoThemeData(
            scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}
