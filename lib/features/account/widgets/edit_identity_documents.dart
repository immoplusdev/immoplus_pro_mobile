import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/gen/assets.gen.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/update_additional_data_dto.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/registration/widgets/document_upload_card.dart';
import 'package:immoplus_pro/features/registration/widgets/identity_photo_picker.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';


class EditIdentityDocuments extends StatefulWidget {
  const EditIdentityDocuments({super.key});
  static String name = 'EDIT_IDENTITY_DOCUMENTS';

  @override
  State<EditIdentityDocuments> createState() => _EditIdentityDocumentsState();
}

class _EditIdentityDocumentsState extends State<EditIdentityDocuments> {
  final _formKey = GlobalKey<FormState>();

  late final bool isEntreprise;
  late final bool isReadOnly;

  // Pro particulier
  late final TextEditingController _lieuNaissanceController;
  late final TextEditingController _activiteController;
  final _photoIdentiteController = FileUploaderController();
  final _pieceIdentiteController = FileUploaderController();
  final _pieceIdentiteVersoController = FileUploaderController();

  // Pro entreprise
  late final TextEditingController _nomEntrepriseController;
  late final TextEditingController _emailEntrepriseController;
  late final TextEditingController _numeroContribuableController;
  late final TextEditingController _typeEntrepriseController;
  final _registreCommerceController = FileUploaderController();

  // Valeurs initiales : on ne renvoie au serveur que ce qui a réellement
  // changé (le backend préserve la valeur existante des champs omis).
  late final String _initialLieuNaissance;
  late final String _initialActivite;
  late final String _initialNomEntreprise;
  late final String _initialEmailEntreprise;
  late final String _initialNumeroContribuable;
  late final String _initialTypeEntreprise;

  @override
  void initState() {
    super.initState();
    final user = SessionManager().currentUser!;
    isEntreprise = user.isEntreprise;
    isReadOnly = user.identityVerified == true;

    _initialLieuNaissance = user.lieuNaissance ?? '';
    _initialActivite = user.activite ?? '';
    _initialNomEntreprise = user.nomEntreprise ?? '';
    _initialEmailEntreprise = user.emailEntreprise ?? '';
    _initialNumeroContribuable = user.numeroContribuable ?? '';
    _initialTypeEntreprise = user.typeEntreprise ?? '';

    _lieuNaissanceController =
        TextEditingController(text: _initialLieuNaissance);
    _activiteController = TextEditingController(text: _initialActivite);
    _nomEntrepriseController =
        TextEditingController(text: _initialNomEntreprise);
    _emailEntrepriseController =
        TextEditingController(text: _initialEmailEntreprise);
    _numeroContribuableController =
        TextEditingController(text: _initialNumeroContribuable);
    _typeEntrepriseController =
        TextEditingController(text: _initialTypeEntreprise);

    if (!isReadOnly) {
      getIt<AnalyticsService>().logKycDocumentsEditStarted();
    }
  }

