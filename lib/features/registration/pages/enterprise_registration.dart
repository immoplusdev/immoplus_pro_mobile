import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/features/authentification/custom_page_immo.dart';
import 'package:immoplus_pro/features/shared_widgets/cgu_checkbox.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EnterpriseRegistrationPage extends StatefulWidget {
  final DataRouterRegistration? dataRouterRegistration;
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
  late FormController _formController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passwordConfirmNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  final FileUploaderController fileUploaderController =
      FileUploaderController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.unfocus();

    _formController = FormController(
      productId: 0,
      enterpriseName: TextEditingController(text: ''),
      enterpriseType: TextEditingController(text: ''),
      numeroContribuable: TextEditingController(text: ''),
      phoneNumber: TextEditingController(
          text: widget.dataRouterRegistration?.phoneNumber ?? ""),
      email: TextEditingController(
          text: widget.dataRouterRegistration?.email ?? ""),
      password: TextEditingController(text: ''),
    );
  }

  @override
  void dispose() {
    _formController.enterpriseName?.dispose();
    _formController.enterpriseType?.dispose();
    _formController.numeroContribuable?.dispose();
    _formController.phoneNumber?.dispose();
    _formController.email?.dispose();
    _formController.password?.dispose();
    _passwordNotifier.dispose();
    _passwordConfirmNotifier.dispose();
    _cguNotifier.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RgistrationCubitCubit(),
      child: CustomPageImmo(
        title: 'Inscription entreprise',
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverGap(20),

                // Nom de l'entreprise
                SliverToBoxAdapter(
                  child: CustomTextField(
                    controller: _formController.enterpriseName,
                    prefixIcon: const Icon(CupertinoIcons.building_2_fill),
                    labelText: "Nom de l'entreprise",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),

                // Type d'entreprise
                SliverToBoxAdapter(
                  child: CustomTextField(
                    controller: _formController.enterpriseType,
                    prefixIcon: const Icon(CupertinoIcons.briefcase),
                    labelText: "Type d'entreprise",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),

                // Numéro contribuable
                SliverToBoxAdapter(
                  child: CustomTextField(
                    controller: _formController.numeroContribuable,
                    prefixIcon: const Icon(CupertinoIcons.number_circle),
                    labelText: "Numero contribuable",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),

                // Téléphone (readonly)
                SliverToBoxAdapter(
                  child: CustomTextField(
                    readOnly: true,
                    controller: _formController.phoneNumber,
                    textInputType: TextInputType.number,
                    labelText: 'Numéro de téléphone',
                    prefixIcon: const Icon(CupertinoIcons.phone),
                    // validator: (String? value) =>
                    //     FormUtils.numberValidator(number: value),
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##########',
                        filter: {'#': RegExp(r'[0-9]')},
                      ),
                    ],
                  ),
                ),

                // Email
                SliverToBoxAdapter(
                  child: CustomTextField(
                    controller: _formController.email,
                    prefixIcon: const Icon(CupertinoIcons.mail),
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    validator: (String? value) =>
                        FormUtils.emailValidator(email: value),
                  ),
                ),

                // Mot de passe
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _passwordNotifier,
                    builder: (BuildContext context, bool value, child) {
                      return CustomTextField(
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        controller: _formController.password,
                        obscureText: !value,
                        sufixIcon: IconButton(
                          onPressed: () {
                            _passwordNotifier.value = !value;
                          },
                          icon: Icon(
                            value
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                        ),
                        labelText: 'Mot de passe',
                        validator: (String? value) =>
                            FormUtils.passwordValidator(password: value),
                      );
                    },
                  ),
                ),

                // Confirmation mot de passe
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _passwordConfirmNotifier,
                    builder: (BuildContext context, bool value, child) {
                      return CustomTextField(
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        obscureText: !value,
                        sufixIcon: IconButton(
                          onPressed: () {
                            _passwordConfirmNotifier.value = !value;
                          },
                          icon: Icon(
                            value
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                        ),
                        labelText: 'Confirmation du mot de passe',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          } else if (value != _formController.password!.text) {
                            return 'Le mot de passe ne correspond pas';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),

                // CGU Checkbox
                SliverToBoxAdapter(
                  child: CguCheckbox(cguNotifier: _cguNotifier),
                ),

                // File Uploader
                SliverToBoxAdapter(
                  child: FileUploader(
                    fileUploaderController: fileUploaderController,
                    title: "Registre de Commerce",
                  ),
                ),

                const SliverGap(20),

                // Bouton de soumission
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<RgistrationCubitCubit,
                        RegistrationCubitState>(
                      builder: (context, state) {
                        return CustomLoadingButtom(
                          isLoading: (state is REGISTRATION_LOADING),
                          onClick: ((state is REGISTRATION_LOADING))
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (!_cguNotifier.value) {
                                      EasyLoading.instance.backgroundColor =
                                          Colors.red.shade400;
                                      EasyLoading.showToast(
                                        "Les Conditions d'utilisation ne sont pas approuvées",
                                        toastPosition:
                                            EasyLoadingToastPosition.bottom,
                                      );
                                    } else if (fileUploaderController.file ==
                                        null) {
                                      EasyLoading.instance.backgroundColor =
                                          Colors.red.shade400;
                                      EasyLoading.showToast(
                                        "Entrer la photo de votre registre de commerce",
                                        toastPosition:
                                            EasyLoadingToastPosition.bottom,
                                      );
                                    } else {
                                      String? registre = await uploadFile(
                                        file: fileUploaderController.file!,
                                      );

                                      final body = EnterpriseRegistrationBody(
                                        email: _formController.email!.text,
                                        registreCommerceId: registre,
                                        phoneNumber:
                                            _formController.phoneNumber!.text,
                                        password:
                                            _formController.password!.text,
                                        nomEntreprise: _formController
                                            .enterpriseName!.text,
                                        emailEntreprise:
                                            _formController.email!.text,
                                        numeroContribuable: _formController
                                            .numeroContribuable!.text,
                                        typeEntreprise: _formController
                                            .enterpriseType!.text,
                                        token: widget.dataRouterRegistration
                                                ?.token ??
                                            "",
                                        provider: widget
                                            .dataRouterRegistration?.provider,
                                      );

                                      if (!context.mounted) return;
                                      context
                                          .read<RgistrationCubitCubit>()
                                          .createEnterpriseAccount(
                                            enterpriseRegistrationBody: body,
                                            fileUploaderController:
                                                fileUploaderController,
                                          );
                                    }
                                  }
                                },
                          text: "Creer mon compte",
                        );
                      },
                    ),
                  ),
                ),

                const SliverGap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
