import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/budget/budget_barrel.dart';
import 'package:budget_intelli/features/category/category_barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';
import 'package:go_router/go_router.dart';

class UpdateGroupCategoryContent extends StatefulWidget {
  const UpdateGroupCategoryContent({
    required this.indexGroup,
    required this.groupCategoryHistories,
    super.key,
    this.groupCategoryHistory,
  });

  final int indexGroup;
  final GroupCategoryHistory? groupCategoryHistory;
  final List<GroupCategoryHistory> groupCategoryHistories;

  @override
  State<UpdateGroupCategoryContent> createState() =>
      _UpdateGroupCategoryContentState();
}

class _UpdateGroupCategoryContentState
    extends State<UpdateGroupCategoryContent> {
  final _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getGroupCategories();
    if (widget.groupCategoryHistory != null) {
      _groupNameController.text = widget.groupCategoryHistory!.groupName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final indexGroup = widget.indexGroup;
    // final groupCategories = context.read<CategoryCubit>().state.groupCategories;
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final groupCategories = state.groupCategories;
        final searchResultGroupCategory = state.searchResultGroupCategory;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _groupNameController,
                    onChanged: (value) {
                      context.read<CategoryCubit>().searchGroupCategoryByName(
                            name: value,
                            groupCategories: groupCategories,
                          );

                      if (widget.groupCategoryHistory != null) {
                        context.read<CategoryCubit>().getItemCategoryArgs(
                              groupCategoryHistory:
                                  widget.groupCategoryHistory!.copyWith(
                                groupName: value,
                              ),
                            );
                      }
                    },
                    style: textStyle(
                      context,
                      style: StyleType.bodMed,
                    ),
                    decoration: InputDecoration(
                      hintText: textLocalizer(context).categoryName,
                      hintStyle: textStyle(
                        context,
                        style: StyleType.bodMed,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _onPaintBrushTap(indexGroup);
                  },
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: state.currentColor[indexGroup],
                    child: Icon(
                      CupertinoIcons.paintbrush,
                      color: context.color.onSurface,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            Gap.vertical(10),
            Column(
              children: List.generate(
                searchResultGroupCategory.length,
                (index) {
                  final groupCategory = searchResultGroupCategory[index];
                  return GestureDetector(
                    onTap: () {
                      final groupCategoryHistory = widget.groupCategoryHistories
                          .where(
                            (element) => element.groupId == groupCategory.id,
                          )
                          .firstOrNull;

                      if (groupCategoryHistory != null) {
                        AppToast.showToastError(
                          context,
                          'Cannot update with the same category name',
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text: groupCategory.groupName,
                            style: StyleType.bodMed,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _changeColor(Color color, int index) {
    context.read<CategoryCubit>().getItemCategoryArgs(
          pickerColor:
              List.from(context.read<CategoryCubit>().state.pickerColor)
                ..[index] = color,
        );
  }

  void _onPaintBrushTap(int index) {
    final localize = textLocalizer(context);
    AppDialog.showCustomDialog(
      context,
      title: AppText(
        text: localize.pickAColor,
        style: StyleType.headMed,
      ),
      content: MaterialPicker(
        pickerColor: context.read<CategoryCubit>().state.pickerColor[index],
        onColorChanged: (color) {
          _changeColor(color, index);
        },
      ),
      actions: <Widget>[
        AppButton(
          label: localize.save,
          onPressed: () {
            final categoryState = context.read<CategoryCubit>().state;
            final color =
                categoryState.pickerColor[index].toARGB32().toRadixString(16);
            final hexColor = int.parse(color, radix: 16);

            context.read<CategoryCubit>().getItemCategoryArgs(
                  groupCategoryHistory:
                      categoryState.groupCategoryHistory!.copyWith(
                    hexColor: hexColor,
                  ),
                  currentColor: List.from(categoryState.currentColor)
                    ..[index] = Color(hexColor),
                );

            context.pop();
          },
        ),
      ],
    );
  }
}
