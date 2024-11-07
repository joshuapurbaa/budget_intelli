import 'package:flutter/material.dart';

class AccountsBottomsheet extends StatelessWidget {
  const AccountsBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.80,
      ),
    );
  }
}
