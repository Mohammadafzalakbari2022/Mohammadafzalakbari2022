import 'package:flutter/material.dart';

import '../../core/printing/invoice/invoice_document_model.dart';
import '../../core/printing/invoice_payment_labels.dart';
import '../../features/catalog/catalog_item_image.dart';
import '../../features/reports/report_money_format.dart';
import '../../features/settings/style/style_figure_image.dart';
import '../../l10n/app_localizations.dart';

/// Scrollable in-app invoice preview — same [InvoiceDocumentModel] as shared PDF.
class OrderInvoicePreviewScreen extends StatelessWidget {
  const OrderInvoicePreviewScreen({
    super.key,
    required this.document,
    required this.l10n,
    required this.title,
    required this.shareLabel,
    required this.formatPaymentDate,
    required this.onShare,
  });

  final InvoiceDocumentModel document;
  final AppLocalizations l10n;
  final String title;
  final String shareLabel;
  final String Function(DateTime dateTime) formatPaymentDate;
  final Future<void> Function() onShare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: shareLabel,
            onPressed: () async {
              try {
                await onShare();
              } on Object catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _HeaderCard(document: document, l10n: l10n),
          const SizedBox(height: 12),
          _CustomerCard(document: document, l10n: l10n),
          for (final garment in document.garments) ...[
            const SizedBox(height: 12),
            _GarmentCard(garment: garment, l10n: l10n),
          ],
          const SizedBox(height: 12),
          _PaymentCard(
            document: document,
            l10n: l10n,
            formatPaymentDate: formatPaymentDate,
          ),
          if (document.internalNotes.isNotEmpty) ...[
            const SizedBox(height: 12),
            _SectionCard(
              title: l10n.receiptInternalNotesHeader,
              child: Text(
                document.internalNotes,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.invoiceGeneratedByKhayat,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.document, required this.l10n});

  final InvoiceDocumentModel document;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final branding = document.branding;
    return _SectionCard(
      title: branding.shopDisplayName,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LabelValueRow(
            label: l10n.orderIdLabel,
            value: document.orderIdLabel,
            emphasize: true,
          ),
          _LabelValueRow(
            label: l10n.ordersAuditStatus,
            value: document.statusText,
          ),
          _LabelValueRow(
            label: l10n.invoiceTakenDateLabel,
            value: document.createdDateText,
          ),
          _LabelValueRow(
            label: l10n.ordersAuditDelivery,
            value: document.deliveryDateText,
          ),
          if (branding.shopPhoneLine != null &&
              branding.shopPhoneLine!.trim().isNotEmpty)
            _LabelValueRow(
              label: l10n.shopProfileShopPhoneLabel,
              value: branding.shopPhoneLine!,
            ),
          for (final line in branding.addressLines)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                line,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.document, required this.l10n});

  final InvoiceDocumentModel document;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final customer = document.customer;
    return _SectionCard(
      title: l10n.ordersDetailSectionCustomer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LabelValueRow(label: l10n.customerNameLabel, value: customer.name),
          if (customer.phone.trim().isNotEmpty)
            _LabelValueRow(
              label: l10n.customerPhoneLabel,
              value: customer.phone,
            ),
          if (customer.displayIdLabel != null &&
              customer.displayIdLabel!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                customer.displayIdLabel!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.end,
              ),
            ),
        ],
      ),
    );
  }
}

class _GarmentCard extends StatelessWidget {
  const _GarmentCard({required this.garment, required this.l10n});

