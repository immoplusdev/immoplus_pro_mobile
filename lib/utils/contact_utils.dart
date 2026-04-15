import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/svgs_icons.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/utils.dart';

class ContactUtils {
  static showContact({String? id}) => showModalBottomSheet(
        context: NavigationService.navigatorKey.currentContext!,
        showDragHandle: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.message_question,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Besoin d'aide ?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Notre équipe est là pour vous accompagner",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // WhatsApp
              _buildContactItem(
                context: context,
                icon: Iconsax.message,
                iconColor: const Color(0xFF25D366),
                title: "Écrivez-nous sur WhatsApp",
                onTap: () {
                  Navigator.pop(context);
                  Utils.whatsapp(
                    phoneNumber: getIt<SessionManager>()
                        .configModel!
                        .data!
                        .contactPhoneNumber,
                  );
                },
              ),
              const SizedBox(height: 12),

              // Call
              _buildContactItem(
                context: context,
                icon: Iconsax.call,
                iconColor: AppColors.primary,
                title: "Appeler le service client",
                onTap: () {
                  Navigator.pop(context);
                  Utils.makePhoneCall(
                    getIt<SessionManager>()
                        .configModel!
                        .data!
                        .contactPhoneNumber,
                  );
                },
              ),
              const SizedBox(height: 12),

              // Email
              _buildContactItem(
                context: context,
                icon: Iconsax.sms,
                iconColor: const Color(0xFFEB4132),
                title: "Envoyez-nous un e-mail",
                onTap: () {
                  Navigator.pop(context);
                  if (id != null) {
                    Utils.bookingMail(
                      id: id,
                      email: getIt<SessionManager>()
                          .configModel!
                          .data!
                          .contactEmail,
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );

  static Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              color: Colors.grey.shade300,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
