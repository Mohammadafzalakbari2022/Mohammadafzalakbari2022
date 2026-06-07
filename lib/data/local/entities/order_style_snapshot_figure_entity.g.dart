// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_style_snapshot_figure_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderStyleSnapshotFigureEntityCollection on Isar {
  IsarCollection<OrderStyleSnapshotFigureEntity>
      get orderStyleSnapshotFigureEntitys => this.collection();
}

const OrderStyleSnapshotFigureEntitySchema = CollectionSchema(
  name: r'OrderStyleSnapshotFigureEntity',
  id: 5376450166241392082,
  properties: {
    r'figureNameSnapshot': PropertySchema(
      id: 0,
      name: r'figureNameSnapshot',
      type: IsarType.string,
    ),
    r'imageRefSnapshot': PropertySchema(
      id: 1,
      name: r'imageRefSnapshot',
      type: IsarType.string,
    ),
    r'noteSnapshot': PropertySchema(
      id: 2,
      name: r'noteSnapshot',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 3,
      name: r'shopId',
      type: IsarType.string,
    ),
    r'sizeOptionsSnapshotJson': PropertySchema(
      id: 4,
      name: r'sizeOptionsSnapshotJson',
      type: IsarType.string,
    ),
    r'snapshotInternalId': PropertySchema(
      id: 5,
      name: r'snapshotInternalId',
      type: IsarType.string,
    ),
    r'sortOrder': PropertySchema(
      id: 6,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'styleFigureInternalId': PropertySchema(
      id: 7,
      name: r'styleFigureInternalId',
      type: IsarType.string,
    ),
    r'textOptionsSnapshotJson': PropertySchema(
      id: 8,
      name: r'textOptionsSnapshotJson',
      type: IsarType.string,
    )
  },
  estimateSize: _orderStyleSnapshotFigureEntityEstimateSize,
  serialize: _orderStyleSnapshotFigureEntitySerialize,
  deserialize: _orderStyleSnapshotFigureEntityDeserialize,
  deserializeProp: _orderStyleSnapshotFigureEntityDeserializeProp,
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
    r'styleFigureInternalId': IndexSchema(
      id: 8992309854832135316,
      name: r'styleFigureInternalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'styleFigureInternalId',
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
  getId: _orderStyleSnapshotFigureEntityGetId,
  getLinks: _orderStyleSnapshotFigureEntityGetLinks,
  attach: _orderStyleSnapshotFigureEntityAttach,
  version: '3.1.0+1',
);

int _orderStyleSnapshotFigureEntityEstimateSize(
  OrderStyleSnapshotFigureEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.figureNameSnapshot.length * 3;
  bytesCount += 3 + object.imageRefSnapshot.length * 3;
  bytesCount += 3 + object.noteSnapshot.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  bytesCount += 3 + object.sizeOptionsSnapshotJson.length * 3;
  bytesCount += 3 + object.snapshotInternalId.length * 3;
  bytesCount += 3 + object.styleFigureInternalId.length * 3;
  bytesCount += 3 + object.textOptionsSnapshotJson.length * 3;
  return bytesCount;
}

void _orderStyleSnapshotFigureEntitySerialize(
  OrderStyleSnapshotFigureEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.figureNameSnapshot);
  writer.writeString(offsets[1], object.imageRefSnapshot);
  writer.writeString(offsets[2], object.noteSnapshot);
  writer.writeString(offsets[3], object.shopId);
  writer.writeString(offsets[4], object.sizeOptionsSnapshotJson);
  writer.writeString(offsets[5], object.snapshotInternalId);
  writer.writeLong(offsets[6], object.sortOrder);
  writer.writeString(offsets[7], object.styleFigureInternalId);
  writer.writeString(offsets[8], object.textOptionsSnapshotJson);
}

OrderStyleSnapshotFigureEntity _orderStyleSnapshotFigureEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderStyleSnapshotFigureEntity();
  object.figureNameSnapshot = reader.readString(offsets[0]);
  object.id = id;
  object.imageRefSnapshot = reader.readString(offsets[1]);
  object.noteSnapshot = reader.readString(offsets[2]);
  object.shopId = reader.readString(offsets[3]);
  object.sizeOptionsSnapshotJson = reader.readString(offsets[4]);
  object.snapshotInternalId = reader.readString(offsets[5]);
  object.sortOrder = reader.readLong(offsets[6]);
  object.styleFigureInternalId = reader.readString(offsets[7]);
  object.textOptionsSnapshotJson = reader.readString(offsets[8]);
  return object;
}

P _orderStyleSnapshotFigureEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
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

Id _orderStyleSnapshotFigureEntityGetId(OrderStyleSnapshotFigureEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderStyleSnapshotFigureEntityGetLinks(
    OrderStyleSnapshotFigureEntity object) {
  return [];
}

void _orderStyleSnapshotFigureEntityAttach(
    IsarCollection<dynamic> col, Id id, OrderStyleSnapshotFigureEntity object) {
  object.id = id;
}

extension OrderStyleSnapshotFigureEntityQueryWhereSort on QueryBuilder<
    OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity, QWhere> {
  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhere> anySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sortOrder'),
      );
    });
  }
}

extension OrderStyleSnapshotFigureEntityQueryWhere on QueryBuilder<
    OrderStyleSnapshotFigureEntity,
    OrderStyleSnapshotFigureEntity,
    QWhereClause> {
  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhereClause> snapshotInternalIdEqualTo(String snapshotInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'snapshotInternalId',
        value: [snapshotInternalId],
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterWhereClause>
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterWhereClause>
      styleFigureInternalIdEqualTo(String styleFigureInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'styleFigureInternalId',
        value: [styleFigureInternalId],
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterWhereClause>
      styleFigureInternalIdNotEqualTo(String styleFigureInternalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'styleFigureInternalId',
              lower: [],
              upper: [styleFigureInternalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'styleFigureInternalId',
              lower: [styleFigureInternalId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'styleFigureInternalId',
              lower: [styleFigureInternalId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'styleFigureInternalId',
              lower: [],
              upper: [styleFigureInternalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhereClause> sortOrderEqualTo(int sortOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sortOrder',
        value: [sortOrder],
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhereClause> sortOrderLessThan(
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterWhereClause> sortOrderBetween(
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

extension OrderStyleSnapshotFigureEntityQueryFilter on QueryBuilder<
    OrderStyleSnapshotFigureEntity,
    OrderStyleSnapshotFigureEntity,
    QFilterCondition> {
  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> figureNameSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'figureNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> figureNameSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'figureNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> figureNameSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'figureNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> figureNameSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'figureNameSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> figureNameSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'figureNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> figureNameSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'figureNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      figureNameSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'figureNameSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      figureNameSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'figureNameSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> figureNameSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'figureNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> figureNameSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'figureNameSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> imageRefSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageRefSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> imageRefSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageRefSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> imageRefSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageRefSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> imageRefSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageRefSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> imageRefSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageRefSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> imageRefSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageRefSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      imageRefSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageRefSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      imageRefSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageRefSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> imageRefSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageRefSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> imageRefSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageRefSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> noteSnapshotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> noteSnapshotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> noteSnapshotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> noteSnapshotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteSnapshot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> noteSnapshotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> noteSnapshotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      noteSnapshotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteSnapshot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      noteSnapshotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteSnapshot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> noteSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> noteSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteSnapshot',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sizeOptionsSnapshotJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sizeOptionsSnapshotJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sizeOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sizeOptionsSnapshotJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sizeOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sizeOptionsSnapshotJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sizeOptionsSnapshotJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sizeOptionsSnapshotJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sizeOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sizeOptionsSnapshotJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sizeOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      sizeOptionsSnapshotJsonContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sizeOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      sizeOptionsSnapshotJsonMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sizeOptionsSnapshotJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sizeOptionsSnapshotJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sizeOptionsSnapshotJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sizeOptionsSnapshotJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sizeOptionsSnapshotJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      snapshotInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'snapshotInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      snapshotInternalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'snapshotInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> snapshotInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> snapshotInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'snapshotInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> sortOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
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

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> styleFigureInternalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleFigureInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> styleFigureInternalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'styleFigureInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> styleFigureInternalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'styleFigureInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> styleFigureInternalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'styleFigureInternalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> styleFigureInternalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'styleFigureInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> styleFigureInternalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'styleFigureInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      styleFigureInternalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'styleFigureInternalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      styleFigureInternalIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'styleFigureInternalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> styleFigureInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleFigureInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> styleFigureInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleFigureInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> textOptionsSnapshotJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> textOptionsSnapshotJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> textOptionsSnapshotJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> textOptionsSnapshotJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textOptionsSnapshotJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> textOptionsSnapshotJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'textOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> textOptionsSnapshotJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'textOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      textOptionsSnapshotJsonContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'textOptionsSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QAfterFilterCondition>
      textOptionsSnapshotJsonMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'textOptionsSnapshotJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> textOptionsSnapshotJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textOptionsSnapshotJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterFilterCondition> textOptionsSnapshotJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'textOptionsSnapshotJson',
        value: '',
      ));
    });
  }
}

extension OrderStyleSnapshotFigureEntityQueryObject on QueryBuilder<
    OrderStyleSnapshotFigureEntity,
    OrderStyleSnapshotFigureEntity,
    QFilterCondition> {}

extension OrderStyleSnapshotFigureEntityQueryLinks on QueryBuilder<
    OrderStyleSnapshotFigureEntity,
    OrderStyleSnapshotFigureEntity,
    QFilterCondition> {}

extension OrderStyleSnapshotFigureEntityQuerySortBy on QueryBuilder<
    OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity, QSortBy> {
  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByFigureNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByFigureNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByImageRefSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageRefSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByImageRefSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageRefSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByNoteSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByNoteSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortBySizeOptionsSnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeOptionsSnapshotJson', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortBySizeOptionsSnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeOptionsSnapshotJson', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortBySnapshotInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortBySnapshotInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByStyleFigureInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleFigureInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByStyleFigureInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleFigureInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByTextOptionsSnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textOptionsSnapshotJson', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> sortByTextOptionsSnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textOptionsSnapshotJson', Sort.desc);
    });
  }
}

extension OrderStyleSnapshotFigureEntityQuerySortThenBy on QueryBuilder<
    OrderStyleSnapshotFigureEntity,
    OrderStyleSnapshotFigureEntity,
    QSortThenBy> {
  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByFigureNameSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureNameSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByFigureNameSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'figureNameSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByImageRefSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageRefSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByImageRefSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageRefSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByNoteSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteSnapshot', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByNoteSnapshotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteSnapshot', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenBySizeOptionsSnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeOptionsSnapshotJson', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenBySizeOptionsSnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeOptionsSnapshotJson', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenBySnapshotInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenBySnapshotInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByStyleFigureInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleFigureInternalId', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByStyleFigureInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleFigureInternalId', Sort.desc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByTextOptionsSnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textOptionsSnapshotJson', Sort.asc);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QAfterSortBy> thenByTextOptionsSnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textOptionsSnapshotJson', Sort.desc);
    });
  }
}

