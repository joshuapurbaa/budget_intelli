import 'package:budget_intelli/features/financial_tracker/financial_tracker_barrel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(const LocationState());

  Future<void> getCurrentLocation() async {
    emit(
      state.copyWith(
        loading: true,
      ),
    );
    try {
      // Meminta izin lokasi
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              error: 'Izin lokasi tidak diberikan.',
            ),
          );
          return;
        }
      }

      // Mendapatkan koordinat lokasi
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Mendapatkan alamat dari koordinat
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        emit(
          state.copyWith(
            transactionLocation: TransactionLocation.fromPlacemark(place),
          ),
        );
      } else {
        emit(
          state.copyWith(
            error: 'Tidak dapat menemukan alamat',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Terjadi kesalahan saat mendapatkan lokasi',
        ),
      );
    } finally {
      emit(
        state.copyWith(
          loading: false,
        ),
      );
    }
  }

  Future<void> resetLocation() async {
    emit(
      const LocationState(),
    );
  }
}
