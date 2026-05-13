// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_profile_item_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMeasurementProfileItemEntityCollection on Isar {
  IsarCollection<MeasurementProfileItemEntity>
      get measurementProfileItemEntitys => this.collection();
}

const MeasurementProfileItemEntitySchema = CollectionSchema(
  name: r'MeasurementProfileItemEntity',
  id: -9128142093866255609,
  properties: {
    r'deletedAt': PropertySchema(
      id: 0,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'measurementTypeInternalId': PropertySchema(
      id: 1,
      name: r'measurementTypeInternalId',
      type: IsarType.string,
    ),
    r'profileInternalId': PropertySchema(
      id: 2,
      name: r'profileInternalId',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 3,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'unitCode': PropertySchema(
      id: 4,
      name: r'unitCode',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: 5,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _measurementProfileItemEntityEstimateSize,
  serialize: _measurementProfileItemEntitySerialize,
  deserialize: _measurementProfileItemEntityDeserialize,
  deserializeProp: _measurementProfileItemEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'profileInternalId': IndexSchema(
      id: -6652948800697819859,
      name: r'profileInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'profileInternalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'shopId': IndexSchema(
      id: 4502922094527709227,
      name: r'shopId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'shopId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'measurementTypeInternalId': IndexSchema(
      id: 878854656436063858,
      name: r'measurementTypeInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'measurementTypeInternalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _measurementProfileItemEntityGetId,
  getLinks: _measurementProfileItemEntityGetLinks,
  attach: _measurementProfileItemEntityAttach,
  version: '3.1.0+1',
);

int _measurementProfileItemEntityEstimateSize(
  MeasurementProfileItemEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.measurementTypeInternalId.length * 3;
  bytesCount += 3 + object.profileInternalId.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _measurementProfileItemEntitySerialize(
  MeasurementProfileItemEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.deletedAt);
  writer.writeString(offsets[1], object.measurementTypeInternalId);
  writer.writeString(offsets[2], object.profileInternalId);
  writer.writeString(offsets[3], object.shopId);
  writer.writeLong(offsets[4], object.unitCode);
  writer.writeString(offsets[5], object.value);
}

MeasurementProfileItemEntity _measurementProfileItemEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MeasurementProfileItemEntity();
  object.deletedAt = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.measurementTypeInternalId = reader.readString(offsets[1]);
  object.profileInternalId = reader.readString(offsets[2]);
  object.shopId = reader.readString(offsets[3]);
  object.unitCode = reader.readLong(offsets[4]);
  object.value = reader.readString(offsets[5]);
  return object;
}

P _measurementProfileItemEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _measurementProfileItemEntityGetId(MeasurementProfileItemEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _measurementProfileItemEntityGetLinks(
    MeasurementProfileItemEntity object) {
  return [];
}

void _measurementProfileItemEntityAttach(
    IsarCollection<dynamic> col, Id id, MeasurementProfileItemEntity object) {
  object.id = id;
}

extension MeasurementProfileItemEntityQueryWhereSort on QueryBuilder<
    MeasurementProfileItemEntity, MeasurementProfileItemEntity, QWhere> {
  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MeasurementProfileItemEntityQueryWhere on QueryBuilder<
    MeasurementProfileItemEntity, MeasurementProfileItemEntity, QWhereClause> {
  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> profileInternalIdEqualTo(String profileInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'profileInternalId',
        value: [profileInternalId],
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> profileInternalIdNotEqualTo(String profileInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileInternalId',
              lower: [],
              upper: [profileInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileInternalId',
              lower: [profileInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileInternalId',
              lower: [profileInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileInternalId',
              lower: [],
              upper: [profileInternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterWhereClause> shopIdNotEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [],
              upper: [shopId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [shopId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [shopId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'shopId',
              lower: [],
              upper: [shopId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterWhereClause>
      measurementTypeInternalIdEqualTo(String measurementTypeInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'measurementTypeInternalId',
        value: [measurementTypeInternalId],
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterWhereClause>
      measurementTypeInternalIdNotEqualTo(String measurementTypeInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'measurementTypeInternalId',
              lower: [],
              upper: [measurementTypeInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'measurementTypeInternalId',
              lower: [measurementTypeInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'measurementTypeInternalId',
              lower: [measurementTypeInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'measurementTypeInternalId',
              lower: [],
              upper: [measurementTypeInternalId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MeasurementProfileItemEntityQueryFilter on QueryBuilder<
    MeasurementProfileItemEntity,
    MeasurementProfileItemEntity,
    QFilterCondition> {
  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measurementTypeInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'measurementTypeInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'measurementTypeInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'measurementTypeInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'measurementTypeInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'measurementTypeInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterFilterCondition>
      measurementTypeInternalIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'measurementTypeInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterFilterCondition>
      measurementTypeInternalIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'measurementTypeInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measurementTypeInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'measurementTypeInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> profileInternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> profileInternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profileInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> profileInternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profileInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> profileInternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profileInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> profileInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profileInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> profileInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profileInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterFilterCondition>
      profileInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profileInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterFilterCondition>
      profileInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profileInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> profileInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> profileInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profileInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> shopIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> shopIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> shopIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> shopIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shopId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> shopIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> shopIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterFilterCondition>
      shopIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterFilterCondition>
      shopIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> unitCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitCode',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> unitCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unitCode',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> unitCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unitCode',
        value: value,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> unitCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unitCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> valueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> valueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> valueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterFilterCondition> valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension MeasurementProfileItemEntityQueryObject on QueryBuilder<
    MeasurementProfileItemEntity,
    MeasurementProfileItemEntity,
    QFilterCondition> {}

extension MeasurementProfileItemEntityQueryLinks on QueryBuilder<
    MeasurementProfileItemEntity,
    MeasurementProfileItemEntity,
    QFilterCondition> {}

extension MeasurementProfileItemEntityQuerySortBy on QueryBuilder<
    MeasurementProfileItemEntity, MeasurementProfileItemEntity, QSortBy> {
  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByMeasurementTypeInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementTypeInternalId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByMeasurementTypeInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementTypeInternalId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByProfileInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileInternalId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByProfileInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileInternalId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByUnitCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension MeasurementProfileItemEntityQuerySortThenBy on QueryBuilder<
    MeasurementProfileItemEntity, MeasurementProfileItemEntity, QSortThenBy> {
  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByMeasurementTypeInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementTypeInternalId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByMeasurementTypeInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementTypeInternalId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByProfileInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileInternalId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByProfileInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileInternalId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByUnitCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.desc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension MeasurementProfileItemEntityQueryWhereDistinct on QueryBuilder<
    MeasurementProfileItemEntity, MeasurementProfileItemEntity, QDistinct> {
  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
          QDistinct>
      distinctByMeasurementTypeInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'measurementTypeInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QDistinct> distinctByProfileInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QDistinct> distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QDistinct> distinctByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitCode');
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, MeasurementProfileItemEntity,
      QDistinct> distinctByValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension MeasurementProfileItemEntityQueryProperty on QueryBuilder<
    MeasurementProfileItemEntity,
    MeasurementProfileItemEntity,
    QQueryProperty> {
  QueryBuilder<MeasurementProfileItemEntity, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, String, QQueryOperations>
      measurementTypeInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measurementTypeInternalId');
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, String, QQueryOperations>
      profileInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileInternalId');
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, int, QQueryOperations>
      unitCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitCode');
    });
  }

  QueryBuilder<MeasurementProfileItemEntity, String, QQueryOperations>
      valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
