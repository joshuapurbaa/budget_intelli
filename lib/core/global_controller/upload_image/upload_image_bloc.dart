import 'dart:io';
import 'dart:typed_data';

import 'package:budget_intelli/core/core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'upload_image_event.dart';
part 'upload_image_state.dart';

class UploadImageBloc extends Bloc<UploadImageEvent, UploadImageState> {
  UploadImageBloc() : super(UploadImageInitial()) {
    on<PickImage>(_onPickImage);
    on<UploadImage>(_onUploadImage);
    on<DeleteImageFirebase>(_deleteImageFromFirebase);
    on<ResetImage>((event, emit) {
      emit(UploadImageInitial());
    });
    on<DeleteImageLocal>(_onDeleteImageLocal);
    on<OnUpdatedTransactions>(_onUpdatedTransactions);
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> _onPickImage(
    PickImage event,
    Emitter<UploadImageState> emit,
  ) async {
    emit(UploadImagePicking());
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
      );
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        // Baca file sebagai bytes
        final imageBytes = await imageFile.readAsBytes();

        // Konversi bytes menjadi Uint8List
        final uint8list = Uint8List.fromList(imageBytes);
        emit(
          UploadImageSuccess(
            pickedFile.path,
            uint8list,
            fromLocal: true,
          ),
        );
        // add(
        //   UploadImage(
        //     imageFile,
        //     event.imageOf,
        //   ),
        // );
      } else {
        emit(UploadImageInitial());
      }
    } catch (e, s) {
      appLogger(
        from: '_onPickImage',
        error: e,
        stackTrace: s,
      );
      emit(UploadImageFailure('Gagal memilih gambar'));
    }
  }

  Future<void> _onUploadImage(
    UploadImage event,
    Emitter<UploadImageState> emit,
  ) async {
    emit(UploadImageLoading());

    try {
      // final imageUrl = await _uploadImageToFirebase(
      //   event.imageFile,
      //   event.imageOf,
      // );
      // emit(UploadImageSuccess(imageUrl));
    } on FirebaseException catch (e, s) {
      appLogger(
        from: '_onUploadImage FirebaseException',
        error: e,
        stackTrace: s,
      );
      emit(UploadImageFailure(e.message ?? 'Gagal upload gambar'));
    } catch (e, s) {
      appLogger(
        from: '_onUploadImage',
        error: e,
        stackTrace: s,
      );
      emit(UploadImageFailure('Gagal upload gambar'));
    }
  }

  // Future<String> _uploadImageToFirebase(File imageFile, String imageOf) async {
  //   try {
  //     final storageReference = _storage
  //         .ref()
  //         .child('images')
  //         .child('$imageOf/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     final uploadTask = storageReference.putFile(imageFile);
  //     final taskSnapshot = await uploadTask;
  //     final imageUrl = await taskSnapshot.ref.getDownloadURL();

  //     return imageUrl;
  //   } catch (e, s) {
  //     appLogger(
  //       from: '_uploadImageToFirebase',
  //       error: e,
  //       stackTrace: s,
  //     );
  //     rethrow;
  //   }
  // }

  Future<void> _deleteImageFromFirebase(
    DeleteImageFirebase event,
    Emitter<UploadImageState> emit,
  ) async {
    try {
      emit(DeleteImageLoading());
      final storageReference = _storage.refFromURL(event.imageUrl);
      await storageReference.delete();
      emit(UploadImageInitial());
    } catch (e) {
      throw Exception('Gagal menghapus gambar: $e');
    }
  }

  Future<void> _onDeleteImageLocal(
    DeleteImageLocal event,
    Emitter<UploadImageState> emit,
  ) async {
    emit(DeleteImageLocalSuccess());
  }

  Future<void> _onUpdatedTransactions(
    OnUpdatedTransactions event,
    Emitter<UploadImageState> emit,
  ) async {
    emit(
      UpdateTransactionState(
        event.oldImageBytes,
        fromLocal: event.fromLocal,
      ),
    );
  }
}
