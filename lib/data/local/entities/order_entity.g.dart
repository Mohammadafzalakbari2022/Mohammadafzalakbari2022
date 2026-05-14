// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderEntityCollection on Isar {
  IsarCollection<OrderEntity> get orderEntitys => this.collection();
}

const OrderEntitySchema = CollectionSchema(
  name: r'OrderEntity',
  id: 4301709931984059335,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customerInternalId': PropertySchema(
      id: 1,
      name: r'customerInternalId',
      type: IsarType.string,
    ),
    r'deletedAt': PropertySchema(
      id: 2,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'deliveryDate': PropertySchema(
      id: 3,
      name: r'deliveryDate',
      type: IsarType.dateTime,
    ),
    r'displayOrderNo': PropertySchema(
      id: 4,
      name: r'displayOrderNo',
      type: IsarType.string,
    ),
    r'internalId': PropertySchema(
      id: 5,
      name: r'internalId',
      type: IsarType.string,
    ),
    r'internalNotes': PropertySchema(
      id: 6,
      name: r'internalNotes',
      type: IsarType.string,
    ),
    r'measurementsSnapshot': PropertySchema(
      id: 7,
      name: r'measurementsSnapshot',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 8,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'sourceMeasurementProfileId': PropertySchema(
      id: 9,
      name: r'sourceMeasurementProfileId',
      type: IsarType.string,
    ),
    r'sourceMeasurementProfileLabel': PropertySchema(
      id: 10,
      name: r'sourceMeasurementProfileLabel',
      type: IsarType.string,
    ),
    r'statusIndex': PropertySchema(
      id: 11,
      name: r'statusIndex',
      type: IsarType.long,
    ),
    r'styleNotes': PropertySchema(
      id: 12,
      name: r'styleNotes',
      type: IsarType.string,
    ),
    r'totalAmountMinor': PropertySchema(
      id: 13,
      name: r'totalAmountMinor',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _orderEntityEstimateSize,
  serialize: _orderEntitySerialize,
  deserialize: _orderEntityDeserialize,
  deserializeProp: _orderEntityDeserializeProp,
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
    r'customerInternalId': IndexSchema(
      id: -1871860840449681099,
      name: r'customerInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'customerInternalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'displayOrderNo': IndexSchema(
      id: 1937663667233477623,
      name: r'displayOrderNo',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'displayOrderNo',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'statusIndex': IndexSchema(
      id: -3068638669929638322,
      name: r'statusIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'statusIndex',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'deliveryDate': IndexSchema(
      id: 3163565673826690650,
      name: r'deliveryDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deliveryDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'totalAmountMinor': IndexSchema(
      id: -162420101180074403,
      name: r'totalAmountMinor',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'totalAmountMinor',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _orderEntityGetId,
  getLinks: _orderEntityGetLinks,
  attach: _orderEntityAttach,
  version: '3.1.0+1',
);

int _orderEntityEstimateSize(
  OrderEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.customerInternalId.length * 3;
  bytesCount += 3 + object.displayOrderNo.length * 3;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.internalNotes.length * 3;
  bytesCount += 3 + object.measurementsSnapshot.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  {
    final value = object.sourceMeasurementProfileId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sourceMeasurementProfileLabel.length * 3;
  bytesCount += 3 + object.styleNotes.length * 3;
  return bytesCount;
}

void _orderEntitySerialize(
  OrderEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.customerInternalId);
  writer.writeDateTime(offsets[2], object.deletedAt);
  writer.writeDateTime(offsets[3], object.deliveryDate);
  writer.writeString(offsets[4], object.displayOrderNo);
  writer.writeString(offsets[5], object.internalId);
  writer.writeString(offsets[6], object.internalNotes);
  writer.writeString(offsets[7], object.measurementsSnapshot);
  writer.writeString(offsets[8], object.shopId);
  writer.writeString(offsets[9], object.sourceMeasurementProfileId);
  writer.writeString(offsets[10], object.sourceMeasurementProfileLabel);
  writer.writeLong(offsets[11], object.statusIndex);
  writer.writeString(offsets[12], object.styleNotes);
  writer.writeLong(offsets[13], object.totalAmountMinor);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

OrderEntity _orderEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderEntity();
  object.createdAt = reader.readDateTimeOrNull(offsets[0]);
  object.customerInternalId = reader.readString(offsets[1]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[2]);
  object.deliveryDate = reader.readDateTime(offsets[3]);
  object.displayOrderNo = reader.readString(offsets[4]);
  object.id = id;
  object.internalId = reader.readString(offsets[5]);
  object.internalNotes = reader.readString(offsets[6]);
  object.measurementsSnapshot = reader.readString(offsets[7]);
  object.shopId = reader.readString(offsets[8]);
  object.sourceMeasurementProfileId = reader.readStringOrNull(offsets[9]);
  object.sourceMeasurementProfileLabel = reader.readString(offsets[10]);
  object.statusIndex = reader.readLong(offsets[11]);
  object.styleNotes = reader.readString(offsets[12]);
  object.totalAmountMinor = reader.readLong(offsets[13]);
  object.updatedAt = reader.readDateTime(offsets[14]);
  return object;
}

P _orderEntityDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderEntityGetId(OrderEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderEntityGetLinks(OrderEntity object) {
  return [];
}

void _orderEntityAttach(
    IsarCollection<dynamic> col, Id id, OrderEntity object) {
  object.id = id;
}

extension OrderEntityByIndex on IsarCollection<OrderEntity> {
  Future<OrderEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  OrderEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<OrderEntity?>> getAllByInternalId(List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<OrderEntity?> getAllByInternalIdSync(List<String> internalIdValues) {
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

  Future<Id> putByInternalId(OrderEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(OrderEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(List<OrderEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<OrderEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension OrderEntityQueryWhereSort
    on QueryBuilder<OrderEntity, OrderEntity, QWhere> {
  QueryBuilder<OrderEntity, OrderEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhere> anyStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'statusIndex'),
      );
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhere> anyDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deliveryDate'),
      );
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhere> anyTotalAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'totalAmountMinor'),
      );
    });
  }
}

extension OrderEntityQueryWhere
    on QueryBuilder<OrderEntity, OrderEntity, QWhereClause> {
  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> internalIdEqualTo(
      String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> shopIdEqualTo(
      String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> shopIdNotEqualTo(
      String shopId) {
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      customerInternalIdEqualTo(String customerInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'customerInternalId',
        value: [customerInternalId],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      customerInternalIdNotEqualTo(String customerInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerInternalId',
              lower: [],
              upper: [customerInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerInternalId',
              lower: [customerInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerInternalId',
              lower: [customerInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'customerInternalId',
              lower: [],
              upper: [customerInternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      displayOrderNoEqualTo(String displayOrderNo) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'displayOrderNo',
        value: [displayOrderNo],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      displayOrderNoNotEqualTo(String displayOrderNo) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayOrderNo',
              lower: [],
              upper: [displayOrderNo],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayOrderNo',
              lower: [displayOrderNo],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayOrderNo',
              lower: [displayOrderNo],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayOrderNo',
              lower: [],
              upper: [displayOrderNo],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> statusIndexEqualTo(
      int statusIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statusIndex',
        value: [statusIndex],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      statusIndexNotEqualTo(int statusIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusIndex',
              lower: [],
              upper: [statusIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusIndex',
              lower: [statusIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusIndex',
              lower: [statusIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusIndex',
              lower: [],
              upper: [statusIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      statusIndexGreaterThan(
    int statusIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'statusIndex',
        lower: [statusIndex],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> statusIndexLessThan(
    int statusIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'statusIndex',
        lower: [],
        upper: [statusIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> statusIndexBetween(
    int lowerStatusIndex,
    int upperStatusIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'statusIndex',
        lower: [lowerStatusIndex],
        includeLower: includeLower,
        upper: [upperStatusIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> deliveryDateEqualTo(
      DateTime deliveryDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deliveryDate',
        value: [deliveryDate],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      deliveryDateNotEqualTo(DateTime deliveryDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliveryDate',
              lower: [],
              upper: [deliveryDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliveryDate',
              lower: [deliveryDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliveryDate',
              lower: [deliveryDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deliveryDate',
              lower: [],
              upper: [deliveryDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      deliveryDateGreaterThan(
    DateTime deliveryDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deliveryDate',
        lower: [deliveryDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      deliveryDateLessThan(
    DateTime deliveryDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deliveryDate',
        lower: [],
        upper: [deliveryDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> deliveryDateBetween(
    DateTime lowerDeliveryDate,
    DateTime upperDeliveryDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deliveryDate',
        lower: [lowerDeliveryDate],
        includeLower: includeLower,
        upper: [upperDeliveryDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> updatedAtEqualTo(
      DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> updatedAtNotEqualTo(
      DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause> updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      totalAmountMinorEqualTo(int totalAmountMinor) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'totalAmountMinor',
        value: [totalAmountMinor],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      totalAmountMinorNotEqualTo(int totalAmountMinor) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'totalAmountMinor',
              lower: [],
              upper: [totalAmountMinor],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'totalAmountMinor',
              lower: [totalAmountMinor],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'totalAmountMinor',
              lower: [totalAmountMinor],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'totalAmountMinor',
              lower: [],
              upper: [totalAmountMinor],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      totalAmountMinorGreaterThan(
    int totalAmountMinor, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'totalAmountMinor',
        lower: [totalAmountMinor],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      totalAmountMinorLessThan(
    int totalAmountMinor, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'totalAmountMinor',
        lower: [],
        upper: [totalAmountMinor],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterWhereClause>
      totalAmountMinorBetween(
    int lowerTotalAmountMinor,
    int upperTotalAmountMinor, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'totalAmountMinor',
        lower: [lowerTotalAmountMinor],
        includeLower: includeLower,
        upper: [upperTotalAmountMinor],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OrderEntityQueryFilter
    on QueryBuilder<OrderEntity, OrderEntity, QFilterCondition> {
  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      customerInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deletedAtGreaterThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deletedAtLessThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deletedAtBetween(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deliveryDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deliveryDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deliveryDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      deliveryDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveryDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayOrderNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayOrderNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayOrderNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayOrderNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayOrderNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayOrderNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayOrderNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayOrderNo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayOrderNo',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      displayOrderNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayOrderNo',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'internalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'internalNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'internalNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'internalNotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'internalNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'internalNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'internalNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'internalNotes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      internalNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measurementsSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'measurementsSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'measurementsSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'measurementsSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'measurementsSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'measurementsSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'measurementsSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'measurementsSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measurementsSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      measurementsSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'measurementsSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> shopIdEqualTo(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> shopIdLessThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> shopIdBetween(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> shopIdEndsWith(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> shopIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition> shopIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceMeasurementProfileId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceMeasurementProfileId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdEqualTo(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdGreaterThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdLessThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdBetween(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdStartsWith(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdEndsWith(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceMeasurementProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceMeasurementProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceMeasurementProfileLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceMeasurementProfileLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceMeasurementProfileLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceMeasurementProfileLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceMeasurementProfileLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceMeasurementProfileLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceMeasurementProfileLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceMeasurementProfileLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceMeasurementProfileLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceMeasurementProfileLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      statusIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      statusIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      statusIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      statusIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styleNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styleNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styleNotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'styleNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'styleNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleNotes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      totalAmountMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      totalAmountMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      totalAmountMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      totalAmountMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAmountMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      updatedAtBetween(
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

extension OrderEntityQueryObject
    on QueryBuilder<OrderEntity, OrderEntity, QFilterCondition> {}

extension OrderEntityQueryLinks
    on QueryBuilder<OrderEntity, OrderEntity, QFilterCondition> {}

extension OrderEntityQuerySortBy
    on QueryBuilder<OrderEntity, OrderEntity, QSortBy> {
  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCustomerInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCustomerInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDate', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByDeliveryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDate', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByDisplayOrderNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrderNo', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByDisplayOrderNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrderNo', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByInternalNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalNotes', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByInternalNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalNotes', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByMeasurementsSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByMeasurementsSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortBySourceMeasurementProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortBySourceMeasurementProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortBySourceMeasurementProfileLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileLabel', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortBySourceMeasurementProfileLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileLabel', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusIndex', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusIndex', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByStyleNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNotes', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByStyleNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNotes', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByTotalAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByTotalAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmountMinor', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OrderEntityQuerySortThenBy
    on QueryBuilder<OrderEntity, OrderEntity, QSortThenBy> {
  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCustomerInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCustomerInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDate', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByDeliveryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDate', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByDisplayOrderNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrderNo', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByDisplayOrderNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrderNo', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByInternalNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalNotes', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByInternalNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalNotes', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByMeasurementsSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByMeasurementsSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenBySourceMeasurementProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenBySourceMeasurementProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenBySourceMeasurementProfileLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileLabel', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenBySourceMeasurementProfileLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileLabel', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusIndex', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByStatusIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusIndex', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByStyleNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNotes', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByStyleNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNotes', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByTotalAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByTotalAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmountMinor', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OrderEntityQueryWhereDistinct
    on QueryBuilder<OrderEntity, OrderEntity, QDistinct> {
  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByCustomerInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByDeliveryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryDate');
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByDisplayOrderNo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayOrderNo',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByInternalId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByInternalNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalNotes',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByMeasurementsSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'measurementsSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByShopId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctBySourceMeasurementProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceMeasurementProfileId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctBySourceMeasurementProfileLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceMeasurementProfileLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByStatusIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusIndex');
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByStyleNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleNotes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByTotalAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmountMinor');
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension OrderEntityQueryProperty
    on QueryBuilder<OrderEntity, OrderEntity, QQueryProperty> {
  QueryBuilder<OrderEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderEntity, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations>
      customerInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerInternalId');
    });
  }

  QueryBuilder<OrderEntity, DateTime?, QQueryOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<OrderEntity, DateTime, QQueryOperations> deliveryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryDate');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations> displayOrderNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayOrderNo');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations> internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations> internalNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalNotes');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations>
      measurementsSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measurementsSnapshot');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations> shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<OrderEntity, String?, QQueryOperations>
      sourceMeasurementProfileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceMeasurementProfileId');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations>
      sourceMeasurementProfileLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceMeasurementProfileLabel');
    });
  }

  QueryBuilder<OrderEntity, int, QQueryOperations> statusIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusIndex');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations> styleNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleNotes');
    });
  }

  QueryBuilder<OrderEntity, int, QQueryOperations> totalAmountMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmountMinor');
    });
  }

  QueryBuilder<OrderEntity, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
