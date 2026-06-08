/// User-visible label for a style part/section (strips numeric folder prefix).
String stylePartSectionLabel(String partName) {
  final stripped = partName.replaceFirst(RegExp(r'^\d+_'), '');
  return stripped.replaceAll('_', ' ');
}
