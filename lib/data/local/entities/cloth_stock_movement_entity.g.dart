// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth_stock_movement_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClothStockMovementEntityCollection on Isar {
  IsarCollection<ClothStockMovementEntity> get clothStockMovementEntitys =>
      this.collection();
}

const ClothStockMovementEntitySchema = CollectionSchema(
  name: r'ClothStockMovementEntity',
  id: 6396095098433679613,
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
    r'movementTypeIndex': PropertySchema(
      id: 2,
      name: r'movementTypeIndex',
      type: IsarType.long,
    ),
    r'note': PropertySchema(
      id: 3,
      name: r'note',
      type: IsarType.string,
    ),
    r'orderItemInternalId': PropertySchema(
      id: 4,
      name: r'orderItemInternalId',
      type: IsarType.string,
    ),
    r'purchaseLineInternalId': PropertySchema(
      id: 5,
      name: r'purchaseLineInternalId',
      type: IsarType.string,
    ),
    r'qtyMilliDelta': PropertySchema(
      id: 6,
      name: r'qtyMilliDelta',
      type: IsarType.long,
    ),
    r'shopId': PropertySchema(
      id: 7,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'skuInternalId': PropertySchema(
      id: 8,
      name: r'skuInternalId',
      type: IsarType.string,
    )
  },
  estimateSize: _clothStockMovementEntityEstimateSize,
  serialize: _clothStockMovementEntitySerialize,
  deserialize: _clothStockMovementEntityDeserialize,
  deserializeProp: _clothStockMovementEntityDeserializeProp,
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
    r'movementTypeIndex': IndexSchema(
      id: 6331196381757538756,
      name: r'movementTypeIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'movementTypeIndex',
          type: IndexType.value,
          caseSensitive: false,
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
  getId: _clothStockMovementEntityGetId,
  getLinks: _clothStockMovementEntityGetLinks,
  attach: _clothStockMovementEntityAttach,
  version: '3.1.0+1',
);

int _clothStockMovementEntityEstimateSize(
  ClothStockMovementEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.note.length * 3;
  {
    final value = object.orderItemInternalId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.purchaseLineInternalId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.shopId.length * 3;
  bytesCount += 3 + object.skuInternalId.length * 3;
  return bytesCount;
}

void _clothStockMovementEntitySerialize(
  ClothStockMovementEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.internalId);
  writer.writeLong(offsets[2], object.movementTypeIndex);
  writer.writeString(offsets[3], object.note);
  writer.writeString(offsets[4], object.orderItemInternalId);
  writer.writeString(offsets[5], object.purchaseLineInternalId);
  writer.writeLong(offsets[6], object.qtyMilliDelta);
  writer.writeString(offsets[7], object.shopId);
  writer.writeString(offsets[8], object.skuInternalId);
}

ClothStockMovementEntity _clothStockMovementEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClothStockMovementEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.internalId = reader.readString(offsets[1]);
  object.movementTypeIndex = reader.readLong(offsets[2]);
  object.note = reader.readString(offsets[3]);
  object.orderItemInternalId = reader.readStringOrNull(offsets[4]);
  object.purchaseLineInternalId = reader.readStringOrNull(offsets[5]);
  object.qtyMilliDelta = reader.readLong(offsets[6]);
  object.shopId = reader.readString(offsets[7]);
  object.skuInternalId = reader.readString(offsets[8]);
  return object;
}

