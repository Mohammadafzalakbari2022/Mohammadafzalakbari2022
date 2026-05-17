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
    r'catalogDesignNameSnapshot': PropertySchema(
      id: 0,
      name: r'catalogDesignNameSnapshot',
      type: IsarType.string,
    ),
    r'catalogDesignerShopNameSnapshot': PropertySchema(
      id: 1,
      name: r'catalogDesignerShopNameSnapshot',
      type: IsarType.string,
    ),
    r'catalogImagePathSnapshot': PropertySchema(
      id: 2,
      name: r'catalogImagePathSnapshot',
      type: IsarType.string,
    ),
    r'catalogItemInternalId': PropertySchema(
      id: 3,
      name: r'catalogItemInternalId',
      type: IsarType.string,
    ),
    r'catalogThumbnailPathSnapshot': PropertySchema(
      id: 4,
      name: r'catalogThumbnailPathSnapshot',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customerInternalId': PropertySchema(
      id: 6,
      name: r'customerInternalId',
      type: IsarType.string,
    ),
    r'deletedAt': PropertySchema(
      id: 7,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'deliveryDate': PropertySchema(
      id: 8,
      name: r'deliveryDate',
      type: IsarType.dateTime,
    ),
    r'displayOrderNo': PropertySchema(
      id: 9,
      name: r'displayOrderNo',
      type: IsarType.string,
    ),
    r'fabricColorPresetInternalId': PropertySchema(
      id: 10,
      name: r'fabricColorPresetInternalId',
      type: IsarType.string,
    ),
    r'fabricColorSnapshot': PropertySchema(
      id: 11,
      name: r'fabricColorSnapshot',
      type: IsarType.string,
    ),
    r'fabricIdSnapshot': PropertySchema(
      id: 12,
      name: r'fabricIdSnapshot',
      type: IsarType.string,
    ),
    r'fabricNamePresetInternalId': PropertySchema(
      id: 13,
      name: r'fabricNamePresetInternalId',
      type: IsarType.string,
    ),
    r'fabricNameSnapshot': PropertySchema(
      id: 14,
      name: r'fabricNameSnapshot',
      type: IsarType.string,
    ),
    r'internalId': PropertySchema(
      id: 15,
      name: r'internalId',
      type: IsarType.string,
    ),
    r'internalNotes': PropertySchema(
      id: 16,
      name: r'internalNotes',
      type: IsarType.string,
    ),
    r'measurementsSnapshot': PropertySchema(
      id: 17,
      name: r'measurementsSnapshot',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 18,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'sourceMeasurementProfileId': PropertySchema(
      id: 19,
      name: r'sourceMeasurementProfileId',
      type: IsarType.string,
    ),
    r'sourceMeasurementProfileLabel': PropertySchema(
      id: 20,
      name: r'sourceMeasurementProfileLabel',
      type: IsarType.string,
    ),
    r'statusIndex': PropertySchema(
      id: 21,
      name: r'statusIndex',
      type: IsarType.long,
    ),
    r'styleName': PropertySchema(
      id: 22,
      name: r'styleName',
      type: IsarType.string,
    ),
    r'styleNameInternalId': PropertySchema(
      id: 23,
      name: r'styleNameInternalId',
      type: IsarType.string,
    ),
    r'styleSelectionJson': PropertySchema(
      id: 24,
      name: r'styleSelectionJson',
      type: IsarType.string,
    ),
    r'styleSummary': PropertySchema(
      id: 25,
      name: r'styleSummary',
      type: IsarType.string,
    ),
    r'totalAmountMinor': PropertySchema(
      id: 26,
      name: r'totalAmountMinor',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 27,
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
  bytesCount += 3 + object.catalogDesignNameSnapshot.length * 3;
  bytesCount += 3 + object.catalogDesignerShopNameSnapshot.length * 3;
  {
    final value = object.catalogImagePathSnapshot;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.catalogItemInternalId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.catalogThumbnailPathSnapshot;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.customerInternalId.length * 3;
  bytesCount += 3 + object.displayOrderNo.length * 3;
  {
    final value = object.fabricColorPresetInternalId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fabricColorSnapshot.length * 3;
  bytesCount += 3 + object.fabricIdSnapshot.length * 3;
  {
    final value = object.fabricNamePresetInternalId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fabricNameSnapshot.length * 3;
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
  bytesCount += 3 + object.styleName.length * 3;
  {
    final value = object.styleNameInternalId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.styleSelectionJson.length * 3;
  bytesCount += 3 + object.styleSummary.length * 3;
  return bytesCount;
}

void _orderEntitySerialize(
  OrderEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.catalogDesignNameSnapshot);
  writer.writeString(offsets[1], object.catalogDesignerShopNameSnapshot);
  writer.writeString(offsets[2], object.catalogImagePathSnapshot);
  writer.writeString(offsets[3], object.catalogItemInternalId);
  writer.writeString(offsets[4], object.catalogThumbnailPathSnapshot);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeString(offsets[6], object.customerInternalId);
  writer.writeDateTime(offsets[7], object.deletedAt);
  writer.writeDateTime(offsets[8], object.deliveryDate);
  writer.writeString(offsets[9], object.displayOrderNo);
  writer.writeString(offsets[10], object.fabricColorPresetInternalId);
  writer.writeString(offsets[11], object.fabricColorSnapshot);
  writer.writeString(offsets[12], object.fabricIdSnapshot);
  writer.writeString(offsets[13], object.fabricNamePresetInternalId);
  writer.writeString(offsets[14], object.fabricNameSnapshot);
  writer.writeString(offsets[15], object.internalId);
  writer.writeString(offsets[16], object.internalNotes);
  writer.writeString(offsets[17], object.measurementsSnapshot);
  writer.writeString(offsets[18], object.shopId);
  writer.writeString(offsets[19], object.sourceMeasurementProfileId);
  writer.writeString(offsets[20], object.sourceMeasurementProfileLabel);
  writer.writeLong(offsets[21], object.statusIndex);
  writer.writeString(offsets[22], object.styleName);
  writer.writeString(offsets[23], object.styleNameInternalId);
  writer.writeString(offsets[24], object.styleSelectionJson);
  writer.writeString(offsets[25], object.styleSummary);
  writer.writeLong(offsets[26], object.totalAmountMinor);
  writer.writeDateTime(offsets[27], object.updatedAt);
}

OrderEntity _orderEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderEntity();
  object.catalogDesignNameSnapshot = reader.readString(offsets[0]);
  object.catalogDesignerShopNameSnapshot = reader.readString(offsets[1]);
  object.catalogImagePathSnapshot = reader.readStringOrNull(offsets[2]);
  object.catalogItemInternalId = reader.readStringOrNull(offsets[3]);
  object.catalogThumbnailPathSnapshot = reader.readStringOrNull(offsets[4]);
  object.createdAt = reader.readDateTimeOrNull(offsets[5]);
  object.customerInternalId = reader.readString(offsets[6]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[7]);
  object.deliveryDate = reader.readDateTime(offsets[8]);
  object.displayOrderNo = reader.readString(offsets[9]);
  object.fabricColorPresetInternalId = reader.readStringOrNull(offsets[10]);
  object.fabricColorSnapshot = reader.readString(offsets[11]);
  object.fabricIdSnapshot = reader.readString(offsets[12]);
  object.fabricNamePresetInternalId = reader.readStringOrNull(offsets[13]);
  object.fabricNameSnapshot = reader.readString(offsets[14]);
  object.id = id;
  object.internalId = reader.readString(offsets[15]);
  object.internalNotes = reader.readString(offsets[16]);
  object.measurementsSnapshot = reader.readString(offsets[17]);
  object.shopId = reader.readString(offsets[18]);
  object.sourceMeasurementProfileId = reader.readStringOrNull(offsets[19]);
  object.sourceMeasurementProfileLabel = reader.readString(offsets[20]);
  object.statusIndex = reader.readLong(offsets[21]);
  object.styleName = reader.readString(offsets[22]);
  object.styleNameInternalId = reader.readStringOrNull(offsets[23]);
  object.styleSelectionJson = reader.readString(offsets[24]);
  object.styleSummary = reader.readString(offsets[25]);
  object.totalAmountMinor = reader.readLong(offsets[26]);
  object.updatedAt = reader.readDateTime(offsets[27]);
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
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    case 26:
      return (reader.readLong(offset)) as P;
    case 27:
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
      catalogDesignNameSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogDesignNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogDesignNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogDesignNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogDesignNameSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogDesignNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogDesignNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogDesignNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogDesignNameSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogDesignNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogDesignNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogDesignerShopNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogDesignerShopNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogDesignerShopNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogDesignerShopNameSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogDesignerShopNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogDesignerShopNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogDesignerShopNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogDesignerShopNameSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogDesignerShopNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogDesignerShopNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'catalogImagePathSnapshot',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'catalogImagePathSnapshot',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogImagePathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogImagePathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogImagePathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogImagePathSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogImagePathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogImagePathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogImagePathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogImagePathSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogImagePathSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogImagePathSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogImagePathSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'catalogItemInternalId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'catalogItemInternalId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogItemInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogItemInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogItemInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogItemInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogItemInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'catalogThumbnailPathSnapshot',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'catalogThumbnailPathSnapshot',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogThumbnailPathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogThumbnailPathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogThumbnailPathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogThumbnailPathSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogThumbnailPathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogThumbnailPathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogThumbnailPathSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogThumbnailPathSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogThumbnailPathSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogThumbnailPathSnapshot',
        value: '',
      ));
    });
  }

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

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fabricColorPresetInternalId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fabricColorPresetInternalId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricColorPresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fabricColorPresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fabricColorPresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fabricColorPresetInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fabricColorPresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fabricColorPresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fabricColorPresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fabricColorPresetInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricColorPresetInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricColorPresetInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricColorSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fabricColorSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fabricColorSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fabricColorSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fabricColorSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fabricColorSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fabricColorSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fabricColorSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricColorSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricColorSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricColorSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fabricIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fabricIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fabricIdSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fabricIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fabricIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fabricIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fabricIdSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricIdSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricIdSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricIdSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fabricNamePresetInternalId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fabricNamePresetInternalId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricNamePresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fabricNamePresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fabricNamePresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fabricNamePresetInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fabricNamePresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fabricNamePresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fabricNamePresetInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fabricNamePresetInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricNamePresetInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricNamePresetInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fabricNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fabricNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fabricNameSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fabricNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fabricNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fabricNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fabricNameSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      fabricNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricNameSnapshot',
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
      styleNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styleName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'styleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'styleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleName',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleName',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'styleNameInternalId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'styleNameInternalId',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNameInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styleNameInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styleNameInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styleNameInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'styleNameInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'styleNameInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleNameInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleNameInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNameInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleNameInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleNameInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleSelectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styleSelectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styleSelectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styleSelectionJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'styleSelectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'styleSelectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleSelectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleSelectionJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleSelectionJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSelectionJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleSelectionJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styleSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styleSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styleSummary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'styleSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'styleSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleSummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterFilterCondition>
      styleSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleSummary',
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
  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogDesignNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogDesignNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogDesignerShopNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignerShopNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogDesignerShopNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignerShopNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogImagePathSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogImagePathSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogImagePathSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogImagePathSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogItemInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogItemInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogItemInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogItemInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogThumbnailPathSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogThumbnailPathSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByCatalogThumbnailPathSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogThumbnailPathSnapshot', Sort.desc);
    });
  }

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

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricColorPresetInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorPresetInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricColorPresetInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorPresetInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricColorSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricColorSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricIdSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricIdSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricIdSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricIdSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricNamePresetInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNamePresetInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricNamePresetInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNamePresetInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByFabricNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNameSnapshot', Sort.desc);
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByStyleName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleName', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByStyleNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleName', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByStyleNameInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByStyleNameInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByStyleSelectionJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSelectionJson', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByStyleSelectionJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSelectionJson', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> sortByStyleSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSummary', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      sortByStyleSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSummary', Sort.desc);
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
  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogDesignNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogDesignNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogDesignerShopNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignerShopNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogDesignerShopNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignerShopNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogImagePathSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogImagePathSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogImagePathSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogImagePathSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogItemInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogItemInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogItemInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogItemInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogThumbnailPathSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogThumbnailPathSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByCatalogThumbnailPathSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogThumbnailPathSnapshot', Sort.desc);
    });
  }

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

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricColorPresetInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorPresetInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricColorPresetInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorPresetInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricColorSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricColorSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricIdSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricIdSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricIdSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricIdSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricNamePresetInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNamePresetInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricNamePresetInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNamePresetInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByFabricNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNameSnapshot', Sort.desc);
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

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByStyleName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleName', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByStyleNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleName', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByStyleNameInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByStyleNameInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByStyleSelectionJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSelectionJson', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByStyleSelectionJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSelectionJson', Sort.desc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy> thenByStyleSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSummary', Sort.asc);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QAfterSortBy>
      thenByStyleSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSummary', Sort.desc);
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
  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByCatalogDesignNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogDesignNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByCatalogDesignerShopNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogDesignerShopNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByCatalogImagePathSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogImagePathSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByCatalogItemInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogItemInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByCatalogThumbnailPathSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogThumbnailPathSnapshot',
          caseSensitive: caseSensitive);
    });
  }

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

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByFabricColorPresetInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricColorPresetInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByFabricColorSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricColorSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByFabricIdSnapshot(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricIdSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByFabricNamePresetInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricNamePresetInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByFabricNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricNameSnapshot',
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

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByStyleName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByStyleNameInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleNameInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct>
      distinctByStyleSelectionJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleSelectionJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderEntity, OrderEntity, QDistinct> distinctByStyleSummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleSummary', caseSensitive: caseSensitive);
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

  QueryBuilder<OrderEntity, String, QQueryOperations>
      catalogDesignNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogDesignNameSnapshot');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations>
      catalogDesignerShopNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogDesignerShopNameSnapshot');
    });
  }

  QueryBuilder<OrderEntity, String?, QQueryOperations>
      catalogImagePathSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogImagePathSnapshot');
    });
  }

  QueryBuilder<OrderEntity, String?, QQueryOperations>
      catalogItemInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogItemInternalId');
    });
  }

  QueryBuilder<OrderEntity, String?, QQueryOperations>
      catalogThumbnailPathSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogThumbnailPathSnapshot');
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

  QueryBuilder<OrderEntity, String?, QQueryOperations>
      fabricColorPresetInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricColorPresetInternalId');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations>
      fabricColorSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricColorSnapshot');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations>
      fabricIdSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricIdSnapshot');
    });
  }

  QueryBuilder<OrderEntity, String?, QQueryOperations>
      fabricNamePresetInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricNamePresetInternalId');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations>
      fabricNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricNameSnapshot');
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

  QueryBuilder<OrderEntity, String, QQueryOperations> styleNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleName');
    });
  }

  QueryBuilder<OrderEntity, String?, QQueryOperations>
      styleNameInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleNameInternalId');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations>
      styleSelectionJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleSelectionJson');
    });
  }

  QueryBuilder<OrderEntity, String, QQueryOperations> styleSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleSummary');
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
