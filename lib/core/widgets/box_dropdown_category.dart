import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BoxDropdownCategory extends StatefulWidget {
  const BoxDropdownCategory({
    required this.categoriesType,
    super.key,
  });

  final CategoriesType categoriesType;

  @override
  State<BoxDropdownCategory> createState() => _BoxDropdownCategoryState();
}

class _BoxDropdownCategoryState extends State<BoxDropdownCategory> {
  ListMap listCategory = [];
  final _dropDowonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listCategory = listCategories(
      categoriesType: widget.categoriesType,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return AppBoxChild(
      padding: getEdgeInsets(
        left: 16,
        right: 8,
        top: 16,
        bottom: 16,
      ),
      boxShadow: appBoxShadows(context),
      border: appBorder(context),
      child: BlocBuilder<BoxCategoryCubit, BoxCategoryState>(
        builder: (context, state) {
          final isSelected = state is HasDataSelected;
          if (!isSelected) {
            _dropDowonController.text = '${localize.categoryFieldLabel}*';
          }
          return DropdownMenu<MapStringDynamic>(
            controller: _dropDowonController,
            expandedInsets: EdgeInsets.zero,
            menuHeight: 150.h,
            selectedTrailingIcon: const _SelectedTrailingWidget(),
            leadingIcon: const _LeadingWidget(),
            inputDecorationTheme: _inputDecoration(
              context,
              isSelected: isSelected,
            ),
            trailingIcon: const _TrailingWidget(),
            hintText: _getHintText(context),
            textStyle: _dropdownHintTextStyle(
              context,
              isSelected: isSelected,
            ),
            requestFocusOnTap: false,
            onSelected: (Map<String, dynamic>? account) {
              context.read<BoxCategoryCubit>().setCategory(
                    category: account!['name'] as String,
                  );
            },
            menuStyle: _menuStyle(),
            dropdownMenuEntries: listCategory
                .map<DropdownMenuEntry<MapStringDynamic>>(
                    (MapStringDynamic category) {
              return DropdownMenuEntry<MapStringDynamic>(
                leadingIcon: getSvgAsset(
                  category['icon'] as String,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                value: category,
                label: category['name'] as String,
                style: MenuItemButton.styleFrom(
                  visualDensity: VisualDensity.comfortable,
                  textStyle: textStyle(
                    context,
                    StyleType.bodMd,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  InputDecorationTheme _inputDecoration(
    BuildContext context, {
    bool isSelected = false,
  }) {
    return InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: textStyle(
        context,
        StyleType.bodMd,
      ).copyWith(
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
        color:
            isSelected ? null : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  MenuStyle _menuStyle() {
    return MenuStyle(
      visualDensity: VisualDensity.standard,
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  String _getHintText(BuildContext context, {bool isSelected = false}) {
    final localize = textLocalizer(context);
    if (isSelected) {
      return '';
    } else {
      return '${localize.categoryFieldLabel}*';
    }
  }

  TextStyle _dropdownHintTextStyle(
    BuildContext context, {
    bool isSelected = false,
  }) {
    return textStyle(
      context,
      StyleType.bodMd,
    ).copyWith(
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
      color: isSelected ? null : Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}

class _TrailingWidget extends StatelessWidget {
  const _TrailingWidget();

  @override
  Widget build(BuildContext context) {
    return getSvgAsset(
      chevronRight,
      width: 18,
      height: 18,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }
}

class _LeadingWidget extends StatelessWidget {
  const _LeadingWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getEdgeInsets(right: 20),
      child: getSvgAsset(
        menuCategory,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _SelectedTrailingWidget extends StatelessWidget {
  const _SelectedTrailingWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // IconButton(
        //   onPressed: () {
        //     context.read<CreateBalanceAccountCubit>().setToInitial();
        //     context.read<BoxCategoryAccountCubit>().setToInitial();
        //     context.push(RouteName.addBalanceAccount);
        //   },
        //   icon: const Icon(
        //     Icons.add,
        //     size: 30,
        //   ),
        // ),
        // Gap.horizontal(16),
        getSvgAsset(
          chevronDown,
          width: 18,
          height: 18,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ],
    );
  }
}
