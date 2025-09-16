import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/update_password_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/update_password_cubit_state.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:lottie/lottie.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});
  static String name = "UPDATE_PASSWORD_PAGE";

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validateOld(String? v) {
    if (v == null || v.isEmpty) return "Entrez l'ancien mot de passe";
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _newCtrl.text) return "Les mots de passe ne correspondent pas";
    return null;
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<UpdatePasswordCubit>().updatePassword(
          oldPassword: _oldCtrl.text,
          newPassword: _newCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdatePasswordCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: AppColors.whiteBackground,
            onPressed: () => context.pop(),
          ),
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.scaffoldBackgroundColor,
          title: Text(
            "Modifier le mot de passe",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                ),
          ),
        ),
        body: BlocConsumer<UpdatePasswordCubit, UpdatePasswordCubitState>(
            listener: (context, state) {
          state.maybeWhen(
            success: (message) {
              ToastUtils.showSuccess(title: message);
              context.pop();
            },
            error: (_) {},
            orElse: () {},
          );
        }, builder: (context, _) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 300,
                            child: LottieBuilder.asset(
                              "assets/lotties/reset_password.json",
                              repeat: false,
                            ),
                          ),
                          // Ancien mot de passe
                          CustomTextField(
                            controller: _oldCtrl,
                            labelText: "Ancien mot de passe",
                            obscureText: _obscureOld,
                            validator: _validateOld,
                            sufixIcon: IconButton(
                              icon: Icon(
                                _obscureOld
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureOld = !_obscureOld),
                            ),
                          ),
                          // Nouveau mot de passe
                          CustomTextField(
                            controller: _newCtrl,
                            labelText: "Nouveau mot de passe",
                            obscureText: _obscureNew,
                            validator: (v) =>
                                FormUtils.passwordValidator(password: v),
                            sufixIcon: IconButton(
                              icon: Icon(
                                _obscureNew
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                            ),
                          ),
                          // Confirmation
                          CustomTextField(
                            controller: _confirmCtrl,
                            labelText: "Confirmer le nouveau mot de passe",
                            obscureText: _obscureConfirm,
                            validator: _validateConfirm,
                            sufixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BlocBuilder<UpdatePasswordCubit, UpdatePasswordCubitState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      submitting: () => true,
                      orElse: () => false,
                    );
                    return Container(
                      margin: const EdgeInsets.only(top: 16, bottom: 16),
                      child: CustomLoadingButtom(
                        isLoading: isLoading,
                        text: 'METTRE À JOUR',
                        onClick: isLoading ? null : () => _onSubmit(context),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
