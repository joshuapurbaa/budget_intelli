import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinancialCalculatorScreen extends StatelessWidget {
  const FinancialCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    final marginLTR = getEdgeInsets(left: 16, top: 16, right: 16);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarPrimary(
            title: localize.financialCalculator,
          ),
          SliverList.list(
            children: [
              AppGlass(
                onTap: () {
                  context.push(MyRoute.mortgageCalculator);
                },
                margin: marginLTR,
                padding: getEdgeInsetsAll(10),
                child: Row(
                  children: [
                    getPngAsset(
                      mortgagePng,
                      color: context.color.onSurface,
                    ),
                    Gap.horizontal(16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AppText(
                            text: 'Kalkulator Hipotek (Mortgage Calculator)',
                            style: StyleType.bodMed,
                            fontWeight: FontWeight.w700,
                          ),
                          Gap.vertical(5),
                          const AppText.noMaxLines(
                            text:
                                'Digunakan untuk menghitung pembayaran bulanan pinjaman rumah, bunga, dan amortisasi.',
                            style: StyleType.bodSm,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_compact_right,
                      size: 40,
                      color: context.color.onSurface,
                    ),
                  ],
                ),
              ),
              // AppGlass(
              //   margin: marginLTR,
              //   padding: getEdgeInsetsAll(10),
              //   child: Row(
              //     children: [
              //       getPngAsset(
              //         loanCalculator,
              //         color: context.color.onSurface,
              //       ),
              //       Gap.horizontal(16),
              //       Expanded(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const AppText(
              //               text: 'Kalkulator Pinjaman (Loan Calculator)',
              //               style: StyleType.bodMd,
              //               fontWeight: FontWeight.w700,
              //             ),
              //             Gap.vertical(5),
              //             const AppText.noMaxLines(
              //               text:
              //                   'Membantu menghitung pembayaran bulanan, total pembayaran, dan bunga untuk berbagai jenis pinjaman seperti pinjaman mobil atau pribadi.',
              //               style: StyleType.bodSm,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Icon(
              //         CupertinoIcons.chevron_compact_right,
              //         size: 40,
              //         color: context.color.onSurface,
              //       ),
              //     ],
              //   ),
              // ),
              // AppGlass(
              //   margin: marginLTR,
              //   padding: getEdgeInsetsAll(10),
              //   child: Row(
              //     children: [
              //       getPngAsset(
              //         loanCalculator,
              //         color: context.color.onSurface,
              //       ),
              //       Gap.horizontal(16),
              //       Expanded(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const AppText(
              //               text: 'Kalkulator Bunga Majemuk (Compound Interest Calculator)',
              //               style: StyleType.bodMd,
              //               fontWeight: FontWeight.w700,
              //             ),
              //             Gap.vertical(5),
              //             const AppText.noMaxLines(
              //               text: 'Menghitung pertumbuhan investasi dari waktu ke waktu dengan bunga majemuk.',
              //               style: StyleType.bodSm,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Icon(
              //         CupertinoIcons.chevron_compact_right,
              //         size: 40,
              //         color: context.color.onSurface,
              //       ),
              //     ],
              //   ),
              // ),
              // AppGlass(
              //   margin: marginLTR,
              //   padding: getEdgeInsetsAll(10),
              //   child: Row(
              //     children: [
              //       getPngAsset(
              //         retirementPlanningPng,
              //         color: context.color.onSurface,
              //       ),
              //       Gap.horizontal(16),
              //       Expanded(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const AppText(
              //               text: 'Kalkulator Pensiun (Retirement Calculator)',
              //               style: StyleType.bodMd,
              //               fontWeight: FontWeight.w700,
              //             ),
              //             Gap.vertical(5),
              //             const AppText.noMaxLines(
              //               text:
              //                   'Digunakan untuk merencanakan kebutuhan dana pensiun dengan memperhitungkan kontribusi, pengembalian investasi, dan kebutuhan pengeluaran di masa depan.',
              //               style: StyleType.bodSm,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Icon(
              //         CupertinoIcons.chevron_compact_right,
              //         size: 40,
              //         color: context.color.onSurface,
              //       ),
              //     ],
              //   ),
              // ),
              // AppGlass(
              //   margin: marginLTR,
              //   padding: getEdgeInsetsAll(10),
              //   child: Row(
              //     children: [
              //       getPngAsset(
              //         investmentCalculatorPng,
              //         color: context.color.onSurface,
              //       ),
              //       Gap.horizontal(16),
              //       Expanded(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const AppText(
              //               text: 'Kalkulator Investasi (Investment Calculator)',
              //               style: StyleType.bodMd,
              //               fontWeight: FontWeight.w700,
              //             ),
              //             Gap.vertical(5),
              //             const AppText.noMaxLines(
              //               text:
              //                   'Membantu menghitung potensi pertumbuhan investasi dengan mempertimbangkan kontribusi bulanan, tingkat pengembalian, dan jangka waktu investasi.',
              //               style: StyleType.bodSm,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Icon(
              //         CupertinoIcons.chevron_compact_right,
              //         size: 40,
              //         color: context.color.onSurface,
              //       ),
              //     ],
              //   ),
              // ),
              // AppGlass(
              //   margin: marginLTR,
              //   padding: getEdgeInsetsAll(10),
              //   child: Row(
              //     children: [
              //       getPngAsset(
              //         savingsCalculatorPng,
              //         color: context.color.onSurface,
              //       ),
              //       Gap.horizontal(16),
              //       Expanded(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const AppText(
              //               text: 'Kalkulator Tabungan (Savings Calculator)',
              //               style: StyleType.bodMd,
              //               fontWeight: FontWeight.w700,
              //             ),
              //             Gap.vertical(5),
              //             const AppText.noMaxLines(
              //               text: 'Menghitung berapa banyak yang perlu ditabung setiap bulan untuk mencapai tujuan tabungan tertentu.',
              //               style: StyleType.bodSm,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Icon(
              //         CupertinoIcons.chevron_compact_right,
              //         size: 40,
              //         color: context.color.onSurface,
              //       ),
              //     ],
              //   ),
              // ),
              // AppGlass(
              //   margin: marginLTR,
              //   padding: getEdgeInsetsAll(10),
              //   child: Row(
              //     children: [
              //       getPngAsset(
              //         netPresentValuePng,
              //         color: context.color.onSurface,
              //       ),
              //       Gap.horizontal(16),
              //       Expanded(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const AppText(
              //               text: 'Kalkulator Nilai Sekarang Bersih (Net Present Value Calculator)',
              //               style: StyleType.bodMd,
              //               fontWeight: FontWeight.w700,
              //             ),
              //             Gap.vertical(5),
              //             const AppText.noMaxLines(
              //               text: 'Digunakan dalam analisis investasi untuk menentukan nilai sekarang dari arus kas masa depan.',
              //               style: StyleType.bodSm,
              //             ),
              //           ],
              //         ),
              //       ),
              //       Icon(
              //         CupertinoIcons.chevron_compact_right,
              //         size: 40,
              //         color: context.color.onSurface,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
