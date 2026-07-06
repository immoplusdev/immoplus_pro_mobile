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
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/features/shared_widgets/cgu_checkbox.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/widgets/document_upload_card.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/widgets/custom_pinput.dart';

class EnterpriseRegistrationPage extends StatefulWidget {
  final DataRouterRegistration dataRouterRegistration;
  const EnterpriseRegistrationPage({
    super.key,
    required this.dataRouterRegistration,
  });
  static String name = "Enterprise_Registration";

  @override
  State<EnterpriseRegistrationPage> createState() =>
      _EnterpriseRegistrationPageState();
}

class _EnterpriseRegistrationPageState
    extends State<EnterpriseRegistrationPage> {
  static const int _totalSteps = 3;

  final RgistrationCubitCubit _registrationCubit = RgistrationCubitCubit();

  late FormController _formController;
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  final FileUploaderController fileUploaderControllerRegistreCommerce =
      FileUploaderController();

  final FocusNode _enterpriseNameFocus = FocusNode();
  final FocusNode _enterpriseTypeFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _numeroContribuableFocus = FocusNode();
  final FocusNode _codeFocus = FocusNode();

  String? _codeError;

  @override
  void initState() {
    super.initState();
    getIt<AnalyticsService>().logKycStarted();

    _formController = FormController(
      productId: 0,
      enterpriseName: TextEditingController(text: ''),
      enterpriseType: TextEditingController(text: ''),
      numeroContribuable: TextEditingController(text: ''),
      phoneNumber: TextEditingController(
          text: widget.dataRouterRegistration.phoneNumber ?? ""),
      email: TextEditingController(text: widget.dataRouterRegistration.email),
      password: TextEditingController(text: ''),
    );
  }

  bool get _isSocialLogin => widget.dataRouterRegistration.provider != null;

  bool get _emailProvided =>
      _isSocialLogin && widget.dataRouterRegistration.email.isNotEmpty;

  @override
  void dispose() {
    _formController.enterpriseName?.dispose();
    _formController.enterpriseType?.dispose();
    _formController.numeroContribuable?.dispose();
    _formController.phoneNumber?.dispose();
    _formController.email?.dispose();
    _formController.password?.dispose();
    _enterpriseNameFocus.dispose();
    _enterpriseTypeFocus.dispose();
    _emailFocus.dispose();
    _numeroContribuableFocus.dispose();
    _codeFocus.dispose();
    _cguNotifier.dispose();
    _pageController.dispose();
    _registrationCubit.close();
    fileUploaderControllerRegistreCommerce.dispose();
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
    } else if (_currentStep == 1) {
      if (!_step2FormKey.currentState!.validate()) return;
      if (fileUploaderControllerRegistreCommerce.file == null) {
        _showErrorToast("Entrer la photo de votre registre de commerce");
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

    if (code.length != 6) {
      setState(() => _codeError = 'Le code doit contenir 6 chiffres');
      return;
    }
    if (!_cguNotifier.value) {
      EasyLoadingHandler.showErrorToast(
        text: "Les Conditions d'utilisation ne sont pas approuvées",
      );
      return;
    }

    final body = EnterpriseRegistrationBody(
      email: _formController.email!.text,
      emailEntreprise: _formController.email!.text,
      phoneNumber: widget.dataRouterRegistration.phoneNumber,
      password: code,
      nomEntreprise: _formController.enterpriseName!.text,
      typeEntreprise: _formController.enterpriseType!.text,
      numeroContribuable: _formController.numeroContribuable!.text,
      token: widget.dataRouterRegistration.token,
      provider: widget.dataRouterRegistration.provider,
    );

    _registrationCubit.createEnterpriseAccount(
      enterpriseRegistrationBody: body,
      fileUploaderController: fileUploaderControllerRegistreCommerce,
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inscription Entreprise',
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
            const Gap(24),
            _sectionTitle(
              'Votre entreprise',
              "Renseignez les informations de votre entreprise",
            ),
            const Gap(24),
            _buildOutlinedField(
              label: "Nom de l'entreprise",
              hint: "Ex: Immo Plus SARL",
              controller: _formController.enterpriseName,
              focusNode: _enterpriseNameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_enterpriseTypeFocus),
              validator: (String? value) =>
                  FormUtils.fieldValidator(value: value),
            ),
            _buildOutlinedField(
              label: "Type d'entreprise",
              hint: "Ex: SARL, SA, Agence immobilière...",
              controller: _formController.enterpriseType,
              focusNode: _enterpriseTypeFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_emailFocus),
              validator: (String? value) =>
                  FormUtils.fieldValidator(value: value),
            ),
            _buildOutlinedField(
              label: "Email",
              hint: "Ex: contact@entreprise.com",
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
    return Form(
      key: _step2FormKey,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(4),
            _sectionTitle(
              "Documents légaux",
              "Ajoutez votre registre de commerce et votre numéro contribuable",
            ),
            const Gap(20),
            DocumentUploadCard(
              controller: fileUploaderControllerRegistreCommerce,
              label: "Registre de Commerce",
              subtitle: "PNG, JPG ou PDF (Max 5Mo)",
              icon: Iconsax.document_upload,
            ),
            const Gap(20),
            _buildOutlinedField(
              label: "Numéro contribuable",
              hint: "Ex: CI-1234567 A",
              controller: _formController.numeroContribuable,
              focusNode: _numeroContribuableFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              validator: (String? value) =>
                  FormUtils.fieldValidator(value: value),
            ),
            const Gap(20),
          ],
        ),
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
                        if (isLastStep) ...[
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
                                text:
                                    isLastStep ? "Créer mon compte" : "Suivant",
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
