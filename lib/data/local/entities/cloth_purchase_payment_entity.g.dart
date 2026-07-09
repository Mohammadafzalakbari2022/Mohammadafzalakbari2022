// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth_purchase_payment_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClothPurchasePaymentEntityCollection on Isar {
  IsarCollection<ClothPurchasePaymentEntity> get clothPurchasePaymentEntitys =>
      this.collection();
}

const ClothPurchasePaymentEntitySchema = CollectionSchema(
  name: r'ClothPurchasePaymentEntity',
  id: 3931951157522211742,
  properties: {
    r'amountMinor': PropertySchema(
      id: 0,
      name: r'amountMinor',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'internalId': PropertySchema(
      id: 2,
      name: r'internalId',
      type: IsarType.string,
    ),
    r'note': PropertySchema(
      id: 3,
      name: r'note',
      type: IsarType.string,
    ),
    r'paidAt': PropertySchema(
      id: 4,
      name: r'paidAt',
      type: IsarType.dateTime,
    ),
    r'purchaseInternalId': PropertySchema(
      id: 5,
      name: r'purchaseInternalId',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 6,
      name: r'shopId',
      type: IsarType.string,
    )
  },
  estimateSize: _clothPurchasePaymentEntityEstimateSize,
  serialize: _clothPurchasePaymentEntitySerialize,
  deserialize: _clothPurchasePaymentEntityDeserialize,
  deserializeProp: _clothPurchasePaymentEntityDeserializeProp,
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
    r'paidAt': IndexSchema(
      id: -701685063105958775,
      name: r'paidAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'paidAt',
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
  getId: _clothPurchasePaymentEntityGetId,
  getLinks: _clothPurchasePaymentEntityGetLinks,
  attach: _clothPurchasePaymentEntityAttach,
  version: '3.1.0+1',
);

int _clothPurchasePaymentEntityEstimateSize(
  ClothPurchasePaymentEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.note.length * 3;
  bytesCount += 3 + object.purchaseInternalId.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  return bytesCount;
}

void _clothPurchasePaymentEntitySerialize(
  ClothPurchasePaymentEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amountMinor);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.internalId);
  writer.writeString(offsets[3], object.note);
  writer.writeDateTime(offsets[4], object.paidAt);
  writer.writeString(offsets[5], object.purchaseInternalId);
  writer.writeString(offsets[6], object.shopId);
}

ClothPurchasePaymentEntity _clothPurchasePaymentEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClothPurchasePaymentEntity();
  object.amountMinor = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.internalId = reader.readString(offsets[2]);
  object.note = reader.readString(offsets[3]);
  object.paidAt = reader.readDateTime(offsets[4]);
  object.purchaseInternalId = reader.readString(offsets[5]);
  object.shopId = reader.readString(offsets[6]);
  return object;
}

P _clothPurchasePaymentEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _clothPurchasePaymentEntityGetId(ClothPurchasePaymentEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _clothPurchasePaymentEntityGetLinks(
    ClothPurchasePaymentEntity object) {
  return [];
}

void _clothPurchasePaymentEntityAttach(
    IsarCollection<dynamic> col, Id id, ClothPurchasePaymentEntity object) {
  object.id = id;
}

extension ClothPurchasePaymentEntityByIndex
    on IsarCollection<ClothPurchasePaymentEntity> {
  Future<ClothPurchasePaymentEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  ClothPurchasePaymentEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<ClothPurchasePaymentEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<ClothPurchasePaymentEntity?> getAllByInternalIdSync(
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

  Future<Id> putByInternalId(ClothPurchasePaymentEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(ClothPurchasePaymentEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(
      List<ClothPurchasePaymentEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<ClothPurchasePaymentEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension ClothPurchasePaymentEntityQueryWhereSort on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QWhere> {
  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhere> anyPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'paidAt'),
      );
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension ClothPurchasePaymentEntityQueryWhere on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QWhereClause> {
  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> purchaseInternalIdEqualTo(String purchaseInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'purchaseInternalId',
        value: [purchaseInternalId],
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> paidAtEqualTo(DateTime paidAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'paidAt',
        value: [paidAt],
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> paidAtNotEqualTo(DateTime paidAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paidAt',
              lower: [],
              upper: [paidAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paidAt',
              lower: [paidAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paidAt',
              lower: [paidAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'paidAt',
              lower: [],
              upper: [paidAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> paidAtGreaterThan(
    DateTime paidAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'paidAt',
        lower: [paidAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> paidAtLessThan(
    DateTime paidAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'paidAt',
        lower: [],
        upper: [paidAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> paidAtBetween(
    DateTime lowerPaidAt,
    DateTime upperPaidAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'paidAt',
        lower: [lowerPaidAt],
        includeLower: includeLower,
        upper: [upperPaidAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterWhereClause> createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

extension ClothPurchasePaymentEntityQueryFilter on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QFilterCondition> {
  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> amountMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> amountMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> amountMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> amountMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> paidAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> paidAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> paidAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paidAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> paidAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paidAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> purchaseInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> purchaseInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaseInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
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

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }
}

extension ClothPurchasePaymentEntityQueryObject on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QFilterCondition> {}

extension ClothPurchasePaymentEntityQueryLinks on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QFilterCondition> {}

extension ClothPurchasePaymentEntityQuerySortBy on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QSortBy> {
  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByPaidAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByPurchaseInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByPurchaseInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }
}

extension ClothPurchasePaymentEntityQuerySortThenBy on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QSortThenBy> {
  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByPaidAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAt', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByPurchaseInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseInternalId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByPurchaseInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseInternalId', Sort.desc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }
}

extension ClothPurchasePaymentEntityQueryWhereDistinct on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QDistinct> {
  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QDistinct> distinctByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountMinor');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QDistinct> distinctByInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QDistinct> distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QDistinct> distinctByPaidAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paidAt');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QDistinct> distinctByPurchaseInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, ClothPurchasePaymentEntity,
      QDistinct> distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }
}

extension ClothPurchasePaymentEntityQueryProperty on QueryBuilder<
    ClothPurchasePaymentEntity, ClothPurchasePaymentEntity, QQueryProperty> {
  QueryBuilder<ClothPurchasePaymentEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, int, QQueryOperations>
      amountMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountMinor');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, String, QQueryOperations>
      internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, String, QQueryOperations>
      noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, DateTime, QQueryOperations>
      paidAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paidAt');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, String, QQueryOperations>
      purchaseInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseInternalId');
    });
  }

  QueryBuilder<ClothPurchasePaymentEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }
}
