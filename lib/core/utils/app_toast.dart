import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void showToast(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Toast? toastLength,
    ToastGravity? gravity,
    double? fontSize,
    int? duration,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.surface,
      textColor: textColor ?? Theme.of(context).colorScheme.onSurface,
      fontSize: fontSize ?? 16,
      timeInSecForIosWeb: duration ?? 3,
    );
  }

  static void showToastError(
    BuildContext context,
    String message, {
    Toast? toastLength,
    ToastGravity? gravity,
    double? fontSize,
    int? duration,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.error,
      textColor: Theme.of(context).colorScheme.onError,
      fontSize: fontSize ?? 16,
      timeInSecForIosWeb: duration ?? 3,
    );
  }

  static void showToastSuccess(
    BuildContext context,
    String message, {
    Toast? toastLength,
    ToastGravity? gravity,
    double? fontSize,
    int? duration,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.TOP,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
      fontSize: fontSize ?? 16,
      timeInSecForIosWeb: duration ?? 3,
    );
  }
}
