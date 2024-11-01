import 'package:budget_intelli/core/core.dart';

ListMap listCategories({
  required CategoriesType categoriesType,
}) {
  switch (categoriesType) {
    case CategoriesType.expenses:
      return spendingCategories;

    case CategoriesType.income:
      return incomeCategories;

    case CategoriesType.schedulePayment:
      return schedulePaymentCategories;
  }
}
