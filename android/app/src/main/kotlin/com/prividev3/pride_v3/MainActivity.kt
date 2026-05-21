package com.prividev3.pride_v3

import android.content.ClipData
import android.content.Intent
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
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
            if (trySharePdf(pkg, uri, phoneDigits, caption, withJid = true)) {
                return true
            }
            if (trySharePdf(pkg, uri, phoneDigits, caption, withJid = false)) {
                return true
            }
        }

        return openWhatsAppChatFallback(phoneDigits, caption)
    }

    private fun trySharePdf(
        pkg: String,
        uri: Uri,
        phoneDigits: String,
        caption: String,
        withJid: Boolean,
    ): Boolean {
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "application/pdf"
            setPackage(pkg)
            putExtra(Intent.EXTRA_STREAM, uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            clipData = ClipData.newRawUri("", uri)
            if (caption.isNotBlank()) {
                putExtra(Intent.EXTRA_TEXT, caption)
            }
            if (withJid) {
                putExtra("jid", "${phoneDigits}@s.whatsapp.net")
            }
        }
        return try {
            startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun openWhatsAppChatFallback(phoneDigits: String, caption: String): Boolean {
        val encodedText = Uri.encode(caption)
        val uris = listOf(
            "https://wa.me/$phoneDigits?text=$encodedText",
            "https://wa.me/$phoneDigits",
        )
        for (waUri in uris) {
            for (pkg in listOf("com.whatsapp", "com.whatsapp.w4b")) {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(waUri)).apply {
                    setPackage(pkg)
                }
                try {
                    startActivity(intent)
                    return true
                } catch (_: Exception) {
                    // try next
                }
            }
        }
        return false
    }
}
