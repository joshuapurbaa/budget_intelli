part of 'upload_image_bloc.dart';

@immutable
sealed class UploadImageState {}

class UploadImageInitial extends UploadImageState {}

class UploadImagePicking extends UploadImageState {}

class UploadImageLoading extends UploadImageState {}

class DeleteImageLoading extends UploadImageState {}

class DeleteImageLocalSuccess extends UploadImageState {}

class UploadImageSuccess extends UploadImageState {
  UploadImageSuccess(
    this.imageUrl,
    this.imageBytes, {
    required this.fromLocal,
  });
  final String imageUrl;
  final Uint8List? imageBytes;
  final bool fromLocal;
}

class UpdateTransactionState extends UploadImageState {
  UpdateTransactionState(
    this.oldImageBytes, {
    required this.fromLocal,
  });

  final Uint8List? oldImageBytes;
  final bool fromLocal;
}

class UploadImageFailure extends UploadImageState {
  UploadImageFailure(this.errorMessage);
  final String errorMessage;
}
