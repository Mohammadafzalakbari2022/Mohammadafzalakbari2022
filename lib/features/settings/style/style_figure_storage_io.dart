import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';
import 'package:uuid/uuid.dart';

import '../../../data/local/style/style_figure_image_ref.dart';

Future<String?> pickStyleFigureRelativePath({
  ImageSource source = ImageSource.gallery,
}) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: source,
    maxWidth: 800,
    maxHeight: 800,
    imageQuality: 90,
  );
  if (picked == null) return null;
  final bytes = await File(picked.path).readAsBytes();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  const maxW = 400;
  final raster = decoded.width > maxW
      ? img.copyResize(
          decoded,
          width: maxW,
          interpolation: img.Interpolation.linear,
        )
      : decoded;
  final dir = await prideApplicationDocumentsDirectory();
  final figuresDir = Directory(
    '${dir.path}${Platform.pathSeparator}style_figures',
  );
  if (!await figuresDir.exists()) {
    await figuresDir.create(recursive: true);
  }
  final id = const Uuid().v4();
  final rel = 'style_figures/$id.png';
  final outFile = File('${dir.path}${Platform.pathSeparator}$rel');
  await outFile.writeAsBytes(img.encodePng(raster));
  return '${StyleFigureImageRef.filePrefix}$rel';
}
