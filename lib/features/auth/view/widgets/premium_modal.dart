import 'dart:async';

import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/settings/settings_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumModal extends StatefulWidget {
  const PremiumModal({
    required this.user,
    super.key,
  });

  final UserIntelli? user;

  @override
  State<PremiumModal> createState() => _PremiumModalState();
}

class _PremiumModalState extends State<PremiumModal> {
  final _productId = [
    'annual_subscription',
    'monthly_subscription',
  ];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _isProductAvailable = false;
  String _selectedProduct = '';
  bool fromProfile = true;

  Future<void> _initStoreInfo() async {
    final isAvailable = await _inAppPurchase.isAvailable();

    if (!isAvailable) {
      setState(() {
        _isProductAvailable = false;
      });
      return;
    }

    final productDetailResponse =
        await _inAppPurchase.queryProductDetails(_productId.toSet());

    if (productDetailResponse.error != null) {
      return;
    } else {
      setState(() {
        _isProductAvailable = true;
        _products = productDetailResponse.productDetails;
        _selectedProduct = _products[0].id;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<SettingBloc>().add(GetUserSettingEvent());
    _initStoreInfo();
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);

    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (!state.loading) {
          if (!fromProfile) {
            _onPurchase(widget.user);
          }
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBarPrimary(
            action: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            leading: const SizedBox(),
            title: 'Premium',
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Image.asset(
                  'assets/images/premium.png',
                  fit: BoxFit.contain,
                  height: 200,
                ),
                Padding(
                  padding: getEdgeInsetsAll(16),
                  child: Column(
                    children: [
                      Center(
                        child: AppText(
                          text: localize.unlockPremiumFeatures,
                          style: StyleType.headMed,
                        ),
                      ),
                      Gap.vertical(16),
                      _Feature(
                        title: localize.unlimitedBudgets,
                      ),
                      Gap.vertical(8),
                      _Feature(
                        title: localize.unlimitedTransactions,
                      ),
                      Gap.vertical(8),
                      _Feature(
                        title: localize.unlimitedCategories,
                      ),
                      Gap.vertical(8),
                      _Feature(
                        title: localize.adFreeExperience,
                      ),
                      Gap.vertical(8),
                      _Feature(
                        title: localize.uploadingReceipts,
                      ),
                      Gap.vertical(8),
                      _Feature(
                        title: localize.exportingData,
                      ),
                      Gap.vertical(8),
                      _Feature(
                        title: localize.backupDataToCloud,
                      ),
                      Gap.vertical(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_products.isNotEmpty) ...[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedProduct = _products[0].id;
                                });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width / 2 -
                                            28,
                                    padding: getEdgeInsetsAll(16),
                                    decoration: BoxDecoration(
                                      color: context.color.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          _selectedProduct == _products[0].id
                                              ? Border.all(
                                                  color: context.color.primary,
                                                  width: 2,
                                                )
                                              : null,
                                    ),
                                    child: Column(
                                      children: [
                                        AppText(
                                          text: localize.annual,
                                          style: StyleType.headSm,
                                        ),
                                        Gap.vertical(8),
                                        AppText(
                                          text:
                                              '${_products.isNotEmpty ? _products[0].price : 0.0}',
                                          style: StyleType.bodLg,
                                        ),
                                        Gap.vertical(8),
                                        AppText(
                                          text: '25% ${localize.savings}',
                                          style: StyleType.labLg,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_selectedProduct == _products[0].id)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: getPngAsset(
                                        checked,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Gap.horizontal(16),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedProduct = _products[1].id;
                                });
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.sizeOf(context).width / 2 -
                                            28,
                                    padding: getEdgeInsetsAll(16),
                                    decoration: BoxDecoration(
                                      color: context.color.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          _selectedProduct == _products[1].id
                                              ? Border.all(
                                                  color: context.color.primary,
                                                  width: 2,
                                                )
                                              : null,
                                    ),
                                    child: Column(
                                      children: [
                                        AppText(
                                          text: localize.monthly,
                                          style: StyleType.headSm,
                                        ),
                                        Gap.vertical(8),
                                        AppText(
                                          text:
                                              '${_products.isNotEmpty ? _products[1].price : 0.0}',
                                          style: StyleType.bodLg,
                                        ),
                                        Gap.vertical(8),
                                        const AppText(
                                          text: ' ',
                                          style: StyleType.labLg,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_selectedProduct == _products[1].id)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: getPngAsset(
                                        checked,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      Gap.vertical(24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final loading = state is AuthLoading;
                          if (loading) {
                            return const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            );
                          }

                          return AppButton(
                            label: localize.getPremium,
                            onPressed: () {
                              // final settingState =
                              //     context.read<SettingBloc>().state;
                              _onPurchase(widget.user);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onPurchase(UserIntelli? user) async {
    final userName = user?.name;

    if (userName != null) {
      if (_isProductAvailable) {
        final selectedProduct = _products.firstWhere(
          (element) => element.id == _selectedProduct,
        );

        await _inAppPurchase.buyNonConsumable(
          purchaseParam: PurchaseParam(
            productDetails: selectedProduct,
          ),
        );
      }
    } else {
      await _goToSignUp(context);
    }
  }

  Future<void> _goToSignUp(
    BuildContext context,
  ) async {
    final result = await context.push(MyRoute.signUpFromProfile);

    if (result != null && result == true) {
      setState(() {
        fromProfile = false;
      });
    }
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(width: 8),
        AppText(
          text: title,
          style: StyleType.bodMd,
        ),
      ],
    );
  }
}
