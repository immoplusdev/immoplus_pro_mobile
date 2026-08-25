import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/payment_method/repositories/payment_method_repository.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:toastification/toastification.dart';

class _PaymentMethodOption {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _PaymentMethodOption({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
}

/// Valeurs de l'enum backend `PaymentMethod` (moyenPaiementType).
const List<_PaymentMethodOption> _paymentMethodOptions = [
  _PaymentMethodOption(value: 'orange', label: 'Orange Money', icon: Iconsax.wallet_money, color: Color(0xFFFF6600)),
  _PaymentMethodOption(value: 'mtn', label: 'MTN MoMo', icon: Iconsax.wallet_money, color: Color(0xFFFFC107)),
  _PaymentMethodOption(value: 'moov', label: 'Moov Money', icon: Iconsax.wallet_money, color: Color(0xFF0057A0)),
  _PaymentMethodOption(value: 'wave', label: 'Wave', icon: Iconsax.wallet_money, color: Color(0xFF1DC8F2)),
  _PaymentMethodOption(value: 'ecobank', label: 'Ecobank', icon: Iconsax.bank, color: Color(0xFF00A651)),
  _PaymentMethodOption(value: 'cash', label: 'Espèces', icon: Iconsax.money, color: Color(0xFF1CA53F)),
  _PaymentMethodOption(value: 'visa_card', label: 'Carte Visa', icon: Iconsax.card, color: Color(0xFF1A1F71)),
  _PaymentMethodOption(value: 'visa_card_retrait', label: 'Carte Visa (retrait)', icon: Iconsax.card, color: Color(0xFF1A1F71)),
];

/// Permet au pro de définir/modifier le moyen de paiement (type + numéro ou
/// identifiant équivalent) sur lequel il reçoit ses paiements. Consomme
/// GET/POST /payments/proprietaire/moyen-paiement.
class ChangePaymentMethodPage extends StatefulWidget {
  static const String name = 'CHANGE_PAYMENT_METHOD';

  const ChangePaymentMethodPage({super.key});

  @override
  State<ChangePaymentMethodPage> createState() =>
      _ChangePaymentMethodPageState();
}

class _ChangePaymentMethodPageState extends State<ChangePaymentMethodPage> {
  late final TextEditingController _numeroController;
  String? _selectedType;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _numeroController = TextEditingController();
    _loadCurrentMethod();
  }

  @override
  void dispose() {
    _numeroController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentMethod() async {
    try {
      final data = await PaymentMethodRepository.getMoyenPaiement();
      if (!mounted) return;
      _selectedType = data.moyenPaiementType;
      if (data.moyenPaiementNumero != null) {
        _numeroController.text = data.moyenPaiementNumero!;
      }
    } catch (_) {
      // Échec silencieux : le formulaire reste vide, l'utilisateur peut
      // quand même renseigner et enregistrer son moyen de paiement.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    if (_selectedType == null) {
      toastification.show(
        type: ToastificationType.warning,
        context: context,
        title: const Text("Moyen de paiement requis"),
        description: const Text("Veuillez sélectionner un moyen de paiement."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    final numero = _numeroController.text.trim();
    if (numero.isEmpty) {
      toastification.show(
        type: ToastificationType.warning,
        context: context,
        title: const Text("Numéro requis"),
        description: const Text("Veuillez renseigner le numéro ou l'identifiant associé."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      EasyLoadingHandler.showLoadingToast(text: "Enregistrement...");
      await PaymentMethodRepository.updateMoyenPaiement(
        type: _selectedType!,
        numero: numero,
      );
      EasyLoadingHandler.hideLoadingToast();
      if (!mounted) return;
      EasyLoadingHandler.showSuccessToast(text: "Moyen de paiement enregistré");
      context.pop();
    } catch (_) {
      EasyLoadingHandler.hideLoadingToast();
      if (!mounted) return;
      toastification.show(
        type: ToastificationType.error,
        context: context,
        title: const Text("Échec de l'enregistrement"),
        description: const Text("Veuillez réessayer."),
        autoCloseDuration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        title: const Text('Moyen de paiement'),
        backgroundColor: AppColors.whiteBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Moyen utilisé pour recevoir vos paiements",
                                    style: GoogleFonts.sen(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _buildOptionsGrid(),
                                  const SizedBox(height: 22),
                                  Text(
                                    "Numéro / identifiant",
                                    style: GoogleFonts.sen(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildNumeroField(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isSaving ? null : _submit,
                        child: _isSaving
                            ? const CupertinoActivityIndicator(
                                color: Colors.white)
                            : Text(
                                "Enregistrer",
                                style: GoogleFonts.sen(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildOptionsGrid() {
    final rows = <Widget>[];
    for (var i = 0; i < _paymentMethodOptions.length; i += 2) {
      final left = _paymentMethodOptions[i];
      final right = i + 1 < _paymentMethodOptions.length
          ? _paymentMethodOptions[i + 1]
          : null;

      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 2 < _paymentMethodOptions.length ? 10 : 0,
          ),
          child: Row(
            children: [
              Expanded(child: _buildOptionTile(left)),
              const SizedBox(width: 10),
              Expanded(
                child: right != null
                    ? _buildOptionTile(right)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildOptionTile(_PaymentMethodOption option) {
    final isSelected = _selectedType == option.value;
    final fg = isSelected ? Colors.white : const Color(0xFF1E293B);

    return GestureDetector(
      onTap: () => setState(() => _selectedType = option.value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.18),
            width: 1.3,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: option.color,
                shape: BoxShape.circle,
              ),
              child: Icon(option.icon, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                option.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.sen(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumeroField() {
    return TextFormField(
      controller: _numeroController,
      style: GoogleFonts.sen(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: Icon(
          CupertinoIcons.number,
          color: AppColors.primary,
          size: 20,
        ),
        hintText: "Ex: 0700000000",
        hintStyle: GoogleFonts.sen(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
