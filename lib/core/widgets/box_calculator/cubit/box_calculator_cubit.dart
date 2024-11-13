import 'package:flutter_bloc/flutter_bloc.dart';

part 'box_calculator_state.dart';

class BoxCalculatorCubit extends Cubit<BoxCalculatorState> {
  BoxCalculatorCubit() : super(BoxCalculatorInitial());

  void select(String value) {
    print('select $value');
    emit(BoxCalculatorSelected(value));
  }

  void unselect() {
    emit(BoxCalculatorInitial());
  }
}
