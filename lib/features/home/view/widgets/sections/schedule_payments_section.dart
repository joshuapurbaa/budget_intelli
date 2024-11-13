import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/home/view/widgets/info_label_section.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SchedulePaymentsSection extends StatelessWidget {
  const SchedulePaymentsSection({
    required this.schedulePayments,
    required this.isLightMode,
    super.key,
  });

  final List<SchedulePayment> schedulePayments;
  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    if (schedulePayments.isEmpty) {
      return Padding(
        padding: getEdgeInsetsAll(16),
        child: EmptySectionWidget(
          label: localize.noSchedulePaymentsFound,
          onTap: () {
            context.push(MyRoute.addSchedulePayment);
          },
        ),
      );
    }

    return Padding(
      padding: getEdgeInsets(left: 16, right: 16),
      child: Column(
        children: [
          InfoLabelSection(
            label: localize.schedulePayments,
            seeAllOnTap: () {
              context.push(MyRoute.schedulePaymentsList);
            },
          ),
          Gap.vertical(16),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedulePayments.length,
            separatorBuilder: (context, index) => Gap.vertical(8),
            itemBuilder: (context, index) {
              final item = schedulePayments[index];
              final name = item.name;
              final amountFormatted = NumberFormatter.formatToMoneyDouble(
                context,
                item.amount,
              );
              final date = item.dueDate;
              // final category = getCategoryByName(item.category);
              // final icon = category['icon'] as String;
              // final backgroundColor = category['color'] as Color;
              final dueDateString = item.dueDate;
              final isCompleted = item.status == 'Completed';
              return GestureDetector(
                onTap: () {
                  context
                      .read<GetSchedulePaymentCubit>()
                      .getSchedulePaymentById(item.id);

                  context.push(
                    MyRoute.schedulePaymentsDetail,
                  );
                },
                child: ScheduledPaymentsCard(
                  // icon: icon,
                  // backgroundColor: backgroundColor,
                  name: name,
                  dueDateString: dueDateString,
                  amountFormatted: amountFormatted,
                  date: date,
                  isCompleted: isCompleted,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
