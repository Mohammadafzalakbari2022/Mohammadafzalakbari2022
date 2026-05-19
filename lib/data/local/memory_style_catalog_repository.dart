import 'dart:async';

import 'package:uuid/uuid.dart';

import 'seed_data.dart';
import 'style/style_figure_image_ref.dart';
import 'style_catalog_repository.dart';
import 'style_figure_summary.dart';
import 'style_name_summary.dart';
import 'style_part_summary.dart';
import 'sync_pull_payload.dart';

class MemoryStyleCatalogRepository implements StyleCatalogRepository {
  final List<StyleNameSummary> _names = [];
  final List<StylePartSummary> _parts = [];
  final List<StyleFigureSummary> _figures = [];
  final _namesCtrl = StreamController<List<StyleNameSummary>>.broadcast();
  final _partsCtrl = StreamController<List<StylePartSummary>>.broadcast();
  final _figuresCtrl = StreamController<List<StyleFigureSummary>>.broadcast();
  final _uuid = const Uuid();

  void _emitNames() => _namesCtrl.add(List.unmodifiable(_names));
  void _emitParts() => _partsCtrl.add(List.unmodifiable(_parts));
  void _emitFigures() => _figuresCtrl.add(List.unmodifiable(_figures));

  @override
  Future<void> seedIfEmpty(String shopId) async {
    final hasNames = _names.any((n) => n.shopId == shopId);
    if (hasNames) {
      _ensureParts(shopId);
      _ensureBundledFigures(shopId);
      return;
    }
    final names = [
      (DevSeedIds.styleNameQasimi, 'Qasimi', 10),
      (DevSeedIds.styleNameKandahari, 'Kandahari', 20),
      (DevSeedIds.styleNameArabi, 'Arabi', 30),
      (DevSeedIds.styleNameClassic, 'Classic', 40),
      (DevSeedIds.styleNameModern, 'Modern', 50),
    ];
    for (final n in names) {
      _names.add(
        StyleNameSummary(
          internalId: n.$1,
          shopId: shopId,
          name: n.$2,
          sortOrder: n.$3,
          isActive: true,
        ),
      );
    }
    final parts = [
      (DevSeedIds.stylePartSleeve, 'Sleeve', 10),
      (DevSeedIds.stylePartCollar, 'Collar', 20),
      (DevSeedIds.stylePartPocket, 'Pocket', 30),
      (DevSeedIds.stylePartCuff, 'Cuff', 40),
      (DevSeedIds.stylePartNeck, 'Neck', 50),
      (DevSeedIds.stylePartFront, 'Front', 60),
      (DevSeedIds.stylePartBottom, 'Bottom', 70),
    ];
    for (final p in parts) {
      _parts.add(
        StylePartSummary(
          internalId: p.$1,
          shopId: shopId,
          name: p.$2,
          sortOrder: p.$3,
          isActive: true,
        ),
      );
    }
    final partIds = [
      DevSeedIds.stylePartSleeve,
      DevSeedIds.stylePartSleeve,
      DevSeedIds.stylePartSleeve,
      DevSeedIds.stylePartCollar,
      DevSeedIds.stylePartCollar,
      DevSeedIds.stylePartPocket,
      DevSeedIds.stylePartPocket,
      DevSeedIds.stylePartCuff,
      DevSeedIds.stylePartCuff,
      DevSeedIds.stylePartNeck,
      DevSeedIds.stylePartNeck,
      DevSeedIds.stylePartFront,
      DevSeedIds.stylePartFront,
      DevSeedIds.stylePartBottom,
      DevSeedIds.stylePartBottom,
    ];
    final figureIds = [
      DevSeedIds.styleFigure1,
      DevSeedIds.styleFigure2,
      DevSeedIds.styleFigure3,
      DevSeedIds.styleFigure4,
      DevSeedIds.styleFigure5,
      DevSeedIds.styleFigure6,
      DevSeedIds.styleFigure7,
      DevSeedIds.styleFigure8,
      DevSeedIds.styleFigure9,
      DevSeedIds.styleFigure10,
      DevSeedIds.styleFigure11,
      DevSeedIds.styleFigure12,
      DevSeedIds.styleFigure13,
      DevSeedIds.styleFigure14,
      DevSeedIds.styleFigure15,
    ];
    for (var i = 0; i < 15; i++) {
      _figures.add(
        StyleFigureSummary(
          internalId: figureIds[i],
          shopId: shopId,
          partInternalId: partIds[i],
          name: '',
          imageRef: StyleFigureImageRef.bundledAssetKey(i + 1),
          sortOrder: (i + 1) * 10,
          isActive: true,
        ),
      );
    }
    _emitNames();
    _emitParts();
    _emitFigures();
  }

