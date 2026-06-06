// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'style_figure_size_option_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStyleFigureSizeOptionEntityCollection on Isar {
  IsarCollection<StyleFigureSizeOptionEntity>
      get styleFigureSizeOptionEntitys => this.collection();
}

const StyleFigureSizeOptionEntitySchema = CollectionSchema(
  name: r'StyleFigureSizeOptionEntity',
  id: 8054311865634006550,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 1,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'internalId': PropertySchema(
      id: 2,
      name: r'internalId',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 3,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'label': PropertySchema(
      id: 4,
      name: r'label',
      type: IsarType.string,
    ),
    r'shopId': PropertySchema(
      id: 5,
      name: r'shopId',
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
    r'unitCode': PropertySchema(
      id: 8,
      name: r'unitCode',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'valueInches': PropertySchema(
      id: 10,
      name: r'valueInches',
      type: IsarType.double,
    )
  },
  estimateSize: _styleFigureSizeOptionEntityEstimateSize,
  serialize: _styleFigureSizeOptionEntitySerialize,
  deserialize: _styleFigureSizeOptionEntityDeserialize,
  deserializeProp: _styleFigureSizeOptionEntityDeserializeProp,
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
    ),
    r'isActive': IndexSchema(
      id: 8092228061260947457,
      name: r'isActive',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isActive',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _styleFigureSizeOptionEntityGetId,
  getLinks: _styleFigureSizeOptionEntityGetLinks,
  attach: _styleFigureSizeOptionEntityAttach,
  version: '3.1.0+1',
);

int _styleFigureSizeOptionEntityEstimateSize(
  StyleFigureSizeOptionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.internalId.length * 3;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.shopId.length * 3;
  bytesCount += 3 + object.styleFigureInternalId.length * 3;
  return bytesCount;
}

void _styleFigureSizeOptionEntitySerialize(
  StyleFigureSizeOptionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.deletedAt);
  writer.writeString(offsets[2], object.internalId);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeString(offsets[4], object.label);
  writer.writeString(offsets[5], object.shopId);
  writer.writeLong(offsets[6], object.sortOrder);
  writer.writeString(offsets[7], object.styleFigureInternalId);
  writer.writeLong(offsets[8], object.unitCode);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeDouble(offsets[10], object.valueInches);
}

StyleFigureSizeOptionEntity _styleFigureSizeOptionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StyleFigureSizeOptionEntity();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.internalId = reader.readString(offsets[2]);
  object.isActive = reader.readBool(offsets[3]);
  object.label = reader.readString(offsets[4]);
  object.shopId = reader.readString(offsets[5]);
  object.sortOrder = reader.readLong(offsets[6]);
  object.styleFigureInternalId = reader.readString(offsets[7]);
  object.unitCode = reader.readLong(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.valueInches = reader.readDouble(offsets[10]);
  return object;
}

P _styleFigureSizeOptionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _styleFigureSizeOptionEntityGetId(StyleFigureSizeOptionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _styleFigureSizeOptionEntityGetLinks(
    StyleFigureSizeOptionEntity object) {
  return [];
}

void _styleFigureSizeOptionEntityAttach(
    IsarCollection<dynamic> col, Id id, StyleFigureSizeOptionEntity object) {
  object.id = id;
}

extension StyleFigureSizeOptionEntityByIndex
    on IsarCollection<StyleFigureSizeOptionEntity> {
  Future<StyleFigureSizeOptionEntity?> getByInternalId(String internalId) {
    return getByIndex(r'internalId', [internalId]);
  }

  StyleFigureSizeOptionEntity? getByInternalIdSync(String internalId) {
    return getByIndexSync(r'internalId', [internalId]);
  }

  Future<bool> deleteByInternalId(String internalId) {
    return deleteByIndex(r'internalId', [internalId]);
  }

  bool deleteByInternalIdSync(String internalId) {
    return deleteByIndexSync(r'internalId', [internalId]);
  }

  Future<List<StyleFigureSizeOptionEntity?>> getAllByInternalId(
      List<String> internalIdValues) {
    final values = internalIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'internalId', values);
  }

  List<StyleFigureSizeOptionEntity?> getAllByInternalIdSync(
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

  Future<Id> putByInternalId(StyleFigureSizeOptionEntity object) {
    return putByIndex(r'internalId', object);
  }

  Id putByInternalIdSync(StyleFigureSizeOptionEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'internalId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInternalId(
      List<StyleFigureSizeOptionEntity> objects) {
    return putAllByIndex(r'internalId', objects);
  }

  List<Id> putAllByInternalIdSync(List<StyleFigureSizeOptionEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'internalId', objects, saveLinks: saveLinks);
  }
}

extension StyleFigureSizeOptionEntityQueryWhereSort on QueryBuilder<
    StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity, QWhere> {
  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhere> anySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sortOrder'),
      );
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhere> anyIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isActive'),
      );
    });
  }
}

