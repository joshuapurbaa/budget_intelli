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
  final List<List<TextEditingController>> _leftTextEditingControllers = [];
  final List<List<TextEditingController>> _rightTextEditingControllers = [];
  final List<TextEditingController> _groupNameTextEditingControllers = [];
  final List<List<FocusNode>> _leftFocusNodes = [];
  final List<List<FocusNode>> _rightFocusNodes = [];
  final List<FocusNode> _groupNameFocusNodes = [];
  final List<Color> _pickerColor = [];
  final List<Color> _currentColor = [];

  @override
  void didUpdateWidget(covariant BudgetFormFieldInitial oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.groupCategories.length != widget.groupCategories.length) {
      _initControllers();
    }
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    const groupNameInitialEN = 'Group Name';
    const groupNameInitialID = 'Nama Grup';
    const categoryNameInitialEN = 'Category Name';
    const categoryNameInitialID = 'Nama Kategori';
    setState(() {
      _groupNameTextEditingControllers.clear();
      _leftTextEditingControllers.clear();
      _rightTextEditingControllers.clear();
      _groupNameFocusNodes.clear();
      _leftFocusNodes.clear();
      _rightFocusNodes.clear();
      _pickerColor.clear();
      _currentColor.clear();

      for (var i = 0; i < widget.groupCategories.length; i++) {
        final groupName = widget.groupCategories[i].groupName;

        if (groupName.isEmpty ||
            groupName == groupNameInitialID ||
            groupName == groupNameInitialEN) {
          _groupNameTextEditingControllers.add(TextEditingController());
        } else {
          _groupNameTextEditingControllers
              .add(TextEditingController(text: groupName));
        }
        _groupNameFocusNodes.add(FocusNode());

        final itemCategories = widget.groupCategories[i].itemCategoryHistories;

        final leftControllers = <TextEditingController>[];
        final rightControllers = <TextEditingController>[];
        final leftFocusNodes = <FocusNode>[];
        final rightFocusNodes = <FocusNode>[];

        for (var j = 0; j < itemCategories.length; j++) {
          TextEditingController? rightController;
          TextEditingController? leftController;
          FocusNode? leftFocusNode;
          FocusNode? rightFocusNode;
          final amount = itemCategories[j].amount;

          if (itemCategories[j].name.isEmpty ||
              itemCategories[j].name == categoryNameInitialID ||
              itemCategories[j].name == categoryNameInitialEN) {
            leftController = TextEditingController();
          } else {
            leftController =
                TextEditingController(text: itemCategories[j].name);
          }

          leftFocusNode = FocusNode();

          if (amount > 0) {
            rightController = TextEditingController(
              text: NumberFormatter.formatToMoneyDouble(context, amount),
            );
          } else {
            rightController = TextEditingController();
          }

          rightFocusNode = FocusNode();

          leftControllers.add(leftController);
          rightControllers.add(rightController);
          leftFocusNodes.add(leftFocusNode);
          rightFocusNodes.add(rightFocusNode);
        }

        _leftTextEditingControllers.add(leftControllers);
        _rightTextEditingControllers.add(rightControllers);
        _leftFocusNodes.add(leftFocusNodes);
        _rightFocusNodes.add(rightFocusNodes);

        _pickerColor.add(Color(widget.groupCategories[i].hexColor));
        _currentColor.add(Color(widget.groupCategories[i].hexColor));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return SliverPadding(
      padding: getEdgeInsets(
        left: 16,
        right: 16,
      ),
      sliver: SliverList.separated(
        itemCount: widget.groupCategories.length,
        itemBuilder: (context, indexGroup) {
          final groupCategory = widget.groupCategories[indexGroup];
          final itemCategories = groupCategory.itemCategoryHistories;
          final groupType = groupCategory.type;
          final groupName = groupCategory.groupName;
          final groupId = groupCategory.id;

          final isIncome = groupType == 'income';
          final isExpense = groupType == 'expense';
          final lastIndex = widget.groupCategories.length - 1;
          final isLast = indexGroup == lastIndex;

          const groupNameInitialEN = 'Group Name';
          const groupNameInitialID = 'Nama Grup';
          const categoryNameInitialEN = 'Category Name';
          const categoryNameInitialID = 'Nama Kategori';
          final title = isIncome ? localize.income : localize.expenses;
          final portions =
              widget.portions.where((element) => !element.isNaN).toList();

          String? portionStr;

          if (portions.isNotEmpty && isExpense && portions.length != 1) {
            portionStr = '${portions[indexGroup].toStringAsFixed(2)}%'
                .replaceAll('.00', '');
          }

          Color? hintColorGroupName;
          final colorOnSurface = context.color.onSurface.withValues(alpha: 0.5);

          if (groupName.isEmpty ||
              groupName == groupNameInitialID ||
              groupName == groupNameInitialEN) {
            hintColorGroupName = colorOnSurface;
          } else {
            hintColorGroupName = context.color.onSurface;
          }

          final onlyTwoGroup = widget.groupCategories.length == 2;

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
                                  style: StyleType.bodMd,
                                ),
                                Gap.horizontal(10),
                                GestureDetector(
                                  onTap: () {
                                    _onPaintBrushTap(indexGroup);
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor:
                                        Color(groupCategory.hexColor),
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
                            Expanded(
                              child: isIncome
                                  ? AppText(
                                      text: groupCategory.groupName,
                                      style: StyleType.bodLg,
                                    )
                                  : TextField(
                                      controller:
                                          _groupNameTextEditingControllers[
                                              indexGroup],
                                      focusNode:
                                          _groupNameFocusNodes[indexGroup],
                                      onSubmitted: (value) {
                                        _unfocusAll();
                                      },
                                      onChanged: (value) {
                                        context.read<BudgetFormBloc>().add(
                                              UpdateGroupCategoryHistory(
                                                groupCategoryHistory:
                                                    groupCategory.copyWith(
                                                  groupName: value,
                                                ),
                                              ),
                                            );
                                      },
                                      style: textStyle(
                                        context,
                                        style: StyleType.bodLg,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        hintText: groupCategory.groupName,
                                        hintStyle: textStyle(
                                          context,
                                          style: StyleType.bodLg,
                                        ).copyWith(
                                          color: hintColorGroupName,
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                            ),
                            if (!isIncome) ...[
                              if (!onlyTwoGroup)
                                GestureDetector(
                                  onTap: () {
                                    _unfocusAll();
                                    _onRemoveGroupCategory(
                                      groupCategory.id,
                                      itemCategories,
                                    );

                                    setState(() {
                                      _groupNameTextEditingControllers
                                          .removeAt(indexGroup);
                                      _leftTextEditingControllers
                                          .removeAt(indexGroup);
                                      _rightTextEditingControllers
                                          .removeAt(indexGroup);
                                      _groupNameFocusNodes.removeAt(indexGroup);
                                      _leftFocusNodes.removeAt(indexGroup);
                                      _rightFocusNodes.removeAt(indexGroup);
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
                            Gap.horizontal(20),
                            AppText(
                              text: localize.planned,
                              style: StyleType.bodSm,
                            ),
                          ],
                        ),
                        Gap.vertical(10),
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount:
                              _leftTextEditingControllers[indexGroup].length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, indexItem) {
                            final item = itemCategories[indexItem];

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
                                style: StyleType.bodMd,
                              ).copyWith(
                                color: colorOnSurface,
                                fontWeight: FontWeight.w400,
                              );
                            } else {
                              baseStyle = textStyle(
                                context,
                                style: StyleType.bodMd,
                              );
                            }

                            return Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _leftTextEditingControllers[
                                            indexGroup][indexItem],
                                        focusNode: _leftFocusNodes[indexGroup]
                                            [indexItem],
                                        onSubmitted: (value) {
                                          _unfocusAll();
                                        },
                                        onChanged: (value) {
                                          final newCategory = item.copyWith(
                                            name: value,
                                          );
                                          _onChangeField(
                                            newCategory,
                                            groupCategory.id,
                                          );
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
                                        color: context.color.primaryContainer
                                            .withValues(alpha: 0.4),
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
                                      Color? colorRightHintText;

                                      final value =
                                          _rightTextEditingControllers[
                                                  indexGroup][indexItem]
                                              .text;

                                      if (value == 'Rp 0' ||
                                          value == r'$ 0' ||
                                          value.isEmpty) {
                                        colorRightHintText = colorOnSurface;
                                      } else {
                                        colorRightHintText =
                                            context.color.onSurface;
                                      }
                                      return TextField(
                                        controller:
                                            _rightTextEditingControllers[
                                                indexGroup][indexItem],
                                        focusNode: _rightFocusNodes[indexGroup]
                                            [indexItem],
                                        onSubmitted: (value) {
                                          _unfocusAll();
                                        },
                                        textAlign: TextAlign.end,
                                        style: textStyle(
                                          context,
                                          style: StyleType.bodMd,
                                        ).copyWith(
                                          color: colorRightHintText,
                                        ),
                                        onChanged: (value) {
                                          final cleanVal = value.replaceAll(
                                            RegExp('[^0-9]'),
                                            '',
                                          );

                                          if (cleanVal.isNotEmpty) {
                                            final newCategory = item.copyWith(
                                              amount: cleanVal.toDouble(),
                                            );

                                            _onChangeField(
                                              newCategory,
                                              groupCategory.id,
                                            );
                                          } else {
                                            _onChangeValueEmpty(
                                              item,
                                              groupCategory.id,
                                            );
                                          }
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
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          hintText: NumberFormatter
                                              .formatToMoneyDouble(
                                            context,
                                            item.amount,
                                          ),
                                          hintStyle: textStyle(
                                            context,
                                            style: StyleType.bodMd,
                                          ).copyWith(
                                            color: colorRightHintText,
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
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
                                    _unfocusAll();
                                    _onRemoveItemCategory(
                                      item,
                                      groupCategory.id,
                                    );
                                    setState(() {
                                      _leftTextEditingControllers[indexGroup]
                                          .removeAt(indexItem);
                                      _rightTextEditingControllers[indexGroup]
                                          .removeAt(indexItem);
                                      _leftFocusNodes[indexGroup]
                                          .removeAt(indexItem);
                                      _rightFocusNodes[indexGroup]
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
                          separatorBuilder: (context, index) => Gap.vertical(5),
                        ),
                        Gap.vertical(10),
                        GestureDetector(
                          onTap: () {
                            _unfocusAll();
                            final itemId = const Uuid().v1();
                            final newItem = ItemCategoryHistory(
                              id: itemId,
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
                                    groupId: groupCategory.id,
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
                              _leftFocusNodes[indexGroup].add(
                                FocusNode(),
                              );
                              _rightFocusNodes[indexGroup].add(
                                FocusNode(),
                              );
                            });
                          },
                          child: AppText(
                            text:
                                '+ ${localize.add} ${groupCategory.groupName}',
                            style: StyleType.bodMd,
                            color: context.color.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLast && widget.fromInitial) ...[
                    Gap.vertical(8),
                    GestureDetector(
                      onTap: () async {
                        _unfocusAll();
                        final newGroupId = const Uuid().v1();
                        final newItemId = const Uuid().v1();
                        final language =
                            await SettingPreferenceRepo().getLanguage();
                        final isIndonesia = language == AppStrings.indonesia;

                        final newGroup = GroupCategoryHistory(
                          id: newGroupId,
                          groupName: isIndonesia
                              ? groupNameInitialID
                              : groupNameInitialEN,
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
                              name: isIndonesia
                                  ? categoryNameInitialID
                                  : categoryNameInitialEN,
                              type: AppStrings.expenseType,
                              createdAt: DateTime.now().toString(),
                              isExpense: true,
                              groupName: isIndonesia
                                  ? groupNameInitialID
                                  : groupNameInitialEN,
                            ),
                          ],
                        );

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
                              style: StyleType.bodMd,
                              color: context.color.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          );
        },
        separatorBuilder: (context, index) => Gap.vertical(8),
      ),
    );
  }

  void _onChangeField(ItemCategoryHistory newCategory, String groupId) {
    context.read<BudgetFormBloc>().add(
          UpdateItemCategoryEventInitialCreate(
            groupHistoId: groupId,
            itemHistoId: newCategory.id,
            itemCategoryHistory: newCategory,
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
          RemoveGroupCategoryHistory(
            groupHistoId: groupId,
          ),
        );

    for (var i = 0; i < itemCategories.length; i++) {
      final itemId = itemCategories[i].id;
      context.read<BudgetFormBloc>().add(
            RemoveItemCategoryFromInitial(
              groupHistoId: groupId,
              itemHistoId: itemId,
            ),
          );
    }
  }

  void _onNewGroup(GroupCategoryHistory newGroup) {
    context.read<BudgetFormBloc>().add(
          AddGroupCategoryHistory(
            groupCategoryHisto: newGroup,
          ),
        );

    setState(() {
      final leftControllers = <TextEditingController>[];
      final rightControllers = <TextEditingController>[];
      final leftFocusNodes = <FocusNode>[];
      final rightFocusNodes = <FocusNode>[];

      for (var i = 0; i < newGroup.itemCategoryHistories.length; i++) {
        final leftController = TextEditingController();
        final rightController = TextEditingController();
        final leftFocusNode = FocusNode();
        final rightFocusNode = FocusNode();

        leftControllers.add(leftController);
        rightControllers.add(rightController);
        leftFocusNodes.add(leftFocusNode);
        rightFocusNodes.add(rightFocusNode);
      }

      _groupNameTextEditingControllers.add(TextEditingController());
      _leftTextEditingControllers.add(leftControllers);
      _rightTextEditingControllers.add(rightControllers);
      _leftFocusNodes.add(leftFocusNodes);
      _rightFocusNodes.add(rightFocusNodes);
      _groupNameFocusNodes.add(FocusNode());
      _pickerColor.add(Color(newGroup.hexColor));
      _currentColor.add(Color(newGroup.hexColor));
    });
  }

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
                            widget.groupCategories[index].copyWith(
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

  void _unfocusAll() {
    for (var i = 0; i < _groupNameFocusNodes.length; i++) {
      _groupNameFocusNodes[i].unfocus();
    }

    for (var i = 0; i < _leftFocusNodes.length; i++) {
      for (var j = 0; j < _leftFocusNodes[i].length; j++) {
        _leftFocusNodes[i][j].unfocus();
      }
    }

    for (var i = 0; i < _rightFocusNodes.length; i++) {
      for (var j = 0; j < _rightFocusNodes[i].length; j++) {
        _rightFocusNodes[i][j].unfocus();
      }
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < _groupNameTextEditingControllers.length; i++) {
      _groupNameTextEditingControllers[i].dispose();
    }

    for (var i = 0; i < _leftTextEditingControllers.length; i++) {
      for (var j = 0; j < _leftTextEditingControllers[i].length; j++) {
        _leftTextEditingControllers[i][j].dispose();
      }
    }

    for (var i = 0; i < _rightTextEditingControllers.length; i++) {
      for (var j = 0; j < _rightTextEditingControllers[i].length; j++) {
        _rightTextEditingControllers[i][j].dispose();
      }
    }

    for (var i = 0; i < _groupNameFocusNodes.length; i++) {
      _groupNameFocusNodes[i].dispose();
    }

    for (var i = 0; i < _leftFocusNodes.length; i++) {
      for (var j = 0; j < _leftFocusNodes[i].length; j++) {
        _leftFocusNodes[i][j].dispose();
      }
    }

    for (var i = 0; i < _rightFocusNodes.length; i++) {
      for (var j = 0; j < _rightFocusNodes[i].length; j++) {
        _rightFocusNodes[i][j].dispose();
      }
    }

    super.dispose();
  }
}
