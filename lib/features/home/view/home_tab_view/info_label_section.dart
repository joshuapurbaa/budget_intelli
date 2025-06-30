import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class InfoLabelSection extends StatelessWidget {
  const InfoLabelSection({
    required this.label,
    required this.seeAllOnTap,
    super.key,
  });

  final String label;
  final VoidCallback seeAllOnTap;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.medium16(
          text: label,
        ),
        GestureDetector(
          onTap: seeAllOnTap,
          child: AppText.reg14(
            text: localize.seeAll,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
