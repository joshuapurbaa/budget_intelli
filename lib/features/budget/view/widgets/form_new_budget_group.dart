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

class FormNewBudgetGroup extends StatefulWidget {
  const FormNewBudgetGroup({
    required this.fromInitial,
    required this.isIncome,
    required this.groupCategoryHistory,
    required this.itemCategoryHistories,
    required this.budgetId,
    required this.categoryType,
    // required this.indexGroup,
    required this.allItemCategoryHistories,
    super.key,
  });

  final bool fromInitial;
  final bool isIncome;
  final GroupCategoryHistory groupCategoryHistory;
  final List<ItemCategoryHistory> itemCategoryHistories;
  final String budgetId;
  final String categoryType;

  // final int indexGroup;
  final List<ItemCategoryHistory> allItemCategoryHistories;

  @override
  State<FormNewBudgetGroup> createState() => _FormNewBudgetGroupState();
}

class _FormNewBudgetGroupState extends State<FormNewBudgetGroup> {
  String categoryTypeLocal = 'expense';
  bool isExpense = true;
  int totalNewGroup = 1;

  GroupCategory? _selectedGroupCategory;
  final _selectedItemCategory = <ItemCategory?>[];
  bool addNewGroup = false;
  List<bool> addCategoryField = <bool>[];
  bool categoryNameExists = false;

  void _onChangeField(ItemCategoryHistory newCategory) {
    final groupId = widget.groupCategoryHistory.id;
    if (widget.fromInitial) {
      context.read<BudgetFormBloc>().add(
            UpdateItemCategoryEventInitialCreate(
              groupHistoId: groupId,
              itemHistoId: newCategory.id,
              itemCategoryHistory: newCategory,
            ),
          );
    } else {
      context.read<BudgetFormBloc>().add(
            UpdateItemCategoryHistoryEvent(
              groupId: groupId,
              itemId: newCategory.id,
              itemCategory: newCategory,
            ),
          );
    }
  }

  void _onChangeValueEmpty(ItemCategoryHistory newCategory) {
    final groupId = widget.groupCategoryHistory.id;
    if (widget.fromInitial) {
      context.read<BudgetFormBloc>().add(
            UpdateItemCategoryEventInitialCreate(
              groupHistoId: groupId,
              itemHistoId: newCategory.id,
              itemCategoryHistory: newCategory.copyWith(
                amount: 0,
              ),
            ),
          );
    } else {
      context.read<BudgetFormBloc>().add(
            UpdateItemCategoryHistoryEvent(
              groupId: groupId,
              itemId: newCategory.id,
              itemCategory: newCategory.copyWith(
                amount: 0,
              ),
            ),
          );
    }
  }

  void _onRemoveItemCategory(ItemCategoryHistory item) {
    final groupId = widget.groupCategoryHistory.id;
    if (widget.fromInitial) {
      context.read<BudgetFormBloc>().add(
            RemoveItemCategoryFromInitial(
              groupHistoId: groupId,
              itemHistoId: item.id,
            ),
          );
    } else {
      context.read<BudgetFormBloc>().add(
            RemoveItemCategoryFromInside(
              groupId: groupId,
              itemId: item.id,
            ),
          );
    }
  }

