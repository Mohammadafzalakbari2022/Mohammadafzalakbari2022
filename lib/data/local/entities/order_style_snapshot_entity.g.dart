// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_style_snapshot_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderStyleSnapshotEntityCollection on Isar {
  IsarCollection<OrderStyleSnapshotEntity> get orderStyleSnapshotEntitys =>
      this.collection();
}

const OrderStyleSnapshotEntitySchema = CollectionSchema(
  name: r'OrderStyleSnapshotEntity',
  id: 394935813306080032,
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
    r'orderInternalId': PropertySchema(
      id: 2,
      name: r'orderInternalId',
      type: IsarType.string,
    ),
    r'orderItemInternalId': PropertySchema(
      id: 3,
      name: r'orderItemInternalId',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 4,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'styleNameInternalIdSnapshot': PropertySchema(
      id: 5,
      name: r'styleNameInternalIdSnapshot',
      type: IsarType.string,
    ),
    r'styleNameSnapshot': PropertySchema(
      id: 6,
      name: r'styleNameSnapshot',
      type: IsarType.string,
    )
  },
  estimateSize: _orderStyleSnapshotEntityEstimateSize,
  serialize: _orderStyleSnapshotEntitySerialize,
  deserialize: _orderStyleSnapshotEntityDeserialize,
  deserializeProp: _orderStyleSnapshotEntityDeserializeProp,
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
    r'orderItemInternalId': IndexSchema(
      id: -2202692246088717177,
      name: r'orderItemInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderItemInternalId',
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _orderStyleSnapshotEntityGetId,
  getLinks: _orderStyleSnapshotEntityGetLinks,
  attach: _orderStyleSnapshotEntityAttach,
  version: '3.1.0+1',
);

int _orderStyleSnapshotEntityEstimateSize(
  OrderStyleSnapshotEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.orderInternalId.length * 3;
  bytesCount += 3 + object.orderItemInternalId.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  {
    final value = object.styleNameInternalIdSnapshot;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.styleNameSnapshot.length * 3;
  return bytesCount;
}

void _orderStyleSnapshotEntitySerialize(
  OrderStyleSnapshotEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.internalId);
  writer.writeString(offsets[2], object.orderInternalId);
  writer.writeString(offsets[3], object.orderItemInternalId);
  writer.writeString(offsets[4], object.shopId);
  writer.writeString(offsets[5], object.styleNameInternalIdSnapshot);
  writer.writeString(offsets[6], object.styleNameSnapshot);
}

OrderStyleSnapshotEntity _orderStyleSnapshotEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderStyleSnapshotEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.internalId = reader.readString(offsets[1]);
  object.orderInternalId = reader.readString(offsets[2]);
  object.orderItemInternalId = reader.readString(offsets[3]);
  object.shopId = reader.readString(offsets[4]);
  object.styleNameInternalIdSnapshot = reader.readStringOrNull(offsets[5]);
  object.styleNameSnapshot = reader.readString(offsets[6]);
  return object;
}

