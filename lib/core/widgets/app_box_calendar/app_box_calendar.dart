import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBoxCalendar extends StatefulWidget {
  const AppBoxCalendar({
    required this.label,
    super.key,
  });

  final String label;

  @override
  State<AppBoxCalendar> createState() => _AppBoxCalendarState();
}

class _AppBoxCalendarState extends State<AppBoxCalendar> {
  bool _calendarOpened = false;
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    final textDate = AppText(
      text: _selectedDate == null
          ? widget.label
          : formatDateDDMMYYYY(_selectedDate!, context),
      style: StyleType.bodMd,
      fontWeight: _selectedDate == null ? FontWeight.w400 : FontWeight.w700,
      color: _selectedDate == null
          ? context.color.onSurface.withOpacity(0.5)
          : context.color.onSurface,
    );

    return GestureDetector(
      onTap: _showCalendar,
      child: AppGlass(
        height: 70.h,
        child: Row(
          children: [
            getSvgAsset(
              dateCalender,
              color: context.color.onSurface,
            ),
            Gap.horizontal(16),
            Expanded(
              child: textDate,
            ),
            Gap.horizontal(16),
            Icon(
              _calendarOpened
                  ? CupertinoIcons.chevron_up
                  : CupertinoIcons.chevron_down,
              size: 25,
            ),
            Gap.horizontal(10),
          ],
        ),
      ),
    );
  }

  Future<void> _showCalendar() async {
    final localize = textLocalizer(context);

    setState(() {
      _calendarOpened = !_calendarOpened;
    });

    final result = await showAdaptiveDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final firstDate = DateTime.now().subtract(const Duration(days: 365));
        final lastDate = DateTime.now().add(const Duration(days: 365));
        return DatePickerDialog(
          firstDate: firstDate,
          lastDate: lastDate,
          confirmText: localize.select,
          cancelText: localize.cancel,
          helpText: localize.selectDate,
        );
      },
    );

    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    if (result != null) {
      _selectedDate = DateTime(
        result.year,
        result.month,
        result.day,
        hour,
        minute,
      );
      if (mounted) {
        context.read<AppBoxCalendarCubit>().selectDate(_selectedDate!);
      }

      setState(() {
        _calendarOpened = false;
      });
    } else {
      setState(() {
        _calendarOpened = false;
      });
    }
  }
}
