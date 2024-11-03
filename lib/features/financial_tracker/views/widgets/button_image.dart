import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonImage extends StatelessWidget {
  const ButtonImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadImageBloc, UploadImageState>(
      builder: (context, state) {
        String? imageUrl;
        Uint8List? imageBytes;
        var fromLocal = false;
        var created = false;
        final isLoading = state is UploadImageLoading;
        final isDeleting = state is DeleteImageLoading;

        if (state is UploadImageSuccess) {
          imageUrl = state.imageUrl;
          imageBytes = state.imageBytes;
          fromLocal = state.fromLocal;
        }

        // if (state is UpdateTransactionState) {
        //   imageBytes = state.oldImageBytes;
        //   fromLocal = true;
        //   created = false;
        // }

        if (state is DeleteImageLocalSuccess) {
          imageUrl = null;
          imageBytes = null;
          fromLocal = false;
          created = false;
        }

        final isImageUploaded = imageUrl != null || imageBytes != null;
        return Visibility(
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
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.color.onInverseSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: !isLoading
                  ? const Icon(
                      CupertinoIcons.photo_fill_on_rectangle_fill,
                    )
                  : CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.color.primary,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
