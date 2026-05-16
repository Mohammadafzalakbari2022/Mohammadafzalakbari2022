package com.pridev3.pride_v3

import android.content.Intent
import android.media.AudioManager
import android.media.ToneGenerator
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private var toneGenerator: ToneGenerator? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

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
