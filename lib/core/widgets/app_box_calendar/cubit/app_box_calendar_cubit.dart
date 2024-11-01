import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_box_calendar_state.dart';

class AppBoxCalendarCubit extends Cubit<AppBoxCalendarState> {
  AppBoxCalendarCubit() : super(AppBoxCalendarInitial());

  void selectDate(DateTime selectedDate) {
    emit(AppBoxCalendarSelected(selectedDate));
  }

  void clearDate() {
    emit(AppBoxCalendarInitial());
  }
}
