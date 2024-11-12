import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/calculator/calculator_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AppCalculatorButtons extends StatelessWidget {
  const AppCalculatorButtons({
    required this.notifier,
    super.key,
  });

  final CalculatorNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 5,
      crossAxisSpacing: 4,
      children: [
        _Button(
          text: '1',
          notifier: notifier,
          buttonText: '1',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '2',
          notifier: notifier,
          buttonText: '2',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '3',
          notifier: notifier,
          buttonText: '3',
          crossAxisCellCount: 1,
        ),
        _Button(
          widget: getPngAsset(
            divideIconPng,
            width: 30,
            height: 30,
            color: context.color.onSurface,
          ),
          notifier: notifier,
          buttonText: '/',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '4',
          notifier: notifier,
          buttonText: '4',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '5',
          notifier: notifier,
          buttonText: '5',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '6',
          notifier: notifier,
          buttonText: '6',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: 'x',
          notifier: notifier,
          buttonText: 'x',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '7',
          notifier: notifier,
          buttonText: '7',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '8',
          notifier: notifier,
          buttonText: '8',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '9',
          notifier: notifier,
          buttonText: '9',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '+',
          notifier: notifier,
          buttonText: '+',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '0',
          notifier: notifier,
          buttonText: '0',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '00',
          notifier: notifier,
          buttonText: '00',
          crossAxisCellCount: 1,
        ),
        _Button(
          widget: Icon(
            Icons.backspace_outlined,
            color: context.color.error,
          ),
          notifier: notifier,
          buttonText: 'Del',
          crossAxisCellCount: 1,
        ),
        _Button(
          text: '-',
          notifier: notifier,
          buttonText: '-',
          crossAxisCellCount: 1,
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.notifier,
    required this.buttonText,
    required this.crossAxisCellCount,
    this.text,
    this.widget,
  });

  final String? text;
  final String buttonText;
  final CalculatorNotifier notifier;
  final int crossAxisCellCount;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    final isNumber = RegExp(r'^[0-9]+$').hasMatch(buttonText);
    return StaggeredGridTile.extent(
      crossAxisCellCount: crossAxisCellCount,
      mainAxisExtent: 75,
      child: GestureDetector(
        onTap: buttonText == 'Del'
            ? () {
                if (notifier.expression.isNotEmpty) {
                  notifier.startCalculator(
                    context: context,
                    buttonText: 'Del',
                  );
                }
              }
            : () => notifier.startCalculator(
                  context: context,
                  buttonText: buttonText,
                ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isNumber
                ? context.color.tertiaryContainer
                : context.color.onInverseSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: widget ??
              AppText(
                text: text ?? buttonText,
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
    );
  }
}
