import 'package:budget_intelli/core/constants/environment.dart';
import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdWidgetRepository extends StatefulWidget {
  const AdWidgetRepository({
    required this.child,
    required this.height,
    super.key,
    this.user,
  });

  final Widget child;
  final double height;

  final UserIntelli? user;

  @override
  State<AdWidgetRepository> createState() => _AdWidgetRepositoryState();
}

class _AdWidgetRepositoryState extends State<AdWidgetRepository> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _createBannerAd() {
    final premiumUser = widget.user?.premium ?? false;

    if (premiumUser) {
      return;
    } else {
      setState(() {
        final adUnitId =
            AdmobService(isProduction: environmentProd).getBannerUnitId();
        _bannerAd = BannerAd(
          adUnitId: adUnitId!,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (Ad ad) {},
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) {
              ad.dispose();
            },
            onAdClosed: (Ad ad) {
              ad.dispose();
            },
          ),
        );

        _bannerAd!.load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerReady = _bannerAd != null;

    if (!bannerReady) {
      return const SizedBox();
    }

    return SizedBox(
      height: widget.height.h,
      child: Stack(
        children: [
          widget.child,
          if (bannerReady)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
        ],
      ),
    );
  }
}
