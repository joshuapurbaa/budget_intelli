import 'dart:async';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class BudgetFormFieldInitial extends StatefulWidget {
  const BudgetFormFieldInitial({
    required this.fromInitial,
    required this.budgetId,
    required this.groupCategories,
    required this.portions,
    super.key,
  });

  final bool fromInitial;
  final List<GroupCategoryHistory> groupCategories;
  final List<double> portions;
  final String budgetId;

  @override
  State<BudgetFormFieldInitial> createState() => _BudgetFormFieldInitialState();
}

class _BudgetFormFieldInitialState extends State<BudgetFormFieldInitial> {
  // Constants
  static const _groupNameInitialEN = 'Group Name';
  static const _groupNameInitialID = 'Nama Grup';
  static const _categoryNameInitialEN = 'Category Name';
  static const _categoryNameInitialID = 'Nama Kategori';

  // Controllers and Focus Nodes
  final List<List<TextEditingController>> _leftTextEditingControllers = [];
  final List<List<TextEditingController>> _rightTextEditingControllers = [];
  final List<TextEditingController> _groupNameTextEditingControllers = [];
  final List<List<FocusNode>> _leftFocusNodes = [];
  final List<List<FocusNode>> _rightFocusNodes = [];
  final List<FocusNode> _groupNameFocusNodes = [];
  final List<Color> _pickerColor = [];
  final Map<String, Timer?> _debounceTimers = {};

  bool _controllersInitialized = false;

