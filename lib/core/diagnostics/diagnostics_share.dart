import 'diagnostics_share_stub.dart'
    if (dart.library.html) 'diagnostics_share_web.dart'
    if (dart.library.io) 'diagnostics_share_io.dart' as impl;

/// Shares a JSON diagnostics bundle (file on IO, text sheet on web).
Future<void> shareDiagnosticsBundle(String json, String filename) =>
    impl.shareDiagnosticsBundle(json, filename);
