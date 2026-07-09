// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth_purchase_line_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClothPurchaseLineEntityCollection on Isar {
  IsarCollection<ClothPurchaseLineEntity> get clothPurchaseLineEntitys =>
      this.collection();
}

const ClothPurchaseLineEntitySchema = CollectionSchema(
  name: r'ClothPurchaseLineEntity',
  id: 8384445079690607161,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'internalId': PropertySchema(
      id: 1,
      name: r'internalId',
      type: IsarType.string,
    ),
    r'lineTotalMinor': PropertySchema(
      id: 2,
      name: r'lineTotalMinor',
      type: IsarType.long,
    ),
    r'purchaseInternalId': PropertySchema(
      id: 3,
      name: r'purchaseInternalId',
      type: IsarType.string,
    ),
    r'qtyMilli': PropertySchema(
      id: 4,
      name: r'qtyMilli',
      type: IsarType.long,
    ),
    r'shopId': PropertySchema(
      id: 5,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'skuInternalId': PropertySchema(
      id: 6,
      name: r'skuInternalId',
      type: IsarType.string,
    ),
    r'unitCostAmountMinor': PropertySchema(
      id: 7,
      name: r'unitCostAmountMinor',
      type: IsarType.long,
    )
  },
  estimateSize: _clothPurchaseLineEntityEstimateSize,
  serialize: _clothPurchaseLineEntitySerialize,
  deserialize: _clothPurchaseLineEntityDeserialize,
  deserializeProp: _clothPurchaseLineEntityDeserializeProp,
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
    r'purchaseInternalId': IndexSchema(
      id: 4531532967385760809,
      name: r'purchaseInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'purchaseInternalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'skuInternalId': IndexSchema(
      id: 6780235958074410995,
      name: r'skuInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'skuInternalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _clothPurchaseLineEntityGetId,
  getLinks: _clothPurchaseLineEntityGetLinks,
  attach: _clothPurchaseLineEntityAttach,
  version: '3.1.0+1',
);

int _clothPurchaseLineEntityEstimateSize(
  ClothPurchaseLineEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.purchaseInternalId.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  bytesCount += 3 + object.skuInternalId.length * 3;
  return bytesCount;
}

void _clothPurchaseLineEntitySerialize(
  ClothPurchaseLineEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.internalId);
  writer.writeLong(offsets[2], object.lineTotalMinor);
  writer.writeString(offsets[3], object.purchaseInternalId);
  writer.writeLong(offsets[4], object.qtyMilli);
  writer.writeString(offsets[5], object.shopId);
  writer.writeString(offsets[6], object.skuInternalId);
  writer.writeLong(offsets[7], object.unitCostAmountMinor);
}

ClothPurchaseLineEntity _clothPurchaseLineEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClothPurchaseLineEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.internalId = reader.readString(offsets[1]);
  object.lineTotalMinor = reader.readLong(offsets[2]);
  object.purchaseInternalId = reader.readString(offsets[3]);
  object.qtyMilli = reader.readLong(offsets[4]);
  object.shopId = reader.readString(offsets[5]);
  object.skuInternalId = reader.readString(offsets[6]);
  object.unitCostAmountMinor = reader.readLong(offsets[7]);
  return object;
}

