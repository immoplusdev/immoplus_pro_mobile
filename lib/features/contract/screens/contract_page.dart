import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/contract/logic/contract_cubit.dart';
import 'package:immoplus_pro/features/contract/logic/contract_mode.dart';
import 'package:immoplus_pro/features/contract/logic/contract_state.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class ContractPage extends StatefulWidget {
  final bool isSigned;
  final ContractMode mode;
  final VoidCallback? onSigned;

  const ContractPage({
    super.key,
    this.isSigned = false,
    this.mode = ContractMode.sign,
    this.onSigned,
  });

  static const String routeName = 'contract';
  static const String routePath = '/contract';

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  final GlobalKey<SfSignaturePadState> _signatureKey = GlobalKey();
  final ValueNotifier<bool> _hasSignature = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hasSignature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContractCubit(),
      child: BlocConsumer<ContractCubit, ContractState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            signed: () {
              ToastUtils.showSuccess(
                title: "Succès",
                description: "Contrat signé avec succès",
              );
              if (widget.onSigned != null) {
                widget.onSigned!.call();
              } else {
                context.pop(true);
              }
            },
            error: (message) {
              ToastUtils.showError(
                title: "Erreur",
                description: message,
              );
            },
          );
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.scafold,
            appBar: AppBar(
              title: const Text('Mon Contrat'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HtmlWidget(_contractHtml),
                  ),
                ),
                _buildBottomSection(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, ContractState state) {
    if (widget.isSigned) {
      return _buildSignedBadge();
    }

    if (widget.mode == ContractMode.read) {
      return _buildCloseButton(context);
    }

    return _buildSignaturePad(context, state);
  }

  Widget _buildSignedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 28),
          const Gap(10),
          Text(
            'Contrat signé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Fermer', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildSignaturePad(BuildContext context, ContractState state) {
    final isLoading = state == const ContractState.loading();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Signez ici',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const Gap(8),
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SfSignaturePad(
                key: _signatureKey,
                backgroundColor: Colors.white,
                strokeColor: Colors.black,
                minimumStrokeWidth: 1.5,
                maximumStrokeWidth: 4.0,
                onDrawStart: () {
                  _hasSignature.value = true;
                  return false;
                },
              ),
            ),
          ),
          const Gap(12),
          ValueListenableBuilder<bool>(
            valueListenable: _hasSignature,
            builder: (context, hasSigned, _) {
              final canValidate = hasSigned && !isLoading;
              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () {
                              _signatureKey.currentState?.clear();
                              _hasSignature.value = false;
                            },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Effacer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: canValidate
                          ? () => _handleValidateSignature(context)
                          : null,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(
                        isLoading ? 'Validation...' : 'Valider la signature',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade500,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleValidateSignature(BuildContext context) async {
    final renderObject = _signatureKey.currentState?.toImage();
    if (renderObject == null) {
      ToastUtils.showError(
        title: "Erreur",
        description: "Veuillez signer avant de valider",
      );
      return;
    }

    final image = await _signatureKey.currentState!.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      ToastUtils.showError(
        title: "Erreur",
        description: "Impossible de récupérer la signature",
      );
      return;
    }

    final signatureBytes = byteData.buffer.asUint8List();

    if (!context.mounted) return;
    context.read<ContractCubit>().signContract(signatureBytes);
  }
}

const String _contractHtml = '''
<!DOCTYPE html>
<html lang="fr">
<body>
    <h1>Conditions Générales d'Utilisation (CGU)</h1>

    <h2>1. Objet</h2>
    <p>Les présentes conditions générales d'utilisation (CGU) ont pour objet de définir les modalités et conditions dans lesquelles les utilisateurs peuvent utiliser l'application ImmoPlus.</p>

    <h2>2. Accès et inscription</h2>
    <p>L'accès à certaines fonctionnalités de l'application nécessite une inscription préalable. Lors de la création d'un compte, l'utilisateur s'engage à fournir des informations exactes et à jour.</p>

    <h2>3. Utilisation de l'application</h2>
    <p>ImmoPlus permet aux utilisateurs de rechercher des propriétés, réserver des logements, contacter des agents immobiliers, organiser des visites et acheter des meubles. L'utilisateur doit utiliser l'application de manière responsable et s'engage à ne pas utiliser les services à des fins illégales ou frauduleuses.</p>

    <h2>4. Réservation et paiement</h2>
    <p>Les réservations de logements se font via l'application. Le paiement peut être effectué directement par l'application selon les modes de paiement disponibles. L'utilisateur est responsable de vérifier les détails de la réservation avant de valider le paiement.</p>

    <h2>5. Propriété intellectuelle</h2>
    <p>Tous les éléments présents dans l'application (textes, images, logos, etc.) sont protégés par le droit de la propriété intellectuelle. Toute reproduction ou utilisation non autorisée de ces éléments est strictement interdite.</p>

    <h2>6. Responsabilité</h2>
    <p>ImmoPlus met à disposition des informations sur les biens immobiliers, mais ne peut être tenue responsable de l'exactitude ou de la mise à jour des informations fournies par des tiers (propriétaires, agents immobiliers). L'utilisateur est responsable de vérifier les informations fournies avant de prendre une décision.</p>

    <h2>7. Modification des CGU</h2>
    <p>ImmoPlus se réserve le droit de modifier les présentes CGU à tout moment. Les utilisateurs seront informés des modifications via l'application.</p>

    <h2>Mentions légales</h2>
    <h3>1. Éditeur de l'application</h3>
    <ul>
        <li><strong>Nom :</strong> ImmoPlus</li>
        <li><strong>Société :</strong> AfriqSolus SARL</li>
        <li><strong>Adresse :</strong> Cocody Rivera Faya, Abidjan, Côte d'Ivoire</li>
        <li><strong>Téléphone :</strong> (+225) 27 22 28 38 81</li>
        <li><strong>Email :</strong> contact@afriqsolus.ci</li>
    </ul>

    <h3>2. Directeur de publication</h3>
    <p><strong>Nom :</strong> Assoko Moune Moise</p>
    <p><strong>Téléphone :</strong> 0779801183</p>
    <p><strong>Email :</strong> m.assoko@afrisolus.ci</p>

    <h3>3. Propriété intellectuelle</h3>
    <p>L'ensemble du contenu de l'application ImmoPlus est protégé par le droit de la propriété intellectuelle. Toute reproduction ou représentation, en tout ou partie, est strictement interdite.</p>

    <h3>Date de prise d'effet et date de la dernière mise à jour :</h3>
    <p>01.10.2024</p>

    <h2>Politique de confidentialité</h2>
    <h3>1. Introduction</h3>
    <p>ImmoPlus est une application de gestion immobilière conçue pour simplifier votre recherche de propriété immobilière idéale, l'achat de terrains, et la commande de meubles pour votre nouvelle maison.</p>

    <h3>2. Informations que nous collectons</h3>
    <p>Nous collectons des informations vous concernant lorsque vous utilisez notre application et nos Services.</p>
    <ul>
        <li><strong>Informations collectées directement auprès de vous :</strong> Nom d'utilisateur, adresse électronique, etc.</li>
        <li><strong>Informations collectées automatiquement :</strong> Informations sur l'appareil (système d'exploitation, adresse IP, etc.)</li>
    </ul>

    <h3>3. Cookies et technologies associées</h3>
    <p>Nous utilisons des cookies et des technologies associées afin de reconnaître votre appareil et de vous fournir des fonctionnalités et des services essentiels.</p>

    <h3>4. Utilisation de vos informations</h3>
    <p>Nous utilisons les informations collectées principalement pour des fins de gestion de l'application Afriq'solus.</p>

    <h3>5. Communication de vos informations</h3>
    <p>Vos données seront communiquées aux destinataires suivants : Directions et services de Afriq'solus, fournisseurs de services cloud, autorités administratives, etc.</p>

    <h3>6. Transferts de données</h3>
    <p>Nous sommes susceptibles de transférer vos informations dans des pays et régions autres que ceux dans lesquels vous vous trouvez.</p>

    <h3>7. Conservation et suppression d'informations personnelles</h3>
    <p>Nous supprimons vos informations dans les plus brefs délais, une fois l'objectif de la collecte atteint.</p>

    <h3>8. Droits reconnus des personnes concernées</h3>
    <p>Vous avez des droits relatifs à la protection de vos données, tels que le droit d'accès, de rectification, d'opposition et d'effacement.</p>

    <h3>9. Sécurité des données</h3>
    <p>ImmoPlus prend des mesures techniques et organisationnelles pour protéger les données personnelles contre l'accès non autorisé.</p>

    <h3>10. Modifications de la politique de confidentialité</h3>
    <p>ImmoPlus se réserve le droit de modifier cette politique de confidentialité à tout moment.</p>

</body>
</html>
''';
