// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOnboardingEntityCollection on Isar {
  IsarCollection<OnboardingEntity> get onboardingEntitys => this.collection();
}

const OnboardingEntitySchema = CollectionSchema(
  name: r'OnboardingEntity',
  id: 330131177673696620,
  properties: {
    r'hasReadOnboarding': PropertySchema(
      id: 0,
      name: r'hasReadOnboarding',
      type: IsarType.bool,
    ),
    r'readAt': PropertySchema(
      id: 1,
      name: r'readAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _onboardingEntityEstimateSize,
  serialize: _onboardingEntitySerialize,
  deserialize: _onboardingEntityDeserialize,
  deserializeProp: _onboardingEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _onboardingEntityGetId,
  getLinks: _onboardingEntityGetLinks,
  attach: _onboardingEntityAttach,
  version: '3.3.0-dev.1',
);

int _onboardingEntityEstimateSize(
  OnboardingEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _onboardingEntitySerialize(
  OnboardingEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.hasReadOnboarding);
  writer.writeDateTime(offsets[1], object.readAt);
}

OnboardingEntity _onboardingEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OnboardingEntity();
  object.hasReadOnboarding = reader.readBool(offsets[0]);
  object.id = id;
  object.readAt = reader.readDateTimeOrNull(offsets[1]);
  return object;
}

P _onboardingEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _onboardingEntityGetId(OnboardingEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _onboardingEntityGetLinks(OnboardingEntity object) {
  return [];
}

void _onboardingEntityAttach(
    IsarCollection<dynamic> col, Id id, OnboardingEntity object) {
  object.id = id;
}

extension OnboardingEntityQueryWhereSort
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QWhere> {
  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OnboardingEntityQueryWhere
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QWhereClause> {
  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OnboardingEntityQueryFilter
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QFilterCondition> {
  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      hasReadOnboardingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasReadOnboarding',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      readAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'readAt',
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      readAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'readAt',
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      readAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      readAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      readAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'readAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterFilterCondition>
      readAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'readAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OnboardingEntityQueryObject
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QFilterCondition> {}

extension OnboardingEntityQueryLinks
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QFilterCondition> {}

extension OnboardingEntityQuerySortBy
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QSortBy> {
  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      sortByHasReadOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReadOnboarding', Sort.asc);
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      sortByHasReadOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReadOnboarding', Sort.desc);
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      sortByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      sortByReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.desc);
    });
  }
}

extension OnboardingEntityQuerySortThenBy
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QSortThenBy> {
  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      thenByHasReadOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReadOnboarding', Sort.asc);
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      thenByHasReadOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReadOnboarding', Sort.desc);
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      thenByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QAfterSortBy>
      thenByReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAt', Sort.desc);
    });
  }
}

extension OnboardingEntityQueryWhereDistinct
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QDistinct> {
  QueryBuilder<OnboardingEntity, OnboardingEntity, QDistinct>
      distinctByHasReadOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasReadOnboarding');
    });
  }

  QueryBuilder<OnboardingEntity, OnboardingEntity, QDistinct>
      distinctByReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readAt');
    });
  }
}

extension OnboardingEntityQueryProperty
    on QueryBuilder<OnboardingEntity, OnboardingEntity, QQueryProperty> {
  QueryBuilder<OnboardingEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OnboardingEntity, bool, QQueryOperations>
      hasReadOnboardingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasReadOnboarding');
    });
  }

  QueryBuilder<OnboardingEntity, DateTime?, QQueryOperations> readAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readAt');
    });
  }
}
