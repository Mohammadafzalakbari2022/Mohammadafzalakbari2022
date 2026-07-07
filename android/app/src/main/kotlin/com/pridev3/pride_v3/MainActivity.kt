package com.pridev3.pride_v3

import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.media.ToneGenerator
import android.net.Uri
import android.util.Base64
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
import android.content.SharedPreferences
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.ObjectInputStream
import java.io.ObjectOutputStream

class MainActivity : FlutterActivity() {
    private var toneGenerator: ToneGenerator? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Register shared_preferences before other plugins — release builds can
        // otherwise miss the legacy Pigeon handler (flutter/flutter#153075).
        if (!flutterEngine.plugins.has(SharedPreferencesPlugin::class.java)) {
            flutterEngine.plugins.add(SharedPreferencesPlugin())
        }
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, "com.pridev3.pride_v3/native_prefs")
            .setMethodCallHandler { call, result ->
                val prefs = flutterSharedPreferences()
                when (call.method) {
                    "getAll" -> {
                        try {
                            result.success(readAllWithPrefix(prefs, "flutter.", null))
                        } catch (ex: Exception) {
                            result.error("native_prefs_error", ex.message, null)
                        }
                    }
                    "getAllWithParameters" -> {
                        try {
                            val prefix = call.argument<String>("prefix") ?: "flutter."
                            @Suppress("UNCHECKED_CAST")
                            val allowList = call.argument<List<String>>("allowList")
                            result.success(readAllWithPrefix(prefs, prefix, allowList))
                        } catch (ex: Exception) {
                            result.error("native_prefs_error", ex.message, null)
                        }
                    }
                    "setValue" -> {
                        try {
                            val key = call.argument<String>("key")
                            val valueType = call.argument<String>("valueType")
                            if (key.isNullOrBlank() || valueType.isNullOrBlank()) {
                                result.success(false)
                                return@setMethodCallHandler
                            }
                            val editor = prefs.edit()
                            when (valueType) {
                                "Bool" -> editor.putBoolean(key, call.argument<Boolean>("value") == true)
                                "Int" -> editor.putInt(key, call.argument<Number>("value")?.toInt() ?: 0)
                                "Double" -> editor.putString(key, DOUBLE_PREFIX + (call.argument<Number>("value")?.toDouble() ?: 0.0))
                                "String" -> editor.putString(key, call.argument<String>("value") ?: "")
                                "StringList" -> {
                                    @Suppress("UNCHECKED_CAST")
                                    val list = call.argument<List<String>>("value") ?: emptyList()
                                    editor.putString(key, encodeFlutterStringList(list))
                                }
                                else -> {
                                    result.success(false)
                                    return@setMethodCallHandler
                                }
                            }
                            result.success(editor.commit())
                        } catch (ex: Exception) {
                            result.error("native_prefs_error", ex.message, null)
                        }
                    }
                    "remove" -> {
                        val key = call.argument<String>("key")
                        if (key.isNullOrBlank()) {
                            result.success(false)
                        } else {
                            result.success(prefs.edit().remove(key).commit())
                        }
                    }
                    "clearWithParameters" -> {
                        try {
                            val prefix = call.argument<String>("prefix") ?: "flutter."
                            @Suppress("UNCHECKED_CAST")
                            val allowList = call.argument<List<String>>("allowList")
                            val editor = prefs.edit()
                            for (key in prefs.all.keys) {
                                if (!key.startsWith(prefix)) continue
                                if (allowList != null && !allowList.contains(key)) continue
                                editor.remove(key)
                            }
                            result.success(editor.commit())
                        } catch (ex: Exception) {
                            result.error("native_prefs_error", ex.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(messenger, "com.pridev3.pride_v3/whatsapp_share")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "sharePdf" -> {
                        val path = call.argument<String>("path")
                        val phone = call.argument<String>("phone")
                        val caption = call.argument<String>("caption") ?: ""
                        if (path.isNullOrBlank() || phone.isNullOrBlank()) {
                            result.success(false)
                            return@setMethodCallHandler
                        }
                        result.success(sharePdfToWhatsApp(path, phone, caption))
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(messenger, "com.pridev3.pride_v3/ui_feedback")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "playUiSound" -> {
                        val kind = call.argument<String>("kind") ?: "info"
                        val deleted = call.argument<Boolean>("deleted") == true
                        playUiSound(kind, deleted)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        toneGenerator?.release()
        toneGenerator = null
        super.onDestroy()
    }

    private fun flutterSharedPreferences(): SharedPreferences =
        applicationContext.getSharedPreferences(
            "FlutterSharedPreferences",
            Context.MODE_PRIVATE,
        )

    private fun readAllWithPrefix(
        prefs: SharedPreferences,
        prefix: String,
        allowList: List<String>?,
    ): Map<String, Any?> {
        val out = mutableMapOf<String, Any?>()
        for ((rawKey, value) in prefs.all) {
            if (!rawKey.startsWith(prefix)) continue
            if (allowList != null && !allowList.contains(rawKey)) continue
            out[rawKey] = decodeFlutterPreferenceValue(value)
        }
        return out
    }

    private fun encodeFlutterStringList(list: List<String>): String {
        val bytes = ByteArrayOutputStream()
        ObjectOutputStream(bytes).use { it.writeObject(ArrayList(list)) }
        return LIST_PREFIX + Base64.encodeToString(bytes.toByteArray(), Base64.DEFAULT)
    }

    companion object {
        private const val LIST_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu"
        private const val JSON_LIST_PREFIX = LIST_PREFIX + "!"
        private const val DOUBLE_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu"
    }

    private fun readFlutterSharedPreferences(): Map<String, Any?> =
        readAllWithPrefix(flutterSharedPreferences(), "flutter.", null)

    private fun decodeFlutterPreferenceValue(value: Any?): Any? {
        if (value !is String) return value
        if (value.startsWith(DOUBLE_PREFIX)) {
            return value.substring(DOUBLE_PREFIX.length).toDoubleOrNull() ?: 0.0
        }
        if (value.startsWith(LIST_PREFIX)) {
            return decodeFlutterStringList(value)
        }
        return value
    }

    private fun decodeFlutterStringList(serialized: String): List<String> {
        return try {
            val payload = when {
                serialized.startsWith(JSON_LIST_PREFIX) ->
                    serialized.substring(JSON_LIST_PREFIX.length)
                serialized.startsWith(LIST_PREFIX) ->
                    serialized.substring(LIST_PREFIX.length)
                else -> return emptyList()
            }
            val bytes = Base64.decode(payload, Base64.DEFAULT)
            ObjectInputStream(ByteArrayInputStream(bytes)).use { input ->
                @Suppress("UNCHECKED_CAST")
                (input.readObject() as? List<String>) ?: emptyList()
            }
        } catch (_: Exception) {
            emptyList()
        }
    }

    private fun playUiSound(kind: String, deleted: Boolean) {
        val tg = toneGenerator ?: ToneGenerator(
            AudioManager.STREAM_MUSIC,
            100,
        ).also { toneGenerator = it }

        val (tone, durationMs) = when {
            deleted -> ToneGenerator.TONE_CDMA_ALERT_CALL_GUARD to 260
            kind == "error" -> ToneGenerator.TONE_PROP_NACK to 220
            kind == "success" -> ToneGenerator.TONE_PROP_ACK to 140
            else -> ToneGenerator.TONE_PROP_BEEP to 90
        }
        tg.startTone(tone, durationMs)
    }

    private fun sharePdfToWhatsApp(
        path: String,
        phoneDigits: String,
        caption: String,
    ): Boolean {
        val file = File(path)
        if (!file.exists()) return false

        val uri: Uri = FileProvider.getUriForFile(
            this,
            "${applicationContext.packageName}.fileprovider",
            file,
        )

        val packages = listOf("com.whatsapp", "com.whatsapp.w4b")
        for (pkg in packages) {
            val intent = Intent(Intent.ACTION_SEND).apply {
                type = "application/pdf"
                setPackage(pkg)
                putExtra(Intent.EXTRA_STREAM, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                if (caption.isNotBlank()) {
                    putExtra(Intent.EXTRA_TEXT, caption)
                }
                putExtra("jid", "${phoneDigits}@s.whatsapp.net")
            }
            try {
                startActivity(intent)
                return true
            } catch (_: Exception) {
                // Try WhatsApp Business or fall back to generic share from Dart.
            }
        }
        return false
    }
}
