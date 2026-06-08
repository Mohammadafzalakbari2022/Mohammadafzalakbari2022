// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'خیاط';

  @override
  String get tabOrders => 'سفارش‌ها';

  @override
  String get tabCustomers => 'لیست مشتریان';

  @override
  String get tabOrdersList => 'لیست سفارش‌ها';

  @override
  String get tabCatalog => 'کاتالوگ';

  @override
  String get tabReports => 'گزارش‌ها';

  @override
  String get tabSettings => 'تنظیمات';

  @override
  String get loginTitle => 'ورود';

  @override
  String get loginSubtitle => 'نام کاربری و رمز فروشگاه خود را وارد کنید.';

  @override
  String get loginMockHint =>
      'در این نسخه هر نام کاربری و رمز غیرخالی به‌صورت محلی وارد می‌شود.';

  @override
  String get loginShopIdLabel => 'شناسه فروشگاه (اختیاری)';

  @override
  String get loginShopIdHint => 'فقط اگر فروشگاه به شما شناسه داده است';

  @override
  String get loginSigningInHint =>
      'لطفاً صبر کنید. با اینترنت کند ممکن است تا یک دقیقه طول بکشد.';

  @override
  String get loginCreatingShopHint =>
      'لطفاً صبر کنید. ایجاد فروشگاه ممکن است کمی زمان ببرد.';

  @override
  String get loginInvalidCredentials =>
      'شناسه فروشگاه، نام کاربری یا رمز درست نیست. بررسی کنید و دوباره تلاش کنید.';

  @override
  String get loginNoInternet =>
      'اتصال اینترنت نیست. شبکه را بررسی کنید و دوباره تلاش کنید.';

  @override
  String get loginOfflineNotSetUp =>
      'برای ورود آفلاین، یک‌بار با اینترنت وارد شوید.';

  @override
  String get loginOfflineShopIdRequired =>
      'برای ورود آفلاین، شناسه فروشگاه را وارد کنید.';

  @override
  String get loginConnectionSlow =>
      'اتصال کند است یا قطع شد. کمی صبر کنید و دوباره تلاش کنید.';

  @override
  String get loginServerBusy =>
      'سرویس الان شلوغ است. چند دقیقه بعد دوباره تلاش کنید.';

  @override
  String get loginSomethingWrong =>
      'الان ورود ممکن نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get loginShopCreateFailed =>
      'الان ایجاد فروشگاه ممکن نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get loginForgotPasswordSubmitting => 'در حال ارسال درخواست…';

  @override
  String get loginForgotPasswordSubmitHint =>
      'لطفاً صبر کنید. با اینترنت کند ممکن است کمی طول بکشد.';

  @override
  String get loginForgotPasswordFailed =>
      'الان ارسال درخواست ممکن نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get loginUsernameLabel => 'نام کاربری';

  @override
  String get loginUsernameHint => 'نام ورود فروشگاه شما';

  @override
  String get loginPasswordLabel => 'رمز عبور';

  @override
  String get loginPasswordShowA11y => 'نمایش رمز عبور';

  @override
  String get loginPasswordHideA11y => 'پنهان کردن رمز عبور';

  @override
  String get loginSignInCta => 'ورود';

  @override
  String get loginForgotPasswordCta => 'رمز را فراموش کرده‌اید؟';

  @override
  String get loginForgotPasswordTitle => 'بازنشانی رمز';

  @override
  String get loginForgotPasswordBody =>
      'شناسهٔ فروشگاه و نام کاربری را وارد کنید. پس از ثبت در صف، توسعه‌دهنده از پرتال می‌تواند رمز جدید تعیین کند.';

  @override
  String get loginForgotPasswordSubmit => 'ارسال درخواست';

  @override
  String get loginForgotPasswordQueued =>
      'در صورت وجود حساب، درخواست بازنشانی در صف پشتیبانی ثبت شد.';

  @override
  String get loginForgotPasswordFieldsRequired =>
      'شناسهٔ فروشگاه و نام کاربری الزامی است.';

  @override
  String get settingsPushTokenTitle => 'توکن اعلان فشاری (آزمایشی)';

  @override
  String get settingsPushTokenHint =>
      'توکن FCM را بچسبانید، پلتفرم را انتخاب کنید و ذخیره کنید. سرور برای ارسال آینده نگه می‌دارد.';

  @override
  String get settingsPushTokenFieldLabel => 'توکن دستگاه';

  @override
  String get settingsPushPlatformLabel => 'پلتفرم';

  @override
  String get settingsPushRegisterCta => 'ذخیره روی سرور';

  @override
  String get settingsPushRegisterOk => 'توکن ذخیره شد.';

  @override
  String get settingsPushRegisterFail => 'ذخیرهٔ توکن ناموفق بود.';

  @override
  String devPortalShopsLoadError(String error) {
    return 'بارگذاری فروشگاه‌ها ناموفق: $error';
  }

  @override
  String devPortalResetsLoadError(String error) {
    return 'بارگذاری صف بازنشانی ناموفق: $error';
  }

  @override
  String get devPortalResetsEmpty => 'درخواست بازنشانی رمز در انتظار نیست.';

  @override
  String get devPortalResetsSetPasswordTitle => 'تنظیم رمز جدید';

  @override
  String get devPortalResetsSetPasswordHint => 'حداقل ۶ نویسه.';

  @override
  String get devPortalResetsResolveCta => 'اعمال رمز';

  @override
  String get devPortalResetsResolved => 'رمز به‌روز شد.';

  @override
  String devPortalResetsResolveFailed(String error) {
    return 'به‌روزرسانی ناموفق: $error';
  }

  @override
  String get loginFieldRequired => 'الزامی';

  @override
  String get loginDevContinue => 'ادامه بدون حساب (توسعه)';

  @override
  String get loginApiHint => 'با شناسه فروشگاه، نام کاربری و رمز وارد شوید.';

  @override
  String get loginSigningIn => 'در حال ورود…';

  @override
  String get loginApiUnauthorized =>
      'شناسه فروشگاه، نام کاربری یا رمز درست نیست. بررسی کنید و دوباره تلاش کنید.';

  @override
  String loginApiError(String error) {
    return 'ورود ناموفق: $error';
  }

  @override
  String get loginShopCreateSectionTitle => 'ایجاد فروشگاه جدید';

  @override
  String get loginShopCreateSubtitle =>
      'فروشگاه خیاطی خود را ثبت کنید و به‌عنوان مالک وارد شوید.';

  @override
  String get loginShopCreateNameLabel => 'نام فروشگاه';

  @override
  String get loginShopCreateOwnerUsernameLabel => 'نام کاربری مالک';

  @override
  String get loginShopCreateOwnerPasswordLabel => 'رمز مالک';

  @override
  String get loginShopCreateWhatsappLabel => 'شماره واتساپ';

  @override
  String get loginShopCreateWhatsappHint => 'مثلاً 0700 123 456';

  @override
  String get loginShopCreateWhatsappInvalid =>
      'شماره واتساپ یا موبایل معتبر وارد کنید.';

  @override
  String get loginShopCreateEmailLabel => 'ایمیل (اختیاری)';

  @override
  String get loginShopCreateAddressLabel => 'آدرس فروشگاه';

  @override
  String get loginShopCreateCta => 'ایجاد فروشگاه و ورود';

  @override
  String get loginShopCreating => 'در حال ایجاد فروشگاه…';

  @override
  String loginShopCreateError(String error) {
    return 'ایجاد فروشگاه ناموفق: $error';
  }

  @override
  String get dashboardTitle => 'داشبورد';

  @override
  String get dashboardSubtitle =>
      'شاخص‌ها و میانبرها از دادهٔ محلی بارگذاری می‌شوند.';

  @override
  String get dashboardKpisPlaceholder => 'نمای کلی امروز';

  @override
  String get dashboardKpiNewOrders => 'سفارش‌های جدید';

  @override
  String get dashboardKpiInProgress => 'در حال انجام';

  @override
  String get dashboardKpiReady => 'آماده';

  @override
  String get dashboardKpiUnpaid => 'مانده پرداخت‌نشده';

  @override
  String get dashboardKpiValuePlaceholder => '—';

  @override
  String get dashboardOpenMenuTooltip => 'باز کردن داشبورد';

  @override
  String get dashboardOrdersPipelineTitle => 'خط سفارش‌ها';

  @override
  String get dashboardRecentIncomeTitle => 'درآمد — ۷ روز اخیر';

  @override
  String get dashboardActivitySectionTitle => 'همگام‌سازی و اعلان‌ها';

  @override
  String get subscriptionTitle => 'اشتراک';

  @override
  String get subscriptionBody =>
      'با حساب پی (مراحل زیر پس از انتشار)، درخواست پرداخت به‌عنوان مالک دکان، یا کد فعال‌سازی از پشتیبانی تمدید کنید. پس از انقضا ویرایش محدود است؛ داده‌هایتان را می‌بینید.';

  @override
  String get subscriptionBillingSectionTitle => 'پرداخت و تمدید';

  @override
  String get subscriptionListTileSubtitle => 'مجوز، آزمایش و فعال‌سازی';

  @override
  String get licenseDevControlsTitle => 'مجوز (فقط توسعه)';

  @override
  String get licenseStatusTrial => 'آزمایشی';

  @override
  String get licenseStatusPaid => 'پرداخت‌شده';

  @override
  String get licenseStatusExpired => 'منقضی';

  @override
  String get ordersNewTitle => 'سفارش جدید';

  @override
  String get ordersNewCta => 'سفارش جدید';

  @override
  String get ordersDetailTitle => 'جزئیات سفارش';

  @override
  String get orderStatusNew => 'جدید';

  @override
  String get orderStatusInProgress => 'در حال انجام';

  @override
  String get orderStatusReady => 'آماده';

  @override
  String get orderStatusDelivered => 'تحویل‌شده';

  @override
  String get orderStatusCancelled => 'لغوشده';

  @override
  String get ordersListEmpty => 'هنوز سفارشی نیست';

  @override
  String ordersDeliveryOn(String date) {
    return 'تحویل: $date';
  }

  @override
  String ordersTakenOn(String dateTime) {
    return 'ثبت سفارش: $dateTime';
  }

  @override
  String get ordersWebDataHint =>
      'پیش‌نمایش وب از دادهٔ نمونه در حافظه استفاده می‌کند (Isar روی اندروید/iOS/دسکتاپ).';

  @override
  String ordersNumberPrefix(String number) {
    return 'شماره $number';
  }

  @override
  String get ordersSearchHint => 'جستجوی شماره سفارش، مشتری یا تلفن';

  @override
  String get ordersDateChipAny => 'همه تاریخ‌ها';

  @override
  String get ordersDateChipToday => 'تحویل امروز';

  @override
  String get ordersDateChipThisWeek => 'تحویل این هفته';

  @override
  String get ordersDateChipCustom => 'بازه دلخواه';

  @override
  String get ordersDateCustomPickerHelp => 'فیلتر بر اساس تاریخ تحویل (شامل).';

  @override
  String ordersCustomerFilterChip(String name) {
    return 'مشتری: $name';
  }

  @override
  String get ordersCustomerFilterUnknown => 'فیلتر مشتری فعال است';

  @override
  String get ordersClearFilterA11y => 'پاک کردن فیلتر';

  @override
  String get ordersOnlyUnpaidChip => 'فقط پرداخت‌نشده';

  @override
  String get ordersFilterOverdueChip => 'معوق';

  @override
  String get ordersFilterDeliveredTodayChip => 'تحویل امروز';

  @override
  String ordersRemainingChip(String amount) {
    return 'مانده: $amount';
  }

  @override
  String get ordersFilteredEmpty =>
      'هیچ سفارشی با جستجو یا فیلتر مطابقت ندارد.';

  @override
  String get ordersFilterSheetTitle => 'فیلترها';

  @override
  String get ordersFilterQuickSection => 'فیلترهای سریع';

  @override
  String get ordersFilterDeliverySection => 'تاریخ تحویل';

  @override
  String get ordersFilterStatusSection => 'وضعیت';

  @override
  String get ordersFilterClearAll => 'پاک کردن همه';

  @override
  String get ordersFilterApply => 'اعمال';

  @override
  String get listToolbarSearchTooltip => 'جستجو';

  @override
  String get listToolbarFilterTooltip => 'فیلترها';

  @override
  String get appShellTapTitleForMenu => 'برای باز کردن داشبورد ضربه بزنید';

  @override
  String get ordersDetailFromNewBanner =>
      'برای چاپ رسید یا اشتراک‌گذاری فاکتور از نوار ابزار بالا استفاده کنید.';

  @override
  String get ordersComposerPostSaveSubtitle =>
      'چاپ، اشتراک‌گذاری، یا باز کردن جزئیات کامل سفارش.';

  @override
  String get ordersDetailNotFound => 'این سفارش یافت نشد.';

  @override
  String get ordersDetailChangeStatus => 'تغییر وضعیت';

  @override
  String get ordersDetailChangeStatusSubtitle => 'آماده / تحویل‌شده / لغو';

  @override
  String get ordersDetailConfirmTitle => 'تأیید';

  @override
  String ordersDetailConfirmBody(String status) {
    return 'وضعیت به $status تغییر کند؟';
  }

  @override
  String get ordersDetailConfirmCta => 'تأیید';

  @override
  String ordersDetailStatusUpdated(String status) {
    return 'وضعیت به‌روز شد: $status';
  }

  @override
  String get ordersDetailSectionCustomer => 'مشتری';

  @override
  String get ordersDetailSectionMeasurements => 'اندازه‌ها';

  @override
  String get ordersDetailSectionStyle => 'استایل';

  @override
  String get orderStyleDisplayMainStyleLabel => 'استایل';

  @override
  String get orderStyleDisplayShapeLabel => 'شکل';

  @override
  String get orderStyleDisplayTextLabel => 'متن';

  @override
  String get orderStyleDisplayDetailLabel => 'جزئیات';

  @override
  String get orderStyleDisplaySizeLabel => 'سایز';

  @override
  String get orderStyleDisplayNoteLabel => 'یادداشت';

  @override
  String get orderStyleDetailsTitle => 'جزئیات استایل';

  @override
  String get ordersDetailSectionInternalNotes => 'یادداشت داخلی';

  @override
  String get ordersDetailSectionPayments => 'پرداخت‌ها';

  @override
  String get ordersDetailSectionAudit => 'تاریخچه';

  @override
  String get ordersDetailSectionPlaceholder =>
      'جزئیات هنگام تکمیل ماژول اینجا نمایش داده می‌شود.';

  @override
  String get ordersDetailAuditIntro =>
      'اطلاعات محلی روی این دستگاه. تاریخچهٔ تغییر وضعیت هنوز به‌صورت رویداد جدا ثبت نمی‌شود؛ برای زمان‌بندی از بخش پرداخت‌ها استفاده کنید.';

  @override
  String get ordersAuditInternalId => 'شناسهٔ داخلی';

  @override
  String get ordersAuditCopyIdTooltip => 'کپی شناسه';

  @override
  String get ordersAuditCopiedId => 'شناسهٔ سفارش کپی شد';

  @override
  String get ordersAuditCreatedAt => 'ایجاد';

  @override
  String get ordersAuditUpdatedAt => 'آخرین به‌روزرسانی';

  @override
  String get ordersAuditStatus => 'وضعیت';

  @override
  String get ordersAuditDelivery => 'تاریخ تحویل';

  @override
  String get ordersAuditPaymentsTitle => 'دفتر پرداخت‌ها';

  @override
  String get ordersAuditPaymentsEmpty =>
      'هنوز ردیف پرداختی برای این سفارش نیست.';

  @override
  String ordersAuditPaymentsLine(int count, String first, String last) {
    return '$count ردیف پرداخت · قدیمی‌ترین $first · جدیدترین $last';
  }

  @override
  String get ordersDetailSnapshotEmpty => 'چیزی ثبت نشده.';

  @override
  String ordersDetailMeasurementsFromProfile(String label) {
    return 'تصویر بر اساس پروفایل «$label».';
  }

  @override
  String get ordersDetailMeasurementsNotes => 'یادداشت روی سفارش';

  @override
  String get ordersDetailLockedHint =>
      'این سفارش به‌دلیل تحویل یا لغو قفل است.';

  @override
  String get ordersDetailLockedStillInternalNotes =>
      'هنوز می‌توانید یادداشت داخلی زیر را ویرایش کنید.';

  @override
  String get ordersInternalNotesDialogTitle => 'یادداشت داخلی';

  @override
  String get ordersInternalNotesHint =>
      'فقط کارکنان — به مشتری نشان داده نمی‌شود.';

  @override
  String get ordersInternalNotesSaved => 'یادداشت داخلی ذخیره شد.';

  @override
  String get licenseReadOnlyHint =>
      'حالت فقط‌خواندنی: ویرایش هنگام انقضای مجوز غیرفعال است.';

  @override
  String get ownerPasswordTitle => 'رمز مالک';

  @override
  String get ownerPasswordLabel => 'رمز مالک را وارد کنید';

  @override
  String get ownerPasswordMismatch =>
      'این رمز با رمز مالک این دستگاه مطابقت ندارد.';

  @override
  String get ownerPasswordWrong =>
      'رمز مالک اشتباه است. رمز ورود مالک فروشگاه را وارد کنید.';

  @override
  String get ownerPasswordOfflineUnavailable =>
      'تأیید رمز مالک بدون اینترنت ممکن نیست. به اینترنت وصل شوید یا یک‌بار به‌عنوان مالک وارد شوید.';

  @override
  String get ownerPasswordOwnerMissing =>
      'ورود مالک روی این دستگاه ذخیره نشده. یک‌بار به‌عنوان مالک فروشگاه وارد شوید.';

  @override
  String get ordersDetailChangeStatusSoon => 'تغییر وضعیت با تأیید باز می‌شود.';

  @override
  String get addPaymentCta => 'افزودن پرداخت';

  @override
  String get addAdjustmentCta => 'افزودن تعدیل';

  @override
  String get paymentAdjustmentHint =>
      'برای کاهش پرداخت‌های ثبت‌شده مبلغ منفی وارد کنید (دفتر رویداد).';

  @override
  String get paymentLedgerAdjustmentTag => 'تعدیل';

  @override
  String get paymentAdjustmentAdded => 'تعدیل ثبت شد';

  @override
  String get paymentAdded => 'پرداخت افزوده شد';

  @override
  String get paymentsEmpty => 'هنوز پرداختی نیست.';

  @override
  String get paymentAmountLabel => 'مبلغ';

  @override
  String get paymentAmountHint => 'مثال: 300';

  @override
  String paymentAmount(String amount) {
    return 'مبلغ: $amount';
  }

  @override
  String get paymentTotal => 'جمع';

  @override
  String get paymentPaid => 'پرداخت‌شده';

  @override
  String get paymentRemaining => 'مانده';

  @override
  String get customersSearchHint => 'جستجوی نام، تلفن یا شناسه';

  @override
  String get customersEmptyTitle => 'هنوز مشتری نیست';

  @override
  String get customersAddCta => 'افزودن مشتری';

  @override
  String get customersNewOrderCta => 'سفارش جدید';

  @override
  String get customersNewOrderForCustomerTooltip => 'سفارش جدید برای این مشتری';

  @override
  String get ordersNewOrderFromThisOrderTooltip =>
      'ایجاد سفارش جدید از این سفارش';

  @override
  String get customersFilteredEmpty => 'هیچ مشتری با جستجو مطابقت ندارد.';

  @override
  String get customersPhoneMissing => 'بدون تلفن';

  @override
  String get customerProfileTitle => 'مشتری';

  @override
  String get customerNotFound => 'این مشتری یافت نشد.';

  @override
  String get customerInfoSection => 'اطلاعات مشتری';

  @override
  String get customerMeasurementProfilesSection => 'پروفایل‌های اندازه';

  @override
  String get customerTodayOrdersTitle => 'سفارش‌های امروز';

  @override
  String get customerNoTodayOrders => 'برای امروز سفارشی نیست.';

  @override
  String get customerOrderHistoryTitle => 'تاریخچه سفارش‌ها';

  @override
  String get customerNoOrders => 'هنوز سفارشی برای این مشتری نیست.';

  @override
  String get customerViewAllOrders => 'همه سفارش‌های این مشتری';

  @override
  String get customerViewAllOrdersSoon =>
      'با فیلتر مشتری تب سفارش‌ها باز می‌شود.';

  @override
  String get customerSectionPlaceholder =>
      'جزئیات هنگام تکمیل ماژول اینجا نمایش داده می‌شود.';

  @override
  String get customerNewPlaceholderBody => 'فرم مشتری جدید اینجا قرار می‌گیرد.';

  @override
  String get measurementUnitCm => 'سانتی‌متر';

  @override
  String get measurementUnitInch => 'اینچ';

  @override
  String get measurementProfilesEmpty =>
      'هنوز پروفایلی نیست. برای استفاده مجدد در سفارش‌های جدید اضافه کنید.';

  @override
  String get measurementProfilesAddCta => 'افزودن پروفایل';

  @override
  String get measurementProfileEditorTitleNew => 'پروفایل اندازه جدید';

  @override
  String get measurementProfileEditorTitleEdit => 'ویرایش پروفایل اندازه';

  @override
  String get measurementProfileLabelField => 'نام پروفایل';

  @override
  String get measurementProfileBodyField => 'اندازه‌ها';

  @override
  String get measurementProfileNotesField => 'یادداشت اضافی';

  @override
  String get measurementProfileUnitSection => 'واحد';

  @override
  String get measurementProfileSaveAsNew => 'ذخیره به‌عنوان پروفایل جدید';

  @override
  String get measurementProfileCreated => 'پروفایل ذخیره شد';

  @override
  String get measurementProfileUpdated => 'پروفایل به‌روز شد';

  @override
  String get measurementProfilePickSheetTitle => 'پروفایل‌های ذخیره‌شده';

  @override
  String get settingsMeasurementTypesTitle => 'فیلدهای اندازه';

  @override
  String get settingsMeasurementTypesSubtitle =>
      'برچسب‌ها برای پروفایل مشتری و سفارش‌ها';

  @override
  String get settingsMeasurementUnitTitle => 'واحد پیش‌فرض اندازه';

  @override
  String get settingsMeasurementUnitSubtitle =>
      'هنگام ثبت اندازه‌های لباس در سفارش جدید';

  @override
  String get tasksTitle => 'کارها';

  @override
  String get tasksSettingsSubtitle => 'فهرست کارها (آفلاین)';

  @override
  String get tasksSearchHint => 'جستجوی کارها';

  @override
  String get tasksFilterAll => 'همه';

  @override
  String get tasksFilterOpen => 'باز';

  @override
  String get tasksFilterDone => 'انجام‌شده';

  @override
  String get tasksEmpty => 'هنوز کاری نیست. اولین کار را اضافه کنید.';

  @override
  String get tasksEmptyFiltered => 'هیچ کاری با این فیلتر پیدا نشد.';

  @override
  String get tasksAddTitle => 'افزودن کار';

  @override
  String get tasksEditTitle => 'ویرایش کار';

  @override
  String get tasksTitleLabel => 'عنوان';

  @override
  String get tasksNotesLabel => 'یادداشت';

  @override
  String get tasksDueDatePick => 'انتخاب تاریخ سررسید';

  @override
  String get tasksDueDateNone => 'بدون تاریخ سررسید';

  @override
  String get tasksDueDateSet => 'تنظیم';

  @override
  String get tasksDueDateClear => 'پاک کردن تاریخ سررسید';

  @override
  String tasksDueDateShort(String date) {
    return 'سررسید: $date';
  }

  @override
  String tasksDueDateValue(String date) {
    return 'تاریخ سررسید: $date';
  }

  @override
  String get tasksSave => 'ذخیره';

  @override
  String get tasksDeleteAction => 'حذف';

  @override
  String get tasksDeleteTitle => 'کار حذف شود؟';

  @override
  String get tasksDeleteBody => 'این کار از فهرست شما حذف می‌شود.';

  @override
  String get tasksDeleteCancel => 'لغو';

  @override
  String get tasksDeleteConfirm => 'حذف';

  @override
  String get measurementTypesScreenTitle => 'فیلدهای اندازه';

  @override
  String get measurementTypesEmpty =>
      'هنوز فیلدی نیست. اندازه‌هایی که فروشگاه ثبت می‌کند را اضافه کنید.';

  @override
  String get measurementTypesAddCta => 'افزودن فیلد';

  @override
  String get measurementTypesFieldNameLabel => 'نام فیلد';

  @override
  String get measurementTypesRenameTitle => 'تغییر نام فیلد';

  @override
  String get measurementTypesDeleteTitle => 'حذف فیلد؟';

  @override
  String get measurementTypesDeleteBody =>
      'فیلد برای اندازه‌های جدید پنهان می‌شود. مقادیر ذخیره‌شده روی پروفایل‌ها و سفارش‌ها دست‌نخورده می‌ماند.';

  @override
  String get measurementTypesActiveLabel => 'در حال استفاده';

  @override
  String get measurementTypesInactiveLabel => 'پنهان';

  @override
  String get measurementTypesReorderHint => 'برای مرتب‌سازی بکشید';

  @override
  String get measurementTypesCreated => 'فیلد افزوده شد';

  @override
  String get measurementTypesUpdated => 'فیلد به‌روز شد';

  @override
  String get measurementTypesDeleted => 'فیلد حذف شد';

  @override
  String get reportsOverviewTitle => 'گزارش‌ها';

  @override
  String get reportsUnpaidCardTitle => 'پرداخت‌نشده';

  @override
  String reportsUnpaidCardSubtitle(String amount) {
    return 'کل مانده: $amount';
  }

  @override
  String get reportsMonthlyIncomeTitle => 'درآمد ماهانه';

  @override
  String get reportsMonthlyIncomeSubtitle =>
      'پرداخت‌ها و مانده‌ها بر اساس ماه تقویم';

  @override
  String get reportsThisMonthOpenUnpaidTitle => 'سفارش‌های باز پرداخت‌نشده';

  @override
  String reportsThisMonthOpenUnpaidSubtitle(String amount) {
    return 'جدید / در حال انجام / آماده: $amount';
  }

  @override
  String get reportsOrdersSummaryTitle => 'سفارش‌ها بر اساس وضعیت';

  @override
  String get reportsOrdersSummaryEmpty => 'هنوز سفارشی نیست.';

  @override
  String get reportsDeliveredReportTitle => 'تحویل‌شده';

  @override
  String get reportsDeliveredCardTitle => 'سفارش‌های تحویل‌شده';

  @override
  String get reportsDeliveredCardSubtitle => 'بر اساس ماه تحویل';

  @override
  String get reportsDeliveredEmpty => 'در این ماه سفارش تحویل‌شده‌ای نیست.';

  @override
  String get reportsPaymentsLedgerTitle => 'دفتر پرداخت‌ها';

  @override
  String get reportsPaymentsLedgerSubtitle =>
      'فهرست پرداخت‌ها بر اساس بازهٔ تاریخ';

  @override
  String get reportsPaymentsPickRange => 'انتخاب بازهٔ تاریخ';

  @override
  String get reportsPaymentsApplyRange => 'اعمال';

  @override
  String get reportsPaymentsSelectedRangeLabel => 'بازهٔ انتخاب‌شده';

  @override
  String reportsPaymentsRangeValue(String from, String to) {
    return '$from → $to';
  }

  @override
  String get reportsPaymentsTotalLabel => 'جمع';

  @override
  String get reportsPaymentsEmpty => 'در این بازهٔ تاریخ پرداختی وجود ندارد.';

  @override
  String get reportsPaymentsUnknownOrder => 'سفارش نامشخص';

  @override
  String get reportsPaymentsAdjustmentChip => 'اصلاحیه';

  @override
  String reportsPaymentsSectionHeader(String title, String total) {
    return '$title — $total';
  }

  @override
  String reportsPaymentsWeekOfLabel(String weekStart) {
    return 'هفته از $weekStart';
  }

  @override
  String get reportsPaymentsGroupByLabel => 'گروه‌بندی';

  @override
  String get reportsPaymentsGroupByDay => 'روز';

  @override
  String get reportsPaymentsGroupByWeek => 'هفته';

  @override
  String get reportsPaymentsGroupByMonth => 'ماه';

  @override
  String get reportsMonthlyIncomePlaceholder =>
      'گزارش درآمد ماهانه اینجا قرار می‌گیرد.';

  @override
  String get reportsThisMonthIncomeTitle => 'درآمد این ماه';

  @override
  String reportsThisMonthIncomeSubtitle(String amount) {
    return 'درآمد: $amount';
  }

  @override
  String get reportsMonthlyIncomeCardLabel => 'پرداخت‌های دریافت‌شده';

  @override
  String get reportsMonthlyDailyPaymentsLabel => 'پرداخت‌های روزانه (این ماه)';

  @override
  String get reportsMonthlyUnpaidDueTitle => 'پرداخت‌نشده (سررسید این ماه)';

  @override
  String get reportsMonthlyUnpaidDueBody =>
      'جمع مانده‌های سفارش‌هایی که تاریخ تحویل در این ماه است.';

  @override
  String get reportsPrevMonth => 'ماه قبل';

  @override
  String get reportsNextMonth => 'ماه بعد';

  @override
  String get reportsUnpaidTotalLabel => 'کل مانده';

  @override
  String get reportsUnpaidEmpty => 'سفارش پرداخت‌نشده‌ای نیست.';

  @override
  String get reportsUnpaidFilteredEmpty =>
      'هیچ سفارش پرداخت‌نشده‌ای با این فیلتر مطابقت ندارد.';

  @override
  String get reportsUnpaidFilterSection => 'پنجره تحویل';

  @override
  String get reportsUnpaidFilterAll => 'همه';

  @override
  String get reportsUnpaidFilterOverdue => 'معوق';

  @override
  String get reportsUnpaidFilterDueSoon => 'سررسید در ۷ روز';

  @override
  String get reportsUnpaidAmountSection => 'مانده سفارش';

  @override
  String get reportsUnpaidAmountAny => 'هر مبلغ';

  @override
  String get reportsUnpaidAmountUnder5000 => 'زیر ۵٬۰۰۰';

  @override
  String get reportsUnpaidAmount5000to20000 => '۵٬۰۰۰ – ۲۰٬۰۰۰';

  @override
  String get reportsUnpaidAmountOver20000 => 'بالای ۲۰٬۰۰۰';

  @override
  String get reportsUnpaidSortSection => 'مرتب‌سازی';

  @override
  String get reportsUnpaidSortAmount => 'مبلغ';

  @override
  String get reportsUnpaidSortDueDate => 'تاریخ سررسید';

  @override
  String get reportsMonthlyCompareToggle => 'مقایسه با ماه قبل';

  @override
  String get reportsMonthlyPreviousPaymentsLabel => 'ماه قبل (پرداخت‌ها)';

  @override
  String get reportsMonthlyDeltaLabel => 'تغییر نسبت به ماه قبل';

  @override
  String get reportsMonthlyDeltaSame => 'بدون تغییر';

  @override
  String reportsRemainingChip(String amount) {
    return '$amount مانده';
  }

  @override
  String get catalogMyDesigns => 'طرح‌های من';

  @override
  String get catalogSharedDesigns => 'طرح‌های اشتراکی';

  @override
  String get catalogGridView => 'نمای شبکه‌ای';

  @override
  String get catalogListView => 'نمای فهرستی';

  @override
  String get catalogSearchHint => 'جستجوی طرح یا نام فروشگاه';

  @override
  String get catalogSortTooltip => 'مرتب‌سازی';

  @override
  String get catalogSortSheetTitle => 'مرتب‌سازی طرح‌ها';

  @override
  String get catalogSortSectionTitle => 'مرتب‌سازی بر اساس';

  @override
  String get catalogSortNewest => 'جدیدترین';

  @override
  String get catalogSortOldest => 'قدیمی‌ترین';

  @override
  String get catalogSortNameAsc => 'نام الفبایی';

  @override
  String get catalogSortNameDesc => 'نام معکوس';

  @override
  String get catalogResetSort => 'بازنشانی';

  @override
  String get catalogApplySort => 'اعمال';

  @override
  String get catalogSharedDirectoryEmpty => 'هنوز در فهرست اشتراکی موردی نیست.';

  @override
  String get catalogCommunityReadOnlyBanner =>
      'ورودی فهرست اشتراکی — فقط مشاهده. نمی‌توانید فهرست فروشگاه دیگر را ویرایش یا حذف کنید.';

  @override
  String get catalogSharingToggleTitle => 'فعال‌سازی اشتراک کاتالوگ';

  @override
  String get catalogSharingToggleSubtitle =>
      'با رضایت دو طرف: برای مرور و نمایش در فهرست عمومی فعال کنید.';

  @override
  String get catalogSharedPlaceholder =>
      'فهرست طرح‌های اشتراکی هنگام اتصال آنلاین اینجا نمایش داده می‌شود.';

  @override
  String get catalogEmptyMyDesigns => 'هنوز طرحی نیست.';

  @override
  String get catalogAddDesignCta => 'افزودن طرح';

  @override
  String get catalogViewDescription => 'توضیحات';

  @override
  String get catalogDescriptionSheetTitle => 'توضیحات';

  @override
  String get catalogNoDescription => 'توضیحی برای این طرح ثبت نشده است.';

  @override
  String get catalogViewerManageA11y => 'مدیریت طرح';

  @override
  String get catalogAddDesignPlaceholder =>
      'افزودن از دوربین / گالری فقط روی اندروید و iOS.';

  @override
  String get catalogDetailTitle => 'قلم کاتالوگ';

  @override
  String get settingsSectionAccountAndShop => 'حساب و فروشگاه';

  @override
  String get settingsSectionUsers => 'کاربران';

  @override
  String get settingsSectionBackupRestore => 'پشتیبان و بازیابی';

  @override
  String get settingsSectionNotifications => 'اعلان‌ها';

  @override
  String get settingsSectionSyncDiagnostics => 'همگام‌سازی و تشخیص';

  @override
  String get settingsSectionAppearanceLanguage => 'ظاهر و زبان';

  @override
  String get settingsSectionAbout => 'درباره';

  @override
  String get settingsSectionDeveloper => 'توسعه‌دهنده';

  @override
  String get settingsShopTileTitle => 'پروفایل فروشگاه';

  @override
  String get settingsShopTileSubtitle =>
      'جزئیات فروشگاه اینجا نمایش داده می‌شود.';

  @override
  String get settingsCurrentUserTitle => 'حساب';

  @override
  String get settingsAccountTitle => 'حساب';

  @override
  String get settingsAccountUsernameLabel => 'نام کاربری';

  @override
  String get settingsAccountUsernameHint =>
      'نام کاربری را مالک فروشگاه تنظیم می‌کند و اینجا قابل تغییر نیست.';

  @override
  String get settingsAccountRoleLabel => 'نقش';

  @override
  String get settingsAccountChangePasswordTitle => 'تغییر رمز عبور';

  @override
  String get settingsAccountChangePasswordSubtitle =>
      'رمز این حساب را برای ورود بعدی به‌روز کنید.';

  @override
  String get settingsAccountCurrentPasswordLabel => 'رمز فعلی';

  @override
  String get settingsAccountNewPasswordLabel => 'رمز جدید';

  @override
  String get settingsAccountConfirmPasswordLabel => 'تأیید رمز جدید';

  @override
  String get settingsAccountChangePasswordCta => 'به‌روزرسانی رمز';

  @override
  String get settingsAccountChangePasswordOk =>
      'رمز به‌روز شد. دفعه بعد با رمز جدید وارد شوید.';

  @override
  String settingsAccountChangePasswordFail(String error) {
    return 'به‌روزرسانی رمز ناموفق بود: $error';
  }

  @override
  String get settingsAccountPasswordMismatch => 'رمزهای جدید یکسان نیستند.';

  @override
  String get settingsAccountOfflineHint => 'برای تغییر رمز به سرور متصل شوید.';

  @override
  String get settingsAccountForgotPasswordCta =>
      'درخواست بازنشانی رمز از پشتیبانی';

  @override
  String get settingsUsersReadOnlyHint =>
      'فقط مالک فروشگاه می‌تواند کاربر اضافه یا حذف کند.';

  @override
  String get settingsSignOutTitle => 'خروج';

  @override
  String get settingsSignOutSubtitle => 'پایان این نشست روی این دستگاه';

  @override
  String get settingsSignOutDialogTitle => 'خروج؟';

  @override
  String get settingsSignOutDialogBody => 'برای ادامه باید دوباره وارد شوید.';

  @override
  String get settingsSignOutCancel => 'لغو';

  @override
  String get settingsSignOutConfirm => 'خروج';

  @override
  String get settingsRoleOwner => 'مالک';

  @override
  String get settingsRoleUser => 'کاربر';

  @override
  String get settingsOwnerOnly => 'فقط مالک';

  @override
  String get settingsUsersTitle => 'مدیریت کاربران';

  @override
  String get settingsUsersSubtitleOwner =>
      'آزمایشی: ۲ کاربر • پرداخت‌شده: ۵ کاربر';

  @override
  String get settingsUsersPlaceholder => 'مدیریت کاربران پیاده می‌شود.';

  @override
  String get settingsBackupRestoreTitle => 'پشتیبان و بازیابی';

  @override
  String get settingsBackupRestoreSubtitleOwner =>
      'خروجی امن و بازیابی دادهٔ فروشگاه';

  @override
  String get settingsBackupRestorePlaceholder =>
      'پشتیبان/بازیابی پیاده می‌شود.';

  @override
  String get settingsMuteNotificationsTitle => 'بی‌صدا کردن اعلان‌ها';

  @override
  String get settingsMuteNotificationsSubtitle =>
      'بی‌صدا کردن بنر و نشان (تاریخچه حفظ می‌شود).';

  @override
  String get settingsNotificationsInboxTitle => 'صندوق اعلان‌ها';

  @override
  String get settingsNotificationsInboxSubtitle => 'تاریخچه و فیلترها.';

  @override
  String get settingsNotificationsPlaceholder => 'صندوق اعلان‌ها پیاده می‌شود.';

  @override
  String get settingsSyncDiagnosticsTitle => 'همگام‌سازی و تشخیص';

  @override
  String get settingsNetworkStatusTitle => 'شبکه';

  @override
  String get settingsNetworkStatusOnline => 'متصل';

  @override
  String get settingsNetworkStatusOffline => 'آفلاین — کار محلی';

  @override
  String get settingsApiServerTitle => 'سرور API';

  @override
  String get settingsApiServerNotConfigured =>
      'آدرس تنظیم نشده. هنگام اجرا یا بیلد از --dart-define=API_BASE_URL=https://... استفاده کنید.';

  @override
  String settingsApiServerConfigured(String url) {
    return 'آدرس پایه: $url';
  }

  @override
  String get settingsApiTestConnection => 'آزمایش اتصال';

  @override
  String get settingsApiTestNeedOnline =>
      'برای آزمایش سرور به اینترنت وصل شوید.';

  @override
  String get settingsApiHealthOk => 'سرور پاسخ داد (GET /health).';

  @override
  String settingsApiHealthFailed(String message) {
    return 'سرور در دسترس نیست: $message';
  }

  @override
  String get settingsSyncDiagnosticsSubtitle =>
      'آخرین همگام‌سازی، صف، صندوق خروج.';

  @override
  String get settingsSyncDiagnosticsPlaceholder =>
      'همگام‌سازی و تشخیص پیاده می‌شود.';

  @override
  String get settingsAppearanceLanguageTitle => 'ظاهر و زبان';

  @override
  String get settingsAppearanceLanguageSubtitle => 'پوسته و زبان';

  @override
  String get settingsAboutTitle => 'درباره';

  @override
  String get settingsAboutSubtitle => 'اطلاعات برنامه و نسخه';

  @override
  String get settingsVersionTitle => 'نسخه';

  @override
  String get settingsBuildTitle => 'بسته';

  @override
  String get settingsDeveloperPortalTitle => 'پورتال توسعه‌دهنده';

  @override
  String get settingsDeveloperPortalSubtitle =>
      'ابزارهای پیشرفته (فقط حساب‌های توسعه‌دهنده).';

  @override
  String get settingsDeveloperPortalPlaceholder =>
      'صفحات پورتال توسعه‌دهنده پیاده می‌شود.';

  @override
  String get settingsDevRolesTitle => 'سوئیچ‌های نقش (توسعه)';

  @override
  String get settingsDevRoleOwnerTitle => 'شبیه‌سازی حساب مالک';

  @override
  String get settingsDevRoleOwnerSubtitle => 'بخش‌های فقط مالک را باز می‌کند.';

  @override
  String get settingsDevRoleDeveloperTitle => 'شبیه‌سازی حساب توسعه‌دهنده';

  @override
  String get settingsDevRoleDeveloperSubtitle =>
      'ورودی پورتال توسعه‌دهنده را نشان می‌دهد.';

  @override
  String get settingsThemeTitle => 'پوسته';

  @override
  String get settingsFontSizeTitle => 'اندازه قلم';

  @override
  String get settingsFontSizeSmall => 'کوچک';

  @override
  String get settingsFontSizeMedium => 'متوسط';

  @override
  String get settingsFontSizeLarge => 'بزرگ';

  @override
  String get settingsFontFamilyTitle => 'قلم';

  @override
  String get settingsFontFamilyVazirmatn => 'وزیرمتن';

  @override
  String get settingsFontFamilyNotoNaskh => 'نوتو نسخ';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

  @override
  String get settingsSectionSoundFeedback => 'صدا و بازخورد';

  @override
  String get settingsUiSoundsTitle => 'صداهای رابط';

  @override
  String get settingsUiSoundsSubtitle =>
      'صدای کوتاه هنگام ذخیره، حذف یا تکمیل عملیات.';

  @override
  String get settingsUiHapticsTitle => 'لرزش لمسی';

  @override
  String get settingsUiHapticsSubtitle => 'لرزش سبک برای عملیات موفق.';

  @override
  String get settingsUiHapticsWebHint => 'لرزش در وب در دسترس نیست.';

  @override
  String get settingsSoundPreviewSuccess => 'موفق';

  @override
  String get settingsSoundPreviewError => 'خطا';

  @override
  String get settingsSoundPreviewDelete => 'حذف';

  @override
  String get ordersDetailPaymentProgress => 'پیشرفت پرداخت';

  @override
  String get ordersComposerProgressTitle => 'پیشرفت سفارش';

  @override
  String ordersComposerProgressCount(int done, int total) {
    return '$done از $total مرحله';
  }

  @override
  String get ordersComposerProgressCustomer => 'مشتری';

  @override
  String get ordersComposerProgressMeasurements => 'اندازه';

  @override
  String get ordersComposerProgressStyle => 'استایل';

  @override
  String get ordersComposerProgressFabric => 'پارچه';

  @override
  String get ordersComposerProgressDelivery => 'تحویل';

  @override
  String get ordersComposerProgressPayment => 'پرداخت';

  @override
  String get settingsLanguageTitle => 'زبان';

  @override
  String get languageSystem => 'سیستم';

  @override
  String get languageEnglish => 'انگلیسی';

  @override
  String get languageDari => 'دری';

  @override
  String get languagePashto => 'پشتو';

  @override
  String get settingsDateCalendarTitle => 'تقویم تاریخ';

  @override
  String get settingsDateCalendarSubtitle =>
      'نحوهٔ نمایش و انتخاب تاریخ در برنامه';

  @override
  String get dateCalendarGregorian => 'میلادی (میلادی غربی)';

  @override
  String get dateCalendarSolarHijri => 'هجری شمسی (افغانستان)';

  @override
  String get calendarMonthHamal => 'حمل';

  @override
  String get calendarMonthSawr => 'ثور';

  @override
  String get calendarMonthJawza => 'جوزا';

  @override
  String get calendarMonthSaratan => 'سرطان';

  @override
  String get calendarMonthAsad => 'اسد';

  @override
  String get calendarMonthSonbola => 'سنبله';

  @override
  String get calendarMonthMizan => 'میزان';

  @override
  String get calendarMonthAqrab => 'عقرب';

  @override
  String get calendarMonthQaws => 'قوس';

  @override
  String get calendarMonthJadi => 'جدی';

  @override
  String get calendarMonthDalw => 'دلو';

  @override
  String get calendarMonthHut => 'حوت';

  @override
  String get datePickerSolarHijriTitle => 'انتخاب تاریخ (هجری شمسی)';

  @override
  String get datePickerSolarHijriRangeTitle => 'انتخاب بازهٔ تاریخ (هجری شمسی)';

  @override
  String get datePickerYearLabel => 'سال';

  @override
  String get datePickerMonthLabel => 'ماه';

  @override
  String get datePickerDayLabel => 'روز';

  @override
  String get dateRangeFromLabel => 'از';

  @override
  String get dateRangeToLabel => 'تا';

  @override
  String get loading => 'در حال بارگذاری…';

  @override
  String get showMoreCta => 'نمایش بیشتر';

  @override
  String get showLessCta => 'نمایش کمتر';

  @override
  String get genericError => 'خطایی رخ داد.';

  @override
  String get resetCta => 'بازنشانی';

  @override
  String get licenseGraceReadOnlySnack => 'فقط‌خواندنی تا تأیید مجوز آنلاین.';

  @override
  String get licenseClockTamperSnack =>
      'فقط‌خواندنی: زمان دستگاه نامعتبر به‌نظر می‌رسد. آنلاین اشتراک را باز کنید و تأیید کنید.';

  @override
  String get licenseExpiredReadOnly => 'مجوز منقضی — حالت فقط‌خواندنی.';

  @override
  String moneyAfn(String amount) {
    return '$amount افغانی';
  }

  @override
  String get ordersComposerOrderItemsTitle => 'اقلام سفارش';

  @override
  String ordersComposerOrderItemsSelectedCount(int count) {
    return '$count قلم انتخاب شده';
  }

  @override
  String get garmentPerahanTunban => 'پیراهن‌تنبان';

  @override
  String get garmentWaistcoat => 'واسکت';

  @override
  String get ordersComposerItemPriceLabel => 'قیمت قلم';

  @override
  String get ordersComposerItemPriceRequired => 'قیمت قلم را وارد کنید';

  @override
  String get ordersComposerItemReady => 'آماده';

  @override
  String get ordersComposerAddWaistcoatCta => 'افزودن واسکت';

  @override
  String get ordersComposerAddPerahanTunbanCta => 'افزودن پیراهن‌تنبان';

  @override
  String get ordersComposerNoItemsError => 'حداقل یک قلم سفارش را انتخاب کنید';

  @override
  String get ordersComposerItemBreakdownTitle => 'جزئیات قیمت اقلام';

  @override
  String get ordersComposerUseSameFabricCta => 'استفاده از همان پارچه';

  @override
  String get ordersComposerCustomerTitle => 'مشتری';

  @override
  String get ordersComposerCustomerRequired => 'مشتری را انتخاب کنید (الزامی)';

  @override
  String get ordersComposerMeasurementsTitle => 'اندازه‌ها';

  @override
  String get ordersComposerMeasurementsRequired =>
      'اندازه‌ها را اضافه کنید (الزامی)';

  @override
  String get ordersComposerMeasurementsSummary => 'اندازه‌ها ثبت شد';

  @override
  String get ordersComposerMeasurementsLabel => 'یادداشت اندازه‌ها';

  @override
  String get ordersComposerMeasurementsHint =>
      'اندازه‌ها را تایپ کنید یا پروفایل مشتری را بارگذاری کنید.';

  @override
  String get ordersComposerLoadProfileCta => 'بارگذاری از پروفایل ذخیره‌شده';

  @override
  String ordersComposerProfileLinked(String name) {
    return 'از پروفایل: $name';
  }

  @override
  String get ordersComposerPaymentTitle => 'پرداخت';

  @override
  String get ordersComposerPaymentRequired => 'جمع‌ها را وارد کنید (الزامی)';

  @override
  String ordersComposerPaymentSummary(
    String total,
    String paid,
    String remaining,
  ) {
    return 'جمع $total • پرداخت $paid • مانده $remaining';
  }

  @override
  String get ordersComposerTotalLabel => 'مبلغ کل (افغانی)';

  @override
  String get ordersComposerTotalHint => 'مثال: 1500';

  @override
  String get ordersComposerPaidLabel => 'پرداخت اولیه (افغانی)';

  @override
  String get ordersComposerPaidHint => 'مثال: 500';

  @override
  String get ordersComposerPriceLabel => 'قیمت کار چقدر است؟ (افغانی)';

  @override
  String get ordersComposerPriceHint => 'مثال: 5000';

  @override
  String get ordersComposerReceivedNowLabel => 'مشتری الان چقدر داد؟ (افغانی)';

  @override
  String get ordersComposerReceivedNowHint => '۰ اگر هنوز نداده';

  @override
  String get ordersComposerNewOrderPaymentHint =>
      'فقط عدد بنویسید. اگر همه را گرفتید «تمام پرداخت» را بزنید.';

  @override
  String get ordersComposerPaidInFullCta => 'تمام پرداخت';

  @override
  String get ordersComposerNothingPaidCta => 'هنوز نداده';

  @override
  String get ordersComposerDueLabel => 'مانده';

  @override
  String get ordersComposerStillOwedLabel => 'باقی‌مانده';

  @override
  String get ordersComposerPaymentSheetTitle => 'پرداخت';

  @override
  String get ordersComposerPaymentCancelCta => 'لغو';

  @override
  String get ordersComposerPaymentInitialOnSaveHint =>
      'وقتی سفارش را ذخیره می‌کنید، پولی که مشتری داد ثبت می‌شود.';

  @override
  String get ordersPaymentInitialExceedsTotal =>
      'پرداخت اولیه نمی‌تواند از جمع سفارش بیشتر باشد.';

  @override
  String get ordersPaymentExceedsRemaining =>
      'پرداخت نمی‌تواند از مانده بیشتر باشد.';

  @override
  String get ordersPaymentTotalBelowPaid =>
      'جمع سفارش نمی‌تواند از مبلغ پرداخت‌شده کمتر باشد.';

  @override
  String get ordersPaymentSheetSavedTitle => 'پرداخت‌ها';

  @override
  String get ordersPaymentSheetEditTitle => 'ویرایش پرداخت‌ها';

  @override
  String get ordersPaymentHistoryTitle => 'سابقه پرداخت‌ها';

  @override
  String get paymentMethodCash => 'نقد';

  @override
  String get ordersPaymentSignedHint =>
      'برای افزودن عدد مثبت وارد کنید. برای کسر از این فیلد منفی بزنید (مثلاً -500).';

  @override
  String ordersPaymentDepositLabel(int n) {
    return 'پرداخت $n';
  }

  @override
  String get ordersPaymentNextPaymentLabel => 'پرداخت بعدی';

  @override
  String get ordersPaymentRecordCta => 'ثبت';

  @override
  String get ordersPaymentNegativeInvalid => 'مبلغ نمی‌تواند کمتر از صفر شود.';

  @override
  String get ordersPaymentNextMustBePositive =>
      'پرداخت بعدی باید مبلغ مثبت باشد.';

  @override
  String get ordersEditConfirmTitle => 'تغییرات ذخیره شود؟';

  @override
  String get ordersEditConfirmBody =>
      'این سفارش با تغییرات شما به‌روزرسانی شود؟';

  @override
  String get ordersDetailEditCustomerTitle => 'ویرایش مشتری';

  @override
  String get ordersDetailCustomerPickFromList => 'انتخاب از فهرست';

  @override
  String get ordersDetailCustomerHistoryTitle => 'تاریخچهٔ تغییر مشتری';

  @override
  String ordersDetailCustomerHistoryChange(
    String fromName,
    String fromPhone,
    String toName,
    String toPhone,
  ) {
    return 'قبلاً $fromName ($fromPhone) → اکنون $toName ($toPhone)';
  }

  @override
  String get ordersStatusChangeConfirmTitle => 'وضعیت تغییر کند؟';

  @override
  String ordersStatusChangeConfirmBody(String status) {
    return 'وضعیت سفارش به $status تغییر کند؟';
  }

  @override
  String get ordersCancelOrderConfirmTitle => 'این سفارش لغو شود؟';

  @override
  String get ordersCancelOrderConfirmBody =>
      'برای تأیید لغو، نام مشتری را تایپ کنید.';

  @override
  String get ordersDetailEditCta => 'ویرایش';

  @override
  String get ordersComposerDeliveryDateTitle => 'تاریخ تحویل';

  @override
  String get ordersComposerDeliveryDateUnset => 'تاریخ تحویل را انتخاب کنید';

  @override
  String get ordersComposerSaveCta => 'ذخیره سفارش';

  @override
  String get ordersComposerSaved => 'سفارش ذخیره شد.';

  @override
  String get ordersComposerResetTitle => 'بازنشانی فرم؟';

  @override
  String get ordersComposerResetBody => 'همه فیلدهای واردشده پاک می‌شود.';

  @override
  String get ordersComposerSelectCustomerFirstTitle =>
      'ابتدا مشتری را انتخاب کنید';

  @override
  String get ordersComposerSelectCustomerFirstBody =>
      'لطفاً پیش از ادامه مشتری را انتخاب کنید.';

  @override
  String get ordersComposerValidationTitle => 'مراحل الزامی را تکمیل کنید';

  @override
  String get ordersComposerValidationBody =>
      'قبل از ذخیرهٔ این سفارش موارد زیر را پر کنید:';

  @override
  String get ordersComposerRecentOrdersTitle => 'سفارش‌های اخیر';

  @override
  String get ordersComposerRecentOrdersSubtitle => 'برای این مشتری';

  @override
  String ordersComposerRecentOrderRowSubtitle(String date, String remaining) {
    return '$date • مانده $remaining';
  }

  @override
  String get ordersComposerPreviousOrderTitle => 'سفارش قبلی';

  @override
  String get ordersComposerPreviousOrderSubtitle =>
      'فقط مرجع — هنوز ذخیره نشده';

  @override
  String get ordersComposerNoPreviousOrders => 'سفارش قبلی برای این مشتری نیست';

  @override
  String get ordersComposerUsePreviousMeasurementsCta =>
      'استفاده از اندازه‌های قبلی';

  @override
  String get ordersComposerUsePreviousStyleCta => 'استفاده از استایل قبلی';

  @override
  String get ordersComposerUsePreviousFabricCta => 'استفاده از پارچه قبلی';

  @override
  String get ordersComposerUsePreviousDesignCta => 'استفاده از طراحی قبلی';

  @override
  String get ordersComposerPreviousValueLabel => 'قبلی';

  @override
  String get ordersComposerCurrentValueLabel => 'فعلی';

  @override
  String get ordersComposerCompareWithPrevious => 'مقایسه با سفارش قبلی';

  @override
  String get ordersComposerChangeReferenceOrderCta => 'تغییر سفارش مرجع';

  @override
  String get ordersComposerPreviousDeliveryLabel => 'تحویل قبلی';

  @override
  String get ordersComposerPreviousPaymentLabel => 'خلاصه پرداخت قبلی';

  @override
  String get ordersComposerPreviousMeasurementsUnavailable =>
      'اندازه‌های قبلی هنوز در دسترس نیست. لحظه‌ای دیگر دوباره امتحان کنید.';

  @override
  String get ordersComposerMeasurementsSheetTitle => 'اندازه‌ها';

  @override
  String get ordersComposerMeasurementsNoTypesBody =>
      'ابتدا انواع اندازه را در تنظیمات ← انواع اندازه اضافه کنید.';

  @override
  String ordersComposerMeasurementsProfileAutoLabel(String date) {
    return 'الگو #$date';
  }

  @override
  String get ordersComposerSaveMeasurementsToProfile =>
      'ذخیره به‌عنوان پروفایل مشتری';

  @override
  String get ordersComposerSaveMeasurementsToProfileSubtitle =>
      'اندازه‌های ذخیره‌شدهٔ مشتری انتخاب‌شده به‌روز می‌شود.';

  @override
  String get ordersComposerAddMeasurementsCta => 'افزودن اندازه‌ها';

  @override
  String get ordersComposerStyleTitle => 'استایل';

  @override
  String get ordersComposerFabricTitle => 'پارچه مشتری';

  @override
  String get ordersComposerFabricOptional =>
      'اختیاری — پارچه‌ای که مشتری می‌آورد';

  @override
  String ordersComposerFabricSummary(String name, String color, String id) {
    return '$name • $color • شناسه $id';
  }

  @override
  String ordersComposerFabricPartialSummary(String name, String color) {
    return '$name • $color';
  }

  @override
  String get ordersComposerFabricUnset => 'پارچه ثبت نشده';

  @override
  String get ordersComposerFabricSheetTitle => 'پارچه مشتری';

  @override
  String get ordersComposerFabricNameLabel => 'نام پارچه';

  @override
  String get ordersComposerFabricNameHint => 'انتخاب یا تایپ';

  @override
  String get ordersComposerFabricColorLabel => 'رنگ پارچه';

  @override
  String get ordersComposerFabricColorHint => 'انتخاب یا تایپ';

  @override
  String get ordersComposerFabricIdLabel => 'شناسه پارچه';

  @override
  String get ordersComposerFabricIdHint => 'با ذخیره به‌طور خودکار داده می‌شود';

  @override
  String get ordersComposerFabricClearCta => 'پاک کردن پارچه';

  @override
  String get ordersComposerStyleRequired => 'استایل را اضافه کنید (الزامی)';

  @override
  String get ordersComposerStyleSummary => 'استایل انتخاب شد';

  @override
  String get ordersComposerStyleSheetTitle => 'استایل سفارش';

  @override
  String get ordersComposerStyleMainTitle => 'نام استایل لباس';

  @override
  String get ordersComposerStyleCustomLabel => 'نام استایل';

  @override
  String get ordersComposerStyleCustomHint => 'از بالا انتخاب کنید یا بنویسید';

  @override
  String get ordersComposerStyleFiguresTitle => 'شکل‌های طرح';

  @override
  String get ordersComposerStyleNoFigures =>
      'هنوز شکل طرح نیست — در تنظیمات → استایل سفارش اضافه کنید.';

  @override
  String get ordersComposerStyleClearFigures => 'پاک کردن همه انتخاب‌ها';

  @override
  String get ordersComposerShapeNoTextOptions => 'گزینه متنی پیکربندی نشده';

  @override
  String get ordersComposerShapeNoSizeOptions => 'گزینه اینچ پیکربندی نشده';

  @override
  String get ordersComposerShapeInactiveHint =>
      'در تنظیمات غیرفعال — برای این سفارش حفظ می‌شود';

  @override
  String get ordersComposerShapeDetailTitle => 'جزئیات';

  @override
  String get ordersComposerShapeInchTitle => 'اینچ';

  @override
  String get ordersComposerShapeNoteLabel => 'یادداشت شکل';

  @override
  String get ordersComposerShapeNoteHint => 'یادداشت اختیاری برای این شکل';

  @override
  String get ordersComposerShapeRemoveShape => 'حذف شکل';

  @override
  String get ordersComposerShapeNoDetailOptions => 'گزینه جزئیات تنظیم نشده.';

  @override
  String get ordersComposerShapeNoInchOptions => 'گزینه اینچ تنظیم نشده.';

  @override
  String get ordersComposerCatalogDesignTitle => 'طرح کامل از کاتالوگ';

  @override
  String get ordersComposerCatalogDesignNone => 'طرح کاتالوگ انتخاب نشده';

  @override
  String get ordersComposerCatalogChooseCta => 'انتخاب از کاتالوگ';

  @override
  String get ordersComposerCatalogClearCta => 'پاک کردن طرح';

  @override
  String get ordersComposerCatalogPickerTitle => 'طرح‌های من';

  @override
  String get ordersComposerCatalogPickerEmpty =>
      'هنوز طرحی در کاتالوگ شما نیست. در تب کاتالوگ طرح اضافه کنید.';

  @override
  String get customerLastCatalogDesignLabel => 'آخرین طرح کاتالوگ';

  @override
  String get orderDetailCatalogDesignTitle => 'طرح کامل';

  @override
  String get receiptCatalogDesignLabel => 'طرح';

  @override
  String get invoiceCatalogDesignLabel => 'طرح کاتالوگ';

  @override
  String get invoiceCatalogDesignerLabel => 'طراح';

  @override
  String get invoiceDesignSectionTitle => 'طراحی و استایل';

  @override
  String get invoiceStyleFiguresLabel => 'اشکال استایل';

  @override
  String get settingsStyleHubTitle => 'استایل سفارش';

  @override
  String get settingsStyleTileTitle => 'استایل سفارش';

  @override
  String get settingsStyleTileSubtitle => 'نام‌های استایل و شکل‌های طرح';

  @override
  String get settingsFabricHubTitle => 'پارچه مشتری';

  @override
  String get settingsFabricHubSubtitle =>
      'نام و رنگ از پیش‌تعریف برای سفارش‌ها';

  @override
  String get settingsFabricNamesTitle => 'نام پارچه‌ها';

  @override
  String get settingsFabricNamesSubtitle => 'پنبه، پشم و انواع دیگر';

  @override
  String get settingsFabricNamesEmpty => 'هنوز نامی نیست.';

  @override
  String get settingsFabricNameAddCta => 'افزودن نام پارچه';

  @override
  String get settingsFabricNameFieldLabel => 'نام';

  @override
  String get settingsFabricNameRenameTitle => 'تغییر نام';

  @override
  String get settingsFabricNameDeleteTitle => 'نام پارچه حذف شود؟';

  @override
  String get settingsFabricNameDeleteBody =>
      'از فهرست حذف می‌شود. سفارش‌های قبلی تغییر نمی‌کنند.';

  @override
  String get settingsFabricColorsTitle => 'رنگ پارچه‌ها';

  @override
  String get settingsFabricColorsSubtitle => 'سرمه‌ای، کرم و رنگ‌های دیگر';

  @override
  String get settingsFabricColorsEmpty => 'هنوز رنگی نیست.';

  @override
  String get settingsFabricColorAddCta => 'افزودن رنگ';

  @override
  String get settingsFabricColorFieldLabel => 'رنگ';

  @override
  String get settingsFabricColorRenameTitle => 'تغییر رنگ';

  @override
  String get settingsFabricColorDeleteTitle => 'رنگ حذف شود؟';

  @override
  String get settingsFabricColorDeleteBody =>
      'از فهرست حذف می‌شود. سفارش‌های قبلی تغییر نمی‌کنند.';

  @override
  String get settingsFabricActiveLabel => 'فعال';

  @override
  String get settingsFabricInactiveLabel => 'مخفی';

  @override
  String get settingsStyleNamesTitle => 'نام‌های استایل لباس';

  @override
  String get settingsStyleNamesSubtitle => 'قاسمی، کندهاری و نام‌های دیگر';

  @override
  String get settingsStyleNamesEmpty => 'هنوز نامی نیست.';

  @override
  String get settingsStyleNameAddCta => 'افزودن نام';

  @override
  String get settingsStyleNameFieldLabel => 'نام';

  @override
  String get settingsStyleNameRenameTitle => 'تغییر نام';

  @override
  String get settingsStyleNameDeleteTitle => 'حذف نام؟';

  @override
  String get settingsStyleNameDeleteBody =>
      'از فهرست حذف می‌شود. سفارش‌های قبلی تغییر نمی‌کنند.';

  @override
  String get settingsStylePartsTitle => 'قسمت‌های لباس';

  @override
  String get settingsStylePartsSubtitle => 'آستین، یقه، جیب و غیره';

  @override
  String get settingsStylePartsEmpty => 'هنوز قسمتی نیست.';

  @override
  String get settingsStylePartAddCta => 'افزودن قسمت';

  @override
  String get settingsStylePartFieldLabel => 'نام قسمت';

  @override
  String get settingsStylePartRenameTitle => 'تغییر نام قسمت';

  @override
  String get settingsStylePartDeleteTitle => 'حذف قسمت؟';

  @override
  String get settingsStylePartDeleteBody => 'شکل‌های این قسمت هم حذف می‌شوند.';

  @override
  String get settingsStyleFiguresTitle => 'شکل‌های طرح';

  @override
  String get settingsStyleFiguresSubtitle =>
      'نام شکل، گزینه‌های متن و اندازه اینچ';

  @override
  String get settingsStyleFiguresEmpty => 'هنوز شکل طرح نیست.';

  @override
  String get settingsStyleFigurePartLabel => 'قسمت لباس';

  @override
  String get settingsStyleFigureAddCta => 'افزودن شکل';

  @override
  String get settingsStyleFigureNameLabel => 'نام شکل';

  @override
  String get settingsStyleFigureDeleteTitle => 'حذف شکل؟';

  @override
  String get settingsStyleFigureDeleteBody => 'از فهرست طرح‌ها حذف می‌شود.';

  @override
  String get settingsStyleFigureWebOnlyBody =>
      'افزودن تصویر سفارشی روی اندروید و iOS است. شکل‌های پیش‌فرض در وب کار می‌کنند.';

  @override
  String get settingsStyleFigureTapToConfigure => 'برای پیکربندی لمس کنید';

  @override
  String get settingsStyleFigureDetailTitle => 'پیکربندی شکل';

  @override
  String get settingsStyleFigurePreviewTitle => 'پیش‌نمایش شکل';

  @override
  String get settingsStyleFigureNotFound => 'شکل یافت نشد.';

  @override
  String get settingsStyleFigureSaved => 'تنظیمات شکل ذخیره شد.';

  @override
  String get settingsStyleFigureActiveLabel => 'فعال';

  @override
  String get settingsStyleFigureBundledHint =>
      'شکل‌های پیش‌فرض حذف نمی‌شوند. در صورت نیاز غیرفعال کنید.';

  @override
  String get settingsStyleFigureBundledDeleteBlocked =>
      'شکل‌های پیش‌فرض حذف نمی‌شوند. به جای آن غیرفعال کنید.';

  @override
  String settingsStyleFigureNameHelper(String name) {
    return 'نام نمایشی: $name';
  }

  @override
  String get settingsStyleFigureTextOptionsTitle => 'گزینه‌های جزئیات';

  @override
  String get settingsStyleFigureTextOptionsEmpty => 'هنوز گزینه جزئیاتی نیست.';

  @override
  String get settingsStyleFigureTextOptionAddCta => 'افزودن جزئیات';

  @override
  String get settingsStyleFigureTextOptionEditTitle => 'ویرایش جزئیات';

  @override
  String get settingsStyleFigureTextOptionLabelField => 'نام جزئیات';

  @override
  String get settingsStyleFigureTextOptionDeleteTitle => 'حذف گزینه متن؟';

  @override
  String get settingsStyleFigureTextOptionDeleteBody =>
      'از فهرست حذف می‌شود. سفارش‌های قبلی تغییر نمی‌کنند.';

  @override
  String get settingsStyleFigureSizeOptionsTitle => 'گزینه‌های اینچ';

  @override
  String get settingsStyleFigureSizeOptionsEmpty => 'هنوز گزینه اینچ نیست.';

  @override
  String get settingsStyleFigureSizeOptionAddCta => 'افزودن اینچ';

  @override
  String get settingsStyleFigureSizeOptionEditTitle => 'ویرایش اینچ';

  @override
  String get settingsStyleFigureSizeOptionLabelField => 'برچسب';

  @override
  String get settingsStyleFigureValueInchesLabel => 'مقدار اینچ';

  @override
  String get settingsStyleFigureSizeOptionDeleteTitle => 'حذف گزینه اینچ؟';

  @override
  String get settingsStyleFigureSizeOptionDeleteBody =>
      'از فهرست حذف می‌شود. سفارش‌های قبلی تغییر نمی‌کنند.';

  @override
  String get settingsStyleFigureLabelRequired => 'نام جزئیات الزامی است.';

  @override
  String get settingsStyleFigureValuePositiveRequired =>
      'اندازه معتبر وارد کنید، مثلاً 5 1/2 x 7 1/2 inch.';

  @override
  String get settingsStyleActiveLabel => 'فعال';

  @override
  String get settingsStyleInactiveLabel => 'غیرفعال';

  @override
  String get saveCta => 'ذخیره';

  @override
  String get customersCreated => 'مشتری ایجاد شد.';

  @override
  String get customerIdLabel => 'شناسه مشتری';

  @override
  String get customerIdShortLabel => 'شناسه';

  @override
  String customersIdPrefix(String number) {
    return 'شناسه $number';
  }

  @override
  String get customerNameLabel => 'نام';

  @override
  String get customerNameHint => 'مثال: احمد کریمی';

  @override
  String get customerNameRequired => 'نام الزامی است.';

  @override
  String get customerNameTooShort => 'نام بسیار کوتاه است.';

  @override
  String get customerPhoneLabel => 'تلفن (اختیاری)';

  @override
  String get customerPhoneHint => 'مثال: 0700000001';

  @override
  String get saved => 'ذخیره شد.';

  @override
  String get deleted => 'حذف شد.';

  @override
  String get editCta => 'ویرایش';

  @override
  String get deleteCta => 'حذف';

  @override
  String deleteByTypingConfirmHint(String expected) {
    return 'برای تأیید «$expected» را در زیر بنویسید.';
  }

  @override
  String get deleteByTypingConfirmFieldLabel => 'تأیید';

  @override
  String get deleteByTypingConfirmMismatch =>
      'مطابقت ندارد. املا را بررسی کنید.';

  @override
  String get deleteConfirmTitle => 'حذف؟';

  @override
  String get deleteConfirmBody => 'این عمل قابل بازگشت نیست.';

  @override
  String get catalogItemNotFound => 'این قلم کاتالوگ یافت نشد.';

  @override
  String get catalogEditMetadataTitle => 'ویرایش اطلاعات';

  @override
  String get catalogDesignNameLabel => 'نام طرح';

  @override
  String get catalogDesignNameHint => 'مثال: کت کرزی';

  @override
  String get catalogDesignerNameLabel => 'نام خیاط / دوخت‌خانه';

  @override
  String get catalogDesignerNameHint => 'نامی که روی طرح نمایش داده می‌شود';

  @override
  String get catalogNotesLabel => 'یادداشت (اختیاری)';

  @override
  String get catalogNotesHint => 'هر جزئیاتی که می‌خواهید به‌خاطر بسپارید…';

  @override
  String catalogDeleteConfirmBody(String name) {
    return '«$name» حذف شود؟';
  }

  @override
  String catalogDesignerAndDate(String shop, String date) {
    return '$shop • $date';
  }

  @override
  String get catalogSharePublicTitle => 'اشتراک عمومی';

  @override
  String get catalogSharePublicSubtitle =>
      'در صورت فعال بودن، این طرح می‌تواند در فهرست عمومی (فقط دادهٔ توصیفی) نمایش داده شود.';

  @override
  String get catalogSharePublicDisabledSubtitle =>
      'برای استفاده، اشتراک کاتالوگ را در بخش کاتالوگ فعال کنید.';

  @override
  String get catalogNotesTitle => 'یادداشت‌ها';

  @override
  String get catalogNotesEmpty => 'یادداشتی نیست';

  @override
  String get catalogAddNotAvailableOnWeb => 'در وب افزودن تصویر ممکن نیست.';

  @override
  String get catalogDesignNameRequired => 'نام طرح الزامی است.';

  @override
  String get catalogImageRequired => 'لطفاً ابتدا تصویر انتخاب کنید.';

  @override
  String get catalogCreated => 'طرح افزوده شد.';

  @override
  String get catalogMyShopNameFallback => 'فروشگاه من';

  @override
  String get cameraCta => 'دوربین';

  @override
  String get galleryCta => 'گالری';

  @override
  String get dashboardKpisSectionTitle => 'در یک نگاه';

  @override
  String get dashboardQuickLinksTitle => 'میانبرها';

  @override
  String get dashboardThisMonthIncomeTitle => 'درآمد این ماه';

  @override
  String get dashboardLicenseExpiredBanner =>
      'مجوز شما منقضی شده است. برای ویرایش مجدد تمدید کنید.';

  @override
  String get dashboardLicenseGraceBanner =>
      'از آخرین تأیید مجوز توسط سرور مدت زیادی آفلاین بوده‌اید. اشتراک را باز کنید و آنلاین تازه‌سازی کنید.';

  @override
  String get dashboardLicenseClockTamperBanner =>
      'زمان دستگاه ممکن است دستکاری شده باشد. آنلاین شوید و در اشتراک، مجوز را تازه‌سازی کنید تا ویرایش ادامه یابد.';

  @override
  String get dashboardTodayDeliveriesTitle => 'تحویل امروز';

  @override
  String get dashboardTodayDeliveriesEmpty => 'امروز سفارش تحویل‌شده‌ای نیست.';

  @override
  String get dashboardSearchOrdersHint => 'جستجوی شماره سفارش، مشتری، تلفن';

  @override
  String get dashboardSearchOrdersTooltip => 'جستجوی سفارش‌ها';

  @override
  String get dashboardOverdueTitle => 'تحویل‌های معوق';

  @override
  String get dashboardOverdueEmpty => 'سفارش باز معوقی نیست.';

  @override
  String get dashboardOverdueViewAll => 'همه معوق‌ها';

  @override
  String get dashboardQuickLinkOverdue => 'سفارش‌های معوق';

  @override
  String get dashboardQuickLinkDeliveredToday => 'تحویل امروز';

  @override
  String get dashboardQuickLinkSystemGuide => 'آموزش استفاده از برنامه';

  @override
  String get shellAppBarSyncA11y => 'وضعیت همگام‌سازی';

  @override
  String get shellAppBarNotificationsA11y => 'اعلان‌ها';

  @override
  String get shellAppBarNotificationsMutedA11y => 'اعلان‌ها (بی‌صدا)';

  @override
  String get shellSyncStatusOfflineChip => 'آفلاین';

  @override
  String get shellSyncTooltipNever =>
      'همگام‌سازی سرور هنوز متصل نیست. داده روی این دستگاه می‌ماند.';

  @override
  String get shellSyncTooltipOffline =>
      'شبکه نیست. می‌توانید ادامه دهید؛ تغییرات روی این دستگاه می‌ماند.';

  @override
  String shellSyncTooltipLast(String when) {
    return 'آخرین همگام‌سازی موفق: $when';
  }

  @override
  String get dashboardNotificationsPreviewTitle => 'اعلان‌های اخیر';

  @override
  String get dashboardNotificationsPreviewEmpty => 'هنوز اعلانی نیست.';

  @override
  String get dashboardNotificationsMutedHint =>
      'اعلان‌ها بی‌صدا هستند. در تنظیمات → اعلان‌ها تغییر دهید.';

  @override
  String get dashboardNotificationsViewAll => 'همه اعلان‌ها';

  @override
  String get notifSeedWelcomeTitle => 'به خیاط خوش آمدید';

  @override
  String get notifSeedWelcomeBody =>
      'به‌روزرسانی سفارش‌ها و اعلان‌های فروشگاه اینجا نمایش داده می‌شود. برای خوانده‌شدن ردیف را باز کنید.';

  @override
  String notifOrderStatusTitle(String orderNo) {
    return 'سفارش $orderNo';
  }

  @override
  String notifOrderStatusBody(String status) {
    return 'وضعیت به $status به‌روز شد.';
  }

  @override
  String get settingsNotifMarkAllRead => 'علامت همه به‌عنوان خوانده‌شده';

  @override
  String get subscriptionCurrentStatusTitle => 'وضعیت جاری';

  @override
  String get subscriptionReadOnlyHint => 'فقط مشاهده تا تمدید.';

  @override
  String get subscriptionGraceReadOnlyHint =>
      'فقط‌خواندنی تا زمانی که سرور مجوز را تأیید کند. به اینترنت وصل شوید و پایین، «تازه‌سازی وضعیت مجوز» را بزنید.';

  @override
  String get subscriptionClockTamperHint =>
      'فقط‌خواندنی تا پس از بررسی زمان دستگاه، سرور مجوز را تأیید کند. آنلاین «تازه‌سازی وضعیت» را بزنید.';

  @override
  String get subscriptionActivationTitle => 'فعال‌سازی';

  @override
  String get subscriptionActivationCodeLabel => 'کد فعال‌سازی';

  @override
  String get subscriptionActivationCodeHint =>
      'هنگام اتصال صورتحساب کد را وارد کنید';

  @override
  String get subscriptionActivateCta => 'فعال‌سازی';

  @override
  String get subscriptionActivationComingSoon =>
      'فعال‌سازی به سرور متصل می‌شود.';

  @override
  String get subscriptionRefreshStatusCta => 'به‌روزرسانی وضعیت مجوز';

  @override
  String get subscriptionRefreshComingSoon =>
      'به‌روزرسانی آنلاین با اتصال API در دسترس خواهد بود.';

  @override
  String get subscriptionActivationCodeHintApi =>
      'کد فعال‌سازی را از توزیع‌کننده وارد کنید.';

  @override
  String get subscriptionApplying => 'در حال اعمال…';

  @override
  String get subscriptionRefreshing => 'در حال به‌روزرسانی…';

  @override
  String get subscriptionRedeemSuccess => 'مجوز به‌روز شد.';

  @override
  String subscriptionRedeemError(String error) {
    return 'فعال‌سازی ناموفق: $error';
  }

  @override
  String subscriptionRefreshError(String error) {
    return 'به‌روزرسانی ناموفق: $error';
  }

  @override
  String get subscriptionBillingPlansTitle => 'پلان‌ها و قیمت‌ها (افغانی)';

  @override
  String get subscriptionBillingPrice1Year => '۱ سال';

  @override
  String get subscriptionBillingPrice2Year => '۲ سال';

  @override
  String get subscriptionBillingPriceLifetime => 'مادام‌العمر';

  @override
  String get subscriptionBillingHesabPayTitle => 'پرداخت با حساب پی';

  @override
  String get subscriptionBillingPaymentLinkTitle => 'اسکن یا لمس برای پرداخت';

  @override
  String get subscriptionBillingPaymentLinkDefaultLabel =>
      'باز کردن لینک پرداخت حساب پی';

  @override
  String get subscriptionBillingCopyPaymentLink => 'کپی لینک پرداخت';

  @override
  String get subscriptionBillingPaymentLinkOpenFailed =>
      'لینک پرداخت روی این دستگاه باز نشد.';

  @override
  String get subscriptionBillingCashTitle => 'پرداخت نقدی';

  @override
  String get subscriptionBillingContactTitle =>
      'بعد از پرداخت — تماس با پشتیبانی';

  @override
  String get subscriptionBillingCopyAccount => 'کاپی شماره حساب';

  @override
  String get subscriptionBillingCopied => 'کاپی شد';

  @override
  String subscriptionBillingOfflineCache(String when) {
    return 'اطلاعات ذخیره‌شده از $when. برای تازه‌سازی آنلاین شوید.';
  }

  @override
  String get subscriptionBillingNotPublished =>
      'دستورالعمل پرداخت هنوز منتشر نشده. از توزیع‌کننده بخواهید در پورتال توسعه‌دهنده → صورتحساب منتشر کند، یا کد فعال‌سازی را پایین وارد کنید.';

  @override
  String subscriptionBillingLoadError(String error) {
    return 'بارگذاری اطلاعات پرداخت ناموفق: $error';
  }

  @override
  String get subscriptionPaymentClaimTitle => 'پرداخت کردم (حساب پی)';

  @override
  String get subscriptionPaymentClaimOwnerOnly =>
      'فقط مالک دکان می‌تواند درخواست پرداخت بفرستد.';

  @override
  String get subscriptionPaymentClaimPlanTier => 'پلان';

  @override
  String get subscriptionPaymentClaimPlanOneYear => '۱ سال';

  @override
  String get subscriptionPaymentClaimPlanTwoYear => '۲ سال';

  @override
  String get subscriptionPaymentClaimPlanLifetime => 'مادام‌العمر';

  @override
  String get subscriptionPaymentClaimTransactionId => 'شناسه معامله';

  @override
  String get subscriptionPaymentClaimTransactionHint => 'از رسید حساب پی';

  @override
  String get subscriptionPaymentClaimPayerPhone => 'تلفن شما (اختیاری)';

  @override
  String get subscriptionPaymentClaimNotes => 'یادداشت (اختیاری)';

  @override
  String get subscriptionPaymentClaimSubmit => 'ارسال درخواست پرداخت';

  @override
  String get subscriptionPaymentClaimSubmitting => 'در حال ارسال…';

  @override
  String get subscriptionPaymentClaimSubmitSuccess =>
      'درخواست ارسال شد. پس از بررسی کد فعال‌سازی فرستاده می‌شود.';

  @override
  String subscriptionPaymentClaimSubmitError(String error) {
    return 'ارسال ناموفق: $error';
  }

  @override
  String get subscriptionPaymentClaimHistoryTitle => 'درخواست‌های پرداخت شما';

  @override
  String get subscriptionPaymentClaimStatusPending => 'در انتظار بررسی';

  @override
  String get subscriptionPaymentClaimStatusApproved => 'تأیید شد';

  @override
  String get subscriptionPaymentClaimStatusRejected => 'رد شد';

  @override
  String get subscriptionPaymentClaimCodeLabel => 'کد فعال‌سازی';

  @override
  String get subscriptionBillingWhatsapp => 'واتساپ';

  @override
  String get subscriptionBillingTelegram => 'تلگرام';

  @override
  String get subscriptionBillingPhone => 'تلفن';

  @override
  String get devPortalTabBilling => 'صورتحساب';

  @override
  String get devPortalTabSupport => 'پشتیبانی';

  @override
  String get devPortalBillingIntro =>
      'یک تصویر تنظیمات برای دکان‌ها بارگذاری کنید (راهنمای اشتراک، QR، قیمت). «منتشر شده» را روشن کنید. درخواست‌های پرداخت را در پایین بررسی کنید.';

  @override
  String get devPortalBillingSettingsImageTitle => 'تصویر تنظیمات';

  @override
  String get devPortalBillingSettingsImagePick => 'انتخاب تصویر';

  @override
  String get devPortalBillingSettingsImageReplace => 'جایگزینی تصویر';

  @override
  String get devPortalBillingSettingsImageRemove => 'حذف تصویر';

  @override
  String get devPortalBillingSettingsImageTooLarge =>
      'تصویر باید حداکثر ۱ مگابایت باشد. فایل کوچک‌تری انتخاب کنید.';

  @override
  String devPortalBillingLoadError(String error) {
    return 'بارگذاری مشخصات صورتحساب ناموفق: $error';
  }

  @override
  String get devPortalBillingProfileTitle => 'مشخصات حساب پی';

  @override
  String get devPortalBillingPublished => 'منتشر شده (برای دکان‌ها)';

  @override
  String get devPortalBillingPaymentLinkSectionTitle => 'لینک پرداخت حساب پی';

  @override
  String get devPortalBillingPaymentLinkSectionBody =>
      'کاربران برنامه در تنظیمات → اشتراک QR و دکمه را می‌بینند وقتی «منتشر شده» روشن است. لینک کامل HTTPS از حساب پی را بچسبانید.';

  @override
  String get devPortalBillingPaymentLinkPreviewTitle =>
      'پیش‌نمایش (آنچه دکان می‌بیند)';

  @override
  String get devPortalBillingAccountName => 'نام حساب';

  @override
  String get devPortalBillingAccountNumber => 'شماره حساب';

  @override
  String get devPortalBillingMerchantId => 'شناسه مرچنت / مرجع';

  @override
  String get devPortalBillingPaymentLink => 'لینک پرداخت حساب پی (HTTPS)';

  @override
  String get devPortalBillingPaymentLinkHint =>
      'لینک کامل از حساب پی. فروشگاه‌ها QR و این آدرس را می‌بینند.';

  @override
  String get devPortalBillingPaymentLinkLabelEn => 'نام دکمه لینک (انگلیسی)';

  @override
  String get devPortalBillingPaymentLinkLabelFa => 'نام دکمه لینک (دری)';

  @override
  String get devPortalBillingPaymentLinkLabelPs => 'نام دکمه لینک (پشتو)';

  @override
  String get devPortalBillingPrice1Year => 'قیمت ۱ سال (افغانی)';

  @override
  String get devPortalBillingPrice2Year => 'قیمت ۲ سال (افغانی)';

  @override
  String get devPortalBillingPriceLifetime => 'قیمت مادام‌العمر (افغانی)';

  @override
  String get devPortalBillingPaymentStepsEn => 'مراحل پرداخت (انگلیسی)';

  @override
  String get devPortalBillingPaymentStepsFa => 'مراحل پرداخت (دری)';

  @override
  String get devPortalBillingPaymentStepsPs => 'مراحل پرداخت (پشتو)';

  @override
  String get devPortalBillingActivationStepsEn => 'دریافت کد (انگلیسی)';

  @override
  String get devPortalBillingActivationStepsFa => 'دریافت کد (دری)';

  @override
  String get devPortalBillingActivationStepsPs => 'دریافت کد (پشتو)';

  @override
  String get devPortalBillingCashNoteEn => 'یادداشت نقدی (انگلیسی)';

  @override
  String get devPortalBillingCashNoteFa => 'یادداشت نقدی (دری)';

  @override
  String get devPortalBillingCashNotePs => 'یادداشت نقدی (پشتو)';

  @override
  String get devPortalBillingWhatsapp => 'واتساپ (E.164)';

  @override
  String get devPortalBillingTelegram => 'تلگرام';

  @override
  String get devPortalBillingPhone => 'تلفن مستقیم (E.164)';

  @override
  String get devPortalBillingSave => 'ذخیره مشخصات';

  @override
  String get devPortalBillingSaveSuccess => 'مشخصات ذخیره شد.';

  @override
  String devPortalBillingSaveError(String error) {
    return 'ذخیره ناموفق: $error';
  }

  @override
  String devPortalSupportLoadError(String error) {
    return 'بارگذاری اطلاعات پشتیبانی ناموفق: $error';
  }

  @override
  String get devPortalSupportPublishTitle => 'منتشر شده (برای دکان‌ها)';

  @override
  String get devPortalSupportPublishSubtitle =>
      'در تنظیمات → درباره نمایش داده می‌شود.';

  @override
  String get devPortalSupportDeveloperName => 'نام توسعه‌دهنده';

  @override
  String get devPortalSupportDeveloperTitle => 'عنوان / نقش';

  @override
  String get devPortalSupportDeveloperBio => 'معرفی کوتاه (اختیاری)';

  @override
  String get devPortalSupportEmail => 'ایمیل پشتیبانی';

  @override
  String get devPortalSupportPhone => 'تلفن پشتیبانی';

  @override
  String get devPortalSupportWhatsapp => 'واتساپ پشتیبانی';

  @override
  String get devPortalSupportHelpVideoUrl => 'لینک ویدیوی آموزشی (HTTPS)';

  @override
  String get devPortalSupportSaveSuccess => 'اطلاعات پشتیبانی ذخیره شد.';

  @override
  String devPortalSupportSaveError(String error) {
    return 'ذخیره ناموفق: $error';
  }

  @override
  String get supportSectionTitle => 'راهنما و پشتیبانی';

  @override
  String get supportSectionSubtitle => 'ویدیوی آموزش و اطلاعات تماس.';

  @override
  String supportSectionSubtitleCached(String time) {
    return 'ذخیره‌شده: $time';
  }

  @override
  String get supportNotAvailableTitle => 'اطلاعات پشتیبانی موجود نیست';

  @override
  String get supportNotAvailableBody =>
      'از توزیع‌کننده بخواهید در پورتال توسعه‌دهنده → پشتیبانی منتشر کند.';

  @override
  String get supportHowToVideoTitle => 'آموزش استفاده از برنامه (ویدیو)';

  @override
  String get supportDeveloperFallback => 'توسعه‌دهنده';

  @override
  String get supportEmailTitle => 'ایمیل';

  @override
  String get supportPhoneTitle => 'تلفن';

  @override
  String get supportWhatsappTitle => 'واتساپ';

  @override
  String get supportOpenLinkFailed =>
      'باز کردن این لینک در این دستگاه ممکن نیست.';

  @override
  String get devPortalBillingClaimsTitle => 'درخواست‌های پرداخت';

  @override
  String get devPortalBillingClaimsPending => 'در انتظار';

  @override
  String get devPortalBillingClaimsAll => 'همه';

  @override
  String get devPortalBillingClaimApprove => 'تأیید و ساخت کد';

  @override
  String get devPortalBillingClaimReject => 'رد';

  @override
  String get devPortalBillingClaimRejectNotes => 'دلیل (اختیاری)';

  @override
  String get devPortalBillingClaimApproved => 'درخواست تأیید شد.';

  @override
  String get devPortalBillingClaimRejected => 'درخواست رد شد.';

  @override
  String get devPortalBillingNoClaims => 'درخواستی نیست.';

  @override
  String get customersListView => 'نمای فهرستی';

  @override
  String get customersCardView => 'نمای کارتی';

  @override
  String get customerEditDialogTitle => 'ویرایش مشتری';

  @override
  String get customerUpdated => 'مشتری به‌روز شد.';

  @override
  String get customerAddressLabel => 'آدرس';

  @override
  String get customerAddressHint => 'اختیاری';

  @override
  String get customerNotesLabel => 'یادداشت‌ها';

  @override
  String get customerNotesHint => 'اختیاری';

  @override
  String get customerFieldEmpty => '—';

  @override
  String get customerDeleteMenu => 'حذف مشتری';

  @override
  String get customerDeleteConfirmTitle => 'این مشتری حذف شود؟';

  @override
  String get customerDeleteConfirmBody =>
      'از فهرست شما حذف می‌شود. سفارش‌های موجود در تب سفارش‌ها می‌مانند.';

  @override
  String get customerDeleted => 'مشتری حذف شد';

  @override
  String get orderDeleteMenu => 'حذف سفارش';

  @override
  String get orderDeleteConfirmTitle => 'این سفارش حذف شود؟';

  @override
  String get orderDeleteConfirmBody =>
      'سفارش از فهرست شما روی این دستگاه حذف می‌شود.';

  @override
  String get orderDeleted => 'سفارش حذف شد';

  @override
  String get customersFinancialSectionTitle => 'مانده';

  @override
  String get customersFinancialFilterAll => 'هر مانده‌ای';

  @override
  String get customersFilterHasUnpaid => 'دارای سفارش پرداخت‌نشده';

  @override
  String get customersSortMostOrders => 'بیشترین سفارش';

  @override
  String customersRowMeta(int orderCount, String unpaid) {
    return '$orderCount سفارش · $unpaid';
  }

  @override
  String get customersRowNoOrdersYet => 'هنوز سفارشی نیست';

  @override
  String customersRowSince(String date) {
    return 'مشتری از $date';
  }

  @override
  String get reportsThisMonthIncomeEmpty =>
      'هنوز پرداختی در این ماه ثبت نشده است.';

  @override
  String get reportsOpenUnpaidEmpty => 'سفارش بازی با مانده بدهی وجود ندارد.';

  @override
  String reportsOrdersByStatusCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سفارش',
    );
    return '$_temp0';
  }

  @override
  String get settingsUsersLimitsTitle => 'محدودیت کاربران';

  @override
  String get settingsUsersLimitsBody =>
      'فروشگاه آزمایشی: حداکثر ۲ کاربر. فروشگاه پرداخت‌شده: حداکثر ۵ کاربر. حساب مالک حذف نمی‌شود.';

  @override
  String settingsUsersLimitsBodyTrial(int max, int count) {
    return 'آزمایشی: حداکثر $max کاربر. $count فعال. حساب مالک حذف نمی‌شود.';
  }

  @override
  String settingsUsersLimitsBodyPaid(int max, int count) {
    return 'حداکثر $max کاربر برای این فروشگاه. $count فعال. حساب مالک حذف نمی‌شود.';
  }

  @override
  String settingsUsersAtLimit(int count, int max) {
    return 'به حد کاربر رسیده‌اید ($count از $max).';
  }

  @override
  String settingsUsersLimitsLoadFailed(String error) {
    return 'بارگذاری محدودیت کاربران ناموفق بود: $error. «تلاش مجدد» بزنید یا «افزودن کاربر» را امتحان کنید (سرور محدودیت را اعمال می‌کند).';
  }

  @override
  String get settingsUsersLicenseExpired =>
      'مجوز فروشگاه منقضی شده است. قبل از افزودن کاربر، تمدید یا فعال‌سازی کنید.';

  @override
  String get settingsUsersNotOwnerBanner =>
      'به‌عنوان عضو تیم وارد شده‌اید. فقط حساب مالک فروشگاه می‌تواند کاربر اضافه یا حذف کند.';

  @override
  String get settingsUsersNeedOnline =>
      'برای مدیریت کاربران آنلاین بمانید و با سرور وارد شوید.';

  @override
  String get settingsUsersOfflineCacheNote =>
      'آفلاین — نمایش آخرین فهرست ذخیره‌شده. برای به‌روزرسانی آنلاین شوید.';

  @override
  String get devPortalOfflineCacheNote =>
      'آفلاین — نمایش آخرین دادهٔ ذخیره‌شده. برای به‌روزرسانی آنلاین شوید.';

  @override
  String get settingsUsersTileNeedApiSession =>
      'برای مدیریت کاربران با سرور وارد شوید';

  @override
  String get settingsUsersAddCta => 'افزودن کاربر';

  @override
  String get settingsUsersAddDisabledHint =>
      'مدیریت کاربر به سرور متصل می‌شود.';

  @override
  String get settingsUsersListTitle => 'تیم';

  @override
  String get settingsUsersOwnerRowTitle => 'مالک فروشگاه';

  @override
  String get settingsUsersOwnerRowSubtitle => 'دسترسی کامل';

  @override
  String get settingsUsersEmptyRowTitle => 'کاربران اضافی';

  @override
  String get settingsUsersEmptyRowSubtitle => 'هنوز کاربر دیگری نیست';

  @override
  String get settingsUsersSubtitleTeam =>
      'مشاهدهٔ حساب‌ها روی سرور (فقط خواندنی مگر مالک باشید).';

  @override
  String settingsUsersLoadError(String error) {
    return 'بارگذاری کاربران ناموفق: $error';
  }

  @override
  String get settingsUsersRetryCta => 'تلاش دوباره';

  @override
  String get settingsUsersDeleteConfirmTitle => 'حذف کاربر؟';

  @override
  String get settingsUsersDeleteConfirmBody => 'دیگر نمی‌تواند وارد شود.';

  @override
  String get settingsUsersDeleteCta => 'حذف';

  @override
  String get settingsUsersAddDialogTitle => 'افزودن کاربر';

  @override
  String get settingsUsersAddUsernameLabel => 'نام کاربری';

  @override
  String get settingsUsersAddPasswordLabel => 'رمز عبور';

  @override
  String get settingsUsersAddSubmitCta => 'ایجاد';

  @override
  String settingsUsersAddError(String error) {
    return 'افزودن کاربر ناموفق: $error';
  }

  @override
  String get settingsUsersAddedSnackbar => 'کاربر ایجاد شد.';

  @override
  String get settingsUsersRemovedSnackbar => 'کاربر حذف شد.';

  @override
  String get settingsBackupOwnerPasswordNote =>
      'پشتیبان و بازیابی به رمز ورود مالک نیاز دارد.';

  @override
  String get settingsBackupSectionTitle => 'پشتیبان';

  @override
  String get settingsBackupOptionDataOnly => 'فقط داده';

  @override
  String get settingsBackupOptionDataOnlySubtitle =>
      'سفارش‌ها، مشتریان، پرداخت‌ها، فرادادهٔ کاتالوگ — فایل کوچک‌تر';

  @override
  String get settingsBackupOptionDataAndImages => 'داده + تصاویر کاتالوگ';

  @override
  String get settingsBackupOptionDataAndImagesSubtitle =>
      'شامل عکس‌های طرح ذخیره‌شده روی این دستگاه';

  @override
  String get settingsBackupCreateCta => 'ایجاد پشتیبان';

  @override
  String get settingsRestoreSectionTitle => 'بازیابی';

  @override
  String get settingsRestoreMergeNote =>
      'بازیابی همیشه با دادهٔ جاری ادغام می‌شود (جایگزینی کامل نیست).';

  @override
  String get settingsRestorePickCta => 'انتخاب فایل پشتیبان';

  @override
  String get settingsBackupRestoreComingSoon =>
      'تصاویر کاتالوگ هنوز در پشتیبان نسخهٔ ۱ نیست.';

  @override
  String get settingsBackupWebNotSupported =>
      'پشتیبان و بازیابی به اپ بومی نیاز دارد (Isar). از اندروید، iOS یا دسکتاپ استفاده کنید — نه وب.';

  @override
  String get settingsBackupExportDone => 'فایل پشتیبان ذخیره شد.';

  @override
  String get settingsBackupRestoreDone => 'بازیابی انجام شد.';

  @override
  String get settingsBackupRestoreSummaryTitle => 'خلاصهٔ بازیابی';

  @override
  String settingsBackupSummaryLineCustomers(int inserted, int updated) {
    return 'مشتریان: $inserted جدید، $updated ادغام‌شده';
  }

  @override
  String settingsBackupSummaryLineMeasurements(
    int types,
    int profiles,
    int lines,
  ) {
    return 'اندازه‌ها: $types نوع فیلد، $profiles پروفایل، $lines مقدار ذخیره‌شده';
  }

  @override
  String settingsBackupSummaryLineOrders(int count) {
    return 'سفارش‌ها: $count نوشته‌شده';
  }

  @override
  String settingsBackupSummaryLinePayments(int inserted, int skipped) {
    return 'پرداخت‌ها: $inserted افزوده، $skipped ردشده (از قبل بود)';
  }

  @override
  String settingsBackupSummaryLineSnapshots(int headers, int items) {
    return 'تصویر اندازه‌ها: $headers سربرگ، $items سطر';
  }

  @override
  String settingsBackupSummaryLineNotifications(int inserted, int skipped) {
    return 'اعلان‌ها: $inserted افزوده، $skipped ردشده';
  }

  @override
  String get settingsBackupInvalidFile => 'خواندن این فایل پشتیبان ممکن نیست.';

  @override
  String get settingsNotificationsFiltersTitle => 'فیلترها';

  @override
  String get settingsNotifFilterAll => 'همه';

  @override
  String get settingsNotifFilterOrders => 'سفارش‌ها';

  @override
  String get settingsNotifFilterLicense => 'مجوز';

  @override
  String get settingsNotifFilterBackup => 'پشتیبان';

  @override
  String get settingsNotificationsInboxEmpty => 'هنوز اعلانی نیست';

  @override
  String get settingsNotificationsInboxEmptyHint =>
      'تاریخچه برای سفارش، مجوز و پشتیبان اینجا نمایش داده می‌شود.';

  @override
  String get settingsNotificationsInboxFilterEmpty =>
      'اعلانی با این فیلتر نیست.';

  @override
  String get settingsSyncLastSyncTitle => 'آخرین همگام‌سازی موفق';

  @override
  String get settingsSyncLastSyncNever =>
      'هنوز همگام نشده (آفلاین‌محور؛ API در انتظار)';

  @override
  String get settingsSyncQueuedTitle => 'تغییرات محلی در صف';

  @override
  String get settingsSyncQueuedZero => 'هیچ‌کدام در انتظار نیست';

  @override
  String settingsSyncQueuedCount(int count) {
    return '$count در انتظار همگام‌سازی';
  }

  @override
  String get settingsSyncLocalSnapshotTitle => 'تصویر دادهٔ محلی';

  @override
  String get settingsSyncLocalOrders => 'سفارش‌ها';

  @override
  String get settingsSyncLocalCustomers => 'مشتریان';

  @override
  String get settingsSyncLocalPayments => 'پرداخت‌ها';

  @override
  String get settingsSyncLocalTasks => 'کارها';

  @override
  String get settingsSyncLocalNotifications => 'اعلان‌ها';

  @override
  String get settingsSyncLocalUnread => 'اعلان‌های خوانده‌نشده';

  @override
  String get settingsSyncRetryTitle => 'هم‌اکنون همگام‌سازی';

  @override
  String get settingsSyncRetrySubtitle =>
      'دریافت از سرور، سپس ارسال صف محلی وقتی API_BASE_URL تنظیم شده و با سرور آنلاین وارد شده‌اید.';

  @override
  String get settingsSyncRetryOffline =>
      'به نظر آفلاین هستید. اینترنت را وصل کنید و دوباره تلاش کنید.';

  @override
  String get settingsSyncRetryConfigureApi =>
      'ابتدا API_BASE_URL را در زمان بیلد تنظیم کنید، سپس تنظیمات → اتصال API را باز کنید.';

  @override
  String get settingsSyncRetrySignIn => 'ابتدا با حساب آنلاین سرور وارد شوید.';

  @override
  String get settingsSyncRetryLicenseExpired =>
      'سرور همگام‌سازی را رد کرد چون مجوز منقضی شده است. اشتراک را باز کنید.';

  @override
  String get settingsSyncRetryEditingBlocked =>
      'همگام‌سازی در حالت فقط‌خواندنی متوقف است. آنلاین که شدید اشتراک را باز کنید.';

  @override
  String settingsSyncRetrySuccess(int pushed, int pulled) {
    return 'همگام‌سازی انجام شد: $pushed تغییر ارسال شد؛ $pulled تغییر از سرور دریافت شد.';
  }

  @override
  String settingsSyncRetryFailed(String detail) {
    return 'همگام‌سازی ناموفق: $detail';
  }

  @override
  String get settingsSyncOutboxTitle => 'صندوق خروج';

  @override
  String get settingsSyncOutboxPlaceholderTitle => 'تغییرات در صف';

  @override
  String get settingsSyncOutboxPlaceholderSubtitle =>
      'تلاش مجدد و جزئیات هنگام فعال بودن همگام‌سازی نمایش داده می‌شود.';

  @override
  String get settingsSyncOutboxPendingListTitle => 'تغییرات در انتظار (محلی)';

  @override
  String get settingsSyncOutboxPendingEmpty => 'چیزی در صف همگام‌سازی نیست.';

  @override
  String get settingsDiagnosticsExportCta => 'خروجی بستهٔ تشخیص';

  @override
  String get settingsDiagnosticsExportBusy => 'در حال آماده‌سازی بسته…';

  @override
  String get settingsDiagnosticsExportSuccess =>
      'بستهٔ تشخیص آمادهٔ اشتراک است.';

  @override
  String settingsDiagnosticsExportError(String error) {
    return 'خروجی تشخیص انجام نشد: $error';
  }

  @override
  String get settingsSyncDiagnosticsFooter =>
      'پشتیبانی ممکن است این بسته را برای عیب‌یابی همگام‌سازی بخواهد.';

  @override
  String get devPortalTitle => 'پورتال توسعه‌دهنده';

  @override
  String get devPortalTabOverview => 'نمای کلی';

  @override
  String get devPortalTabCodes => 'کدها';

  @override
  String get devPortalTabShops => 'فروشگاه‌ها';

  @override
  String get devPortalTabResets => 'بازنشانی‌ها';

  @override
  String get devPortalTabDiagnostics => 'تشخیص';

  @override
  String get devPortalTabAccount => 'رمز عبور من';

  @override
  String get devPortalMyPasswordTitle => 'تغییر رمز عبور';

  @override
  String get devPortalMyPasswordSubtitle =>
      'نام کاربری اینجا تغییر نمی‌کند. رمز فعلی را وارد کنید، سپس رمز جدید (حداقل ۶ نویسه).';

  @override
  String get devPortalCurrentPasswordLabel => 'رمز فعلی';

  @override
  String get devPortalNewPasswordLabel => 'رمز جدید';

  @override
  String get devPortalConfirmPasswordLabel => 'تکرار رمز جدید';

  @override
  String get devPortalPasswordMismatch => 'رمز جدید و تکرار آن یکسان نیستند.';

  @override
  String get devPortalChangePasswordCta => 'به‌روزرسانی رمز';

  @override
  String get devPortalChangePasswordOk =>
      'رمز به‌روز شد. دفعه بعد با رمز جدید وارد شوید.';

  @override
  String get devPortalChangePasswordFail => 'به‌روزرسانی رمز ناموفق بود.';

  @override
  String get devPortalOnlineRequired =>
      'ابزارهای توسعه‌دهنده به اتصال آنلاین و حساب تأییدشده نیاز دارند.';

  @override
  String get devPortalRetryCta => 'تلاش مجدد';

  @override
  String get devPortalStubAction => 'API در این نسخه متصل نیست.';

  @override
  String get devPortalAdviceOfflineTitle => 'به نظر آفلاین هستید';

  @override
  String get devPortalAdviceOfflineBody =>
      'برای آزمایش سلامت API عمومی به اینترنت وصل شوید. فهرست‌های مدیریتی پس از استقرار APIهای مدیریت در دسترس می‌شوند.';

  @override
  String get devPortalAdviceOnlineTitle => 'ابزارهای توسعه‌دهنده';

  @override
  String get devPortalAdviceOnlineBody =>
      'از صورتحساب برای انتشار دستورالعمل حساب پی برای همه دکان‌ها استفاده کنید. نمای کلی سلامت API و آمار را نشان می‌دهد. کدها، دکان‌ها و بازنشانی رمز به حساب توسعه‌دهنده در API نیاز دارند.';

  @override
  String get devPortalShopsEmpty => 'هنوز فروشگاهی روی سرور ثبت نشده است.';

  @override
  String devPortalShopRowUsers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کاربر',
      one: '۱ کاربر',
    );
    return '$_temp0';
  }

  @override
  String devPortalShopSignedUp(String date) {
    return 'ثبت‌نام: $date';
  }

  @override
  String devPortalShopTrialStarted(String date) {
    return 'آزمایشی از: $date';
  }

  @override
  String get devPortalShopContactHeader => 'اطلاعات تماس ثبت‌نام';

  @override
  String devPortalShopContactWhatsapp(String value) {
    return 'واتساپ: $value';
  }

  @override
  String devPortalShopContactEmail(String value) {
    return 'ایمیل: $value';
  }

  @override
  String devPortalShopContactAddress(String value) {
    return 'آدرس: $value';
  }

  @override
  String get devPortalShopContactMissing =>
      'اطلاعات تماس ثبت نشده (فروشگاه قبل از این فیلدها ایجاد شده).';

  @override
  String get devPortalShopUsersHeader => 'حساب‌ها';

  @override
  String get devPortalShopUserOwnerBadge => 'مالک';

  @override
  String get devPortalShopUserDeletedBadge => 'حذف‌شده';

  @override
  String get devPortalShopUserPasswordNote =>
      'رمز عبور به‌صورت هش روی سرور ذخیره شده است. برای تنظیم رمز جدید از برگه «بازیابی رمز» استفاده کنید.';

  @override
  String get devPortalShopDisabledLabel => 'غیرفعال';

  @override
  String get devPortalShopActionsTooltip => 'اقدامات فروشگاه';

  @override
  String get devPortalShopDisableCta => 'غیرفعال‌سازی فروشگاه';

  @override
  String get devPortalShopEnableCta => 'فعال‌سازی فروشگاه';

  @override
  String get devPortalShopExtendCta => 'تمدید مجوز…';

  @override
  String get devPortalShopExtendTitle => 'تمدید مجوز';

  @override
  String get devPortalShopExtendHint =>
      'روزهای افزوده از امروز یا از تاریخ انقضای فعلی (هرکدام دیرتر باشد).';

  @override
  String get devPortalShopExtendDaysLabel => 'روز';

  @override
  String get devPortalShopSetMaxUsersCta => 'تعیین حد کاربر…';

  @override
  String get devPortalShopSetMaxUsersTitle => 'حد کاربر (فروشگاه پرداخت‌شده)';

  @override
  String get devPortalShopSetMaxUsersHint =>
      'حداکثر کاربران فعال شامل مالک (۱–۲۰). نمی‌تواند کمتر از کاربران فعلی باشد.';

  @override
  String get devPortalShopMaxUsersLabel => 'حداکثر کاربران';

  @override
  String devPortalShopRowMaxUsers(int max, int count) {
    return 'حد: $max کاربر ($count فعال)';
  }

  @override
  String get devPortalShopTrialUserLimitNote => 'آزمایشی: ۲ کاربر (ثابت)';

  @override
  String get devPortalShopActionOk => 'انجام شد.';

  @override
  String get devPortalShopPushTestCta => 'آزمایش اعلان…';

  @override
  String get devPortalShopPushTitle => 'اعلان آزمایشی';

  @override
  String get devPortalShopPushNotifTitleLabel => 'عنوان اعلان';

  @override
  String get devPortalShopPushBodyLabel => 'پیام';

  @override
  String devPortalShopPushResult(int success, int failed, String reason) {
    return 'ارسال‌شده: $success، ناموفق: $failed. دلیل: $reason.';
  }

  @override
  String devPortalCodesLoadError(String error) {
    return 'بارگذاری کدها ناموفق: $error';
  }

  @override
  String get devPortalCodesEmpty =>
      'هنوز کد فعال‌سازی وجود ندارد. برای اعمال زمان پولی یک کد بسازید.';

  @override
  String get devPortalCodesCreateTitle => 'کد فعال‌سازی جدید';

  @override
  String get devPortalCodesPlanDaysLabel => 'روزهای پولی پس از فعال‌سازی';

  @override
  String get devPortalCodesMaxUsesLabel => 'حداکثر دفعات استفاده';

  @override
  String get devPortalCodesCreateCta => 'تولید کد';

  @override
  String devPortalCodesCreated(String code) {
    return 'ایجاد شد: $code';
  }

  @override
  String get devPortalCodesCreateFail => 'ایجاد کد ناموفق بود.';

  @override
  String get devPortalCodesRevokeTitle => 'لغو کد';

  @override
  String devPortalCodesRevokeBody(String code) {
    return 'فروشگاه‌ها دیگر نمی‌توانند «$code» را فعال کنند.';
  }

  @override
  String get devPortalCodesRevoked => 'کد لغو شد.';

  @override
  String get devPortalCodesRevokeFail => 'لغو ناموفق بود.';

  @override
  String get devPortalCodesRevokeCta => 'لغو';

  @override
  String get devPortalCodesDetailTitle => 'کد فعال‌سازی';

  @override
  String get devPortalCodesCopyCta => 'کپی کد';

  @override
  String get devPortalCodesShareCta => 'اشتراک کد';

  @override
  String get devPortalCodesCopied => 'کد در کلیپ‌بورد کپی شد.';

  @override
  String get devPortalCodesShareSubject => 'کد فعال‌سازی خیاط';

  @override
  String devPortalCodesShareMessage(String code, int days) {
    return 'خیاط — فعال‌سازی اشتراک\n\nکد: $code\nروزهای پولی پس از فعال‌سازی: $days\n\nدر برنامه: تنظیمات → اشتراک → این کد را وارد کنید.';
  }

  @override
  String get devPortalApiHealthPrompt =>
      'برای تازه‌سازی و فراخوانی GET /health، صفحه را به پایین بکشید.';

  @override
  String get devPortalEnvBadge => 'محیط: توسعه';

  @override
  String get devPortalStatShops => 'کل فروشگاه‌ها';

  @override
  String get devPortalStatActiveExpired => 'فعال / منقضی';

  @override
  String get devPortalStatTrials => 'آزمایش‌های جاری';

  @override
  String get devPortalStatActivations => 'ایجاد کد (نمونهٔ ممیزی)';

  @override
  String get devPortalApiHealthTitle => 'سلامت API';

  @override
  String get devPortalApiHealthUnknown => 'نامشخص — به API متصل شوید';

  @override
  String get devPortalDiagHint =>
      'برای بستهٔ کامل دستگاه از تنظیمات → همگام‌سازی و تشخیص → خروجی بستهٔ تشخیص استفاده کنید.';

  @override
  String get devPortalDiagLocalTitle => 'این دستگاه (حافظهٔ محلی)';

  @override
  String get devPortalDiagLocalSubtitle =>
      'شمارش از ذخیرهٔ محلی — وقتی API مدیریت آفلاین است مفید است.';

  @override
  String get devPortalDiagCountLoading => '…';

  @override
  String get devPortalAdminAuditTitle => 'گزارش ممیزی مدیریت';

  @override
  String get devPortalAdminAuditNeedSignIn =>
      'با API وارد شوید، سپس برای تازه‌سازی به پایین بکشید.';

  @override
  String devPortalAdminAuditLine(int count, int schema) {
    return 'GET /admin/audit-log — $count ردیف، نسخهٔ طرحواره $schema';
  }

  @override
  String get settingsShopProfileTitle => 'پروفایل فروشگاه';

  @override
  String get shopProfileIntro =>
      'نام، لوگو، آدرس و پیام تشکر در رسید چاپی و فاکتور اشتراکی نمایش داده می‌شود. یادداشت پایین فقط برای خودتان است.';

  @override
  String get shopProfileNameLabel => 'نام فروشگاه';

  @override
  String get shopProfileNameHint => 'مثال: خیاطی کرزی';

  @override
  String get shopProfileNameRequired => 'نام فروشگاه الزامی است.';

  @override
  String get shopProfileNameTooShort => 'نام فروشگاه بسیار کوتاه است.';

  @override
  String get shopProfileShopPhoneLabel => 'تلفن فروشگاه (اختیاری)';

  @override
  String get shopProfileShopPhoneHint => 'مثال: 0701234567';

  @override
  String get shopProfileAddressLabel => 'آدرس (اختیاری)';

  @override
  String get shopProfileAddressHint => 'مثال: کارته چهار، کابل';

  @override
  String get shopProfileReceiptThanksLabel => 'پیام تشکر رسید (اختیاری)';

  @override
  String get shopProfileReceiptThanksHint => 'مثال: از همکاری شما سپاسگزاریم!';

  @override
  String get shopProfileNotesLabel => 'یادداشت (اختیاری)';

  @override
  String get shopProfileNotesHint => 'ساعات، نشانه، شناسه مالیاتی…';

  @override
  String get shopProfileSaved => 'پروفایل فروشگاه ذخیره شد.';

  @override
  String get shopProfileReadOnlyBanner =>
      'مجوز منقضی — می‌توانید ببینید اما ویرایش نکنید.';

  @override
  String get settingsCurrentUserGuest => 'مهمان';

  @override
  String settingsShopIdChip(String shopId) {
    return 'فروشگاه $shopId';
  }

  @override
  String get customersFilterTooltip => 'مرتب‌سازی و فیلتر';

  @override
  String get customersFilterSheetTitle => 'مرتب‌سازی و فیلتر';

  @override
  String get customersSortSectionTitle => 'مرتب‌سازی';

  @override
  String get customersSortNameAsc => 'الفبایی';

  @override
  String get customersSortNameDesc => 'معکوس الفبا';

  @override
  String get customersSortRecentActivity => 'آخرین فعالیت';

  @override
  String get customersCreatedSectionTitle => 'افزوده‌شده';

  @override
  String get customersCreatedFilterAll => 'هر زمان';

  @override
  String get customersCreatedFilterToday => 'امروز';

  @override
  String get customersCreatedFilterThisWeek => 'این هفته';

  @override
  String get customersActivitySectionTitle => 'فعالیت';

  @override
  String get customersFilterAll => 'همه مشتریان';

  @override
  String get customersFilterHasOrders => 'دارای سفارش';

  @override
  String get customersFilterNoOrders => 'هنوز سفارشی نیست';

  @override
  String get customersApplyFilters => 'اعمال';

  @override
  String get customersResetFilters => 'بازنشانی';

  @override
  String get settingsSectionPrinter => 'چاپگر';

  @override
  String get settingsPrinterTileTitle => 'چاپگر حرارتی';

  @override
  String get settingsPrinterTileSubtitle =>
      'چاپگر شبکه‌ای رسید (۵۸ / ۸۰ میلی‌متر)';

  @override
  String get settingsPrinterScreenTitle => 'چاپگر حرارتی';

  @override
  String get settingsPrinterIntro =>
      'رسید را به چاپگر شبکه ESC/POS بفرستید (معمولاً TCP خام روی پورت ۹۱۰۰). آدرس IP یا نام میزبان چاپگر روی وای‌فای یا LAN را وارد کنید.';

  @override
  String get settingsPrinterAsciiNotice =>
      'رسید از مجموعه کاراکتر ساده چاپگر استفاده می‌کند. نام یا یادداشت‌های غیرلاتین ممکن است روی برگه به صورت «؟» چاپ شوند.';

  @override
  String get settingsPrinterHostLabel => 'آدرس چاپگر';

  @override
  String get settingsPrinterHostHint => 'مثال: ۱۹۲.۱۶۸.۱.۵۰';

  @override
  String get settingsPrinterPortLabel => 'پورت';

  @override
  String get settingsPrinterPaperWidthLabel => 'عرض کاغذ';

  @override
  String get settingsPrinterPaper58Label => '۵۸ میلی‌متر';

  @override
  String get settingsPrinterPaper80Label => '۸۰ میلی‌متر';

  @override
  String get settingsPrinterSaved => 'تنظیمات چاپگر ذخیره شد.';

  @override
  String get settingsPrinterTestCta => 'چاپ آزمایشی';

  @override
  String get settingsPrinterTestHeadline => 'خیاط';

  @override
  String get settingsPrinterTestDetail =>
      'چاپ آزمایشی — اگر این متن را می‌بینید، اتصال برقرار است.';

  @override
  String get settingsPrinterTestOk => 'صفحه آزمایشی به چاپگر ارسال شد.';

  @override
  String settingsPrinterTestFail(String detail) {
    return 'چاپ آزمایشی ناموفق: $detail';
  }

  @override
  String get settingsPrinterWebUnavailable =>
      'چاپ حرارتی در اپلیکیشن‌های اندروید و iOS در دسترس است. برای چاپ از دستگاهی با اپ استفاده کنید؛ نسخه وب به چاپگر سخت‌افزاری کار نمی‌فرستد.';

  @override
  String get settingsPrinterHostEmptyError =>
      'برای ذخیره یا آزمایش، آدرس چاپگر را وارد کنید.';

  @override
  String get settingsPrinterPortInvalidError =>
      'پورت معتبر (۱ تا ۶۵۵۳۵) وارد کنید.';

  @override
  String get orderPrintReceiptTooltip => 'چاپ رسید';

  @override
  String get orderPrintReceiptNeedPrinter =>
      'آدرس چاپگر را در تنظیمات → چاپگر حرارتی وارد کنید.';

  @override
  String get orderPrintReceiptOk => 'رسید به چاپگر ارسال شد.';

  @override
  String orderPrintReceiptFail(String detail) {
    return 'چاپ ناموفق: $detail';
  }

  @override
  String get receiptCustomerLabel => 'مشتری';

  @override
  String get receiptPhoneLabel => 'تلفن';

  @override
  String get receiptDeliveryLabel => 'تحویل';

  @override
  String get receiptStatusLabel => 'وضعیت';

  @override
  String get receiptMeasurementsLabel => 'اندازه';

  @override
  String get invoicePridePromoLine =>
      'این فاکتور با برنامهٔ خیاط تهیه و ارسال شده است';

  @override
  String get invoiceContinuedLabel => 'ادامه';

  @override
  String get invoiceTakenDateLabel => 'ثبت';

  @override
  String get invoicePaymentDateLabel => 'تاریخ';

  @override
  String get invoiceMeasurementProfileLabel => 'پروفایل اندازه';

  @override
  String get invoiceStyleNameLabel => 'استایل';

  @override
  String get receiptStyleLabel => 'یادداشت استایل';

  @override
  String get receiptFabricLabel => 'پارچه مشتری';

  @override
  String get receiptFabricNameLabel => 'پارچه';

  @override
  String get receiptFabricColorLabel => 'رنگ';

  @override
  String get receiptFabricIdLabel => 'شناسه پارچه';

  @override
  String get orderDetailFabricTitle => 'پارچه مشتری';

  @override
  String get receiptInternalNotesHeader => 'یادداشت داخلی';

  @override
  String get receiptTotalLabel => 'جمع';

  @override
  String get receiptPaidLabel => 'پرداخت‌شده';

  @override
  String get receiptBalanceLabel => 'مانده';

  @override
  String get receiptPaymentsHeader => 'پرداخت';

  @override
  String get receiptShopPhoneLabel => 'تلفن فروشگاه';

  @override
  String get receiptShopAddressLabel => 'آدرس';

  @override
  String get receiptShareDivider => '--------------------------------';

  @override
  String get receiptShareSectionRule => '================================';

  @override
  String get settingsPrinterRetryHint =>
      'اگر چاپگر مشغول باشد، برنامه چند بار به‌صورت خودکار دوباره اتصال را امتحان می‌کند.';

  @override
  String get shopProfileLogoSectionTitle => 'لوگوی سربرگ فاکتور';

  @override
  String get shopProfileBannerSectionTitle => 'بنر داشبورد و فاکتور';

  @override
  String get shopProfileBannerSubtitle =>
      'تصویر عریض (~3:1) در داشبورد و فاکتور PDF نمایش داده می‌شود. بارگذاری بنر، بنر پیش‌فرض را تا زمان حذف جایگزین می‌کند.';

  @override
  String get shopProfileBannerPickCta => 'بارگذاری بنر';

  @override
  String get shopProfileBannerRemoveCta => 'حذف بنر';

  @override
  String get shopProfileBannerSaved => 'بنر ذخیره شد.';

  @override
  String get shopProfileBannerWebHint =>
      'بارگذاری بنر در اندروید و دسکتاپ در دسترس است.';

  @override
  String get shopProfileLogoSubtitle =>
      'در بالای رسید حرارتی و متن فاکتور اشتراکی (اندروید / iOS) نمایش داده می‌شود. تصویر مربعی بهتر است.';

  @override
  String get shopProfileLogoPickCta => 'انتخاب تصویر';

  @override
  String get shopProfileLogoRemoveCta => 'حذف لوگو';

  @override
  String get shopProfileLogoSaved => 'لوگو ذخیره شد.';

  @override
  String get shopProfileLogoWebHint =>
      'بارگذاری لوگو در برنامه‌های اندروید و iOS در دسترس است.';

  @override
  String get shopProfileLogoStatusOnFile =>
      'لوگو برای رسید روی این دستگاه ذخیره شده است.';

  @override
  String get shopProfileLogoDefaultCaption =>
      'تا بارگذاری لوگوی خودتان، لوگوی پیش‌فرض روی رسید چاپ می‌شود.';

  @override
  String get defaultShopName => 'خیاطی من';

  @override
  String get defaultShopAddress => 'کابل، افغانستان';

  @override
  String get defaultShopPhone => '0701234567';

  @override
  String get orderShareInvoiceTooltip => 'اشتراک فاکتور';

  @override
  String get orderShareInvoicePdfCta => 'اشتراک فاکتور PDF';

  @override
  String get orderShareContactPermissionDenied =>
      'اجازه مخاطبین خاموش است — فاکتور اشتراک شد، اما مشتری در تلفن ذخیره نشد.';

  @override
  String get orderShareInvoiceSharedSheet =>
      'واتساپ یا برنامه دیگر را برای ارسال فاکتور PDF انتخاب کنید.';

  @override
  String orderShareInvoiceFail(String detail) {
    return 'ارسال فاکتور ناموفق: $detail';
  }

  @override
  String orderShareInvoiceSubject(String orderNo) {
    return 'سفارش $orderNo';
  }

  @override
  String orderShareInvoiceWhatsappCaption(String orderNo, String customerName) {
    return 'فاکتور سفارش $orderNo — $customerName';
  }

  @override
  String orderShareContactSaved(String name) {
    return '$name در مخاطبین تلفن شما ذخیره شد.';
  }

  @override
  String get orderShareWhatsappOpened => 'فاکتور PDF در واتساپ باز شد.';

  @override
  String get orderShareWhatsappPhoneInvalid =>
      'برای ارسال فاکتور در واتساپ، شمارهٔ معتبر مشتری را وارد کنید.';

  @override
  String get receiptFooterThanks => 'از همکاری شما سپاسگزاریم!';

  @override
  String get settingsDeveloperPortalCheckFailed =>
      'تأیید دسترسی توسعه‌دهنده ممکن نشد. برای تکرار لمس کنید.';

  @override
  String get settingsDeveloperPortalRetry => 'تلاش دوباره';

  @override
  String get dashboardSyncRunning => 'همگام‌سازی…';

  @override
  String get dashboardSyncTapToRun => 'برای همگام‌سازی لمس کنید';

  @override
  String get dashboardTasksSectionTitle => 'کارها';

  @override
  String dashboardTasksOpenCount(int count) {
    return '$count باز';
  }

  @override
  String get dashboardTasksViewAll => 'همه کارها';

  @override
  String get shopFinanceTitle => 'امور مالی دکان';

  @override
  String get shopFinanceSubtitle => 'کرایه، مصارف روزانه و خوراک';

  @override
  String get shopFinanceOverviewTitle => 'خلاصه';

  @override
  String get shopFinanceRentTitle => 'کرایه';

  @override
  String get shopFinanceExpensesTitle => 'مصارف';

  @override
  String get shopFinanceMonthOutflow => 'مصارف این ماه';

  @override
  String get shopFinanceRentDue => 'کرایه معوق';

  @override
  String get shopFinanceRentPaid => 'کرایه پرداخت‌شده این ماه';

  @override
  String get shopFinanceExpenseDaily => 'مصارف روزانه';

  @override
  String get shopFinanceExpenseFood => 'خوراک و نوشیدنی';

  @override
  String get shopFinanceExpenseOther => 'سایر';

  @override
  String get shopFinanceAddRent => 'تنظیم کرایه';

  @override
  String get shopFinanceRecordRentPayment => 'ثبت پرداخت کرایه';

  @override
  String get shopFinanceAddExpense => 'افزودن مصرف';

  @override
  String get shopFinanceAmountLabel => 'مبلغ (افغانی)';

  @override
  String get shopFinanceDueDateLabel => 'تاریخ سررسید';

  @override
  String get shopFinancePeriodMonthsLabel => 'دوره (ماه)';

  @override
  String get shopFinanceNoteLabel => 'یادداشت';

  @override
  String get shopFinanceCategoryLabel => 'دسته';

  @override
  String get shopFinanceDateLabel => 'تاریخ';

  @override
  String get shopFinanceClearPeriodTitle => 'مصارف قدیمی پاک شود؟';

  @override
  String get shopFinanceClearPeriodBody =>
      'مصارف قبل از تاریخ انتخاب‌شده از فهرست حذف می‌شوند.';

  @override
  String get shopFinanceRentDueNotificationTitle => 'کرایه نزدیک است';

  @override
  String shopFinanceRentDueNotificationBody(String amount, String date) {
    return 'کرایه $amount در $date سررسید است';
  }

  @override
  String get shopFinanceEmptyRent =>
      'هنوز کرایه ثبت نشده. کرایه ماهانه را تنظیم کنید.';

  @override
  String get shopFinanceEmptyExpenses => 'هنوز مصرفی ثبت نشده.';

  @override
  String get shopFinanceSave => 'ذخیره';

  @override
  String get shopFinanceChartsExpensesByCategory => 'مصارف بر اساس دسته';

  @override
  String get appGuideCloseTooltip => 'بستن راهنما';

  @override
  String get appGuideSkipAll => 'رد کردن همه راهنماها';

  @override
  String get appGuideGotIt => 'متوجه شدم';

  @override
  String get appGuideOrdersTitle => 'سفارش‌ها';

  @override
  String get appGuideOrdersBody =>
      'سفارش‌های خیاطی را بسازید و پیگیری کنید. برای وضعیت، پرداخت و تاریخ تحویل، سفارش را باز کنید.';

  @override
  String get appGuideCustomersTitle => 'مشتریان';

  @override
  String get appGuideCustomersBody =>
      'نام، تلفن و پروفایل اندازه مشتریان را ذخیره کنید تا سفارش جدید سریع‌تر شود.';

  @override
  String get appGuideCatalogTitle => 'کاتالوگ';

  @override
  String get appGuideCatalogBody =>
      'عکس طرح‌ها را با مشتریان از طریق کاتالوگ فروشگاه به اشتراک بگذارید.';

  @override
  String get appGuideReportsTitle => 'گزارش‌ها';

  @override
  String get appGuideReportsBody =>
      'درآمد، سفارش‌های پرداخت‌نشده و گزارش تحویل را ببینید.';

  @override
  String get appGuideSettingsTitle => 'تنظیمات';

  @override
  String get appGuideSettingsBody =>
      'پروفایل فروشگاه، چاپگر، کتابخانه استایل و اشتراک را اینجا تنظیم کنید.';

  @override
  String get appGuideDashboardTitle => 'داشبورد';

  @override
  String get appGuideDashboardBody =>
      'از لبه چپ بکشید (یا آیکن منو) برای جستجو، همگام‌سازی و میانبرها.';

  @override
  String get syncConflictsTitle => 'تعارض همگام‌سازی';

  @override
  String get syncConflictsSubtitle =>
      'سفارش‌هایی که دستگاه و سرور در آن‌ها اختلاف دارند.';

  @override
  String get syncConflictsEmpty => 'تعارض همگام‌سازی نیست.';

  @override
  String get syncConflictPullSkipped =>
      'به‌روزرسانی سرور رد شد — نسخهٔ شما جدیدتر است.';

  @override
  String get syncConflictPushRejected =>
      'سرور به‌روزرسانی شما را رد کرد — نسخهٔ سرور جدیدتر است.';

  @override
  String get syncConflictKeepMine => 'نگه‌داشتن نسخهٔ من';

  @override
  String get syncConflictUseServer => 'استفاده از نسخهٔ سرور';

  @override
  String get syncConflictDismiss => 'رد کردن';

  @override
  String get syncConflictLocalLabel => 'روی این دستگاه';

  @override
  String get syncConflictRemoteLabel => 'از سرور';

  @override
  String get catalogPublicFeedError =>
      'بارگذاری طرح‌های اشتراکی ممکن نشد. اشتراک‌گذاری را فعال کنید و اتصال را بررسی کنید.';

  @override
  String get catalogP2pDownload => 'دانلود طرح';

  @override
  String get catalogP2pDownloading => 'در حال دانلود…';

  @override
  String get catalogP2pWaitingSender => 'در انتظار آنلاین شدن فرستنده…';

  @override
  String get catalogP2pDownloadDone => 'طرح در «طرح‌های من» ذخیره شد.';

  @override
  String get catalogP2pDownloadFailed =>
      'دانلود ناموفق بود. وقتی هر دو فروشگاه آنلاین‌اند دوباره تلاش کنید.';

  @override
  String get catalogP2pWebNotSupported =>
      'دانلود کاتالوگ در وب موجود نیست. از اپ اندروید استفاده کنید.';

  @override
  String get settingsSyncConflictsTile => 'تعارض همگام‌سازی';

  @override
  String get settingsSyncConflictsTileSubtitle => 'بررسی و حل تعارض سفارش';

  @override
  String get pushTokenAutoRegistered => 'اعلان فوری برای این دستگاه ثبت شد.';
}
