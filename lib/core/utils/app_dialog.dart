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
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (barrierDismissible ?? true) {
                  Navigator.of(context).pop();
                }
              },
              child: ColoredBox(
                color: Colors.black.withOpacity(0.5), // warna background dengan opacity 50%
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // intensitas blur
                  child: blurBackground
                      ? ColoredBox(
                          color: Colors.black.withOpacity(
                            0,
                          ), // opacity 0 agar tidak berpengaruh terhadap warna
                        )
                      : null,
                ),
              ),
            ),
            AlertDialog(
              title: title,
              content: content,
              actions: actions,
              contentPadding: contentPadding ?? getEdgeInsetsAll(16),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoading(BuildContext context, {String? message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;
        return ColoredBox(
          color: colorScheme.surface.withOpacity(0.2),
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
                    style: StyleType.bodMd,
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
            style: StyleType.bodMd,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: AppText(
                text: localize.cencel,
                style: StyleType.bodMd,
              ),
            ),
            TextButton(
              onPressed: () {
                context.pop(true);
              },
              child: AppText(
                text: localize.delete,
                style: StyleType.bodMd,
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
          content: imageUrl != null ? Image.network(imageUrl) : Image.memory(imageBytes!),
        );
      },
    );
  }
}