  @override
  void dispose() {
    _lieuNaissanceController.dispose();
    _activiteController.dispose();
    _nomEntrepriseController.dispose();
    _emailEntrepriseController.dispose();
    _numeroContribuableController.dispose();
    _typeEntrepriseController.dispose();
    _photoIdentiteController.dispose();
    _pieceIdentiteController.dispose();
    _pieceIdentiteVersoController.dispose();
    _registreCommerceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? true)) return;

    final hasFileChange = isEntreprise
        ? _registreCommerceController.file != null
        : (_photoIdentiteController.file != null ||
            _pieceIdentiteController.file != null ||
            _pieceIdentiteVersoController.file != null);

    final hasTextChange = isEntreprise
        ? (_nomEntrepriseController.text != _initialNomEntreprise ||
            _emailEntrepriseController.text != _initialEmailEntreprise ||
            _numeroContribuableController.text !=
                _initialNumeroContribuable ||
            _typeEntrepriseController.text != _initialTypeEntreprise)
        : (_lieuNaissanceController.text != _initialLieuNaissance ||
            _activiteController.text != _initialActivite);

    if (!hasFileChange && !hasTextChange) {
      ToastUtils.info("Aucune modification n'a été faite");
      return;
    }

    FocusScope.of(context).unfocus();

    final UpdateAdditionalDataDto body;
    if (isEntreprise) {
      body = UpdateAdditionalDataDto(
        nomEntreprise: _nomEntrepriseController.text != _initialNomEntreprise
            ? _nomEntrepriseController.text
            : null,
        emailEntreprise:
            _emailEntrepriseController.text != _initialEmailEntreprise
                ? _emailEntrepriseController.text
                : null,
        numeroContribuable:
            _numeroContribuableController.text != _initialNumeroContribuable
                ? _numeroContribuableController.text
                : null,
        typeEntreprise:
            _typeEntrepriseController.text != _initialTypeEntreprise
                ? _typeEntrepriseController.text
                : null,
        registreCommerce: _registreCommerceController.file != null
            ? await _registreCommerceController.ensureUploaded()
            : null,
      );
    } else {
      body = UpdateAdditionalDataDto(
        lieuNaissance: _lieuNaissanceController.text != _initialLieuNaissance
            ? _lieuNaissanceController.text
            : null,
        activite: _activiteController.text != _initialActivite
            ? _activiteController.text
            : null,
        photoIdentite: _photoIdentiteController.file != null
            ? await _photoIdentiteController.ensureUploaded()
            : null,
        pieceIdentite: _pieceIdentiteController.file != null
            ? await _pieceIdentiteController.ensureUploaded()
            : null,
        pieceIdentiteVerso: _pieceIdentiteVersoController.file != null
            ? await _pieceIdentiteVersoController.ensureUploaded()
            : null,
      );
    }

    if (!mounted) return;
    getIt<AnalyticsService>().logKycDocumentsEditSubmitted();
    context.read<LoginCubit>().updateAdditionalData(body: body);
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionManager().currentUser!;

    final fields = isEntreprise
        ? _buildEntrepriseFields(user)
        : _buildParticulierFields(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mes documents'),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<LoginCubit, LoginCubitState>(
        listener: (context, state) {
          if (state is LOGIN_SUCCESS) {
            ToastUtils.success('Documents mis à jour avec succès');
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              if (isReadOnly) ...[
                _buildVerifiedBanner(),
                const Gap(20),
              ],
              ...fields,
              const Gap(20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isReadOnly
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<LoginCubit, LoginCubitState>(
                  builder: (context, state) {
                    return CustomLoadingButtom(
                      isLoading: state is LOGIN_LOADING,
                      onClick: state is LOGIN_LOADING ? null : _submit,
                      text: "Enregistrer",
                    );
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildVerifiedBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(Assets.svgs.icons.securitySafe, width: 24, height: 24),
          const Gap(12),
          Expanded(
            child: Text(
              "Vos informations ont été vérifiées et ne peuvent plus être modifiées.",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyFile({required String label, String? fileId}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        Container(
          width: double.infinity,
          height: 170,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.grey.shade100,
          ),
          child: fileId != null
              ? CachedNetworkImage(
                  imageUrl: Utils.getImagePath(id: fileId),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade400,
                    period: const Duration(milliseconds: 500),
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                )
              : Center(
                  child: Icon(Icons.image_not_supported,
                      color: Colors.grey.shade400),
                ),
        ),
      ],
    );
  }

  List<Widget> _buildParticulierFields(UserModelSchema user) {
    return [
      CustomTextField(
        controller: _lieuNaissanceController,
        labelText: 'Lieu de naissance',
        isEnabled: !isReadOnly,
        prefixIcon: const Icon(CupertinoIcons.location),
        validator: (value) =>
            isReadOnly ? null : FormUtils.fieldValidator(value: value),
      ),
      const Gap(16),
      CustomTextField(
        controller: _activiteController,
        labelText: 'Activité',
        isEnabled: !isReadOnly,
        prefixIcon: const Icon(CupertinoIcons.briefcase),
        validator: (value) =>
            isReadOnly ? null : FormUtils.fieldValidator(value: value),
      ),
      const Gap(24),
      if (isReadOnly) ...[
        _buildReadOnlyFile(
            label: "Photo d'identité (selfie)", fileId: user.photoIdentite),
        const Gap(20),
        _buildReadOnlyFile(
            label: "Pièce d'identité (recto)", fileId: user.pieceIdentite),
        const Gap(20),
        _buildReadOnlyFile(
            label: "Pièce d'identité (verso)",
            fileId: user.pieceIdentiteVerso),
      ] else ...[
        Center(
          child: IdentityPhotoPicker(
            controller: _photoIdentiteController,
            label: "Photo d'identité (selfie)",
            placeholderText: "Ajouter une photo d'identité",
            helperText: "Assurez-vous que votre visage est bien éclairé.",
            placeholderImageId: user.photoIdentite,
          ),
        ),
        const Gap(24),
        DocumentUploadCard(
          controller: _pieceIdentiteController,
          label: "Pièce d'identité (recto)",
          subtitle: "PNG, JPG ou PDF (Max 5Mo)",
          placeholderImageId: user.pieceIdentite,
        ),
        const Gap(20),
        DocumentUploadCard(
          controller: _pieceIdentiteVersoController,
          label: "Pièce d'identité (verso)",
          subtitle: "PNG, JPG ou PDF (Max 5Mo)",
          placeholderImageId: user.pieceIdentiteVerso,
        ),
      ],
    ];
  }

  List<Widget> _buildEntrepriseFields(UserModelSchema user) {
    return [
      CustomTextField(
        controller: _nomEntrepriseController,
        labelText: "Nom de l'entreprise",
        isEnabled: !isReadOnly,
        prefixIcon: const Icon(CupertinoIcons.building_2_fill),
        validator: (value) =>
            isReadOnly ? null : FormUtils.fieldValidator(value: value),
      ),
      const Gap(16),
      CustomTextField(
        controller: _emailEntrepriseController,
        labelText: "Email de l'entreprise",
        isEnabled: !isReadOnly,
        textInputType: TextInputType.emailAddress,
        prefixIcon: const Icon(CupertinoIcons.mail),
        validator: (value) =>
            isReadOnly ? null : FormUtils.emailValidator(email: value),
      ),
      const Gap(16),
      CustomTextField(
        controller: _numeroContribuableController,
        labelText: "Numéro contribuable",
        isEnabled: !isReadOnly,
        prefixIcon: const Icon(CupertinoIcons.number),
        validator: (value) =>
            isReadOnly ? null : FormUtils.fieldValidator(value: value),
      ),
      const Gap(16),
      CustomTextField(
        controller: _typeEntrepriseController,
        labelText: "Type d'entreprise",
        isEnabled: !isReadOnly,
        prefixIcon: const Icon(CupertinoIcons.doc_text),
        validator: (value) =>
            isReadOnly ? null : FormUtils.fieldValidator(value: value),
      ),
      const Gap(24),
      if (isReadOnly)
        _buildReadOnlyFile(
            label: "Registre de commerce", fileId: user.registreCommerce)
      else
        DocumentUploadCard(
          controller: _registreCommerceController,
          label: "Registre de commerce",
          subtitle: "PNG, JPG ou PDF (Max 5Mo)",
          icon: Iconsax.document_upload,
          placeholderImageId: user.registreCommerce,
        ),
    ];
  }
}
