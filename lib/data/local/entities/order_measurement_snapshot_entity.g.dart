// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_measurement_snapshot_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderMeasurementSnapshotEntityCollection on Isar {
  IsarCollection<OrderMeasurementSnapshotEntity>
      get orderMeasurementSnapshotEntitys => this.collection();
}

const OrderMeasurementSnapshotEntitySchema = CollectionSchema(
  name: r'OrderMeasurementSnapshotEntity',
  id: -7706627693523675543,
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
    r'shopId': PropertySchema(
      id: 3,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'sourceMeasurementProfileId': PropertySchema(
      id: 4,
      name: r'sourceMeasurementProfileId',
      type: IsarType.string,
    )
  },
  estimateSize: _orderMeasurementSnapshotEntityEstimateSize,
  serialize: _orderMeasurementSnapshotEntitySerialize,
  deserialize: _orderMeasurementSnapshotEntityDeserialize,
  deserializeProp: _orderMeasurementSnapshotEntityDeserializeProp,
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
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'orderInternalId',
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
  getId: _orderMeasurementSnapshotEntityGetId,
  getLinks: _orderMeasurementSnapshotEntityGetLinks,
  attach: _orderMeasurementSnapshotEntityAttach,
  version: '3.1.0+1',
);

int _orderMeasurementSnapshotEntityEstimateSize(
  OrderMeasurementSnapshotEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.orderInternalId.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  {
    final value = object.sourceMeasurementProfileId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _orderMeasurementSnapshotEntitySerialize(
  OrderMeasurementSnapshotEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.internalId);
  writer.writeString(offsets[2], object.orderInternalId);
  writer.writeString(offsets[3], object.shopId);
  writer.writeString(offsets[4], object.sourceMeasurementProfileId);
}

OrderMeasurementSnapshotEntity _orderMeasurementSnapshotEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderMeasurementSnapshotEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.internalId = reader.readString(offsets[1]);
  object.orderInternalId = reader.readString(offsets[2]);
  object.shopId = reader.readString(offsets[3]);
  object.sourceMeasurementProfileId = reader.readStringOrNull(offsets[4]);
  return object;
}

P _orderMeasurementSnapshotEntityDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderMeasurementSnapshotEntityGetId(OrderMeasurementSnapshotEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderMeasurementSnapshotEntityGetLinks(
    OrderMeasurementSnapshotEntity object) {
  return [];
}

void _orderMeasurementSnapshotEntityAttach(
    IsarCollection<dynamic> col, Id id, OrderMeasurementSnapshotEntity object) {
  object.id = id;
}

extension OrderMeasurementSnapshotEntityByIndex
    on IsarCollection<OrderMeasurementSnapshotEntity> {
  Future<OrderMeasurementSnapshotEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  OrderMeasurementSnapshotEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<OrderMeasurementSnapshotEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<OrderMeasurementSnapshotEntity?> getAllByInternalIdSync(
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

  Future<Id> putByInternalId(OrderMeasurementSnapshotEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(OrderMeasurementSnapshotEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(
      List<OrderMeasurementSnapshotEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<OrderMeasurementSnapshotEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }

  Future<OrderMeasurementSnapshotEntity?> getByOrderInternalId(
      String orderInternalId) {
    return getByIndex(r'orderInternalId', [orderInternalId]);
  }

  OrderMeasurementSnapshotEntity? getByOrderInternalIdSync(
      String orderInternalId) {
    return getByIndexSync(r'orderInternalId', [orderInternalId]);
  }

  Future<bool> deleteByOrderInternalId(String orderInternalId) {
    return deleteByIndex(r'orderInternalId', [orderInternalId]);
  }

  bool deleteByOrderInternalIdSync(String orderInternalId) {
    return deleteByIndexSync(r'orderInternalId', [orderInternalId]);
  }

  Future<List<OrderMeasurementSnapshotEntity?>> getAllByOrderInternalId(
      List<String> orderInternalIdValues) {
    final values = orderInternalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'orderInternalId', values);
  }

  List<OrderMeasurementSnapshotEntity?> getAllByOrderInternalIdSync(
      List<String> orderInternalIdValues) {
    final values = orderInternalIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'orderInternalId', values);
  }

  Future<int> deleteAllByOrderInternalId(List<String> orderInternalIdValues) {
    final values = orderInternalIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'orderInternalId', values);
  }

  int deleteAllByOrderInternalIdSync(List<String> orderInternalIdValues) {
    final values = orderInternalIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'orderInternalId', values);
  }

  Future<Id> putByOrderInternalId(OrderMeasurementSnapshotEntity object) {
    return putByIndex(r'orderInternalId', object);
  }

  Id putByOrderInternalIdSync(OrderMeasurementSnapshotEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'orderInternalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOrderInternalId(
      List<OrderMeasurementSnapshotEntity> objects) {
    return putAllByIndex(r'orderInternalId', objects);
  }

  List<Id> putAllByOrderInternalIdSync(
      List<OrderMeasurementSnapshotEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'orderInternalId', objects, saveLinks: saveLinks);
  }
}

