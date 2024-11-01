import 'package:flutter/material.dart';

RelativeRect getRelativeRectPosition(
  BuildContext context,
  GlobalKey actionKey,
) {
  final button = actionKey.currentContext!.findRenderObject()! as RenderBox;
  final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
  final position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(
        Offset(0, button.size.height),
        ancestor: overlay,
      ),
      button.localToGlobal(
        button.size.bottomRight(Offset.zero),
        ancestor: overlay,
      ),
    ),
    Offset.zero & overlay.size,
  );
  return position;
}
