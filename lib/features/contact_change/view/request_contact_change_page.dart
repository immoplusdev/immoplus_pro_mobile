import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/enums/contact_change_type.dart';
import 'package:immoplus_pro/features/contact_change/cubit/contact_change_cubit.dart';
import 'package:immoplus_pro/features/contact_change/cubit/contact_change_state.dart';
import 'package:immoplus_pro/features/contact_change/view/confirm_contact_change_page.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/features/shared_widgets/international_phone_number_input.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';

class RequestContactChangePage extends StatefulWidget {
  static const String name = 'REQUEST_CONTACT_CHANGE';

  final ContactChangeType type;

  const RequestContactChangePage({super.key, required this.type});

  @override
  State<RequestContactChangePage> createState() =>
      _RequestContactChangePageState();
}

class _RequestContactChangePageState extends State<RequestContactChangePage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _phoneNumber = '';
  bool _isPhoneValid = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String get _title => widget.type == ContactChangeType.phone
      ? 'Changer mon numéro de téléphone'
      : 'Changer mon email';

  String get _subtitle => widget.type == ContactChangeType.phone
      ? 'Entrez votre nouveau numéro. Un code de vérification vous sera envoyé.'
      : 'Entrez votre nouvel email. Un code de vérification vous sera envoyé.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
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
          if (state is ContactChangeRequestSuccess) {
            context.pushNamed(
              ConfirmContactChangePage.name,
              extra: state.type,
            );
          } else if (state is ContactChangeRequestError) {
            setState(() {
              _errorMessage = state.message;
            });
          }
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                Text(
                  _subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const Gap(32),
                if (widget.type == ContactChangeType.phone)
                  InternationalPhoneInput(
                    onValidPhoneNumber: (value) {
                      _phoneNumber = value;
                    },
                    onInputValidated: (isValid) {
                      setState(() {
                        _isPhoneValid = isValid;
                        _errorMessage = null;
                      });
                    },
                  )
                else
                  CustomTextField(
                    controller: _emailController,
                    prefixIcon: const Icon(CupertinoIcons.mail),
                    labelText: 'Nouvel email',
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) {
                      if (_errorMessage != null) {
                        setState(() => _errorMessage = null);
                      }
                    },
                    validator: (value) =>
                        FormUtils.emailValidator(email: value),
                  ),
                // if (_errorMessage != null) ...[
                //   const Gap(8),
                //   Text(
                //     _errorMessage!,
                //     style: const TextStyle(color: Colors.red, fontSize: 13),
                //   ),
                // ],
                const Gap(40),
                BlocBuilder<ContactChangeCubit, ContactChangeState>(
                  builder: (context, state) {
                    return CustomLoadingButtom(
                      text: 'Envoyer le code',
                      isLoading: state is ContactChangeRequestLoading,
                      onClick: () {
                        if (widget.type == ContactChangeType.phone) {
                          if (!_isPhoneValid) return;
                          context.read<ContactChangeCubit>().requestChange(
                                type: widget.type,
                                phoneNumber: _phoneNumber,
                              );
                        } else {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<ContactChangeCubit>().requestChange(
                                type: widget.type,
                                email: _emailController.text.trim(),
                              );
                        }
                      },
                    );
                  },
                ),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
