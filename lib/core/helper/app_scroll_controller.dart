import 'package:flutter/widgets.dart';

class AppScrollController {
  static void scrollToTop(BuildContext context) {
    PrimaryScrollController.of(context).animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
