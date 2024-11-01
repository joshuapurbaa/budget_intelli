import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

const String _error = 'Syntax Error';

class CalculatorNotifier extends ChangeNotifier {
  String _result = ' ';
  String _expression = '';

  void setInitialValues({
    required String result,
    required String expression,
  }) {
    _result = _formatOutput(result);
    _expression = expression;
    notifyListeners();
  }

  String get result => _result;

  String get expression => _getExpression();

  void updateDisplayValues({
    required String result,
    required String expression,
    required String date,
  }) {
    _result = _formatOutput(result);
    _expression = expression;
    _clearExpression();
    notifyListeners();
  }

  void startCalculator({
    required BuildContext context,
    required String buttonText,
  }) {
    if (buttonText == 'AC') {
      _clearInput();
    } else if (buttonText == 'Del') {
      _deleteLast();
    } else if (buttonText == '=') {
      final result = _getResult();
      updateDisplayValues(
        result: result,
        expression: _expression,
        date: DateTime.now().toString(),
      );
    } else {
      _getButtonText(buttonText);
    }
    notifyListeners();
  }

  void _getButtonText(String buttonValue) {
    if (expression.startsWith('0') && buttonValue == '0') {
      _expression = '0';
      return;
    }

    final regExp1 = RegExp(r'[.÷×+]$');
    if (expression == '0' && regExp1.hasMatch(buttonValue)) {
      _expression = '0$buttonValue';
      return;
    }

    if (regExp1.hasMatch(expression) && regExp1.hasMatch(buttonValue)) {
      _deleteLast(calculate: false);
    }

    final regExp2 = RegExp(r'\.((\d+)|[÷×+-])?$');
    if (regExp2.hasMatch(expression) && buttonValue == '.') {
      return;
    }

    final regExp3 = RegExp(r'[÷×+]$');
    if (expression.endsWith('-') && regExp3.hasMatch(buttonValue)) {
      return;
    }

    if (expression.endsWith('-') && buttonValue == '-') {
      return;
    }

    if (_frequency('(') <= _frequency(')') && buttonValue == ')') {
      return;
    }

    final regExp4 = RegExp(r'0\d');

    if (expression.startsWith('0') && regExp4.hasMatch(expression)) {
      _expression = buttonValue;
    } else {
      if (expression.startsWith('0')) {
        _expression = buttonValue;
      } else {
        _expression += buttonValue;
      }
    }

    _result = _formatOutput(_getResult());
  }

  String _getExpression() {
    final exp = _formatOutput(_expression);
    return (exp.isEmpty) ? '0' : exp;
  }

  void _clearInput() {
    _result = ' ';
    _expression = '';
  }

  void _clearExpression() {
    _expression = _result;
  }

  void resetCalculator() {
    _clearInput();
    notifyListeners();
  }

  void _deleteLast({bool calculate = true}) {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      if (_expression.isEmpty) {
        _clearInput();
      }
      if (calculate) {
        _result = _formatOutput(_getResult());
      }
    }
  }

  String _getResult({bool showError = false}) {
    var placeholder = _expression.replaceAll(',', '');
    placeholder = placeholder.replaceAll('x', '*');
    placeholder = placeholder.replaceAll('÷', '/');

    final regExp = RegExp(r'\d+\(');
    if (regExp.hasMatch(placeholder)) {
      placeholder = placeholder.replaceAllMapped(regExp, (match) {
        final value = placeholder.substring(match.start, match.end);
        return value.replaceAll('(', '*(');
      });
    }

    try {
      final exp = Parser().parse(placeholder);
      final context = ContextModel();
      final answer = exp.evaluate(EvaluationType.REAL, context) as double;
      final length = _getDecimalLength(answer);
      return _formatOutput(answer.toStringAsFixed(length));
    } catch (e) {
      return showError ? _error : result;
    }
  }

  int _getDecimalLength(double value) {
    final text = value.toString();
    if (!text.endsWith('.0')) {
      final startIndex = text.indexOf('.') + 1;
      final endIndex = text.length;
      final decimal = text.substring(startIndex, endIndex);
      return decimal.length;
    } else {
      return 0;
    }
  }

  int _frequency(String value) {
    return expression.split(value).length - 1;
  }

  String _formatOutput(String text) {
    final regExp1 = RegExp(r'\d+');
    final first = text.replaceAllMapped(regExp1, (match) {
      final value = text.substring(match.start, match.end);
      return _commaSeparator(value);
    });

    final regExp2 = RegExp(r'\.(\d{1,3},)+(\d+)?');
    final last = first.replaceAllMapped(regExp2, (match) {
      final value = first.substring(match.start, match.end);
      return value.replaceAll(',', '');
    });

    return last;
  }

  String _commaSeparator(String text) {
    final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return text.replaceAllMapped(regExp, (match) {
      return '${match.group(0)},';
    });
  }
}
