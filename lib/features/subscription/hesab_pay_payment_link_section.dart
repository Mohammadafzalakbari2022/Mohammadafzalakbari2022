import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// QR + tappable Hesab Pay payment link from published billing config.
class HesabPayPaymentLinkSection extends StatelessWidget {
  const HesabPayPaymentLinkSection({
    super.key,
    required this.paymentLink,
    required this.linkLabel,
    required this.l10n,
  });

  final String paymentLink;
  final String linkLabel;
  final AppLocalizations l10n;

  Future<void> _openLink(BuildContext context) async {
    final uri = Uri.tryParse(paymentLink.trim());
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.subscriptionBillingPaymentLinkOpenFailed)),
      );
    }
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: paymentLink.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.subscriptionBillingCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = linkLabel.trim().isNotEmpty
        ? linkLabel.trim()
        : l10n.subscriptionBillingPaymentLinkDefaultLabel;
    final link = paymentLink.trim();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              l10n.subscriptionBillingPaymentLinkTitle,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            QrImageView(
              data: link,
              size: 200,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _openLink(context),
              icon: const Icon(Icons.open_in_new),
              label: Text(label),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _copyLink(context),
              icon: const Icon(Icons.link, size: 18),
              label: Text(l10n.subscriptionBillingCopyPaymentLink),
            ),
          ],
        ),
      ),
    );
  }
}
