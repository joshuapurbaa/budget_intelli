import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
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
  Future<void> _initFinancialCategoryInstance() async {
    final language = await SettingPreferenceRepo().getLanguage();
    List<FinancialCategory>? financialCategory;
    if (language == 'English') {
      financialCategory = financialCategoryHardcodedEN;
    } else {
      financialCategory = financialCategoryHardcodedID;
    }

    _setFinancialCategoryDb(financialCategory);
  }

  void _setFinancialCategoryDb(List<FinancialCategory> financialCategory) {
    for (final category in financialCategory) {
      if (!mounted) return;
      context.read<FinancialCategoryBloc>().add(
            InsertFinancialCategoryEvent(category),
          );
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<FinancialCategoryBloc>().add(
          const GetAllFinancialCategoryEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FinancialCategoryBloc, FinancialCategoryState>(
      listener: (context, state) {
        if (state.financialCategories.isEmpty) {
          _initFinancialCategoryInstance();
        }
      },
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
                  label: category.categoryName,
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

  Widget _buildLeadingIconMenu(FinancialCategory? category) {
    if (category != null) {
      final icon = category.iconPath ?? categoryPng;
      if (icon.contains('.svg')) {
        return getSvgAsset(
          icon,
          width: 20,
          height: 20,
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
