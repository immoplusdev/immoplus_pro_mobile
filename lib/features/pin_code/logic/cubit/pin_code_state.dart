part of 'pin_code_cubit.dart';

@freezed
class PinCodeState with _$PinCodeState {
  const factory PinCodeState.initial() = _Initial;
  const factory PinCodeState.loading() = _Loading;
  const factory PinCodeState.error(String message) = _Error;
  const factory PinCodeState.createPin() = _CreatePin;
  const factory PinCodeState.enterPin(List<BiometricType> biometrics) =
      _EnterPin;
  const factory PinCodeState.confirmPin() = _ConfirmPin;
  const factory PinCodeState.pinSet() = _PinSet;
  const factory PinCodeState.pinVerified() = _PinVerified;
  const factory PinCodeState.biometricAvailable(
      List<BiometricType> biometrics) = _BiometricAvailable;
}
