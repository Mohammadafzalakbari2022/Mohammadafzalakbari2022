import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Typing direction for values read left-to-right (digits, money, phones).
///
/// In RTL locales, omitting this makes backspace and cursor behavior feel reversed.
abstract final class PrideLtrInput {
  static const TextDirection direction = TextDirection.ltr;
  static const TextAlign align = TextAlign.left;
}

/// Allowed characters for inch / measurement free-text (e.g. `5 X 5 1/2`).
final RegExp kPrideMeasurementInputPattern = RegExp(r'[0-9۰-۹٠-٩./\sXx×\-]');

/// True when [text] should render LTR (measurements, Latin IDs, phones).
bool prideShouldForceLtrDisplay(String text) {
  if (text.isEmpty) return false;
  return RegExp(r'[0-9A-Za-z/×xX]').hasMatch(text);
}

/// [Text] that stays left-to-right for measurement and Latin tokens in RTL UI.
class PrideLtrText extends StatelessWidget {
  const PrideLtrText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textDirection: PrideLtrInput.direction,
      textAlign: textAlign ?? PrideLtrInput.align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Inch / measurement entry with LTR typing in Dari and Pashto locales.
class PrideMeasurementTextField extends StatelessWidget {
  const PrideMeasurementTextField({
    super.key,
    required this.controller,
    this.decoration,
    this.autofocus = false,
    this.maxLines = 1,
    this.style,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final InputDecoration? decoration;
  final bool autofocus;
  final int maxLines;
  final TextStyle? style;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: decoration,
      autofocus: autofocus,
      maxLines: maxLines,
      style: style,
      textDirection: PrideLtrInput.direction,
      textAlign: PrideLtrInput.align,
      scrollPadding: kPrideKeyboardSafeScrollPadding,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(kPrideMeasurementInputPattern),
      ],
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}

/// Localized label + value row; forces LTR for measurement/Latin [value] text.
class PrideLabelValueLine extends StatelessWidget {
  const PrideLabelValueLine({
    super.key,
    required this.label,
    required this.value,
    this.style,
  });

  final String label;
  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? Theme.of(context).textTheme.bodyMedium;
    final forceLtr = prideShouldForceLtrDisplay(value);

    return Row(
      textDirection: Directionality.of(context),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: effectiveStyle),
        Expanded(
          child: forceLtr
              ? PrideLtrText(text: value, style: effectiveStyle)
              : Text(value, style: effectiveStyle),
        ),
      ],
    );
  }
}

/// [TextField.scrollPadding] for forms with [KeyboardSafeBottomBar].
///
/// Do not add [MediaQuery.viewInsets] here — the bottom bar already lifts above
/// the keyboard; double-reserving space rebuilds the field and dismisses IME.
const EdgeInsets kPrideKeyboardSafeScrollPadding = EdgeInsets.only(bottom: 140);
