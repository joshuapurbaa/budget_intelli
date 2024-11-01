part of 'app_box_calendar_cubit.dart';

sealed class AppBoxCalendarState extends Equatable {
  const AppBoxCalendarState();

  @override
  List<Object> get props => [];
}

final class AppBoxCalendarInitial extends AppBoxCalendarState {}

final class AppBoxCalendarSelected extends AppBoxCalendarState {
  const AppBoxCalendarSelected(this.selectedDate);
  final DateTime selectedDate;

  @override
  List<Object> get props => [selectedDate];
}
