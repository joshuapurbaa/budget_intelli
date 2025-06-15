import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/view/controllers/category/category_cubit.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddItemCategoryOverviewScreen extends StatefulWidget {
  const AddItemCategoryOverviewScreen({
    required this.groupHistory,
    super.key,
  });

  final GroupCategoryHistory groupHistory;

  @override
  State<AddItemCategoryOverviewScreen> createState() =>
      _AddItemCategoryOverviewScreenState();
}

class _AddItemCategoryOverviewScreenState
    extends State<AddItemCategoryOverviewScreen> {
  final _nameController = TextEditingController();
  final _focusCategoryName = FocusNode();

  ItemCategoryHistory? itemCategoryHistory;
  bool categoryNameExists = false;
  List<ItemCategory> _searchResult = [];
  ItemCategory? _selectedItemCategory;

  String? iconPath;
  int? hexColor;
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusCategoryName.dispose();

    super.dispose();
  }

  void _reset() {
    context.read<BudgetFirestoreCubit>().resetState();
    _nameController.clear();
    iconPath = null;
    hexColor = null;
    pickerColor = const Color(0xff443a49);
    currentColor = const Color(0xff443a49);
    context.read<BoxCalculatorCubit>().unselect();
    context.read<CategoryCubit>().resetState();
  }

  Future<void> _onSuccessInsert(CategoryState state) async {
    final settingState = context.read<SettingBloc>().state;
    final premium = settingState.premiumUser;

    if (premium) {
      if (state.itemCategoryHistoryParam != null &&
          state.itemCategoryParam != null) {
        await context
            .read<BudgetFirestoreCubit>()
            .insertItemCategoryHistoryToFirestore(
              itemCategoryHistory: state.itemCategoryHistoryParam!,
              itemCategory: state.itemCategoryParam!,
              itemCategories: state.itemCategories,
            );
      }
    } else {
      _getItem(state);
    }
  }

  void _getItem(CategoryState state) {
    context.read<BudgetBloc>().add(
          GetBudgetsByIdEvent(
            id: state.budget?.id ?? '',
          ),
        );

    context.read<CategoryCubit>()
      ..getItemCategoryArgs(
        itemCategoryHistory: itemCategoryHistory,
        groupCategoryHistories: state.groupCategoryHistories,
        budget: state.budget,
        addNewItemCategory: false,
      )
      ..getItemCategoryTransactions(
        itemId: itemCategoryHistory!.id,
      );

    _reset();
  }

  @override
  void initState() {
    super.initState();
    _reset();
    context.read<CategoryCubit>()
      ..getItemCategories()
      ..getItemCategoryHistoriesByBudgetId(
        widget.groupHistory.budgetId!,
      );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final groupName = widget.groupHistory.groupName;
    final type = widget.groupHistory.type;
    final groupId = widget.groupHistory.id;
    var hintCalculator = '-';

    final isExpense = type == 'expense';

    if (isExpense) {
      hintCalculator = '${localize.budget}*';
    } else {
      hintCalculator = '${localize.amountFieldLabel}*';
    }

    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.successInsert) {
          _onSuccessInsert(state);

          AppToast.showToastSuccess(
            context,
            localize.createdSuccessFully,
          );
        }
      },
      builder: (context, state) {
        var height = 0.0;
        if (_searchResult.isNotEmpty && _nameController.text.isNotEmpty) {
          height = _searchResult.length * 60.0;
          if (height > 200) {
            height = 200;
          }
        }

        final categories = state.itemCategories;
        final itemCategoryHistoCurrentBudgetId =
            state.itemCategoryHistoriesCurrentBudgetId;

        return Scaffold(
          bottomSheet: BottomSheetParent(
            isWithBorderTop: true,
            child: BlocConsumer<BudgetFirestoreCubit, BudgetFirestoreState>(
              listener: (context, fireState) {
                if (fireState.insertItemHistoryFireSuccess) {
                  context.read<CategoryCubit>().resetState();
                  context.read<BudgetFirestoreCubit>().resetState();
                  _getItem(state);
                }
              },
              builder: (context, fireState) {
                if (fireState.loadingFirestore) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return AppButton.darkLabel(
                  label: localize.add,
                  onPressed: () {
                    final alreadyExistInCurrentBudget =
                        itemCategoryHistoCurrentBudgetId.any(
                      (element) =>
                          element.name.toLowerCase().trim() ==
                          _nameController.text.toLowerCase().trim(),
                    );

                    if (alreadyExistInCurrentBudget) {
                      AppToast.showToastError(
                        context,
                        localize.categoryNameAlreadyExists,
                      );
                      return;
                    }

                    ItemCategory? itemCategory;

                    final amount = ControllerHelper.getAmount(context);
                    final budgetId =
                        context.read<CategoryCubit>().state.budget?.id;

                    String? id;
                    String? name;
                    String? type;
                    int? hexColor;
                    String? iconPath;
                    String? itemId;

                    if (_nameController.text.isNotEmpty) {
                      itemCategory = categories
                          .where(
                            (element) =>
                                element.categoryName.toLowerCase().trim() ==
                                _nameController.text.toLowerCase().trim(),
                          )
                          .firstOrNull;
                    }

                    if (_selectedItemCategory != null || itemCategory != null) {
                      String? typeStr;

                      if (_selectedItemCategory != null) {
                        typeStr = _selectedItemCategory?.type == 'expense'
                            ? localize.expenses
                            : localize.income;

                        if (widget.groupHistory.type !=
                            _selectedItemCategory?.type) {
                          AppToast.showToastError(
                            context,
                            '${localize.thisCategoryIs} $typeStr ${localize.inPreviousBudget}',
                          );
                          return;
                        }
                        id = _selectedItemCategory?.id;
                        name = _selectedItemCategory?.categoryName;
                        type = _selectedItemCategory?.type;
                        hexColor = _selectedItemCategory?.hexColor;
                        iconPath = _selectedItemCategory?.iconPath;
                        itemId = _selectedItemCategory?.id;
                      } else {
                        typeStr = itemCategory?.type == 'expense'
                            ? localize.expenses
                            : localize.income;

                        if (widget.groupHistory.type != itemCategory?.type) {
                          AppToast.showToastError(
                            context,
                            '${localize.thisCategoryIs} $typeStr ${localize.inPreviousBudget}',
                          );
                          return;
                        }

                        id = itemCategory?.id;
                        name = itemCategory?.categoryName;
                        type = itemCategory?.type;
                        hexColor = itemCategory?.hexColor;
                        iconPath = itemCategory?.iconPath;
                        itemId = itemCategory?.id;
                      }
                    } else {
                      id = const Uuid().v4();
                      itemId = const Uuid().v1();
                      name = _nameController.text;
                      hexColor = this.hexColor;
                      iconPath = this.iconPath;
                      type = isExpense ? 'expense' : 'income';
                    }

                    if (id != null &&
                        name != null &&
                        type != null &&
                        itemId != null &&
                        amount != null) {
                      final history = ItemCategoryHistory(
                        id: id,
                        name: name,
                        type: type,
                        createdAt: DateTime.now().toString(),
                        isExpense: type == 'expense',
                        hexColor: hexColor,
                        iconPath: iconPath,
                        groupHistoryId: groupId,
                        amount: amount,
                        budgetId: budgetId,
                        itemId: itemId,
                        groupName: groupName,
                      );

                      setState(() {
                        itemCategoryHistory = history;
                      });

                      context.read<CategoryCubit>().insertItemCategoryHistory(
                            itemCategoryHistory: history,
                          );
                    } else {
                      AppToast.showToastError(
                        context,
                        localize.pleaseFillAllRequiredFields,
                      );
                    }
                  },
                );
              },
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: AppSliverPersistentHeader(
                  title: _nameController.text,
                  color: hexColor,
                  iconPath: iconPath,
                  onImageIconTap: () async {
                    final result = await context.push(MyRoute.listIconScreen);
                    if (result != null) {
                      setState(() {
                        iconPath = result as String;
                      });
                    }
                  },
                  onBackTap: () {
                    context.pop();
                  },
                  onPaintBrushTap: () {
                    AppDialog.showCustomDialog(
                      context,
                      title: AppText(
                        text: localize.pickAColor,
                        style: StyleType.headMed,
                      ),
                      content: MaterialPicker(
                        pickerColor: currentColor,
                        onColorChanged: changeColor,
                      ),
                      actions: <Widget>[
                        AppButton(
                          label: localize.save,
                          onPressed: () {
                            final color =
                                pickerColor.toARGB32().toRadixString(16);
                            final hexColor = int.parse(color, radix: 16);

                            setState(() {
                              currentColor = pickerColor;
                              this.hexColor = hexColor;
                            });

                            context.pop();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              SliverPadding(
                padding: getEdgeInsetsAll(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      AppGlass(
                        height: 70.h,
                        child: Row(
                          children: [
                            getPngAsset(
                              groupCategoryPng,
                              height: 20,
                              width: 20,
                              color: context.color.onSurface,
                            ),
                            Gap.horizontal(16),
                            AppText(
                              text: groupName,
                              style: StyleType.bodMed,
                            ),
                          ],
                        ),
                      ),
                      Gap.vertical(10),
                      BoxCalculator(
                        label: hintCalculator,
                      ),
                      Gap.vertical(10),
                      AppBoxFormField(
                        hintText: '${localize.nameFieldLabel}*',
                        prefixIcon: noteDescriptionPng,
                        controller: _nameController,
                        focusNode: _focusCategoryName,
                        isPng: true,
                        iconColor: context.color.onSurface,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final categoryExists = categories.any(
                              (element) =>
                                  element.categoryName.toLowerCase().trim() ==
                                  value.toLowerCase().trim(),
                            );

                            final search = context
                                .read<CategoryCubit>()
                                .searchItemCategoryByName(
                                  name: value,
                                  itemCategories: state.itemCategories,
                                );

                            setState(() {
                              categoryNameExists = categoryExists;
                              _selectedItemCategory = null;
                              _searchResult = search;
                            });
                          }
                        },
                      ),
                      if (_searchResult.isNotEmpty) ...[
                        Gap.vertical(10),
                        AppGlass(
                          child: Column(
                            children: List.generate(
                              _searchResult.length,
                              (index) {
                                final item = _searchResult[index];
                                var alreadyUsed = false;
                                final onlyOneAndLastIndex =
                                    _searchResult.length == 1 ||
                                        index == _searchResult.length - 1;

                                for (var i = 0;
                                    i <
                                        state
                                            .itemCategoryHistoriesCurrentBudgetId
                                            .length;
                                    i++) {
                                  final element = state
                                      .itemCategoryHistoriesCurrentBudgetId[i];
                                  if (element.name == item.categoryName) {
                                    alreadyUsed = true;
                                    break;
                                  }
                                }

                                return GestureDetector(
                                  onTap: () {
                                    if (alreadyUsed) {
                                      AppToast.showToastError(
                                        context,
                                        localize
                                            .thisCategoryAlreadyUsedInBudget,
                                      );
                                      return;
                                    }

                                    setState(() {
                                      _nameController.text = item.categoryName;
                                      _selectedItemCategory = item;
                                      _searchResult = [];
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        getEdgeInsetsSymmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      border: onlyOneAndLastIndex
                                          ? null
                                          : Border(
                                              bottom: BorderSide(
                                                color: context
                                                    .color.outlineVariant
                                                    .withValues(alpha: 0.3),
                                              ),
                                            ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: item.categoryName,
                                          style: StyleType.bodMed,
                                        ),
                                        if (alreadyUsed)
                                          const Icon(
                                            CupertinoIcons.check_mark,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Gap.vertical(100),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
