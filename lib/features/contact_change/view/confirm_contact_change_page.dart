import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/extensions/go_router_extensions.dart';
import 'package:immoplus_pro/data/enums/contact_change_type.dart';
import 'package:immoplus_pro/features/contact_change/cubit/contact_change_cubit.dart';
import 'package:immoplus_pro/features/contact_change/cubit/contact_change_state.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:immoplus_pro/widgets/custom_pinput.dart';

class ConfirmContactChangePage extends StatefulWidget {
  static const String name = 'CONFIRM_CONTACT_CHANGE';

  final ContactChangeType type;

  const ConfirmContactChangePage({super.key, required this.type});

  @override
  State<ConfirmContactChangePage> createState() =>
      _ConfirmContactChangePageState();
}

class _ConfirmContactChangePageState extends State<ConfirmContactChangePage> {
  final _otpController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String get _subtitle => widget.type == ContactChangeType.phone
      ? 'Un code a été envoyé à votre nouveau numéro de téléphone.'
      : 'Un code a été envoyé à votre nouvel email.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérification'),
        backgroundColor: AppColors.whiteBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.whiteBackground,
      body: BlocListener<ContactChangeCubit, ContactChangeState>(
        listener: (context, state) {
          if (state is ContactChangeConfirmSuccess) {
            ToastUtils.showSuccess(
                description: state.message, title: "Opération réussie");
            AppRouter.router.mayPop(context, count: 2);
          } else if (state is ContactChangeConfirmError) {
            setState(() {
              _errorText = 'Code incorrect. Veuillez réessayer.';
            });
          }
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(24),
              Text(
                _subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const Gap(40),
              CustomPinput(
                controller: _otpController,
                length: 6,
                // errorText: _errorText,
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },
                onCompleted: (otp) {
                  context.read<ContactChangeCubit>().confirmChange(
                        type: widget.type,
                        otp: otp,
                      );
                },
              ),
              const Gap(40),
              BlocBuilder<ContactChangeCubit, ContactChangeState>(
                builder: (context, state) {
                  return CustomLoadingButtom(
                    text: 'Confirmer',
                    isLoading: state is ContactChangeConfirmLoading,
                    onClick: () {
                      if (_otpController.text.length < 6) {
                        setState(() {
                          _errorText = 'Veuillez saisir le code à 6 chiffres';
                        });
                        return;
                      }
                      context.read<ContactChangeCubit>().confirmChange(
                            type: widget.type,
                            otp: _otpController.text,
                          );
                    },
                  );
                },
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
