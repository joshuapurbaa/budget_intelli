import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchedulePaymentsDetailScreen extends StatefulWidget {
  const SchedulePaymentsDetailScreen({super.key});

  @override
  State<SchedulePaymentsDetailScreen> createState() =>
      _SchedulePaymentsDetailScreenState();
}

class _SchedulePaymentsDetailScreenState
    extends State<SchedulePaymentsDetailScreen> {
  bool notificationEnable = false;
  final settingPref = SettingPreferenceRepo();

  Future<void> _getSchedulePaymentNotification() async {
    final enable = await settingPref.getSchedulePaymentNotification();
    setState(() {
      notificationEnable = enable ?? false;
    });
  }

  Future<void> _setSchedulePaymentNotification({required bool val}) async {
    await settingPref.setSchedulePaymentNotification(value: val);
  }

  @override
  void initState() {
    super.initState();
    _getSchedulePaymentNotification();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocBuilder<SchedulePaymentDbBloc, SchedulePaymentDbState>(
      builder: (context, state) {
        final schedulePayment = state.schedulePayment;

        final repetitions = state.repetitions;
        final name = schedulePayment?.name;
        var description = schedulePayment?.description ?? '-';
        final amountFormatted = NumberFormatter.formatToMoneyDouble(
          context,
          schedulePayment?.amount ?? 0,
        );

        var totalPaid = 0;
        final repetitionLen = repetitions.length;
        var remaining = 0;

        for (final rep in repetitions) {
          if (rep.status == 'Paid') {
            totalPaid++;
          }
        }
        remaining = repetitionLen - totalPaid;

        if (description.isEmpty) {
          description = '-';
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBarPrimary(
                title: name ?? '-',
              ),
              SliverToBoxAdapter(
                child: AppGlass(
                  onTap: () {},
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              text: 'Status',
                              style: StyleType.bodMd,
                            ),
                            AppText(
                              text: localize.description,
                              style: StyleType.bodMd,
                            ),
                            AppText(
                              text: localize.amountFieldLabel,
                              style: StyleType.bodMd,
                            ),
                            AppText(
                              text: localize.repetition,
                              style: StyleType.bodMd,
                            ),
                            const AppText(
                              text: 'Paid/remaining',
                              style: StyleType.bodMd,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: ':  ${schedulePayment?.status ?? '-'}',
                              style: StyleType.bodMd,
                              fontWeight: FontWeight.w600,
                            ),
                            AppText(
                              text: ':  $description',
                              style: StyleType.bodMd,
                              fontWeight: FontWeight.w600,
                            ),
                            AppText(
                              text: ':  $amountFormatted',
                              style: StyleType.bodMd,
                              fontWeight: FontWeight.w600,
                            ),
                            AppText(
                              text: ':  ${repetitionLen}x',
                              style: StyleType.bodMd,
                              fontWeight: FontWeight.w600,
                            ),
                            AppText(
                              text: ':  $totalPaid/$remaining',
                              style: StyleType.bodMd,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            text: 'Notification',
                            style: StyleType.bodMd,
                            fontWeight: FontWeight.w600,
                          ),
                          Switch.adaptive(
                            value: notificationEnable,
                            onChanged: (val) {
                              _setSchedulePaymentNotification(val: val);

                              setState(
                                () {
                                  notificationEnable = val;
                                },
                              );

                              if (val) {
                                _setScheduleNotification(
                                  repetitions: state.repetitions,
                                  paymentName: name ?? '-',
                                );
                              } else {
                                cancelAllNotifications();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 10,
                  right: 16,
                ),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const AppDivider(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final rep = state.repetitions[index];
                    final status = getStatusSchedulePaymentEnum(rep.status);
                    final paid = status == StatusSchedulePayment.paid;
                    final overdue = status == StatusSchedulePayment.overdue;

                    return Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const AppText(
                                  text: 'Payment ',
                                  style: StyleType.bodLg,
                                ),
                                AppText(
                                  text: '${index + 1}',
                                  style: StyleType.bodLg,
                                ),
                              ],
                            ),
                            AppText(
                              text: formatDateDDMMYYYY(
                                DateTime.parse(rep.dueDate),
                                context,
                              ),
                              style: StyleType.bodMd,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Switch.adaptive(
                              value: paid,
                              onChanged: (val) {
                                String? updatedStatus;
                                if (paid) {
                                  updatedStatus = getStatusSchedulePayment(
                                    StatusSchedulePayment.active,
                                  );
                                  if (remaining == 0) {
                                    final updatedSchedulePayment =
                                        SchedulePayment(
                                      status: updatedStatus,
                                      id: schedulePayment!.id,
                                      name: schedulePayment.name,
                                      amount: schedulePayment.amount,
                                      dueDate: schedulePayment.dueDate,
                                      createdAt: schedulePayment.createdAt,
                                      repitition: schedulePayment.repitition,
                                    );
                                    context.read<SchedulePaymentDbBloc>()
                                      ..add(
                                        UpdateSchedulePaymentDbEvent(
                                          updatedSchedulePayment,
                                        ),
                                      )
                                      ..add(
                                        GetSchedulePaymentByIdFromDb(
                                          id: schedulePayment.id,
                                        ),
                                      );
                                  }
                                } else {
                                  updatedStatus = getStatusSchedulePayment(
                                    StatusSchedulePayment.paid,
                                  );

                                  if (remaining == 1) {
                                    final updatedSchedulePayment =
                                        SchedulePayment(
                                      status: updatedStatus,
                                      id: schedulePayment!.id,
                                      name: schedulePayment.name,
                                      amount: schedulePayment.amount,
                                      dueDate: schedulePayment.dueDate,
                                      createdAt: schedulePayment.createdAt,
                                      repitition: schedulePayment.repitition,
                                    );
                                    context.read<SchedulePaymentDbBloc>()
                                      ..add(
                                        UpdateSchedulePaymentDbEvent(
                                          updatedSchedulePayment,
                                        ),
                                      )
                                      ..add(
                                        GetSchedulePaymentByIdFromDb(
                                          id: schedulePayment.id,
                                        ),
                                      );
                                  }
                                }
                                final updatedRep = Repetition(
                                  id: rep.id,
                                  dueDate: rep.dueDate,
                                  status: updatedStatus,
                                  schedulePaymentId: rep.schedulePaymentId,
                                );
                                context.read<SchedulePaymentDbBloc>()
                                  ..add(
                                    UpdateRepetitionByIdEvent(updatedRep),
                                  )
                                  ..add(
                                    GetRepetitionListBySchedulePaymentIdEvent(
                                      rep.schedulePaymentId,
                                    ),
                                  );
                              },
                            ),
                            if (overdue)
                              AppText(
                                text: localize.overdue,
                                style: StyleType.bodMd,
                                color: context.color.error,
                              ),
                            if (paid)
                              AppText(
                                text: localize.paid,
                                style: StyleType.bodMd,
                                color: AppColor.green,
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                  itemCount: repetitionLen,
                ),
              ),
            ],
          ),
          // bottomSheet: BottomSheetParent(
          //   isWithBorderTop: true,
          //   child: AppButton(
          //     label: localize.save,
          //     onPressed: () {},
          //   ),
          // ),
        );
      },
    );
  }

  Future<void> _setScheduleNotification({
    required List<Repetition> repetitions,
    required String paymentName,
  }) async {
    for (final rep in repetitions) {
      final dueDate = DateTime.parse(rep.dueDate);
      await scheduleDailyNotification(
        title: '$paymentName Payment Reminder',
        body: "Hi, don't forget to make your payment today!",
        hour: 8,
        year: dueDate.year,
        month: dueDate.month,
        day: dueDate.day,
      );
    }
  }
}
