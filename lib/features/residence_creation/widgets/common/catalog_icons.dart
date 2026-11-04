import 'package:flutter/material.dart';
import 'package:immoplus_pro/svgs_icons.dart';

/// Icônes des éléments de catalogue (types de logement, équipements).
///
/// Les SVG bicolores du projet sont retrouvés par **code** de catalogue :
/// l'API ne fournit un nom d'icône que pour quelques équipements. Sans SVG
/// correspondant, on retombe sur une icône Material choisie d'après le nom
/// d'icône de l'API, puis sur une icône neutre.
abstract class CatalogIcons {
  /// Code de catalogue -> clé de `SVGMap` (SVG historiques du projet).
  static const Map<String, String> _legacySvgKeyByCode = {
    // Types de logement
    'APPARTEMENT': 'building-user-solid',
    'STUDIO': 'studio',
    'DUPLEX': 'cottage',
    'VILLA': 'villa',
    'MAISON': 'home',
    // Équipements
    'WIFI': 'wifi',
    'TELEVISION': 'tv',
    'SMART_TV': 'tv',
    'CLIMATISEUR': 'wind',
    'VENTILATEUR': 'fan-solid',
    'SERVIETTES': 'dry_cleaning',
    'PARKING_GRATUIT': 'directions_car',
    'PARKING_PRIVE': 'directions_car',
    'MICRO_ONDE': 'microwave',
    'LAVE_LINGE': 'local_laundry',
    'CUISINIERE': 'oven',
    'REFRIGERATEUR': 'kitchen',
    'USTENSILES_CUISINE': 'kitchen-set-solid',
    'DRAPS_LINGE_LIT': 'bed',
    'OREILLERS_COUVERTURES': 'bed',
  };

