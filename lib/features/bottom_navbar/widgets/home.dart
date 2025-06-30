import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/home/view/home_tab_view/home_content.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.user,
    super.key,
  });

  final UserIntelli? user;

  @override
  Widget build(BuildContext context) {
    return HomeContent(
      user: user,
    );
  }
}
