import 'dart:typed_data';
import 'dart:ui';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDialog {
  static Future<void> showCustomDialog(
    BuildContext context, {
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    bool? barrierDismissible,
    EdgeInsetsGeometry? contentPadding,
    bool blurBackground = true,
  }) async {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SafeArea(
          child: Center(
            child: Material(
              type: MaterialType.card,
              elevation: 24,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 32,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                padding: contentPadding ?? getEdgeInsetsAll(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (title != null) ...[
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.headlineSmall!,
                        child: title,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (content != null)
                      Flexible(
                        child: content,
                      ),
                    if (actions != null && actions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: actions.map((action) {
                          return Expanded(child: action);
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: blurBackground
          ? (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5 * animation.value,
                  sigmaY: 5 * animation.value,
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            }
          : null,
    );
  }

  static Future<void> showLoading(
    BuildContext context, {
    String? message,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return ColoredBox(
          color: colorScheme.surface.withValues(alpha: 0.2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: message ?? textLocalizer(context).pleaseWait,
                    style: StyleType.bodMed,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) async {
    final localize = textLocalizer(context);
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppText(
            text: title,
            style: StyleType.headMed,
          ),
          backgroundColor: colorScheme.surface,
          actions: [
            TextButton(
              onPressed: onConfirm,
              child: AppText.color(
                text: localize.yes,
                color: colorScheme.error,
                style: StyleType.headMed,
              ),
            ),
            TextButton(
              onPressed: onCancel,
              child: AppText.color(
                text: localize.no,
                color: colorScheme.primary,
                style: StyleType.headMed,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showConfirmationDelete(
    BuildContext context,
    String title,
    String textContent,
  ) async {
    final localize = textLocalizer(context);
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppText(
            text: title,
            style: StyleType.headMed,
          ),
          content: AppText(
            text: textContent,
            style: StyleType.bodMed,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: AppText(
                text: localize.cencel,
                style: StyleType.bodMed,
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop(true);
              },
              child: AppText(
                text: localize.delete,
                style: StyleType.bodMed,
                color: context.color.error,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showImageDialog(
    BuildContext context, {
    String? imageUrl,
    Uint8List? imageBytes,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: imageUrl != null
              ? Image.network(imageUrl)
              : Image.memory(imageBytes!),
        );
      },
    );
  }

  static Future<Object?> showAnimationDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (
        BuildContext buildContext,
        animation,
        secondaryAnimation,
      ) {
        return Center(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(),
            content: SizedBox(
              // height: 200,
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
            insetPadding: EdgeInsets.zero,
          ),
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }
}
