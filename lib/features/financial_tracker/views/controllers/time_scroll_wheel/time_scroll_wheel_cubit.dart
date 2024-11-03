import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'time_scroll_wheel_state.dart';

class TimeScrollWheelCubit extends Cubit<TimeScrollWheelState> {
  TimeScrollWheelCubit() : super(TimeScrollWheelState());

  void setSelectedHourWheel(String selectedHour) {
    final period = int.parse(selectedHour) < 12 ? 'AM' : 'PM';
    DateTime? updatedDate;
    if (state.selectedDate != null) {
      updatedDate = DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
        int.parse(selectedHour),
        int.parse(state.selectedMinute),
      );
    }
    emit(
      state.copyWith(
        selectedHour: selectedHour,
        period: period,
        selectedDate: updatedDate,
      ),
    );
  }

  void setSelectedMinuteWheel(String selectedMinute) {
    DateTime? updatedDate;

    if (state.selectedDate != null) {
      updatedDate = DateTime(
        state.selectedDate!.year,
        state.selectedDate!.month,
        state.selectedDate!.day,
        int.parse(state.selectedHour),
        int.parse(selectedMinute),
      );
    }
    emit(state.copyWith(
      selectedMinute: selectedMinute,
      selectedDate: updatedDate,
    ));
  }

  void setSelectedDate(DateTime selectedDate) {
    emit(state.copyWith(
      selectedDate: selectedDate,
    ));
  }
}
