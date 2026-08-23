import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/contact_change/repositories/address_repository.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:toastification/toastification.dart';

/// Modification de l'adresse (rue + ville) du pro, via
/// PATCH /users/:id (id = utilisateur connecté).
class ChangeAddressPage extends StatefulWidget {
  static const String name = 'CHANGE_ADDRESS';

  const ChangeAddressPage({super.key});

  @override
  State<ChangeAddressPage> createState() => _ChangeAddressPageState();
}

class _ChangeAddressPageState extends State<ChangeAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      EasyLoadingHandler.showLoadingToast(text: "Enregistrement...");
      await AddressRepository.updateAddress(
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
      );
      EasyLoadingHandler.hideLoadingToast();
      if (!mounted) return;
      EasyLoadingHandler.showSuccessToast(text: "Adresse enregistrée");
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
        title: const Text('Adresse'),
        backgroundColor: AppColors.whiteBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adresse :",
                          style: GoogleFonts.sen(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _addressController,
                          hint: "Rue des Jardins, Angré",
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Ville :",
                          style: GoogleFonts.sen(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildField(
                          controller: _cityController,
                          hint: "Abidjan",
                          icon: Icons.location_city_outlined,
                        ),
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
                        ? const CupertinoActivityIndicator(color: Colors.white)
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
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.sen(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      validator: (value) =>
          (value == null || value.trim().isEmpty) ? 'Ce champ est requis' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: Icon(icon, color: const Color(0xFF2563EB), size: 20),
        hintText: hint,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
