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
  final int leftToBudget;

  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<CategoryEditDialog> {
  final _leftController = TextEditingController();
  final _rightController = TextEditingController();

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = textLocalizer(context).editCategory;
    final category = widget.itemCategory;
    _leftController.text = category.name;
    _rightController.text = NumberFormatter.formatToMoneyInt(
      context,
      category.amount,
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            style: StyleType.headMed,
          ),
          Gap.vertical(16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${textLocalizer(context).leftToBudget2}: ',
                  style: textStyle(
                    context,
                    StyleType.bodMd,
                  ),
                ),
                TextSpan(
                  text: NumberFormatter.formatToMoneyInt(
                    context,
                    widget.leftToBudget,
                  ),
                  style: textStyle(
                    context,
                    StyleType.bodMd,
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
                  controller: _leftController,
                  textInputAction: TextInputAction.next,
                  style: textStyle(
                    context,
                    StyleType.bodMd,
                  ),
                  decoration: InputDecoration(
                    hintText: textLocalizer(context).categoryName,
                    hintStyle: textStyle(
                      context,
                      StyleType.bodMd,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              Gap.horizontal(5),
              Expanded(
                child: BlocBuilder<SettingBloc, SettingState>(
                  builder: (context, state) {
                    return TextField(
                      controller: _rightController,
                      textAlign: TextAlign.end,
                      textInputAction: TextInputAction.done,
                      style: textStyle(
                        context,
                        StyleType.bodMd,
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
                        contentPadding: const EdgeInsets.all(10),
                        hintText: NumberFormatter.formatToMoneyInt(
                          context,
                          0,
                        ),
                        hintStyle: textStyle(
                          context,
                          StyleType.bodMd,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: context.color.onSurface.withOpacity(0.1),
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
                    style: StyleType.bodMd,
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
                    final amount = _rightController.text;
                    final amountInt = int.parse(
                      amount.replaceAll(RegExp('[^0-9]'), ''),
                    );
                    context.read<CategoryCubit>().updateItemCategoryHistory(
                          itemCategoryHistory: category.copyWith(
                            name: _leftController.text,
                            amount: amountInt,
                            updatedAt: DateTime.now().toString(),
                          ),
                        );
                    context.pop();
                  },
                  child: AppText(
                    text: textLocalizer(context).save,
                    style: StyleType.bodMd,
                    color: context.color.onPrimary,
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