  /// Code de catalogue -> pictogramme de `assets/svgs/catalog/`, dessinés dans
  /// le même style que les SVG historiques. Les équipements voisins partagent
  /// le même pictogramme.
  static const Map<String, String> _catalogGlyphByCode = {
    'TRIPLEX': 'triplex',
    'LOFT': 'loft',
    'BUNGALOW': 'bungalow',
    'CHAUFFE_EAU': 'water_heater',
    'EAU_CHAUDE': 'water_heater',
    'GROUPE_ELECTROGENE': 'generator',
    'GROUPE_ELECTROGENE_AUTO': 'generator',
    'ONDULEUR_UPS': 'battery_bolt',
    'PANNEAU_SOLAIRE_BATTERIE': 'solar_panel',
    'PANNEAUX_SOLAIRES': 'solar_panel',
    'PISCINE_EQUIPEMENT': 'pool',
    'CITERNE_EAU': 'water_tank',
    'CHATEAU_D_EAU': 'water_tower',
    'FORAGE_PUITS': 'well',
    'FILTRATION_EAU': 'filter',
    'ADOUCISSEUR_EAU': 'filter',
    'DISTRIBUTEUR_EAU': 'dispenser',
    'ECLAIRAGE_LED': 'bulb',
    'ECLAIRAGE_EXTERIEUR_SECURITE': 'bulb',
    'DETECTEUR_FUITE_EAU': 'leak_detector',
    'HUMIDIFICATEUR': 'humidifier',
    'PURIFICATEUR_AIR': 'purifier',
    'CHAUFFAGE': 'heater',
    'CHAUFFAGE_AU_SOL': 'floor_heating',
    'CHEMINEE': 'fireplace',
    'POELE_A_BOIS': 'fireplace',
    'CHEMINEE_EXTERIEURE': 'fire_pit',
    'ENCEINTE_BLUETOOTH': 'speaker',
    'CHAINE_HIFI': 'speaker',
    'KARAOKE': 'mic',
    'PRISES_INTERNATIONALES': 'plug',
    'STORES_ELECTRIQUES': 'blinds',
    'STORE_BANNE': 'awning',
    'MOUSTIQUAIRES': 'net',
    'RIDEAUX_OCCULTANTS': 'curtains',
    'VISIOPHONE': 'intercom',
    'INTERPHONE': 'intercom',
    'SONNETTE_CONNECTEE': 'intercom',
    'ESPACE_TRAVAIL_DEDIE': 'desk',
    'DECODEUR_TV': 'decoder',
    'PROJECTEUR_VIDEOPROJECTEUR': 'projector',
    'KITCHENETTE': 'kitchenette',
    'CONGELATEUR': 'freezer',
    'FOUR': 'oven',
    'PLAQUE_INDUCTION': 'hob',
    'BOUILLOIRE': 'kettle',
    'GRILLE_PAIN': 'toaster',
    'CAFETIERE': 'coffee_maker',
    'BLENDER_MIXEUR': 'blender',
    'PRESSE_AGRUMES': 'blender',
    'ROBOT_CUISEUR': 'blender',
    'AUTOCUISEUR': 'pressure_cooker',
    'MACHINE_A_PAIN': 'bread_machine',
    'BALANCE_CUISINE': 'scale',
    'BALANCE_SALLE_DE_BAIN': 'scale',
    'VAISSELLE': 'dishes',
    'LAVE_VAISSELLE': 'dishwasher',
    'KIT_FONDUE_RACLETTE': 'fondue',
    'MACHINE_A_GLACONS': 'ice_cube',
    'CINTRES': 'hanger',
    'RANGEMENT_VETEMENTS': 'wardrobe',
    'SECHE_LINGE': 'dryer',
    'FER_A_REPASSER': 'iron',
    'ETENDOIR_CORDE_A_LINGE': 'clothesline',
    'SECHE_CHEVEUX': 'hairdryer',
    'PEIGNOIR': 'bathrobe',
    'ARTICLES_TOILETTE': 'toiletries',
    'SAVON_SHAMPOING_FOURNIS': 'toiletries',
    'SECHE_SERVIETTES': 'towel_rail',
    'MIROIR_GROSSISSANT': 'mirror',
    'EXTINCTEUR': 'extinguisher',
    'DETECTEUR_FUMEE': 'smoke_detector',
    'DETECTEUR_CO2': 'co_detector',
    'CAMERA_SECURITE': 'cctv',
    'VIDEOSURVEILLANCE_EXTERIEURE': 'cctv',
    'ALARME': 'alarm',
    'COFFRE_FORT': 'safe',
    'PORTAIL_SECURISE': 'gate',
    'PORTAIL_AUTOMATIQUE': 'gate',
    'GARDIENNAGE': 'guard',
    'TROUSSE_PREMIERS_SECOURS': 'first_aid',
    'DIGICODE': 'keypad',
    'LECTEUR_BADGE': 'badge_reader',
    'DETECTEUR_MOUVEMENT': 'motion',
    'ISSUE_DE_SECOURS': 'exit',
    'PLAN_EVACUATION': 'evac_plan',
    'RECHARGE_VEHICULE_ELECTRIQUE': 'ev_charger',
    'JACUZZI': 'jacuzzi',
    'JARDIN_EQUIPEMENT': 'garden',
    'BARBECUE': 'barbecue',
    'BALCON_TERRASSE_MEUBLEE': 'balcony',
    'MOBILIER_JARDIN': 'bench',
    'CHAISES_PARASOLS_PLAGE': 'parasol',
    'HAMAC': 'hammock',
    'DOUCHE_EXTERIEURE': 'outdoor_shower',
    'FOUR_A_PIZZA_EXTERIEUR': 'pizza_oven',
    'PLANCHA': 'plancha',
    'SYSTEME_ARROSAGE_AUTOMATIQUE': 'sprinkler',
    'COMPOST': 'compost',
    'TONDEUSE_GAZON': 'mower',
    'SOUFFLEUR_FEUILLES': 'leaf_blower',
    'KIT_JARDINAGE': 'garden_kit',
    'ETABLI_OUTILS': 'toolbox',
    'VELO': 'bike',
    'VELO_ELECTRIQUE': 'ebike',
    'TROTTINETTE_ELECTRIQUE': 'escooter',
    'SALLE_SPORT_EQUIPEMENT': 'dumbbell',
    'BILLARD': 'billiards',
    'BABY_FOOT': 'foosball',
    'CONSOLE_JEUX': 'gamepad',
    'TERRAIN_SPORT': 'sports_field',
    'COURT_TENNIS': 'tennis',
    'TERRAIN_BASKET': 'basketball',
    'PETANQUE': 'petanque',
    'MINI_GOLF': 'minigolf',
    'KAYAK_CANOE': 'kayak',
    'PADDLE': 'paddle',
    'MATERIEL_PLONGEE': 'diving_mask',
    'BAR_EQUIPE': 'cocktail',
    'CAVE_A_WHISKY': 'whisky',
    'PING_PONG': 'pingpong',
    'FLECHETTES': 'darts',
    'JEUX_DE_SOCIETE': 'dice',
    'WIFI_HAUT_DEBIT': 'wifi_fast',
    'DOMOTIQUE': 'smart_home',
    'BOITE_A_CLES': 'key_box',
    'ASCENSEUR': 'elevator',
    'ACCES_HANDICAPE': 'wheelchair',
    'ESPACE_BAGAGES': 'luggage',
    'LOCAL_BAGAGES_SECURISE': 'luggage',
    'CASIERS_CONSIGNE': 'lockers',
    'ASPIRATEUR': 'vacuum',
    'BALAI_SERPILLIERE': 'broom',
    'PRODUITS_MENAGERS': 'spray',
    'ESSUIE_TOUT': 'paper_roll',
    'LIT_BEBE_PARC': 'crib',
    'CHAISE_HAUTE': 'high_chair',
    'JOUETS_ENFANTS': 'teddy',
  };

