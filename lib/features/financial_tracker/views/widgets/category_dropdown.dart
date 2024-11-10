import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({super.key});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  @override
  void initState() {
    super.initState();
    context.read<FinancialCategoryBloc>().add(
          const GetAllFinancialCategoryEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinancialCategoryBloc, FinancialCategoryState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: context.color.onInverseSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownMenu<FinancialCategory>(
            expandedInsets: const EdgeInsets.all(8),
            menuHeight: 150.h,
            selectedTrailingIcon: const Icon(
              CupertinoIcons.chevron_up,
              size: 20,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: InputBorder.none,
              hintStyle: textStyle(
                context,
                StyleType.bodMd,
              ).copyWith(
                color: context.color.primary,
              ),
            ),
            leadingIcon: Padding(
              padding: const EdgeInsets.all(8),
              child: _buildLeadingIconMenu(state.selectedFinancialCategory),
            ),
            trailingIcon: Icon(
              CupertinoIcons.chevron_down,
              size: 20,
              color: context.color.primary,
            ),
            hintText:
                state.selectedFinancialCategory?.categoryName ?? 'Category',
            textStyle: textStyle(
              context,
              StyleType.bodMd,
            ).copyWith(
              fontWeight: FontWeight.w700,
            ),
            requestFocusOnTap: false,
            onSelected: (FinancialCategory? value) {
              context.read<FinancialCategoryBloc>().add(
                    SetSelectedFinancialCategoryEvent(value),
                  );
            },
            menuStyle: MenuStyle(
              visualDensity: VisualDensity.standard,
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            dropdownMenuEntries: state.financialCategories
                .map<DropdownMenuEntry<FinancialCategory>>(
              (FinancialCategory category) {
                return DropdownMenuEntry<FinancialCategory>(
                  value: category,
                  label: _buildLabel(state.language, category.categoryName),
                  leadingIcon: _buildLeadingIconMenu(category),
                  style: MenuItemButton.styleFrom(
                    visualDensity: VisualDensity.comfortable,
                    textStyle: textStyle(
                      context,
                      StyleType.bodMd,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  String _buildLabel(String? language, String categoryName) {
    if (language == 'English') {
      return categoryName;
    } else {
      switch (categoryName) {
        case 'Food':
          return 'Makanan';
        case 'Transport':
          return 'Transportasi';
        case 'Salary':
          return 'Gaji';
        case 'Gift':
          return 'Hadiah';
        case 'Shopping':
          return 'Belanja';
        case 'Health':
          return 'Kesehatan';
        case 'Entertainment':
          return 'Hiburan';
        case 'Investment':
          return 'Investasi';
        case 'Education':
          return 'Pendidikan';
        case 'Others':
          return 'Lainnya';
        default:
          return categoryName;
      }
    }
  }

  Widget _buildLeadingIconMenu(FinancialCategory? category) {
    final others = category?.categoryName == 'Others';
    if (category != null) {
      final icon = category.iconPath ?? categoryPng;
      if (icon.contains('.svg')) {
        return getSvgAsset(
          icon,
          width: 20,
          height: 20,
          color: others ? context.color.primary : null,
        );
      } else {
        return getPngAsset(
          icon,
          width: 20,
          height: 20,
        );
      }
    } else {
      return getPngAsset(
        categoryPng,
        width: 20,
        height: 20,
        color: context.color.primary,
      );
    }
  }
}
