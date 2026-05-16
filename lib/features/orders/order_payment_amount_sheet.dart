import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Bottom sheet for entering a payment or adjustment amount (RTL-safe).
Future<int?> showOrderPaymentAmountSheet(
  BuildContext context,
  AppLocalizations l10n, {
  required String title,
  String? hint,
  bool signed = false,
}) {
  return showModalBottomSheet<int?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: _OrderPaymentAmountBody(
          l10n: l10n,
          title: title,
          hint: hint,
          signed: signed,
        ),
      );
    },
  );
}

class _OrderPaymentAmountBody extends StatefulWidget {
  const _OrderPaymentAmountBody({
    required this.l10n,
    required this.title,
    this.hint,
    required this.signed,
  });

  final AppLocalizations l10n;
  final String title;
  final String? hint;
  final bool signed;

  @override
  State<_OrderPaymentAmountBody> createState() =>
      _OrderPaymentAmountBodyState();
}

class _OrderPaymentAmountBodyState extends State<_OrderPaymentAmountBody> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _controller.text.trim();
    final value = int.tryParse(raw);
    if (value == null) {
      Navigator.of(context).pop(null);
      return;
    }
    if (widget.signed) {
      if (value == 0) {
        Navigator.of(context).pop(null);
        return;
      }
    } else {
      if (value <= 0) {
        Navigator.of(context).pop(null);
        return;
      }
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final ml = MaterialLocalizations.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (widget.hint != null && widget.hint!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                widget.hint!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: widget.signed
                  ? const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: false,
                    )
                  : TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.l10n.paymentAmountLabel,
                hintText: widget.l10n.paymentAmountHint,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: PrideCancelButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    label: ml.cancelButtonLabel,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    style: prideButtonStyle(context, PrideButtonVariant.payment),
                    child: Text(ml.okButtonLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
