import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DetailCategoryScreen extends StatefulWidget {
  const DetailCategoryScreen({super.key});

  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void _onUpdate({
    ItemCategoryHistory? itemCategory,
    int? hexColor,
    String? iconPath,
  }) {
    context.read<CategoryCubit>().updateItemCategoryHistory(
          itemCategoryHistory: itemCategory!.copyWith(
            hexColor: hexColor,
            iconPath: iconPath,
          ),
        );
  }

  void _onSuccessUpdate(CategoryState state) {
    final settingState = context.read<SettingBloc>().state;
    final premium = settingState.premiumUser;

    if (premium) {
      _updateFirestore(state);
      _afterUpdate(state);
    } else {
      _afterUpdate(state);
    }

    _resetState();
  }

  void _afterUpdate(CategoryState state) {
    context.read<BudgetBloc>().add(
          GetBudgetsByIdEvent(
            id: state.budget?.id ?? '',
          ),
        );
    context.read<CategoryCubit>().resetState();

    AppToast.showToastSuccess(
      context,
      textLocalizer(context).successfullyChanged,
    );
  }

  void _onSuccessDelete(CategoryState state) {
    final settingState = context.read<SettingBloc>().state;
    final premium = settingState.premiumUser;

    if (premium) {
      _deleteFirestore(state);
      _afterDelete(state);
    } else {
      _afterDelete(state);
    }

    _resetState();
  }

  void _afterDelete(CategoryState state) {
    final localize = textLocalizer(context);
    context.read<BudgetBloc>().add(
          GetBudgetsByIdEvent(
            id: state.budget?.id ?? '',
          ),
        );

    context.read<CategoryCubit>()
      ..getItemCategoryTransactions(itemId: state.itemCategoryHistory!.id)
      ..resetState();

    AppToast.showToastSuccess(
      context,
      localize.successfullyDeleted,
    );
  }

  Future<void> _updateFirestore(CategoryState state) async {
    final itemCategoryHistory = state.itemCategoryHistory;
    final itemCategory = state.itemCategoryParam;
    if (itemCategoryHistory != null && itemCategory != null) {
      await context
          .read<BudgetFirestoreCubit>()
          .updateItemCategoryHistoryFirestore(
            itemCategoryHistory: itemCategoryHistory,
            itemCategoryUpdated: itemCategory,
          );
    } else {
      AppToast.showToastError(
        context,
        textLocalizer(context).anErrorOccured,
      );
    }
  }

  Future<void> _deleteFirestore(CategoryState state) async {}

  void _resetState() {
    context.read<CategoryCubit>().resetState();
    context.read<BudgetFirestoreCubit>().resetState();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state.successUpdate) {
          _onSuccessUpdate(state);
        }

        if (state.successDeleteTransaction) {
          _onSuccessDelete(state);
        }
      },
      builder: (context, state) {
        final addNewCategory = state.addNewItemCategory;

        if (addNewCategory) {
          return AddItemCategoryOverviewScreen(
            groupHistory: state.groupCategoryHistory!,
          );
        }

        final itemCategory = state.itemCategoryHistory;
        final isExpense = itemCategory?.isExpense ?? false;
        final title = itemCategory?.name;
        final iconPath = itemCategory?.iconPath;
        final hexColor = itemCategory?.hexColor;
        final amount = itemCategory?.amount;
        String? amountStr;
        String? remainingStr;

        var totalTransactions = '0';
        var spent = 0.0;
        var spentStr = '0';
        var remaining = 0.0;

        final itemCategoryTransaction = state.itemCategoryTransactions;

        if (itemCategoryTransaction.isNotEmpty) {
          spent = itemCategoryTransaction.map((e) => e.amount).reduce(
                (value, element) => value + element,
              );
        }
        totalTransactions = itemCategoryTransaction.length.toString();
        spentStr = NumberFormatter.formatToMoneyDouble(context, spent);

        if (amount != null) {
          amountStr = NumberFormatter.formatToMoneyDouble(context, amount);
          remainingStr =
              NumberFormatter.formatToMoneyDouble(context, amount - spent);
          remaining = amount - spent;
        }

        var title1 = '-';
        var title2 = '-';
        var title3 = '-';

        if (isExpense) {
          title1 = localize.spent;
          title2 = localize.budget;
          title3 = '${localize.remaining}: ';
        } else {
          title1 = localize.received;
          title2 = localize.planned;
          title3 = '${localize.leftToReceive}: ';
        }

        final itemLen =
            state.groupCategoryHistory?.itemCategoryHistories.length ?? 0;

        final itemIncomeLenOnlyOne =
            itemLen == 1 && state.groupCategoryHistory?.type == 'income';

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              context.read<CategoryCubit>().getItemCategoryArgs(
                    groupCategoryHistories: state.groupCategoryHistories,
                    itemCategoryHistory: itemCategory,
                    budget: state.budget,
                    lefToBudget: remaining,
                  );
              if (isExpense) {
                context.pushNamed(
                  MyRoute.addExpense.noSlashes(),
                );
              } else {
                context.pushNamed(
                  MyRoute.addIncomeLocal.noSlashes(),
                );
              }
            },
            child: const Icon(Icons.add),
          ),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: AppSliverPersistentHeader(
                  title: title ?? '-',
                  iconPath: iconPath,
                  color: hexColor,
                  onImageIconTap: () async {
                    final result = await context.push(MyRoute.listIconScreen);
                    if (result != null) {
                      _onUpdate(
                        itemCategory: itemCategory,
                        iconPath: result as String,
                      );
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

                                if (itemCategory != null) {
                                  _onUpdate(
                                    itemCategory: itemCategory,
                                    hexColor: hexColor,
                                  );
                                }

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
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    Gap.vertical(16),
                    Row(
                      children: [
                        Expanded(
                          child: AppGlass(
                            margin: getEdgeInsets(left: 16, bottom: 10),
                            height: 100.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  text: title1,
                                  style: StyleType.bodMd,
                                  maxLines: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                Gap.vertical(8),
                                AppText.color(
                                  text: spentStr,
                                  color: context.color.primary,
                                  style: StyleType.bodLg,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap.horizontal(10),
                        Expanded(
                          child: AppGlass(
                            margin: getEdgeInsets(right: 16, bottom: 10),
                            height: 100.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  text: title2,
                                  style: StyleType.bodMd,
                                  maxLines: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                                Gap.vertical(8),
                                AppText.color(
                                  text: amountStr ?? '-',
                                  color: context.color.primary,
                                  style: StyleType.bodLg,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppGlass(
                      margin: getEdgeInsets(right: 16, left: 16, bottom: 10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: title3,
                              style: textStyle(
                                context,
                                StyleType.bodMd,
                              ).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: remainingStr,
                              style: textStyle(
                                context,
                                StyleType.bodLg,
                              ).copyWith(
                                color: context.color.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppGlass(
                      margin: getEdgeInsets(right: 16, left: 16, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text:
                                '${localize.transactions} ($totalTransactions)',
                            style: StyleType.bodMd,
                            fontWeight: FontWeight.bold,
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemCategoryTransaction.length,
                            padding: getEdgeInsets(top: 16),
                            itemBuilder: (context, index) {
                              final transaction =
                                  itemCategoryTransaction[index];

                              final transactionDate = transaction.createdAt;

                              final formatDate =
                                  getDayMonth(transactionDate, context);
                              final spendOn = transaction.spendOn;
                              final amount = transaction.amount;
                              final createdAtDateTime =
                                  DateTime.parse(transactionDate);

                              final hour = createdAtDateTime.hour;
                              final minute = createdAtDateTime.minute;

                              String? minuteStr;

                              if (minute < 10) {
                                minuteStr = '0$minute';
                              } else {
                                minuteStr = '$minute';
                              }

                              final time = '$hour:$minuteStr';

                              return TransactionItemList(
                                onTap: () {
                                  context.read<CategoryCubit>()
                                    ..getItemCategoryTransaction(
                                      itemCategoryTransaction: transaction,
                                      budget: state.budget,
                                      itemCategory: itemCategory,
                                    )
                                    ..getAccountById(
                                      accountId: transaction.accountId,
                                    );

                                  context.pushNamed(
                                    MyRoute.updateItemCategoryTransaction
                                        .noSlashes(),
                                  );
                                },
                                formatDate: formatDate,
                                spendOn: spendOn,
                                amount: amount,
                                time: time,
                                categoryName: itemCategory?.name,
                              );
                            },
                            separatorBuilder: (context, index) => AppDivider(
                              padding: getEdgeInsets(top: 10, bottom: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!itemIncomeLenOnlyOne)
                      Padding(
                        padding: getEdgeInsets(top: 16, right: 16, left: 16),
                        child: OutlineButtonPrimary(
                          onPressed: () async {
                            final title = localize.deleteCategory;
                            final contentText = localize.confirmDelete;
                            final result =
                                await AppDialog.showConfirmationDelete(
                              context,
                              title,
                              contentText,
                            );
                            if (result != null) {
                              _onDeleteItemCategory(itemCategory!.id);
                            }
                          },
                          label: localize.delete,
                        ),
                      ),
                    Padding(
                      padding: getEdgeInsets(top: 16, right: 16, left: 16),
                      child: OutlineButtonPrimary(
                        onPressed: () {
                          _showEditAmountDialog(
                            context: context,
                            itemCategory: itemCategory!,
                            leftToBudget: state.leftToBudget ?? 0,
                          );
                        },
                        label: localize.edit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditAmountDialog({
    required BuildContext context,
    required ItemCategoryHistory itemCategory,
    required double leftToBudget,
  }) {
    AppDialog.showCustomDialog(
      context,
      blurBackground: false,
      content: CategoryEditDialog(
        itemCategory: itemCategory,
        leftToBudget: leftToBudget,
      ),
    );
  }

  void _onDeleteItemCategory(String itemId) {
    context.read<CategoryCubit>().deleteItemCategory(itemId: itemId);
    context.pop();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(dynamic _, RouteInfo info) {
    context.pop();
    return true;
  }
}
