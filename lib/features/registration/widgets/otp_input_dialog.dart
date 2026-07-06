import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/widgets/custom_pinput.dart';

/// Dialog de saisie du code OTP affiché après le choix du canal d'envoi.
///
/// Si [onVerify] est fourni, le code saisi lui est passé dès que les 6
/// chiffres sont entrés : un loading s'affiche pendant l'appel, le dialog se
/// ferme seulement en cas de succès, sinon un message d'erreur s'affiche et
/// l'utilisateur peut ressaisir sans que le dialog ne se ferme.
/// Sans [onVerify], le comportement historique est conservé : le dialog se
/// ferme immédiatement en retournant le code saisi (String), ou `null` si fermé.
Future<String?> showOtpInputDialog(
  BuildContext context, {
  required String phoneNumber,
  required bool isWhatsapp,
  String? errorText,
  VoidCallback? onResend,
  Future<bool> Function(String code)? onVerify,
}) {
  final otpController = TextEditingController();
  String? currentError = errorText;
  bool isVerifying = false;

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: StatefulBuilder(
          builder: (ctx, setState) {
            Future<void> handleCompleted(String code) async {
              if (onVerify == null) {
                Navigator.of(ctx).pop(code);
                return;
              }
              setState(() {
                isVerifying = true;
                currentError = null;
              });
              final success = await onVerify(code);
              if (!ctx.mounted) return;
              if (success) {
                Navigator.of(ctx).pop(code);
              } else {
                setState(() {
                  isVerifying = false;
                  currentError = 'Code invalide ou expiré. Veuillez réessayer.';
                  otpController.clear();
                });
              }
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap:
                          isVerifying ? null : () => Navigator.of(ctx).pop(),
                      child: const Icon(
                        Iconsax.close_circle,
                        size: 22,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isWhatsapp
                        ? 'Entrez le code reçu par WhatsApp'
                        : 'Entrez le code reçu par SMS',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Un code à 6 chiffres a été envoyé au $phoneNumber',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: CustomPinput(
                      controller: otpController,
                      errorText: currentError,
                      enabled: !isVerifying,
                      onChanged: (value) {
                        if (currentError != null) {
                          setState(() => currentError = null);
                        }
                      },
                      onCompleted: handleCompleted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isVerifying)
                    const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  else
                    Center(
                      child: TextButton(
                        onPressed: onResend,
                        child: Text(
                          'Renvoyer le code',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
