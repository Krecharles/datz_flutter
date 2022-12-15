import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SlidableListView<T> extends StatefulWidget {
  const SlidableListView({
    super.key,
    required this.childrenDataList,
    required this.childBuilder,
    this.headerLabelText,
    this.onEdit,
    this.onDelete,
  });

  final List<T> childrenDataList;
  final CupertinoListTile Function(BuildContext, T) childBuilder;
  final String? headerLabelText;
  final void Function(BuildContext, T)? onEdit;
  final void Function(BuildContext, T)? onDelete;

  @override
  State<SlidableListView> createState() => _SlidableListViewState<T>();
}

class _SlidableListViewState<T> extends State<SlidableListView> {
  final Set<SlidableController> _slidableControllers = {};
  late SlidableListProvider slidableListProvider;

  @override
  void initState() {
    super.initState();
    slidableListProvider =
        Provider.of<SlidableListProvider>(context, listen: false);
    slidableListProvider.subscribeEditModeListener(onChangeEditMode);
  }

  @override
  void dispose() {
    slidableListProvider.unSubscribeEditModeListener(onChangeEditMode);
    super.dispose();
  }

  void onChangeEditMode(bool isInEditMode) {
    if (isInEditMode) {
      showActions();
    } else {
      hideActions();
    }
  }

  void addController(SlidableController c) {
    _slidableControllers.add(c);
  }

  void removeController(SlidableController c) {
    _slidableControllers.remove(c);
  }

  void showActions() {
    for (final controller in _slidableControllers) {
      controller.openEndActionPane();
    }
  }

  void hideActions() {
    for (final controller in _slidableControllers) {
      controller.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: widget.headerLabelText == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                widget.headerLabelText!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ),
      children: [
        for (T listTileData in widget.childrenDataList)
          buildListTile(listTileData)
      ],
    );
  }

  Widget buildListTile(T listTileData) {
    // print("type of T: $T, type of func: ${widget.childBuilder} ");
    // Widget w = widget.childBuilder(context, listTileData);
    return Slidable(
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (widget.onEdit != null)
            SlidableAction(
              // An action can be bigger than the others.
              onPressed: (BuildContext context) =>
                  widget.onEdit!(context, listTileData),
              backgroundColor: CupertinoColors.systemBlue,
              label: 'Edit',
            ),
          if (widget.onDelete != null)
            SlidableAction(
              onPressed: (BuildContext context) =>
                  widget.onDelete!(context, listTileData),
              backgroundColor: CupertinoColors.systemRed,
              label: 'Delete',
            ),
        ],
      ),

      child: SlidableControllerSender(
        addController: addController,
        removeController: removeController,
        child: Container(),
      ),
    );
  }
}

class SlidableControllerSender extends StatefulWidget {
  const SlidableControllerSender({
    Key? key,
    this.child,
    required this.addController,
    required this.removeController,
  }) : super(key: key);

  final Widget? child;
  final Function addController;
  final Function removeController;

  @override
  _SlidableControllerSenderState createState() =>
      _SlidableControllerSenderState();
}

class _SlidableControllerSenderState extends State<SlidableControllerSender> {
  SlidableController? controller;

  @override
  void initState() {
    super.initState();
    controller = Slidable.of(context);
    widget.addController(controller);
  }

  @override
  void dispose() {
    widget.removeController(controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}

class SlidableListProvider extends ChangeNotifier {
  bool isInEditMode;
  Set<Function> listeners = {};

  SlidableListProvider({this.isInEditMode = false});

  void toggleEditMode() {
    isInEditMode = !isInEditMode;
    notifyListeners();
    for (final listener in listeners) {
      listener(isInEditMode);
    }
  }

  void subscribeEditModeListener(Function callback) {
    listeners.add(callback);
  }

  void unSubscribeEditModeListener(Function callback) {
    listeners.remove(callback);
  }
}
