import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Minimal HTML shell that renders a PDF with pdf.js for WebView preview.
String invoicePdfPreviewHtml(Uint8List pdfBytes) {
  final encoded = base64Encode(pdfBytes);
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
  <style>
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      min-height: 100%;
      background: #525659;
      overflow: auto;
    }
    #pages {
      padding: 12px 0 24px;
    }
    canvas {
      display: block;
      margin: 0 auto 16px;
      max-width: calc(100% - 24px);
      height: auto;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.35);
      background: #fff;
    }
    #error {
      color: #fff;
      padding: 16px;
      font-family: sans-serif;
    }
  </style>
</head>
<body>
  <div id="pages"></div>
  <div id="error" hidden></div>
  <script>
    pdfjsLib.GlobalWorkerOptions.workerSrc =
      'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';

    const raw = atob('$encoded');
    const bytes = new Uint8Array(raw.length);
    for (let i = 0; i < raw.length; i++) {
      bytes[i] = raw.charCodeAt(i);
    }

    const container = document.getElementById('pages');
    const errorEl = document.getElementById('error');

    pdfjsLib.getDocument({ data: bytes }).promise.then(async (pdf) => {
      for (let pageNum = 1; pageNum <= pdf.numPages; pageNum++) {
        const page = await pdf.getPage(pageNum);
        const viewport = page.getViewport({ scale: 1.5 });
        const canvas = document.createElement('canvas');
        canvas.width = viewport.width;
        canvas.height = viewport.height;
        container.appendChild(canvas);
        await page.render({
          canvasContext: canvas.getContext('2d'),
          viewport: viewport,
        }).promise;
      }
    }).catch((err) => {
      errorEl.hidden = false;
      errorEl.textContent = String(err);
    });
  </script>
</body>
</html>
''';
}
