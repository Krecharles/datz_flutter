import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/forms/form_rows.dart';
import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/data_loader.dart';
import 'package:datz_flutter/pages/class_edit_page/class_creation_model.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ClassEditPage extends StatefulWidget {
  const ClassEditPage({super.key});

  @override
  State<ClassEditPage> createState() => _ClassEditPageState();
}

class _ClassEditPageState extends State<ClassEditPage> {
  final ClassCreationModel _subjectCreationModel = ClassCreationModel(
    useSemesters: true,
    hasExams: false,
  );

  void onSubmit() {
    String? errorMessage = _subjectCreationModel.validate();
    if (errorMessage != null) {
      return alertError(context, errorMessage);
    }
    ClassMetaModel metaModel = _subjectCreationModel.parseToMetaModel();

    Class newClass = Class.fromMetaModel(metaModel);
    DataLoader.addClassId(newClass.id);
    DataLoader.saveActiveClassId(newClass.id);
    DataLoader.saveClass(newClass);

    Provider.of<ClassProvider>(context, listen: false).selectClass(newClass);
    Navigator.pop(context); // pop to class picker
    Navigator.pop(context); // pop to homepage
  }

  void removeSubject(int subjectId) {
    setState(() {
      _subjectCreationModel.removeSubject(subjectId);
    });
  }

  void addSimpleSubject() {
    setState(() {
      _subjectCreationModel.addSimpleSubject();
    });
  }

  void addCombiSubject() {
    setState(() {
      _subjectCreationModel.addCombiSubject();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "Back",
        middle: Text(
          "Edit Class",
        ),
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Form(
            child: Column(
              children: [
                buildGeneralInformationForm(),
                buildSubjectsList(),
                const SizedBox(height: 32),
                buildSubmitButtonRow(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGeneralInformationForm() {
    return CupertinoListSection.insetGrouped(
      children: [
        TextFieldFormRow(
          controller: _subjectCreationModel.nameController,
          title: const Text("Name"),
          placeholder: "3MB",
        ),
        BoolFieldFormRow(
          title: const Text("Use Semesters"),
          value: _subjectCreationModel.useSemesters,
          onChanged: (newVal) => setState(() {
            _subjectCreationModel.useSemesters = newVal;
            if (!_subjectCreationModel.useSemesters &&
                _subjectCreationModel.hasExams) {
              _subjectCreationModel.hasExams = false;
            }
          }),
        ),
        BoolFieldFormRow(
          title: const Text("Has Exams"),
          value: _subjectCreationModel.hasExams,
          onChanged: (newVal) => setState(() {
            _subjectCreationModel.hasExams = newVal;
            if (!_subjectCreationModel.useSemesters &&
                _subjectCreationModel.hasExams) {
              _subjectCreationModel.useSemesters = true;
            }
          }),
        ),
      ],
    );
  }

  Widget buildSubjectsList() {
    return Column(
      children: [
        for (SubjectCreationModel subjectModel
            in _subjectCreationModel.subjects)
          CupertinoListSection.insetGrouped(children: [
            TextFieldFormRow(
              controller: subjectModel.nameController,
              title: const Text("Subject Name"),
              placeholder: "Allemand",
            ),
            StepperFieldFormRow(
              title: const Text("Coefficient"),
              value: subjectModel.coef,
              minValue: 1,
              maxValue: 99,
              onChanged: (int newValue) => setState(() {
                subjectModel.coef = newValue;
              }),
            ),
            if (subjectModel.subSubjects != null) ...[
              StepperFieldFormRow(
                title: const Text("Combi Subjects"),
                value: subjectModel.subSubjects!.length,
                minValue: 1,
                maxValue: 9,
                onChanged: (int newValue) => setState(() {
                  if (newValue > subjectModel.subSubjects!.length) {
                    subjectModel.addSubSubject();
                  }
                  if (newValue < subjectModel.subSubjects!.length) {
                    subjectModel.removeSubSubject();
                  }
                }),
              ),
              for (SubjectCreationModel subSubjectModel
                  in subjectModel.subSubjects!)
                ...buildSubSubject(subSubjectModel),
            ],
            CupertinoListTile.notched(
              title: Center(
                child: Text(
                  "Delete",
                  style: TextStyle(
                      color: CupertinoColors.systemRed.resolveFrom(context)),
                ),
              ),
              onTap: () => removeSubject(subjectModel.id),
            )
          ]),
      ],
    );
  }

  List<Widget> buildSubSubject(SubjectCreationModel subSubjectModel) {
    return [
      TextFieldFormRow(
        controller: subSubjectModel.nameController,
        title: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Text("Subject Name"),
        ),
        placeholder: "Allemand",
      ),
      StepperFieldFormRow(
        title: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Text("Coefficient"),
        ),
        value: subSubjectModel.coef,
        minValue: 1,
        maxValue: 99,
        onChanged: (int newValue) => setState(() {
          subSubjectModel.coef = newValue;
        }),
      ),
    ];
  }

  Widget buildSubmitButtonRow(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              type: ButtonType.tinted,
              text: "Subject",
              leadingIcon: CupertinoIcons.add,
              onPressed: addSimpleSubject,
              // leadingIcon: CupertinoIcons.add,
            ),
            const SizedBox(width: 8),
            Button(
              type: ButtonType.plain,
              text: "Combi",
              leadingIcon: CupertinoIcons.add,
              onPressed: addCombiSubject,
              // leadingIcon: CupertinoIcons.add,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              type: ButtonType.filled,
              text: "Save",
              onPressed: onSubmit,
              // leadingIcon: CupertinoIcons.add,
            ),
          ],
        ),
      ],
    );
  }
}
