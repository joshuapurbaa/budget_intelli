import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoxCalculator extends StatefulWidget {
  const BoxCalculator({
    required this.label,
    super.key,
    this.focusNode,
    this.isIcome = false,
  });

  final String label;
  final FocusNode? focusNode;
  final bool isIcome;

  @override
  State<BoxCalculator> createState() => _BoxCalculatorState();
}

class _BoxCalculatorState extends State<BoxCalculator>
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
      child: BlocBuilder<BoxCalculatorCubit, BoxCalculatorState>(
        builder: (context, state) {
          if (state is BoxCalculatorSelected) {
            label = state.value;
          } else {
            label = widget.label;
          }
          return AppGlass(
            height: 70.h,
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
                _label(label, context),
              ],
            ),
          );
        },
      ),
    );
  }

  AppText _label(
    String label,
    BuildContext context,
  ) {
    final localize = textLocalizer(context);

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
      // Try to parse the label as a double
      final parsedValue = double.tryParse(label);
      if (parsedValue != null) {
        final currencyFormatter = NumberFormatter.formatToMoneyDouble(
          context,
          parsedValue,
        );
        return AppText(
          text: currencyFormatter,
          fontWeight: FontWeight.w700,
          style: StyleType.bodMed,
          color: context.color.onSurface,
        );
      } else {
        // If parsing fails, display the label as is
        return AppText(
          text: label,
          color: context.color.onSurface.withValues(alpha: 0.5),
          fontWeight: FontWeight.w400,
          style: StyleType.bodMed,
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
        context.read<BoxCalculatorCubit>().select(result);
      });
    }
  }
}
