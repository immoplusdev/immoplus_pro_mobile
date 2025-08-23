import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus_pro/cubits/authentification/reset_password_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/reset_password_cubit_state.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/features/login_page/login_page.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:pinput/pinput.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  static String name = "RESET_PASSWORD_PAGE";

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: Scaffold(
        backgroundColor: HexColor("#121224"),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _EmailInputPage(pageController: _pageController),
            _OtpVerificationPage(pageController: _pageController),
            _NewPasswordPage(pageController: _pageController),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// ================== PAGE 1: EMAIL INPUT ==================
class _EmailInputPage extends StatefulWidget {
  final PageController pageController;

  const _EmailInputPage({required this.pageController});

  @override
  State<_EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<_EmailInputPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isFormCompleted = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFormCompletion);
  }

  void _checkFormCompletion() {
    final isCompleted = _isValidEmail(_emailController.text);
    if (_isFormCompleted != isCompleted) {
      setState(() {
        _isFormCompleted = isCompleted;
      });
    }
  }

  bool _isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _checkFormCompletion();
        });
      },
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: HexColor("#121224"),
            leadingWidth: 60,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(40, 40),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                  backgroundColor: Colors.white,
                ),
                onPressed: () => context.pop(),
                child: const Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              "Réinitialisation",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            ),
          ),
          const SliverGap(40),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.envelope,
                    size: 80,
                    color: HexColor('#2072ca'),
                  ),
                  const Gap(30),
                  Text(
                    "Entrez votre email",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),
                  const Gap(15),
                  Text(
                    "Nous vous enverrons un code de vérification par email pour réinitialiser votre mot de passe.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey.shade300),
                  ),
                ],
              ),
            ),
          ),
          const SliverGap(50),
          SliverFillRemaining(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(30),
                    CustomTextField(
                      controller: _emailController,
                      prefixIcon: const Icon(FontAwesomeIcons.envelope),
                      labelText: 'Adresse email',
                      textInputType: TextInputType.emailAddress,
                      validator: (value) =>
                          FormUtils.emailValidator(email: value),
                    ),
                    const Gap(30),
                    BlocConsumer<ResetPasswordCubit, ResetPasswordCubitState>(
                      listener: (context, state) {
                        state.when(
                          initial: () {},
                          sendingEmailOtp: () {},
                          emailOtpSent: (message) {
                            widget.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          verifyingEmail: () {},
                          emailVerified: () {},
                          resettingPassword: () {},
                          passwordResetSuccess: (message) {},
                          error: (errorMessage) {},
                        );
                      },
                      builder: (context, state) {
                        return CustomLoadingButtom(
                          isLoading: state.maybeWhen(
                            sendingEmailOtp: () => true,
                            orElse: () => false,
                          ),
                          clickable: _isFormCompleted,
                          onClick: () async {
                            if (_formKey.currentState!.validate()) {
                              context.read<ResetPasswordCubit>().sendEmailOtp(
                                  email: _emailController.text.trim());
                            }
                          },
                          text: "Envoyer le code",
                        );
                      },
                    ),
                    const Gap(20),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        "Retour à la connexion",
                        style: TextStyle(
                          color: HexColor('#2072ca'),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkFormCompletion);
    _emailController.dispose();
    super.dispose();
  }
}

// ================== PAGE 2: OTP VERIFICATION ==================
class _OtpVerificationPage extends StatefulWidget {
  final PageController pageController;

  const _OtpVerificationPage({required this.pageController});

