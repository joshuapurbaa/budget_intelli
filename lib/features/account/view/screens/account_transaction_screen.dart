import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountTransactionScreen extends StatefulWidget {
  const AccountTransactionScreen({super.key});

  @override
  State<AccountTransactionScreen> createState() =>
      _AccountTransactionScreenState();
}

class _AccountTransactionScreenState extends State<AccountTransactionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetAllItemCategoryTransactionsEvent());
    context.read<AccountBloc>().add(GetItemCategoryHistoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        final accountId = state.selectedAccount?.id;
        final itemCategoryTransactions = state.itemCategoryTransactions;
        final itemCategoryHistories = state.itemCategoryHistories;
        final transactions = <ItemCategoryTransaction>[];

        if (accountId != null && itemCategoryTransactions.isNotEmpty) {
          final filterById = itemCategoryTransactions
              .where((element) => element.accountId == accountId);
          transactions.addAll(filterById);
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBarPrimary(
                title: localize.accountTransaction,
              ),
              if (transactions.isNotEmpty)
                SliverList.separated(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final itemHistoId = transaction.itemHistoId;

                    final transactionDate = transaction.createdAt;

                    final formatDate = getDayMonth(transactionDate, context);
                    final spendOn = transaction.spendOn;
                    final amount = transaction.amount;
                    final createdAtDateTime = DateTime.parse(transactionDate);

                    final hour = createdAtDateTime.hour;
                    final minute = createdAtDateTime.minute;
                    final time = '$hour:$minute';

                    ItemCategoryHistory? itemCategoryHistory;

                    if (itemCategoryHistories.isNotEmpty) {
                      itemCategoryHistory = itemCategoryHistories
                          .firstWhere((element) => element.id == itemHistoId);
                    }
                    final expense =
                        itemCategoryHistory?.type == AppStrings.expenseType;

                    return _TransactionItemList(
                      formatDate: formatDate,
                      spendOn: spendOn,
                      amount: amount,
                      time: time,
                      categoryName: itemCategoryHistory?.name ?? '-',
                      hexColor: itemCategoryHistory?.hexColor,
                      iconPath: itemCategoryHistory?.iconPath,
                      expense: expense,
                    );
                  },
                  separatorBuilder: (context, index) => Gap.vertical(10),
                ),
              if (transactions.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: AppText(
                      text: localize.noTransactions,
                      style: StyleType.bodLg,
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

class _TransactionItemList extends StatelessWidget {
  const _TransactionItemList({
    required this.formatDate,
    required this.spendOn,
    required this.amount,
    required this.time,
    required this.iconPath,
    required this.hexColor,
    required this.expense,
    this.categoryName,
  });

  final String formatDate;
  final String? spendOn;
  final double amount;
  final String time;
  // final bool noChevron;
  // final void Function()? onTap;
  final int? hexColor;
  final String? iconPath;
  final String? categoryName;
  final bool expense;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: getEdgeInsets(
          left: 16,
          right: 16,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor:
                  hexColor != null ? Color(hexColor!) : context.color.secondary,
              child: Padding(
                padding: getEdgeInsetsAll(8),
                child: AppText(
                  text: formatDate,
                  style: StyleType.labLg,
                  maxLines: 2,
                  color: context.color.onSecondary,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Gap.horizontal(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: spendOn ?? '-',
                    style: StyleType.bodMed,
                  ),
                  Row(
                    children: [
                      AppText(
                        text: '$categoryName, ',
                        style: StyleType.labLg,
                      ),
                      AppText(
                        text: time,
                        style: StyleType.labLg,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppText(
              text: NumberFormatter.formatToMoneyDouble(
                context,
                amount,
              ),
              style: StyleType.bodMed,
            ),
          ],
        ),
      ),
    );
  }
}
