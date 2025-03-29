import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppFieldCalculator extends StatefulWidget {
  const AppFieldCalculator({
    required this.label,
    super.key,
    this.focusNode,
    this.isIcome = false,
  });

  final String label;
  final FocusNode? focusNode;
  final bool isIcome;

  @override
  State<AppFieldCalculator> createState() => _AppFieldCalculatorState();
}

class _AppFieldCalculatorState extends State<AppFieldCalculator>
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
            label = NumberFormatter.formatStringToMoney(context, state.value);
          } else {
            label = widget.label;
          }
          return Row(
            children: [
              // if (widget.isIcome)
              //   getPngAsset(
              //     incomePng,
              //   ),
              // if (!widget.isIcome)
              //   getPngAsset(
              //     calculator,
              //   ),
              Gap.horizontal(5),
              _label(
                label,
                context,
              ),
            ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final currency = context.watch<SettingBloc>().state.currency;

    if (label.contains(localize.amountFieldLabel) ||
        label.contains(localize.totalAmountFieldLabel) ||
        label.contains(localize.budget) ||
        label.contains(localize.value)) {
      return AppText(
        text: '$label*',
        color: context.color.onSurface.withOpacity(0.5),
        fontWeight: FontWeight.w400,
        style: StyleType.bodMd,
      );
    } else {
      String? amount;
      if (label.isNotEmpty) {
        amount = label;
      } else {
        amount = widget.label;
      }
      return AppText(
        text: '${currency.symbol} $amount',
        fontWeight: FontWeight.w700,
        style: StyleType.bodMd,
        color: colorScheme.onSurface,
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
      });
    }
  }
}
