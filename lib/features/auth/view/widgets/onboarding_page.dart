import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    super.key,
  });

  final String title;
  final String description;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: getEdgeInsets(top: 80),
            child: Align(
              alignment: Alignment.topCenter,
              child: getPngAsset(
                image,
                width: 200,
                height: 200,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: TopCurveClipper(),
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: getEdgeInsets(
                    left: 24,
                    right: 24,
                    top: 80,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text: title,
                        style: StyleType.disSm,
                        textAlign: TextAlign.center,
                      ),
                      Gap.vertical(12),
                      AppText.reg18(
                        text: description,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