extension OrderStyleSnapshotFigureEntityQueryWhereDistinct on QueryBuilder<
    OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity, QDistinct> {
  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QDistinct> distinctByFigureNameSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'figureNameSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QDistinct> distinctByImageRefSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageRefSnapshot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QDistinct> distinctByNoteSnapshot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteSnapshot', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QDistinct> distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QDistinct>
      distinctBySizeOptionsSnapshotJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeOptionsSnapshotJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QDistinct> distinctBySnapshotInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QDistinct> distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
      QDistinct> distinctByStyleFigureInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleFigureInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, OrderStyleSnapshotFigureEntity,
          QDistinct>
      distinctByTextOptionsSnapshotJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textOptionsSnapshotJson',
          caseSensitive: caseSensitive);
    });
  }
}

extension OrderStyleSnapshotFigureEntityQueryProperty on QueryBuilder<
    OrderStyleSnapshotFigureEntity,
    OrderStyleSnapshotFigureEntity,
    QQueryProperty> {
  QueryBuilder<OrderStyleSnapshotFigureEntity, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, String, QQueryOperations>
      figureNameSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'figureNameSnapshot');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, String, QQueryOperations>
      imageRefSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageRefSnapshot');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, String, QQueryOperations>
      noteSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteSnapshot');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, String, QQueryOperations>
      sizeOptionsSnapshotJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeOptionsSnapshotJson');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, String, QQueryOperations>
      snapshotInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotInternalId');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, int, QQueryOperations>
      sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, String, QQueryOperations>
      styleFigureInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleFigureInternalId');
    });
  }

  QueryBuilder<OrderStyleSnapshotFigureEntity, String, QQueryOperations>
      textOptionsSnapshotJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textOptionsSnapshotJson');
    });
  }
}
