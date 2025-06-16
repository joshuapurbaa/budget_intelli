import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryEditDialog extends StatefulWidget {
  const CategoryEditDialog({
    required this.itemCategory,
    required this.leftToBudget,
    super.key,
  });

  final ItemCategoryHistory itemCategory;
  final double leftToBudget;

  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _nameFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = textLocalizer(context).editCategory;
    final category = widget.itemCategory;
    _nameController.text = category.name;
    _amountController.text = NumberFormatter.formatToMoneyDouble(
      context,
      category.amount,
    );
    return SizedBox(
      width: context.screenWidth * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            style: StyleType.headMed,
          ),
          Gap.vertical(16),
          AppDivider(
            color: context.color.onSurface.withValues(alpha: 0.3),
          ),
          Gap.vertical(10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${textLocalizer(context).leftToBudget2}: ',
                  style: textStyle(
                    context,
                    style: StyleType.bodMed,
                  ),
                ),
                TextSpan(
                  text: NumberFormatter.formatToMoneyDouble(
                    context,
                    widget.leftToBudget,
                  ),
                  style: textStyle(
                    context,
                    style: StyleType.bodMed,
                  ).copyWith(
                    color: context.color.primary,
                  ),
                ),
              ],
            ),
          ),
          Gap.vertical(10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _nameFocusNode,
                  controller: _nameController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  style: textStyle(
                    context,
                    style: StyleType.bodMed,
                  ),
                  decoration: InputDecoration(
                    hintText: textLocalizer(context).categoryName,
                    hintStyle: textStyle(
                      context,
                      style: StyleType.bodMed,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: context.color.onSurface.withValues(alpha: 0.05),
                    filled: true,
                  ),
                ),
              ),
              Gap.horizontal(5),
              Expanded(
                child: BlocBuilder<SettingBloc, SettingState>(
                  builder: (context, state) {
                    return TextField(
                      focusNode: _amountFocusNode,
                      controller: _amountController,
                      textAlign: TextAlign.end,
                      textInputAction: TextInputAction.done,
                      style: textStyle(
                        context,
                        style: StyleType.bodMed,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter.currency(
                          locale: state.currency.locale,
                          symbol: '${state.currency.symbol} ',
                          decimalDigits: 0,
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: NumberFormatter.formatToMoneyInt(
                          context,
                          0,
                        ),
                        hintStyle: textStyle(
                          context,
                          style: StyleType.bodMed,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            context.color.onSurface.withValues(alpha: 0.05),
                        filled: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Gap.vertical(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: AppText(
                    text: textLocalizer(context).cancel,
                    style: StyleType.bodMed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Gap.horizontal(10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.color.primary,
                  ),
                  onPressed: () {
                    final amount = _amountController.text;

                    // check if category name and amount is changed
                    if (category.name == _nameController.text &&
                        category.amount == amount.toDouble()) {
                      context.pop();
                      return;
                    }

                    context.read<CategoryCubit>().updateItemCategoryHistory(
                          itemCategoryHistory: category.copyWith(
                            name: _nameController.text,
                            amount: amount.toDouble(),
                            updatedAt: DateTime.now().toString(),
                          ),
                        );
                    context.pop();
                  },
                  child: AppText(
                    text: textLocalizer(context).save,
                    style: StyleType.bodMed,
                    color: context.color.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