P _clothStockMovementEntityDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _clothStockMovementEntityGetId(ClothStockMovementEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _clothStockMovementEntityGetLinks(
    ClothStockMovementEntity object) {
  return [];
}

void _clothStockMovementEntityAttach(
    IsarCollection<dynamic> col, Id id, ClothStockMovementEntity object) {
  object.id = id;
}

extension ClothStockMovementEntityByIndex
    on IsarCollection<ClothStockMovementEntity> {
  Future<ClothStockMovementEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  ClothStockMovementEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<ClothStockMovementEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<ClothStockMovementEntity?> getAllByInternalIdSync(
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

  Future<Id> putByInternalId(ClothStockMovementEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(ClothStockMovementEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(List<ClothStockMovementEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<ClothStockMovementEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension ClothStockMovementEntityQueryWhereSort on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QWhere> {
  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterWhere>
      anyMovementTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'movementTypeIndex'),
      );
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension ClothStockMovementEntityQueryWhere on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QWhereClause> {
  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> skuInternalIdEqualTo(String skuInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'skuInternalId',
        value: [skuInternalId],
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> movementTypeIndexEqualTo(int movementTypeIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'movementTypeIndex',
        value: [movementTypeIndex],
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> movementTypeIndexNotEqualTo(int movementTypeIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'movementTypeIndex',
              lower: [],
              upper: [movementTypeIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'movementTypeIndex',
              lower: [movementTypeIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'movementTypeIndex',
              lower: [movementTypeIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'movementTypeIndex',
              lower: [],
              upper: [movementTypeIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> movementTypeIndexGreaterThan(
    int movementTypeIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'movementTypeIndex',
        lower: [movementTypeIndex],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> movementTypeIndexLessThan(
    int movementTypeIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'movementTypeIndex',
        lower: [],
        upper: [movementTypeIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> movementTypeIndexBetween(
    int lowerMovementTypeIndex,
    int upperMovementTypeIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'movementTypeIndex',
        lower: [lowerMovementTypeIndex],
        includeLower: includeLower,
        upper: [upperMovementTypeIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterWhereClause> createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

extension ClothStockMovementEntityQueryFilter on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QFilterCondition> {
  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> movementTypeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movementTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> movementTypeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movementTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> movementTypeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movementTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> movementTypeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movementTypeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> noteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> noteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> noteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> noteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
          QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
          QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orderItemInternalId',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orderItemInternalId',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderItemInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orderItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orderItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
          QAfterFilterCondition>
      orderItemInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orderItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
          QAfterFilterCondition>
      orderItemInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orderItemInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderItemInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> orderItemInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderItemInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'purchaseLineInternalId',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'purchaseLineInternalId',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseLineInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseLineInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseLineInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseLineInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purchaseLineInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purchaseLineInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
          QAfterFilterCondition>
      purchaseLineInternalIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purchaseLineInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
          QAfterFilterCondition>
      purchaseLineInternalIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purchaseLineInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseLineInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> purchaseLineInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaseLineInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> qtyMilliDeltaEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qtyMilliDelta',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> qtyMilliDeltaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qtyMilliDelta',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> qtyMilliDeltaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qtyMilliDelta',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> qtyMilliDeltaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qtyMilliDelta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
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

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> skuInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skuInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity,
      QAfterFilterCondition> skuInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'skuInternalId',
        value: '',
      ));
    });
  }
}

extension ClothStockMovementEntityQueryObject on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QFilterCondition> {}

extension ClothStockMovementEntityQueryLinks on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QFilterCondition> {}

extension ClothStockMovementEntityQuerySortBy on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QSortBy> {
  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByMovementTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementTypeIndex', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByMovementTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementTypeIndex', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByOrderItemInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByOrderItemInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByPurchaseLineInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseLineInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByPurchaseLineInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseLineInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByQtyMilliDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyMilliDelta', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByQtyMilliDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyMilliDelta', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortBySkuInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      sortBySkuInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuInternalId', Sort.desc);
    });
  }
}

extension ClothStockMovementEntityQuerySortThenBy on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QSortThenBy> {
  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByMovementTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementTypeIndex', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByMovementTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movementTypeIndex', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByOrderItemInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByOrderItemInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByPurchaseLineInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseLineInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByPurchaseLineInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseLineInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByQtyMilliDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyMilliDelta', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByQtyMilliDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyMilliDelta', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenBySkuInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QAfterSortBy>
      thenBySkuInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skuInternalId', Sort.desc);
    });
  }
}

extension ClothStockMovementEntityQueryWhereDistinct on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QDistinct> {
  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctByInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctByMovementTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movementTypeIndex');
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctByOrderItemInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderItemInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctByPurchaseLineInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseLineInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctByQtyMilliDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qtyMilliDelta');
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothStockMovementEntity, ClothStockMovementEntity, QDistinct>
      distinctBySkuInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skuInternalId',
          caseSensitive: caseSensitive);
    });
  }
}

extension ClothStockMovementEntityQueryProperty on QueryBuilder<
    ClothStockMovementEntity, ClothStockMovementEntity, QQueryProperty> {
  QueryBuilder<ClothStockMovementEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ClothStockMovementEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ClothStockMovementEntity, String, QQueryOperations>
      internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<ClothStockMovementEntity, int, QQueryOperations>
      movementTypeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movementTypeIndex');
    });
  }

  QueryBuilder<ClothStockMovementEntity, String, QQueryOperations>
      noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<ClothStockMovementEntity, String?, QQueryOperations>
      orderItemInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderItemInternalId');
    });
  }

  QueryBuilder<ClothStockMovementEntity, String?, QQueryOperations>
      purchaseLineInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseLineInternalId');
    });
  }

  QueryBuilder<ClothStockMovementEntity, int, QQueryOperations>
      qtyMilliDeltaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qtyMilliDelta');
    });
  }

  QueryBuilder<ClothStockMovementEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<ClothStockMovementEntity, String, QQueryOperations>
      skuInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skuInternalId');
    });
  }
}
