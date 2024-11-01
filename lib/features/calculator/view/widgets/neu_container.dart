import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';

class NeuContainer extends StatefulWidget {
  const NeuContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
  });

  final Widget? child;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  State<NeuContainer> createState() => _NeuContainerState();
}

class _NeuContainerState extends State<NeuContainer> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Container(
        padding: widget.padding,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: context.color.primary,
          borderRadius: getRadius(16),
        ),
        child: widget.child,
      ),
    );
  }
}