  @override
  void didUpdateWidget(covariant BudgetFormFieldInitial oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('didUpdateWidget');
    if (oldWidget.groupCategories.length != widget.groupCategories.length) {
      debugPrint(
          'didUpdateWidget: ${oldWidget.groupCategories.length} != ${widget.groupCategories.length}');
      _controllersInitialized = false;
      _initControllers();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('didChangeDependencies');
    if (!_controllersInitialized) {
      debugPrint('didChangeDependencies: _controllersInitialized = false');
      _initControllers();
      _controllersInitialized = true;
    }
  }

  void _initControllers() {
    debugPrint('initControllers: _controllersInitialized = false');
    setState(() {
      _clearAllControllers();
      _createControllersForGroups();
    });
  }

  void _clearAllControllers() {
    debugPrint('clearAllControllers');
    _groupNameTextEditingControllers.clear();
    _leftTextEditingControllers.clear();
    _rightTextEditingControllers.clear();
    _groupNameFocusNodes.clear();
    _leftFocusNodes.clear();
    _rightFocusNodes.clear();
    _pickerColor.clear();
  }

  void _createControllersForGroups() {
    debugPrint('createControllersForGroups');
    for (var i = 0; i < widget.groupCategories.length; i++) {
      final groupCategory = widget.groupCategories[i];
      _createGroupController(groupCategory);
      _createItemControllers(groupCategory.itemCategoryHistories);
      _pickerColor.add(Color(groupCategory.hexColor));
    }
  }

  void _createGroupController(GroupCategoryHistory groupCategory) {
    debugPrint('createGroupController');
    final groupName = groupCategory.groupName;
    final isInitialName = _isInitialGroupName(groupName);

    _groupNameTextEditingControllers.add(
      TextEditingController(text: isInitialName ? '' : groupName),
    );
    _groupNameFocusNodes.add(FocusNode());
  }

  void _createItemControllers(List<ItemCategoryHistory> itemCategories) {
    debugPrint('createItemControllers :: ${itemCategories.length}');
    final leftControllers = <TextEditingController>[];
    final rightControllers = <TextEditingController>[];
    final leftFocusNodes = <FocusNode>[];
    final rightFocusNodes = <FocusNode>[];

    for (final item in itemCategories) {
      debugPrint('createItemControllers :: ${item.name}');
      final isInitialName = _isInitialCategoryName(item.name);

      leftControllers.add(
        TextEditingController(text: isInitialName ? '' : item.name),
      );
      leftFocusNodes.add(FocusNode());

      rightControllers.add(
        TextEditingController(
          text: item.amount > 0
              ? NumberFormatter.formatToMoneyDouble(context, item.amount)
              : '',
        ),
      );
      rightFocusNodes.add(FocusNode());
    }

    _leftTextEditingControllers.add(leftControllers);
    _rightTextEditingControllers.add(rightControllers);
    _leftFocusNodes.add(leftFocusNodes);
    _rightFocusNodes.add(rightFocusNodes);
  }

  bool _isInitialGroupName(String name) {
    return name.isEmpty ||
        name == _groupNameInitialID ||
        name == _groupNameInitialEN;
  }

  bool _isInitialCategoryName(String name) {
    if (name.isEmpty ||
        name == _categoryNameInitialID ||
        name == _categoryNameInitialEN) {
      return true;
    }

    // Only check localized strings if context is available
    try {
      final localize = textLocalizer(context);
      return name == localize.selectCategory ||
          name == localize.typeCategoryName ||
          name == localize.categoryName;
    } on Exception catch (_) {
      // If localization isn't available yet, just return false
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: getEdgeInsets(left: 16, right: 16),
      sliver: SliverList.separated(
        itemCount: widget.groupCategories.length,
        itemBuilder: _buildGroupItem,
        separatorBuilder: (context, index) => Gap.vertical(8),
      ),
    );
  }

  Widget _buildGroupItem(BuildContext context, int indexGroup) {
    final groupCategory = widget.groupCategories[indexGroup];
    final isLast = indexGroup == widget.groupCategories.length - 1;

    return Column(
      children: [
        AppGlass(
          child: _buildGroupContent(context, groupCategory, indexGroup),
        ),
        if (isLast && widget.fromInitial) ...[
          Gap.vertical(8),
          _buildAddGroupButton(context),
        ],
      ],
    );
  }

  Widget _buildGroupContent(
    BuildContext context,
    GroupCategoryHistory groupCategory,
    int indexGroup,
  ) {
    final localize = textLocalizer(context);
    final isIncome = groupCategory.type == 'income';
    final title = isIncome ? localize.income : localize.expenses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGroupHeader(context, groupCategory, indexGroup, title),
        Gap.vertical(10),
        const AppDivider(),
        Gap.vertical(5),
        _buildGroupNameRow(context, groupCategory, indexGroup, isIncome),
        Gap.vertical(10),
        _buildItemsList(context, groupCategory, indexGroup),
        Gap.vertical(10),
        _buildAddItemButton(context, groupCategory, indexGroup),
      ],
    );
  }

  Widget _buildGroupHeader(
    BuildContext context,
    GroupCategoryHistory groupCategory,
    int indexGroup,
    String title,
  ) {
    final colorOnSurface = context.color.onSurface.withValues(alpha: 0.5);
    final isExpense = groupCategory.type == 'expense';
    final portions =
        widget.portions.where((element) => !element.isNaN).toList();

    String? portionStr;
    if (portions.isNotEmpty && isExpense && portions.length != 1) {
      portionStr =
          '${portions[indexGroup].toStringAsFixed(2)}%'.replaceAll('.00', '');
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: () => IncomeExpenseDialog.showInfoDialog(
            context,
            isIncome: groupCategory.type == 'income',
            isExpense: isExpense,
          ),
          child: Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: title,
                  style: StyleType.bodSm,
                  color: colorOnSurface,
                ),
                Gap.horizontal(5),
                Icon(
                  CupertinoIcons.info_circle,
                  size: 17,
                  color: colorOnSurface,
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppText(
              text: portionStr ?? '',
              style: StyleType.bodMed,
            ),
            Gap.horizontal(10),
            GestureDetector(
              onTap: () => _onPaintBrushTap(indexGroup),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Color(groupCategory.hexColor),
                child: Icon(
                  CupertinoIcons.paintbrush,
                  color: context.color.onSurface,
                  size: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroupNameRow(
    BuildContext context,
    GroupCategoryHistory groupCategory,
    int indexGroup,
    bool isIncome,
  ) {
    final localize = textLocalizer(context);
    final colorOnSurface = context.color.onSurface.withValues(alpha: 0.5);
    final hintColorGroupName = _isInitialGroupName(groupCategory.groupName)
        ? colorOnSurface
        : context.color.onSurface;

    return Row(
      children: [
        Expanded(
          child: isIncome
              ? AppText(
                  text: groupCategory.groupName,
                  style: StyleType.bodLg,
                )
              : TextField(
                  controller: _groupNameTextEditingControllers[indexGroup],
                  focusNode: _groupNameFocusNodes[indexGroup],
                  onSubmitted: (_) => _unfocusAll(),
                  onChanged: (value) => _updateGroupName(groupCategory, value),
                  style: textStyle(context, style: StyleType.bodLg),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: groupCategory.groupName,
                    hintStyle: textStyle(context, style: StyleType.bodLg)
                        .copyWith(color: hintColorGroupName),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
        ),
        if (!isIncome && widget.groupCategories.length > 2)
          GestureDetector(
            onTap: () => _removeGroupCategory(groupCategory, indexGroup),
            child: Icon(
              Icons.delete,
              color: context.color.primary.withValues(alpha: 0.5),
            ),
          ),
        Gap.horizontal(20),
        AppText(
          text: localize.planned,
          style: StyleType.bodSm,
        ),
      ],
    );
  }

  Widget _buildItemsList(
    BuildContext context,
    GroupCategoryHistory groupCategory,
    int indexGroup,
  ) {
    debugPrint(
        'buildItemsList: ${_leftTextEditingControllers[indexGroup].length}');
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _leftTextEditingControllers[indexGroup].length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, indexItem) => _buildItemRow(
        context,
        groupCategory,
        indexGroup,
        indexItem,
      ),
      separatorBuilder: (context, index) => Gap.vertical(5),
    );
  }

  Widget _buildItemRow(
    BuildContext context,
    GroupCategoryHistory groupCategory,
    int indexGroup,
    int indexItem,
  ) {
    final currency = context.read<SettingBloc>().state.currency;
    final item = groupCategory.itemCategoryHistories[indexItem];
    final colorOnSurface = context.color.onSurface.withValues(alpha: 0.5);
    final baseStyle = _isInitialCategoryName(item.name)
        ? textStyle(context, style: StyleType.bodMed).copyWith(
            color: colorOnSurface,
            fontWeight: FontWeight.w400,
          )
        : textStyle(context, style: StyleType.bodMed);

    final colorRightHintText = context.color.onSurface;

    final currencyFormatter = CurrencyTextInputFormatter.currency(
      locale: context.l10n.localeName,
      symbol: currency.symbol,
      decimalDigits: 0,
    );

    const radiusCircular = Radius.circular(10);
    debugPrint(
        'buildItemRow: $indexGroup, $indexItem, ${item.name} ${item.amount}');

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              TextField(
                controller: _leftTextEditingControllers[indexGroup][indexItem],
                focusNode: _leftFocusNodes[indexGroup][indexItem],
                onSubmitted: (_) => _unfocusAll(),
                onChanged: (value) {
                  _updateItemName(item, groupCategory.id, value);
                },
                style: baseStyle,
                decoration: InputDecoration(
                  hintText: item.name,
                  hintStyle: baseStyle,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              Divider(
                color: context.color.primaryContainer.withValues(alpha: 0.4),
                height: 0,
                thickness: 0.5,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: TextField(
            controller: _rightTextEditingControllers[indexGroup][indexItem],
            focusNode: _rightFocusNodes[indexGroup][indexItem],
            textAlign: TextAlign.end,
            style: textStyle(context, style: StyleType.bodMed)
                .copyWith(color: colorRightHintText),
            keyboardType: TextInputType.number,
            inputFormatters: [currencyFormatter],
            onChanged: (value) =>
                _updateItemAmount(item, groupCategory.id, value),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              hintText:
                  NumberFormatter.formatToMoneyDouble(context, item.amount),
              hintStyle: textStyle(context, style: StyleType.bodMed)
                  .copyWith(color: colorRightHintText),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: radiusCircular,
                  bottomRight: radiusCircular,
                  topRight: radiusCircular,
                ),
                borderSide: BorderSide.none,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: radiusCircular,
                  bottomRight: radiusCircular,
                  topRight: radiusCircular,
                ),
                borderSide: BorderSide.none,
              ),
              fillColor: context.color.onSurface.withValues(alpha: 0.1),
              filled: true,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _removeItemCategory(
              item, groupCategory.id, indexGroup, indexItem),
          child: Icon(
            Icons.delete,
            color: context.color.primary.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildAddItemButton(
    BuildContext context,
    GroupCategoryHistory groupCategory,
    int indexGroup,
  ) {
    final localize = textLocalizer(context);
    return GestureDetector(
      onTap: () => _addNewItem(groupCategory, indexGroup),
      child: AppText(
        text: '+ ${localize.add} ${groupCategory.groupName}',
        style: StyleType.bodMed,
        color: context.color.primary,
      ),
    );
  }

  Widget _buildAddGroupButton(BuildContext context) {
    final localize = textLocalizer(context);
    return GestureDetector(
      onTap: _addNewGroup,
      child: AppGlass(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: context.color.primary),
            Gap.horizontal(10),
            AppText(
              text: localize.addGroupCategory,
              style: StyleType.bodMed,
              color: context.color.primary,
            ),
          ],
        ),
      ),
    );
  }

  // Event Handlers
  void _updateGroupName(GroupCategoryHistory groupCategory, String value) {
    context.read<BudgetFormBloc>().add(
          UpdateGroupCategoryHistory(
            groupCategoryHistory: groupCategory.copyWith(groupName: value),
          ),
        );
  }

  void _updateItemName(ItemCategoryHistory item, String groupId, String value) {
    final newCategory = item.copyWith(name: value);
    _onChangeField(newCategory, groupId);
  }

  void _updateItemAmount(
      ItemCategoryHistory item, String groupId, String value) {
    final amount = double.tryParse(value) ?? 0.0;
    final newCategory = item.copyWith(amount: amount);
    _onChangeField(newCategory, groupId);
  }

  void _removeGroupCategory(
      GroupCategoryHistory groupCategory, int indexGroup) {
    _unfocusAll();
    _onRemoveGroupCategory(
        groupCategory.id, groupCategory.itemCategoryHistories);

    setState(() {
      _removeControllersAtIndex(indexGroup);
    });
  }

  void _removeItemCategory(
    ItemCategoryHistory item,
    String groupId,
    int indexGroup,
    int indexItem,
  ) {
    _unfocusAll();
    _onRemoveItemCategory(item, groupId);

    setState(() {
      _leftTextEditingControllers[indexGroup].removeAt(indexItem);
      _rightTextEditingControllers[indexGroup].removeAt(indexItem);
      _leftFocusNodes[indexGroup].removeAt(indexItem);
      _rightFocusNodes[indexGroup].removeAt(indexItem);
    });
  }

  void _addNewItem(GroupCategoryHistory groupCategory, int indexGroup) {
    _unfocusAll();
    final localize = textLocalizer(context);
    final itemId = const Uuid().v1();
    final newItem = ItemCategoryHistory(
      id: itemId,
      type: groupCategory.type,
      name: localize.categoryName,
      groupHistoryId: groupCategory.id,
      itemId: const Uuid().v1(),
      budgetId: widget.budgetId,
      createdAt: DateTime.now().toString(),
      isExpense: groupCategory.type == 'expense',
      groupName: groupCategory.groupName,
    );

    context.read<BudgetFormBloc>().add(
          AddItemCategoryHistory(
            groupId: groupCategory.id,
            itemCategory: newItem,
          ),
        );

    setState(() {
      _leftTextEditingControllers[indexGroup].add(TextEditingController());
      _rightTextEditingControllers[indexGroup].add(TextEditingController());
      _leftFocusNodes[indexGroup].add(FocusNode());
      _rightFocusNodes[indexGroup].add(FocusNode());
    });
  }

  Future<void> _addNewGroup() async {
    _unfocusAll();
    final newGroupId = const Uuid().v1();
    final newItemId = const Uuid().v1();
    final language = await SettingPreferenceRepo().getLanguage();
    final isIndonesia = language == AppStrings.indonesia;

    final newGroup = GroupCategoryHistory(
      id: newGroupId,
      groupName: isIndonesia ? _groupNameInitialID : _groupNameInitialEN,
      type: AppStrings.expenseType,
      groupId: const Uuid().v1(),
      createdAt: DateTime.now().toString(),
      hexColor: 0xFFF44336,
      itemCategoryHistories: [
        ItemCategoryHistory(
          id: newItemId,
          groupHistoryId: newGroupId,
          budgetId: widget.budgetId,
          itemId: const Uuid().v1(),
          name: isIndonesia ? _categoryNameInitialID : _categoryNameInitialEN,
          type: AppStrings.expenseType,
          createdAt: DateTime.now().toString(),
          isExpense: true,
          groupName: isIndonesia ? _groupNameInitialID : _groupNameInitialEN,
        ),
      ],
    );

    _onNewGroup(newGroup);
  }

  void _removeControllersAtIndex(int index) {
    _groupNameTextEditingControllers.removeAt(index);
    _leftTextEditingControllers.removeAt(index);
    _rightTextEditingControllers.removeAt(index);
    _groupNameFocusNodes.removeAt(index);
    _leftFocusNodes.removeAt(index);
    _rightFocusNodes.removeAt(index);
    _pickerColor.removeAt(index);
  }

  // BLoC Event Methods
  void _onChangeField(ItemCategoryHistory newCategory, String groupId) {
    context.read<BudgetFormBloc>().add(
          UpdateItemCategoryEventInitialCreate(
            groupHistoId: groupId,
            itemHistoId: newCategory.id,
            itemCategoryHistory: newCategory,
          ),
        );
  }

  void _onChangeValueEmpty(
      ItemCategoryHistory newCategory, String groupId, String value) {
    context.read<BudgetFormBloc>().add(
          UpdateItemCategoryEventInitialCreate(
            groupHistoId: groupId,
            itemHistoId: newCategory.id,
            itemCategoryHistory: newCategory.copyWith(amount: 0),
          ),
        );
  }

  void _onRemoveItemCategory(ItemCategoryHistory item, String groupId) {
    context.read<BudgetFormBloc>().add(
          RemoveItemCategoryFromInitial(
            groupHistoId: groupId,
            itemHistoId: item.id,
          ),
        );
  }

  void _onRemoveGroupCategory(
    String groupId,
    List<ItemCategoryHistory> itemCategories,
  ) {
    context.read<BudgetFormBloc>().add(
          RemoveGroupCategoryHistory(groupHistoId: groupId),
        );

    for (final item in itemCategories) {
      context.read<BudgetFormBloc>().add(
            RemoveItemCategoryFromInitial(
              groupHistoId: groupId,
              itemHistoId: item.id,
            ),
          );
    }
  }

  void _onNewGroup(GroupCategoryHistory newGroup) {
    context.read<BudgetFormBloc>().add(
          AddGroupCategoryHistory(groupCategoryHisto: newGroup),
        );

    setState(() {
      _groupNameTextEditingControllers.add(TextEditingController());
      _leftTextEditingControllers.add([TextEditingController()]);
      _rightTextEditingControllers.add([TextEditingController()]);
      _leftFocusNodes.add([FocusNode()]);
      _rightFocusNodes.add([FocusNode()]);
      _groupNameFocusNodes.add(FocusNode());
      _pickerColor.add(Color(newGroup.hexColor));
    });
  }

  void _onPaintBrushTap(int index) {
    final localize = textLocalizer(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          text: localize.pickAColor,
          style: StyleType.headMed,
        ),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: _pickerColor[index],
            onColorChanged: (color) =>
                setState(() => _pickerColor[index] = color),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final color = _pickerColor[index].toARGB32().toRadixString(16);
              final hexColor = int.parse(color, radix: 16);

              context.read<BudgetFormBloc>().add(
                    UpdateGroupCategoryHistory(
                      groupCategoryHistory:
                          widget.groupCategories[index].copyWith(
                        hexColor: hexColor,
                      ),
                    ),
                  );
              context.pop();
            },
            child: AppText(text: localize.save, style: StyleType.bodLg),
          ),
        ],
      ),
    );
  }

  void _unfocusAll() {
    for (final focusNode in _groupNameFocusNodes) {
      focusNode.unfocus();
    }
    for (final focusNodeList in _leftFocusNodes) {
      for (final focusNode in focusNodeList) {
        focusNode.unfocus();
      }
    }
    for (final focusNodeList in _rightFocusNodes) {
      for (final focusNode in focusNodeList) {
        focusNode.unfocus();
      }
    }
  }

  @override
  void dispose() {
    // Cancel all debounce timers
    for (final timer in _debounceTimers.values) {
      timer?.cancel();
    }
    _debounceTimers.clear();

    // Dispose all controllers and focus nodes
    for (final controller in _groupNameTextEditingControllers) {
      controller.dispose();
    }
    for (final controllerList in _leftTextEditingControllers) {
      for (final controller in controllerList) {
        controller.dispose();
      }
    }
    for (final controllerList in _rightTextEditingControllers) {
      for (final controller in controllerList) {
        controller.dispose();
      }
    }
    for (final focusNode in _groupNameFocusNodes) {
      focusNode.dispose();
    }
    for (final focusNodeList in _leftFocusNodes) {
      for (final focusNode in focusNodeList) {
        focusNode.dispose();
      }
    }
    for (final focusNodeList in _rightFocusNodes) {
      for (final focusNode in focusNodeList) {
        focusNode.dispose();
      }
    }
    super.dispose();
  }
}
