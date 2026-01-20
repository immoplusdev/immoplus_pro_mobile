import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/core/extensions/safe_area_extensions.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit_state.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FormController _formController;
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _newPasswordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _confirmNewPasswordNotifier =
      ValueNotifier<bool>(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formController = FormController(
      productId: 0,
      password: TextEditingController(text: ''),
      newPassword: TextEditingController(text: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Modifier mon mot de passe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ValueListenableBuilder<bool>(
                  valueListenable: _passwordNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return CustomTextField(
                      controller: _formController.password,
                      obscureText: !_passwordNotifier.value,
                      prefixIcon: Icon(CupertinoIcons.lock),
                      sufixIcon: IconButton(
                        onPressed: () {
                          _passwordNotifier.value = !_passwordNotifier.value;
                        },
                        icon: Icon(
                          (value)
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        iconSize: 22,
                      ),
                      labelText: 'Ancien mot de passe',
                      validator: (value) =>
                          FormUtils.passwordValidator(password: value),
                    );
                  }),
              ValueListenableBuilder<bool>(
                  valueListenable: _newPasswordNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return CustomTextField(
                      controller: _formController.newPassword,
                      obscureText: !_newPasswordNotifier.value,
                      prefixIcon: Icon(CupertinoIcons.lock),
                      sufixIcon: IconButton(
                        onPressed: () {
                          _newPasswordNotifier.value =
                              !_newPasswordNotifier.value;
                        },
                        icon: Icon(
                          (value)
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        iconSize: 22,
                      ),
                      labelText: 'Nouveau mot de passe',
                      validator: (value) =>
                          FormUtils.passwordValidator(password: value),
                    );
                  }),
              ValueListenableBuilder<bool>(
                  valueListenable: _confirmNewPasswordNotifier,
                  builder: (BuildContext context, bool value, child) {
                    return CustomTextField(
                      prefixIcon: Icon(CupertinoIcons.lock),
                      obscureText: !_confirmNewPasswordNotifier.value,
                      sufixIcon: IconButton(
                          onPressed: () {
                            _confirmNewPasswordNotifier.value =
                                !_confirmNewPasswordNotifier.value;
                          },
                          icon: Icon(
                            (value)
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          )),
                      labelText: 'Confirmer nouveau mot de passe',
                      validator: (String? value) {
                        if ((value == null || value.isEmpty) ||
                            value != _formController.newPassword!.text) {
                          return 'le mot de passe ne correspond pas';
                        }
                        return null;
                      },
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<LoginCubit, LoginCubitState>(
                builder: (context, state) {
                  return CustomLoadingButtom(
                    text: 'Mettre à jour',
                    isLoading: state is LOGIN_LOADING,
                    //color: Colors.white,
                    textColor: Colors.white,
                    onClick: () async {
                      if (_formKey.currentState!.validate()) {
                        // Process data.

                        // context.read<LoginCubit>().updatePassword(
                        //     formController: _formController, context: context);
                      }
                    },
                  );
                },
              ),
              SizedBox(
                height: 20 + kDefaultPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
