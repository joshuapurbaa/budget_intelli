import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class DrawerFinancialTracker extends StatelessWidget {
  const DrawerFinancialTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.color.primaryContainer,
              context.color.primaryContainer,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
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
                    child: Text('Financial Tracker'),
                  ),
                ],
              ),
            ),
            const ListTile(
              title: Text('Dashboard'),
              leading: Icon(Icons.dashboard),
            ),
            const ListTile(
              title: Text('Transactions'),
              leading: Icon(Icons.account_balance_wallet),
            ),
            const ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
