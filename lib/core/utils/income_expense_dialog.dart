import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class IncomeExpenseDialog {
  static void showInfoDialog(
    BuildContext context, {
    bool isIncome = false,
    bool isExpense = false,
  }) {
    final localize = textLocalizer(context);
    final settingState = context.read<SettingBloc>().state;
    final language = settingState.selectedLanguage;
    String? textInfo;
    if (isIncome) {
      if (language.text == AppStrings.indonesia) {
        textInfo = AppStrings.incomeInfoID;
      } else {
        textInfo = AppStrings.incomeInfoEN;
      }
    } else if (isExpense) {
      if (language.text == AppStrings.indonesia) {
        textInfo = AppStrings.expenseInfoID;
      } else {
        textInfo = AppStrings.expenseInfoEN;
      }
    }
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 50,
            bottom: 16,
          ),
          actionsPadding: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: AppText(
            text: isIncome ? localize.income : localize.expenses,
            style: StyleType.headMed,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.noMaxLines(
                  text: textInfo!,
                  style: StyleType.bodMed,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: AppText(
                text: localize.close,
                style: StyleType.headMed,
                color: context.color.primary,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
