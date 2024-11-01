import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'spending_breakdown_state.dart';

class SpendingBreakdownCubit extends Cubit<SpendingBreakdownState> {
  SpendingBreakdownCubit() : super(SpendingBreakdownState());
}
