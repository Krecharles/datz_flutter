import 'package:datz_flutter/components/forms/form_rows.dart';
import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/model/test_model.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TestEditPage extends StatefulWidget {
  /// indicates if it is a new test or modifying an existing one
  final Test? editTest;
  final void Function(Test) onSubmit;

  const TestEditPage({
    super.key,
    this.editTest,
    required this.onSubmit,
  });

  @override
  State<TestEditPage> createState() => _TestEditPageState();
}

class _TestEditPageState extends State<TestEditPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  TextEditingController _maxGradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.editTest?.name ?? "Test");
    _gradeController =
        TextEditingController(text: widget.editTest?.grade.toString());
    _maxGradeController =
        TextEditingController(text: "${widget.editTest?.maxGrade ?? 60}");
  }

  void onSubmit() {
    if (_nameController.value.text == "") {
      return alertError(context, "Name cannot be Empty.");
    }
    if (double.tryParse(_gradeController.value.text) == null) {
      return alertError(context, "Grade must be a Number");
    }
    if (double.tryParse(_maxGradeController.value.text) == null) {
      return alertError(context, "Max Grade must be a Number");
    }
    Test newTest = Test(
      id: widget.editTest?.id,
      name: _nameController.value.text,
      grade: double.parse(_gradeController.value.text),
      maxGrade: double.parse(_maxGradeController.value.text),
    );
    widget.onSubmit(newTest);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: "Back",
        middle: Text(
          widget.editTest == null ? "Add Test" : "Edit Test",
        ),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              buildInputForm(),
              const SizedBox(height: 32),
              buildSubmitButtonRow(context),
            ],
          ),
        ),
      ),
    );
  }

  CupertinoListSection buildInputForm() {
    return CupertinoListSection.insetGrouped(
      children: [
        TextFieldFormRow(
            title: const Text("Name"), controller: _nameController),
        NumberFieldFormRow(
            title: const Text("Grade"),
            placeholder: "45",
            controller: _gradeController),
        NumberFieldFormRow(
            title: const Text("Max Grade"), controller: _maxGradeController),
      ],
    );
  }

  Row buildSubmitButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button(
          type: ButtonType.filled,
          text: widget.editTest == null ? "Add" : "Save",
          onPressed: onSubmit,
          // leadingIcon: CupertinoIcons.add,
        ),
        if (widget.editTest != null) ...[
          const SizedBox(width: 4),
          Button(
            type: ButtonType.plain,
            color: CupertinoColors.systemRed,
            text: "Delete",
            onPressed: () {
              Provider.of<ClassProvider>(context, listen: false)
                  .deleteTest(widget.editTest!.id);
              Navigator.pop(context);
            },
            // leadingIcon: CupertinoIcons.trash,
          ),
        ]
      ],
    );
  }
}