  /// SVG historiques sans couleur propre : ils doivent être teintés.
  static const Set<String> _monochromeSvgKeys = {'studio'};

  /// Codes de catalogue qui ont un SVG.
  static Iterable<String> get mappedCodes =>
      [..._legacySvgKeyByCode.keys, ..._catalogGlyphByCode.keys];

  /// Chemin du SVG associé à ce code, ou `null` s'il n'y en a pas.
  static String? svgAsset(String code) {
    final legacyKey = _legacySvgKeyByCode[code];
    if (legacyKey != null) return SVGMap.map[legacyKey];

    final glyph = _catalogGlyphByCode[code];
    return glyph == null ? null : 'assets/svgs/catalog/$glyph.svg';
  }

  static bool needsTint(String code) =>
      _monochromeSvgKeys.contains(_legacySvgKeyByCode[code]);

  static IconData fallback(String? iconName) =>
      _materialIcons[iconName] ?? Icons.check_circle_outline;

  static const Map<String, IconData> _materialIcons = {
    'baby': Icons.child_care,
    'bath': Icons.bathtub_outlined,
    'bed': Icons.bed_outlined,
    'briefcase': Icons.work_outline,
    'building': Icons.apartment,
    'camera': Icons.videocam_outlined,
    'car': Icons.directions_car_outlined,
    'door': Icons.door_front_door_outlined,
    'droplet': Icons.water_drop_outlined,
    'fire-extinguisher': Icons.fire_extinguisher,
    'flame': Icons.local_fire_department_outlined,
    'home': Icons.home_outlined,
    'layers': Icons.layers_outlined,
    'refrigerator': Icons.kitchen_outlined,
    'shower': Icons.shower_outlined,
    'siren': Icons.notifications_active_outlined,
    'snowflake': Icons.ac_unit,
    'sofa': Icons.weekend_outlined,
    'tree': Icons.park_outlined,
    'tv': Icons.tv,
    'utensils': Icons.restaurant_outlined,
    'warehouse': Icons.warehouse_outlined,
    'washing-machine': Icons.local_laundry_service_outlined,
    'waves': Icons.pool,
    'wifi': Icons.wifi,
    'zap': Icons.bolt,
  };
}
