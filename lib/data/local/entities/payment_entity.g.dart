// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPaymentEntityCollection on Isar {
  IsarCollection<PaymentEntity> get paymentEntitys => this.collection();
}

const PaymentEntitySchema = CollectionSchema(
  name: r'PaymentEntity',
  id: -3566663255078343216,
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
    r'isAdjustment': PropertySchema(
      id: 3,
      name: r'isAdjustment',
      type: IsarType.bool,
    ),
    r'method': PropertySchema(
      id: 4,
      name: r'method',
      type: IsarType.string,
    ),
    r'orderInternalId': PropertySchema(
      id: 5,
      name: r'orderInternalId',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 6,
      name: r'shopId',
      type: IsarType.string,
    )
  },
  estimateSize: _paymentEntityEstimateSize,
  serialize: _paymentEntitySerialize,
  deserialize: _paymentEntityDeserialize,
  deserializeProp: _paymentEntityDeserializeProp,
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
    r'orderInternalId': IndexSchema(
      id: -7258485722081298256,
      name: r'orderInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderInternalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'amountMinor': IndexSchema(
      id: -700810384903240540,
      name: r'amountMinor',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'amountMinor',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isAdjustment': IndexSchema(
      id: 3144191402132463265,
      name: r'isAdjustment',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isAdjustment',
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
  getId: _paymentEntityGetId,
  getLinks: _paymentEntityGetLinks,
  attach: _paymentEntityAttach,
  version: '3.1.0+1',
);

int _paymentEntityEstimateSize(
  PaymentEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.method.length * 3;
  bytesCount += 3 + object.orderInternalId.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  return bytesCount;
}

void _paymentEntitySerialize(
  PaymentEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.amountMinor);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.internalId);
  writer.writeBool(offsets[3], object.isAdjustment);
  writer.writeString(offsets[4], object.method);
  writer.writeString(offsets[5], object.orderInternalId);
  writer.writeString(offsets[6], object.shopId);
}

PaymentEntity _paymentEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PaymentEntity();
  object.amountMinor = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.internalId = reader.readString(offsets[2]);
  object.isAdjustment = reader.readBool(offsets[3]);
  object.method = reader.readString(offsets[4]);
  object.orderInternalId = reader.readString(offsets[5]);
  object.shopId = reader.readString(offsets[6]);
  return object;
}

