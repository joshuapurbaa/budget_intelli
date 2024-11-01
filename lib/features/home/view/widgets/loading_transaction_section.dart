import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class LoadingTransactionSection extends StatelessWidget {
  const LoadingTransactionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: AppShimmer(
            height: 300,
            width: double.infinity,
          ),
        ),
        Gap.vertical(16),
        const AppShimmerWidget.cardSlider(
          height: 140,
          width: 140,
        ),
        Gap.vertical(16),
      ],
    );
  }
}
