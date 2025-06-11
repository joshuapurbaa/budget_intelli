import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/models/item_category.dart';
import 'package:budget_intelli/features/category/view/controllers/category/category_cubit.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddItemCategoryScreen extends StatefulWidget {
  const AddItemCategoryScreen({
    super.key,
  });

  @override
  State<AddItemCategoryScreen> createState() => _AddItemCategoryScreenState();
}

class _AddItemCategoryScreenState extends State<AddItemCategoryScreen> {
  final _nameController = TextEditingController();
  final _focusCategoryName = FocusNode();
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
    _nameController.clear();
    iconPath = null;
    hexColor = null;
    pickerColor = const Color(0xff443a49);
    currentColor = const Color(0xff443a49);
    context.read<BoxCalculatorCubit>().unselect();
  }

  @override
  void initState() {
    super.initState();
    _reset();
    context.read<CategoryCubit>().getItemCategories();
    _getItemCategoryHistory();
  }

  void _getItemCategoryHistory() {
    final lastSeenBudgetId = context.read<SettingBloc>().state.lastSeenBudgetId;
    final budgetIdNotNullOrNotEmpty =
        lastSeenBudgetId != null && lastSeenBudgetId.isNotEmpty;
    if (budgetIdNotNullOrNotEmpty) {
      context.read<CategoryCubit>().getItemCategoryHistoriesByBudgetId(
            lastSeenBudgetId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.successInsert != true) {
          AppToast.showToastError(
            context,
            localize.failedToAddCategory,
          );
        } else {
          AppToast.showToastSuccess(
            context,
            localize.createdSuccessFully,
          );
          _reset();
          context.read<CategoryCubit>().getItemCategories();
          _getItemCategoryHistory();
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

        final groupHistory = state.groupCategoryHistory;

        final groupName = groupHistory?.groupName ?? '-';

        final type = groupHistory?.type;
        final groupId = groupHistory?.id;
        var hintCalculator = '-';

        final isExpense = type == 'expense';

        if (isExpense) {
          hintCalculator = '${localize.budget}*';
        } else {
          hintCalculator = '${localize.amountFieldLabel}*';
        }

        return Scaffold(
          bottomSheet: BottomSheetParent(
            isWithBorderTop: true,
            child: AppButton.darkLabel(
              label: localize.add,
              onPressed: () {
                final amount = ControllerHelper.getAmount(context);

                String? id;
                String? name;
                String? type;
                int? hexColor;
                String? iconPath;
                String? itemId;

                if (_selectedItemCategory != null) {
                  final typeStr = _selectedItemCategory?.type == 'expense'
                      ? localize.expenses
                      : localize.income;

                  if (groupHistory?.type != _selectedItemCategory?.type) {
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
                  id = const Uuid().v4();
                  name = _nameController.text;
                  itemId = const Uuid().v1();
                  hexColor = this.hexColor;
                  iconPath = this.iconPath;
                  type = isExpense ? 'expense' : 'income';
                }

                if (id != null &&
                    name != null &&
                    type != null &&
                    groupId != null &&
                    itemId != null &&
                    amount != null) {
                  final itemCategory = ItemCategory(
                    id: id,
                    categoryName: name,
                    type: type,
                    createdAt: DateTime.now().toString(),
                    hexColor: hexColor,
                    iconPath: iconPath,
                    updatedAt: DateTime.now().toString(),
                  );

                  context.read<CategoryCubit>().insertItemCategory(
                        itemCategory: itemCategory,
                      );
                } else {
                  AppToast.showToastError(
                    context,
                    localize.pleaseFillAllRequiredFields,
                  );
                }
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
                              pickerColor: currentColor,
                              onColorChanged: changeColor,
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: AppText(
                                text: localize.save,
                                style: StyleType.bodLg,
                              ),
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
                              style: StyleType.bodMd,
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
                          final categories = state.itemCategories;

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
                            _searchResult = search;
                          });
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
                                          style: StyleType.bodMd,
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
                        // if (_nameController.text.isNotEmpty) ...[
                        //   Gap.vertical(4),
                        //   Row(
                        //     children: [
                        //       Gap.horizontal(16),
                        //       if (categoryNameExists)
                        //         Expanded(
                        //           child: AppText(
                        //             text:
                        //                 'Category name already exists, please enter a unique name.',
                        //             style: StyleType.bodSm,
                        //             color: context.color.error,
                        //           ),
                        //         )
                        //       else
                        //         const SizedBox(),
                        //     ],
                        //   ),
                        // ],
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
