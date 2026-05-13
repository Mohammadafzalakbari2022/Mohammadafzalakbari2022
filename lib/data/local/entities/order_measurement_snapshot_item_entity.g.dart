// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_measurement_snapshot_item_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderMeasurementSnapshotItemEntityCollection on Isar {
  IsarCollection<OrderMeasurementSnapshotItemEntity>
      get orderMeasurementSnapshotItemEntitys => this.collection();
}

const OrderMeasurementSnapshotItemEntitySchema = CollectionSchema(
  name: r'OrderMeasurementSnapshotItemEntity',
  id: -8904583364789736841,
  properties: {
    r'measurementTypeInternalId': PropertySchema(
      id: 0,
      name: r'measurementTypeInternalId',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 1,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'snapshotInternalId': PropertySchema(
      id: 2,
      name: r'snapshotInternalId',
      type: IsarType.string,
    ),
    r'sortOrder': PropertySchema(
      id: 3,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'typeNameSnapshot': PropertySchema(
      id: 4,
      name: r'typeNameSnapshot',
      type: IsarType.string,
    ),
    r'unitCode': PropertySchema(
      id: 5,
      name: r'unitCode',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: 6,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _orderMeasurementSnapshotItemEntityEstimateSize,
  serialize: _orderMeasurementSnapshotItemEntitySerialize,
  deserialize: _orderMeasurementSnapshotItemEntityDeserialize,
  deserializeProp: _orderMeasurementSnapshotItemEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'snapshotInternalId': IndexSchema(
      id: -4481210298163749424,
      name: r'snapshotInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'snapshotInternalId',
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _orderMeasurementSnapshotItemEntityGetId,
  getLinks: _orderMeasurementSnapshotItemEntityGetLinks,
  attach: _orderMeasurementSnapshotItemEntityAttach,
  version: '3.1.0+1',
);

int _orderMeasurementSnapshotItemEntityEstimateSize(
  OrderMeasurementSnapshotItemEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.measurementTypeInternalId.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  bytesCount += 3 + object.snapshotInternalId.length * 3;
  bytesCount += 3 + object.typeNameSnapshot.length * 3;
  bytesCount += 3 + object.value.length * 3;
  return bytesCount;
}

void _orderMeasurementSnapshotItemEntitySerialize(
  OrderMeasurementSnapshotItemEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.measurementTypeInternalId);
  writer.writeString(offsets[1], object.shopId);
  writer.writeString(offsets[2], object.snapshotInternalId);
  writer.writeLong(offsets[3], object.sortOrder);
  writer.writeString(offsets[4], object.typeNameSnapshot);
  writer.writeLong(offsets[5], object.unitCode);
  writer.writeString(offsets[6], object.value);
}

OrderMeasurementSnapshotItemEntity
    _orderMeasurementSnapshotItemEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderMeasurementSnapshotItemEntity();
  object.id = id;
  object.measurementTypeInternalId = reader.readString(offsets[0]);
  object.shopId = reader.readString(offsets[1]);
  object.snapshotInternalId = reader.readString(offsets[2]);
  object.sortOrder = reader.readLong(offsets[3]);
  object.typeNameSnapshot = reader.readString(offsets[4]);
  object.unitCode = reader.readLong(offsets[5]);
  object.value = reader.readString(offsets[6]);
  return object;
}

P _orderMeasurementSnapshotItemEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderMeasurementSnapshotItemEntityGetId(
    OrderMeasurementSnapshotItemEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderMeasurementSnapshotItemEntityGetLinks(
    OrderMeasurementSnapshotItemEntity object) {
  return [];
}

void _orderMeasurementSnapshotItemEntityAttach(IsarCollection<dynamic> col,
    Id id, OrderMeasurementSnapshotItemEntity object) {
  object.id = id;
}

extension OrderMeasurementSnapshotItemEntityQueryWhereSort on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QWhere> {
  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterWhere> anySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sortOrder'),
      );
    });
  }
}