  final List<TextEditingController> _leftControllers = [];
  final List<TextEditingController> _rightControllers = [];
  final List<FocusNode> _leftFocusNodes = [];
  final List<FocusNode> _rightFocusNodes = [];
  final _groupNameController = TextEditingController();
  final _groupNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.itemCategoryHistories.length; i++) {
      addCategoryField.add(false);
      _selectedItemCategory.add(null);
      _leftControllers.add(TextEditingController());
      _rightControllers.add(TextEditingController());
      _leftFocusNodes.add(FocusNode());
      _rightFocusNodes.add(FocusNode());
    }
    _pickerColor = Color(widget.groupCategoryHistory.hexColor);
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupNameFocusNode.dispose();
    for (var i = 0; i < widget.itemCategoryHistories.length; i++) {
      _leftControllers[i].dispose();
      _rightControllers[i].dispose();
      _leftFocusNodes[i].dispose();
      _rightFocusNodes[i].dispose();
    }
    super.dispose();
  }

  Color? _pickerColor;

  void _changeColor(Color color) {
    setState(() {
      _pickerColor = color;
    });
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
      actions: <Widget>[
        AppButton(
          label: localize.save,
          onPressed: () {
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
          },
        ),
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
    int? hexColor;
    hexColor = groupCategoryHistory.hexColor;

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final groupCategories = state.groupCategories;
        final itemCategories = state.itemCategories;

        final groupCategoryHistoriesCurrentBudgetId =
            state.groupCategoryHistoriesCurrentBudgetId;
        final itemCategoryHistoriesCurrentBudgetId =
            state.itemCategoryHistoriesCurrentBudgetId;

        const groupNameInitialEN = 'Group Name';
        const groupNameInitialID = 'Nama Grup';

        TextStyle? groupNameBaseStyle;

        if (groupName.isEmpty ||
            groupName == groupNameInitialEN ||
            groupName == groupNameInitialID ||
            groupName == localize.groupName) {
          groupNameBaseStyle = textStyle(
            context,
            style: StyleType.bodMed,
          ).copyWith(
            color: context.color.onSurface.withValues(alpha: 0.3),
            fontWeight: FontWeight.w400,
          );
        } else {
          groupNameBaseStyle = textStyle(
            context,
            style: StyleType.bodMed,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (addNewGroup)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Radio.adaptive(
                            value: AppStrings.expenseType,
                            groupValue: type,
                            onChanged: (value) {
                              context.read<BudgetFormBloc>().add(
                                    UpdateGroupCategoryHistoryType(
                                      groupId: groupId,
                                      type: value.toString(),
                                      isExpenses: true,
                                    ),
                                  );
                            },
                          ),
                          Gap.horizontal(8),
                          AppText(
                            text: localize.expenses,
                            style: StyleType.bodMed,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio.adaptive(
                            value: AppStrings.incomeType,
                            groupValue: type,
                            onChanged: (value) {
                              context.read<BudgetFormBloc>().add(
                                    UpdateGroupCategoryHistoryType(
                                      groupId: groupId,
                                      type: value.toString(),
                                      isExpenses: false,
                                    ),
                                  );
                            },
                          ),
                          Gap.horizontal(8),
                          AppText(
                            text: localize.income,
                            style: StyleType.bodMed,
                          ),
                        ],
                      ),
                      Gap.horizontal(10),
                      GestureDetector(
                        onTap: _onPaintBrushTap,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(
                            hexColor ?? 0xFFF44336,
                          ),
                          child: Icon(
                            CupertinoIcons.paintbrush,
                            color: context.color.onSurface,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap.vertical(5),
                  const AppDivider(),
                  Gap.vertical(5),
                ],
              ),
            if (!addNewGroup) ...[
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
                    children: [
                      GestureDetector(
                        onTap: _onPaintBrushTap,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(
                            hexColor ?? 0xFFF44336,
                          ),
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
              ),
              Gap.vertical(10),
              const AppDivider(),
              Gap.vertical(10),
            ],
            Row(
              children: [
                if (!addNewGroup) ...[
                  Expanded(
                    child: DropdownSearch<String>(
                      suffixProps: DropdownSuffixProps(
                        clearButtonProps: ClearButtonProps(
                          color: context.color.primary,
                        ),
                        dropdownButtonProps: DropdownButtonProps(
                          color: context.color.primary,
                          iconSize: 18,
                        ),
                      ),
                      popupProps: PopupProps.menu(
                        showSelectedItems: true,
                        disabledItemFn: (item) {
                          return groupCategoryHistoriesCurrentBudgetId
                              .map((e) => e.groupName)
                              .contains(item);
                        },
                      ),
                      items: (f, cs) => List.generate(
                        groupCategories.length,
                        (index) {
                          return groupCategories[index].groupName;
                        },
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        baseStyle: groupNameBaseStyle,
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
                            (element) => element.groupName == value,
                          );

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
                            _selectedGroupCategory = selectedGroup.copyWith(
                              hexColor: hexColor,
                            );
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
                        final groupExist = groupCategories.any(
                          (element) =>
                              element.groupName.toLowerCase().trim() ==
                              value.toLowerCase().trim(),
                        );

                        if (groupExist) {
                          AppToast.showToastError(
                            context,
                            '$value ${localize.alreadyExists}',
                          );
                          _groupNameController.clear();
                          context.read<BudgetFormBloc>().add(
                                UpdateGroupCategoryHistory(
                                  groupCategoryHistory:
                                      groupCategoryHistory.copyWith(
                                    groupName: '',
                                  ),
                                ),
                              );
                        } else {
                          context.read<BudgetFormBloc>().add(
                                UpdateGroupCategoryHistory(
                                  groupCategoryHistory:
                                      groupCategoryHistory.copyWith(
                                    groupName: value,
                                  ),
                                ),
                              );
                        }
                      },
                      style: textStyle(
                        context,
                        style: StyleType.bodMed,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: groupName,
                        hintStyle: textStyle(
                          context,
                          style: StyleType.bodMed,
                        ).copyWith(
                          color: context.color.onSurface.withValues(alpha: 0.3),
                          fontWeight: FontWeight.w400,
                        ),
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
                              groupName: localize.groupName,
                            ),
                          ),
                        );
                    setState(() {
                      addNewGroup = !addNewGroup;
                      if (addNewGroup) {
                        _groupNameFocusNode.requestFocus();
                      }
                      if (_selectedGroupCategory != null) {
                        _selectedGroupCategory = null;
                      }
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
            ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: itemCategoryHistories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, indexItem) {
                final item = itemCategoryHistories[indexItem];
                const categoryNameInitialEN = 'Category Name';
                const categoryNameInitialID = 'Nama Kategori';
                TextStyle? baseStyle;
                final itemName = item.name;

                if (itemName.isEmpty ||
                    itemName == categoryNameInitialID ||
                    itemName == categoryNameInitialEN ||
                    itemName == localize.selectCategory ||
                    itemName == localize.typeCategoryName ||
                    itemName == localize.categoryName) {
                  baseStyle = textStyle(
                    context,
                    style: StyleType.bodMed,
                  ).copyWith(
                    color: context.color.onSurface.withValues(alpha: 0.3),
                    fontWeight: FontWeight.w400,
                  );
                } else {
                  baseStyle = textStyle(
                    context,
                    style: StyleType.bodMed,
                  );
                }

                return Row(
                  children: [
                    if (addCategoryField[indexItem]) ...[
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            TextField(
                              controller: _leftControllers[indexItem],
                              focusNode: _leftFocusNodes[indexItem],
                              onChanged: (value) {
                                final categories = state.itemCategories;

                                final categoryExists = categories.any(
                                  (element) =>
                                      element.categoryName
                                          .toLowerCase()
                                          .trim() ==
                                      value.toLowerCase().trim(),
                                );

                                setState(() {
                                  categoryNameExists = categoryExists;
                                });

                                if (categoryExists) {
                                  AppToast.showToastError(
                                    context,
                                    '$value ${localize.alreadyExists}',
                                  );
                                  _leftControllers[indexItem].clear();
                                  final newCategory = item.copyWith(
                                    name: '',
                                  );
                                  _onChangeField(newCategory);
                                } else {
                                  final newCategory = item.copyWith(
                                    name: value,
                                  );
                                  _onChangeField(newCategory);
                                }
                              },
                              style: textStyle(
                                context,
                                style: StyleType.bodMed,
                              ),
                              decoration: InputDecoration(
                                hintText: item.name,
                                hintStyle: textStyle(
                                  context,
                                  style: StyleType.bodMed,
                                ).copyWith(
                                  color: context.color.onSurface
                                      .withValues(alpha: 0.3),
                                  fontWeight: FontWeight.w400,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      addCategoryField[indexItem] =
                                          !addCategoryField[indexItem];
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
                                    });
                                  },
                                  icon: Icon(
                                    CupertinoIcons.chevron_down,
                                    color: context.color.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: context.color.primaryContainer,
                              height: 0,
                              thickness: 0.5,
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (!addCategoryField[indexItem])
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            DropdownSearch<String>(
                              popupProps: PopupProps.menu(
                                containerBuilder: (context, popupWidget) {
                                  return SizedBox(
                                    height: 300,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: popupWidget,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: AppButton.noWidth(
                                            onPressed: () {
                                              setState(() {
                                                addCategoryField[indexItem] =
                                                    !addCategoryField[
                                                        indexItem];
                                              });

                                              context
                                                  .read<BudgetFormBloc>()
                                                  .add(
                                                    UpdateItemCategoryHistoryEvent(
                                                      groupId: groupId,
                                                      itemId: item.id,
                                                      itemCategory:
                                                          item.copyWith(
                                                        name: localize
                                                            .typeCategoryName,
                                                      ),
                                                    ),
                                                  );
                                              context.pop();
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
                                disabledItemFn: (item) {
                                  return itemCategoryHistoriesCurrentBudgetId
                                      .map((e) => e.name)
                                      .contains(item);
                                },
                              ),
                              items: (f, cs) => List.generate(
                                itemCategories.length,
                                (index) {
                                  return itemCategories[index].categoryName;
                                },
                              ),
                              decoratorProps: DropDownDecoratorProps(
                                baseStyle: baseStyle,
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
                                      itemCategories.firstWhere(
                                    (element) => element.categoryName == value,
                                  );

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

                                  setState(() {
                                    _selectedItemCategory[indexItem] =
                                        selectedCategory;
                                  });
                                }
                              },
                              selectedItem: item.name,
                              suffixProps: DropdownSuffixProps(
                                clearButtonProps: ClearButtonProps(
                                  color: context.color.primary,
                                ),
                                dropdownButtonProps: DropdownButtonProps(
                                  color: context.color.primary,
                                  iconSize: 18,
                                ),
                              ),
                            ),
                            Divider(
                              color: context.color.primaryContainer,
                              height: 0,
                              thickness: 0.5,
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      flex: 2,
                      child: BlocBuilder<SettingBloc, SettingState>(
                        builder: (context, state) {
                          return TextField(
                            controller: _rightControllers[indexItem],
                            focusNode: _rightFocusNodes[indexItem],
                            textAlign: TextAlign.end,
                            style: textStyle(
                              context,
                              style: StyleType.bodMed,
                            ),
                            onChanged: (value) {
                              final cleanVal =
                                  value.replaceAll(RegExp('[^0-9]'), '');

                              if (cleanVal.isNotEmpty) {
                                final newCategory = item.copyWith(
                                  amount: cleanVal.toDouble(),
                                );

                                _onChangeField(newCategory);
                              } else {
                                _onChangeValueEmpty(item);
                              }
                            },
                            onEditingComplete: () {
                              _rightFocusNodes[indexItem].unfocus();
                            },
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
                                context,
                                item.amount,
                              ),
                              hintStyle: textStyle(
                                context,
                                style: StyleType.bodMed,
                              ).copyWith(
                                color: context.color.onSurface
                                    .withValues(alpha: 0.3),
                                fontWeight: FontWeight.w400,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10),
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
                    GestureDetector(
                      onTap: () {
                        _onRemoveItemCategory(item);

                        _leftControllers.removeAt(indexItem);
                        _rightControllers.removeAt(indexItem);
                        _leftFocusNodes.removeAt(indexItem);
                        _rightFocusNodes.removeAt(indexItem);

                        setState(() {
                          addCategoryField.removeAt(indexItem);
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
                  addCategoryField.add(true);
                  _selectedItemCategory.add(null);
                });
              },
              child: AppText(
                text: '+ ${localize.add} $groupName',
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
