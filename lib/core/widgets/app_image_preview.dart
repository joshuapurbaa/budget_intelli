import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppImagePreview extends StatelessWidget {
  const AppImagePreview({
    required this.imageUrl,
    required this.isDeleting,
    required this.fromLocal,
    this.imageBytes,
    super.key,
    this.created,
  });
  final String? imageUrl;
  final Uint8List? imageBytes;
  final bool isDeleting;
  final bool? created;
  final bool fromLocal;

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return Stack(
      children: [
        if (imageBytes != null || imageUrl != null)
          Align(
            child: ClipRRect(
              borderRadius: getRadius(5),
              child: fromLocal
                  ? Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        Align(
          alignment: Alignment.topRight,
          child: AppFixedContainer(
            onTap: () {
              final isCreated = created ?? false;

              if (isCreated) {
                return;
              }

              if (fromLocal) {
                if (imageBytes != null) {
                  context.read<UploadImageBloc>().add(
                        DeleteImageLocal(),
                      );
                } else {
                  context.read<UploadImageBloc>().add(
                        ResetImage(),
                      );
                }
              } else {
                context.read<UploadImageBloc>().add(
                      DeleteImageFirebase(imageUrl!),
                    );
              }
            },
            height: 25,
            width: 25,
            decoration: const BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              color: AppColor.red,
              size: 20,
            ),
          ),
        ),
        if (isDeleting)
          Positioned(
            top: 70,
            left: 20,
            child: AppBoxChild(
              padding: getEdgeInsetsAll(8),
              child: AppText.reg12(
                text: localize.deleting,
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomRight,
          child: OutlinedButton(
            onPressed: () {
              if (imageUrl != null || imageBytes != null) {
                AppDialog.showCustomDialog(
                  context,
                  content: imageBytes != null
                      ? Image.memory(imageBytes!)
                      : Image.network(imageUrl!),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: context.color.primary,
              padding: getEdgeInsetsAll(8),
            ),
            child: AppText(
              text: localize.viewImage,
              color: context.color.onPrimary,
              style: StyleType.labLg,
            ),
          ),
        ),
      ],
    );
  }
}
