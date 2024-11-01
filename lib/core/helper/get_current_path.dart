import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String getCurrentPath(BuildContext context) {
  final path = GoRouter.of(context).routeInformationProvider.value.uri.path;

  return path;
}

bool checkCurrentPath(BuildContext context, String path) {
  final currentPath = getCurrentPath(context);

  return currentPath == path;
}