extension OrderMeasurementSnapshotItemEntityQueryWhere on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QWhereClause> {
  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterWhereClause> snapshotInternalIdEqualTo(String snapshotInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'snapshotInternalId',
        value: [snapshotInternalId],
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterWhereClause>
      snapshotInternalIdNotEqualTo(String snapshotInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'snapshotInternalId',
              lower: [],
              upper: [snapshotInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'snapshotInternalId',
              lower: [snapshotInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'snapshotInternalId',
              lower: [snapshotInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'snapshotInternalId',
              lower: [],
              upper: [snapshotInternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterWhereClause>
      measurementTypeInternalIdEqualTo(String measurementTypeInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'measurementTypeInternalId',
        value: [measurementTypeInternalId],
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterWhereClause>
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterWhereClause> sortOrderEqualTo(int sortOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sortOrder',
        value: [sortOrder],
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterWhereClause> sortOrderLessThan(
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterWhereClause> sortOrderBetween(
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
}

extension OrderMeasurementSnapshotItemEntityQueryFilter on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QFilterCondition> {
  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measurementTypeInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> measurementTypeInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'measurementTypeInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> shopIdEqualTo(
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> shopIdLessThan(
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> shopIdBetween(
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> shopIdEndsWith(
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
      shopIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
      shopIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> snapshotInternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> snapshotInternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snapshotInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> snapshotInternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snapshotInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> snapshotInternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snapshotInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> snapshotInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'snapshotInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> snapshotInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'snapshotInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
      snapshotInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'snapshotInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
      snapshotInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'snapshotInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> snapshotInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> snapshotInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'snapshotInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> sortOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> typeNameSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> typeNameSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> typeNameSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> typeNameSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeNameSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> typeNameSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> typeNameSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
      typeNameSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
      typeNameSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeNameSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> typeNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> typeNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> unitCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitCode',
        value: value,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> valueEqualTo(
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> valueLessThan(
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> valueBetween(
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

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterFilterCondition> valueEndsWith(
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

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterFilterCondition> valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension OrderMeasurementSnapshotItemEntityQueryObject on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QFilterCondition> {}

extension OrderMeasurementSnapshotItemEntityQueryLinks on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QFilterCondition> {}

extension OrderMeasurementSnapshotItemEntityQuerySortBy on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QSortBy> {
  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> sortByMeasurementTypeInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementTypeInternalId', Sort.asc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> sortByMeasurementTypeInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementTypeInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> sortBySnapshotInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotInternalId', Sort.asc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> sortBySnapshotInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> sortByTypeNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> sortByTypeNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> sortByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> sortByUnitCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension OrderMeasurementSnapshotItemEntityQuerySortThenBy on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QSortThenBy> {
  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> thenByMeasurementTypeInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementTypeInternalId', Sort.asc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> thenByMeasurementTypeInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementTypeInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> thenBySnapshotInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotInternalId', Sort.asc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> thenBySnapshotInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> thenByTypeNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QAfterSortBy> thenByTypeNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenByUnitCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.desc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension OrderMeasurementSnapshotItemEntityQueryWhereDistinct on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QDistinct> {
  QueryBuilder<OrderMeasurementSnapshotItemEntity,
          OrderMeasurementSnapshotItemEntity, QDistinct>
      distinctByMeasurementTypeInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'measurementTypeInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QDistinct> distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QDistinct> distinctBySnapshotInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QDistinct> distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QDistinct> distinctByTypeNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity, QDistinct> distinctByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitCode');
    });
  }

  QueryBuilder<
      OrderMeasurementSnapshotItemEntity,
      OrderMeasurementSnapshotItemEntity,
      QDistinct> distinctByValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension OrderMeasurementSnapshotItemEntityQueryProperty on QueryBuilder<
    OrderMeasurementSnapshotItemEntity,
    OrderMeasurementSnapshotItemEntity,
    QQueryProperty> {
  QueryBuilder<OrderMeasurementSnapshotItemEntity, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity, String, QQueryOperations>
      measurementTypeInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measurementTypeInternalId');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity, String, QQueryOperations>
      snapshotInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotInternalId');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity, int, QQueryOperations>
      sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity, String, QQueryOperations>
      typeNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeNameSnapshot');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity, int, QQueryOperations>
      unitCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitCode');
    });
  }

  QueryBuilder<OrderMeasurementSnapshotItemEntity, String, QQueryOperations>
      valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
