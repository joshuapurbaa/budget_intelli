import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:flutter/material.dart';

class PortfolioItem extends StatelessWidget {
  const PortfolioItem({
    required this.onTap,
    required this.myPortfolio,
    super.key,
  });

  final VoidCallback onTap;
  final MyPortfolioModel myPortfolio;

  @override
  Widget build(BuildContext context) {
    String? updatedAtStr;
    final investedStr = myPortfolio.buyPrice * (myPortfolio.lot * 100);

    final updatedAt = DateTime.tryParse(myPortfolio.updatedAt);

    if (updatedAt != null) {
      final now = DateTime.now();
      final difference = now.difference(updatedAt);

      if (difference.inMinutes < 1) {
        updatedAtStr = 'Updated just now';
      } else if (difference.inMinutes < 60) {
        updatedAtStr = 'Updated ${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        updatedAtStr = 'Updated ${difference.inHours} hours ago';
      } else {
        updatedAtStr = 'Updated ${difference.inDays} days ago';
      }
    } else {
      updatedAtStr = 'Update time not available';
    }

    return AppGlass(
      onTap: onTap,
      margin: getEdgeInsetsSymmetric(horizontal: 16, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: myPortfolio.stockSymbol,
                style: StyleType.bodLg,
              ),
              AppText.light14(
                text: updatedAtStr,
                textAlign: TextAlign.end,
              ),
            ],
          ),
          Gap.vertical(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.bold14(
                text: NumberFormatter.formatToMoneyDouble(
                  context,
                  investedStr,
                  decimalDigits: 0,
                ),
              ),
              const AppText.light14(
                text: '+Rp 100,000',
                color: Colors.green,
              ),
            ],
          ),
          Gap.vertical(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.light14(
                text: '${myPortfolio.lot} lot',
              ),
              const AppText.light14(
                text: '10%',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
