// GENERATED from waistcoat CSV manifest
import '../entities/garment_type.dart';
import '../seed_data.dart';
import 'style_figure_image_ref.dart';

class BundledWaistcoatPartTemplate {
  const BundledWaistcoatPartTemplate({required this.internalId, required this.folderKey, required this.sortOrder});
  final String internalId; final String folderKey; final int sortOrder;
}

class BundledWaistcoatFigureTemplate {
  const BundledWaistcoatFigureTemplate({required this.internalId, required this.partInternalId, required this.folderKey, required this.fileBase, required this.displayName, required this.sortOrder});
  final String internalId; final String partInternalId; final String folderKey; final String fileBase; final String displayName; final int sortOrder;
  String get imageRef => StyleFigureImageRef.waistcoatAssetKey('$folderKey/$fileBase');
}

const bundledWaistcoatPartTemplates = <BundledWaistcoatPartTemplate>[
  BundledWaistcoatPartTemplate(internalId: DevSeedIds.waistcoatPart01, folderKey: '01_شکل_و_استایل_جلو', sortOrder: 10),
  BundledWaistcoatPartTemplate(internalId: DevSeedIds.waistcoatPart02, folderKey: '02_استایل_یخن', sortOrder: 20),
  BundledWaistcoatPartTemplate(internalId: DevSeedIds.waistcoatPart03, folderKey: '03_استایل_جیب', sortOrder: 30),
  BundledWaistcoatPartTemplate(internalId: DevSeedIds.waistcoatPart04, folderKey: '04_استایل_عقب', sortOrder: 40),
  BundledWaistcoatPartTemplate(internalId: DevSeedIds.waistcoatPart05, folderKey: '05_شکل_پایین', sortOrder: 50),
  BundledWaistcoatPartTemplate(internalId: DevSeedIds.waistcoatPart06, folderKey: '06_استایل_دکمه', sortOrder: 60),
  BundledWaistcoatPartTemplate(internalId: DevSeedIds.waistcoatPart07, folderKey: '07_تزئینات_و_جزئیات', sortOrder: 70),
  BundledWaistcoatPartTemplate(internalId: DevSeedIds.waistcoatPart08, folderKey: '08_بخش‌های_اضافی', sortOrder: 80),
];

