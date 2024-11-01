part of 'upload_image_bloc.dart';

@immutable
sealed class UploadImageEvent {}

class OnUpdatedTransactions extends UploadImageEvent {
  OnUpdatedTransactions(
    this.oldImageBytes, {
    required this.fromLocal,
  });

  final Uint8List? oldImageBytes;
  final bool fromLocal;
}

class PickImage extends UploadImageEvent {
  PickImage({required this.imageOf});

  final String imageOf;
}

class UploadImage extends UploadImageEvent {
  UploadImage(this.imageFile, this.imageOf);
  final File imageFile;
  final String imageOf;
}

class DeleteImageFirebase extends UploadImageEvent {
  DeleteImageFirebase(
    this.imageUrl,
  );
  final String imageUrl;
}

class DeleteImageLocal extends UploadImageEvent {
  DeleteImageLocal();
}

class ResetImage extends UploadImageEvent {}
