import 'dart:typed_data';
import 'dart:ui';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDialog {
  static Future<dynamic> showCustomDialog(
    BuildContext context, {
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    bool? barrierDismissible,
    EdgeInsetsGeometry? contentPadding,
    bool blurBackground = true,
  }) async {
    return showGeneralDialog<dynamic>(
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
                  maxWidth: context.screenWidth - 32,
                  maxHeight: context.screenHeight * 0.8,
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
                      Gap.vertical(16),
                      const AppDivider(),
                      Gap.vertical(16),
                    ],
                    if (content != null)
                      Flexible(
                        child: content,
                      ),
                    if (actions != null && actions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: actions
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final action = entry.value;
                              return [
                                if (index > 0) Gap.horizontal(8),
                                Expanded(child: action),
                              ];
                            })
                            .expand((element) => element)
                            .toList(),
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
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
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
                padding: getEdgeInsetsAll(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.headlineSmall!,
                      child: AppText(
                        text: title,
                        style: StyleType.headMed,
                      ),
                    ),
                    Gap.vertical(16),
                    const AppDivider(),
                    Gap.vertical(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: onCancel,
                            child: AppText.color(
                              text: localize.no,
                              color: colorScheme.primary,
                              style: StyleType.headMed,
                            ),
                          ),
                        ),
                        Gap.horizontal(8),
                        Expanded(
                          child: TextButton(
                            onPressed: onConfirm,
                            child: AppText.color(
                              text: localize.yes,
                              color: colorScheme.error,
                              style: StyleType.headMed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
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
      },
    );
  }

  static Future<bool?> showConfirmationDelete(
    BuildContext context,
    String title,
    String textContent,
  ) async {
    final localize = textLocalizer(context);
    return showGeneralDialog<bool?>(
      context: context,
      barrierDismissible: true,
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
                padding: getEdgeInsetsAll(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.headlineSmall!,
                      child: AppText(
                        text: title,
                        style: StyleType.headMed,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gap.vertical(16),
                    const AppDivider(),
                    Gap.vertical(16),
                    Flexible(
                      child: AppText(
                        text: textContent,
                        style: StyleType.bodMed,
                      ),
                    ),
                    Gap.vertical(16),
                    const AppDivider(),
                    Gap.vertical(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: AppText(
                              text: localize.cencel,
                              style: StyleType.bodMed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Gap.horizontal(8),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              context.pop(true);
                            },
                            child: AppText(
                              text: localize.delete,
                              style: StyleType.bodMed,
                              color: context.color.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
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
      },
    );
  }

  static Future<void> showImageDialog(
    BuildContext context, {
    String? imageUrl,
    Uint8List? imageBytes,
  }) async {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
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
                padding: getEdgeInsetsAll(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: imageUrl != null
                          ? Image.network(imageUrl)
                          : Image.memory(imageBytes!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
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
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (
        BuildContext buildContext,
        animation,
        secondaryAnimation,
      ) {
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
                padding: getEdgeInsetsAll(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: child,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5 * animation.value,
            sigmaY: 5 * animation.value,
          ),
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
    );
  }
}
