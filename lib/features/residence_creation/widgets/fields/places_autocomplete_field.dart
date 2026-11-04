import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/place_suggestion.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';
import 'package:uuid/uuid.dart';

/// Champ `google_places_autocomplete` : l'utilisateur tape une adresse, choisit
/// une suggestion Google, et on récupère l'adresse et sa position GPS.
/// Tant qu'aucune suggestion n'est choisie, la valeur reste `null`.
class PlacesAutocompleteField extends StatefulWidget {
  const PlacesAutocompleteField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.search,
    required this.resolve,
    required this.onChanged,
    this.pickOnMap,
  });

  final CreationField field;
  final PlaceSelection? value;
  final String? errorText;
  final Future<List<PlaceSuggestion>> Function(
    String input, {
    String? sessionToken,
  }) search;
  final Future<PlaceSelection> Function(
    PlaceSuggestion suggestion, {
    String? sessionToken,
  }) resolve;
  final ValueChanged<PlaceSelection?> onChanged;

  /// Si fourni, affiche un bouton « carte » à côté du champ : position
  /// actuelle ou point choisi sur la carte.
  final Future<PlaceSelection?> Function(BuildContext context)? pickOnMap;

  @override
  State<PlacesAutocompleteField> createState() =>
      _PlacesAutocompleteFieldState();
}

class _PlacesAutocompleteFieldState extends State<PlacesAutocompleteField> {
  static const Duration _debounce = Duration(milliseconds: 400);
  static const int _minChars = 3;

  late final TextEditingController _controller =
      TextEditingController(text: widget.value?.address ?? '');
  final FocusNode _focusNode = FocusNode();

  Timer? _timer;
  String _sessionToken = const Uuid().v4();
  List<PlaceSuggestion> _suggestions = const [];
  bool _loading = false;
  String? _localError;

  @override
  void didUpdateWidget(PlacesAutocompleteField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Valeur fournie de l'extérieur (préremplissage de l'édition).
    final address = widget.value?.address;
    if (address != null && address != _controller.text) {
      _controller.text = address;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTyped(String text) {
    _localError = null;
    // Modifier le texte invalide l'adresse précédemment choisie.
    if (widget.value != null && text != widget.value!.address) {
      widget.onChanged(null);
    }

    _timer?.cancel();
    if (text.trim().length < _minChars) {
      setState(() {
        _suggestions = const [];
        _loading = false;
      });
      return;
    }
    _timer = Timer(_debounce, () => _fetch(text));
  }

  Future<void> _fetch(String text) async {
    setState(() => _loading = true);
    try {
      final result = await widget.search(text, sessionToken: _sessionToken);
      // Une frappe plus récente a pris le relais : on ignore cette réponse.
      if (!mounted || text != _controller.text) return;
      setState(() {
        _suggestions = result.take(5).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _suggestions = const [];
        _loading = false;
        _localError = 'Recherche indisponible. Vérifiez votre connexion.';
      });
    }
  }

  Future<void> _select(PlaceSuggestion suggestion) async {
    _focusNode.unfocus();
    _controller.text = suggestion.description;
    setState(() {
      _suggestions = const [];
      _loading = true;
      _localError = null;
    });
    try {
      final selection =
          await widget.resolve(suggestion, sessionToken: _sessionToken);
      _sessionToken = const Uuid().v4();
      if (!mounted) return;
      setState(() => _loading = false);
      widget.onChanged(selection);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _localError = 'Impossible de récupérer la position. Réessayez.';
      });
    }
  }

  Future<void> _pickOnMap() async {
    _focusNode.unfocus();
    _timer?.cancel();
    final selection = await widget.pickOnMap!(context);
    if (selection == null || !mounted) return;
    _controller.text = selection.address;
    setState(() {
      _suggestions = const [];
      _loading = false;
      _localError = null;
    });
    widget.onChanged(selection);
  }

  Widget _textField(CreationField field, String? error) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: _onTyped,
      maxLength: field.maxLength,
      style: AppTypography.bodyMedium,
      textInputAction: TextInputAction.search,
      decoration: creationInputDecoration(
        hint: field.placeholder,
        hasError: error != null,
        prefix: Icon(Iconsax.location, size: 18, color: AppColors.primary),
        suffix: _loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : (widget.value != null
                ? Icon(Icons.check_circle, size: 20, color: AppColors.green500)
                : null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.field;
    final error = widget.errorText ?? _localError;

    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: error,
      labelStyle: FieldLabelStyle.plain,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _textField(field, error)),
              if (widget.pickOnMap != null) ...[
                AppSpacing.gap8,
                _MapButton(onTap: _pickOnMap),
              ],
            ],
          ),
          if (_suggestions.isNotEmpty) ...[
            AppSpacing.gap8,
            _SuggestionList(suggestions: _suggestions, onTap: _select),
          ],
        ],
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({required this.suggestions, required this.onTap});

  final List<PlaceSuggestion> suggestions;
  final ValueChanged<PlaceSuggestion> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
        border: Border.all(color: CreationStyle.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < suggestions.length; i++) ...[
            if (i > 0) Divider(height: 1, color: CreationStyle.border),
            InkWell(
              onTap: () => onTap(suggestions[i]),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 20, color: AppColors.gray400),
                    AppSpacing.gap12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(suggestions[i].primaryText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMediumMedium
                                  .copyWith(color: AppColors.gray950)),
                          if (suggestions[i].secondaryText != null)
                            Text(suggestions[i].secondaryText!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.gray400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bouton carré à côté du champ, à la hauteur de la saisie.
class _MapButton extends StatelessWidget {
  const _MapButton({required this.onTap});

  final VoidCallback onTap;

  static const double _size = 50;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Choisir sur la carte',
      child: Material(
        color: CreationStyle.selectedFill,
        borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
          child: SizedBox(
            width: _size,
            height: _size,
            child: Icon(Icons.map_outlined, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
