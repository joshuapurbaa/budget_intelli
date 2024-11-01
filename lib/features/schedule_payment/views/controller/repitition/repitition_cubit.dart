import 'package:budget_intelli/features/schedule_payment/schedule_payment_barrel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'repitition_state.dart';

class RepititionCubit extends Cubit<RepititionState> {
  RepititionCubit()
      : super(
          const RepititionState(
            repititions: [],
          ),
        );

  void getRepititions(List<Repetition> repititions) {
    emit(state.copyWith(repititions: repititions));
  }

  void updateRepitition(
    Repetition repitition,
    Timestamp dueDate,
  ) {
    final repititions = state.repititions.map((rep) {
      if (rep.dueDate == repitition.dueDate) {
        return repitition;
      }
      return rep;
    }).toList();
    emit(
      state.copyWith(
        repititions: repititions,
        dueDate: dueDate,
      ),
    );
  }
}
