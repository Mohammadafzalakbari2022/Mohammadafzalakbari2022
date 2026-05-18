import 'package:flutter/material.dart';

/// Typing direction for values read left-to-right (digits, money, phones).
///
/// In RTL locales, omitting this makes backspace and cursor behavior feel reversed.
abstract final class PrideLtrInput {
  static const TextDirection direction = TextDirection.ltr;
  static const TextAlign align = TextAlign.left;
}

/// [TextField.scrollPadding] for forms with [KeyboardSafeBottomBar].
///
/// Do not add [MediaQuery.viewInsets] here — the bottom bar already lifts above
/// the keyboard; double-reserving space rebuilds the field and dismisses IME.
const EdgeInsets kPrideKeyboardSafeScrollPadding = EdgeInsets.only(bottom: 140);
