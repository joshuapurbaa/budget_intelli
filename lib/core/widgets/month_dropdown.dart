import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthDropdown extends StatefulWidget {
  const MonthDropdown({
    required this.controller,
    super.key,
    this.onSelected,
  });
  final TextEditingController controller;
  final void Function(String?)? onSelected;

  @override
  State<MonthDropdown> createState() => _MonthDropdownState();
}

class _MonthDropdownState extends State<MonthDropdown> {
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final settingState = context.read<SettingBloc>().state;
    final language = settingState.selectedLanguage.text;
    final monthList = language == 'Indonesia'
        ? AppStrings.monthListID
        : AppStrings.monthListEn;
    return AppGlass(
      padding: const EdgeInsets.only(
        left: 16,
        top: 8,
        right: 8,
        bottom: 8,
      ),
      child: DropdownMenu<String>(
        controller: widget.controller,
        expandedInsets: EdgeInsets.zero,
        menuHeight: 150.h,
        selectedTrailingIcon: const Icon(
          CupertinoIcons.chevron_up,
          size: 25,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          hintStyle: textStyle(
            context,
            StyleType.bodMd,
          ).copyWith(
            fontWeight: FontWeight.w400,
            color: context.color.onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailingIcon: const Icon(
          CupertinoIcons.chevron_down,
          size: 25,
        ),
        hintText: '${localize.month}*',
        textStyle: textStyle(
          context,
          StyleType.bodMd,
        ).copyWith(
          fontWeight: FontWeight.w700,
        ),
        requestFocusOnTap: false,
        onSelected: widget.onSelected,
        menuStyle: MenuStyle(
          visualDensity: VisualDensity.standard,
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        dropdownMenuEntries: monthList.map<DropdownMenuEntry<String>>(
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
    );
  }
}
