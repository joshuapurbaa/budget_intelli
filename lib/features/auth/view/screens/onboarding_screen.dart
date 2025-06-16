import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/auth/view/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: context.color.primary,
          elevation: 0,
        ),
      ),
      backgroundColor: context.color.primary,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            padEnds: false,
            children: [
              OnboardingPage(
                title: localize.onboardTitle1,
                description: localize.onboardDesc1,
                image: onboarding1,
              ),
              OnboardingPage(
                title: localize.onboardTitle2,
                description: localize.onboardDesc2,
                image: onboarding2,
              ),
              OnboardingPage(
                title: localize.onboardTitle3,
                description: localize.onboardDesc3,
                image: onboarding3,
              ),
            ],
          ),
          Positioned(
            bottom: 130,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  dotColor: context.color.tertiaryContainer,
                  activeDotColor: context.color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: BottomSheetParent(
        isWithBorderTop: true,
        child: currentPage == 2
            ? AppButton.darkLabel(
                label: localize.onboardGetStartedButton,
                onPressed: () {
                  context.go(MyRoute.signInInitial);
                },
                height: 58.h,
              )
            : Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: localize.onboardSkipButton,
                      onPressed: () {
                        context.go(MyRoute.signInInitial);
                      },
                      width: double.infinity,
                      height: 58.h,
                      backgroundColor: context.color.tertiaryContainer,
                    ),
                  ),
                  Gap.horizontal(16),
                  Expanded(
                    child: AppButton.darkLabel(
                      label: localize.onboardContinueButton,
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      width: double.infinity,
                      height: 58.h,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
