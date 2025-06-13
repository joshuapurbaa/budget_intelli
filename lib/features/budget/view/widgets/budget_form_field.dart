import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class BudgetFormField extends StatefulWidget {
  const BudgetFormField({
    required this.fromInitial,
    required this.budgetId,
    required this.groupCategoryHistories,
    required this.portions,
    super.key,
  });

  final bool fromInitial;
  final String budgetId;
  final List<GroupCategoryHistory> groupCategoryHistories;
  final List<double> portions;

  @override
  State<BudgetFormField> createState() => _BudgetFormFieldState();
}

class _BudgetFormFieldState extends State<BudgetFormField> {
  final List<List<TextEditingController>> _leftTextEditingControllers = [];
  final List<List<TextEditingController>> _rightTextEditingControllers = [];
  final List<List<bool>> _addCategoryField = [];
  final List<List<ItemCategory>> _selectedItemCategories = [];
  final List<GroupCategory> _selectedGroupCategories = [];
  List<bool> addNewGroups = [];
  final List<TextEditingController> _groupNameController = [];

  @override
  void didUpdateWidget(covariant BudgetFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.groupCategoryHistories.length !=
        widget.groupCategoryHistories.length) {
      _initControllers();
    }
  }

  void _onChangeField(
    ItemCategoryHistory newCategoryHisto,
    String groupHistoId,
  ) {
    context.read<BudgetFormBloc>().add(
          UpdateItemCategoryEventInitialCreate(
            groupHistoId: groupHistoId,
            itemHistoId: newCategoryHisto.id,
            itemCategoryHistory: newCategoryHisto,
          ),
        );
  }

  void _onChangeValueEmpty(ItemCategoryHistory newCategory, String groupId) {
    context.read<BudgetFormBloc>().add(
          UpdateItemCategoryEventInitialCreate(
            groupHistoId: groupId,
            itemHistoId: newCategory.id,
            itemCategoryHistory: newCategory.copyWith(
              amount: 0,
            ),
          ),
        );
  }

  void _onRemoveItemCategory(
    ItemCategoryHistory itemHisto,
    String groupHistoId,
  ) {
    context.read<BudgetFormBloc>().add(
          RemoveItemCategoryFromInitial(
            groupHistoId: groupHistoId,
            itemHistoId: itemHisto.id,
          ),
        );
  }

  void _onRemoveGroupCategory(
    String groupHistoId,
    List<ItemCategoryHistory> itemCategories,
  ) {
    context.read<BudgetFormBloc>().add(
          RemoveGroupCategoryHistory(
            groupHistoId: groupHistoId,
          ),
        );

    for (var i = 0; i < itemCategories.length; i++) {
      final itemId = itemCategories[i].id;
      context.read<BudgetFormBloc>().add(
            RemoveItemCategoryFromInitial(
              groupHistoId: groupHistoId,
              itemHistoId: itemId,
            ),
          );
    }
  }

  void _onNewGroup(GroupCategoryHistory newGroupHisto) {
    context.read<BudgetFormBloc>().add(
          AddGroupCategoryHistory(
            groupCategoryHisto: newGroupHisto,
          ),
        );

    setState(() {
      final leftControllers = <TextEditingController>[];
      final rightControllers = <TextEditingController>[];
      final valueList = <bool>[];
      final itemCategoryList = <ItemCategory>[];

      for (var i = 0; i < newGroupHisto.itemCategoryHistories.length; i++) {
        final leftController = TextEditingController();
        final rightController = TextEditingController();
        const value = false;

        final itemCategory = ItemCategory(
          id: newGroupHisto.itemCategoryHistories[i].itemId,
          categoryName: newGroupHisto.itemCategoryHistories[i].name,
          type: newGroupHisto.itemCategoryHistories[i].type,
          createdAt: newGroupHisto.itemCategoryHistories[i].createdAt,
          updatedAt: newGroupHisto.itemCategoryHistories[i].updatedAt,
          iconPath: newGroupHisto.itemCategoryHistories[i].iconPath,
          hexColor: newGroupHisto.itemCategoryHistories[i].hexColor,
        );

        leftControllers.add(leftController);
        rightControllers.add(rightController);
        valueList.add(value);
        itemCategoryList.add(itemCategory);
      }

      _leftTextEditingControllers.add(leftControllers);
      _rightTextEditingControllers.add(rightControllers);
      _addCategoryField.add(valueList);
      _selectedItemCategories.add(itemCategoryList);
      _selectedGroupCategories.add(
        GroupCategory(
          id: newGroupHisto.groupId,
          groupName: newGroupHisto.groupName,
          type: newGroupHisto.type,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
          iconPath: null,
          hexColor: newGroupHisto.hexColor,
        ),
      );
      addNewGroups.add(false);
      _groupNameController.add(TextEditingController());
      _pickerColor.add(Color(newGroupHisto.hexColor));
      _currentColor.add(Color(newGroupHisto.hexColor));
    });
  }

  @override
  void initState() {
    super.initState();

    _initControllers();
  }

  void _initControllers() {
    setState(() {
      _leftTextEditingControllers.clear();
      _rightTextEditingControllers.clear();
      _pickerColor.clear();
      _currentColor.clear();
      _addCategoryField.clear();
      _selectedItemCategories.clear();
      _selectedGroupCategories.clear();
      addNewGroups.clear();
      _groupNameController.clear();

      final groupHistories = widget.groupCategoryHistories;
      for (var i = 0; i < groupHistories.length; i++) {
        final itemCategories = groupHistories[i].itemCategoryHistories;
        final leftControllers = <TextEditingController>[];
        final rightControllers = <TextEditingController>[];
        final valueList = <bool>[];
        final itemCategoryList = <ItemCategory>[];

        for (var j = 0; j < itemCategories.length; j++) {
          TextEditingController? rightController;
          final amount = itemCategories[j].amount;
          final leftController =
              TextEditingController(text: itemCategories[j].name);

          if (amount > 0) {
            rightController = TextEditingController(
              text: NumberFormatter.formatToMoneyDouble(context, amount),
            );
          } else {
            rightController = TextEditingController();
          }
          const value = false;

          final itemCategory = ItemCategory(
            id: itemCategories[j].itemId,
            categoryName: itemCategories[j].name,
            type: itemCategories[j].type,
            createdAt: itemCategories[j].createdAt,
            updatedAt: itemCategories[j].updatedAt,
            iconPath: itemCategories[j].iconPath,
            hexColor: itemCategories[j].hexColor,
          );

          leftControllers.add(leftController);
          rightControllers.add(rightController);
          valueList.add(value);
          itemCategoryList.add(itemCategory);
        }

        _leftTextEditingControllers.add(leftControllers);
        _rightTextEditingControllers.add(rightControllers);

        _addCategoryField.add(valueList);
        addNewGroups.add(false);
        _selectedItemCategories.add(itemCategoryList);
        _selectedGroupCategories.add(
          GroupCategory(
            id: groupHistories[i].groupId,
            groupName: groupHistories[i].groupName,
            type: groupHistories[i].type,
            createdAt: DateTime.now().toString(),
            updatedAt: DateTime.now().toString(),
            iconPath: null,
            hexColor: groupHistories[i].hexColor,
          ),
        );
        _groupNameController.add(TextEditingController());
        _pickerColor.add(Color(widget.groupCategoryHistories[i].hexColor));
        _currentColor.add(Color(widget.groupCategoryHistories[i].hexColor));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    final selectedItemCategoryList = <ItemCategory>[];

    for (var i = 0; i < _selectedItemCategories.length; i++) {
      for (var j = 0; j < _selectedItemCategories[i].length; j++) {
        selectedItemCategoryList.add(_selectedItemCategories[i][j]);
      }
    }

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final itemCategories = state.itemCategories;
        final groupCategories = state.groupCategories;

        return SliverPadding(
          padding: getEdgeInsets(
            left: 16,
            right: 16,
          ),
          sliver: SliverList.separated(
            itemCount: widget.groupCategoryHistories.length,
            itemBuilder: (context, indexGroup) {
              final groupCategoryHistory =
                  widget.groupCategoryHistories[indexGroup];
              final itemCategoryHistories =
                  groupCategoryHistory.itemCategoryHistories;
              final groupType = groupCategoryHistory.type;
              final groupName = groupCategoryHistory.groupName;
              final groupId = groupCategoryHistory.id;

              final isIncome = groupType == 'income';
              final isExpense = groupType == 'expense';
              final lastIndex = widget.groupCategoryHistories.length - 1;
              final isLast = indexGroup == lastIndex;

              const groupNameInitialEN = 'Group Name';
              const groupNameInitialID = 'Nama Grup';
              const categoryNameInitialEN = 'Category Name';
              const categoryNameInitialID = 'Nama Kategori';
              final title = isIncome ? localize.income : localize.expenses;

              final onlyOneIncomeAndExpense =
                  widget.groupCategoryHistories.length == 2;

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

              final portions =
                  widget.portions.where((element) => !element.isNaN).toList();

              String? portionStr;

              if (portions.isNotEmpty && isExpense && portions.length != 1) {
                portionStr = '${portions[indexGroup].toStringAsFixed(2)}%'
                    .replaceAll('.00', '');
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      AppGlass(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    IncomeExpenseDialog.showInfoDialog(
                                      context,
                                      isIncome: isIncome,
                                      isExpense: isExpense,
                                    );
                                  },
                                  child: Align(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          text: title,
                                          style: StyleType.bodSm,
                                          color: context.color.onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                        Gap.horizontal(5),
                                        Icon(
                                          CupertinoIcons.info_circle,
                                          size: 17,
                                          color: context.color.onSurface
                                              .withValues(alpha: 0.5),
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
                                      onTap: () {
                                        _onPaintBrushTap(indexGroup);
                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Color(
                                          groupCategoryHistory.hexColor,
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
                            Gap.vertical(5),
                            Row(
                              children: [
                                if (!addNewGroups[indexGroup])
                                  Expanded(
                                    child: DropdownSearch<String>(
                                      popupProps: PopupProps.menu(
                                        showSelectedItems: true,
                                        disabledItemFn: (item) {
                                          return _selectedGroupCategories
                                              .map((e) => e.groupName)
                                              .contains(item);
                                        },
                                      ),
                                      items: (f, cs) => List.generate(
                                        groupCategories.length,
                                        (index) {
                                          return groupCategories[index]
                                              .groupName;
                                        },
                                      ),
                                      decoratorProps: DropDownDecoratorProps(
                                        baseStyle: groupNameBaseStyle,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          hintText: localize.selectGroup,
                                          hintStyle: textStyle(
                                            context,
                                            style: StyleType.bodMed,
                                          ).copyWith(
                                            color: context.color.onSurface
                                                .withValues(alpha: 0.3),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      onBeforeChange: (prevItem, nextItem) {
                                        final firstIndex = indexGroup == 0;
                                        if (firstIndex) {
                                          final nextSelectedGroup =
                                              groupCategories.firstWhere(
                                            (element) =>
                                                element.groupName == nextItem,
                                          );

                                          if (nextSelectedGroup.type !=
                                              AppStrings.incomeType) {
                                            AppToast.showToastError(
                                              context,
                                              localize.firstGroupMustBeIncome,
                                            );
                                            return Future.value(false);
                                          }
                                        } else {
                                          final nextSelectedGroup =
                                              groupCategories.firstWhere(
                                            (element) =>
                                                element.groupName == nextItem,
                                          );

                                          if (nextSelectedGroup.type !=
                                              groupType) {
                                            AppToast.showToastError(
                                              context,
                                              localize.selectGroupWithSameType,
                                            );
                                            return Future.value(false);
                                          }
                                        }
                                        return Future.value(true);
                                      },
                                      onChanged: (value) {
                                        if (value != null) {
                                          final selectedGroup =
                                              groupCategories.firstWhere(
                                            (element) =>
                                                element.groupName == value,
                                          );

                                          context.read<BudgetFormBloc>().add(
                                                UpdateGroupCategoryHistory(
                                                  groupCategoryHistory:
                                                      groupCategoryHistory
                                                          .copyWith(
                                                    groupName:
                                                        selectedGroup.groupName,
                                                    groupId: selectedGroup.id,
                                                    type: selectedGroup.type,
                                                    hexColor:
                                                        selectedGroup.hexColor,
                                                  ),
                                                ),
                                              );

                                          setState(() {
                                            _selectedGroupCategories[
                                                indexGroup] = selectedGroup;
                                          });
                                        }
                                      },
                                      selectedItem: groupName,
                                      suffixProps: DropdownSuffixProps(
                                        clearButtonProps: ClearButtonProps(
                                          color: context.color.primary,
                                        ),
                                        dropdownButtonProps:
                                            DropdownButtonProps(
                                          color: context.color.primary,
                                          iconSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (addNewGroups[indexGroup])
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          _groupNameController[indexGroup],
                                      onChanged: (value) {
                                        final groupExist = groupCategories.any(
                                          (element) =>
                                              element.groupName
                                                  .toLowerCase()
                                                  .trim() ==
                                              value.toLowerCase().trim(),
                                        );

                                        if (groupExist) {
                                          AppToast.showToastError(
                                            context,
                                            '$value ${localize.alreadyExists}',
                                          );
                                          _groupNameController[indexGroup]
                                              .clear();
                                          context.read<BudgetFormBloc>().add(
                                                UpdateGroupCategoryHistory(
                                                  groupCategoryHistory:
                                                      groupCategoryHistory
                                                          .copyWith(
                                                    groupName: '',
                                                  ),
                                                ),
                                              );
                                        } else {
                                          context.read<BudgetFormBloc>().add(
                                                UpdateGroupCategoryHistory(
                                                  groupCategoryHistory:
                                                      groupCategoryHistory
                                                          .copyWith(
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
                                          color: context.color.onSurface
                                              .withValues(alpha: 0.3),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                if (!onlyOneIncomeAndExpense) ...[
                                  if (!isIncome)
                                    GestureDetector(
                                      onTap: () {
                                        _onRemoveGroupCategory(
                                          groupCategoryHistory.id,
                                          itemCategoryHistories,
                                        );

                                        setState(() {
                                          _leftTextEditingControllers
                                              .removeAt(indexGroup);
                                          _rightTextEditingControllers
                                              .removeAt(indexGroup);
                                          _addCategoryField
                                              .removeAt(indexGroup);
                                          _selectedItemCategories
                                              .removeAt(indexGroup);
                                          _selectedGroupCategories
                                              .removeAt(indexGroup);
                                          addNewGroups.removeAt(indexGroup);
                                          _groupNameController
                                              .removeAt(indexGroup);
                                          _pickerColor.removeAt(indexGroup);
                                          _currentColor.removeAt(indexGroup);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: context.color.primary
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                ],
                                TextButton(
                                  onPressed: () {
                                    context.read<BudgetFormBloc>().add(
                                          UpdateGroupCategoryHistory(
                                            groupCategoryHistory:
                                                groupCategoryHistory.copyWith(
                                              groupName: localize.groupName,
                                            ),
                                          ),
                                        );
                                    setState(() {
                                      addNewGroups[indexGroup] =
                                          !addNewGroups[indexGroup];

                                      _selectedGroupCategories[indexGroup] =
                                          GroupCategory(
                                        id: const Uuid().v1(),
                                        groupName: localize.groupName,
                                        type: groupType,
                                        createdAt: DateTime.now().toString(),
                                        updatedAt: DateTime.now().toString(),
                                        iconPath: null,
                                        hexColor: 0xFF4CAF50,
                                      );
                                    });
                                  },
                                  child: AppText(
                                    text: addNewGroups[indexGroup]
                                        ? localize.select
                                        : localize.add,
                                    style: StyleType.bodMed,
                                    color: context.color.primary,
                                  ),
                                ),
                              ],
                            ),
                            Gap.vertical(10),
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: _leftTextEditingControllers[indexGroup]
                                  .length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, indexItem) {
                                final item = itemCategoryHistories[indexItem];

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
                                    color: context.color.onSurface
                                        .withValues(alpha: 0.5),
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
                                    if (_addCategoryField[indexGroup]
                                        [indexItem])
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller:
                                                  _leftTextEditingControllers[
                                                      indexGroup][indexItem],
                                              onChanged: (value) {
                                                final categoryExists =
                                                    itemCategories.any(
                                                  (element) =>
                                                      element.categoryName
                                                          .toLowerCase()
                                                          .trim() ==
                                                      value
                                                          .toLowerCase()
                                                          .trim(),
                                                );

                                                if (categoryExists) {
                                                  AppToast.showToastError(
                                                    context,
                                                    '$value ${localize.alreadyExists}',
                                                  );
                                                  _leftTextEditingControllers[
                                                          indexGroup][indexItem]
                                                      .clear();
                                                  final newCategory =
                                                      item.copyWith(
                                                    name: '',
                                                  );
                                                  _onChangeField(
                                                    newCategory,
                                                    groupCategoryHistory.id,
                                                  );
                                                } else {
                                                  final newCategory =
                                                      item.copyWith(
                                                    name: value,
                                                  );
                                                  _onChangeField(
                                                    newCategory,
                                                    groupCategoryHistory.id,
                                                  );
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
                                                      final prevsValue =
                                                          _addCategoryField[
                                                                  indexGroup]
                                                              [indexItem];

                                                      _addCategoryField[
                                                                  indexGroup]
                                                              [indexItem] =
                                                          !prevsValue;

                                                      _leftTextEditingControllers[
                                                                  indexGroup]
                                                              [indexItem]
                                                          .clear();

                                                      context
                                                          .read<
                                                              BudgetFormBloc>()
                                                          .add(
                                                            UpdateItemCategoryHistoryEvent(
                                                              groupId: groupId,
                                                              itemId: item.id,
                                                              itemCategory:
                                                                  item.copyWith(
                                                                name: localize
                                                                    .selectCategory,
                                                              ),
                                                            ),
                                                          );
                                                    });
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons.chevron_down,
                                                    color:
                                                        context.color.primary,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: context
                                                  .color.primaryContainer,
                                              height: 0,
                                              thickness: 0.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (!_addCategoryField[indexGroup]
                                        [indexItem])
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            DropdownSearch<String>(
                                              suffixProps: DropdownSuffixProps(
                                                clearButtonProps:
                                                    ClearButtonProps(
                                                  color: context.color.primary,
                                                ),
                                                dropdownButtonProps:
                                                    DropdownButtonProps(
                                                  color: context.color.primary,
                                                  iconSize: 18,
                                                ),
                                              ),
                                              onBeforeChange:
                                                  (prevItem, nextItem) {
                                                final selectedCategory =
                                                    itemCategories.firstWhere(
                                                  (element) =>
                                                      element.categoryName ==
                                                      nextItem,
                                                );

                                                if (selectedCategory.type !=
                                                    groupType) {
                                                  AppToast.showToastError(
                                                    context,
                                                    localize
                                                        .selectCategoryWithSameType,
                                                  );
                                                  return Future.value(false);
                                                } else {
                                                  return Future.value(true);
                                                }
                                              },
                                              popupProps: PopupProps.menu(
                                                containerBuilder:
                                                    (context, popupWidget) {
                                                  return SizedBox(
                                                    height: 300,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: popupWidget,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child:
                                                              AppButton.noWidth(
                                                            onPressed: () {
                                                              _setNewCategory(
                                                                item: item,
                                                                indexGroup:
                                                                    indexGroup,
                                                                indexItem:
                                                                    indexItem,
                                                                groupId:
                                                                    groupId,
                                                              );
                                                              context.pop();
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
                                                  return selectedItemCategoryList
                                                      .map(
                                                        (e) => e.categoryName,
                                                      )
                                                      .contains(item);
                                                },
                                              ),
                                              items: (f, cs) => List.generate(
                                                itemCategories.length,
                                                (index) {
                                                  return itemCategories[index]
                                                      .categoryName;
                                                },
                                              ),
                                              decoratorProps:
                                                  DropDownDecoratorProps(
                                                baseStyle: baseStyle,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  hintText:
                                                      localize.selectCategory,
                                                  hintStyle: textStyle(
                                                    context,
                                                    style: StyleType.bodLg,
                                                  ).copyWith(
                                                    color: context
                                                        .color.onSurface
                                                        .withValues(alpha: 0.3),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  final selectedCategory =
                                                      itemCategories.firstWhere(
                                                    (element) =>
                                                        element.categoryName ==
                                                        value,
                                                  );

                                                  context
                                                      .read<BudgetFormBloc>()
                                                      .add(
                                                        UpdateItemCategoryHistoryEvent(
                                                          groupId: groupId,
                                                          itemId: item.id,
                                                          itemCategory:
                                                              item.copyWith(
                                                            name: selectedCategory
                                                                .categoryName,
                                                            itemId:
                                                                selectedCategory
                                                                    .id,
                                                            type:
                                                                selectedCategory
                                                                    .type,
                                                            iconPath:
                                                                selectedCategory
                                                                    .iconPath,
                                                            hexColor:
                                                                selectedCategory
                                                                    .hexColor,
                                                            isExpense:
                                                                selectedCategory
                                                                        .type ==
                                                                    AppStrings
                                                                        .expenseType,
                                                          ),
                                                        ),
                                                      );

                                                  setState(() {
                                                    _selectedItemCategories[
                                                                indexGroup]
                                                            [indexItem] =
                                                        selectedCategory;
                                                  });
                                                }
                                              },
                                              selectedItem: item.name,
                                            ),
                                            Divider(
                                              color: context
                                                  .color.primaryContainer
                                                  .withValues(alpha: 0.4),
                                              height: 0,
                                              thickness: 0.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    Expanded(
                                      flex: 2,
                                      child: BlocBuilder<SettingBloc,
                                          SettingState>(
                                        builder: (context, state) {
                                          Color? colorText;

                                          final value =
                                              _rightTextEditingControllers[
                                                      indexGroup][indexItem]
                                                  .text;

                                          if (value == '0' || value.isEmpty) {
                                            colorText = context.color.onSurface
                                                .withValues(alpha: 0.5);
                                          } else {
                                            colorText = context.color.onSurface;
                                          }
                                          return TextField(
                                            controller:
                                                _rightTextEditingControllers[
                                                    indexGroup][indexItem],
                                            textAlign: TextAlign.end,
                                            style: textStyle(
                                              context,
                                              style: StyleType.bodMed,
                                            ).copyWith(
                                              color: colorText,
                                            ),
                                            onChanged: (value) {
                                              final cleanVal = value.replaceAll(
                                                RegExp('[^0-9]'),
                                                '',
                                              );

                                              if (cleanVal.isNotEmpty) {
                                                final newCategory =
                                                    item.copyWith(
                                                  amount: cleanVal.toDouble(),
                                                );

                                                _onChangeField(
                                                  newCategory,
                                                  groupCategoryHistory.id,
                                                );
                                              } else {
                                                _onChangeValueEmpty(
                                                  item,
                                                  groupCategoryHistory.id,
                                                );
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter
                                                  .currency(
                                                locale: state.currency.locale,
                                                symbol:
                                                    '${state.currency.symbol} ',
                                                decimalDigits: 0,
                                              ),
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              hintText: NumberFormatter
                                                  .formatToMoneyDouble(
                                                context,
                                                item.amount,
                                              ),
                                              hintStyle: textStyle(
                                                context,
                                                style: StyleType.bodMed,
                                              ).copyWith(
                                                color: colorText,
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                borderSide: BorderSide.none,
                                              ),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10),
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
                                        _onRemoveItemCategory(
                                          item,
                                          groupCategoryHistory.id,
                                        );
                                        setState(() {
                                          _leftTextEditingControllers[
                                                  indexGroup]
                                              .removeAt(indexItem);
                                          _rightTextEditingControllers[
                                                  indexGroup]
                                              .removeAt(indexItem);

                                          _selectedItemCategories[indexGroup]
                                              .removeAt(indexItem);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: context.color.primary
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  Gap.vertical(5),
                            ),
                            Gap.vertical(10),
                            GestureDetector(
                              onTap: () {
                                final id = const Uuid().v1();
                                final newItem = ItemCategoryHistory(
                                  id: id,
                                  type: groupType,
                                  name: localize.categoryName,
                                  groupHistoryId: groupId,
                                  itemId: const Uuid().v1(),
                                  budgetId: widget.budgetId,
                                  createdAt: DateTime.now().toString(),
                                  isExpense: isExpense,
                                  groupName: groupName,
                                );
                                context.read<BudgetFormBloc>().add(
                                      AddItemCategoryHistory(
                                        groupId: groupCategoryHistory.id,
                                        itemCategory: newItem,
                                      ),
                                    );

                                setState(() {
                                  _leftTextEditingControllers[indexGroup].add(
                                    TextEditingController(),
                                  );
                                  _rightTextEditingControllers[indexGroup].add(
                                    TextEditingController(),
                                  );

                                  _addCategoryField[indexGroup].add(false);
                                  _selectedItemCategories[indexGroup].add(
                                    ItemCategory(
                                      id: newItem.itemId,
                                      categoryName: newItem.name,
                                      type: newItem.type,
                                      createdAt: newItem.createdAt,
                                      updatedAt: newItem.createdAt,
                                      iconPath: null,
                                      hexColor: null,
                                    ),
                                  );
                                  _groupNameController
                                      .add(TextEditingController());
                                });
                              },
                              child: AppText(
                                text:
                                    '+ ${localize.add} ${groupCategoryHistory.groupName}',
                                style: StyleType.bodMed,
                                color: context.color.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isLast && widget.fromInitial) ...[
                        Gap.vertical(16),
                        GestureDetector(
                          onTap: () async {
                            final newGroupId = const Uuid().v1();
                            final newItemId = const Uuid().v1();

                            GroupCategoryHistory? newGroup;
                            final language =
                                await SettingPreferenceRepo().getLanguage();

                            if (language != AppStrings.indonesia) {
                              newGroup = GroupCategoryHistory(
                                id: newGroupId,
                                groupName: groupNameInitialEN,
                                type: AppStrings.expenseType,
                                groupId: const Uuid().v1(),
                                createdAt: DateTime.now().toString(),
                                hexColor: 0xFF4CAF50,
                                itemCategoryHistories: [
                                  ItemCategoryHistory(
                                    id: newItemId,
                                    groupHistoryId: newGroupId,
                                    budgetId: widget.budgetId,
                                    itemId: const Uuid().v1(),
                                    name: categoryNameInitialEN,
                                    type: AppStrings.expenseType,
                                    createdAt: DateTime.now().toString(),
                                    isExpense: true,
                                    groupName: groupNameInitialEN,
                                  ),
                                ],
                              );
                            } else {
                              newGroup = GroupCategoryHistory(
                                id: newGroupId,
                                groupName: groupNameInitialID,
                                type: AppStrings.expenseType,
                                groupId: const Uuid().v1(),
                                createdAt: DateTime.now().toString(),
                                hexColor: 0xFF4CAF50,
                                itemCategoryHistories: [
                                  ItemCategoryHistory(
                                    id: newItemId,
                                    groupHistoryId: newGroupId,
                                    budgetId: widget.budgetId,
                                    itemId: const Uuid().v1(),
                                    name: categoryNameInitialID,
                                    type: AppStrings.expenseType,
                                    createdAt: DateTime.now().toString(),
                                    isExpense: true,
                                    groupName: groupNameInitialID,
                                  ),
                                ],
                              );
                            }

                            _onNewGroup(newGroup);
                          },
                          child: AppGlass(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: context.color.primary,
                                ),
                                Gap.horizontal(10),
                                AppText(
                                  text: localize.addGroupCategory,
                                  style: StyleType.bodMed,
                                  color: context.color.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap.vertical(16),
                      ],
                    ],
                  );
                },
              );
            },
            separatorBuilder: (context, index) => Gap.vertical(10),
          ),
        );
      },
    );
  }

  void _setNewCategory({
    required ItemCategoryHistory item,
    required int indexGroup,
    required int indexItem,
    required String groupId,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final localize = textLocalizer(context);
      setState(() {
        final prevsValue = _addCategoryField[indexGroup][indexItem];

        _addCategoryField[indexGroup][indexItem] = !prevsValue;

        _selectedItemCategories[indexGroup][indexItem] = ItemCategory(
          id: item.id,
          categoryName: item.name,
          type: item.type,
          createdAt: item.createdAt,
          updatedAt: item.updatedAt,
          iconPath: item.iconPath,
          hexColor: item.hexColor,
        );
      });

      context.read<BudgetFormBloc>().add(
            UpdateItemCategoryHistoryEvent(
              groupId: groupId,
              itemId: item.id,
              itemCategory: item.copyWith(
                name: localize.typeCategoryName,
              ),
            ),
          );
    });
  }

  final List<Color> _pickerColor = [];
  final List<Color> _currentColor = [];

  void _changeColor(Color color, int index) {
    setState(() {
      _pickerColor[index] = color;
    });
  }

  void _onPaintBrushTap(int index) {
    final localize = textLocalizer(context);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: AppText(
            text: localize.pickAColor,
            style: StyleType.headMed,
          ),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: _pickerColor[index],
              onColorChanged: (color) {
                _changeColor(color, index);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: AppText(
                text: localize.save,
                style: StyleType.bodLg,
              ),
              onPressed: () {
                final color = _pickerColor[index].toARGB32().toRadixString(16);
                final hexColor = int.parse(color, radix: 16);

                context.read<BudgetFormBloc>().add(
                      UpdateGroupCategoryHistory(
                        groupCategoryHistory:
                            widget.groupCategoryHistories[index].copyWith(
                          hexColor: hexColor,
                        ),
                      ),
                    );

                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
