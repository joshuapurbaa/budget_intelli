import 'package:budget_intelli/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonLocation extends StatelessWidget {
  const ButtonLocation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state.error != null) {
          AppToast.showToastError(
            context,
            state.error ?? 'Terjadi kesalahan',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.loading;
        final location = state.transactionLocation;
        var transactionLocation = '';

        if (location != null) {
          if (location.subLocality.isNotEmpty) {
            transactionLocation +=
                '${location.subLocality}, ${location.locality}';
          } else {
            transactionLocation +=
                '${location.locality}, ${location.subAdministritiveArea}';
          }
        }
        return GestureDetector(
          onTap: isLoading
              ? null
              : () async {
                  await context.read<LocationCubit>().getCurrentLocation();
                },
          child: Container(
            padding: getEdgeInsetsAll(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.color.onInverseSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: isLoading
                ? CircularProgressIndicator.adaptive(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(context.color.onSurface),
                  )
                : location == null
                    ? Icon(
                        Icons.location_on,
                        color: context.color.onSurface,
                      )
                    : AppText(
                        text: transactionLocation,
                        style: StyleType.bodSm,
                        color: context.color.onSurface,
                        fontWeight: FontWeight.w400,
                        maxLines: 3,
                      ),
          ),
        );
      },
    );
  }
}
