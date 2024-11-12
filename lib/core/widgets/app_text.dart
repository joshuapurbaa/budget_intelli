import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppText extends StatelessWidget {
  const AppText({
    required this.text,
    required this.style,
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  });

  const AppText.color({
    required this.text,
    required this.color,
    required this.style,
    super.key,
    this.textAlign,
    this.fontWeight,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  });

  const AppText.reg12({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  }) : style = StyleType.bodSm;

  const AppText.bold14({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.bodMd,
        fontWeight = FontWeight.w700;

  const AppText.reg14({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.bodMd,
        fontWeight = FontWeight.w400;

  const AppText.light14({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.bodMd,
        fontWeight = FontWeight.w300;

  const AppText.medium14({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.bodMd,
        fontWeight = FontWeight.w500;

  const AppText.medium16({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.bodLg,
        fontWeight = FontWeight.w500;

  const AppText.reg16({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.bodLg,
        fontWeight = FontWeight.w400;

  const AppText.light16({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.bodLg,
        fontWeight = FontWeight.w300;

  const AppText.reg18({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.titSm,
        fontWeight = FontWeight.w400;

  const AppText.semi18({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.titSm,
        fontWeight = FontWeight.w600;

  const AppText.error({
    required this.text,
    super.key,
    this.textAlign,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  })  : style = StyleType.bodMd,
        fontWeight = FontWeight.w400;

  // create a new constructor for italic text
  const AppText.italic({
    required this.text,
    required this.style,
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  }) : fontStyle = FontStyle.italic;

  const AppText.autoSize({
    required this.text,
    required this.style,
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.fontStyle,
    this.maxLines,
    this.noMaxLines,
    this.animation,
  }) : autoSize = true;

  const AppText.noMaxLines({
    required this.text,
    required this.style,
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.animation,
  }) : noMaxLines = true;

  const AppText.animate({
    required this.text,
    required this.style,
    super.key,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.fontStyle,
    this.autoSize,
    this.maxLines,
    this.noMaxLines,
  }) : animation = true;

  final String text;
  final StyleType style;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? fontStyle;
  final bool? autoSize;
  final int? maxLines;
  final bool? noMaxLines;
  final bool? animation;

  @override
  Widget build(BuildContext context) {
    if (autoSize != null) {
      return AutoSizeText(
        minFontSize: 30,
        text,
        style: textStyle(
          context,
          style,
        ).copyWith(
          fontWeight: fontWeight,
          color: color ?? context.color.onSurface,
          fontStyle: fontStyle,
        ),
        maxLines: maxLines ?? 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (noMaxLines != null) {
      return Text(
        text,
        style: textStyle(
          context,
          style,
        ).copyWith(
          fontWeight: fontWeight,
          color: color ?? context.color.onSurface,
          fontStyle: fontStyle,
        ),
        textAlign: textAlign,
      );
    }

    if (animation != null) {
      return Text(
        text,
        style: textStyle(
          context,
          style,
        ).copyWith(
          fontWeight: fontWeight,
          color: color ?? context.color.onSurface,
          fontStyle: fontStyle,
        ),
        textAlign: textAlign,
        maxLines: maxLines ?? 2,
        overflow: TextOverflow.ellipsis,
      ).animate().fadeIn().scale().move(
            delay: 300.ms,
            duration: 600.ms,
          );
    }

    return Text(
      text,
      style: textStyle(
        context,
        style,
      ).copyWith(
        fontWeight: fontWeight,
        color: color ?? context.color.onSurface,
        fontStyle: fontStyle,
      ),
      textAlign: textAlign,
      maxLines: maxLines ?? 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