P _orderStyleSnapshotEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderStyleSnapshotEntityGetId(OrderStyleSnapshotEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderStyleSnapshotEntityGetLinks(
    OrderStyleSnapshotEntity object) {
  return [];
}

void _orderStyleSnapshotEntityAttach(
    IsarCollection<dynamic> col, Id id, OrderStyleSnapshotEntity object) {
  object.id = id;
}

extension OrderStyleSnapshotEntityByIndex
    on IsarCollection<OrderStyleSnapshotEntity> {
  Future<OrderStyleSnapshotEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  OrderStyleSnapshotEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<OrderStyleSnapshotEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<OrderStyleSnapshotEntity?> getAllByInternalIdSync(
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

  Future<Id> putByInternalId(OrderStyleSnapshotEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(OrderStyleSnapshotEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(List<OrderStyleSnapshotEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<OrderStyleSnapshotEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension OrderStyleSnapshotEntityQueryWhereSort on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QWhere> {
  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OrderStyleSnapshotEntityQueryWhere on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QWhereClause> {
  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterWhereClause> internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterWhereClause> orderInternalIdEqualTo(String orderInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderInternalId',
        value: [orderInternalId],
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterWhereClause> orderInternalIdNotEqualTo(String orderInternalId) {
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
          QAfterWhereClause>
      orderItemInternalIdEqualTo(String orderItemInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderItemInternalId',
        value: [orderItemInternalId],
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
          QAfterWhereClause>
      orderItemInternalIdNotEqualTo(String orderItemInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderItemInternalId',
              lower: [],
              upper: [orderItemInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderItemInternalId',
              lower: [orderItemInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderItemInternalId',
              lower: [orderItemInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderItemInternalId',
              lower: [],
              upper: [orderItemInternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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
}

extension OrderStyleSnapshotEntityQueryFilter on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QFilterCondition> {
  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderInternalIdEqualTo(
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderInternalIdGreaterThan(
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderInternalIdLessThan(
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderInternalIdBetween(
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderInternalIdStartsWith(
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderInternalIdEndsWith(
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
          QAfterFilterCondition>
      orderInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orderInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
          QAfterFilterCondition>
      orderInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orderInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderItemInternalIdEqualTo(
    String value, {
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderItemInternalIdGreaterThan(
    String value, {
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderItemInternalIdLessThan(
    String value, {
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderItemInternalIdBetween(
    String lower,
    String upper, {
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderItemInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderItemInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> orderItemInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderItemInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
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

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'styleNameInternalIdSnapshot',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'styleNameInternalIdSnapshot',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNameInternalIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styleNameInternalIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styleNameInternalIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styleNameInternalIdSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'styleNameInternalIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'styleNameInternalIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
          QAfterFilterCondition>
      styleNameInternalIdSnapshotContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleNameInternalIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
          QAfterFilterCondition>
      styleNameInternalIdSnapshotMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleNameInternalIdSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNameInternalIdSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameInternalIdSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleNameInternalIdSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styleNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styleNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styleNameSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'styleNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'styleNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
          QAfterFilterCondition>
      styleNameSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
          QAfterFilterCondition>
      styleNameSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleNameSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity,
      QAfterFilterCondition> styleNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleNameSnapshot',
        value: '',
      ));
    });
  }
}

extension OrderStyleSnapshotEntityQueryObject on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QFilterCondition> {}

extension OrderStyleSnapshotEntityQueryLinks on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QFilterCondition> {}

extension OrderStyleSnapshotEntityQuerySortBy on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QSortBy> {
  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByOrderInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByOrderInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByOrderItemInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByOrderItemInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByStyleNameInternalIdSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalIdSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByStyleNameInternalIdSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalIdSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByStyleNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      sortByStyleNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameSnapshot', Sort.desc);
    });
  }
}

extension OrderStyleSnapshotEntityQuerySortThenBy on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QSortThenBy> {
  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByOrderInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByOrderInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByOrderItemInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByOrderItemInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderItemInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByStyleNameInternalIdSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalIdSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByStyleNameInternalIdSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalIdSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByStyleNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QAfterSortBy>
      thenByStyleNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameSnapshot', Sort.desc);
    });
  }
}

extension OrderStyleSnapshotEntityQueryWhereDistinct on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QDistinct> {
  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QDistinct>
      distinctByInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QDistinct>
      distinctByOrderInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QDistinct>
      distinctByOrderItemInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderItemInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QDistinct>
      distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QDistinct>
      distinctByStyleNameInternalIdSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleNameInternalIdSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QDistinct>
      distinctByStyleNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }
}

extension OrderStyleSnapshotEntityQueryProperty on QueryBuilder<
    OrderStyleSnapshotEntity, OrderStyleSnapshotEntity, QQueryProperty> {
  QueryBuilder<OrderStyleSnapshotEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, String, QQueryOperations>
      internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, String, QQueryOperations>
      orderInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderInternalId');
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, String, QQueryOperations>
      orderItemInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderItemInternalId');
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, String?, QQueryOperations>
      styleNameInternalIdSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleNameInternalIdSnapshot');
    });
  }

  QueryBuilder<OrderStyleSnapshotEntity, String, QQueryOperations>
      styleNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleNameSnapshot');
    });
  }
}
