import 'package:budget_intelli/features/auth/auth_barrel.dart';
import 'package:budget_intelli/features/bottom_navbar/widgets/explores.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({
    required this.user,
    super.key,
  });

  final UserIntelli? user;

  @override
  Widget build(BuildContext context) {
    return Explores(
      user: user,
    );
  }
}
