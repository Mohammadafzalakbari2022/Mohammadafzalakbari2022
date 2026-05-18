import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../input/pride_ltr_input.dart';

/// Money / amount entry: Western + Persian + Arabic-Indic digits, keyboard-safe padding.
class PrideMoneyField extends StatefulWidget {
  const PrideMoneyField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.enabled = true,
    this.signed = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool enabled;
  final bool signed;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;

  @override
  State<PrideMoneyField> createState() => _PrideMoneyFieldState();
}

class _PrideMoneyFieldState extends State<PrideMoneyField> {
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
      autofocus: widget.autofocus,
      keyboardType: widget.signed
          ? const TextInputType.numberWithOptions(signed: true, decimal: false)
          : TextInputType.number,
      textInputAction: widget.textInputAction,
      textDirection: PrideLtrInput.direction,
      textAlign: PrideLtrInput.align,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          widget.signed ? RegExp(r'[0-9۰-۹٠-٩\-]') : RegExp(r'[0-9۰-۹٠-٩]'),
        ),
      ],
      scrollPadding: kPrideKeyboardSafeScrollPadding,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
