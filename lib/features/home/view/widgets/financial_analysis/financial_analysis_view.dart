import 'package:flutter/material.dart';

class FinancialAnalysisView extends StatefulWidget {
  const FinancialAnalysisView({
    required this.budgetId,
    super.key,
  });

  final String budgetId;

  @override
  State<FinancialAnalysisView> createState() => _FinancialAnalysisViewState();
}

class _FinancialAnalysisViewState extends State<FinancialAnalysisView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
