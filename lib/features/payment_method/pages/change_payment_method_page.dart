import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/payment/operator_model.dart';
import 'package:immoplus_pro/features/payment_method/repositories/payment_method_repository.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_utils.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/operator_payment.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:toastification/toastification.dart';

/// Permet au pro de définir/modifier le moyen de paiement (opérateur mobile
/// money + numéro) sur lequel il reçoit ses paiements. Consomme
/// GET/POST /payments/proprietaire/moyen-paiement.
class ChangePaymentMethodPage extends StatefulWidget {
  static const String name = 'CHANGE_PAYMENT_METHOD';

  const ChangePaymentMethodPage({super.key});

  @override
  State<ChangePaymentMethodPage> createState() =>
      _ChangePaymentMethodPageState();
}

class _ChangePaymentMethodPageState extends State<ChangePaymentMethodPage> {
  late final TextEditingController _phoneController;
  OperatorModel? _selectedOperator;
  bool _isLoading = true;
  bool _isSaving = false;

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '## ## ## ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _loadCurrentMethod();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentMethod() async {
    try {
      final data = await PaymentMethodRepository.getMoyenPaiement();
      if (!mounted) return;
      if (data.moyenPaiementType != null) {
        _selectedOperator = OrderPaymentController.retraitOperatorsItems
            .firstWhereOrNull((op) => op.value == data.moyenPaiementType);
      }
      if (data.moyenPaiementNumero != null) {
        _phoneController.text = data.moyenPaiementNumero!;
      }
    } catch (_) {
      // Échec silencieux : le formulaire reste vide, l'utilisateur peut
      // quand même renseigner et enregistrer son moyen de paiement.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    if (_selectedOperator == null) {
      toastification.show(
        type: ToastificationType.warning,
        context: context,
        title: const Text("Opérateur requis"),
        description: const Text("Veuillez sélectionner un opérateur."),
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    final rawPhone = _phoneController.text.replaceAll(' ', '');
    final validationErr = PaymentUtils.numberValidator(
      number: rawPhone,
      operatorName: _selectedOperator!.value,
    );
    if (validationErr != null) {
      toastification.show(
        type: ToastificationType.error,
        context: context,
        title: const Text("Numéro invalide"),
        description: Text(validationErr),
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      EasyLoadingHandler.showLoadingToast(text: "Enregistrement...");
      await PaymentMethodRepository.updateMoyenPaiement(
        type: _selectedOperator!.value,
        numero: rawPhone,
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
      backgroundColor: Colors.white,
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
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Opérateur mobile money utilisé pour recevoir vos paiements :",
                              style: GoogleFonts.sen(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildOperatorSelectorRow(),
                            const SizedBox(height: 24),
                            Text(
                              "Numéro associé :",
                              style: GoogleFonts.sen(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildPhoneInputField(),
                          ],
                        ),
                      ),
                    ),
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

  Widget _buildOperatorSelectorRow() {
    return Row(
      spacing: 10,
      children:
          OrderPaymentController.retraitOperatorsItems.map((operator) {
        final isSelected = _selectedOperator == operator;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedOperator = operator),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 66,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: isSelected ? 2.0 : 0.0,
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(operator.logo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhoneInputField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.sen(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      inputFormatters: [_phoneFormatter],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: const Icon(
          CupertinoIcons.phone,
          color: Color(0xFF2563EB),
          size: 20,
        ),
        hintText: "07 00 00 00 00",
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
