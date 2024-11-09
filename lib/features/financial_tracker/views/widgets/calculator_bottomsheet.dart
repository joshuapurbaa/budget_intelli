import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:budget_intelli/features/calculator/calculator_barrel.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:budget_intelli/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CalculatorBottomSheet extends StatefulWidget {
  const CalculatorBottomSheet({
    super.key,
  });

  @override
  State<CalculatorBottomSheet> createState() => _CalculatorBottomSheetState();
}

class _CalculatorBottomSheetState extends State<CalculatorBottomSheet> {
  final _commentController = TextEditingController();
  final notifier = CalculatorNotifier();

  @override
  void initState() {
    super.initState();
    notifier.addListener(() {
      setState(() {});
    });
    _setInitialValues();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final isIncome = context.watch<FinancialDashboardCubit>().state.isIncome;
    final zeroExpression = notifier.expression == '0';
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
                  const Expanded(
                    child: AccountDropdown(),
                  ),
                  Gap.horizontal(10),
                  const Expanded(
                    child: CategoryDropdown(),
                  ),
                ],
              ),
              Gap.vertical(15),
              AppText(
                text: isIncome ? localize.income : localize.expenses,
                style: StyleType.bodLg,
                color: context.color.onSurface,
              ),
              Gap.vertical(15),
              Column(
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
                        text: notifier.result,
                        style: StyleType.disLg,
                      ),
                    ],
                  ),
                  if (!zeroExpression)
                    AppText(
                      text: notifier.expression,
                      style: StyleType.bodMd,
                      color: context.color.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                ],
              ),
              TextField(
                controller: _commentController,
                textAlign: TextAlign.center,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: '${localize.addComment}...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const Spacer(),
              CalculatorButtons(
                notifier: notifier,
              ),
              Gap.vertical(5),
              Row(
                children: [
                  MemberButton(),
                  Gap.horizontal(5),
                  Expanded(
                    child: BlocConsumer<FinancialTransactionBloc,
                        FinancialTransactionState>(
                      listener: (context, state) {
                        if (state.insertSuccess) {
                          context.pop();
                          context.read<FinancialTransactionBloc>().add(
                                const ResetFinancialTransactionStateEvent(),
                              );
                          context
                              .read<FinancialDashboardCubit>()
                              .getAllFinancialTransactionByMonthAndYear(
                                context,
                                namaBulan: context
                                    .read<FinancialDashboardCubit>()
                                    .state
                                    .selectedMonth,
                              );
                        } else {
                          AppToast.showToastError(context, localize.failed);
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(382.w, 65.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: context.color.primary,
                          ),
                          onPressed: () {
                            final category = context
                                .read<FinancialCategoryBloc>()
                                .state
                                .selectedFinancialCategory;
                            final account = context
                                .read<AccountBloc>()
                                .state
                                .selectedAccount;
                            final location = context
                                .read<LocationCubit>()
                                .state
                                .transactionLocation;
                            final imageBytes = ControllerHelper.getImagesBytes(
                              context,
                            );
                            final date = context
                                .read<TimeScrollWheelCubit>()
                                .state
                                .selectedDate;
                            final isIncome = context
                                .read<FinancialDashboardCubit>()
                                .state
                                .isIncome;

                            if (category != null && account != null) {
                              final transaction = FinancialTransaction(
                                id: const Uuid().v4(),
                                createdAt: DateTime.now().toString(),
                                updatedAt: DateTime.now().toString(),
                                comment: _commentController.text,
                                amount: double.parse(
                                    notifier.result.replaceAll(',', '')),
                                date: date.toString(),
                                type: isIncome ? 'income' : 'expense',
                                categoryName: category.categoryName,
                                accountName: account.name,
                                accountId: account.id,
                                categoryId: category.id,
                                transactionLocation: location,
                                picture: imageBytes,
                                memberId: state.selectedMember.id,
                                memberName: state.selectedMember.name,
                              );

                              context.read<FinancialTransactionBloc>().add(
                                    InsertFinancialTransactionEvent(
                                        transaction),
                                  );
                            }
                          },
                          child: AppText(
                            text: localize.recordTransaction,
                            style: StyleType.bodLg,
                            color: context.color.onPrimary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Gap.vertical(20),
            ],
          ),
        ],
      ),
    );
  }

  void _setInitialValues() {
    final amount = ControllerHelper.getAmount(context);

    if (amount != null) {
      final formatter = NumberFormat('#,###');
      notifier.setInitialValues(
        result: formatter.format(amount),
        expression: formatter.format(amount),
      );
    } else {
      notifier.setInitialValues(
        result: '0',
        expression: '0',
      );
    }
  }
}

class MemberButton extends StatelessWidget {
  const MemberButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialTransactionBloc, FinancialTransactionState>(
      builder: (context, state) {
        final member = state.selectedMember;
        final iconPath = member.iconPath;
        final icon = member.icon;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(85.w, 65.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.zero,
            backgroundColor: context.color.primaryContainer,
          ),
          onPressed: () {
            AppDialog.showAnimationDialog(
              context: context,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    memberStaticList.length,
                    (index) {
                      final iconPath = memberStaticList[index].iconPath;
                      final icon = memberStaticList[index].icon;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(85.w, 70.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.zero,
                            backgroundColor: context.color.primaryContainer,
                          ),
                          onPressed: () {
                            context.read<FinancialTransactionBloc>().add(
                                  SelectMemberEvent(
                                    memberStaticList[index],
                                  ),
                                );
                            context.pop();
                          },
                          child: _IconMember(
                            iconPath: iconPath,
                            icon: icon,
                            name: memberStaticList[index].name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          child: _IconMember(
            iconPath: iconPath,
            icon: icon,
            name: member.name,
          ),
        );
      },
    );
  }
}

class _IconMember extends StatefulWidget {
  const _IconMember({
    super.key,
    this.iconPath,
    this.icon,
    required this.name,
  });

  final String? iconPath;
  final Uint8List? icon;
  final String name;

  @override
  State<_IconMember> createState() => _IconMemberState();
}

class _IconMemberState extends State<_IconMember> {
  String? language;

  @override
  void initState() {
    super.initState();
    _getLanguage();
  }

  Future<void> _getLanguage() async {
    language = await serviceLocator<SettingPreferenceRepo>().getLanguage();
    setState(() {
      language = language;
    });
  }

  String _setName(String language, String name) {
    if (language == 'Indonesia') {
      if (name == 'Self') {
        return 'Sendiri';
      } else if (name == 'Wife') {
        return 'Istri';
      } else if (name == 'Husband') {
        return 'Suami';
      } else if (name == 'Child') {
        return 'Anak';
      } else if (name == 'Parents') {
        return 'Orang Tua';
      } else if (name == 'Pet') {
        return 'Peliharaan';
      }
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    if (language == null) {
      return const CircularProgressIndicator.adaptive();
    }

    if (widget.iconPath != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getPngAsset(
            widget.iconPath!,
            width: 30,
            height: 30,
            color: context.color.primary,
          ),
          Gap.vertical(2),
          AppText(
            text: _setName(language!, widget.name),
            style: StyleType.bodSm,
            color: context.color.primary,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.memory(
            widget.icon!,
            width: 30,
            height: 30,
          ),
          Gap.vertical(3),
          AppText(
            text: _setName(language!, widget.name),
            style: StyleType.bodSm,
            color: context.color.primary,
          ),
        ],
      );
    }
  }
}
