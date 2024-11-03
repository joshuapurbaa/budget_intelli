part of 'time_scroll_wheel_cubit.dart';

final class TimeScrollWheelState extends Equatable {
  TimeScrollWheelState({
    String? selectedHour,
    String? selectedMinute,
    String? period,
    DateTime? selectedDate,
  })  : selectedHour =
            selectedHour ?? DateTime.now().hour.toString().padLeft(2, '0'),
        selectedMinute =
            selectedMinute ?? DateTime.now().minute.toString().padLeft(2, '0'),
        period = period ?? 'AM',
        selectedDate = selectedDate ?? DateTime.now();

  final String selectedHour;
  final String selectedMinute;
  final String period;
  final DateTime selectedDate;

  TimeScrollWheelState copyWith({
    String? selectedHour,
    String? selectedMinute,
    String? period,
    DateTime? selectedDate,
  }) {
    return TimeScrollWheelState(
      selectedHour: selectedHour ?? this.selectedHour,
      selectedMinute: selectedMinute ?? this.selectedMinute,
      period: period ?? this.period,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [
        selectedHour,
        selectedMinute,
        period,
        selectedDate,
      ];
}