P _clothPurchaseLineEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _clothPurchaseLineEntityGetId(ClothPurchaseLineEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _clothPurchaseLineEntityGetLinks(
    ClothPurchaseLineEntity object) {
  return [];
}

void _clothPurchaseLineEntityAttach(
    IsarCollection<dynamic> col, Id id, ClothPurchaseLineEntity object) {
  object.id = id;
}

extension ClothPurchaseLineEntityByIndex
    on IsarCollection<ClothPurchaseLineEntity> {
  Future<ClothPurchaseLineEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  ClothPurchaseLineEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<ClothPurchaseLineEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<ClothPurchaseLineEntity?> getAllByInternalIdSync(
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

  Future<Id> putByInternalId(ClothPurchaseLineEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(ClothPurchaseLineEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(List<ClothPurchaseLineEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<ClothPurchaseLineEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension ClothPurchaseLineEntityQueryWhereSort
    on QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QWhere> {
  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension ClothPurchaseLineEntityQueryWhere on QueryBuilder<
    ClothPurchaseLineEntity, ClothPurchaseLineEntity, QWhereClause> {
  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> purchaseInternalIdEqualTo(String purchaseInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'purchaseInternalId',
        value: [purchaseInternalId],
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
          QAfterWhereClause>
      purchaseInternalIdNotEqualTo(String purchaseInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseInternalId',
              lower: [],
              upper: [purchaseInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseInternalId',
              lower: [purchaseInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseInternalId',
              lower: [purchaseInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseInternalId',
              lower: [],
              upper: [purchaseInternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> skuInternalIdEqualTo(String skuInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'skuInternalId',
        value: [skuInternalId],
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> skuInternalIdNotEqualTo(String skuInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'skuInternalId',
              lower: [],
              upper: [skuInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'skuInternalId',
              lower: [skuInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'skuInternalId',
              lower: [skuInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'skuInternalId',
              lower: [],
              upper: [skuInternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterWhereClause> createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ClothPurchaseLineEntityQueryFilter on QueryBuilder<
    ClothPurchaseLineEntity, ClothPurchaseLineEntity, QFilterCondition> {
  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> lineTotalMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lineTotalMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> lineTotalMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lineTotalMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> lineTotalMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lineTotalMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> lineTotalMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lineTotalMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> purchaseInternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> purchaseInternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> purchaseInternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> purchaseInternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> purchaseInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purchaseInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> purchaseInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purchaseInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
          QAfterFilterCondition>
      purchaseInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purchaseInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
          QAfterFilterCondition>
      purchaseInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purchaseInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> purchaseInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> purchaseInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaseInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> qtyMilliEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qtyMilli',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> qtyMilliGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qtyMilli',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> qtyMilliLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qtyMilli',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> qtyMilliBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qtyMilli',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
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

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> skuInternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skuInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> skuInternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skuInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> skuInternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skuInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> skuInternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skuInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> skuInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'skuInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> skuInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'skuInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
          QAfterFilterCondition>
      skuInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'skuInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
          QAfterFilterCondition>
      skuInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'skuInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> skuInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skuInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> skuInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'skuInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> unitCostAmountMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitCostAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> unitCostAmountMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unitCostAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> unitCostAmountMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unitCostAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity,
      QAfterFilterCondition> unitCostAmountMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unitCostAmountMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ClothPurchaseLineEntityQueryObject on QueryBuilder<
    ClothPurchaseLineEntity, ClothPurchaseLineEntity, QFilterCondition> {}

extension ClothPurchaseLineEntityQueryLinks on QueryBuilder<
    ClothPurchaseLineEntity, ClothPurchaseLineEntity, QFilterCondition> {}

extension ClothPurchaseLineEntityQuerySortBy
    on QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QSortBy> {
  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByLineTotalMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineTotalMinor', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByLineTotalMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineTotalMinor', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByPurchaseInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByPurchaseInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByQtyMilli() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyMilli', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByQtyMilliDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyMilli', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortBySkuInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortBySkuInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByUnitCostAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCostAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      sortByUnitCostAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCostAmountMinor', Sort.desc);
    });
  }
}

extension ClothPurchaseLineEntityQuerySortThenBy on QueryBuilder<
    ClothPurchaseLineEntity, ClothPurchaseLineEntity, QSortThenBy> {
  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByLineTotalMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineTotalMinor', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByLineTotalMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lineTotalMinor', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByPurchaseInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByPurchaseInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByQtyMilli() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyMilli', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByQtyMilliDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyMilli', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenBySkuInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenBySkuInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByUnitCostAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCostAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QAfterSortBy>
      thenByUnitCostAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCostAmountMinor', Sort.desc);
    });
  }
}

extension ClothPurchaseLineEntityQueryWhereDistinct on QueryBuilder<
    ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct> {
  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct>
      distinctByInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct>
      distinctByLineTotalMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lineTotalMinor');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct>
      distinctByPurchaseInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct>
      distinctByQtyMilli() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qtyMilli');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct>
      distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct>
      distinctBySkuInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skuInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, ClothPurchaseLineEntity, QDistinct>
      distinctByUnitCostAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitCostAmountMinor');
    });
  }
}

extension ClothPurchaseLineEntityQueryProperty on QueryBuilder<
    ClothPurchaseLineEntity, ClothPurchaseLineEntity, QQueryProperty> {
  QueryBuilder<ClothPurchaseLineEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, String, QQueryOperations>
      internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, int, QQueryOperations>
      lineTotalMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lineTotalMinor');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, String, QQueryOperations>
      purchaseInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseInternalId');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, int, QQueryOperations>
      qtyMilliProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qtyMilli');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, String, QQueryOperations>
      skuInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skuInternalId');
    });
  }

  QueryBuilder<ClothPurchaseLineEntity, int, QQueryOperations>
      unitCostAmountMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitCostAmountMinor');
    });
  }
}
