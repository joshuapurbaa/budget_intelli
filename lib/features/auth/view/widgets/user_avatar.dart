import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class UserAvar extends StatelessWidget {
  const UserAvar({
    required String imageUrl,
    required String firstChar,
    required String name,
    super.key,
  })  : _imageUrl = imageUrl,
        _firstChar = firstChar,
        _name = name;

  final String _imageUrl;
  final String _firstChar;
  final String _name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getEdgeInsetsAll(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppFixedContainer(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.color.outlineVariant,
                width: 2,
              ),
            ),
            child: _imageUrl != '-'
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      _imageUrl,
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: context.color.primary,
                    child: AppText(
                      text: _firstChar,
                      style: StyleType.disLg,
                      color: context.color.onPrimary,
                    ),
                  ),
          ),
          Gap.vertical(8),
          AppText(
            text: _name,
            style: StyleType.headLg,
          ),
        ],
      ),
    );
  }
}
