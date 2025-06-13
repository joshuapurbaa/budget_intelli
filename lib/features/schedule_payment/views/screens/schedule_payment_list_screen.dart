import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SchedulePaymentListScreen extends StatefulWidget {
  const SchedulePaymentListScreen({super.key});

  @override
  State<SchedulePaymentListScreen> createState() =>
      _SchedulePaymentListScreenState();
}

class _SchedulePaymentListScreenState extends State<SchedulePaymentListScreen> {
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocConsumer<SchedulePaymentDbBloc, SchedulePaymentDbState>(
      listener: (context, state) {},
      builder: (context, state) {
        final schedulePayments = state.schedulePayments;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBarPrimary(
                title: localize.schedulePayments,
              ),
              if (schedulePayments.isEmpty) ...[
                SliverToBoxAdapter(
                  child: AppGlass(
                    onTap: () {
                      context.pushNamed(
                        MyRoute.addSchedulePayment.noSlashes(),
                      );
                    },
                    margin: getEdgeInsetsAll(16),
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.add,
                        ),
                        Gap.horizontal(16),
                        const AppText(
                          text: 'Add Schedule Payment',
                          style: StyleType.bodMed,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (schedulePayments.isNotEmpty) ...[
                SliverList.separated(
                  itemCount: schedulePayments.length,
                  separatorBuilder: (context, index) => Gap.vertical(10),
                  itemBuilder: (context, index) {
                    final item = schedulePayments[index];

                    return AppGlass(
                      onTap: () {
                        context.read<SchedulePaymentDbBloc>()
                          ..add(
                            GetSchedulePaymentByIdFromDb(id: item.id),
                          )
                          ..add(
                            GetRepetitionListBySchedulePaymentIdEvent(item.id),
                          );
                        context.pushNamed(
                          MyRoute.schedulePaymentsDetail.noSlashes(),
                        );
                      },
                      margin: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: index == 0 ? 16 : 0,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: AppText(
                                text: item.status,
                                style: StyleType.bodSm,
                              ),
                            ),
                          ),
                          Gap.horizontal(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: item.name,
                                  style: StyleType.bodLg,
                                ),
                                Gap.vertical(5),
                                AppText(
                                  text: 'Total Repetition ${item.repitition}x',
                                  style: StyleType.bodMed,
                                  fontStyle: FontStyle.italic,
                                ),
                                if (item.description != null) ...[
                                  Gap.vertical(5),
                                  AppText(
                                    text: item.description ?? '-',
                                    style: StyleType.bodSm,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.chevron_compact_right,
                            size: 30,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              SliverToBoxAdapter(
                child: Gap.vertical(100),
              ),
            ],
          ),
          bottomSheet: BottomSheetParent(
            isWithBorderTop: true,
            child: AppButton(
              label: 'Add Schedule Payment',
              onPressed: () {
                context.pushNamed(
                  MyRoute.addSchedulePayment.noSlashes(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
