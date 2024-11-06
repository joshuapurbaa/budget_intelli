import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerFinancialTracker extends StatelessWidget {
  const DrawerFinancialTracker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.color.primary,
            ),
            child: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Menutup drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.pop(context); // Menutup drawer
            },
          ),
        ],
      ),
    );
  }
}