const bundledWaistcoatFigureTemplates = <BundledWaistcoatFigureTemplate>[
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure01, partInternalId: DevSeedIds.waistcoatPart01, folderKey: '01_شکل_و_استایل_جلو', fileBase: '01_جلو_صاف', displayName: 'جلو صاف', sortOrder: 10),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure02, partInternalId: DevSeedIds.waistcoatPart01, folderKey: '01_شکل_و_استایل_جلو', fileBase: '02_جلو_هفت', displayName: 'جلو هفت', sortOrder: 20),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure03, partInternalId: DevSeedIds.waistcoatPart01, folderKey: '01_شکل_و_استایل_جلو', fileBase: '03_جلو_گرد', displayName: 'جلو گرد', sortOrder: 30),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure04, partInternalId: DevSeedIds.waistcoatPart01, folderKey: '01_شکل_و_استایل_جلو', fileBase: '04_جلو_رویهم', displayName: 'جلو روی‌هم', sortOrder: 40),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure05, partInternalId: DevSeedIds.waistcoatPart01, folderKey: '01_شکل_و_استایل_جلو', fileBase: '05_جلو_بسته', displayName: 'جلو بسته', sortOrder: 50),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure06, partInternalId: DevSeedIds.waistcoatPart01, folderKey: '01_شکل_و_استایل_جلو', fileBase: '06_جلو_یخن_چینی', displayName: 'جلو یخن چینی', sortOrder: 60),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure07, partInternalId: DevSeedIds.waistcoatPart01, folderKey: '01_شکل_و_استایل_جلو', fileBase: '07_جلو_باز', displayName: 'جلو باز', sortOrder: 70),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure08, partInternalId: DevSeedIds.waistcoatPart02, folderKey: '02_استایل_یخن', fileBase: '08_بدون_یخن', displayName: 'بدون یخن', sortOrder: 80),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure09, partInternalId: DevSeedIds.waistcoatPart02, folderKey: '02_استایل_یخن', fileBase: '09_یخن_بند_چینی', displayName: 'یخن بند / چینی', sortOrder: 90),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure10, partInternalId: DevSeedIds.waistcoatPart02, folderKey: '02_استایل_یخن', fileBase: '10_یخن_ایستاده_کوتاه', displayName: 'یخن ایستاده کوتاه', sortOrder: 100),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure11, partInternalId: DevSeedIds.waistcoatPart02, folderKey: '02_استایل_یخن', fileBase: '11_یخن_ایستاده_بلند', displayName: 'یخن ایستاده بلند', sortOrder: 110),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure12, partInternalId: DevSeedIds.waistcoatPart02, folderKey: '02_استایل_یخن', fileBase: '12_یخن_هفت', displayName: 'یخن هفت', sortOrder: 120),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure13, partInternalId: DevSeedIds.waistcoatPart02, folderKey: '02_استایل_یخن', fileBase: '13_یخن_گرد', displayName: 'یخن گرد', sortOrder: 130),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure14, partInternalId: DevSeedIds.waistcoatPart03, folderKey: '03_استایل_جیب', fileBase: '14_بدون_جیب', displayName: 'بدون جیب', sortOrder: 140),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure15, partInternalId: DevSeedIds.waistcoatPart03, folderKey: '03_استایل_جیب', fileBase: '15_جیب_سینه_دهان_جیب', displayName: 'جیب سینه / دهان‌جیب', sortOrder: 150),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure16, partInternalId: DevSeedIds.waistcoatPart03, folderKey: '03_استایل_جیب', fileBase: '16_جیب_سینه_سرجیب_دار', displayName: 'جیب سینه / سرجیب‌دار', sortOrder: 160),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure17, partInternalId: DevSeedIds.waistcoatPart03, folderKey: '03_استایل_جیب', fileBase: '17_دو_جیب_پایین_دهان_جیب', displayName: 'دو جیب پایین / دهان‌جیب', sortOrder: 170),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure18, partInternalId: DevSeedIds.waistcoatPart03, folderKey: '03_استایل_جیب', fileBase: '18_دو_جیب_پایین_سرجیب_دار', displayName: 'دو جیب پایین / سرجیب‌دار', sortOrder: 180),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure19, partInternalId: DevSeedIds.waistcoatPart03, folderKey: '03_استایل_جیب', fileBase: '19_چهار_جیب', displayName: 'چهار جیب', sortOrder: 190),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure20, partInternalId: DevSeedIds.waistcoatPart03, folderKey: '03_استایل_جیب', fileBase: '20_جیب_داخلی', displayName: 'جیب داخلی', sortOrder: 200),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure21, partInternalId: DevSeedIds.waistcoatPart04, folderKey: '04_استایل_عقب', fileBase: '21_عقب_از_همان_تکه', displayName: 'عقب از همان تکه', sortOrder: 210),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure22, partInternalId: DevSeedIds.waistcoatPart04, folderKey: '04_استایل_عقب', fileBase: '22_عقب_آستر_دار', displayName: 'عقب آستر دار', sortOrder: 220),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure23, partInternalId: DevSeedIds.waistcoatPart04, folderKey: '04_استایل_عقب', fileBase: '23_کمربند_تنظیمی', displayName: 'کمربند تنظیمی', sortOrder: 230),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure24, partInternalId: DevSeedIds.waistcoatPart04, folderKey: '04_استایل_عقب', fileBase: '24_چاک_کناری', displayName: 'چاک کناری', sortOrder: 240),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure25, partInternalId: DevSeedIds.waistcoatPart05, folderKey: '05_شکل_پایین', fileBase: '25_پایین_صاف', displayName: 'پایین صاف', sortOrder: 250),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure26, partInternalId: DevSeedIds.waistcoatPart05, folderKey: '05_شکل_پایین', fileBase: '26_پایین_جلو_گرد', displayName: 'پایین جلو گرد', sortOrder: 260),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure27, partInternalId: DevSeedIds.waistcoatPart05, folderKey: '05_شکل_پایین', fileBase: '27_پایین_جلو_نوک_تیز', displayName: 'پایین جلو نوک‌تیز', sortOrder: 270),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure28, partInternalId: DevSeedIds.waistcoatPart05, folderKey: '05_شکل_پایین', fileBase: '28_کمی_خمیده', displayName: 'کمی خمیده', sortOrder: 280),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure29, partInternalId: DevSeedIds.waistcoatPart05, folderKey: '05_شکل_پایین', fileBase: '29_بلند_پرنس_کوت', displayName: 'بلند / پرنس‌کوت', sortOrder: 290),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure30, partInternalId: DevSeedIds.waistcoatPart06, folderKey: '06_استایل_دکمه', fileBase: '30_دکمه_معمولی', displayName: 'دکمه معمولی', sortOrder: 300),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure31, partInternalId: DevSeedIds.waistcoatPart06, folderKey: '06_استایل_دکمه', fileBase: '31_دکمه_فلزی', displayName: 'دکمه فلزی', sortOrder: 310),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure32, partInternalId: DevSeedIds.waistcoatPart06, folderKey: '06_استایل_دکمه', fileBase: '32_دکمه_روکش_تکه‌ای', displayName: 'دکمه روکش / تکه‌ای', sortOrder: 320),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure33, partInternalId: DevSeedIds.waistcoatPart06, folderKey: '06_استایل_دکمه', fileBase: '33_دکمه_زینتی', displayName: 'دکمه زینتی', sortOrder: 330),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure34, partInternalId: DevSeedIds.waistcoatPart06, folderKey: '06_استایل_دکمه', fileBase: '34_دکمه_پنهان', displayName: 'دکمه پنهان', sortOrder: 340),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure35, partInternalId: DevSeedIds.waistcoatPart06, folderKey: '06_استایل_دکمه', fileBase: '35_دکمه_حلقه‌ای', displayName: 'دکمه حلقه‌ای', sortOrder: 350),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure36, partInternalId: DevSeedIds.waistcoatPart07, folderKey: '07_تزئینات_و_جزئیات', fileBase: '36_ساده', displayName: 'ساده', sortOrder: 360),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure37, partInternalId: DevSeedIds.waistcoatPart07, folderKey: '07_تزئینات_و_جزئیات', fileBase: '37_لبه_دوزی', displayName: 'لبه‌دوزی', sortOrder: 370),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure38, partInternalId: DevSeedIds.waistcoatPart07, folderKey: '07_تزئینات_و_جزئیات', fileBase: '38_لبه_دوزی_متضاد', displayName: 'لبه‌دوزی / متضاد', sortOrder: 380),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure39, partInternalId: DevSeedIds.waistcoatPart07, folderKey: '07_تزئینات_و_جزئیات', fileBase: '39_گلدوزی', displayName: 'گلدوزی', sortOrder: 390),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure40, partInternalId: DevSeedIds.waistcoatPart07, folderKey: '07_تزئینات_و_جزئیات', fileBase: '40_گلدوزی_یخن', displayName: 'گلدوزی یخن', sortOrder: 400),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure41, partInternalId: DevSeedIds.waistcoatPart07, folderKey: '07_تزئینات_و_جزئیات', fileBase: '41_گلدوزی_جیب', displayName: 'گلدوزی جیب', sortOrder: 410),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure42, partInternalId: DevSeedIds.waistcoatPart08, folderKey: '08_بخش‌های_اضافی', fileBase: '42_شکل_شانه', displayName: 'شکل شانه', sortOrder: 420),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure43, partInternalId: DevSeedIds.waistcoatPart08, folderKey: '08_بخش‌های_اضافی', fileBase: '43_حلقه_آستین', displayName: 'حلقه آستین', sortOrder: 430),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure44, partInternalId: DevSeedIds.waistcoatPart08, folderKey: '08_بخش‌های_اضافی', fileBase: '44_لایی_روی_جلو', displayName: 'لایی روی جلو', sortOrder: 440),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure45, partInternalId: DevSeedIds.waistcoatPart08, folderKey: '08_بخش‌های_اضافی', fileBase: '45_لایی_روی_عقب', displayName: 'لایی روی عقب', sortOrder: 450),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure46, partInternalId: DevSeedIds.waistcoatPart08, folderKey: '08_بخش‌های_اضافی', fileBase: '46_آستر', displayName: 'آستر', sortOrder: 460),
  BundledWaistcoatFigureTemplate(internalId: DevSeedIds.waistcoatFigure47, partInternalId: DevSeedIds.waistcoatPart08, folderKey: '08_بخش‌های_اضافی', fileBase: '47_لایی_چسپ', displayName: 'لایی چسپ', sortOrder: 470),
];

bool bundledWaistcoatFigureNeedsRepair({
  required String shopId,
  required BundledWaistcoatFigureTemplate template,
  required String existingShopId,
  required String existingImageRef,
  required String existingPartInternalId,
  required int existingSortOrder,
  required int existingGarmentTypeIndex,
  required bool isDeleted,
}) {
  if (isDeleted) return true;
  if (existingShopId != shopId) return true;
  if (existingGarmentTypeIndex != GarmentType.waistcoat.code) return true;
  if (existingImageRef.trim() != template.imageRef) return true;
  if (existingPartInternalId != template.partInternalId) return true;
  if (existingSortOrder != template.sortOrder) return true;
  return false;
}
