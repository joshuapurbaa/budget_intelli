import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/view/controllers/category/category_cubit.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

// Constants
class _Constants {
  static const String groupNameInitialEN = 'Group Name';
  static const String groupNameInitialID = 'Nama Grup';
  static const String categoryNameInitialEN = 'Category Name';
  static const String categoryNameInitialID = 'Nama Kategori';
  static const String expenseType = 'expense';
  static const double colorPickerRadius = 14.0;
  static const double colorPickerIconSize = 12.0;
  static const double dropdownMenuHeight = 300.0;
}

class FormNewBudgetGroup extends StatefulWidget {
  const FormNewBudgetGroup({
    required this.fromInitial,
    required this.isIncome,
    required this.groupCategoryHistory,
    required this.itemCategoryHistories,
    required this.budgetId,
    required this.categoryType,
    required this.allItemCategoryHistories,
    super.key,
  });

  final bool fromInitial;
  final bool isIncome;
  final GroupCategoryHistory groupCategoryHistory;
  final List<ItemCategoryHistory> itemCategoryHistories;
  final String budgetId;
  final String categoryType;
  final List<ItemCategoryHistory> allItemCategoryHistories;

  @override
  State<FormNewBudgetGroup> createState() => _FormNewBudgetGroupState();
}

class _FormNewBudgetGroupState extends State<FormNewBudgetGroup> {
  // State variables
  String categoryTypeLocal = _Constants.expenseType;
  bool isExpense = true;
  bool addNewGroup = false;
  bool categoryNameExists = false;

  // Controllers and focus nodes
  final List<TextEditingController> _leftControllers = [];
  final List<TextEditingController> _rightControllers = [];
  final List<FocusNode> _leftFocusNodes = [];
  final List<FocusNode> _rightFocusNodes = [];
  final _groupNameController = TextEditingController();
  final _groupNameFocusNode = FocusNode();

  // Category selection state
  GroupCategory? _selectedGroupCategory;
  final _selectedItemCategory = <ItemCategory?>[];
  List<bool> _addNewCategoryField = [];