  final InvoiceDocumentGarment garment;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      title: garment.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (garment.priceLabel.isNotEmpty)
            _LabelValueRow(
              label: l10n.ordersComposerItemPriceLabel,
              value: garment.priceLabel,
              emphasize: true,
            ),
          if (garment.measurementRows.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.ordersDetailSectionMeasurements,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            for (final row in garment.measurementRows)
              _LabelValueRow(label: row.label, value: row.value),
          ],
          if (garment.styleName.isNotEmpty || garment.styleSummary.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.invoiceStyleNameLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (garment.styleName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(garment.styleName, style: theme.textTheme.bodyMedium),
              ),
            if (garment.styleSummary.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  garment.styleSummary,
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
          if (garment.fabricLines.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.orderDetailFabricTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            for (final line in garment.fabricLines)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(line, style: theme.textTheme.bodyMedium),
              ),
          ],
          if (garment.catalogLines.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.invoiceCatalogDesignLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            for (final line in garment.catalogLines)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(line, style: theme.textTheme.bodyMedium),
              ),
          ],
          if (garment.referenceDesign.hasContent) ...[
            const SizedBox(height: 8),
            Text(
              l10n.invoiceReferenceDesignLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (garment.referenceDesign.hasImage) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CatalogItemImage(
                  imagePath: garment.referenceDesign.catalogImagePath,
                ),
              ),
            ],
            if (garment.referenceDesign.designName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  garment.referenceDesign.designName,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            if (garment.referenceDesign.designerShopName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  garment.referenceDesign.designerShopName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
          if (garment.shapes.any((s) => !s.isEmpty)) ...[
            const SizedBox(height: 8),
            Text(
              l10n.invoiceStyleFiguresLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final shape in garment.shapes)
                  if (!shape.isEmpty) _ShapeTile(shape: shape, l10n: l10n),
              ],
            ),
          ],
          if (garment.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            _LabelValueRow(
              label: l10n.receiptInternalNotesHeader,
              value: garment.notes,
            ),
          ],
        ],
      ),
    );
  }
}

class _ShapeTile extends StatelessWidget {
  const _ShapeTile({required this.shape, required this.l10n});

  final InvoiceDocumentShape shape;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 140,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (shape.imageRef.trim().isNotEmpty)
                Center(
                  child: StyleFigureImage(imageRef: shape.imageRef, size: 56),
                ),
              if (shape.shapeName.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  shape.shapeName,
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ],
              for (final row in shape.detailRows)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${row.label}: ${row.value}',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (shape.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${l10n.ordersComposerShapeNoteLabel}: ${shape.note}',
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.document,
    required this.l10n,
    required this.formatPaymentDate,
  });

  final InvoiceDocumentModel document;
  final AppLocalizations l10n;
  final String Function(DateTime dateTime) formatPaymentDate;

  @override
  Widget build(BuildContext context) {
    final payment = document.payment;
    final diff = payment.grandTotalMinor - payment.garmentTotalMinor;
    final discountMinor = diff < 0 ? -diff : 0;
    final additionalMinor = diff > 0 ? diff : 0;

    return _SectionCard(
      title: l10n.invoicePaymentSummaryTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LabelValueRow(
            label: l10n.invoiceGarmentTotalLabel,
            value: reportFormatMoney(l10n, payment.garmentTotalMinor),
          ),
          if (discountMinor > 0)
            _LabelValueRow(
              label: l10n.invoiceDiscountLabel,
              value: reportFormatMoney(l10n, discountMinor),
            ),
          if (additionalMinor > 0)
            _LabelValueRow(
              label: l10n.invoiceAdditionalChargesLabel,
              value: reportFormatMoney(l10n, additionalMinor),
            ),
          const Divider(height: 20),
          _LabelValueRow(
            label: l10n.invoiceGrandTotalLabel,
            value: reportFormatMoney(l10n, payment.grandTotalMinor),
            emphasize: true,
          ),
          _LabelValueRow(
            label: l10n.receiptPaidLabel,
            value: reportFormatMoney(l10n, payment.paidMinor),
          ),
          _LabelValueRow(
            label: l10n.invoiceRemainingBalanceLabel,
            value: reportFormatMoney(l10n, payment.remainingMinor),
            emphasize: payment.remainingMinor > 0,
          ),
          if (payment.ledger.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.ordersDetailSectionPayments,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            for (final row in payment.ledger)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${formatPaymentDate(row.createdAt)} · '
                  '${formatInvoicePaymentMethod(l10n, row.method)} · '
                  '${reportFormatMoney(l10n, row.amountMinor)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _LabelValueRow extends StatelessWidget {
  const _LabelValueRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final valueStyle = emphasize
        ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: valueStyle, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
