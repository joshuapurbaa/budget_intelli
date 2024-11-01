import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A reusable widget that provides a scaffold with an app bar and a body.
///
/// The [AppScaffold] widget is used to create a scaffold with a custom app bar
/// title and a list of children widgets as the body. It is commonly used as a
/// base widget for creating screens in the application.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.children,
    this.appBarTitle,
    super.key,
    this.bottomSheet,
    this.onBackButtonPressed,
    this.titleTextStyle,
    this.actions,
  });

  /// The title to be displayed in the app bar.
  final String? appBarTitle;

  /// The list of children widgets to be displayed in the body of the scaffold.
  final List<Widget> children;
  final Widget? bottomSheet;
  final VoidCallback? onBackButtonPressed;
  final TextStyle? titleTextStyle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverVisibility(
            visible: appBarTitle != null,
            sliver: SliverAppBarPrimary(
              title: appBarTitle ?? '',
              leading: canPop
                  ? BackButton(
                      onPressed: onBackButtonPressed,
                    )
                  : null,
              titleTextStyle: titleTextStyle,
              action: actions,
            ),
          ),
          SliverPadding(
            padding: getEdgeInsetsAll(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(children),
            ),
          ),
        ],
      ),
      bottomSheet: bottomSheet,
    );
  }
}
