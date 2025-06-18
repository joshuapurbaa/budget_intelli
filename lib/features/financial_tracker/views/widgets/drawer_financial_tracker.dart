import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerFinancialTracker extends StatelessWidget {
  const DrawerFinancialTracker({
    required this.onNavigate,
    super.key,
  });
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.color.primaryContainer,
              const Color(0xff406836),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.color.primary,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: context.color.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AppText(
                      text: localize.financialTracker,
                      style: StyleType.headSm,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                onNavigate.call();
                context.pushNamed(
                  MyRoute.member.noSlashes(),
                );
              },
              title: AppText(
                text: localize.member,
                style: StyleType.bodLg,
              ),
              leading: getPngAsset(
                familyMemberPng,
                color: context.color.primary,
              ),
            ),
            ListTile(
              onTap: () {
                context
                    .pushNamed(
                      MyRoute.setting.noSlashes(),
                    )
                    .whenComplete(onNavigate.call);
              },
              title: AppText(
                text: localize.settings,
                style: StyleType.bodLg,
              ),
              leading: Icon(
                Icons.settings,
                color: context.color.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
