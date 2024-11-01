// import 'package:budget_intelli/core/core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// class BoxCategoryDropdown extends StatefulWidget {
//   const BoxCategoryDropdown({
//     required this.categoriesType,
//     super.key,
//   });

//   final CategoriesType categoriesType;

//   @override
//   State<BoxCategoryDropdown> createState() => _BoxCategoryDropdownState();
// }

// class _BoxCategoryDropdownState extends State<BoxCategoryDropdown> {
//   GlobalKey actionKey = GlobalKey();

//   String _boxLabel(String? selectedCategory) {
//     if (selectedCategory != null) {
//       return selectedCategory;
//     }
//     return 'Select Category*';
//   }

//   @override
//   void initState() {
//     super.initState();
//     context.read<BoxCategoryCubit>().collapseDropdown(widget.categoriesType);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (FocusScope.of(context).hasFocus) {
//           FocusScope.of(context).unfocus();
//         }
//         final state = context.read<BoxCategoryCubit>().state;
//         if (state is DropdownExpanded) {
//           context
//               .read<BoxCategoryCubit>()
//               .collapseDropdown(widget.categoriesType);
//         }

//         if (state is HasInitialListCategory) {
//           context
//               .read<BoxCategoryCubit>()
//               .expandDropdown(widget.categoriesType);
//           _showPopupMenu(state.categories);
//         }
//       },
//       child: AppBoxChild(
//         height: 78.h,
//         child: BlocBuilder<BoxCategoryCubit, BoxCategoryState>(
//           builder: (context, state) {
//             final isExpanded = state is DropdownExpanded;
//             String? selectedCategory;
//             Widget label = AppText.color(
//               color: AppColor.grayscale700,
//               style: StyleType.mediumDef14,
//               text: _boxLabel(selectedCategory),
//             );

//             if (state is HasInitialListCategory) {
//               selectedCategory = state.selectedCategory;
//               if (state.selectedCategory != null) {
//                 label = AppText.bold14(
//                   text: state.selectedCategory!,
//                 );
//               }
//             }

//             return Row(
//               children: [
//                 getSvgPicture(
//                   menuCategory,
//                 ),
//                 Gap.horizontal(16),
//                 Expanded(
//                   child: label,
//                 ),
//                 Gap.horizontal(16),
//                 getSvgPicture(
//                   isExpanded ? chevronDown : chevronRight,
//                   key: actionKey,
//                   width: 18,
//                   height: 18,
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _showPopupMenu(ListMap categories) {
//     showMenu<String>(
//       context: context,
//       position: getRelativeRectPosition(context, actionKey),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16).r,
//       ),
//       popUpAnimationStyle: AnimationStyle(
//         curve: Curves.ease,
//         reverseCurve: Curves.ease,
//         duration: const Duration(milliseconds: 100),
//       ),
//       color: AppColor.dark2,
//       items: [
//         PopupMenuItem(
//           enabled: false,
//           child: AppFixedContainer(
//             width: 150.w,
//             height: 240.h,
//             padding: getEdgeInsetsAll(5),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.separated(
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       final name = categories[index]['name'] as String;
//                       final icon = categories[index]['icon'] as String;
//                       return GestureDetector(
//                         onTap: () {
//                           context.pop(name);
//                           if (FocusScope.of(context).hasFocus) {
//                             FocusScope.of(context).unfocus();
//                           }
//                         },
//                         child: Row(
//                           children: [
//                             getSvgPicture(
//                               icon,
//                               color: AppColor.white,
//                             ),
//                             Gap.horizontal(10),
//                             AppText.reg12(
//                               text: name,
//                               color: AppColor.white,
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) => const AppDivider(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ).then((value) {
//       // context.read<BoxCategoryCubit>().collapseDropdown(
//       //       widget.categoriesType,
//       //       selectedCategory: value,
//       //     );
//     });
//   }
// }
