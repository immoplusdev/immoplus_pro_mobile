// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/particulier_registration_body.dart';
import 'package:immoplus_pro/features/shared_widgets/cgu_checkbox.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/widgets/document_upload_card.dart';
import 'package:immoplus_pro/features/registration/widgets/identity_photo_picker.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/widgets/custom_pinput.dart';

class ParticulierRegistration extends StatefulWidget {
  final DataRouterRegistration dataRouterRegistration;
  const ParticulierRegistration({
    super.key,
    required this.dataRouterRegistration,
  });
  static String name = "Particulier_Registration";

  @override
  State<ParticulierRegistration> createState() =>
      _ParticulierRegistrationState();
}

class _ParticulierRegistrationState extends State<ParticulierRegistration> {
  static const int _totalSteps = 3;

  final RgistrationCubitCubit _registrationCubit = RgistrationCubitCubit();

  late FormController _formController;
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  final FileUploaderController fileUploaderControllerPhotoIdentite =
      FileUploaderController();
  final FileUploaderController fileUploaderControllerPieceIdentite =
      FileUploaderController();
  final FileUploaderController fileUploaderControllerPieceIdentiteVerso =
      FileUploaderController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _activityFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _codeFocus = FocusNode();

  String? _codeError;
  // String? _codeConfirmError; // confirmation du code désactivée

  @override
  void initState() {
    super.initState();

    _formController = FormController(
      productId: 0,
      firstName: TextEditingController(
          text: widget.dataRouterRegistration.firstName ?? ""),
      lastName: TextEditingController(
        text: widget.dataRouterRegistration.lastName ?? '',
      ),
      activity: TextEditingController(text: ''),
      phoneNumber: TextEditingController(
          text: widget.dataRouterRegistration.phoneNumber ?? ""),
      email: TextEditingController(text: widget.dataRouterRegistration.email),
      password: TextEditingController(text: ''),
      // passwordConfirm: TextEditingController(text: ''), // confirmation désactivée
    );
  }

  bool get _isSocialLogin => widget.dataRouterRegistration.provider != null;

  bool get _firstNameProvided =>
      _isSocialLogin &&
      (widget.dataRouterRegistration.firstName ?? '').isNotEmpty;

  bool get _lastNameProvided =>
      _isSocialLogin &&
      (widget.dataRouterRegistration.lastName ?? '').isNotEmpty;

  bool get _emailProvided =>
      _isSocialLogin && widget.dataRouterRegistration.email.isNotEmpty;

  @override
  void dispose() {
    _formController.firstName?.dispose();
    _formController.lastName?.dispose();
    _formController.activity?.dispose();
    _formController.phoneNumber?.dispose();
    _formController.email?.dispose();
    _formController.password?.dispose();
    // _formController.passwordConfirm?.dispose(); // confirmation désactivée
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _activityFocus.dispose();
    _emailFocus.dispose();
    _codeFocus.dispose();
    _cguNotifier.dispose();
    _pageController.dispose();
    _registrationCubit.close();
    fileUploaderControllerPhotoIdentite.dispose();
    fileUploaderControllerPieceIdentite.dispose();
    fileUploaderControllerPieceIdentiteVerso.dispose();
    super.dispose();
  }

