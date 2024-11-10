import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/account/account_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AccountDropdown extends StatelessWidget {
  const AccountDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AccountBloc>().state.accounts;
    final localize = textLocalizer(context);
    return Container(
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
                      text: localize.addAccountFIeldLabel,
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
              leadingIcon: Padding(
                padding: const EdgeInsets.all(8),
                child: getPngAsset(
                  accountPng,
                  width: 20,
                  height: 20,
                  color: context.color.primary,
                ),
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
              onSelected: (Account? value) {
                if (value != null) {
                  context.read<AccountBloc>().add(
                        SelectAccountEvent(value),
                      );
                }
              },
              menuStyle: MenuStyle(
                visualDensity: VisualDensity.standard,
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              dropdownMenuEntries: accounts.map<DropdownMenuEntry<Account>>(
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
    );
  }
}