P _paymentEntityDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _paymentEntityGetId(PaymentEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _paymentEntityGetLinks(PaymentEntity object) {
  return [];
}

void _paymentEntityAttach(
    IsarCollection<dynamic> col, Id id, PaymentEntity object) {
  object.id = id;
}

extension PaymentEntityByIndex on IsarCollection<PaymentEntity> {
  Future<PaymentEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  PaymentEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<PaymentEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<PaymentEntity?> getAllByInternalIdSync(List<String> internalIdValues) {
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

  Future<Id> putByInternalId(PaymentEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(PaymentEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(List<PaymentEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<PaymentEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension PaymentEntityQueryWhereSort
    on QueryBuilder<PaymentEntity, PaymentEntity, QWhere> {
  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhere> anyAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'amountMinor'),
      );
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhere> anyIsAdjustment() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isAdjustment'),
      );
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension PaymentEntityQueryWhere
    on QueryBuilder<PaymentEntity, PaymentEntity, QWhereClause> {
  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      internalIdNotEqualTo(String internalId) {
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause> shopIdEqualTo(
      String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      shopIdNotEqualTo(String shopId) {
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      orderInternalIdEqualTo(String orderInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderInternalId',
        value: [orderInternalId],
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      orderInternalIdNotEqualTo(String orderInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderInternalId',
              lower: [],
              upper: [orderInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderInternalId',
              lower: [orderInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderInternalId',
              lower: [orderInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderInternalId',
              lower: [],
              upper: [orderInternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      amountMinorEqualTo(int amountMinor) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'amountMinor',
        value: [amountMinor],
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      amountMinorNotEqualTo(int amountMinor) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'amountMinor',
              lower: [],
              upper: [amountMinor],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'amountMinor',
              lower: [amountMinor],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'amountMinor',
              lower: [amountMinor],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'amountMinor',
              lower: [],
              upper: [amountMinor],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      amountMinorGreaterThan(
    int amountMinor, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'amountMinor',
        lower: [amountMinor],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      amountMinorLessThan(
    int amountMinor, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'amountMinor',
        lower: [],
        upper: [amountMinor],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      amountMinorBetween(
    int lowerAmountMinor,
    int upperAmountMinor, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'amountMinor',
        lower: [lowerAmountMinor],
        includeLower: includeLower,
        upper: [upperAmountMinor],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      isAdjustmentEqualTo(bool isAdjustment) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isAdjustment',
        value: [isAdjustment],
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      isAdjustmentNotEqualTo(bool isAdjustment) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAdjustment',
              lower: [],
              upper: [isAdjustment],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAdjustment',
              lower: [isAdjustment],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAdjustment',
              lower: [isAdjustment],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isAdjustment',
              lower: [],
              upper: [isAdjustment],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      createdAtGreaterThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      createdAtLessThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterWhereClause>
      createdAtBetween(
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

extension PaymentEntityQueryFilter
    on QueryBuilder<PaymentEntity, PaymentEntity, QFilterCondition> {
  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      amountMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      amountMinorGreaterThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      amountMinorLessThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      amountMinorBetween(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdEqualTo(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdGreaterThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdLessThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdBetween(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdStartsWith(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdEndsWith(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'internalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      isAdjustmentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAdjustment',
        value: value,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'method',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'method',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'method',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      methodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'method',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orderInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orderInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orderInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orderInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      orderInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdEqualTo(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdGreaterThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdLessThan(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdBetween(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdStartsWith(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdEndsWith(
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

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterFilterCondition>
      shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }
}

extension PaymentEntityQueryObject
    on QueryBuilder<PaymentEntity, PaymentEntity, QFilterCondition> {}

extension PaymentEntityQueryLinks
    on QueryBuilder<PaymentEntity, PaymentEntity, QFilterCondition> {}

extension PaymentEntityQuerySortBy
    on QueryBuilder<PaymentEntity, PaymentEntity, QSortBy> {
  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> sortByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      sortByAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      sortByIsAdjustment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdjustment', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      sortByIsAdjustmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdjustment', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> sortByMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> sortByMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      sortByOrderInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      sortByOrderInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }
}

extension PaymentEntityQuerySortThenBy
    on QueryBuilder<PaymentEntity, PaymentEntity, QSortThenBy> {
  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      thenByAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountMinor', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      thenByIsAdjustment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdjustment', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      thenByIsAdjustmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdjustment', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenByMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenByMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      thenByOrderInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy>
      thenByOrderInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.desc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }
}

extension PaymentEntityQueryWhereDistinct
    on QueryBuilder<PaymentEntity, PaymentEntity, QDistinct> {
  QueryBuilder<PaymentEntity, PaymentEntity, QDistinct>
      distinctByAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountMinor');
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QDistinct> distinctByInternalId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QDistinct>
      distinctByIsAdjustment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAdjustment');
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QDistinct> distinctByMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'method', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QDistinct>
      distinctByOrderInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PaymentEntity, PaymentEntity, QDistinct> distinctByShopId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }
}

extension PaymentEntityQueryProperty
    on QueryBuilder<PaymentEntity, PaymentEntity, QQueryProperty> {
  QueryBuilder<PaymentEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PaymentEntity, int, QQueryOperations> amountMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountMinor');
    });
  }

  QueryBuilder<PaymentEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PaymentEntity, String, QQueryOperations> internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<PaymentEntity, bool, QQueryOperations> isAdjustmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAdjustment');
    });
  }

  QueryBuilder<PaymentEntity, String, QQueryOperations> methodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'method');
    });
  }

  QueryBuilder<PaymentEntity, String, QQueryOperations>
      orderInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderInternalId');
    });
  }

  QueryBuilder<PaymentEntity, String, QQueryOperations> shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }
}
