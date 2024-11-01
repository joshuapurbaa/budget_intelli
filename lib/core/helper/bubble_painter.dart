import 'package:flutter/material.dart';

///custom painter use to create the shape of the chat bubble
///
/// [color],[alignment] and [tail] can be changed

class BubblePainter extends CustomPainter {
  BubblePainter({
    required this.color,
    required this.alignment,
    required this.tail,
  });
  final Color color;
  final Alignment alignment;
  final bool tail;

  final double _radius = 10;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    if (alignment == Alignment.topRight) {
      if (tail) {
        final path = Path()
          ..moveTo(_radius * 2, 0)
          ..quadraticBezierTo(0, 0, 0, _radius * 1.5)
          ..lineTo(0, h - _radius * 1.5)
          ..quadraticBezierTo(0, h, _radius * 2, h)
          ..lineTo(w - _radius * 3, h)
          ..quadraticBezierTo(
            w - _radius * 1.5,
            h,
            w - _radius * 1.5,
            h - _radius * 0.6,
          )
          ..quadraticBezierTo(w - _radius * 1, h, w, h)
          ..quadraticBezierTo(
            w - _radius * 0.8,
            h,
            w - _radius,
            h - _radius * 1.5,
          )
          ..lineTo(w - _radius, _radius * 1.5)
          ..quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas
          ..clipPath(path)
          ..drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
      } else {
        final path = Path()
          ..moveTo(_radius * 2, 0)
          ..quadraticBezierTo(0, 0, 0, _radius * 1.5)

          /// left line
          ..lineTo(0, h - _radius * 1.5)

          /// bottom-left corner
          ..quadraticBezierTo(0, h, _radius * 2, h)

          /// bottom line
          ..lineTo(w - _radius * 3, h)

          /// bottom-right curve
          ..quadraticBezierTo(w - _radius, h, w - _radius, h - _radius * 1.5)

          /// right line
          ..lineTo(w - _radius, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w - _radius, 0, w - _radius * 3, 0);

        canvas
          ..clipPath(path)
          ..drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
      }
    } else {
      if (tail) {
        final path = Path()

          /// starting point
          ..moveTo(_radius * 3, 0)

          /// top-left corner
          ..quadraticBezierTo(_radius, 0, _radius, _radius * 1.5)

          /// left line
          ..lineTo(_radius, h - _radius * 1.5)
          // bottom-right tail curve 1
          ..quadraticBezierTo(_radius * .8, h, 0, h)

          /// bottom-right tail curve 2
          ..quadraticBezierTo(
            _radius * 1,
            h,
            _radius * 1.5,
            h - _radius * 0.6,
          )

          /// bottom-left bubble curve
          ..quadraticBezierTo(_radius * 1.5, h, _radius * 3, h)

          /// bottom line
          ..lineTo(w - _radius * 2, h)

          /// bottom-right curve
          ..quadraticBezierTo(w, h, w, h - _radius * 1.5)

          /// right line
          ..lineTo(w, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas
          ..clipPath(path)
          ..drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
      } else {
        final path = Path()

          /// starting point
          ..moveTo(_radius * 3, 0)

          /// top-left corner
          ..quadraticBezierTo(_radius, 0, _radius, _radius * 1.5)

          /// left line
          ..lineTo(_radius, h - _radius * 1.5)

          /// bottom-left curve
          ..quadraticBezierTo(_radius, h, _radius * 3, h)

          /// bottom line
          ..lineTo(w - _radius * 2, h)

          /// bottom-right curve
          ..quadraticBezierTo(w, h, w, h - _radius * 1.5)

          /// right line
          ..lineTo(w, _radius * 1.5)

          /// top-right curve
          ..quadraticBezierTo(w, 0, w - _radius * 2, 0);
        canvas
          ..clipPath(path)
          ..drawRRect(
            RRect.fromLTRBR(0, 0, w, h, Radius.zero),
            Paint()
              ..color = color
              ..style = PaintingStyle.fill,
          );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
