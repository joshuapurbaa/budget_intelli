import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/calculator/calculator_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String label = '';

  @override
  void initState() {
    super.initState();
    label = widget.label;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.focusNode != null) {
          widget.focusNode!.unfocus();
        }

        showModalBottomSheet<String>(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          transitionAnimationController: _animationController,
          context: context,
          builder: (context) => const ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: CalculatorNeumorphism(),
          ),
        ).then((value) {
          if (value != null && value.isNotEmpty && value != ' ') {
            setState(() {
              label = value;
            });
            widget.onValueSelected.call(value);
          }
        });
      },
      child: AppGlass(
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
    BuildContext context,
  ) {
    final localize = textLocalizer(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (label.contains(localize.amountFieldLabel) ||
        label.contains(localize.totalAmountFieldLabel) ||
        label.contains(localize.budget) ||
        label.contains(localize.startingBalance)) {
      return AppText(
        text: label,
        color: context.color.onSurface.withOpacity(0.5),
        fontWeight: FontWeight.w400,
        style: StyleType.bodMd,
      );
    } else {
      String? amount;
      if (label.isNotEmpty) {
        amount = NumberFormatter.formatStringToMoney(
          context,
          label,
        );
      } else {
        amount = widget.label;
      }
      return AppText(
        text: amount,
        fontWeight: FontWeight.w700,
        style: StyleType.bodMd,
        color: colorScheme.onSurface,
      );
    }
  }
}
