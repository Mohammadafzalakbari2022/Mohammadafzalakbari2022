import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../core/api/pride_api_config.dart';
import '../../data/local/catalog_repository.dart';

const _chunkSize = 48 * 1024;

/// P2P catalog image transfer via API signaling (`plan-14`). Images never touch the server.
class CatalogP2pService {
  CatalogP2pService({
    required this.accessToken,
    required this.myShopId,
  });

  final String accessToken;
  final String myShopId;
  final _uuid = const Uuid();

  String? get _base => PrideApiConfig.normalizedBase;

  Future<void> _sendSignal({
    required String toShopId,
    required String sessionId,
    required String payloadType,
    required Map<String, dynamic> payload,
  }) async {
    final base = _base;
    if (base == null) return;
    await http.post(
      Uri.parse('$base/p2p/signal'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'to_shop_id': toShopId,
        'session_id': sessionId,
        'payload_type': payloadType,
        'payload': payload,
      }),
    );
  }

  Future<List<Map<String, dynamic>>> _pollInbox({String? sessionId}) async {
    final base = _base;
    if (base == null) return const [];
    final uri = Uri.parse('$base/p2p/inbox').replace(
      queryParameters: sessionId == null || sessionId.isEmpty
          ? null
          : {'session_id': sessionId},
    );
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 200) return const [];
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) return const [];
    final raw = decoded['messages'];
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList();
  }

  /// Receiver: request a shared design image from [senderShopId].
  Future<Uint8List?> downloadSharedDesign({
    required String senderShopId,
    required String catalogInternalId,
    void Function(int received, int total)? onProgress,
    Duration timeout = const Duration(minutes: 2),
  }) async {
    final sessionId = _uuid.v4();
    await _sendSignal(
      toShopId: senderShopId,
      sessionId: sessionId,
      payloadType: 'download_request',
      payload: {
        'catalog_internal_id': catalogInternalId,
        'requester_shop_id': myShopId,
      },
    );

    final chunks = <int, Uint8List>{};
    var expectedTotal = 0;
    final deadline = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(deadline)) {
      final inbox = await _pollInbox(sessionId: sessionId);
      for (final m in inbox) {
        if (m['payload_type'] != 'image_chunk') continue;
        final payload = m['payload'];
        if (payload is! Map<String, dynamic>) continue;
        final index = payload['index'];
        final total = payload['total'];
        final b64 = payload['data_base64'];
        if (index is! num || total is! num || b64 is! String) continue;
        expectedTotal = total.toInt();
        chunks[index.toInt()] = Uint8List.fromList(base64Decode(b64));
        onProgress?.call(chunks.length, expectedTotal);
        if (expectedTotal > 0 && _chunksComplete(chunks, expectedTotal)) {
          return _assembleChunks(chunks, expectedTotal);
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 600));
    }
    return null;
  }

  /// Sender: answer pending download requests in our inbox.
  Future<int> servePendingDownloadRequests(CatalogRepository catalog) async {
    final inbox = await _pollInbox();
    var served = 0;
    for (final m in inbox) {
      if (m['payload_type'] != 'download_request') continue;
      final sessionId = m['session_id'];
      final payload = m['payload'];
      if (sessionId is! String || payload is! Map<String, dynamic>) continue;
      final catalogId = payload['catalog_internal_id'];
      final requester = payload['requester_shop_id'];
      if (catalogId is! String || requester is! String) continue;
      if (catalogId.isEmpty || requester.isEmpty) continue;

      final detail = await catalog.watchItem(catalogId).first;
      if (detail == null) continue;
      final path = detail.imagePath;
      if (path == null || path.isEmpty) continue;
      final file = File(path);
      if (!file.existsSync()) continue;

      final bytes = await file.readAsBytes();
      final total = (bytes.length / _chunkSize).ceil();
      for (var i = 0; i < total; i++) {
        final start = i * _chunkSize;
        final end = (start + _chunkSize).clamp(0, bytes.length);
        await _sendSignal(
          toShopId: requester,
          sessionId: sessionId,
          payloadType: 'image_chunk',
          payload: {
            'index': i,
            'total': total,
            'data_base64': base64Encode(bytes.sublist(start, end)),
          },
        );
      }
      served++;
    }
    return served;
  }

  bool _chunksComplete(Map<int, Uint8List> chunks, int total) {
    if (chunks.length < total) return false;
    for (var i = 0; i < total; i++) {
      if (!chunks.containsKey(i)) return false;
    }
    return true;
  }

  Uint8List _assembleChunks(Map<int, Uint8List> chunks, int total) {
    final builder = BytesBuilder(copy: false);
    for (var i = 0; i < total; i++) {
      builder.add(chunks[i]!);
    }
    return builder.toBytes();
  }
}
