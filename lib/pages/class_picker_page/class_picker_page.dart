import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/data_loader.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ClassPickerPage extends StatefulWidget {
  const ClassPickerPage({super.key});

  @override
  State<ClassPickerPage> createState() => _ClassPickerPageState();
}

class _ClassPickerPageState extends State<ClassPickerPage> {
  List<ClassMetaModel> _allClassMetaModels = [];
  List<Class> _userClasses = [];

  void loadData() async {
    _allClassMetaModels = await DataLoader.loadAllClassMetaModels();
    _userClasses = await DataLoader.loadAllClasses();
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

  onDeleteClass(Class c) {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Delete Class ${c.name}?'),
        content: const Text('Data in this class will be lost forever.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              classProvider.deleteClass(context, c.id);
              loadData();
            },
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              buildUserClasses(context),
              buildPresetClasses(context),
            ],
          ),
        ),
      ),
    );
  }

  CupertinoListSection buildUserClasses(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Your Classes",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ),
      children: [
        // needed because otherwise listsection is temporarily empty
        if (_userClasses.isEmpty) Container(),
        for (final c in _userClasses)
          Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => onDeleteClass(c),
                  backgroundColor: CupertinoColors.systemRed,
                  label: 'Delete',
                ),
              ],
            ),
            child: CupertinoListTile.notched(
              onTap: () => onSelectUserClass(c),
              title: Text(c.name),
            ),
          ),
      ],
    );
  }

  CupertinoListSection buildPresetClasses(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Preset Classes",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
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
    );
  }
}