extension OrderMeasurementSnapshotEntityQueryWhereSort on QueryBuilder<
    OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity, QWhere> {
  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OrderMeasurementSnapshotEntityQueryWhere on QueryBuilder<
    OrderMeasurementSnapshotEntity,
    OrderMeasurementSnapshotEntity,
    QWhereClause> {
  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterWhereClause> internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterWhereClause> orderInternalIdEqualTo(String orderInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderInternalId',
        value: [orderInternalId],
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

extension OrderMeasurementSnapshotEntityQueryFilter on QueryBuilder<
    OrderMeasurementSnapshotEntity,
    OrderMeasurementSnapshotEntity,
    QFilterCondition> {
  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> orderInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> orderInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
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

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceMeasurementProfileId',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceMeasurementProfileId',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceMeasurementProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceMeasurementProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceMeasurementProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceMeasurementProfileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceMeasurementProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceMeasurementProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
          QAfterFilterCondition>
      sourceMeasurementProfileIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceMeasurementProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
          QAfterFilterCondition>
      sourceMeasurementProfileIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceMeasurementProfileId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceMeasurementProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterFilterCondition> sourceMeasurementProfileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceMeasurementProfileId',
        value: '',
      ));
    });
  }
}

extension OrderMeasurementSnapshotEntityQueryObject on QueryBuilder<
    OrderMeasurementSnapshotEntity,
    OrderMeasurementSnapshotEntity,
    QFilterCondition> {}

extension OrderMeasurementSnapshotEntityQueryLinks on QueryBuilder<
    OrderMeasurementSnapshotEntity,
    OrderMeasurementSnapshotEntity,
    QFilterCondition> {}

extension OrderMeasurementSnapshotEntityQuerySortBy on QueryBuilder<
    OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity, QSortBy> {
  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortByOrderInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortByOrderInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortBySourceMeasurementProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> sortBySourceMeasurementProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.desc);
    });
  }
}

extension OrderMeasurementSnapshotEntityQuerySortThenBy on QueryBuilder<
    OrderMeasurementSnapshotEntity,
    OrderMeasurementSnapshotEntity,
    QSortThenBy> {
  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByOrderInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByOrderInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenBySourceMeasurementProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QAfterSortBy> thenBySourceMeasurementProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.desc);
    });
  }
}

extension OrderMeasurementSnapshotEntityQueryWhereDistinct on QueryBuilder<
    OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity, QDistinct> {
  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QDistinct> distinctByInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QDistinct> distinctByOrderInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
      QDistinct> distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, OrderMeasurementSnapshotEntity,
          QDistinct>
      distinctBySourceMeasurementProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceMeasurementProfileId',
          caseSensitive: caseSensitive);
    });
  }
}

extension OrderMeasurementSnapshotEntityQueryProperty on QueryBuilder<
    OrderMeasurementSnapshotEntity,
    OrderMeasurementSnapshotEntity,
    QQueryProperty> {
  QueryBuilder<OrderMeasurementSnapshotEntity, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, String, QQueryOperations>
      internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, String, QQueryOperations>
      orderInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderInternalId');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotEntity, String?, QQueryOperations>
      sourceMeasurementProfileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceMeasurementProfileId');
    });
  }
}
