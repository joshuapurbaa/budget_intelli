import 'package:flutter/material.dart';

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(
        size.width / 2,
        size.height * 0.3,
        size.width,
        0, // Kurva menuju pojok kanan atas
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close(); // Menutup jalur
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
