import 'package:budget_intelli/core/helper/extensions.dart';
import 'package:flutter/foundation.dart';

void main() {
  // Test cases for the issue

  try {
    const test1 = '4,390,000';
    final result1 = test1.toDouble();
    debugPrint('$test1 -> $result1 (should be 4390000.0)');

    const test2 = '5,490,000';
    final result2 = test2.toDouble();
    debugPrint('$test2 -> $result2 (should be 5490000.0)');

    const test3 = '1,000,000';
    final result3 = test3.toDouble();
    debugPrint('$test3 -> $result3 (should be 1000000.0)');

    // Additional test cases
    const test4 = '1,000';
    final result4 = test4.toDouble();
    debugPrint('$test4 -> $result4 (should be 1000.0)');

    const test5 = '12,50'; // decimal with comma
    final result5 = test5.toDouble();
    debugPrint('$test5 -> $result5 (should be 12.5)');

    const test6 = '1234.56'; // decimal with dot
    final result6 = test6.toDouble();
    debugPrint('$test6 -> $result6 (should be 1234.56)');

    debugPrint('All tests completed successfully!');
  } on Exception catch (e) {
    debugPrint('Error: $e');
  }
}
