import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CalculatorBottomSheet extends StatefulWidget {
  const CalculatorBottomSheet({
    super.key,
  });

  @override
  State<CalculatorBottomSheet> createState() => _CalculatorBottomSheetState();
}

class _CalculatorBottomSheetState extends State<CalculatorBottomSheet> {
  final List<String> balancedList = [
    'Cash',
    'Credit Card',
    'Debit Card',
  ];
  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AccountBloc>().state.accounts;
    print('accounts: $accounts');
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      padding: getEdgeInsetsSymmetric(horizontal: 10),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: getEdgeInsets(top: 10),
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: context.color.onInverseSurface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              Gap.vertical(20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.color.onInverseSurface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: accounts.isEmpty
                          ? GestureDetector(
                              onTap: () {
                                context.push(MyRoute.addAccountScreen);
                              },
                              child: Padding(
                                padding: getEdgeInsetsAll(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppText(
                                      text: 'Add Account',
                                      style: StyleType.bodMd,
                                      color: context.color.primary,
                                      textAlign: TextAlign.center,
                                    ),
                                    Gap.horizontal(5),
                                    Icon(
                                      CupertinoIcons.add,
                                      color: context.color.primary,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : DropdownMenu<Account>(
                              controller: TextEditingController(),
                              expandedInsets: const EdgeInsets.all(8),
                              menuHeight: 150.h,
                              selectedTrailingIcon: const Icon(
                                CupertinoIcons.chevron_up,
                                size: 20,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                border: InputBorder.none,
                                hintStyle: textStyle(
                                  context,
                                  StyleType.bodMd,
                                ).copyWith(
                                  color: context.color.primary,
                                ),
                              ),
                              leadingIcon: const Icon(
                                CupertinoIcons.airplane,
                                size: 20,
                                color: Color(0xFF1A1A1A),
                              ),
                              trailingIcon: Icon(
                                CupertinoIcons.chevron_down,
                                size: 20,
                                color: context.color.primary,
                              ),
                              hintText: 'Balanced',
                              textStyle: textStyle(
                                context,
                                StyleType.bodMd,
                              ).copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              requestFocusOnTap: false,
                              onSelected: (Account? value) {},
                              menuStyle: MenuStyle(
                                visualDensity: VisualDensity.standard,
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              dropdownMenuEntries:
                                  accounts.map<DropdownMenuEntry<Account>>(
                                (Account acc) {
                                  return DropdownMenuEntry<Account>(
                                    value: acc,
                                    label: acc.name,
                                    style: MenuItemButton.styleFrom(
                                      visualDensity: VisualDensity.comfortable,
                                      textStyle: textStyle(
                                        context,
                                        StyleType.bodMd,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                    ),
                  ),
                  Gap.horizontal(10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.color.onInverseSurface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // padding: getEdgeInsetsAll(12),
                      child: DropdownMenu<String>(
                        controller: TextEditingController(),
                        expandedInsets: const EdgeInsets.all(8),
                        menuHeight: 150.h,
                        selectedTrailingIcon: const Icon(
                          CupertinoIcons.chevron_up,
                          size: 20,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          border: InputBorder.none,
                          hintStyle: textStyle(
                            context,
                            StyleType.bodMd,
                          ).copyWith(
                            color: context.color.primary,
                          ),
                        ),
                        leadingIcon: const Icon(
                          CupertinoIcons.airplane,
                          size: 20,
                          color: Color(0xFF1A1A1A),
                        ),
                        trailingIcon: Icon(
                          CupertinoIcons.chevron_down,
                          size: 20,
                          color: context.color.primary,
                        ),
                        hintText: 'Category',
                        textStyle: textStyle(
                          context,
                          StyleType.bodMd,
                        ).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        requestFocusOnTap: false,
                        onSelected: (String? value) {},
                        menuStyle: MenuStyle(
                          visualDensity: VisualDensity.standard,
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        dropdownMenuEntries:
                            balancedList.map<DropdownMenuEntry<String>>(
                          (String month) {
                            return DropdownMenuEntry<String>(
                              value: month,
                              label: month,
                              style: MenuItemButton.styleFrom(
                                visualDensity: VisualDensity.comfortable,
                                textStyle: textStyle(
                                  context,
                                  StyleType.bodMd,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              Gap.vertical(15),
              AppText(
                text: 'Expenses',
                style: StyleType.bodLg,
                color: context.color.onSurface,
              ),
              Gap.vertical(15),
              BlocBuilder<FinancialCalculatorCubit, FinancialCalculatorState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppText(
                            text: r'$',
                            style: StyleType.disSm,
                          ),
                          Gap.horizontal(5),
                          AppText(
                            text: NumberFormatter.formatStringToMoneyNoSymbol(
                              context,
                              state.amountDisplay,
                              decimalDigits: 0,
                            ),
                            style: StyleType.disLg,
                          ),
                        ],
                      ),
                      AppText(
                        text: state.expression,
                        style: StyleType.bodMd,
                        color: context.color.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  );
                },
              ),
              const TextField(
                textAlign: TextAlign.center,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Add comment...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const Spacer(),
              const CalculatorButtons(),
              Gap.vertical(8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(382.w, 58.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: context.color.primary,
                ),
                onPressed: () {
                  context.pop();
                },
                child: AppText(
                  text: 'Catat Transaksi',
                  style: StyleType.bodLg,
                  color: context.color.onPrimary,
                ),
              ),
              Gap.vertical(20),
            ],
          ),
        ],
      ),
    );
  }
}
