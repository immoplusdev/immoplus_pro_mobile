import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/login_body_model.dart';
import 'package:immoplus_pro/utils/formuar_controller.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/utils/hex_color.dart';
import 'package:immoplus_pro/views/login_page/pages/reset_password.dart';
import 'package:immoplus_pro/views/registration/registration_main_screen.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String name = "LOGIN_PAGE";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ValueNotifier<bool> _passwordNotifier;
  late GlobalKey<FormState> _formKey;

  late Map<String, dynamic> _formData;
  late FormController _formController;

  // INITSTATE
  @override
  void initState() {
    // TODO: implement initState
    _formController = FormController(
      productId: 0,
      email: TextEditingController(text: ''), //'satu1@gmail.com'
      password: TextEditingController(text: ''), //'satu@123'
    );
    _passwordNotifier = ValueNotifier<bool>(false);
    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Connexion ou inscription'),
          titleTextStyle:
              Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
          centerTitle: false,
          elevation: 0,
          automaticallyImplyLeading: false,
          // actions: [
          //   IconButton(
          //       onPressed: () {},
          //       icon: Icon(
          //         CupertinoIcons.question_circle_fill,
          //         color: Colors.black,
          //       ))
          // ],
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: SvgPicture.asset(
                        'assets/icons/logo_immo.svg',
                        color: HexColor.fromHex('#2072ca'),
                        width: 100,
                      ),
                    ),
                    CustomTextField(
                      controller: _formController.email,
                      labelText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        CupertinoIcons.mail,
                        size: 19,
                      ),
                      validator: (value) =>
                          FormUtils.emailValidator(email: value),
                    ),
                    SizedBox(
                      height: 10,
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
                                _passwordNotifier.value =
                                    !_passwordNotifier.value;
                              },
                              icon: Icon(
                                (value)
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                              ),
                              iconSize: 22,
                            ),
                            labelText: 'Mot de passe',
                            validator: (value) =>
                                FormUtils.passwordValidator(password: value),
                          );
                        }),
                    const Gap(10),
                    BlocBuilder<LoginCubit, LoginCubitState>(
                      builder: (context, state) {
                        return CustomLoadingButtom(
                          isLoading: (state is LOGIN_LOADING),
                          onClick: ((state is LOGIN_LOADING))
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    final body = LoginBodyModel(
                                      username: _formController.email!.text,
                                      password: _formController.password!.text,
                                    );
                                    print(body);
                                    context.read<LoginCubit>().onSendData(
                                          body: body,
                                        );
                                  }

                                  //context.go('/homePage');
                                },
                          text: 'Continuer',
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => ResetPassword(),
                              //     ));
                            },
                            child: Text(
                              'Mot de passe oublié',
                              style:
                                  GoogleFonts.inter(color: AppColors.primary),
                            )),
                        TextButton(
                            onPressed: () {
                              context.pushNamed(RegistrationMainScreean.name);
                              //context.go('/registration');
                            },
                            child: Text(
                              'S\'inscrire',
                              style:
                                  GoogleFonts.inter(color: AppColors.primary),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: 200,
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('ou'),
                        ),
                        Flexible(
                            child: SizedBox(
                                child: Divider(
                          thickness: 1,
                        ))),
                      ],
                    ),
                    // SocialNetworkButton(
                    //     icon: Icon(
                    //       Icons.phone_android_rounded,
                    //       color: CupertinoColors.black,
                    //       size: 40,
                    //     ),
                    //     title: 'Continuer avec numéro de téléphone',
                    //     onTap: () {}),
                    // SocialNetworkButton(
                    //     icon: Icon(
                    //       FontAwesomeIcons.apple,
                    //       color: CupertinoColors.black,
                    //       size: 40,
                    //     ),
                    //     title: 'Continuer avec Apple',
                    //     onTap: () {}),
                    // SocialNetworkButton(
                    //     icon:
                    //         SvgPicture.asset('assets/svgs/icons/facebook.svg'),
                    //     title: 'Continuer avec Facebook',
                    //     onTap: () {}),
                    // SocialNetworkButton(
                    //     icon: SvgPicture.asset('assets/svgs/icons/google.svg'),
                    //     title: 'Continuer avec Google',
                    //     onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
            height: 50,
            child: Center(
              child: Text(
                '©AfriqueSolus',
                style: TextStyle(color: Color.fromARGB(255, 182, 181, 181)),
              ),
            )),
      ),
    );
  }
}
