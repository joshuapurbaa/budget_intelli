import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YearDropdown extends StatefulWidget {
  const YearDropdown({
    required this.controller,
    super.key,
    this.onSelected,
  });
  final TextEditingController controller;
  final void Function(int?)? onSelected;

  @override
  State<YearDropdown> createState() => _YearDropdownState();
}

class _YearDropdownState extends State<YearDropdown> {
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return AppGlass(
      padding: const EdgeInsets.only(
        left: 16,
        top: 8,
        right: 8,
        bottom: 8,
      ),
      child: DropdownMenu<int>(
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
            style: StyleType.bodMd,
          ).copyWith(
            fontWeight: FontWeight.w400,
            color: context.color.onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailingIcon: const Icon(
          CupertinoIcons.chevron_down,
          size: 25,
        ),
        hintText: '${localize.year}*',
        textStyle: textStyle(
          context,
          style: StyleType.bodMd,
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
        dropdownMenuEntries: yearList.map<DropdownMenuEntry<int>>(
          (int year) {
            return DropdownMenuEntry<int>(
              value: year,
              label: year.toString(),
              style: MenuItemButton.styleFrom(
                visualDensity: VisualDensity.comfortable,
                textStyle: textStyle(
                  context,
                  style: StyleType.bodMd,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  List<int> yearList =
      List.generate(11, (index) => DateTime.now().year + index);
}
