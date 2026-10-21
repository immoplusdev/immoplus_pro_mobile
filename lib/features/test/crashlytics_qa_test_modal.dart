import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/services/crashlytics_service.dart';

/// Modal de test Crashlytics exclusivement réservé aux builds DEV / QA.
/// En production (`kReleaseMode`), ce composant et ses déclencheurs sont inactifs.
class CrashlyticsQaTestModal extends StatefulWidget {
  const CrashlyticsQaTestModal({super.key});

  static Future<void> show(BuildContext context) {
    if (kReleaseMode) {
      return Future.value();
    }
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CrashlyticsQaTestModal(),
    );
  }

  @override
  State<CrashlyticsQaTestModal> createState() => _CrashlyticsQaTestModalState();
}

class _CrashlyticsQaTestModalState extends State<CrashlyticsQaTestModal> {
  final _crashlyticsService = getIt<CrashlyticsService>();
  bool _isCollectionEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadConsent();
  }

  Future<void> _loadConsent() async {
    final enabled = await _crashlyticsService.isCollectionEnabled();
    if (mounted) {
      setState(() => _isCollectionEnabled = enabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(16),
          Row(
            children: [
              Icon(
                Iconsax.warning_2,
                color: AppColors.redFF0000,
                size: 24,
              ),
              const Gap(10),
              const Expanded(
                child: Text(
                  'Crashlytics QA Tests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'DEV/QA ONLY',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.redFF0000,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            'Utilisez ces déclencheurs pour vérifier l\'intégration Crashlytics dans la console Firebase (rapports, version, stack traces).',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const Gap(20),
          // Toggle de consentement / collecte
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _isCollectionEnabled,
            activeTrackColor: AppColors.primary,
            title: const Text(
              'Collecte Crashlytics active',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.slate800,
              ),
            ),
            subtitle: Text(
              'Simuler le consentement de l\'utilisateur',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            onChanged: (val) async {
              await _crashlyticsService.setCollectionEnabled(val);
              setState(() => _isCollectionEnabled = val);
              EasyLoading.showToast(
                val ? 'Collecte activée' : 'Collecte désactivée',
              );
            },
          ),
          const Divider(height: 24),
          // Bouton 1: Erreur non fatale
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.black87,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Iconsax.info_circle, size: 20),
            label: const Text('Tester une erreur non fatale'),
            onPressed: () async {
              EasyLoading.show(status: 'Envoi en cours...');
              await _crashlyticsService.triggerControlledNonFatalError();
              EasyLoading.dismiss();
              EasyLoading.showSuccess('Erreur non fatale enregistrée !');
            },
          ),
          const Gap(12),
          // Bouton 2: Erreur asynchrone non interceptée
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade50,
              foregroundColor: Colors.orange.shade800,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Iconsax.flash, size: 20),
            label: const Text('Tester une erreur asynchrone'),
            onPressed: () {
              Navigator.of(context).pop();
              EasyLoading.showToast(
                'Exception asynchrone déclenchée dans 100ms...',
              );
              _crashlyticsService.triggerControlledAsyncError();
            },
          ),
          const Gap(12),
          // Bouton 3: Crash fatal immédiat
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redFF0000,
              foregroundColor: AppColors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Iconsax.danger, size: 20),
            label: const Text('Déclencher un crash fatal (force crash)'),
            onPressed: () {
              Navigator.of(context).pop();
              _crashlyticsService.triggerControlledFatalCrash();
            },
          ),
          const Gap(30),
        ],
      ),
    );
  }
}
