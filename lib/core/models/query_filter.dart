import 'dart:convert';

enum FilterOperator {
  eq('eq'),
  neq('neq'),
  gt('gt'),
  gte('gte'),
  lt('lt'),
  lte('lte'),
  contains('contains');

  final String value;
  const FilterOperator(this.value);
}

class QueryFilter {
  final String field;
  final FilterOperator operator;
  final dynamic value;

  QueryFilter({
    required this.field,
    required this.operator,
    required this.value,
  });

  /// Convertit le filtre en chaine JSON attendue par le backend dans la liste `_where`
  String toJsonString() {
    return jsonEncode({
      "_field": field,
      "_op": operator.value,
      "_val": value.toString(),
    });
  }
}

class QueryBuilder {
  /// Construit la Map de filtres pour les requêtes paginées
  static Map<String, dynamic> build({List<QueryFilter>? filters}) {
    if (filters == null || filters.isEmpty) return {};
    return {
      '_where': filters.map((f) => f.toJsonString()).toList(),
    };
  }
}
