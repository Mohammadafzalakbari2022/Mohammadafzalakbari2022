// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderItemEntityCollection on Isar {
  IsarCollection<OrderItemEntity> get orderItemEntitys => this.collection();
}

const OrderItemEntitySchema = CollectionSchema(
  name: r'OrderItemEntity',
  id: 1065654758604758688,
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
    r'clothMetersSnapshot': PropertySchema(
      id: 5,
      name: r'clothMetersSnapshot',
      type: IsarType.string,
    ),
    r'clothPriceAmountMinor': PropertySchema(
      id: 6,
      name: r'clothPriceAmountMinor',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 7,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 8,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'fabricColorPresetInternalId': PropertySchema(
      id: 9,
      name: r'fabricColorPresetInternalId',
      type: IsarType.string,
    ),
    r'fabricColorSnapshot': PropertySchema(
      id: 10,
      name: r'fabricColorSnapshot',
      type: IsarType.string,
    ),
    r'fabricIdSnapshot': PropertySchema(
      id: 11,
      name: r'fabricIdSnapshot',
      type: IsarType.string,
    ),
    r'fabricNamePresetInternalId': PropertySchema(
      id: 12,
      name: r'fabricNamePresetInternalId',
      type: IsarType.string,
    ),
    r'fabricNameSnapshot': PropertySchema(
      id: 13,
      name: r'fabricNameSnapshot',
      type: IsarType.string,
    ),
    r'garmentTypeIndex': PropertySchema(
      id: 14,
      name: r'garmentTypeIndex',
      type: IsarType.long,
    ),
    r'internalId': PropertySchema(
      id: 15,
      name: r'internalId',
      type: IsarType.string,
    ),
    r'itemNotes': PropertySchema(
      id: 16,
      name: r'itemNotes',
      type: IsarType.string,
    ),
    r'measurementsSnapshot': PropertySchema(
      id: 17,
      name: r'measurementsSnapshot',
      type: IsarType.string,
    ),
    r'orderInternalId': PropertySchema(
      id: 18,
      name: r'orderInternalId',
      type: IsarType.string,
    ),
    r'priceAmountMinor': PropertySchema(
      id: 19,
      name: r'priceAmountMinor',
      type: IsarType.long,
    ),
    r'shopId': PropertySchema(
      id: 20,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'sortOrder': PropertySchema(
      id: 21,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'sourceMeasurementProfileId': PropertySchema(
      id: 22,
      name: r'sourceMeasurementProfileId',
      type: IsarType.string,
    ),
    r'sourceMeasurementProfileLabel': PropertySchema(
      id: 23,
      name: r'sourceMeasurementProfileLabel',
      type: IsarType.string,
    ),
    r'styleName': PropertySchema(
      id: 24,
      name: r'styleName',
      type: IsarType.string,
    ),
    r'styleNameInternalId': PropertySchema(
      id: 25,
      name: r'styleNameInternalId',
      type: IsarType.string,
    ),
    r'styleSelectionJson': PropertySchema(
      id: 26,
      name: r'styleSelectionJson',
      type: IsarType.string,
    ),
    r'styleSummary': PropertySchema(
      id: 27,
      name: r'styleSummary',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 28,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _orderItemEntityEstimateSize,
  serialize: _orderItemEntitySerialize,
  deserialize: _orderItemEntityDeserialize,
  deserializeProp: _orderItemEntityDeserializeProp,
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
    r'garmentTypeIndex': IndexSchema(
      id: 1071229905578550785,
      name: r'garmentTypeIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'garmentTypeIndex',
          type: IndexType.value,
          caseSensitive: false,
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
  getId: _orderItemEntityGetId,
  getLinks: _orderItemEntityGetLinks,
  attach: _orderItemEntityAttach,
  version: '3.1.0+1',
);

int _orderItemEntityEstimateSize(
  OrderItemEntity object,
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
  bytesCount += 3 + object.clothMetersSnapshot.length * 3;
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
  bytesCount += 3 + object.itemNotes.length * 3;
  bytesCount += 3 + object.measurementsSnapshot.length * 3;
  bytesCount += 3 + object.orderInternalId.length * 3;
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

void _orderItemEntitySerialize(
  OrderItemEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.catalogDesignNameSnapshot);
  writer.writeString(offsets[1], object.catalogDesignerShopNameSnapshot);
  writer.writeString(offsets[2], object.catalogImagePathSnapshot);
  writer.writeString(offsets[3], object.catalogItemInternalId);
  writer.writeString(offsets[4], object.catalogThumbnailPathSnapshot);
  writer.writeString(offsets[5], object.clothMetersSnapshot);
  writer.writeLong(offsets[6], object.clothPriceAmountMinor);
  writer.writeDateTime(offsets[7], object.createdAt);
  writer.writeDateTime(offsets[8], object.deletedAt);
  writer.writeString(offsets[9], object.fabricColorPresetInternalId);
  writer.writeString(offsets[10], object.fabricColorSnapshot);
  writer.writeString(offsets[11], object.fabricIdSnapshot);
  writer.writeString(offsets[12], object.fabricNamePresetInternalId);
  writer.writeString(offsets[13], object.fabricNameSnapshot);
  writer.writeLong(offsets[14], object.garmentTypeIndex);
  writer.writeString(offsets[15], object.internalId);
  writer.writeString(offsets[16], object.itemNotes);
  writer.writeString(offsets[17], object.measurementsSnapshot);
  writer.writeString(offsets[18], object.orderInternalId);
  writer.writeLong(offsets[19], object.priceAmountMinor);
  writer.writeString(offsets[20], object.shopId);
  writer.writeLong(offsets[21], object.sortOrder);
  writer.writeString(offsets[22], object.sourceMeasurementProfileId);
  writer.writeString(offsets[23], object.sourceMeasurementProfileLabel);
  writer.writeString(offsets[24], object.styleName);
  writer.writeString(offsets[25], object.styleNameInternalId);
  writer.writeString(offsets[26], object.styleSelectionJson);
  writer.writeString(offsets[27], object.styleSummary);
  writer.writeDateTime(offsets[28], object.updatedAt);
}

OrderItemEntity _orderItemEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderItemEntity();
  object.catalogDesignNameSnapshot = reader.readString(offsets[0]);
  object.catalogDesignerShopNameSnapshot = reader.readString(offsets[1]);
  object.catalogImagePathSnapshot = reader.readStringOrNull(offsets[2]);
  object.catalogItemInternalId = reader.readStringOrNull(offsets[3]);
  object.catalogThumbnailPathSnapshot = reader.readStringOrNull(offsets[4]);
  object.clothMetersSnapshot = reader.readString(offsets[5]);
  object.clothPriceAmountMinor = reader.readLong(offsets[6]);
  object.createdAt = reader.readDateTime(offsets[7]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[8]);
  object.fabricColorPresetInternalId = reader.readStringOrNull(offsets[9]);
  object.fabricColorSnapshot = reader.readString(offsets[10]);
  object.fabricIdSnapshot = reader.readString(offsets[11]);
  object.fabricNamePresetInternalId = reader.readStringOrNull(offsets[12]);
  object.fabricNameSnapshot = reader.readString(offsets[13]);
  object.garmentTypeIndex = reader.readLong(offsets[14]);
  object.id = id;
  object.internalId = reader.readString(offsets[15]);
  object.itemNotes = reader.readString(offsets[16]);
  object.measurementsSnapshot = reader.readString(offsets[17]);
  object.orderInternalId = reader.readString(offsets[18]);
  object.priceAmountMinor = reader.readLong(offsets[19]);
  object.shopId = reader.readString(offsets[20]);
  object.sortOrder = reader.readLong(offsets[21]);
  object.sourceMeasurementProfileId = reader.readStringOrNull(offsets[22]);
  object.sourceMeasurementProfileLabel = reader.readString(offsets[23]);
  object.styleName = reader.readString(offsets[24]);
  object.styleNameInternalId = reader.readStringOrNull(offsets[25]);
  object.styleSelectionJson = reader.readString(offsets[26]);
  object.styleSummary = reader.readString(offsets[27]);
  object.updatedAt = reader.readDateTime(offsets[28]);
  return object;
}

P _orderItemEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readString(offset)) as P;
    case 27:
      return (reader.readString(offset)) as P;
    case 28:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderItemEntityGetId(OrderItemEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderItemEntityGetLinks(OrderItemEntity object) {
  return [];
}

void _orderItemEntityAttach(
    IsarCollection<dynamic> col, Id id, OrderItemEntity object) {
  object.id = id;
}

extension OrderItemEntityByIndex on IsarCollection<OrderItemEntity> {
  Future<OrderItemEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  OrderItemEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<OrderItemEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<OrderItemEntity?> getAllByInternalIdSync(List<String> internalIdValues) {
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

  Future<Id> putByInternalId(OrderItemEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(OrderItemEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(List<OrderItemEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<OrderItemEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension OrderItemEntityQueryWhereSort
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QWhere> {
  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhere>
      anyGarmentTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'garmentTypeIndex'),
      );
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhere> anySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sortOrder'),
      );
    });
  }
}

extension OrderItemEntityQueryWhere
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QWhereClause> {
  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      orderInternalIdEqualTo(String orderInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderInternalId',
        value: [orderInternalId],
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      garmentTypeIndexEqualTo(int garmentTypeIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'garmentTypeIndex',
        value: [garmentTypeIndex],
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      garmentTypeIndexNotEqualTo(int garmentTypeIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'garmentTypeIndex',
              lower: [],
              upper: [garmentTypeIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'garmentTypeIndex',
              lower: [garmentTypeIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'garmentTypeIndex',
              lower: [garmentTypeIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'garmentTypeIndex',
              lower: [],
              upper: [garmentTypeIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      garmentTypeIndexGreaterThan(
    int garmentTypeIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'garmentTypeIndex',
        lower: [garmentTypeIndex],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      garmentTypeIndexLessThan(
    int garmentTypeIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'garmentTypeIndex',
        lower: [],
        upper: [garmentTypeIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      garmentTypeIndexBetween(
    int lowerGarmentTypeIndex,
    int upperGarmentTypeIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'garmentTypeIndex',
        lower: [lowerGarmentTypeIndex],
        includeLower: includeLower,
        upper: [upperGarmentTypeIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      sortOrderEqualTo(int sortOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sortOrder',
        value: [sortOrder],
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      sortOrderNotEqualTo(int sortOrder) {
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      sortOrderGreaterThan(
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      sortOrderLessThan(
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterWhereClause>
      sortOrderBetween(
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

extension OrderItemEntityQueryFilter
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QFilterCondition> {
  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogDesignNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogDesignNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogDesignNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogDesignerShopNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogDesignerShopNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogDesignerShopNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogImagePathSnapshotIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'catalogImagePathSnapshot',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogImagePathSnapshotIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'catalogImagePathSnapshot',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogImagePathSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogImagePathSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogImagePathSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogImagePathSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogItemInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'catalogItemInternalId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogItemInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'catalogItemInternalId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogItemInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogItemInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogItemInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogItemInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogItemInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogItemInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'catalogThumbnailPathSnapshot',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'catalogThumbnailPathSnapshot',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogThumbnailPathSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      catalogThumbnailPathSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogThumbnailPathSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clothMetersSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clothMetersSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clothMetersSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clothMetersSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clothMetersSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clothMetersSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clothMetersSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clothMetersSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clothMetersSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothMetersSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clothMetersSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothPriceAmountMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clothPriceAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothPriceAmountMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clothPriceAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothPriceAmountMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clothPriceAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      clothPriceAmountMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clothPriceAmountMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fabricColorPresetInternalId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fabricColorPresetInternalId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricColorPresetInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricColorPresetInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricColorPresetInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricColorSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fabricColorSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricColorSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fabricColorSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricColorSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricColorSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricColorSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricColorSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricIdSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fabricIdSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricIdSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fabricIdSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricIdSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricIdSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricIdSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricIdSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fabricNamePresetInternalId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fabricNamePresetInternalId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricNamePresetInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricNamePresetInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricNamePresetInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricNameSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fabricNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricNameSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fabricNameSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      fabricNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fabricNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      garmentTypeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'garmentTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      garmentTypeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'garmentTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      garmentTypeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'garmentTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      garmentTypeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'garmentTypeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      internalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'internalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      internalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'internalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemNotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemNotes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemNotes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      itemNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemNotes',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      measurementsSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'measurementsSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      measurementsSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'measurementsSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      measurementsSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'measurementsSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      measurementsSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'measurementsSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      orderInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orderInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      orderInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orderInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      orderInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      orderInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      priceAmountMinorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priceAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      priceAmountMinorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priceAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      priceAmountMinorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priceAmountMinor',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      priceAmountMinorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priceAmountMinor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      shopIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      shopIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sortOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sortOrderGreaterThan(
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sortOrderLessThan(
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sortOrderBetween(
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceMeasurementProfileId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceMeasurementProfileId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceMeasurementProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sourceMeasurementProfileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceMeasurementProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceMeasurementProfileLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      sourceMeasurementProfileLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceMeasurementProfileLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleName',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleName',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameInternalIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'styleNameInternalId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameInternalIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'styleNameInternalId',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleNameInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleNameInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleNameInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleNameInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleNameInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleSelectionJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleSelectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleSelectionJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleSelectionJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleSelectionJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleSelectionJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleSelectionJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleSelectionJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleSummaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleSummaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleSummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      styleSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterFilterCondition>
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

extension OrderItemEntityQueryObject
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QFilterCondition> {}

extension OrderItemEntityQueryLinks
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QFilterCondition> {}

extension OrderItemEntityQuerySortBy
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QSortBy> {
  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogDesignNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogDesignNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogDesignerShopNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignerShopNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogDesignerShopNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignerShopNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogImagePathSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogImagePathSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogImagePathSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogImagePathSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogItemInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogItemInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogItemInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogItemInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogThumbnailPathSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogThumbnailPathSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCatalogThumbnailPathSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogThumbnailPathSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByClothMetersSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clothMetersSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByClothMetersSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clothMetersSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByClothPriceAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clothPriceAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByClothPriceAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clothPriceAmountMinor', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricColorPresetInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorPresetInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricColorPresetInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorPresetInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricColorSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricColorSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricIdSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricIdSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricIdSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricIdSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricNamePresetInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNamePresetInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricNamePresetInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNamePresetInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByFabricNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByGarmentTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentTypeIndex', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByGarmentTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentTypeIndex', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByItemNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNotes', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByItemNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNotes', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByMeasurementsSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByMeasurementsSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByOrderInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByOrderInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByPriceAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByPriceAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceAmountMinor', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortBySourceMeasurementProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortBySourceMeasurementProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortBySourceMeasurementProfileLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileLabel', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortBySourceMeasurementProfileLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileLabel', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByStyleName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleName', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByStyleNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleName', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByStyleNameInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByStyleNameInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByStyleSelectionJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSelectionJson', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByStyleSelectionJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSelectionJson', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByStyleSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSummary', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByStyleSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSummary', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OrderItemEntityQuerySortThenBy
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QSortThenBy> {
  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogDesignNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogDesignNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogDesignerShopNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignerShopNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogDesignerShopNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogDesignerShopNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogImagePathSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogImagePathSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogImagePathSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogImagePathSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogItemInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogItemInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogItemInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogItemInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogThumbnailPathSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogThumbnailPathSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCatalogThumbnailPathSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogThumbnailPathSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByClothMetersSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clothMetersSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByClothMetersSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clothMetersSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByClothPriceAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clothPriceAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByClothPriceAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clothPriceAmountMinor', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricColorPresetInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorPresetInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricColorPresetInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorPresetInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricColorSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricColorSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricColorSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricIdSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricIdSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricIdSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricIdSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricNamePresetInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNamePresetInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricNamePresetInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNamePresetInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByFabricNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByGarmentTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentTypeIndex', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByGarmentTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentTypeIndex', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByItemNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNotes', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByItemNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNotes', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByMeasurementsSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByMeasurementsSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'measurementsSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByOrderInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByOrderInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByPriceAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceAmountMinor', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByPriceAmountMinorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priceAmountMinor', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenBySourceMeasurementProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenBySourceMeasurementProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenBySourceMeasurementProfileLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileLabel', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenBySourceMeasurementProfileLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceMeasurementProfileLabel', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByStyleName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleName', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByStyleNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleName', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByStyleNameInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByStyleNameInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleNameInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByStyleSelectionJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSelectionJson', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByStyleSelectionJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSelectionJson', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByStyleSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSummary', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByStyleSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleSummary', Sort.desc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OrderItemEntityQueryWhereDistinct
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct> {
  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByCatalogDesignNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogDesignNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByCatalogDesignerShopNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogDesignerShopNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByCatalogImagePathSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogImagePathSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByCatalogItemInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogItemInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByCatalogThumbnailPathSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogThumbnailPathSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByClothMetersSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clothMetersSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByClothPriceAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clothPriceAmountMinor');
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByFabricColorPresetInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricColorPresetInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByFabricColorSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricColorSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByFabricIdSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricIdSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByFabricNamePresetInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricNamePresetInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByFabricNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByGarmentTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'garmentTypeIndex');
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct> distinctByItemNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemNotes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByMeasurementsSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'measurementsSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByOrderInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByPriceAmountMinor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priceAmountMinor');
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct> distinctByShopId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctBySourceMeasurementProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceMeasurementProfileId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctBySourceMeasurementProfileLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceMeasurementProfileLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct> distinctByStyleName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByStyleNameInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleNameInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByStyleSelectionJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleSelectionJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByStyleSummary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleSummary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItemEntity, OrderItemEntity, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension OrderItemEntityQueryProperty
    on QueryBuilder<OrderItemEntity, OrderItemEntity, QQueryProperty> {
  QueryBuilder<OrderItemEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      catalogDesignNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogDesignNameSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      catalogDesignerShopNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogDesignerShopNameSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, String?, QQueryOperations>
      catalogImagePathSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogImagePathSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, String?, QQueryOperations>
      catalogItemInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogItemInternalId');
    });
  }

  QueryBuilder<OrderItemEntity, String?, QQueryOperations>
      catalogThumbnailPathSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogThumbnailPathSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      clothMetersSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clothMetersSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, int, QQueryOperations>
      clothPriceAmountMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clothPriceAmountMinor');
    });
  }

  QueryBuilder<OrderItemEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OrderItemEntity, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<OrderItemEntity, String?, QQueryOperations>
      fabricColorPresetInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricColorPresetInternalId');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      fabricColorSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricColorSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      fabricIdSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricIdSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, String?, QQueryOperations>
      fabricNamePresetInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricNamePresetInternalId');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      fabricNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricNameSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, int, QQueryOperations>
      garmentTypeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'garmentTypeIndex');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations> internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations> itemNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemNotes');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      measurementsSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'measurementsSnapshot');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      orderInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderInternalId');
    });
  }

  QueryBuilder<OrderItemEntity, int, QQueryOperations>
      priceAmountMinorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priceAmountMinor');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations> shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<OrderItemEntity, int, QQueryOperations> sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<OrderItemEntity, String?, QQueryOperations>
      sourceMeasurementProfileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceMeasurementProfileId');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      sourceMeasurementProfileLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceMeasurementProfileLabel');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations> styleNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleName');
    });
  }

  QueryBuilder<OrderItemEntity, String?, QQueryOperations>
      styleNameInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleNameInternalId');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      styleSelectionJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleSelectionJson');
    });
  }

  QueryBuilder<OrderItemEntity, String, QQueryOperations>
      styleSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleSummary');
    });
  }

  QueryBuilder<OrderItemEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