  void _ensureParts(String shopId) {
    if (_parts.any((p) => p.shopId == shopId)) return;
    final parts = [
      (DevSeedIds.stylePartSleeve, 'Sleeve', 10),
      (DevSeedIds.stylePartCollar, 'Collar', 20),
      (DevSeedIds.stylePartPocket, 'Pocket', 30),
      (DevSeedIds.stylePartCuff, 'Cuff', 40),
      (DevSeedIds.stylePartNeck, 'Neck', 50),
      (DevSeedIds.stylePartFront, 'Front', 60),
      (DevSeedIds.stylePartBottom, 'Bottom', 70),
    ];
    for (final p in parts) {
      _parts.add(
        StylePartSummary(
          internalId: p.$1,
          shopId: shopId,
          name: p.$2,
          sortOrder: p.$3,
          isActive: true,
        ),
      );
    }
    _emitParts();
  }

  void _ensureBundledFigures(String shopId) {
    final partIds = [
      DevSeedIds.stylePartSleeve,
      DevSeedIds.stylePartSleeve,
      DevSeedIds.stylePartSleeve,
      DevSeedIds.stylePartCollar,
      DevSeedIds.stylePartCollar,
      DevSeedIds.stylePartPocket,
      DevSeedIds.stylePartPocket,
      DevSeedIds.stylePartCuff,
      DevSeedIds.stylePartCuff,
      DevSeedIds.stylePartNeck,
      DevSeedIds.stylePartNeck,
      DevSeedIds.stylePartFront,
      DevSeedIds.stylePartFront,
      DevSeedIds.stylePartBottom,
      DevSeedIds.stylePartBottom,
    ];
    final figureIds = [
      DevSeedIds.styleFigure1,
      DevSeedIds.styleFigure2,
      DevSeedIds.styleFigure3,
      DevSeedIds.styleFigure4,
      DevSeedIds.styleFigure5,
      DevSeedIds.styleFigure6,
      DevSeedIds.styleFigure7,
      DevSeedIds.styleFigure8,
      DevSeedIds.styleFigure9,
      DevSeedIds.styleFigure10,
      DevSeedIds.styleFigure11,
      DevSeedIds.styleFigure12,
      DevSeedIds.styleFigure13,
      DevSeedIds.styleFigure14,
      DevSeedIds.styleFigure15,
    ];
    var added = false;
    for (var i = 0; i < 15; i++) {
      if (_figures.any(
        (f) => f.internalId == figureIds[i] && f.shopId == shopId,
      )) {
        continue;
      }
      _figures.add(
        StyleFigureSummary(
          internalId: figureIds[i],
          shopId: shopId,
          partInternalId: partIds[i],
          name: '',
          imageRef: StyleFigureImageRef.bundledAssetKey(i + 1),
          sortOrder: (i + 1) * 10,
          isActive: true,
        ),
      );
      added = true;
    }
    if (added) _emitFigures();
  }

