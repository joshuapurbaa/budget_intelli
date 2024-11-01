import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'box_category_state.dart';

class BoxCategoryCubit extends Cubit<BoxCategoryState> {
  BoxCategoryCubit() : super(BoxCategoryInitial());

  void setToInitial() {
    emit(BoxCategoryInitial());
  }

  void setCategory({
    required String category,
  }) {
    emit(
      HasDataSelected(
        category,
      ),
    );
  }
}
