import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../input/pride_ltr_input.dart';

/// Compact numeric entry (measurements, counts) with RTL-safe typing.
class PrideNumericTextField extends StatefulWidget {
  const PrideNumericTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.decimal = true,
    this.maxLength,
    this.textAlign = PrideLtrInput.align,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.done,
    this.dense = false,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool enabled;
  final bool decimal;
  final int? maxLength;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;
  final bool dense;

  @override
  State<PrideNumericTextField> createState() => _PrideNumericTextFieldState();
}

class _PrideNumericTextFieldState extends State<PrideNumericTextField> {
  final _focusNode = FocusNode();
  var _scrollEnsuredForFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _scrollEnsuredForFocus = false;
      return;
    }
    if (_scrollEnsuredForFocus) return;
    _scrollEnsuredForFocus = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_focusNode.hasFocus) return;
      Scrollable.ensureVisible(
        context,
        alignment: 0.35,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      keyboardType: widget.decimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      textInputAction: widget.textInputAction,
      textDirection: PrideLtrInput.direction,
      textAlign: widget.textAlign,
      maxLength: widget.maxLength,
      scrollPadding: kPrideKeyboardSafeScrollPadding,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          widget.decimal ? RegExp(r'[0-9۰-۹٠-٩.]') : RegExp(r'[0-9۰-۹٠-٩]'),
        ),
      ],
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        isDense: widget.dense,
        counterText: widget.maxLength != null ? '' : null,
        border: const OutlineInputBorder(),
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
