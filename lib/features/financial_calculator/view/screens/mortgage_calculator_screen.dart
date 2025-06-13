import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MortgageCalculatorScreen extends StatefulWidget {
  const MortgageCalculatorScreen({super.key});

  @override
  State<MortgageCalculatorScreen> createState() =>
      _MortgageCalculatorScreenState();
}

class _MortgageCalculatorScreenState extends State<MortgageCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();
  final _principalFocusNode = FocusNode();
  final _interestRateFocusNode = FocusNode();
  final _tenureFocusNode = FocusNode();
  String? _calculationResult;
  final _rateTpyeController = TextEditingController();
  final _subsequentInterestRateController = TextEditingController();
  final _subsequentInterestRateFocusNode = FocusNode();
  String _selectedRateType = 'Fixed';
  final scrollController = ScrollController();

  final rateTypes = <String>[
    'Fixed',
    'Floating',
  ];

  @override
  void initState() {
    super.initState();
    _rateTpyeController.text = _selectedRateType;
  }

  @override
  Widget build(BuildContext context) {
    final marginLTR = getEdgeInsets(left: 16, top: 10, right: 16);
    final localize = textLocalizer(context);

    String? hintInterestRate;

    if (_selectedRateType == 'Floating') {
      hintInterestRate = 'Suku Bunga Tahunan Pertama*';
    } else {
      hintInterestRate = 'Suku Bunga Tahunan Berikutnya*';
    }

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          const SliverAppBarPrimary(
            title: 'Mortgage Calculator',
          ),
          Form(
            key: _formKey,
            child: SliverList.list(
              children: [
                AppGlass(
                  margin: marginLTR,
                  padding: getEdgeInsets(
                    top: 10,
                    bottom: 10,
                    left: 16,
                    right: 10,
                  ),
                  child: DropdownMenu<String>(
                    controller: _rateTpyeController,
                    expandedInsets: EdgeInsets.zero,
                    menuHeight: 150.h,
                    selectedTrailingIcon: const Icon(
                      CupertinoIcons.chevron_up,
                      size: 25,
                    ),
                    leadingIcon: Padding(
                      padding: getEdgeInsets(right: 22),
                      child: getPngAsset(
                        categoryPng,
                        height: 18,
                        width: 18,
                        color: context.color.onSurface,
                      ),
                    ),
                    inputDecorationTheme: _inputDecoration(context),
                    trailingIcon: const Icon(
                      CupertinoIcons.chevron_down,
                      size: 25,
                    ),
                    hintText: localize.interestRate,
                    textStyle: textStyle(
                      context,
                      style: StyleType.bodMed,
                    ).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    requestFocusOnTap: false,
                    onSelected: (String? rateType) {
                      setState(() {
                        if (rateType != null) {
                          _selectedRateType = rateType;
                        }
                      });
                    },
                    menuStyle: _menuStyle(),
                    dropdownMenuEntries:
                        rateTypes.map<DropdownMenuEntry<String>>(
                      (String accountType) {
                        return DropdownMenuEntry<String>(
                          value: accountType,
                          label: accountType,
                          style: MenuItemButton.styleFrom(
                            visualDensity: VisualDensity.comfortable,
                            textStyle: textStyle(
                              context,
                              style: StyleType.bodMed,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                AppBoxFormField(
                  margin: marginLTR,
                  hintText: localize.loanAmount,
                  keyboardType: TextInputType.number,
                  prefixIcon: priceHousePng,
                  controller: _principalController,
                  focusNode: _principalFocusNode,
                  isPng: true,
                  iconColor: context.color.onSurface,
                ),
                AppBoxFormField(
                  margin: marginLTR,
                  hintText: hintInterestRate,
                  keyboardType: TextInputType.number,
                  prefixIcon: interestRatePng,
                  controller: _interestRateController,
                  focusNode: _interestRateFocusNode,
                  isPng: true,
                  iconColor: context.color.onSurface,
                ),
                if (_selectedRateType == 'Floating')
                  AppBoxFormField(
                    margin: marginLTR,
                    hintText: localize.nextAnnualInterestRate,
                    keyboardType: TextInputType.number,
                    prefixIcon: interestRatePng,
                    controller: _subsequentInterestRateController,
                    focusNode: _subsequentInterestRateFocusNode,
                    isPng: true,
                    iconColor: context.color.onSurface,
                  ),
                AppBoxFormField(
                  margin: marginLTR,
                  hintText: 'Tenure (Years)*',
                  keyboardType: TextInputType.number,
                  prefixIcon: tenureTimePng,
                  controller: _tenureController,
                  focusNode: _tenureFocusNode,
                  isPng: true,
                  iconColor: context.color.onSurface,
                ),
                if (_calculationResult != null) ...[
                  Container(
                    padding: getEdgeInsetsAll(16),
                    margin: marginLTR,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.color.onSurface.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: '${localize.result}:',
                          style: StyleType.bodLg,
                        ),
                        Gap.vertical(10),
                        AppText.noMaxLines(
                          text: _calculationResult ?? '',
                          style: StyleType.bodMed,
                        ),
                      ],
                    ),
                  ),
                ],
                Gap.vertical(100),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: BottomSheetParent(
        isWithBorderTop: true,
        child: AppButton(
          label: localize.calculate,
          onPressed: () {
            if (_selectedRateType == 'Fixed') {
              _calculateMortgageFixedRate();
            } else if (_selectedRateType == 'Floating') {
              _calculateMortgageFloatingRate();
            }
          },
        ),
      ),
    );
  }

  void _automaticScroll() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
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

  InputDecorationTheme _inputDecoration(
    BuildContext context,
  ) {
    return InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: textStyle(
        context,
        style: StyleType.bodMed,
      ).copyWith(
        fontWeight: FontWeight.w400,
        color: context.color.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  void _calculateMortgageFixedRate() {
    if (_formKey.currentState!.validate()) {
      final localize = textLocalizer(context);
      try {
        final principal =
            ControllerHelper.parseStringToInt(_principalController.text);
        final interestRate =
            ControllerHelper.parseStringToInt(_interestRateController.text);
        final tenure =
            ControllerHelper.parseStringToInt(_tenureController.text);

        final totalMonthlyInstallment = calculateFixedRateMortgage(
          principal,
          interestRate,
          tenure,
        );

        final monthlyInstallement = NumberFormatter.formatToMoneyInt(
          context,
          totalMonthlyInstallment.totalMonthlyInstallment,
        );

        setState(() {
          _calculationResult = '''
          ${localize.monthlyInstallment}: $monthlyInstallement
          
          Total: ${NumberFormatter.formatToMoneyInt(context, totalMonthlyInstallment.total)}
          ''';
        });
        _automaticScroll();
      } on Exception catch (_) {
        AppToast.showToastError(
          context,
          'Error calculating mortgage',
        );
      }
    }
  }

  ({
    int totalMonthlyInstallment,
    int total,
  }) calculateFixedRateMortgage(
    int? principal,
    int? annualInterestRate,
    int? tenureInYears,
  ) {
    var totalMonthlyInstallment = 0.0;
    var total = 0.0;

    if (principal != null &&
        annualInterestRate != null &&
        tenureInYears != null) {
      final totalMonths = tenureInYears * 12;

      final monthlyPrincipalInstallment = principal / totalMonths;
      final monthlyInterestInstallment =
          principal * (annualInterestRate / 100) / 12;
      totalMonthlyInstallment =
          monthlyPrincipalInstallment + monthlyInterestInstallment;
      total = totalMonthlyInstallment * totalMonths;
    }

    return (
      totalMonthlyInstallment: totalMonthlyInstallment.toInt(),
      total: total.toInt(),
    );
  }

  void _calculateMortgageFloatingRate() {
    try {
      if (_formKey.currentState!.validate()) {
        final principal =
            ControllerHelper.parseStringToInt(_principalController.text);
        final initialAnnualInterestRate =
            ControllerHelper.parseStringToInt(_interestRateController.text);
        final subsequentAnnualInterestRate = ControllerHelper.parseStringToInt(
          _subsequentInterestRateController.text,
        );
        final tenureInYears =
            ControllerHelper.parseStringToInt(_tenureController.text);

        final monthlyInstallments = calculateFloatingRateMortgage(
          principal,
          initialAnnualInterestRate,
          subsequentAnnualInterestRate,
          tenureInYears,
        );
        if (monthlyInstallments != null) {
          setState(() {
            _calculationResult = '''
            ${monthlyInstallments.initialYear}
            ${monthlyInstallments.totalInitialYear}
            ${monthlyInstallments.subsequentYear}
            ${monthlyInstallments.totalSubsequentYear}     
            
            ${monthlyInstallments.totals}       
            ''';
          });
          _automaticScroll();
        }
      }
    } on Exception catch (_) {
      AppToast.showToastError(
        context,
        'Error calculating mortgage',
      );
    }
  }

  ({
    String initialYear,
    String subsequentYear,
    String totalInitialYear,
    String totalSubsequentYear,
    String totals,
  })? calculateFloatingRateMortgage(
    int? principal,
    int? interestRate,
    int? subsequentAnnualInterestRate,
    int? tenureInYears,
  ) {
    final localize = textLocalizer(context);
    if (principal != null &&
        interestRate != null &&
        subsequentAnnualInterestRate != null &&
        tenureInYears != null) {
      final totalMonths = tenureInYears * 12;
      const monthsInFirstYear = 12;

      final monthlyPrincipalInstallment = principal / totalMonths;
      final initialMonthlyInterestInstallment =
          principal * (interestRate / 100) / 12;
      final subsequentMonthlyInterestInstallment =
          principal * (subsequentAnnualInterestRate / 100) / 12;

      final initialMonthlyInstallment =
          monthlyPrincipalInstallment + initialMonthlyInterestInstallment;
      final subsequentMonthlyInstallment =
          monthlyPrincipalInstallment + subsequentMonthlyInterestInstallment;

      final initialYearResult =
          '${localize.month} 1 - 12 : ${NumberFormatter.formatToMoneyDouble(context, initialMonthlyInstallment)}';
      final subsequentYearResult =
          '${localize.month} 13 - $totalMonths : ${NumberFormatter.formatToMoneyDouble(context, subsequentMonthlyInstallment)}';
      final totalIntialYear =
          'Total : ${NumberFormatter.formatToMoneyDouble(context, initialMonthlyInstallment * monthsInFirstYear)}';
      final totalSubsequentYear =
          'Total: ${NumberFormatter.formatToMoneyDouble(context, subsequentMonthlyInstallment * (totalMonths - monthsInFirstYear))}';
      final totals =
          'Totals: ${NumberFormatter.formatToMoneyDouble(context, initialMonthlyInstallment * monthsInFirstYear + subsequentMonthlyInstallment * (totalMonths - monthsInFirstYear))}';

      return (
        initialYear: initialYearResult,
        subsequentYear: subsequentYearResult,
        totalInitialYear: totalIntialYear,
        totalSubsequentYear: totalSubsequentYear,
        totals: totals,
      );
    }

    return null;
  }
}
