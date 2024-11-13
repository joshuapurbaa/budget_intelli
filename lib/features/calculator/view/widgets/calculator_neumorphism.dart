// import 'package:budget_intelli/core/core.dart';
// import 'package:budget_intelli/features/calculator/calculator_barrel.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// class CalculatorNeumorphism extends StatefulWidget {
//   const CalculatorNeumorphism({super.key});

//   @override
//   State<CalculatorNeumorphism> createState() => _CalculatorNeumorphismState();
// }

// class _CalculatorNeumorphismState extends State<CalculatorNeumorphism> {
//   final notifier = CalculatorNotifier();

//   @override
//   void initState() {
//     super.initState();
//     notifier.addListener(() {
//       setState(() {});
//     });
//     _setInitialValues();
//   }

//   void _setInitialValues() {
//     final amount = ControllerHelper.getAmount(context);

//     if (amount != null) {
//       final formatter = NumberFormat('#,###');
//       notifier.setInitialValues(
//         result: formatter.format(amount),
//         expression: formatter.format(amount),
//       );
//     } else {
//       notifier.setInitialValues(
//         result: '0',
//         expression: '0',
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localize = textLocalizer(context);
//     return ColoredBox(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: Padding(
//         padding: getEdgeInsetsAll(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: AppText(
//                     text: notifier.result,
//                     style: StyleType.disLg,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Padding(
//                       padding: getEdgeInsets(left: 20),
//                       child: AppText.color(
//                         text: '=',
//                         color: Theme.of(context).hintColor,
//                         style: StyleType.headMed,
//                       ),
//                     ),
//                     Gap.horizontal(10),
//                     AppText.color(
//                       text: notifier.expression,
//                       color: Theme.of(context).hintColor,
//                       style: StyleType.headMed,
//                     ),
//                   ],
//                 ),
//                 Gap.vertical(10),
//               ],
//             ),
//             Column(
//               children: [
//                 Row(
//                   children: [
//                     _buttonRounded(
//                       title: '7',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '7',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '8',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '8',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '9',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '9',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: 'x',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: 'x',
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     _buttonRounded(
//                       title: '4',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '4',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '5',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '5',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '6',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '6',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '-',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '-',
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buttonRounded(
//                       title: '1',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '1',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '2',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '2',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '3',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '3',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '+',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '+',
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buttonRounded(
//                       title: '0',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '0',
//                       ),
//                     ),
//                     _buttonRounded(
//                       title: '00',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '00',
//                       ),
//                     ),
//                     _buttonRounded(
//                       icon: Icons.backspace_outlined,
//                       onTap: () {
//                         if (notifier.expression.isNotEmpty) {
//                           notifier.startCalculator(
//                             context: context,
//                             buttonText: 'Del',
//                           );
//                         }
//                       },
//                     ),
//                     _buttonRounded(
//                       title: '/',
//                       onTap: () => notifier.startCalculator(
//                         context: context,
//                         buttonText: '/',
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     _buttonRounded(
//                       title: localize.save,
//                       flex: 2,
//                       onTap: () {
//                         notifier.startCalculator(
//                           context: context,
//                           buttonText: '=',
//                         );
//                         context.pop(
//                           notifier.result,
//                         );
//                       },
//                     ),
//                     _buttonRounded(
//                       title: '=',
//                       flex: 1,
//                       onTap: () {
//                         notifier.startCalculator(
//                           context: context,
//                           buttonText: '=',
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buttonRounded({
//     required VoidCallback onTap,
//     String? title,
//     IconData? icon,
//     int? flex,
//   }) {
//     return Flexible(
//       flex: flex ?? 1,
//       child: GestureDetector(
//         onTap: onTap,
//         child: NeuContainer(
//           padding: getEdgeInsetsAll(16),
//           margin: getEdgeInsetsAll(4),
//           child: Center(
//             child: title != null
//                 ? AppText.color(
//                     text: title,
//                     color: context.color.secondaryContainer,
//                     style: StyleType.headMed,
//                   )
//                 : Icon(
//                     icon,
//                     size: 30,
//                     color: context.color.secondaryContainer,
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
