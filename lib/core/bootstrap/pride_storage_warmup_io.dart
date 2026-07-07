import '../crash/pride_error_collector.dart';
import '../persistence/pride_path_provider_io.dart';

/// Resolves Android/iOS document + cache dirs during cold start so Isar and
/// file features do not hit pigeon channel errors on first navigation.
Future<void> warmPrideLocalStoragePaths() async {
  try {
    await prideApplicationDocumentsDirectory();
    await prideTemporaryDirectory();
  } catch (error, stack) {
    await PrideErrorCollector.record(
      error,
      stack: stack,
      source: 'startup',
      context: 'warmPrideLocalStoragePaths',
      fatal: true,
    );
    rethrow;
  }
}
