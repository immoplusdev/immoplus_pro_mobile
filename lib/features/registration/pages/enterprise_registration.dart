import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/features/account/widgets/general_condition_page.dart';
import 'package:immoplus_pro/features/registration/registration_main_screen.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
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
  final int _selectedCity = 0;
  final FocusNode _focusNode = FocusNode();
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
        enterpriseName: TextEditingController(text: ''),
        enterpriseType: TextEditingController(text: ''),
        //registreCommerce: TextEditingController(text: ''),
        numeroContribuable: TextEditingController(text: ''),
        phoneNumber: TextEditingController(text: ''),
        email: TextEditingController(text: ''),
        password: TextEditingController(text: ''));

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
          title: const Text('Inscription entreprise'),
          elevation: 0,
          actions: const [
            Icon(FontAwesomeIcons.treeCity),
            Gap(20),
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: CustomTextField(
                    controller: _formController.enterpriseName,
                    prefixIcon: const Icon(FontAwesomeIcons.buildingUser),
                    labelText: "Nom de l'entreprise",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomTextField(
                    controller: _formController.enterpriseType,
                    prefixIcon: const Icon(CupertinoIcons.building_2_fill),
                    labelText: "Type d'entreprise",
                    validator: (String? value) =>
                        FormUtils.fieldValidator(value: value),
                  ),
                ),
                SliverToBoxAdapter(
                  child: CustomTextField(
                    controller: _formController.numeroContribuable,
                    prefixIcon: const Icon(CupertinoIcons.number_circle),
                    labelText: "Numero contribuable",
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
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _passworConfirmdNotifier,
                    builder: (BuildContext context, bool value, child) {
                      return CustomTextField(
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        obscureText: !value,
                        sufixIcon: IconButton(
                          onPressed: () {
                            _passworConfirmdNotifier.value = !value;
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
                SliverToBoxAdapter(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _cguNotifier,
                    builder: (BuildContext context, bool value, child) {
                      return Row(
                        children: [
                          Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            value: value,
                            fillColor: value
                                ? WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.primary)
                                : WidgetStateProperty.all(Colors.white),
                            onChanged: (val) {
                              _cguNotifier.value = !_cguNotifier.value;
                            },
                          ),
                          const Text("j'approuve les"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const GeneralConditionPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Termes & conditions',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: FileUploader(
                    fileUploaderController: fileUploaderController,
                    title: "Registre de Commerce",
                  ),
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
                                      String? registre = await uploadFile(
                                          file: fileUploaderController.file!);

                                      final body = EnterpriseRegistrationBody(
                                        email: _formController.email!.text,
                                        registreCommerceId: registre,
                                        phoneNumber:
                                            "225${_formController.phoneNumber!.text..replaceAll(" ", "")}",
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

                                      // ignore: use_build_context_synchronously
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
                ),
                SliverGap(
                  10,
                ),
              ],
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
