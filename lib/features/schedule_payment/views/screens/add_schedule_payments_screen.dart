import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddSchedulePaymentsScreen extends StatefulWidget {
  const AddSchedulePaymentsScreen({super.key});

  @override
  State<AddSchedulePaymentsScreen> createState() =>
      _AddSchedulePaymentsScreenState();
}

class _AddSchedulePaymentsScreenState extends State<AddSchedulePaymentsScreen> {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  final _repititionsController = TextEditingController();
  final _nameFocus = FocusNode();
  final _noteFocus = FocusNode();
  final _amountFocus = FocusNode();
  final _repititionsFocus = FocusNode();
  DateTime? _selectedDate;
  bool calendarOpened = false;

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _repititionsController.dispose();
    _nameFocus.dispose();
    _noteFocus.dispose();
    _amountFocus.dispose();
    _repititionsFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final text = AppText(
      text: _selectedDate == null
          ? '${localize.dueDateFieldLabel}*'
          : formatDateDDMMYYYY(_selectedDate!, context),
      style: StyleType.bodMd,
      fontWeight: _selectedDate == null ? FontWeight.w400 : FontWeight.w700,
      color: _selectedDate == null
          ? context.color.onSurface.withOpacity(0.5)
          : context.color.onSurface,
    );
    return BlocConsumer<SchedulePaymentDbBloc, SchedulePaymentDbState>(
      listener: (context, state) {
        if (state.insertSchedulePaymentSuccess &&
            state.insertRepetitionsSuccess) {
          AppToast.showToastSuccess(
            context,
            localize.createdSuccessFully,
            gravity: ToastGravity.TOP,
          );
          _reset();
          context.pop();
          context.read<SchedulePaymentDbBloc>().add(
                GetSchedulePaymentsFromDb(),
              );
        }

        if (state.errorMessageSchedulePayment != null ||
            state.errorMessageRepetition != null) {
          AppToast.showToastError(
            context,
            state.errorMessageSchedulePayment ?? 'Error inserting data',
          );
        }
      },
      builder: (context, state) {
        return AppScaffold(
          appBarTitle: localize.addSchedulePayment,
          onBackButtonPressed: () {
            context.pop();
            _reset();
          },
          titleTextStyle: textStyle(
            context,
            StyleType.bodMd,
          ),
          children: [
            AppBoxFormField(
              isPng: true,
              hintText: '${localize.nameFieldLabel}*',
              prefixIcon: schedulePayment,
              controller: _nameController,
              focusNode: _nameFocus,
              iconColor: context.color.onSurface,
            ),
            Gap.vertical(10),
            BoxCalculator(
              label: '${localize.totalAmountFieldLabel}*',
              focusNode: _nameFocus,
            ),
            Gap.vertical(10),
            AppBoxFormField(
              isPng: true,
              hintText: '${localize.totalRepetitionFieldLabel}*',
              prefixIcon: calendarRepeat,
              controller: _repititionsController,
              keyboardType: TextInputType.number,
              focusNode: _repititionsFocus,
              iconColor: Theme.of(context).colorScheme.onSurface,
            ),
            Gap.vertical(10),
            GestureDetector(
              onTap: _showCalendar,
              child: AppGlass(
                height: 70.h,
                child: Row(
                  children: [
                    getSvgPicture(
                      dateCalender,
                      color: context.color.onSurface,
                    ),
                    Gap.horizontal(16),
                    Expanded(
                      child: text,
                    ),
                    Gap.horizontal(16),
                    Icon(
                      calendarOpened
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                      size: 25,
                    ),
                    Gap.horizontal(10),
                  ],
                ),
              ),
            ),
            Gap.vertical(10),
            AppBoxFormField(
              isPng: true,
              hintText: '${localize.noteFieldLabel} (${localize.optional})',
              prefixIcon: noteDescriptionPng,
              controller: _noteController,
              iconColor: Theme.of(context).colorScheme.onSurface,
              focusNode: _noteFocus,
            ),
            Gap.vertical(26),
            if (!state.insertSchedulePaymentSuccess &&
                !state.insertRepetitionsSuccess)
              AppButton.darkLabel(
                label: localize.save,
                isActive: true,
                onPressed: () {
                  _nameFocus.unfocus();
                  _noteFocus.unfocus();
                  _repititionsFocus.unfocus();

                  final schedulePaymentId = const Uuid().v4();
                  final amount = ControllerHelper.getAmount(context);
                  final repitition = ControllerHelper.parseStringToInt(
                    _repititionsController.text,
                  );

                  final status = getStatusSchedulePayment(
                    StatusSchedulePayment.active,
                  );

                  final repititionList = <Repetition>[];

                  if (_nameController.text.isNotEmpty &&
                      repitition != null &&
                      amount != null &&
                      _selectedDate != null) {
                    for (var i = 1; i < repitition + 1; i++) {
                      final currentMonth = _selectedDate!.month + i;
                      final currentYear =
                          _selectedDate!.year + (currentMonth > 12 ? 1 : 0);
                      final month = (currentMonth - 1) % 12 + 1;
                      final lastDayOfMonth =
                          DateTime(currentYear, month + 1, 0).day;
                      final day = _selectedDate!.day <= lastDayOfMonth
                          ? _selectedDate!.day
                          : lastDayOfMonth;

                      final dueDate = DateTime(currentYear, month, day);

                      repititionList.add(
                        Repetition(
                          id: const Uuid().v1(),
                          dueDate: dueDate.toString(),
                          status: status,
                          schedulePaymentId: schedulePaymentId,
                        ),
                      );
                    }
                    context.read<SchedulePaymentDbBloc>()
                      ..add(
                        InsertSchedulePaymentToDb(
                          schedulePayment: SchedulePayment(
                            id: schedulePaymentId,
                            name: _nameController.text,
                            status: status,
                            amount: amount,
                            dueDate: _selectedDate.toString(),
                            description: _noteController.text,
                            createdAt: DateTime.now().toString(),
                            repitition: repitition,
                          ),
                        ),
                      )
                      ..add(
                        InsertRepetitionsEvent(repititionList),
                      );
                  } else {
                    AppToast.showToastError(
                      context,
                      localize.pleaseFillAllRequiredFields,
                      gravity: ToastGravity.TOP,
                    );
                  }
                },
              ),
            // if (state.insertSuccess) ...[
            //   OutlineButtonPrimary(
            //     label: localize.back,
            //     onPressed: () {
            //       _reset();
            //       context.pop();
            //     },
            //   ),
            //   Gap.vertical(16),
            //   AppButton.darkLabel(
            //     label: localize.addAnother,
            //     onPressed: () {
            //       _reset();
            //       AppScrollController.scrollToTop(context);
            //     },
            //   ),
            // ],
          ],
        );
      },
    );
  }

  Future<void> _showCalendar() async {
    final localize = textLocalizer(context);

    setState(() {
      calendarOpened = !calendarOpened;
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
      if (result.year == now.year &&
          result.month == now.month &&
          result.day == now.day) {
        _selectedDate = DateTime(
          result.year,
          result.month,
          result.day,
          hour,
          minute,
        );
      } else {
        _selectedDate = DateTime(
          result.year,
          result.month,
          result.day,
        );
      }

      setState(() {
        calendarOpened = false;
      });
    } else {
      setState(() {
        calendarOpened = false;
      });
    }
  }

  void _reset() {
    _noteController.clear();
    _nameController.clear();
    _repititionsController.clear();
    _selectedDate = null;
    context.read<BoxCalculatorCubit>().unselect();
    context.read<SchedulePaymentDbBloc>().add(ResetStatePaymentDbBloc());
    context
        .read<BoxCalendarCubit>()
        .setToInitial(CalendarDatePicker2Type.single);
    context.read<BoxCategoryCubit>().setToInitial();
  }
}
