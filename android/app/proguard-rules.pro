# shared_preferences legacy Pigeon API (flutter/flutter#153075).
# Without these, R8 can strip LegacySharedPreferencesPlugin in release APKs.
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.sharedpreferences.LegacySharedPreferencesPlugin { *; }
-keep class io.flutter.plugins.sharedpreferences.Messages { *; }
-keep class io.flutter.plugins.sharedpreferences.Messages$* { *; }

# Flutter embedding + generated registrant.
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class io.flutter.embedding.** { *; }
