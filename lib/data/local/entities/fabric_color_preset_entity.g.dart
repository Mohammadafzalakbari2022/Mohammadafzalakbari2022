// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fabric_color_preset_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFabricColorPresetEntityCollection on Isar {
  IsarCollection<FabricColorPresetEntity> get fabricColorPresetEntitys =>
      this.collection();
}

const FabricColorPresetEntitySchema = CollectionSchema(
  name: r'FabricColorPresetEntity',
  id: 1807175500663015666,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 1,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'internalId': PropertySchema(
      id: 2,
      name: r'internalId',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 3,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 5,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'sortOrder': PropertySchema(
      id: 6,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _fabricColorPresetEntityEstimateSize,
  serialize: _fabricColorPresetEntitySerialize,
  deserialize: _fabricColorPresetEntityDeserialize,
  deserializeProp: _fabricColorPresetEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'internalId': IndexSchema(
      id: -9205954563115848852,
      name: r'internalId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'internalId',
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
    r'sortOrder': IndexSchema(
      id: -1119549396205841918,
      name: r'sortOrder',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sortOrder',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isActive': IndexSchema(
      id: 8092228061260947457,
      name: r'isActive',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isActive',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _fabricColorPresetEntityGetId,
  getLinks: _fabricColorPresetEntityGetLinks,
  attach: _fabricColorPresetEntityAttach,
  version: '3.1.0+1',
);

int _fabricColorPresetEntityEstimateSize(
  FabricColorPresetEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  return bytesCount;
}

void _fabricColorPresetEntitySerialize(
  FabricColorPresetEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.deletedAt);
  writer.writeString(offsets[2], object.internalId);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeString(offsets[4], object.name);
  writer.writeString(offsets[5], object.shopId);
  writer.writeLong(offsets[6], object.sortOrder);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

FabricColorPresetEntity _fabricColorPresetEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FabricColorPresetEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.internalId = reader.readString(offsets[2]);
  object.isActive = reader.readBool(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.shopId = reader.readString(offsets[5]);
  object.sortOrder = reader.readLong(offsets[6]);
  object.updatedAt = reader.readDateTime(offsets[7]);
  return object;
}

P _fabricColorPresetEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _fabricColorPresetEntityGetId(FabricColorPresetEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _fabricColorPresetEntityGetLinks(
    FabricColorPresetEntity object) {
  return [];
}

void _fabricColorPresetEntityAttach(
    IsarCollection<dynamic> col, Id id, FabricColorPresetEntity object) {
  object.id = id;
}

extension FabricColorPresetEntityByIndex
    on IsarCollection<FabricColorPresetEntity> {
  Future<FabricColorPresetEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  FabricColorPresetEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<FabricColorPresetEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<FabricColorPresetEntity?> getAllByInternalIdSync(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'internalId', values);
  }

  Future<int> deleteAllByInternalId(List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'internalId', values);
  }

  int deleteAllByInternalIdSync(List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'internalId', values);
  }

  Future<Id> putByInternalId(FabricColorPresetEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(FabricColorPresetEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(List<FabricColorPresetEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<FabricColorPresetEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension FabricColorPresetEntityQueryWhereSort
    on QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QWhere> {
  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterWhere>
      anySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sortOrder'),
      );
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterWhere>
      anyIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isActive'),
      );
    });
  }
}

extension FabricColorPresetEntityQueryWhere on QueryBuilder<
    FabricColorPresetEntity, FabricColorPresetEntity, QWhereClause> {
  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> internalIdNotEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'internalId',
              lower: [],
              upper: [internalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'internalId',
              lower: [internalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'internalId',
              lower: [internalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'internalId',
              lower: [],
              upper: [internalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> sortOrderEqualTo(int sortOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sortOrder',
        value: [sortOrder],
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> sortOrderNotEqualTo(int sortOrder) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sortOrder',
              lower: [],
              upper: [sortOrder],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sortOrder',
              lower: [sortOrder],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sortOrder',
              lower: [sortOrder],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sortOrder',
              lower: [],
              upper: [sortOrder],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> sortOrderGreaterThan(
    int sortOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sortOrder',
        lower: [sortOrder],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> sortOrderLessThan(
    int sortOrder, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sortOrder',
        lower: [],
        upper: [sortOrder],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> sortOrderBetween(
    int lowerSortOrder,
    int upperSortOrder, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sortOrder',
        lower: [lowerSortOrder],
        includeLower: includeLower,
        upper: [upperSortOrder],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> isActiveEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isActive',
        value: [isActive],
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterWhereClause> isActiveNotEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [],
              upper: [isActive],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [isActive],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [isActive],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [],
              upper: [isActive],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FabricColorPresetEntityQueryFilter on QueryBuilder<
    FabricColorPresetEntity, FabricColorPresetEntity, QFilterCondition> {
  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> internalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> internalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> internalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> internalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'internalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> internalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> internalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
          QAfterFilterCondition>
      internalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
          QAfterFilterCondition>
      internalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'internalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
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

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> sortOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> sortOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> sortOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> sortOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sortOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FabricColorPresetEntityQueryObject on QueryBuilder<
    FabricColorPresetEntity, FabricColorPresetEntity, QFilterCondition> {}

extension FabricColorPresetEntityQueryLinks on QueryBuilder<
    FabricColorPresetEntity, FabricColorPresetEntity, QFilterCondition> {}

extension FabricColorPresetEntityQuerySortBy
    on QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QSortBy> {
  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FabricColorPresetEntityQuerySortThenBy on QueryBuilder<
    FabricColorPresetEntity, FabricColorPresetEntity, QSortThenBy> {
  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FabricColorPresetEntityQueryWhereDistinct on QueryBuilder<
    FabricColorPresetEntity, FabricColorPresetEntity, QDistinct> {
  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QDistinct>
      distinctByInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QDistinct>
      distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QDistinct>
      distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<FabricColorPresetEntity, FabricColorPresetEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FabricColorPresetEntityQueryProperty on QueryBuilder<
    FabricColorPresetEntity, FabricColorPresetEntity, QQueryProperty> {
  QueryBuilder<FabricColorPresetEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FabricColorPresetEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FabricColorPresetEntity, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<FabricColorPresetEntity, String, QQueryOperations>
      internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<FabricColorPresetEntity, bool, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<FabricColorPresetEntity, String, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FabricColorPresetEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<FabricColorPresetEntity, int, QQueryOperations>
      sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<FabricColorPresetEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
