# shared_preferences legacy Pigeon API (flutter/flutter#153075).
# Without these, R8 can strip LegacySharedPreferencesPlugin in release APKs.
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.sharedpreferences.LegacySharedPreferencesPlugin { *; }
-keep class io.flutter.plugins.sharedpreferences.Messages { *; }
-keep class io.flutter.plugins.sharedpreferences.Messages$* { *; }

# Flutter embedding + generated registrant.
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class io.flutter.embedding.** { *; }

# Isar (JNI / native bindings).
-keep class isar.** { *; }
-keep class dev.isar.** { *; }
-dontwarn isar.**

# Sentry.
-keep class io.sentry.** { *; }
-dontwarn io.sentry.**

# path_provider / plugin channels.
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep generic signatures used by Flutter plugins.
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes *Annotation*

# Flutter deferred components / Play Core (optional; not shipped in this APK).
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
