import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 36,
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  child: Column(
                    children: [
                      Gap.vertical(45),
                      AppText(
                        text: localize.welcomeScreenTitle,
                        style: StyleType.disSm,
                        textAlign: TextAlign.center,
                      ),
                      Gap.vertical(12),
                      AppText.reg18(
                        text: localize.welcomeScreenDesc,
                        textAlign: TextAlign.center,
                      ),
                      Gap.vertical(48),
                      IconTextButton(
                        label: localize.googleButtonLabel,
                        iconPath: googleColorfulIcon,
                        onPressed: () {},
                        side: BorderSide(
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                      ),
                      // Gap.vertical(20),
                      // IconTextButton(
                      //   label: localize.appleButtonLabel,
                      //   iconPath: AssetPaths.appleWhiteBoldIcon,
                      //   onPressed: () {},
                      //   side: const BorderSide(
                      //     color: AppColor.dark5,
                      //   ),
                      // ),
                      Gap.vertical(48),
                      Row(
                        children: [
                          const Expanded(child: AppDivider()),
                          Padding(
                            padding: getEdgeInsetsSymmetric(horizontal: 16),
                            child: AppText(
                              text: localize.orText,
                              style: StyleType.headSm,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Expanded(
                            child: AppDivider(),
                          ),
                        ],
                      ),
                      Gap.vertical(48),
                      AppButton.darkLabel(
                        label: localize.signUpLabel,
                        onPressed: () {
                          context.push(MyRoute.signUpInitial);
                        },
                      ),
                      Gap.vertical(20),
                      AppButton(
                        label: localize.signInLabel,
                        onPressed: () {
                          context.push(MyRoute.signInInitial);
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      Gap.vertical(48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText.reg14(
                            text: localize.privacyAndPolicy,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: AppText(
                              text: '.',
                              style: StyleType.bodLg,
                            ),
                          ),
                          AppText.reg14(
                            text: localize.termsOfService,
                          ),
                        ],
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
}
