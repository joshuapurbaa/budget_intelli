part of 'financial_calculator_cubit.dart';

final class FinancialCalculatorState {
  const FinancialCalculatorState({
    this.amountDisplay = '0.0',
    this.firstOperand = '',
    this.secondOperand = '',
    this.operator = '',
    this.expression = '',
  });

  final String amountDisplay;
  final String expression;
  final String firstOperand;
  final String secondOperand;
  final String operator;

  FinancialCalculatorState copyWith({
    String? amountDisplay,
    String? firstOperand,
    String? secondOperand,
    String? operator,
    String? expression,
  }) {
    return FinancialCalculatorState(
      amountDisplay: amountDisplay ?? this.amountDisplay,
      firstOperand: firstOperand ?? this.firstOperand,
      secondOperand: secondOperand ?? this.secondOperand,
      operator: operator ?? this.operator,
      expression: expression ?? this.expression,
    );
  }
}
