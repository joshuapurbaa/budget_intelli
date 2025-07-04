part of 'box_calculator_cubit.dart';

sealed class BoxCalculatorState {
  const BoxCalculatorState();
}

final class BoxCalculatorInitial extends BoxCalculatorState {}

final class BoxCalculatorSelected extends BoxCalculatorState {
  BoxCalculatorSelected(
    this.value, {
    this.onUpdateFromState = true,
  });
  final String value;
  final bool onUpdateFromState;
}
