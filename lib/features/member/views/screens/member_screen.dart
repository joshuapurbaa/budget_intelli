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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: getEdgeInsetsAll(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MemberItem(
                        iconPath: selfPng,
                        title: 'Self',
                        onTap: () {},
                      ),
                      MemberItem(
                        iconPath: wifePng,
                        title: 'Wife',
                        onTap: () {},
                      ),
                      MemberItem(
                        iconPath: husbandPng,
                        title: 'Husband',
                        onTap: () {},
                      ),
                      MemberItem(
                        iconPath: parentsPng,
                        title: 'Parents',
                        onTap: () {},
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

class MemberItem extends StatelessWidget {
  const MemberItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          getPngAsset(
            iconPath,
            width: 30,
            height: 30,
            color: context.color.primary,
          ),
          Gap.horizontal(12),
          AppText(
            text: title,
            style: StyleType.bodMd,
          ),
        ],
      ),
    );
  }
}
