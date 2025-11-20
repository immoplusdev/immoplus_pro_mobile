// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/particulier_registration_body.dart';
import 'package:immoplus_pro/features/registration/pages/verify_email_otp_page.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/features/account/widgets/general_condition_page.dart';
import 'package:immoplus_pro/features/registration/registration_main_screen.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ParticulierRegistration extends StatefulWidget {
  final DataRouterRegistration dataRouterRegistration;
  const ParticulierRegistration(
      {super.key, required this.dataRouterRegistration});
  static String name = "Particulier_Registration";
  @override
  State<ParticulierRegistration> createState() =>
      _ParticulierRegistrationState();
}

class _ParticulierRegistrationState extends State<ParticulierRegistration> {
  late FormController _formController;
  late GlobalKey<FormState> _formKey;
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passworConfirmdNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  final FileUploaderController fileUploaderControllerPhotoIdentite =
      FileUploaderController();
  final FileUploaderController fileUploaderControllerPieceIdentite =
      FileUploaderController();
  final int _selectedCity = 0;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _formController = FormController(
      productId: 0,
      firstName: TextEditingController(text: ''),
      lastName: TextEditingController(text: ''),
      activity: TextEditingController(text: ''),
      phoneNumber: TextEditingController(text: ''),
      email: TextEditingController(text: widget.dataRouterRegistration.email),
      password: TextEditingController(text: ''),
    );
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RgistrationCubitCubit(),
      child: Scaffold(
          backgroundColor: AppColors.scafold,
          appBar: AppBar(
            backgroundColor: AppColors.scafold,
            title: const Text('Inscription particulier'),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                size: 30,
              ),
              onPressed: () async {
                context.goNamed(RegistrationMainScreean.name);
              },
            ),
            actions: const [
              Icon(FontAwesomeIcons.userTie),
              Gap(20),
            ],
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: FileUploader(
                            width: 150,
                            fileUploaderController:
                                fileUploaderControllerPhotoIdentite,
                            title: "Photo d'identité",
                            iconPlaceholder: FontAwesomeIcons.idBadge,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: FileUploader(
                            width: 150,
                            fileUploaderController:
                                fileUploaderControllerPieceIdentite,
                            title: "Pièce d'identité",
                            iconPlaceholder: FontAwesomeIcons.idCard,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(child: Gap(10)),
                  SliverToBoxAdapter(
                    child: CustomTextField(
                      controller: _formController.firstName,
                      prefixIcon: const Icon(FontAwesomeIcons.user),
                      labelText: "Nom",
                      validator: (String? value) =>
                          FormUtils.fieldValidator(value: value),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomTextField(
                      controller: _formController.lastName,
                      prefixIcon: const Icon(FontAwesomeIcons.user),
                      labelText: "Prénom",
                      validator: (String? value) =>
                          FormUtils.fieldValidator(value: value),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomTextField(
                      controller: _formController.activity,
                      prefixIcon: const Icon(CupertinoIcons.briefcase),
                      labelText: "Activité",
                      validator: (String? value) =>
                          FormUtils.fieldValidator(value: value),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomTextField(
                      controller: _formController.phoneNumber,
                      textInputType: TextInputType.number,
                      labelText: 'Numéro de téléphone',
                      prefixIcon: const Icon(CupertinoIcons.phone),
                      validator: (String? value) =>
                          FormUtils.numberValidator(number: value),
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '##########',
                          filter: {'#': RegExp(r'[0-9]')},
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomTextField(
                      focusNode: _emailFocus,
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordFocus),
                      controller: _formController.email,
                      prefixIcon: const Icon(CupertinoIcons.mail),
                      labelText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      validator: (String? value) =>
                          FormUtils.emailValidator(email: value),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: _passwordNotifier,
                        builder: (BuildContext context, bool value, child) {
                          return CustomTextField(
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordConfirmFocus);
                            },
                            controller: _formController.password,
                            obscureText: !_passwordNotifier.value,
                            prefixIcon: const Icon(CupertinoIcons.lock),
                            sufixIcon: IconButton(
                                onPressed: () {
                                  _passwordNotifier.value =
                                      !_passwordNotifier.value;
                                },
                                icon: Icon(
                                  (_passwordNotifier.value)
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                )),
                            labelText: 'Mot de passe',
                            validator: (String? value) =>
                                FormUtils.passwordValidator(password: value),
                          );
                        }),
                  ),
                  SliverToBoxAdapter(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: _passworConfirmdNotifier,
                        builder: (BuildContext context, bool value, child) {
                          return CustomTextField(
                            focusNode: _passwordConfirmFocus,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: _formController.passwordConfirm,
                            obscureText: !_passworConfirmdNotifier.value,
                            prefixIcon: const Icon(CupertinoIcons.lock),
                            sufixIcon: IconButton(
                                onPressed: () {
                                  _passworConfirmdNotifier.value =
                                      !_passworConfirmdNotifier.value;
                                },
                                icon: Icon(
                                  (_passworConfirmdNotifier.value)
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                )),
                            labelText: 'Confirmation du mot de passe',
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un mot de passe';
                              } else if (value !=
                                  _formController.password!.text) {
                                return 'Le mot de passe ne correspond pas';
                              }
                              return null;
                            },
                          );
                        }),
                  ),
                  SliverToBoxAdapter(
                    child: ValueListenableBuilder<bool>(
                        valueListenable: _cguNotifier,
                        builder: (BuildContext context, bool value, child) {
                          return Row(
                            children: [
                              Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  value: value,
                                  fillColor: value
                                      ? WidgetStateProperty.all(
                                          Theme.of(context).colorScheme.primary)
                                      : WidgetStateProperty.all(Colors.white),
                                  onChanged: (val) {
                                    _cguNotifier.value = !_cguNotifier.value;
                                  }),
                              const Text("j'approuve les"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const GeneralConditionPage(),
                                        ));
                                  },
                                  child: Text(
                                    'Termes & conditions',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ))
                            ],
                          );
                        }),
                  ),
                  const SliverGap(10),
                  SliverPadding(
                    padding: const EdgeInsets.all(5.0),
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
                                        EasyLoadingHandler.showErrorToast(
                                          text:
                                              "Les Conditions d'utilisation ne sont pas approuvées",
                                          // toastPosition:
                                          //     EasyLoadingToastPosition.bottom
                                        );
                                      } else if (fileUploaderControllerPhotoIdentite
                                              .file ==
                                          null) {
                                        EasyLoading.instance.backgroundColor =
                                            Colors.red.shade400;
                                        EasyLoading.showToast(
                                            "Entrer une photo de vous",
                                            toastPosition:
                                                EasyLoadingToastPosition
                                                    .bottom);
                                      } else if (fileUploaderControllerPieceIdentite
                                              .file ==
                                          null) {
                                        EasyLoading.instance.backgroundColor =
                                            Colors.red.shade400;
                                        EasyLoading.showToast(
                                            "Entrer la photo de votre pièce d'identité",
                                            toastPosition:
                                                EasyLoadingToastPosition
                                                    .bottom);
                                      } else {
                                        String? avatar = await uploadFile(
                                            file:
                                                fileUploaderControllerPhotoIdentite
                                                    .file!);
                                        String? piece = await uploadFile(
                                            file:
                                                fileUploaderControllerPieceIdentite
                                                    .file!);
                                        final body = ParticulierRegistrationBody(
                                            avatar: avatar,
                                            pieceIdentiteId: piece,
                                            photoIdentiteId: avatar,
                                            firstName:
                                                _formController.firstName!.text,
                                            lastName:
                                                _formController.lastName!.text,
                                            email: _formController.email!.text,
                                            phoneNumber:
                                                "225${_formController.phoneNumber!.text..replaceAll(" ", "")}",
                                            password:
                                                _formController.password!.text,
                                            activite:
                                                _formController.activity!.text,
                                            token: widget
                                                .dataRouterRegistration.token);

                                        context
                                            .read<RgistrationCubitCubit>()
                                            .createParticulierAccount(
                                                particulierRegistrationBody:
                                                    body,
                                                fileUploaderControllerPhotoIdentite:
                                                    fileUploaderControllerPhotoIdentite,
                                                fileUploaderControllerPieceIdentite:
                                                    fileUploaderControllerPieceIdentite);
                                      }
                                    }

                                    //context.go('/homePage');
                                  },
                            text: "Creer mon compte",
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverGap(10),
                ],
              ),
            ),
          )),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