  @override
  State<_OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<_OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      final isComplete = _otpController.text.length == 6;
      if (_isOtpComplete != isComplete) {
        setState(() {
          _isOtpComplete = isComplete;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: HexColor("#121224"),
          leadingWidth: 60,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(40, 40),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(8),
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                widget.pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(
                FontAwesomeIcons.chevronLeft,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Vérification",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.white),
          ),
        ),
        const SliverGap(40),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Icon(
                  FontAwesomeIcons.shieldHalved,
                  size: 80,
                  color: HexColor('#2072ca'),
                ),
                const Gap(30),
                Text(
                  "Entrez le code de vérification",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.white),
                ),
                const Gap(15),
                BlocBuilder<ResetPasswordCubit, ResetPasswordCubitState>(
                  builder: (context, state) {
                    final email =
                        context.read<ResetPasswordCubit>().currentEmail ?? "";
                    return Text(
                      "Code envoyé à $email",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.grey.shade300),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SliverGap(50),
        SliverFillRemaining(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Gap(50),
                  Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: HexColor('#2072ca'), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        color: HexColor('#2072ca'),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const Gap(30),
                  BlocConsumer<ResetPasswordCubit, ResetPasswordCubitState>(
                    listener: (context, state) {
                      state.when(
                        initial: () {},
                        sendingEmailOtp: () {},
                        emailOtpSent: (message) {},
                        verifyingEmail: () {},
                        emailVerified: () {
                          widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        resettingPassword: () {},
                        passwordResetSuccess: (message) {},
                        error: (errorMessage) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(errorMessage ?? "Code invalide"),
                          //     backgroundColor: Colors.red,
                          //     behavior: SnackBarBehavior.floating,
                          //   ),
                          // );
                          _otpController.clear();
                        },
                      );
                    },
                    builder: (context, state) {
                      return CustomLoadingButtom(
                        isLoading: state.maybeWhen(
                          verifyingEmail: () => true,
                          orElse: () => false,
                        ),
                        clickable: _isOtpComplete,
                        onClick: _isOtpComplete
                            ? () {
                                context
                                    .read<ResetPasswordCubit>()
                                    .verifyEmailOtp(otp: _otpController.text);
                              }
                            : null,
                        text: "Vérifier le code",
                      );
                    },
                  ),
                  const Gap(20),
                  TextButton(
                    onPressed: () {
                      final cubit = context.read<ResetPasswordCubit>();
                      if (cubit.currentEmail != null) {
                        cubit.sendEmailOtp(email: cubit.currentEmail!);
                      }
                    },
                    child: Text(
                      "Renvoyer le code",
                      style: TextStyle(
                        color: HexColor('#2072ca'),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}

// ================== PAGE 3: NEW PASSWORD ==================
class _NewPasswordPage extends StatefulWidget {
  final PageController pageController;

  const _NewPasswordPage({required this.pageController});

  @override
  State<_NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<_NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ValueNotifier<bool> _passwordNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _confirmPasswordNotifier =
      ValueNotifier<bool>(false);
  bool _isFormCompleted = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkFormCompletion);
    _confirmPasswordController.addListener(_checkFormCompletion);
  }

  void _checkFormCompletion() {
    final isCompleted = _isValidPassword(_passwordController.text) &&
        _passwordController.text == _confirmPasswordController.text &&
        _confirmPasswordController.text.isNotEmpty;

    if (_isFormCompleted != isCompleted) {
      setState(() {
        _isFormCompleted = isCompleted;
      });
    }
  }

  bool _isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _checkFormCompletion();
        });
      },
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: HexColor("#121224"),
            leadingWidth: 60,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(40, 40),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  widget.pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(
                  FontAwesomeIcons.chevronLeft,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              "Nouveau mot de passe",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            ),
          ),
          const SliverGap(40),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Icon(
                    FontAwesomeIcons.lock,
                    size: 80,
                    color: HexColor('#2072ca'),
                  ),
                  const Gap(30),
                  Text(
                    "Créez un nouveau mot de passe",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),
                  const Gap(15),
                  Text(
                    "Votre nouveau mot de passe doit être différent des précédents.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.grey.shade300),
                  ),
                ],
              ),
            ),
          ),
          const SliverGap(50),
          SliverFillRemaining(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(30),
                    ValueListenableBuilder<bool>(
                      valueListenable: _passwordNotifier,
                      builder: (context, value, child) {
                        return CustomTextField(
                          controller: _passwordController,
                          obscureText: !value,
                          prefixIcon: const Icon(FontAwesomeIcons.lock),
                          sufixIcon: IconButton(
                            onPressed: () {
                              _passwordNotifier.value = !value;
                            },
                            icon: Icon(
                              value
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 20,
                            ),
                          ),
                          labelText: 'Nouveau mot de passe',
                          validator: (value) =>
                              FormUtils.passwordValidator(password: value),
                        );
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _confirmPasswordNotifier,
                      builder: (context, value, child) {
                        return CustomTextField(
                          controller: _confirmPasswordController,
                          obscureText: !value,
                          prefixIcon: const Icon(FontAwesomeIcons.lock),
                          sufixIcon: IconButton(
                            onPressed: () {
                              _confirmPasswordNotifier.value = !value;
                            },
                            icon: Icon(
                              value
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              size: 20,
                            ),
                          ),
                          labelText: 'Confirmer le mot de passe',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez confirmer votre mot de passe';
                            }
                            if (value != _passwordController.text) {
                              return 'Les mots de passe ne correspondent pas';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const Gap(30),
                    BlocConsumer<ResetPasswordCubit, ResetPasswordCubitState>(
                      listener: (context, state) {
                        state.when(
                          initial: () {},
                          sendingEmailOtp: () {},
                          emailOtpSent: (message) {},
                          verifyingEmail: () {},
                          emailVerified: () {},
                          resettingPassword: () {},
                          passwordResetSuccess: (message) {
                            ToastUtils.success(message ??
                                "Mot de passe réinitialisé avec succès !");

                            // Redirection vers la page de connexion
                            Future.delayed(const Duration(seconds: 2), () {
                              context.goNamed(LoginPage.name);
                            });
                          },
                          error: (errorMessage) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text(errorMessage ??
                            //         "Erreur lors de la réinitialisation"),
                            //     backgroundColor: Colors.red,
                            //     behavior: SnackBarBehavior.floating,
                            //   ),
                            // );
                          },
                        );
                      },
                      builder: (context, state) {
                        return CustomLoadingButtom(
                          isLoading: state.maybeWhen(
                            resettingPassword: () => true,
                            orElse: () => false,
                          ),
                          clickable: _isFormCompleted,
                          onClick: _isFormCompleted
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    context
                                        .read<ResetPasswordCubit>()
                                        .resetPassword(
                                            newPassword:
                                                _passwordController.text);
                                  }
                                }
                              : null,
                          text: "Réinitialiser le mot de passe",
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.removeListener(_checkFormCompletion);
    _confirmPasswordController.removeListener(_checkFormCompletion);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordNotifier.dispose();
    _confirmPasswordNotifier.dispose();
    super.dispose();
  }
}
