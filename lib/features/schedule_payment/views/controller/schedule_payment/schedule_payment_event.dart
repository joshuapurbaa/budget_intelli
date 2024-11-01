part of 'schedule_payment_bloc.dart';

@immutable
sealed class SchedulePaymentEvent {}

class GetSchedulePaymentsEvent extends SchedulePaymentEvent {
  GetSchedulePaymentsEvent({
    required this.limit,
    this.offset,
    this.search,
    this.orderBy,
    this.isDescending = true,
    this.lastDocument,
    this.filterBy,
  });
  final int limit;
  final int? offset;
  final String? search;
  final String? orderBy;
  final bool isDescending;
  final DocumentSnapshot? lastDocument;
  final String? filterBy;
}
