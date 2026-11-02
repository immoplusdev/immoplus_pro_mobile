import 'dart:async';

import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';

typedef CatalogLoader = Future<List<CatalogGroup>> Function(
  String endpoint, {
  String? search,
});

/// Affiche l'état de chargement / d'erreur d'un catalogue, puis [builder]
/// avec ses groupes.
class CatalogFutureBuilder extends StatelessWidget {
  const CatalogFutureBuilder({
    super.key,
    required this.future,
    required this.onRetry,
    required this.builder,
  });

  final Future<List<CatalogGroup>> future;
  final VoidCallback onRetry;
  final Widget Function(List<CatalogGroup> groups) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CatalogGroup>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Impossible de charger la liste. Réessayer'),
            ),
          );
        }
        return builder(snapshot.data ?? const []);
      },
    );
  }
}

/// Champ de recherche avec temporisation, utilisé par les catalogues.
class CatalogSearchField extends StatefulWidget {
  const CatalogSearchField({
    super.key,
    required this.hint,
    required this.onSearch,
  });

  final String? hint;
  final ValueChanged<String> onSearch;

  @override
  State<CatalogSearchField> createState() => _CatalogSearchFieldState();
}

class _CatalogSearchFieldState extends State<CatalogSearchField> {
  static const Duration _debounce = Duration(milliseconds: 350);
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onChanged(String text) {
    _timer?.cancel();
    _timer = Timer(_debounce, () => widget.onSearch(text));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onChanged,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        hintText: widget.hint ?? 'Rechercher',
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray400),
        suffixIcon: Icon(Icons.search, color: AppColors.gray400),
        filled: true,
        fillColor: CreationStyle.inputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
          borderSide: BorderSide(color: CreationStyle.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
          borderSide: BorderSide(color: CreationStyle.border),
        ),
      ),
    );
  }
}