  Color? _pickerColor;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _pickerColor = Color(widget.groupCategoryHistory.hexColor);
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    final itemCount = widget.itemCategoryHistories.length;
    for (var i = 0; i < itemCount; i++) {
      _addNewCategoryField.add(false);
      _selectedItemCategory.add(null);
      _leftControllers.add(TextEditingController());
      _rightControllers.add(TextEditingController());
      _leftFocusNodes.add(FocusNode());
      _rightFocusNodes.add(FocusNode());
    }
  }

  void _disposeControllers() {
    _groupNameController.dispose();
    _groupNameFocusNode.dispose();

    for (var i = 0; i < _leftControllers.length; i++) {
      _leftControllers[i].dispose();
      _rightControllers[i].dispose();
      _leftFocusNodes[i].dispose();
      _rightFocusNodes[i].dispose();
    }
  }

  void _onChangeField(ItemCategoryHistory newCategory) {
    final groupId = widget.groupCategoryHistory.id;
    final event = widget.fromInitial
        ? UpdateItemCategoryEventInitialCreate(
            groupHistoId: groupId,
            itemHistoId: newCategory.id,
            itemCategoryHistory: newCategory,
          )
        : UpdateItemCategoryHistoryEvent(
            groupId: groupId,
            itemId: newCategory.id,
            itemCategory: newCategory,
          );

    context.read<BudgetFormBloc>().add(event);
  }

  void _onChangeValueEmpty(ItemCategoryHistory newCategory) {
    final categoryWithZeroAmount = newCategory.copyWith(amount: 0);
    _onChangeField(categoryWithZeroAmount);
  }

  void _onRemoveItemCategory(ItemCategoryHistory item) {
    final groupId = widget.groupCategoryHistory.id;
    final event = widget.fromInitial
        ? RemoveItemCategoryFromInitial(
            groupHistoId: groupId,
            itemHistoId: item.id,
          )
        : RemoveItemCategoryFromInside(
            groupId: groupId,
            itemId: item.id,
          );

    context.read<BudgetFormBloc>().add(event);
  }

  void _changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  void _onPaintBrushTap() {
    final localize = textLocalizer(context);
    AppDialog.showCustomDialog(
      context,
      title: AppText(
        text: localize.pickAColor,
        style: StyleType.headMed,
      ),
      content: MaterialPicker(
        pickerColor: _pickerColor ?? Colors.red,
        onColorChanged: _changeColor,
      ),
      actions: [
        AppButton(
          label: localize.save,
          onPressed: _saveColorSelection,
        ),
      ],
    );
  }

  void _saveColorSelection() {
    final color = _pickerColor!.toARGB32().toRadixString(16);
    final hexColor = int.parse(color, radix: 16);

    context.read<BudgetFormBloc>().add(
          UpdateGroupCategoryHistory(
            groupCategoryHistory: widget.groupCategoryHistory.copyWith(
              hexColor: hexColor,
            ),
          ),
        );
    context.pop();
  }

  bool _isGroupNamePlaceholder(String groupName, String localizedGroupName) {
    return groupName.isEmpty ||
        groupName == _Constants.groupNameInitialEN ||
        groupName == _Constants.groupNameInitialID ||
        groupName == localizedGroupName;
  }

  bool _isCategoryNamePlaceholder(String itemName, String selectCategory,
      String typeCategoryName, String categoryName) {
    return itemName.isEmpty ||
        itemName == _Constants.categoryNameInitialID ||
        itemName == _Constants.categoryNameInitialEN ||
        itemName == selectCategory ||
        itemName == typeCategoryName ||
        itemName == categoryName;
  }

  TextStyle _getTextStyle(bool isPlaceholder) {
    final baseStyle = textStyle(context, style: StyleType.bodMed);

    if (isPlaceholder) {
      return baseStyle.copyWith(
        color: context.color.onSurface.withValues(alpha: 0.3),
        fontWeight: FontWeight.w400,
      );
    }
    return baseStyle;
  }

  Widget _buildColorPicker(int hexColor) {
    return GestureDetector(
      onTap: _onPaintBrushTap,
      child: CircleAvatar(
        radius: _Constants.colorPickerRadius,
        backgroundColor: Color(hexColor),
        child: Icon(
          CupertinoIcons.paintbrush,
          color: context.color.onSurface,
          size: _Constants.colorPickerIconSize,
        ),
      ),
    );
  }

  Widget _buildRadioOption(
      String label, String value, String groupValue, String groupId,
      {required bool isExpenses}) {
    return Row(
      children: [
        Radio.adaptive(
          value: value,
          groupValue: groupValue,
          onChanged: (value) => context.read<BudgetFormBloc>().add(
                UpdateGroupCategoryHistoryType(
                  groupId: groupId,
                  type: value.toString(),
                  isExpenses: isExpenses,
                ),
              ),
        ),
        Gap.horizontal(8),
        AppText(text: label, style: StyleType.bodMed),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final groupCategoryHistory = widget.groupCategoryHistory;
    final itemCategoryHistories = widget.itemCategoryHistories;
    final type = widget.categoryType;
    final groupId = groupCategoryHistory.id;
    final groupName = groupCategoryHistory.groupName;
    final hexColor = groupCategoryHistory.hexColor;

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final groupCategories = state.groupCategories;
        final itemCategories = state.itemCategories;
        final groupCategoryHistoriesCurrentBudgetId =
            state.groupCategoryHistoriesCurrentBudgetId;
        final itemCategoryHistoriesCurrentBudgetId =
            state.itemCategoryHistoriesCurrentBudgetId;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group type selection
            if (addNewGroup) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRadioOption(
                      localize.expenses, AppStrings.expenseType, type, groupId,
                      isExpenses: true),
                  _buildRadioOption(
                      localize.income, AppStrings.incomeType, type, groupId,
                      isExpenses: false),
                  Gap.horizontal(10),
                  _buildColorPicker(hexColor),
                ],
              ),
              Gap.vertical(5),
              const AppDivider(),
              Gap.vertical(5),
            ] else ...[
              Stack(
                children: [
                  Align(
                    child: AppText(
                      text:
                          widget.isIncome ? localize.income : localize.expenses,
                      style: StyleType.bodSm,
                      color: context.color.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [_buildColorPicker(hexColor)],
                  ),
                ],
              ),
              Gap.vertical(10),
              const AppDivider(),
              Gap.vertical(10),
            ],

            // Group name section
            Row(
              children: [
                if (!addNewGroup) ...[
                  Expanded(
                    child: DropdownSearch<String>(
                      suffixProps: DropdownSuffixProps(
                        clearButtonProps:
                            ClearButtonProps(color: context.color.primary),
                        dropdownButtonProps: DropdownButtonProps(
                            color: context.color.primary, iconSize: 18),
                      ),
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (item) =>
                            groupCategoryHistoriesCurrentBudgetId
                                .map((e) => e.groupName)
                                .contains(item),
                      ),
                      items: (f, cs) =>
                          groupCategories.map((e) => e.groupName).toList(),
                      decoratorProps: DropDownDecoratorProps(
                        baseStyle: _getTextStyle(_isGroupNamePlaceholder(
                            groupName, localize.groupName)),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: localize.selectGroup,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          final selectedGroup = groupCategories.firstWhere(
                              (element) => element.groupName == value);

                          context.read<BudgetFormBloc>().add(
                                UpdateGroupCategoryHistory(
                                  groupCategoryHistory:
                                      groupCategoryHistory.copyWith(
                                    groupName: selectedGroup.groupName,
                                    groupId: selectedGroup.id,
                                    type: selectedGroup.type,
                                    hexColor: selectedGroup.hexColor,
                                  ),
                                ),
                              );

                          final color =
                              _pickerColor?.toARGB32().toRadixString(16);
                          final hexColor = int.parse(color ?? '0', radix: 16);

                          setState(() {
                            _selectedGroupCategory =
                                selectedGroup.copyWith(hexColor: hexColor);
                          });
                        }
                      },
                      selectedItem: groupName,
                    ),
                  ),
                ],
                if (addNewGroup)
                  Expanded(
                    child: TextField(
                      controller: _groupNameController,
                      focusNode: _groupNameFocusNode,
                      onChanged: (value) {
                        final groupExist = groupCategories.any((element) =>
                            element.groupName.toLowerCase().trim() ==
                            value.toLowerCase().trim());

                        if (groupExist) {
                          AppToast.showToastError(
                              context, '$value ${localize.alreadyExists}');
                          _groupNameController.clear();
                          context.read<BudgetFormBloc>().add(
                                UpdateGroupCategoryHistory(
                                  groupCategoryHistory: groupCategoryHistory
                                      .copyWith(groupName: ''),
                                ),
                              );
                        } else {
                          context.read<BudgetFormBloc>().add(
                                UpdateGroupCategoryHistory(
                                  groupCategoryHistory: groupCategoryHistory
                                      .copyWith(groupName: value),
                                ),
                              );
                        }
                      },
                      style: textStyle(context, style: StyleType.bodMed),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: groupName,
                        hintStyle: _getTextStyle(true),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    context.read<BudgetFormBloc>().add(
                          UpdateGroupCategoryHistory(
                            groupCategoryHistory: groupCategoryHistory.copyWith(
                                groupName: localize.groupName),
                          ),
                        );
                    setState(() {
                      addNewGroup = !addNewGroup;
                      if (addNewGroup) {
                        _groupNameFocusNode.requestFocus();
                      }
                      _selectedGroupCategory = null;
                    });
                  },
                  child: AppText(
                    text: addNewGroup ? localize.select : localize.add,
                    style: StyleType.bodMed,
                    color: context.color.primary,
                  ),
                ),
              ],
            ),
            Gap.vertical(10),

            // Item categories list
            ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: itemCategoryHistories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, indexItem) {
                final item = itemCategoryHistories[indexItem];

                final itemName = item.name;
                final isPlaceholder = _isCategoryNamePlaceholder(
                    itemName,
                    localize.selectCategory,
                    localize.typeCategoryName,
                    localize.categoryName);

                if (_addNewCategoryField.length !=
                    itemCategoryHistories.length) {
                  return const CircularProgressIndicator.adaptive();
                }

                return Row(
                  children: [
                    // show input new category
                    if (_addNewCategoryField[indexItem]) ...[
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            TextField(
                              controller: _leftControllers[indexItem],
                              focusNode: _leftFocusNodes[indexItem],
                              onChanged: (value) {
                                final categoryExists = itemCategories.any(
                                    (element) =>
                                        element.categoryName
                                            .toLowerCase()
                                            .trim() ==
                                        value.toLowerCase().trim());

                                setState(
                                    () => categoryNameExists = categoryExists);

                                if (categoryExists) {
                                  AppToast.showToastError(context,
                                      '$value ${localize.alreadyExists}');
                                  _leftControllers[indexItem].clear();
                                  _onChangeField(item.copyWith(name: ''));
                                } else {
                                  _onChangeField(item.copyWith(name: value));
                                }
                              },
                              style:
                                  textStyle(context, style: StyleType.bodMed),
                              decoration: InputDecoration(
                                hintText: item.name,
                                hintStyle: _getTextStyle(true),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _addNewCategoryField[indexItem] =
                                          !_addNewCategoryField[indexItem];
                                    });
                                    _leftControllers[indexItem].clear();

                                    context.read<BudgetFormBloc>().add(
                                          UpdateItemCategoryHistoryEvent(
                                            groupId: groupId,
                                            itemId: item.id,
                                            itemCategory: item.copyWith(
                                              name: localize.selectCategory,
                                            ),
                                          ),
                                        );
                                  },
                                  icon: Icon(
                                    CupertinoIcons.chevron_down,
                                    color: context.color.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            const AppDivider(),
                          ],
                        ),
                      ),
                    ],

                    // show category dropdown
                    if (!_addNewCategoryField[indexItem])
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                containerBuilder: (context, popupWidget) {
                                  return SizedBox(
                                    height: _Constants.dropdownMenuHeight,
                                    child: Column(
                                      children: [
                                        Expanded(child: popupWidget),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: AppButton(
                                            height: 40,
                                            onPressed: () {
                                              setState(() {
                                                _addNewCategoryField[
                                                    indexItem] = true;
                                              });

                                              context
                                                  .read<BudgetFormBloc>()
                                                  .add(
                                                    UpdateItemCategoryHistoryEvent(
                                                      groupId: groupId,
                                                      itemId: item.id,
                                                      itemCategory: item.copyWith(
                                                          name: localize
                                                              .typeCategoryName),
                                                    ),
                                                  );
                                              _leftFocusNodes[indexItem]
                                                  .requestFocus();
                                            },
                                            label: localize.add,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                showSelectedItems: true,
                                disabledItemFn: (item) =>
                                    itemCategoryHistoriesCurrentBudgetId
                                        .map((e) => e.name)
                                        .contains(item),
                              ),
                              items: (f, cs) => itemCategories
                                  .map((e) => e.categoryName)
                                  .toList(),
                              decoratorProps: DropDownDecoratorProps(
                                baseStyle: _getTextStyle(isPlaceholder),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: localize.selectCategory,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  final selectedCategory =
                                      itemCategories.firstWhere((element) =>
                                          element.categoryName == value);

                                  context.read<BudgetFormBloc>().add(
                                        UpdateItemCategoryHistoryEvent(
                                          groupId: groupId,
                                          itemId: item.id,
                                          itemCategory: item.copyWith(
                                            name: selectedCategory.categoryName,
                                            itemId: selectedCategory.id,
                                            type: selectedCategory.type,
                                            iconPath: selectedCategory.iconPath,
                                            hexColor: selectedCategory.hexColor,
                                            isExpense: selectedCategory.type ==
                                                AppStrings.expenseType,
                                          ),
                                        ),
                                      );

                                  setState(() =>
                                      _selectedItemCategory[indexItem] =
                                          selectedCategory);
                                }
                              },
                              selectedItem: item.name,
                              suffixProps: DropdownSuffixProps(
                                clearButtonProps: ClearButtonProps(
                                    color: context.color.primary),
                                dropdownButtonProps: DropdownButtonProps(
                                    color: context.color.primary, iconSize: 18),
                              ),
                            ),
                            const AppDivider(),
                          ],
                        ),
                      ),

                    // Amount input
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<SettingBloc, SettingState>(
                        builder: (context, state) {
                          const radius10 = Radius.circular(10);
                          return TextField(
                            controller: _rightControllers[indexItem],
                            focusNode: _rightFocusNodes[indexItem],
                            textAlign: TextAlign.end,
                            style: textStyle(context, style: StyleType.bodMed),
                            onChanged: (value) {
                              final cleanVal =
                                  value.replaceAll(RegExp('[^0-9]'), '');

                              if (cleanVal.isNotEmpty) {
                                _onChangeField(
                                    item.copyWith(amount: cleanVal.toDouble()));
                              } else {
                                _onChangeValueEmpty(item);
                              }
                            },
                            onEditingComplete: () =>
                                _rightFocusNodes[indexItem].unfocus(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              CurrencyTextInputFormatter.currency(
                                locale: state.currency.locale,
                                symbol: '${state.currency.symbol} ',
                                decimalDigits: 0,
                              ),
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              hintText: NumberFormatter.formatToMoneyDouble(
                                  context, item.amount),
                              hintStyle: _getTextStyle(true),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: radius10,
                                  bottomRight: radius10,
                                  topRight: radius10,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: radius10,
                                  bottomRight: radius10,
                                  topRight: radius10,
                                ),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: context.color.onSurface
                                  .withValues(alpha: 0.1),
                              filled: true,
                            ),
                          );
                        },
                      ),
                    ),

                    // Delete button
                    GestureDetector(
                      onTap: () {
                        _onRemoveItemCategory(item);

                        _leftControllers.removeAt(indexItem);
                        _rightControllers.removeAt(indexItem);
                        _leftFocusNodes.removeAt(indexItem);
                        _rightFocusNodes.removeAt(indexItem);

                        setState(() {
                          _addNewCategoryField.removeAt(indexItem);
                          _selectedItemCategory.removeAt(indexItem);
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        color: context.color.primary.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gap.vertical(5),
            ),
            Gap.vertical(10),

            // Add new item button
            GestureDetector(
              onTap: () {
                final newItem = ItemCategoryHistory(
                  id: const Uuid().v1(),
                  type: categoryTypeLocal,
                  name: '',
                  groupHistoryId: groupId,
                  itemId: const Uuid().v1(),
                  createdAt: DateTime.now().toString(),
                  isExpense: isExpense,
                  budgetId: widget.budgetId,
                  groupName: groupName,
                );
                context.read<BudgetFormBloc>().add(
                      AddItemCategoryHistory(
                        groupId: groupId,
                        itemCategory: newItem,
                      ),
                    );

                _leftControllers.add(TextEditingController());
                _rightControllers.add(TextEditingController());
                _leftFocusNodes.add(FocusNode());
                _rightFocusNodes.add(FocusNode());

                setState(() {
                  _addNewCategoryField.add(true);
                  _selectedItemCategory.add(null);
                });
              },
              child: AppText(
                text: '+ ${localize.add} ${localize.category}',
                style: StyleType.bodMed,
                color: context.color.primary,
              ),
            ),
            Gap.vertical(10),
          ],
        );
      },
    );
  }
}