  List<StyleNameSummary> _namesFor(String shopId) =>
      _names.where((e) => e.shopId == shopId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<StylePartSummary> _partsFor(String shopId) =>
      _parts.where((e) => e.shopId == shopId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<StyleFigureSummary> _figuresFor(String shopId, {String? partId}) {
    var list = _figures.where((e) => e.shopId == shopId);
    if (partId != null) {
      list = list.where((e) => e.partInternalId == partId);
    }
    return list.toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Stream<List<StyleNameSummary>> watchStyleNames(String shopId) async* {
    await seedIfEmpty(shopId);
    yield _namesFor(shopId);
    yield* _namesCtrl.stream.map((_) => _namesFor(shopId));
  }

  @override
  Stream<List<StylePartSummary>> watchStyleParts(String shopId) async* {
    await seedIfEmpty(shopId);
    yield _partsFor(shopId);
    yield* _partsCtrl.stream.map((_) => _partsFor(shopId));
  }

  @override
  Stream<List<StyleFigureSummary>> watchFiguresForPart(
    String shopId,
    String partInternalId,
  ) async* {
    await seedIfEmpty(shopId);
    yield _figuresFor(shopId, partId: partInternalId);
    yield* _figuresCtrl.stream
        .map((_) => _figuresFor(shopId, partId: partInternalId));
  }

  @override
  Stream<List<StyleFigureSummary>> watchAllFigures(String shopId) async* {
    await seedIfEmpty(shopId);
    yield _figuresFor(shopId);
    yield* _figuresCtrl.stream.map((_) => _figuresFor(shopId));
  }

  int _maxOrder<T>(Iterable<T> items, int Function(T) order) {
    var max = 0;
    for (final e in items) {
      final o = order(e);
      if (o > max) max = o;
    }
    return max + 10;
  }

  @override
  Future<String> createStyleName({
    required String shopId,
    required String name,
    int? sortOrder,
  }) async {
    final id = _uuid.v4();
    _names.add(
      StyleNameSummary(
        internalId: id,
        shopId: shopId,
        name: name.trim(),
        sortOrder: sortOrder ?? _maxOrder(_namesFor(shopId), (e) => e.sortOrder),
        isActive: true,
      ),
    );
    _emitNames();
    return id;
  }

  @override
  Future<void> updateStyleName({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  }) async {
    final i = _names.indexWhere((e) => e.internalId == internalId);
    if (i < 0) return;
    final old = _names[i];
    _names[i] = StyleNameSummary(
      internalId: old.internalId,
      shopId: old.shopId,
      name: name.trim().isNotEmpty ? name.trim() : old.name,
      sortOrder: sortOrder ?? old.sortOrder,
      isActive: isActive ?? old.isActive,
    );
    _emitNames();
  }

  @override
  Future<void> softDeleteStyleName(String internalId) async {
    _names.removeWhere((e) => e.internalId == internalId);
    _emitNames();
  }

  @override
  Future<String> createStylePart({
    required String shopId,
    required String name,
    int? sortOrder,
  }) async {
    final id = _uuid.v4();
    _parts.add(
      StylePartSummary(
        internalId: id,
        shopId: shopId,
        name: name.trim(),
        sortOrder: sortOrder ?? _maxOrder(_partsFor(shopId), (e) => e.sortOrder),
        isActive: true,
      ),
    );
    _emitParts();
    return id;
  }

  @override
  Future<void> updateStylePart({
    required String internalId,
    required String name,
    int? sortOrder,
    bool? isActive,
  }) async {
    final i = _parts.indexWhere((e) => e.internalId == internalId);
    if (i < 0) return;
    final old = _parts[i];
    _parts[i] = StylePartSummary(
      internalId: old.internalId,
      shopId: old.shopId,
      name: name.trim().isNotEmpty ? name.trim() : old.name,
      sortOrder: sortOrder ?? old.sortOrder,
      isActive: isActive ?? old.isActive,
    );
    _emitParts();
  }

  @override
  Future<void> softDeleteStylePart(String internalId) async {
    _parts.removeWhere((e) => e.internalId == internalId);
    _figures.removeWhere((e) => e.partInternalId == internalId);
    _emitParts();
    _emitFigures();
  }

  @override
  Future<String> createStyleFigure({
    required String shopId,
    required String partInternalId,
    required String name,
    required String imageRef,
    int? sortOrder,
  }) async {
    final id = _uuid.v4();
    _figures.add(
      StyleFigureSummary(
        internalId: id,
        shopId: shopId,
        partInternalId: partInternalId,
        name: name.trim(),
        imageRef: imageRef.trim(),
        sortOrder: sortOrder ??
            _maxOrder(
              _figuresFor(shopId, partId: partInternalId),
              (e) => e.sortOrder,
            ),
        isActive: true,
      ),
    );
    _emitFigures();
    return id;
  }

  @override
  Future<void> updateStyleFigure({
    required String internalId,
    String? name,
    String? imageRef,
    int? sortOrder,
    bool? isActive,
  }) async {
    final i = _figures.indexWhere((e) => e.internalId == internalId);
    if (i < 0) return;
    final old = _figures[i];
    _figures[i] = StyleFigureSummary(
      internalId: old.internalId,
      shopId: old.shopId,
      partInternalId: old.partInternalId,
      name: name?.trim().isNotEmpty == true ? name!.trim() : old.name,
      imageRef: imageRef?.trim().isNotEmpty == true ? imageRef!.trim() : old.imageRef,
      sortOrder: sortOrder ?? old.sortOrder,
      isActive: isActive ?? old.isActive,
    );
    _emitFigures();
  }

  @override
  Future<void> softDeleteStyleFigure(String internalId) async {
    _figures.removeWhere((e) => e.internalId == internalId);
    _emitFigures();
  }

  @override
  Future<void> mergeRemoteStyleName({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteStyleName(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null) return;
    final i = _names.indexWhere((e) => e.internalId == internalId);
    if (i < 0) {
      await createStyleName(shopId: shopId, name: name);
    } else {
      await updateStyleName(internalId: internalId, name: name);
    }
  }

  @override
  Future<void> mergeRemoteStylePart({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteStylePart(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null) return;
    final i = _parts.indexWhere((e) => e.internalId == internalId);
    if (i < 0) {
      await createStylePart(shopId: shopId, name: name);
    } else {
      await updateStylePart(internalId: internalId, name: name);
    }
  }

  @override
  Future<void> mergeRemoteStyleFigure({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteStyleFigure(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    final partId = syncPullString(
      m,
      const ['part_internal_id', 'partInternalId'],
    );
    final imageRef = syncPullString(m, const ['image_ref', 'imageRef']);
    if (name == null || partId == null || imageRef == null) return;
    final i = _figures.indexWhere((e) => e.internalId == internalId);
    if (i < 0) {
      await createStyleFigure(
        shopId: shopId,
        partInternalId: partId,
        name: name,
        imageRef: imageRef,
      );
    } else {
      await updateStyleFigure(
        internalId: internalId,
        name: name,
        imageRef: imageRef,
      );
    }
  }
}
