import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/views/account/widgets/general_condition_page.dart';
import 'package:immoplus_pro/views/registration/registration_main_screen.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EnterpriseRegistrationPage extends StatefulWidget {
  const EnterpriseRegistrationPage({super.key});
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
  final ValueNotifier<bool> _passworConfirmdNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _cguNotifier = ValueNotifier<bool>(false);
  final FileUploaderController fileUploaderController =
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
        enterpriseName: TextEditingController(text: 'Sturne'),
        enterpriseType: TextEditingController(text: 'SARL'),
        //registreCommerce: TextEditingController(text: ''),
        numeroContribuable: TextEditingController(text: '22334'),
        phoneNumber: TextEditingController(text: '0701710065'),
        email: TextEditingController(text: 'satu@gmail.com'),
        password: TextEditingController(text: 'Satutu@123'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RgistrationCubitCubit(),
      child: Scaffold(
        backgroundColor: AppColors.scafold,
        appBar: AppBar(
          backgroundColor: AppColors.scafold,
          title: const Text('Incription entreprise'),
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
            Icon(FontAwesomeIcons.treeCity),
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
                  CustomTextField(
                    controller: _formController.enterpriseName,
                    prefixIcon: Icon(FontAwesomeIcons.buildingUser),
                    labelText: "Nom de l'entreprise",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                  CustomTextField(
                    controller: _formController.enterpriseType,
                    prefixIcon: Icon(CupertinoIcons.building_2_fill),
                    labelText: "Type d'entreprise",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                  CustomTextField(
                    controller: _formController.numeroContribuable,
                    prefixIcon: Icon(CupertinoIcons.number_circle),
                    labelText: "Numero contribuable",
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
                    prefixIcon: Icon(CupertinoIcons.mail),
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
                                    ? MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary)
                                    : MaterialStateProperty.all(Colors.white),
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
                  FileUploader(
                    fileUploaderController: fileUploaderController,
                    title: "Registre de Commerce",
                  ),
                  Gap(10),
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
                                      EasyLoading.instance.backgroundColor =
                                          Colors.red.shade400;
                                      EasyLoading.showToast(
                                          "Les Conditions d'utilisation ne sont pas approuvées",
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom);
                                    } else if (fileUploaderController.file ==
                                        null) {
                                      EasyLoading.instance.backgroundColor =
                                          Colors.red.shade400;
                                      EasyLoading.showToast(
                                          "Entrer la photo de votre registre de commerce",
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom);
                                    } else {
                                      final body = EnterpriseRegistrationBody(
                                        email: _formController.email!.text,
                                        phoneNumber:
                                            "225-${_formController.phoneNumber!.text..replaceAll(" ", "")}",
                                        password:
                                            _formController.password!.text,
                                        nomEntreprise: _formController
                                            .enterpriseName!.text,
                                        emailEntreprise:
                                            _formController.email!.text,
                                        // registreCommerce:
                                        //     _formController.email!.text,
                                        numeroContribuable: _formController
                                            .numeroContribuable!.text,
                                        typeEntreprise: _formController
                                            .enterpriseType!.text,
                                      );

                                      context
                                          .read<RgistrationCubitCubit>()
                                          .createEnterpriseAccount(
                                              enterpriseRegistrationBody: body,
                                              fileUploaderController:
                                                  fileUploaderController);
                                    }
                                  }

                                  //context.go('/homePage');
                                },
                          text: "Creer mon compte",
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
