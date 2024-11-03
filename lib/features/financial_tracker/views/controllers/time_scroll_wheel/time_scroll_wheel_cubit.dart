import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'time_scroll_wheel_state.dart';

class TimeScrollWheelCubit extends Cubit<TimeScrollWheelState> {
  TimeScrollWheelCubit() : super(TimeScrollWheelState());

  void setSelectedHourWheel(String selectedHour) {
    final period = int.parse(selectedHour) < 12 ? 'AM' : 'PM';
    emit(state.copyWith(
      selectedHour: selectedHour,
      period: period,
    ),);
  }

  void setSelectedMinuteWheel(String selectedMinute) {
    emit(state.copyWith(selectedMinute: selectedMinute));
  }
}
