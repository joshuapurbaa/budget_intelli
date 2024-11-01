import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptySectionWidget extends StatelessWidget {
  const EmptySectionWidget({
    required this.label,
    super.key,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppBoxChild(
        boxShadow: appBoxShadows(context),
        border: appBorder(context),
        child: Center(
          child: Column(
            children: [
              AppText.medium16(
                text: label,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              Gap.vertical(16),
              Icon(
                Icons.add,
                size: 40.w,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
