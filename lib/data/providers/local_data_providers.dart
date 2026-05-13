// Local persistence: Web → memory only (Isar .g.dart uses int64 IDs invalid in JS).
// Android / iOS / desktop → Isar via local_data_providers_io.dart.
export 'local_data_providers_web.dart'
    if (dart.library.io) 'local_data_providers_io.dart';
