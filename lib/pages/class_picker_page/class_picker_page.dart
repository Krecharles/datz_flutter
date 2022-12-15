import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/data_loader.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ClassPickerPage extends StatefulWidget {
  const ClassPickerPage({super.key});

  @override
  State<ClassPickerPage> createState() => _ClassPickerPageState();
}

class _ClassPickerPageState extends State<ClassPickerPage> {
  List<ClassMetaModel> _allClassMetaModels = [];
  List<Class> _userClassIds = [];

  void loadData() async {
    _allClassMetaModels = await DataLoader.loadAllClassMetaModels();
    _userClassIds = await DataLoader.loadAllClasses();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void onSelectUserClass(Class c) {
    Provider.of<ClassProvider>(context, listen: false).selectClass(c);
    Navigator.pop(context);
  }

  void onSelectNewClass(ClassMetaModel classData) {
    Class newClass = Class.fromMetaModel(classData);
    DataLoader.addClassId(newClass.id);
    DataLoader.saveActiveClassId(newClass.id);
    DataLoader.saveClass(newClass);

    Provider.of<ClassProvider>(context, listen: false).selectClass(newClass);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print("Userclass IDS: $_userClassIds");
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        // backgroundColor: CustomColors.color2,
        previousPageTitle: "Back",
        middle: Text(
          "Select Class",
          // style: TextStyle(color: Colors.white),
        ),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CupertinoListSection.insetGrouped(
                header: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Your Classes",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                ),
                children: [
                  // needed because otherwise listsection is temporarily empty
                  if (_userClassIds.isEmpty) Container(),
                  for (final c in _userClassIds)
                    CupertinoListTile.notched(
                      onTap: () => onSelectUserClass(c),
                      title: Text(c.name),
                    ),
                ],
              ),
              CupertinoListSection.insetGrouped(
                header: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Preset Classes",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                  ),
                ),
                children: [
                  // needed because otherwise listsection is temporarily empty
                  if (_allClassMetaModels.isEmpty) Container(),
                  for (final m in _allClassMetaModels)
                    CupertinoListTile.notched(
                      onTap: () => onSelectNewClass(m),
                      title: Text(m.name),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
