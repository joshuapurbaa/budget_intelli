import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoxCalculator extends StatefulWidget {
  const BoxCalculator({
    required this.label,
    super.key,
    this.focusNode,
    this.isIcome = false,
    this.height,
    this.onComplete,
  });

  final String label;
  final FocusNode? focusNode;
  final bool isIcome;
  final double? height;
  final void Function()? onComplete;

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
            height: widget.height,
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

    // Check if label is a placeholder text (not a number value)
    final isPlaceholder = label.contains(localize.amountFieldLabel) ||
        label.contains(localize.totalAmountFieldLabel) ||
        label.contains(localize.budget) ||
        label.contains(localize.startingBalance);

    if (isPlaceholder) {
      // Style for placeholder/label text
      return AppText(
        text: label,
        color: context.color.onSurface.withValues(alpha: 0.5),
        fontWeight: FontWeight.w400,
        style: StyleType.bodMed,
      );
    }

    // Try to parse the label as a number
    final parsedValue = double.tryParse(label.replaceAll(',', ''));

    if (parsedValue != null) {
      // Style for number values - more prominent
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
      // Style for non-number text - similar to placeholder but distinct
      return AppText(
        text: label,
        color: context.color.onSurface.withValues(alpha: 0.6),
        fontWeight: FontWeight.w500,
        style: StyleType.bodMed,
      );
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
        widget.onComplete?.call();
      });
    }
  }
}
