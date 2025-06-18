import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AppBoxCalculator extends StatefulWidget {
  const AppBoxCalculator({
    required this.label,
    required this.onValueSelected,
    super.key,
    this.focusNode,
    this.isIcome = false,
  });

  final String label;
  final FocusNode? focusNode;
  final bool isIcome;
  final void Function(String) onValueSelected;

  @override
  State<AppBoxCalculator> createState() => _AppBoxCalculatorState();
}

class _AppBoxCalculatorState extends State<AppBoxCalculator>
    with TickerProviderStateMixin {
  String label = '';

  @override
  void initState() {
    super.initState();
    label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.focusNode != null) {
          widget.focusNode!.unfocus();
        }

        _showCalculator();
      },
      child: AppGlass(
        child: Row(
          children: [
            if (widget.isIcome)
              getPngAsset(
                incomePng,
              ),
            if (!widget.isIcome)
              getPngAsset(
                calculator,
              ),
            Gap.horizontal(16),
            _label(
              label,
              context,
            ),
          ],
        ),
      ),
    );
  }

  AppText _label(
    String label,
    BuildContext context, {
    bool onUpdateFromState = false,
  }) {
    final localize = textLocalizer(context);
    final colorScheme = context.color;
    final currency = context.watch<SettingBloc>().state.currency;

    if (label.contains(localize.amountFieldLabel) ||
        label.contains(localize.totalAmountFieldLabel) ||
        label.contains(localize.budget) ||
        label.contains(localize.startingBalance)) {
      return AppText(
        text: label,
        color: context.color.onSurface.withValues(alpha: 0.5),
        fontWeight: FontWeight.w400,
        style: StyleType.bodMed,
      );
    } else {
      String? amount;
      final isUpdate = onUpdateFromState;
      if (label.isNotEmpty) {
        amount = label;

        if (isUpdate) {
          final formatter = NumberFormat.currency(
            locale: currency.locale,
            symbol: '${currency.symbol} ',
            decimalDigits: 0,
          );

          amount = formatter.format(double.tryParse(amount) ?? 0);
        }

        return AppText(
          text: isUpdate ? amount : '${currency.symbol} $amount',
          fontWeight: FontWeight.w700,
          style: StyleType.bodMed,
          color: colorScheme.onSurface,
        );
      } else {
        amount = widget.label;

        return AppText(
          text: '${currency.symbol} $amount',
          fontWeight: FontWeight.w700,
          style: StyleType.bodMed,
          color: colorScheme.onSurface,
        );
      }
    }
  }

  Future<void> _showCalculator() async {
    final result = await showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
      builder: (context) {
        return const AppCalculatorBottomSheet();
      },
    );

    if (result != null && result.isNotEmpty && result != ' ') {
      setState(() {
        label = result;
        widget.onValueSelected.call(result);
      });
    }
  }
}
