import 'package:flutter/material.dart';

class DashboardGraphic extends StatelessWidget {
  const DashboardGraphic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Placeholder(),
    );
  }
}
