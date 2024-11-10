import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({
    required this.title, required this.onTap, super.key,
    this.iconPath,
    this.icon,
  });

  final String? iconPath;
  final String title;
  final void Function() onTap;
  final Uint8List? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Row(
          children: [
            CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: iconPath != null
                    ? getPngAsset(
                        iconPath!,
                        width: 30,
                        height: 30,
                        color: context.color.primary,
                      )
                    : Image.memory(
                        icon!,
                        width: 30,
                        height: 30,
                      ),
              ),
            ),
            Gap.horizontal(12),
            Expanded(
              child: AppText(
                text: title,
                style: StyleType.bodMd,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: context.color.primary,
            ),
          ],
        ),
      ),
    );
  }
}
