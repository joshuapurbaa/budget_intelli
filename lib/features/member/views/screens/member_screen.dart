import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarPrimary(
            title: localize.member,
          ),
        ],
      ),
    );
  }
}
