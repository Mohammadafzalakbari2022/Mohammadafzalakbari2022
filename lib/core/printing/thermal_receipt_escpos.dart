import 'package:esc_pos_utils/esc_pos_utils.dart';

import 'package:image/image.dart' as img;



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



/// One selected style figure raster for thermal output.
class ReceiptStyleFigure {
  const ReceiptStyleFigure({this.image, this.name = ''});

  final img.Image? image;
  final String name;
}

class OrderReceiptEscPosContent {

  const OrderReceiptEscPosContent({

    this.headerLogo,

    required this.shopLine,

    this.shopPhoneLine,

    this.shopAddressLines = const [],

    required this.orderLine,

    required this.customerLine,

    this.phoneLine,

    required this.deliveryLine,

    required this.statusLine,

    this.measurementsLine,

    this.styleLine,

    this.styleFigures = const [],

    this.internalNotesLine,

    required this.totalLine,

    required this.paidLine,

    required this.balanceLine,

    required this.paymentHeader,

    required this.paymentRows,

    this.footerAddressLines = const [],

    required this.footerThankYouLines,

  });



  final img.Image? headerLogo;

  final String shopLine;

  final String? shopPhoneLine;

  final List<String> shopAddressLines;

  final String orderLine;

  final String customerLine;

  final String? phoneLine;

  final String deliveryLine;

  final String statusLine;

  final String? measurementsLine;

  final String? styleLine;

  final List<ReceiptStyleFigure> styleFigures;

  final String? internalNotesLine;

  final String totalLine;

  final String paidLine;

  final String balanceLine;

  final String paymentHeader;

  final List<String> paymentRows;

  final List<String> footerAddressLines;

  final List<String> footerThankYouLines;

}



void _appendCenteredLines(

  Generator gen,

  List<int> bytes,

  Iterable<String> lines, {

  bool bold = false,

}) {

  for (final line in lines) {

    final t = line.trim();

    if (t.isEmpty) continue;

    bytes.addAll(

      gen.text(

        receiptLatin1Safe(t),

        styles: PosStyles(

          align: PosAlign.center,

          bold: bold,

        ),

      ),

    );

  }

}



void _appendReceiptHeader(Generator gen, List<int> bytes, OrderReceiptEscPosContent c) {

  final logo = c.headerLogo;

  if (logo != null) {

    bytes.addAll(gen.image(logo));

    bytes.addAll(gen.feed(1));

  }

  bytes.addAll(

    gen.text(

      receiptLatin1Safe(c.shopLine),

      styles: const PosStyles(

        align: PosAlign.center,

        bold: true,

        height: PosTextSize.size2,

        width: PosTextSize.size1,

      ),

    ),

  );

  final shopPhone = c.shopPhoneLine?.trim();

  if (shopPhone != null && shopPhone.isNotEmpty) {

    bytes.addAll(

      gen.text(

        receiptLatin1Safe(shopPhone),

        styles: const PosStyles(align: PosAlign.center),

      ),

    );

  }

  _appendCenteredLines(gen, bytes, c.shopAddressLines);

  bytes.addAll(gen.feed(1));

  bytes.addAll(gen.hr(ch: '-', len: 48));

}



void _appendStyleFigures(
  Generator gen,
  List<int> bytes,
  List<ReceiptStyleFigure> figures,
) {
  for (final figure in figures) {
    final image = figure.image;
    if (image != null) {
      bytes.addAll(gen.image(image));
      bytes.addAll(gen.feed(1));
    }
    final name = figure.name.trim();
    if (name.isNotEmpty) {
      bytes.addAll(
        gen.text(
          receiptLatin1Safe(name),
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
  }
}

void _appendReceiptFooter(Generator gen, List<int> bytes, OrderReceiptEscPosContent c) {

  bytes.addAll(gen.feed(1));

  bytes.addAll(gen.hr(ch: '-', len: 48));

  _appendCenteredLines(gen, bytes, c.footerAddressLines);

  if (c.footerAddressLines.isNotEmpty && c.footerThankYouLines.isNotEmpty) {

    bytes.addAll(gen.feed(1));

  }

  _appendCenteredLines(gen, bytes, c.footerThankYouLines, bold: true);

  bytes.addAll(gen.feed(2));

}



Future<List<int>> buildThermalOrderReceipt({

  required PaperSize paper,

  required OrderReceiptEscPosContent c,

}) async {

  final profile = await CapabilityProfile.load();

  final gen = Generator(paper, profile);

  final bytes = <int>[];

  bytes.addAll(gen.reset());

  _appendReceiptHeader(gen, bytes, c);

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

  final style = c.styleLine?.trim();

  if (style != null && style.isNotEmpty) {

    bytes.addAll(gen.hr());

    bytes.addAll(gen.text(receiptLatin1Safe(style)));

  }

  if (c.styleFigures.isNotEmpty) {
    if (style == null || style.isEmpty) {
      bytes.addAll(gen.hr());
    }
    _appendStyleFigures(gen, bytes, c.styleFigures);
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

  _appendReceiptFooter(gen, bytes, c);

  bytes.addAll(gen.cut());

  return bytes;

}


