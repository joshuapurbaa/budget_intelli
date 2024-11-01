import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/calculator/calculator_barrel.dart';
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
            label = value;
            context.read<BoxCalculatorCubit>().select(value);
          }
        });
      },
      child: BlocBuilder<BoxCalculatorCubit, BoxCalculatorState>(
        builder: (context, state) {
          if (state is BoxCalculatorSelected) {
            label = NumberFormatter.formatStringToMoney(context, state.value);
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

  AppText _label(String label, BuildContext context) {
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
      return AppText(
        text: label,
        fontWeight: FontWeight.w700,
        style: StyleType.bodMd,
        color: colorScheme.onSurface,
      );
    }
  }
}