  void _showErrorToast(String message) {
    EasyLoading.instance.backgroundColor = Colors.red.shade400;
    EasyLoading.showToast(
      message,
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }

  void _goBack() {
    if (_currentStep == 0) {
      context.pop();
      return;
    }
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goNext() {
    FocusScope.of(context).unfocus();

    if (_currentStep == 0) {
      if (!_step1FormKey.currentState!.validate()) return;
      if (fileUploaderControllerPhotoIdentite.file == null) {
        _showErrorToast("Entrer une photo de vous");
        return;
      }
    } else if (_currentStep == 1) {
      if (fileUploaderControllerPieceIdentite.file == null) {
        _showErrorToast("Entrer la photo de votre pièce d'identité");
        return;
      }
      if (fileUploaderControllerPieceIdentiteVerso.file == null) {
        _showErrorToast("Entrer la photo verso de votre pièce d'identité");
        return;
      }
      if (!_cguNotifier.value) {
        EasyLoadingHandler.showErrorToast(
          text: "Les Conditions d'utilisation ne sont pas approuvées",
        );
        return;
      }
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submit() async {
    final code = _formController.password!.text;
    // final confirmCode = _formController.passwordConfirm!.text; // confirmation désactivée

    if (code.length != 6) {
      setState(() => _codeError = 'Le code doit contenir 6 chiffres');
      return;
    }
    // if (code != confirmCode) {
    //   setState(() => _codeConfirmError = 'Les codes ne correspondent pas');
    //   return;
    // }

    // Les fichiers (photo, recto, verso) sont uploadés une seule fois,
    // directement par le cubit ci-dessous (createParticulierAccount).
    final body = ParticulierRegistrationBody(
      firstName: _formController.firstName!.text,
      lastName: _formController.lastName!.text,
      email: _formController.email!.text,
      phoneNumber: _formController.phoneNumber!.text,
      password: code,
      activite: _formController.activity!.text,
      token: widget.dataRouterRegistration.token,
      provider: widget.dataRouterRegistration.provider,
    );

    _registrationCubit.createParticulierAccount(
      particulierRegistrationBody: body,
      fileUploaderControllerPhotoIdentite: fileUploaderControllerPhotoIdentite,
      fileUploaderControllerPieceIdentite: fileUploaderControllerPieceIdentite,
      fileUploaderControllerPieceIdentiteVerso:
          fileUploaderControllerPieceIdentiteVerso,
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inscription Pro Particulier',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_totalSteps, (index) {
              final isActive = index <= _currentStep;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index == _totalSteps - 1 ? 0 : 6,
                  ),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Gap(6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildOutlinedField({
    required String label,
    required String hint,
    required TextEditingController? controller,
    bool isEnabled = true,
    String? Function(String?)? validator,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
          const Gap(8),
          TextFormField(
            controller: controller,
            enabled: isEnabled,
            validator: validator,
            focusNode: focusNode,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              errorStyle: const TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _step1FormKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Gap(4),
            // _sectionTitle(
            //   'Vos informations',
            //   "Ajoutez votre photo et vos informations personnelles",
            // ),
            const Gap(24),
            Center(
              child: IdentityPhotoPicker(
                controller: fileUploaderControllerPhotoIdentite,
                label: "Photo d'identité (selfie)",
                placeholderText: "Ajouter une photo d'identité",
                helperText: "Assurez-vous que votre visage est bien éclairé.",
              ),
            ),
            const Gap(28),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildOutlinedField(
                    label: "Nom",
                    hint: "Ex: Dupont",
                    controller: _formController.firstName,
                    isEnabled: !_firstNameProvided,
                    focusNode: _firstNameFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_lastNameFocus),
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: _buildOutlinedField(
                    label: "Prénom",
                    hint: "Ex: Jean",
                    controller: _formController.lastName,
                    isEnabled: !_lastNameProvided,
                    focusNode: _lastNameFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_activityFocus),
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),
              ],
            ),
            _buildOutlinedField(
              label: "Profession",
              hint: "Ex: Architecte, Consultant...",
              controller: _formController.activity,
              focusNode: _activityFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_emailFocus),
              validator: (String? value) =>
                  FormUtils.fieldValidator(value: value),
            ),
            _buildOutlinedField(
              label: "Email",
              hint: "Ex: jean.dupont@email.com",
              controller: _formController.email,
              isEnabled: !_emailProvided,
              focusNode: _emailFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              validator: (String? value) =>
                  FormUtils.emailValidator(email: value),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(4),
          _sectionTitle(
            "Pièce d'identité",
            "Ajoutez le recto et le verso de votre pièce d'identité",
          ),
          const Gap(20),
          DocumentUploadCard(
            controller: fileUploaderControllerPieceIdentite,
            label: "Recto",
            subtitle: "PNG, JPG ou PDF (Max 5Mo)",
            icon: Iconsax.gallery_add,
          ),
          const Gap(20),
          DocumentUploadCard(
            controller: fileUploaderControllerPieceIdentiteVerso,
            label: "Verso",
            subtitle: "PNG, JPG ou PDF (Max 5Mo)",
            icon: Iconsax.gallery_add,
          ),
          const Gap(20),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'CODE DE SÉCURITÉ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 0.4,
            ),
          ),
          const Gap(32),
          CustomPinput(
            controller: _formController.password!,
            focusNode: _codeFocus,
            width: 55,
            height: 55,
            fontSize: 24,
            errorText: _codeError,
            onChanged: (_) {
              if (_codeError != null) setState(() => _codeError = null);
            },
          ),
          // Confirmation du code désactivée : un seul code suffit désormais.
          // const Gap(24),
          // Text(
          //   'Confirmer le code',
          //   style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          // ),
          // const Gap(10),
          // Center(
          //   child: CustomPinput(
          //     controller: _formController.passwordConfirm!,
          //     errorText: _codeConfirmError,
          //     onChanged: (_) {
          //       if (_codeConfirmError != null) {
          //         setState(() => _codeConfirmError = null);
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _registrationCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: GestureDetector(
              onTap: _goBack,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(
                  Iconsax.arrow_left_2,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentStep = index);
                    if (index == 2) {
                      Future.delayed(const Duration(milliseconds: 250), () {
                        if (mounted) _codeFocus.requestFocus();
                      });
                    }
                  },
                  children: [
                    _buildStep1(),
                    _buildStep2(),
                    _buildStep3(),
                  ],
                ),
              ),
              BlocBuilder<RgistrationCubitCubit, RegistrationCubitState>(
                builder: (context, state) {
                  final isLoading = state is REGISTRATION_LOADING;
                  final isLastStep = _currentStep == _totalSteps - 1;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_currentStep == 1) ...[
                          CguCheckbox(cguNotifier: _cguNotifier),
                          const Gap(12),
                        ],
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: isLoading ? null : _goBack,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        radiusButton,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Retour',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(12),
                            Expanded(
                              flex: 2,
                              child: CustomLoadingButtom(
                                text: isLastStep
                                    ? "Créer mon compte"
                                    : "Suivant",
                                isLoading: isLoading,
                                onClick: isLoading
                                    ? null
                                    : (isLastStep ? _submit : _goNext),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
