import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBoxUploadImage extends StatefulWidget {
  const AppBoxUploadImage({
    required this.created,
    super.key,
    this.imageBytes,
  });

  final bool created;
  final Uint8List? imageBytes;

  @override
  State<AppBoxUploadImage> createState() => _AppBoxUploadImageState();
}

class _AppBoxUploadImageState extends State<AppBoxUploadImage> {
  @override
  void initState() {
    super.initState();
    context.read<UploadImageBloc>().add(
          ResetImage(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final localize = textLocalizer(context);
    return BlocBuilder<UploadImageBloc, UploadImageState>(
      builder: (context, state) {
        String? imageUrl;
        Uint8List? imageBytes;
        var fromLocal = false;
        var created = widget.created;
        final isLoading = state is UploadImageLoading;
        final isDeleting = state is DeleteImageLoading;

        if (state is UploadImageSuccess) {
          imageUrl = state.imageUrl;
          imageBytes = state.imageBytes;
          fromLocal = state.fromLocal;
        }

        if (state is UpdateTransactionState) {
          imageBytes = state.oldImageBytes;
          fromLocal = true;
          created = false;
        }

        if (state is DeleteImageLocalSuccess) {
          imageUrl = null;
          imageBytes = null;
          fromLocal = false;
          created = false;
        }

        final isImageUploaded = imageUrl != null || imageBytes != null;

        return AppGlass(
          height: isImageUploaded ? 200 : 150,
          child: Visibility(
            visible: !isImageUploaded,
            replacement: Center(
              child: isImageUploaded
                  ? AppImagePreview(
                      imageUrl: imageUrl,
                      isDeleting: isDeleting,
                      created: created,
                      fromLocal: fromLocal,
                      imageBytes: imageBytes,
                    )
                  : const SizedBox(),
            ),
            child: GestureDetector(
              onTap: () {
                context.read<UploadImageBloc>().add(
                      PickImage(imageOf: 'receipt'),
                    );
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLoading) ...[
                      getSvgAsset(
                        cameraReceipt,
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 50,
                        height: 50,
                      ),
                      Gap.vertical(8),
                      AppText.reg12(
                        text:
                            '${localize.uploadReceiptLabel} (${localize.optional})',
                        color: context.color.onSurface.withValues(alpha: 0.5),
                      ),
                    ] else ...[
                      getLottieAsset(
                        loadingAi,
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
