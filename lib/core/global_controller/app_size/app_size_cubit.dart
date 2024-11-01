import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_size_state.dart';

class AppSizeCubit extends Cubit<AppSizeState> {
  AppSizeCubit() : super(const AppSizeState());

  void setSize(Size? size) {
    emit(state.copyWith(size: size));
  }
}
