import 'dart:io';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({
    required this.updateInfo,
    super.key,
    this.canDismiss = true,
  });
  final AppUpdateInfo updateInfo;
  final bool canDismiss;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return BlocListener<AppUpdateCubit, AppUpdateState>(
      listener: (context, state) {
        if (state is AppUpdateError) {
          AppToast.showToastError(context, state.message);
        } else if (state is AppUpdateDownloaded) {
          _showInstallDialog(context);
        } else if (state is AppUpdateCompleted) {
          Navigator.of(context).pop();
        }
      },
      child: AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.system_update,
              color: context.color.primary,
            ),
            Gap.horizontal(8),
            AppText(
              text: localize.updateAvailable,
              style: StyleType.headSm,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: localize.newVersionAvailable,
              style: StyleType.bodMed,
            ),
            Gap.vertical(8),
            if (updateInfo.currentVersion != null) ...[
              AppText(
                text:
                    '${localize.currentVersion}: ${updateInfo.currentVersion}',
                style: StyleType.bodSm,
                color: context.color.onSurfaceVariant,
              ),
              Gap.vertical(4),
            ],
            if (updateInfo.availableVersion != null) ...[
              AppText(
                text: '${localize.newVersion}: ${updateInfo.availableVersion}',
                style: StyleType.bodSm,
                color: context.color.primary,
              ),
              Gap.vertical(16),
            ],
            AppText(
              text: localize.updateRecommendation,
              style: StyleType.bodSm,
              color: context.color.onSurfaceVariant,
            ),
          ],
        ),
        actions: [
          if (canDismiss) ...[
            TextButton(
              onPressed: () {
                context.read<AppUpdateCubit>().dismissUpdate();
                Navigator.of(context).pop();
              },
              child: AppText(
                text: localize.later,
                style: StyleType.bodMed,
              ),
            ),
          ],
          BlocBuilder<AppUpdateCubit, AppUpdateState>(
            builder: (context, state) {
              final isLoading = state is AppUpdateDownloading;

              return ElevatedButton(
                onPressed: isLoading ? null : () => _handleUpdate(context),
                child: isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.color.onPrimary,
                          ),
                        ),
                      )
                    : AppText(
                        text: localize.updateNow,
                        style: StyleType.bodMed,
                        color: context.color.onPrimary,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleUpdate(BuildContext context) {
    if (Platform.isAndroid) {
      // Use flexible update for Android if available
      if (updateInfo.isFlexibleUpdateAllowed) {
        context.read<AppUpdateCubit>().startFlexibleUpdate();
      } else if (updateInfo.isImmediateUpdateAllowed) {
        context.read<AppUpdateCubit>().startImmediateUpdate();
      } else {
        // Fallback to Play Store
        context.read<AppUpdateCubit>().openAppStore();
        Navigator.of(context).pop();
      }
    } else {
      // For iOS, open App Store
      context.read<AppUpdateCubit>().openAppStore();
      Navigator.of(context).pop();
    }
  }

  void _showInstallDialog(BuildContext context) {
    final localize = textLocalizer(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.download_done,
              color: context.color.primary,
            ),
            Gap.horizontal(8),
            AppText(
              text: localize.updateDownloaded,
              style: StyleType.headSm,
            ),
          ],
        ),
        content: AppText(
          text: localize.restartToComplete,
          style: StyleType.bodMed,
        ),
        actions: [
          BlocBuilder<AppUpdateCubit, AppUpdateState>(
            builder: (context, state) {
              final isInstalling = state is AppUpdateInstalling;

              return ElevatedButton(
                onPressed: isInstalling
                    ? null
                    : () =>
                        context.read<AppUpdateCubit>().completeFlexibleUpdate(),
                child: isInstalling
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            context.color.onPrimary,
                          ),
                        ),
                      )
                    : AppText(
                        text: localize.restartNow,
                        style: StyleType.bodMed,
                        color: context.color.onPrimary,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Show update dialog
  static Future<void> show(
    BuildContext context,
    AppUpdateInfo updateInfo, {
    bool canDismiss = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: canDismiss,
      builder: (context) => AppUpdateDialog(
        updateInfo: updateInfo,
        canDismiss: canDismiss,
      ),
    );
  }
}