extension StyleFigureSizeOptionEntityQueryWhere on QueryBuilder<
    StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity, QWhereClause> {
  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhereClause> internalIdEqualTo(String internalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'internalId',
        value: [internalId],
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhereClause> shopIdEqualTo(String shopId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'shopId',
        value: [shopId],
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
          QAfterWhereClause>
      styleFigureInternalIdEqualTo(String styleFigureInternalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'styleFigureInternalId',
        value: [styleFigureInternalId],
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhereClause> sortOrderEqualTo(int sortOrder) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sortOrder',
        value: [sortOrder],
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhereClause> isActiveEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isActive',
        value: [isActive],
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterWhereClause> isActiveNotEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [],
              upper: [isActive],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [isActive],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [isActive],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isActive',
              lower: [],
              upper: [isActive],
              includeUpper: false,
            ));
      }
    });
  }
}

extension StyleFigureSizeOptionEntityQueryFilter on QueryBuilder<
    StyleFigureSizeOptionEntity,
    StyleFigureSizeOptionEntity,
    QFilterCondition> {
  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> deletedAtGreaterThan(
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> deletedAtLessThan(
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> deletedAtBetween(
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> internalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> internalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'internalId',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> labelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'label',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> labelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> labelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
          QAfterFilterCondition>
      labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'label',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
          QAfterFilterCondition>
      labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'label',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'label',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> shopIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> shopIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopId',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> sortOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> styleFigureInternalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'styleFigureInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> styleFigureInternalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'styleFigureInternalId',
        value: '',
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> unitCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitCode',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> valueInchesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valueInches',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> valueInchesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valueInches',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> valueInchesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valueInches',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterFilterCondition> valueInchesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valueInches',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension StyleFigureSizeOptionEntityQueryObject on QueryBuilder<
    StyleFigureSizeOptionEntity,
    StyleFigureSizeOptionEntity,
    QFilterCondition> {}

extension StyleFigureSizeOptionEntityQueryLinks on QueryBuilder<
    StyleFigureSizeOptionEntity,
    StyleFigureSizeOptionEntity,
    QFilterCondition> {}

extension StyleFigureSizeOptionEntityQuerySortBy on QueryBuilder<
    StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity, QSortBy> {
  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByStyleFigureInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleFigureInternalId', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByStyleFigureInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleFigureInternalId', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByUnitCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByValueInches() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valueInches', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> sortByValueInchesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valueInches', Sort.desc);
    });
  }
}

extension StyleFigureSizeOptionEntityQuerySortThenBy on QueryBuilder<
    StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity, QSortThenBy> {
  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'internalId', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByShopId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByShopIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopId', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByStyleFigureInternalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleFigureInternalId', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByStyleFigureInternalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'styleFigureInternalId', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByUnitCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitCode', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByValueInches() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valueInches', Sort.asc);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QAfterSortBy> thenByValueInchesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valueInches', Sort.desc);
    });
  }
}

extension StyleFigureSizeOptionEntityQueryWhereDistinct on QueryBuilder<
    StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity, QDistinct> {
  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'internalId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByShopId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByStyleFigureInternalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'styleFigureInternalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByUnitCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitCode');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity,
      QDistinct> distinctByValueInches() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valueInches');
    });
  }
}

extension StyleFigureSizeOptionEntityQueryProperty on QueryBuilder<
    StyleFigureSizeOptionEntity, StyleFigureSizeOptionEntity, QQueryProperty> {
  QueryBuilder<StyleFigureSizeOptionEntity, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, String, QQueryOperations>
      internalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'internalId');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, bool, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, String, QQueryOperations>
      labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, String, QQueryOperations>
      shopIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopId');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, int, QQueryOperations>
      sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, String, QQueryOperations>
      styleFigureInternalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'styleFigureInternalId');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, int, QQueryOperations>
      unitCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitCode');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<StyleFigureSizeOptionEntity, double, QQueryOperations>
      valueInchesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valueInches');
    });
  }
}
