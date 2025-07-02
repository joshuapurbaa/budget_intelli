import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/my_portfolio/my_portfolio_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddMyPortfolioScreen extends StatefulWidget {
  const AddMyPortfolioScreen({super.key});

  @override
  State<AddMyPortfolioScreen> createState() => _AddMyPortfolioScreenState();
}

class _AddMyPortfolioScreenState extends State<AddMyPortfolioScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _stockSymbolController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _buyPriceController = TextEditingController();
  final TextEditingController _stopLossController = TextEditingController();
  final TextEditingController _takeProfitController = TextEditingController();
  final TextEditingController _lotController = TextEditingController();
  final TextEditingController _buyReasonController = TextEditingController();
  final FocusNode _buyPriceFocusNode = FocusNode();
  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _stockCodeFocusNode = FocusNode();
  final FocusNode _stopLossFocusNode = FocusNode();
  final FocusNode _takeProfitFocusNode = FocusNode();
  final FocusNode _lotFocusNode = FocusNode();
  final FocusNode _buyReasonFocusNode = FocusNode();

  String? stopLossPriceString;
  double? stopLossPrice;
  double? heightSizebox;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _stockSymbolController.dispose();
    _companyNameController.dispose();
    _buyPriceController.dispose();
    _stopLossController.dispose();
    _takeProfitController.dispose();
    _lotController.dispose();
    _buyReasonController.dispose();
    _buyPriceFocusNode.dispose();
    _companyNameFocusNode.dispose();
    _stockCodeFocusNode.dispose();
    _stopLossFocusNode.dispose();
    _takeProfitFocusNode.dispose();
    _lotFocusNode.dispose();
    _buyReasonFocusNode.dispose();

    super.dispose();
  }

  void _scrollToField(int index) {
    _scrollController.animateTo(
      index * 100.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void setStopLossPrice() {
    if (_buyPriceController.text.isNotEmpty &&
        _stopLossController.text.isNotEmpty) {
      final buyPrice =
          double.tryParse(_buyPriceController.text.replaceAll('.', ''));
      final stopLoss =
          double.tryParse(_stopLossController.text.replaceAll('.', ''));

      final calculatedStopLoss = buyPrice! - (buyPrice * stopLoss! / 100);
      setState(() {
        heightSizebox = 120.h;
        stopLossPriceString = NumberFormatter.formatToMoneyDouble(
          context,
          calculatedStopLoss,
        );
        stopLossPrice = calculatedStopLoss;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBarPrimary(
                title: localize.addPortfolio,
              ),
              SliverPadding(
                padding: getEdgeInsetsAll(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      AppBoxFormField(
                        hintText: '${localize.stockSymbol}*',
                        prefixIcon: stockSymbolPng,
                        controller: _stockSymbolController,
                        focusNode: _stockCodeFocusNode,
                        isPng: true,
                        iconColor: context.color.onSurface,
                      ),
                      Gap.vertical(10),
                      AppBoxFormField(
                        hintText: '${localize.companyName}*',
                        prefixIcon: companyOfficeBuilding,
                        controller: _companyNameController,
                        focusNode: _companyNameFocusNode,
                        isPng: true,
                        iconColor: context.color.onSurface,
                      ),
                      Gap.vertical(10),
                      AppBoxCalendar(
                        label: '${localize.buyDate}*',
                      ),
                      Gap.vertical(10),
                      AppBoxFormField(
                        hintText: '${localize.buyReason}*',
                        prefixIcon: reasonPng,
                        controller: _buyReasonController,
                        focusNode: _buyReasonFocusNode,
                        isPng: true,
                        iconColor: context.color.onSurface,
                      ),
                      Gap.vertical(10),
                      Row(
                        children: [
                          Expanded(
                            child: AppBoxFormField(
                              hintText: '${localize.buyPrice}*',
                              prefixIcon: priceTagPng,
                              controller: _buyPriceController,
                              focusNode: _buyPriceFocusNode,
                              isPng: true,
                              iconColor: context.color.onSurface,
                              keyboardType: TextInputType.number,
                              onChanged: (_) {
                                setStopLossPrice();
                              },
                            ),
                          ),
                          Gap.horizontal(10),
                          Expanded(
                            child: AppBoxFormField(
                              hintText: '${localize.lot}*',
                              prefixIcon: pieChartPng,
                              controller: _lotController,
                              focusNode: _lotFocusNode,
                              isPng: true,
                              iconColor: context.color.onSurface,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Gap.vertical(10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: heightSizebox,
                              child: Stack(
                                children: [
                                  if (stopLossPriceString != null)
                                    Positioned(
                                      top: 30,
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: getEdgeInsets(
                                          left: 10,
                                          bottom: 10,
                                          right: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: context.color.primary
                                              .withValues(alpha: 0.4),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            bottom: Radius.circular(10),
                                          ),
                                        ),
                                        child: AppText(
                                          text:
                                              '${localize.stopLossAtPrice} : $stopLossPriceString',
                                          style: StyleType.bodMed,
                                        ),
                                      ),
                                    ),
                                  AppBoxFormField(
                                    hintText: '${localize.takeProfit}*',
                                    prefixIcon: takeProfitPng,
                                    controller: _takeProfitController,
                                    focusNode: _takeProfitFocusNode,
                                    isPng: true,
                                    iconColor: context.color.onSurface,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gap.horizontal(10),
                          Expanded(
                            child: AppBoxFormField(
                              hintText: '${localize.stopLoss}*',
                              prefixIcon: stopLossPng,
                              controller: _stopLossController,
                              focusNode: _stopLossFocusNode,
                              isPng: true,
                              iconColor: context.color.onSurface,
                              keyboardType: TextInputType.number,
                              suffixIcon: const AppText(
                                text: '%',
                                style: StyleType.bodLg,
                              ),
                              onChanged: (_) {
                                setStopLossPrice();
                              },
                            ),
                          ),
                        ],
                      ),
                      Gap.vertical(80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: BottomSheetParent(
                isWithBorderTop: true,
                child: BlocListener<MyPortfolioDbBloc, MyPortfolioDbState>(
                  listener: (context, state) {
                    if (state.insertMyPortfolioSuccess) {
                      AppToast.showToastSuccess(
                        context,
                        localize.successfullyAddedPortfolio,
                      );
                      if (context.canPop()) {
                        context.read<MyPortfolioDbBloc>().add(
                              const GetMyPortfolioListDbEvent(),
                            );
                        context.pop();
                      }
                    }
                  },
                  child: AppButton(
                    label: localize.add,
                    onPressed: () async {
                      String? selectedDate;
                      final appBoxCalendarState =
                          context.read<AppBoxCalendarCubit>().state;

                      if (appBoxCalendarState is AppBoxCalendarSelected) {
                        final date = appBoxCalendarState.selectedDate;
                        selectedDate = date.toString();
                      }

                      if (_stockSymbolController.text.isEmpty ||
                          _companyNameController.text.isEmpty ||
                          _buyPriceController.text.isEmpty ||
                          _stopLossController.text.isEmpty ||
                          _lotController.text.isEmpty ||
                          selectedDate == null ||
                          stopLossPrice == null ||
                          _takeProfitController.text.isEmpty ||
                          _buyReasonController.text.isEmpty) {
                        AppToast.showToastError(
                          context,
                          localize.pleaseFillAllRequiredFields,
                        );
                        return;
                      }

                      final myPortfolio = MyPortfolioModel(
                        id: const Uuid().v4(),
                        stockSymbol: _stockSymbolController.text,
                        companyName: _companyNameController.text,
                        buyPrice: double.tryParse(
                          _buyPriceController.text.replaceAll('.', ''),
                        )!,
                        stopLoss: stopLossPrice!,
                        takeProfit: double.tryParse(
                          _takeProfitController.text.replaceAll('.', ''),
                        ),
                        lot: int.parse(_lotController.text),
                        buyDate: selectedDate,
                        createdAt: DateTime.now().toString(),
                        updatedAt: DateTime.now().toString(),
                        buyReason: _buyReasonController.text,
                        closePrice: 0,
                      );

                      context.read<MyPortfolioDbBloc>().add(
                            InsertMyPortfolioDbEvent(myPortfolio),
                          );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
