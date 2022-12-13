import 'package:datz_flutter/components/Buttons.dart';
import 'package:datz_flutter/model/ClassModel.dart';
import 'package:datz_flutter/model/TestModel.dart';
import 'package:datz_flutter/providers/ClassProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AddTestPage extends StatefulWidget {
  const AddTestPage({super.key});

  @override
  State<AddTestPage> createState() => _AddTestPageState();
}

class _AddTestPageState extends State<AddTestPage> {
  final TextEditingController _nameController =
      TextEditingController(text: "Test");
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _maxGradeController =
      TextEditingController(text: "60");

  void onSubmit() {
    print(_nameController.value.text);
    if (_nameController.value.text == "") {
      return alertError("Name cannot be Empty.");
    }
    if (double.tryParse(_gradeController.value.text) == null) {
      return alertError("Grade must be a Number");
    }
    if (double.tryParse(_maxGradeController.value.text) == null) {
      return alertError("Max Grade must be a Number");
    }
    Test newTest = Test(
      name: _nameController.value.text,
      grade: double.parse(_gradeController.value.text),
      maxGrade: double.parse(_maxGradeController.value.text),
    );
    addTest(newTest);
  }

  void addTest(Test newTest) {
    Provider.of<ClassProvider>(context, listen: false).addTest(newTest);
    Navigator.pop(context);
  }

  void alertError(String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "Back",
        middle: Text("Add Test"),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile.notched(
                    title: Text("Name"),
                    trailing: SizedBox(
                      width: 128,
                      child: CupertinoTextField(
                        autocorrect: false,
                        controller: _nameController,
                      ),
                    ),
                  ),
                  CupertinoListTile.notched(
                    title: Text("Grade"),
                    trailing: SizedBox(
                      width: 64,
                      child: CupertinoTextField(
                        placeholder: "45",
                        autocorrect: false,
                        controller: _gradeController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        // controller: TextEditingController(text: "Test 1"),
                      ),
                    ),
                  ),
                  CupertinoListTile.notched(
                    title: Text("Max Grade"),
                    trailing: SizedBox(
                      width: 64,
                      child: CupertinoTextField(
                        autocorrect: false,
                        controller: _maxGradeController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    type: ButtonType.filled,
                    text: "Add",
                    onPressed: onSubmit,
                    leadingIcon: CupertinoIcons.add,
                  ),
                ],
              ),
              // CupertinoTextField(),
            ],
          ),
        ),
      ),
    );
  }
}
