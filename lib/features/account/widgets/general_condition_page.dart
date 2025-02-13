import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/main.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_loading_button.dart';

class GeneralConditionPage extends StatelessWidget {
  const GeneralConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conditions Générales d’utilisation'),
      ),
      body: Markdown(
          data:
              '''ARTICLE 1 – OBJET DES CONDITIONS GENERALES D’UTILISATION (CGU)
Les présentes conditions générales d’utilisation (ci-après « CGU ») encadrent juridiquement l’utilisation de l’application mobile « Immo+» (ci-après « l’application ») éditée par la Société Afriq’solus, Société à Responsabilité Limitée au capital de cinq million de francs CFA (5 000 000), dont le siège social est à Cocody, 06 BP 2506 Abidjan 06, Côte d’ivoire, immatriculée au centre des impôts de Cocody Faya sous le Numéro de Compte Combrituable ......, représentée par le Gérant Monsieur ASSOKO MOUNE MOISE.
En installant l’application sur votre terminal et/ou en accédant à l’application, vous acceptez sans réserve l’intégralité des présentes CGU et vous engagez à respecter les obligations à votre charge. En cas de désaccord ou de réserves, vous êtes priés de renoncer à l’utilisation de la présente application.
Les CGU expriment l'intégralité de l'accord entre vous et Afriq’solus applicable à votre utilisation de l’application. Afriq’solus se réserve le droit de modifier ces CGU en les mettant à jour à tout moment.  La version des CGU qui est applicable entre vous et Afriq’solus est celle en vigueur au moment de votre connexion et de votre  utilisation de l’application.  Nous vous saurions donc gré de bien vouloir consulter cette page régulièrement afin de prendre connaissance des CGU en vigueur lorsque vous êtes sur l’application.
 
ARTICLE 2 – OBJECTIFS ET SERVICES DE L’APPLICATION
L’application vous vise à:
Trouver instantanément des logements et des biens disponibles immédiatement à la vente ou à la location autour de vous;
Sélectionner vos biens et préparer vos visites ;
Contacter directement l’équipe depuis l’application ;
Accéder à toute l’actualité de la communauté Afriq’solus.
Ces fonctionnalités peuvent être complètées ou modifiées à tout moment par Afriq’solus sans que sa responsabilité ne puisse être engagée à ce titre.
 
ARTICLE 3 – MOYENS D’ACCES A L’APPLICATION
Pour accéder à l’application, vous devez disposer d’un terminal mobile et d’un accès au réseau Internet.
L’application est téléchargeable gratuitement depuis les plateformes « Apple Store » et « Google Play Store ».
La version du logiciel de l’application peut être mise à jour de temps à autre pour agrémenter celle-ci de nouvelles fonctions et de nouveaux services.
Une fois l’application installée sur votre terminal, il vous suffit de vous connecter en utilisant votre adresse identifiant.
Si vous êtes un client ou un fournisseur référencé chez Afriq’solus, vous recevrez une notification selon votre moyen de connexion,vous permettant de valider votre compte.
2
 
Si vous ne faites pas encore partie de la communauté, n’hésitez pas à nous contacter pour profiter de tous les avantages de nos services à cette adresse :…………
 
Vous vous engagez, lors de votre utilisation et navigation sur l’application, à fournir des informations vraies, exactes et aussi complètes que possible. Vous vous engagez également à mettre à jour ces informations dans les meilleurs délais en cas de changement de celles-ci.
 
ARTICLE 4 – AUTORISATION D’UTILISATION
Afriq’solus vous confère un droit personnel d’utilisation de l’application et de son contenu. Ce droit est accordé à titre non exclusif, révocable, non cessible, non transférable, mondial et gratuit et pour la seule utilisation de l’application, à l’exclusion de toute autre finalité.
Il est strictement interdit d’accéder et/ou d’utiliser et/ou de tenter d’accéder ou d’utiliser les codes sources ou objets de l’application.
Vous n’acquérez aucun droit de propriété intellectuelle sur l’application ou son contenu, ni aucun autre droit que ceux conférés par les présentes CGU.
ARTICLE 5 - DONNÉES DES UTILISATEURS
Les données personnelles utilisées sont principalement votre nom, prénom, fonction, adresse, numéro de téléphone, adresse mail, bien recherché et/ou disponible.
Vous avez la possibilité d’accéder et/ou de modifier vos inrofmations  en  nous  envoyant  un  mail à l’adresse suivante: ……………….
 
 
ARTICLE 6 - PROPRIÉTÉ INTELLECTUELLE
L’application relève de la législation Ivoirienne, communautaire et internationale sur le droit d'auteur et la propriété intellectuelle.
Tous les droits de reproduction et de représentation liés à l’application sont réservés par Afriq’solus, y compris toutes representations graphiques, iconographiques et photographiques, ce quel que soit le territoire de protection et que ces droit aient fait l'objet d'un dépôt ou non.
La reproduction et/ou représentation de tout ou partie de l’application, quel que soit le support, en ce compris tous noms commerciaux, marques, logos, noms de domaine et autres signes distinctifs, est formellement interdite et constituerait une contrefaçon sanctionnée par le code de la propriété intellectuelle.
Les mots Afriq’solus, Immo+ et tous les logos émanent de Afriq’solus.
 
ARTICLE 7 – DISPONIBILITE DE L’APPLICATION
L’application est disponible en ligne 7 jours sur 7 et 24 heures sur 24.
Cependant, compte tenu de la complexité du réseau internet et des pics de connexion, à  certaines  heures  des  utilisateurs d'internet, Afriq’solus n'offre aucune garantie de continuité du service et ne pourra voir sa responsabilité engage, en cas d'impossibilité temporaire d'accéder en tout ou partie à l’application. Aucun droit à indemnisation n’est accordé au titre du présent alinéa.
Afriq’solus se réserve le droit de cesser, sans préavis, sans indemnité et à son entière discrétion, à titre définitif ou provisoire, de fournir tout ou partie du service ou des fonctionnalités de l’application.
2
 
 
 
ARTICLE 8 – ENCADREMENT DE RESPONSABILITE – ABSENCE DE GARANTIE
Afriq’solus s'engage à mettre en œuvre tous les moyens nécessaires afin d'assurer au mieux l’accès à l’application.
Toutefois,vous êtes l’unique responsable de vos identifiants. Vous vous engagez à les garder confidentiels et à ne pas les transmettre à des tiers. Si vous vous apercevez d'une utilisation non autorisée de votre compte, il vous incombe d'en informer immédiatement Afriq’solus en écrivant à l'adresse suivante : …………………..
Plus généralement, vous acceptez et reconnaissez que votre utilisation de l’application, y compris   les   informations   que vous   partagez, est faite   sous votre   unique   et   entière responsabilité.
En utilisant l’application, vous vous engagez à agir de manière responsable, à ne pas agir de manière dommageable ou en vue de causer un préjudice à l’image, aux intérêts ou aux droits de Afriq’solus, d’endommager ou de rendre inopérante l’application.
Afriq’solus ne saurait être tenue pour responsable et ne saurait être tenue de vous indemniser du préjudice direct ou indirect qui résulterait de l’indisponibilité momentanée ou définitive de l’application. Afriq’solus ne saurait à cet égard être tenue pour responsable de tout dommage résultant de la perte, de l’altération ou de toute utilisation frauduleuse de données, de la transmission accidentelle de virus ou autres éléments nuisibles, de l’attitude ou comportement d’un tiers. Elle n’encourt aucune responsabilité du fait de l’impossibilité d’accéder à l’Application, d’une mauvaise utilisation de l’Application, de la saturation du réseau internet, d’éventuels dysfonctionnements sur les terminaux mobiles utilisés par vous, en cas de force majeure ou de fait ne lui incombant pas.
 
ARTICLE 9 - NON RENONCIATION
Le fait pour l'une des parties de ne pas se prévaloir instantanément d'un manquement par l'autre partie de l'une quelconque des obligations visées dans les présentes CGU, ne saurait être interprété pour l'avenir comme une renonciation à l'obligation en cause.
 
ARTICLE  10 – NON REMBOURSEMENT
Tout paiement effectué sur la présente application en vue de la réservation, de la location ou de l’achat d’un bien ne saurait donner lieu à aucun remboursement en cas de désistement de l’utilisateur/ du client.
 
ARTICLE 11- REGLEMENT DE LITIGES
Les présentes CGU sont soumises au droit Ivoirien.
Tout litige découlant de l’utilisation de la présente application ne saurait donner lieu à l’exposition de Afriq’solus ou de l’une quelconque de ses démembrements sur les réseaux sociaux et/ou autres plateformes de communication.
Tout litige concernant l’application ou l’interprétation des présentes CGU sera soumis à un préalable de tentative de règlement amiable entre les parties avant toute saisine du tribunal compétent d’Abidjan.
 
ARTICLE  12 - PREOCCUPATIONS
Vous pouvez joindre l’équipe Afriq’solus relativement à vos préoccupations concernant l’application ou les CGU à l'adresse suivante: ……………………………..
 
 
POLITIQUE DE CONFIDENTIALITE ET DE PROTECTION DES DONNEES A CARACTERE PERSONNEL
 
1. Information que nous collectons
 
Nous collectons des informations vous concernant lorsque vous utilisez notre application et nos Services. Ces informations peuvent être nécessaires pour conclure un contrat avec vous ou exécuter un contrat avec vous (par exemple, conclure un contrat de location ou de vente ). Si les informations demandées ne sont pas fournies, nous ne serons peut-être pas en mesure de fournir Service demandé. Les informations que nous collectons relèvent des deux catégories suivantes :
Informations collectées auprès de vous
Vous êtes susceptible de nous communiquer les informations suivantes lorsque vous utilisez notre application. Les informations comprennent notamment :
- Nom et prénoms
- Numéro de téléphone
- Adresse électronique Email
- Numéro de la carte bancaire
- Langue
Informations collectées automatiquement
Nous collectons automatiquement certaines informations lorsque vous utilisez nos Services.
Le type d'informations que nous collectons automatiquement inclut généralement:
- les informations sur l'appareil (adresse IP, ID de l'appareil, modèle de l'appareil, système d’exploitation de l’appareil)
- les cookies et des technologies associées afin de reconnaître votre navigateur ou appareil, d'en savoir plus sur vos centres d'intérêts et de vous fournir des fonctionnalités et des services essentiels, entre autres. Des tiers autorisés peuvent également configurer des cookies et d'autres technologies lorsque vous utilisez notre Site.
- Les cookies sont de petits fichiers texte téléchargés sur votre appareil.
 
2. Traitement de données et finalités
 
Nous procédons à la collecte, enregistrement, conservations, communication, suppression, archivage de vos données à caractère personnel
Pour des fins diverses, Cela comprend :
 
- la création de votre compte/profil
 
- la gestion des reportings,
 
- la gestion du marketing et de la prospection commerciale
- la gestion du système information
 
3. Communication et transfert de donnée
Partage de vos informations
 
Nous communiquons vos données personnelles à des sous-traitants pour effectuer différentes tâches, notamment le stockage de vos informations sur un cloud le paiement des services. Il s’agit des :
 
- Fournisseurs de services de cloud ( Ocean….)
 
- Fournisseurs de service de paiement pour aider lors du paiement des transactions (Orange, Mtn,Moov,Wave
 
4. Conservation et suppression de données
 
Selon les dispositions de la loi 2013-450, nous sommes tenu de conserver vos données jusqu’à l’accomplissement des finalités puis les supprimer. Vos données à caractère personnel seront conservées uniquement pour la durée nécessaire pour l’accomplissement des finalités ci-dessus définies, et/ou pour la durée de conservation définie par la loi applicable
En principe, nous supprimons vos informations dans les plus brefs délais, une fois l'objectif de la collecte atteint. Les informations conservées sous forme physique sont déchiquetées ou incinérées et les informations personnelles conservées au format électronique sont supprimées en utilisant des mesures techniques qui ne permettent pas de les reproduire. Cependant, nous sommes susceptibles de conserver vos informations personnelles pendant même après que vous avez fermé votre compte chez nous ou que nous avons cessé de vous fournir les services, s'il est nécessaire de les conserver afin de nous conformer aux obligations légales, respecter les exigences réglementaires, résoudre les litiges, empêcher les fraudes ou les abus. Pour plus d’information vous pouvez contacter notre correspondant à la protection des données.
 
5. Vos droits dont vous disposez
Vous disposez de droits, conformément aux articles 28 à 33 de la loi N°2013-450 du 19 juin 2013 relative à la protection des données à caractère personnel. Ainsi :  
Vous avez le droit d’être informés, lors de la collecte de vos données, de l’identité du responsable du traitement, des finalités de traitement, du type de données concernées, des destinataires, de la durée de conservation des données et de l’éventualité de transfert de données à destination de pays tiers.Vous avez le droit d’accéder aux données à caractère personnel vous concernant en notre possession.Vous avez le droit de rectifier toute donnée inexacte, ou de compléter toute donnée incomplète. Vous avez le droit de vous opposer au traitement de vos données à caractère personnel, sauf dans les cas définis par la loi N°2013-450 du 19 juin 2013 ; de même vous pouvez retirer votre consentement au traitement de vos données à caractère personnel dans la mesure où votre consentement justifiait le traitement. Vous pouvez demander l’effacement de vos données à caractère personnel si leur traitement n’est plus nécessaire pour les finalités décrites ci-avant, lorsque le traitement n’est pas ou plus licite pour quelques raisons que ce soit, lorsque vous avez retiré votre consentement au traitement (dans la mesure où vous n’êtes pas dans une relation de travail avec nous et votre consentement justifiait le traitement), lorsque l’effacement est nécessaire pour se conformer à la loi applicable ou lorsque vous vous opposez au traitement en l’absence de tout motif légitime prépondérant pour un tel traitement.
Afriq’Solus s’engage à répondre à toute plainte ou demande d’exercice des droits relatifs à vos données à caractère personnel gratuitement et dans les meilleurs délais (01 mois au maximum, sauf pour les cas les plus complexes).
Par ailleurs en vertus de l’article 29 relative à la loi n°2013-450 Afriq’Solus a le droit de s’opposer aux demandes manifestement abusives de la même personne, notamment par leur nombre, leur caractère répétitif ou systématique.
Toute demande doit être accompagnée de la photocopie d’un justificatif d’identité, faute de quoi elle ne pourra être traitée.
Vous pouvez exercer les droits mentionnés ci-dessus en contactant notre correspondant à la protection des données à caractère personnel aux coordonnées ci-dessous :  
 
'''),
      // bottomNavigationBar: Container(
      //   height: 100,
      //   padding: const EdgeInsets.all(10.0),
      //   child: CustomButtom(
      //     color: Theme.of(context).colorScheme.primary,
      //     onClick: () {
      //       // if (_formKey.currentState!.validate()) {
      //       //   context.read<LoginCubit>().registerSendData(
      //       //       formController: _formController,
      //       //       context: context);
      //       // }

      //       //context.go('/homePage');
      //     },
      //     text: "Accepter",
      //   ),
      // ),
    );
  }
}
