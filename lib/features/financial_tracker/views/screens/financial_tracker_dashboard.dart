import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:flutter/material.dart';

class FinancialTrackerDashboard extends StatefulWidget {
  const FinancialTrackerDashboard({super.key});

  @override
  State<FinancialTrackerDashboard> createState() =>
      _FinancialTrackerDashboardState();
}

class _FinancialTrackerDashboardState extends State<FinancialTrackerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Menutup drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Menutup drawer
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          FinancialTrackerDashboardAppbar(),
          FinancialTrackerDashboardBody(),
        ],
      ),
    );
  }
}
