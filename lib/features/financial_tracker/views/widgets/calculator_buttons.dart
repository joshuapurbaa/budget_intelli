import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CalculatorButtons extends StatelessWidget {
  const CalculatorButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '1');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '1',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '2');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '2',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '3');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '3',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '/');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: getPngAsset(
                divideIconPng,
                width: 30,
                height: 30,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '4');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '4',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '5');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '5',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '6');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '6',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: 'x');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: 'x',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '7');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '7',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '8');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '8',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '9');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '9',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '-');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '-',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '0');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '0',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '000');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '000',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().deleteDigit();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.error.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.backspace_outlined,
                color: context.color.error,
              ),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            onTap: () {
              context.read<FinancialCalculatorCubit>().addDigit(digit: '+');
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AppText(
                text: '+',
                style: StyleType.disMd,
                color: context.color.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
