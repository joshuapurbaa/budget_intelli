import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMonthDropdown extends StatefulWidget {
  const AppMonthDropdown({
    required this.controller,
    super.key,
    this.onSelected,
  });
  final TextEditingController controller;
  final void Function(String?)? onSelected;

  @override
  State<AppMonthDropdown> createState() => _AppMonthDropdownState();
}

class _AppMonthDropdownState extends State<AppMonthDropdown> {
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final settingState = context.read<SettingBloc>().state;
    final language = settingState.selectedLanguage.text;
    final monthList = language == 'Indonesia'
        ? AppStrings.monthListID
        : AppStrings.monthListEn;
    return Container(
      padding: getEdgeInsetsSymmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: context.color.onInverseSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownMenu<String>(
        controller: widget.controller,
        expandedInsets: EdgeInsets.zero,
        menuHeight: 150.h,
        selectedTrailingIcon: const Icon(
          CupertinoIcons.chevron_up,
          size: 18,
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(
            minHeight: 40,
            maxHeight: 40,
          ),
          border: InputBorder.none,
          hintStyle: textStyle(
            context,
            style: StyleType.bodMed,
          ),
        ),
        trailingIcon: const Icon(
          CupertinoIcons.chevron_down,
          size: 18,
        ),
        hintText: localize.month,
        textStyle: textStyle(
          context,
          style: StyleType.bodMed,
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
                  style: StyleType.bodMed,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
