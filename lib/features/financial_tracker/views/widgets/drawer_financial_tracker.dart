import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerFinancialTracker extends StatelessWidget {
  const DrawerFinancialTracker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.color.primaryContainer,
              Color(0xff406836),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: context.color.primary,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: AppText(
                      text: 'Financial Tracker',
                      style: StyleType.headSm,
                    ),
                  ),
                ],
              ),
            ),
            const ListTile(
              title: AppText(
                text: 'Transactions',
                style: StyleType.bodLg,
              ),
              leading: Icon(Icons.account_balance_wallet),
            ),
            ListTile(
              onTap: () {
                context.pushNamed(
                  MyRoute.profileScreen.noSlashes(),
                );
              },
              title: AppText(
                text: 'Settings',
                style: StyleType.bodLg,
              ),
              leading: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
