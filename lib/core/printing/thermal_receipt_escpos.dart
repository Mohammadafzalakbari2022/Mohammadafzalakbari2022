import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'receipt_safe_text.dart';

PaperSize paperSizeFromMm(String mm) =>
    mm == '80' ? PaperSize.mm80 : PaperSize.mm58;

Future<List<int>> buildThermalTestReceipt({
  required PaperSize paper,
  required String headline,
  required String detail,
}) async {
  final profile = await CapabilityProfile.load();
  final gen = Generator(paper, profile);
  final bytes = <int>[];
  bytes.addAll(gen.reset());
  bytes.addAll(
    gen.text(
      receiptLatin1Safe(headline),
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ),
  );
  bytes.addAll(
    gen.text(
      receiptLatin1Safe(detail),
      styles: const PosStyles(align: PosAlign.center),
    ),
  );
  bytes.addAll(gen.feed(1));
  bytes.addAll(gen.hr());
  bytes.addAll(
    gen.text(
      receiptLatin1Safe(DateTime.now().toUtc().toIso8601String()),
    ),
  );
  bytes.addAll(gen.feed(2));
  bytes.addAll(gen.cut());
  return bytes;
}

class OrderReceiptEscPosContent {
  const OrderReceiptEscPosContent({
    required this.shopLine,
    required this.orderLine,
    required this.customerLine,
    this.phoneLine,
    required this.deliveryLine,
    required this.statusLine,
    this.measurementsLine,
    this.styleNotesLine,
    this.internalNotesLine,
    required this.totalLine,
    required this.paidLine,
    required this.balanceLine,
    required this.paymentHeader,
    required this.paymentRows,
    required this.footerLine,
  });

  final String shopLine;
  final String orderLine;
  final String customerLine;
  final String? phoneLine;
  final String deliveryLine;
  final String statusLine;
  final String? measurementsLine;
  final String? styleNotesLine;
  final String? internalNotesLine;
  final String totalLine;
  final String paidLine;
  final String balanceLine;
  final String paymentHeader;
  final List<String> paymentRows;
  final String footerLine;
}

Future<List<int>> buildThermalOrderReceipt({
  required PaperSize paper,
  required OrderReceiptEscPosContent c,
}) async {
  final profile = await CapabilityProfile.load();
  final gen = Generator(paper, profile);
  final bytes = <int>[];
  bytes.addAll(gen.reset());
  bytes.addAll(
    gen.text(
      receiptLatin1Safe(c.shopLine),
      styles: const PosStyles(align: PosAlign.center, bold: true),
    ),
  );
  bytes.addAll(gen.hr());
  bytes.addAll(
    gen.text(
      receiptLatin1Safe(c.orderLine),
      styles: const PosStyles(bold: true),
    ),
  );
  bytes.addAll(gen.text(receiptLatin1Safe(c.customerLine)));
  final phone = c.phoneLine?.trim();
  if (phone != null && phone.isNotEmpty) {
    bytes.addAll(gen.text(receiptLatin1Safe(phone)));
  }
  bytes.addAll(gen.text(receiptLatin1Safe(c.deliveryLine)));
  bytes.addAll(gen.text(receiptLatin1Safe(c.statusLine)));
  final m = c.measurementsLine?.trim();
  if (m != null && m.isNotEmpty) {
    bytes.addAll(gen.hr());
    bytes.addAll(gen.text(receiptLatin1Safe(m)));
  }
  final st = c.styleNotesLine?.trim();
  if (st != null && st.isNotEmpty) {
    bytes.addAll(gen.text(receiptLatin1Safe(st)));
  }
  final internal = c.internalNotesLine?.trim();
  if (internal != null && internal.isNotEmpty) {
    bytes.addAll(gen.hr());
    bytes.addAll(gen.text(receiptLatin1Safe(internal)));
  }
  bytes.addAll(gen.hr());
  bytes.addAll(
    gen.text(
      receiptLatin1Safe(c.totalLine),
      styles: const PosStyles(bold: true),
    ),
  );
  bytes.addAll(gen.text(receiptLatin1Safe(c.paidLine)));
  bytes.addAll(gen.text(receiptLatin1Safe(c.balanceLine)));
  bytes.addAll(gen.hr());
  bytes.addAll(
    gen.text(
      receiptLatin1Safe(c.paymentHeader),
      styles: const PosStyles(bold: true),
    ),
  );
  for (final row in c.paymentRows) {
    bytes.addAll(gen.text(receiptLatin1Safe(row)));
  }
  bytes.addAll(gen.feed(1));
  bytes.addAll(
    gen.text(
      receiptLatin1Safe(c.footerLine),
      styles: const PosStyles(align: PosAlign.center),
    ),
  );
  bytes.addAll(gen.feed(2));
  bytes.addAll(gen.cut());
  return bytes;
}
