import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/features/pin_code/data/repositories/pin_code_repository.dart';
import 'package:immoplus_pro/features/pin_code/views/services/biometry_service.dart';
import 'package:local_auth/local_auth.dart';

import 'package:injectable/injectable.dart';

part 'pin_code_state.dart';
part 'pin_code_cubit.freezed.dart';

@injectable
class PinCodeCubit extends Cubit<PinCodeState> {
  final PinCodeRepository _repository;
  final BiometryService _biometryService;

  String? _tempPin;

  PinCodeCubit(this._repository, this._biometryService)
      : super(const PinCodeState.initial());

  Future<void> checkStatus() async {
    emit(const PinCodeState.loading());
    try {
      final hasPin = await _repository.hasPin();

      if (hasPin) {
        final biometricsEnabled = await _repository.getBiometricPreference();
        final canCheckBiometrics =
            await _biometryService.isBiometricAvailable();

        if (biometricsEnabled && canCheckBiometrics) {
          final availableBiometrics =
              await _biometryService.getAvailableBiometrics();
          emit(PinCodeState.biometricAvailable(availableBiometrics));
        } else {
          final availableBiometrics =
              await _biometryService.getAvailableBiometrics();
          emit(PinCodeState.enterPin(availableBiometrics));
        }
      } else {
        emit(const PinCodeState.createPin());
      }
    } catch (e) {
      emit(PinCodeState.error(e.toString()));
    }
  }

  Future<void> setPin(String pin) async {
    state.maybeWhen(
      createPin: () {
        _tempPin = pin;
        emit(const PinCodeState.confirmPin());
      },
      confirmPin: () async {
        if (_tempPin == pin) {
          emit(const PinCodeState.loading());
          try {
            await _repository.setPin(pin);
            emit(const PinCodeState.pinSet());
            _tempPin = null;

            // Check if biometrics is available to prompt user
            final canCheckBiometrics =
                await _biometryService.isBiometricAvailable();
            if (canCheckBiometrics) {
              // We could emit a state to ask for biometric enrollment here
              // For now, we'll just leave it as pinSet which the UI handles
            }
          } catch (e) {
            emit(PinCodeState.error(e.toString()));
            emit(const PinCodeState.createPin());
            _tempPin = null;
          }
        } else {
          emit(const PinCodeState.error("Les codes PIN ne correspondent pas"));
          emit(const PinCodeState.createPin());
          _tempPin = null;
        }
      },
      orElse: () {},
    );
  }

  Future<void> verifyPin(String pin) async {
    emit(const PinCodeState.loading());
    try {
      await _repository.verifyPin(pin);
      // If verifyPin doesn't throw, it's valid
      // Save/Refresh local PIN for offline/biometric usage if needed
      await _repository.saveLocalPin(pin);
      emit(const PinCodeState.pinVerified());
    } catch (e) {
      emit(const PinCodeState.error("Code PIN incorrect"));
      // We should ideally pass the biometrics list again if we want to keep the button visible
      // For now, let's fetch it or pass empty if we don't want to show it on error (though we probably do)
      // But since we are in error state, we might transition to enterPin after a delay or immediately.
      // The UI handles error state by showing snackbar and resetting pin, but it stays in previous state?
      // No, we emit enterPin explicitly.
      final availableBiometrics =
          await _biometryService.getAvailableBiometrics();
      emit(PinCodeState.enterPin(availableBiometrics));
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      final authenticated = await _biometryService.authenticate();
      if (authenticated) {
        final localPin = await _repository.getLocalPin();
        if (localPin != null) {
          await verifyPin(localPin);
        } else {
          // Fallback if no local PIN but authenticated (shouldn't happen if logic is strict)
          // Or maybe we just trust biometrics?
          // Requirement says: "prendre de code en localstorate et lancer le /wallet/verify-pin"
          emit(
              const PinCodeState.error("Aucun code PIN enregistré localement"));
          final availableBiometrics =
              await _biometryService.getAvailableBiometrics();
          emit(PinCodeState.enterPin(availableBiometrics));
        }
      }
    } catch (e) {
      emit(PinCodeState.error(e.toString()));
      final availableBiometrics =
          await _biometryService.getAvailableBiometrics();
      emit(PinCodeState.enterPin(availableBiometrics));
    }
  }

  Future<void> enableBiometrics() async {
    await _repository.setBiometricPreference(true);
  }

  Future<void> disableBiometrics() async {
    await _repository.setBiometricPreference(false);
  }
}
