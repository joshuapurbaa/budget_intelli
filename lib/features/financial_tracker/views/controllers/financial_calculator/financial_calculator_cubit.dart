import 'package:flutter_bloc/flutter_bloc.dart';

part 'financial_calculator_state.dart';

class FinancialCalculatorCubit extends Cubit<FinancialCalculatorState> {
  FinancialCalculatorCubit() : super(const FinancialCalculatorState());

  // Adds a digit or operator to the current expression
  void addDigit({required String digit}) {
    final amountDisplay = state.amountDisplay;
    final firstOperand = state.firstOperand;
    final secondOperand = state.secondOperand;
    final operator = state.operator;

    // If no operator is set and the digit is not an operator
    if (operator.isEmpty && !digit.contains(RegExp('[/x+-]'))) {
      if (amountDisplay == '0.0') {
        // Replace initial zero with the digit
        emit(
          state.copyWith(
            amountDisplay: digit,
            firstOperand: digit,
          ),
        );
      } else {
        // Append digit to the current first operand
        emit(
          state.copyWith(
            amountDisplay: amountDisplay + digit,
            firstOperand: firstOperand + digit,
          ),
        );
      }
    } else {
      // If an operator is set
      if (secondOperand.isEmpty) {
        if (digit.contains(RegExp('[/x+-]'))) {
          // Set the operator if the digit is an operator
          emit(
            state.copyWith(
              operator: digit,
              expression: firstOperand + digit,
            ),
          );
        } else {
          // Append digit to the second operand and calculate result

          emit(
            state.copyWith(
              secondOperand: secondOperand + digit,
              expression: firstOperand + operator + digit,
            ),
          );

          calculateResult(
            firstOperand: int.parse(firstOperand),
            secondOperand: int.parse(digit),
            operator: operator,
          );
        }
      } else {
        // Append digit to the second operand

        if (digit.contains(RegExp('[/x+-]'))) {
          // Set the operator if the digit is an operator
          emit(
            state.copyWith(
              operator: digit,
              expression: firstOperand + digit,
              secondOperand: '',
            ),
          );
        } else {
          emit(
            state.copyWith(
              amountDisplay: amountDisplay + digit,
              secondOperand: secondOperand + digit,
            ),
          );

          calculateResult(
            firstOperand: int.parse(firstOperand),
            secondOperand: int.parse(secondOperand + digit),
            operator: operator,
          );
        }
      }
    }
  }

  // Calculates the result based on the operator and operands
  void calculateResult({
    required int firstOperand,
    required int secondOperand,
    required String operator,
  }) {
    var result = 0;

    switch (operator) {
      case '+':
        result = firstOperand + secondOperand;

      case '-':
        result = firstOperand - secondOperand;

      case 'x':
        result = firstOperand * secondOperand;

      case '/':
        result = firstOperand ~/ secondOperand;
    }

    // Emit the new state with the calculated result
    emit(
      state.copyWith(
        amountDisplay: result.toString(),
        firstOperand: result.toString(),
        secondOperand: secondOperand.toString(),
        operator: operator,
        expression:
            firstOperand.toString() + operator + secondOperand.toString(),
      ),
    );
  }

  // Deletes the last digit or operator from the current expression
  void deleteDigit() {
    final amountDisplay = state.amountDisplay;
    final firstOperand = state.firstOperand;
    final secondOperand = state.secondOperand;
    final operator = state.operator;

    if (operator.isEmpty) {
      if (amountDisplay != '0.0' && firstOperand.length == 3) {
        // Reset to initial state if only one digit is left
        emit(state.copyWith(amountDisplay: '0.0'));
      } else {
        if (firstOperand == '0.0' || amountDisplay == '0.0') {
          return;
        }
        // Remove the last digit from the first operand
        emit(
          state.copyWith(
            amountDisplay: amountDisplay.substring(0, amountDisplay.length - 1),
            expression: firstOperand.substring(0, firstOperand.length - 1),
            firstOperand: firstOperand.substring(0, firstOperand.length - 1),
          ),
        );
      }
    } else {
      if (secondOperand.isEmpty) {
        if (firstOperand != '0.0' && operator.isNotEmpty) {
          // Remove the operator if no second operand is set
          emit(
            state.copyWith(
              operator: '',
              expression: firstOperand,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            secondOperand: secondOperand.substring(0, secondOperand.length - 1),
            expression: firstOperand +
                operator +
                secondOperand.substring(0, secondOperand.length - 1),
          ),
        );
      }
    }
  }
}
