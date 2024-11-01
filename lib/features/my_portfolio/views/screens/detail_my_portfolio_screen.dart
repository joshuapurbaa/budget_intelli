import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class DetailMyPortfolioScreen extends StatelessWidget {
  const DetailMyPortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarPrimary(
            title: 'Detail Portfolio',
          ),
        ],
      ),
    );
  }
}
