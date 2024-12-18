import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/member/member_barrel.dart';
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: getEdgeInsetsAll(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      memberStaticList.length,
                      (index) {
                        final iconPath = memberStaticList[index].iconPath;
                        final icon = memberStaticList[index].icon;
                        return MemberItem(
                          iconPath: iconPath,
                          icon: icon,
                          title: memberStaticList[index].name,
                          onTap: () {},
                        );
                      },
                    ),
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
