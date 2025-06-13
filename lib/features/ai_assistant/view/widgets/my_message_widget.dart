import 'package:budget_intelli/core/core.dart';
import 'package:budget_intelli/features/google_generative_ai/google_generative_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MyMessageWidget extends StatelessWidget {
  const MyMessageWidget({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomPaint(
        painter: BubblePainter(
          tail: true,
          alignment: Alignment.topRight,
          color: context.color.primary,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: context.screenWidth * 0.7,
          ),
          decoration: BoxDecoration(
            color: context.color.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: getEdgeInsets(
            top: 10,
            right: 15,
            left: 10,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // if (message.imagesUrls.isNotEmpty)
              //   PreviewImagesWidget(
              //     message: message,
              //   ),
              MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: textStyle(
                    context,
                    style: StyleType.bodMed,
                  ).copyWith(
                    color: context.color.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
