import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/particulier_registration_body.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/views/account/widgets/general_condition_page.dart';
import 'package:immoplus_pro/views/registration/registration_main_screen.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ParticulierRegistration extends StatefulWidget {
  const ParticulierRegistration({super.key});
  static String name = "Particulier_Registration";
  @override
  State<ParticulierRegistration> createState() =>
      _ParticulierRegistrationState();
}

class _ParticulierRegistrationState extends State<ParticulierRegistration> {
  late FormController _formController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _passworConfirmdNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  final FileUploaderController fileUploaderControllerPhotoIdentite =
      FileUploaderController();
  final FileUploaderController fileUploaderControllerPieceIdentite =
      FileUploaderController();
  int _selectedCity = 0;
  FocusNode _focusNode = FocusNode();
  _getCity({required Widget child}) {
    _focusNode.unfocus();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  void initState() {
    _focusNode.unfocus();

    _formController = FormController(
        productId: 0,
        firstName: TextEditingController(text: ''),
        lastName: TextEditingController(text: ''),
        activity: TextEditingController(text: ''),
        phoneNumber: TextEditingController(text: ''),
        email: TextEditingController(text: ''),
        password: TextEditingController(text: ''));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: AppColors.scafold,
        appBar: AppBar(
          backgroundColor: AppColors.scafold,
          title: const Text('Incription particulier'),
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
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: FileUploader(
                          width: 150,
                          fileUploaderController:
                              fileUploaderControllerPhotoIdentite,
                          title: "Photo d'itentité",
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
                  const Gap(10),
                  CustomTextField(
                    controller: _formController.firstName,
                    prefixIcon: Icon(FontAwesomeIcons.user),
                    labelText: "Nom",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                  CustomTextField(
                    controller: _formController.lastName,
                    prefixIcon: Icon(FontAwesomeIcons.user),
                    labelText: "Prénom",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                  CustomTextField(
                    controller: _formController.activity,
                    prefixIcon: const Icon(CupertinoIcons.briefcase),
                    labelText: "Activité",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                  CustomTextField(
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
                        //initialText: '+225 ', // Optionnel: préfixe par défaut
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: _formController.email,
                    prefixIcon: const Icon(CupertinoIcons.mail),
                    labelText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    validator: (String? value) =>
                        FormUtils.emailValidator(email: value),
                  ),
                  ValueListenableBuilder<bool>(
                      valueListenable: _passwordNotifier,
                      builder: (BuildContext context, bool value, child) {
                        return CustomTextField(
                          prefixIcon: Icon(CupertinoIcons.lock),
                          controller: _formController.password,
                          obscureText: !_passwordNotifier.value,
                          sufixIcon: IconButton(
                              onPressed: () {
                                _passwordNotifier.value =
                                    !_passwordNotifier.value;
                              },
                              icon: Icon(
                                (value)
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                              )),
                          labelText: 'Mot de passe',
                          validator: (String? value) =>
                              FormUtils.passwordValidator(password: value),
                        );
                      }),
                  ValueListenableBuilder<bool>(
                      valueListenable: _passworConfirmdNotifier,
                      builder: (BuildContext context, bool value, child) {
                        return CustomTextField(
                          prefixIcon: Icon(CupertinoIcons.lock),
                          obscureText: !_passworConfirmdNotifier.value,
                          sufixIcon: IconButton(
                              onPressed: () {
                                _passworConfirmdNotifier.value =
                                    !_passworConfirmdNotifier.value;
                              },
                              icon: Icon(
                                (value)
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                              )),
                          labelText: 'Confirmation du mot de passe ',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'veillez entrer un mot de passe';
                            } else if (value !=
                                _formController.password!.text) {
                              return 'le mot de passe ne correspond pas';
                            }

                            return null;
                          },
                        );
                      }),
                  ValueListenableBuilder<bool>(
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
                                            GeneralConditionPage(),
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
                  const Gap(10),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: BlocBuilder<RgistrationCubitCubit,
                        RegistrationCubitState>(
                      builder: (context, state) {
                        return CustomLoadingButtom(
                          isLoading: (state is REGISTRATION_LOADING),
                          onClick: ((state is REGISTRATION_LOADING))
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (!_cguNotifier.value) {
                                      EasyLoading.showToast(
                                          "Les Conditions d'utilisation ne sont pas approuvées",
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom);
                                    } else if (fileUploaderControllerPhotoIdentite
                                            .file ==
                                        null) {
                                      EasyLoading.instance.backgroundColor =
                                          Colors.red.shade400;
                                      EasyLoading.showToast(
                                          "Entrer une photo de vous",
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom);
                                    } else if (fileUploaderControllerPieceIdentite
                                            .file ==
                                        null) {
                                      EasyLoading.instance.backgroundColor =
                                          Colors.red.shade400;
                                      EasyLoading.showToast(
                                          "Entrer la photo de votre pièce d'identité",
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom);
                                    } else {
                                      final body = ParticulierRegistrationBody(
                                        firstName:
                                            _formController.firstName!.text,
                                        lastName:
                                            _formController.lastName!.text,
                                        email: _formController.email!.text,
                                        phoneNumber:
                                            "225-${_formController.phoneNumber!.text..replaceAll(" ", "")}",
                                        password:
                                            _formController.password!.text,
                                        activite:
                                            _formController.activity!.text,
                                      );

                                      context
                                          .read<RgistrationCubitCubit>()
                                          .createParticulierAccount(
                                              particulierRegistrationBody: body,
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
                  const Gap(10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
