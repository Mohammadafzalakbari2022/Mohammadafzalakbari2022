// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'افغان پراید';

  @override
  String get tabOrders => 'سفارش‌ها';

  @override
  String get tabCustomers => 'مشتریان';

  @override
  String get tabCatalog => 'کاتالوگ';

  @override
  String get tabReports => 'گزارش‌ها';

  @override
  String get tabSettings => 'تنظیمات';

  @override
  String get loginTitle => 'ورود';

  @override
  String get loginSubtitle =>
      'نام کاربری و رمز فروشگاه را وارد کنید. سرور هنگام اتصال API تأیید می‌کند (plan-04).';

  @override
  String get loginMockHint =>
      'در این نسخه هر نام کاربری و رمز غیرخالی به‌صورت محلی وارد می‌شود.';

  @override
  String get loginShopIdLabel => 'شناسه فروشگاه (اختیاری)';

  @override
  String get loginShopIdHint => 'برای توسعه تک‌فروشگاه خالی بگذارید';

  @override
  String get loginUsernameLabel => 'نام کاربری';

  @override
  String get loginUsernameHint => 'نام ورود فروشگاه شما';

  @override
  String get loginPasswordLabel => 'رمز عبور';

  @override
  String get loginSignInCta => 'ورود';

  @override
  String get loginFieldRequired => 'الزامی';

  @override
  String get loginDevContinue => 'ادامه بدون حساب (توسعه)';

  @override
  String modulePlaceholder(String moduleName) {
    return '$moduleName — رابط به‌زودی.';
  }

  @override
  String get dashboardTitle => 'داشبورد';

  @override
  String get dashboardSubtitle =>
      'شاخص‌ها و میانبرها از دادهٔ محلی بارگذاری می‌شوند (plan-09).';

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
  String get dashboardOpenMenuTooltip => 'باز کردن منو';

  @override
  String get subscriptionTitle => 'اشتراک';

  @override
  String get subscriptionBody =>
      'تمدید یا کد فعال‌سازی هنگام اتصال صورتحساب (plan-06). پس از انقضا ویرایش محدود است؛ مشاهده فهرست و جزئیات ممکن است.';

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
  String get ordersComposerPlaceholderBody =>
      'فرم سفارش اینجا قرار می‌گیرد (plan-11).';

  @override
  String get ordersDetailTitle => 'جزئیات سفارش';

  @override
  String ordersDetailPlaceholderBody(String orderId) {
    return 'سفارش $orderId — جزئیات به‌زودی (plan-12).';
  }

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
  String get ordersDetailSectionInternalNotes => 'یادداشت داخلی';

  @override
  String get ordersDetailSectionPayments => 'پرداخت‌ها';

  @override
  String get ordersDetailSectionAudit => 'تاریخچه';

  @override
  String get ordersDetailSectionPlaceholder =>
      'جزئیات هنگام تکمیل ماژول اینجا نمایش داده می‌شود.';

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
      'این سفارش به‌دلیل تحویل یا لغو قفل است (plan-12).';

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
  String get ordersDetailChangeStatusSoon =>
      'تغییر وضعیت با تأیید باز می‌شود (plan-12).';

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
  String get paymentAmountHint => 'مبلغ را وارد کنید (بدون اعشار)';

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
  String get customersSearchHint => 'جستجوی نام یا تلفن';

  @override
  String get customersEmptyTitle => 'هنوز مشتری نیست';

  @override
  String get customersAddCta => 'افزودن مشتری';

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
  String get customerViewAllOrders => 'همه سفارش‌های این مشتری';

  @override
  String get customerViewAllOrdersSoon =>
      'با فیلتر مشتری تب سفارش‌ها باز می‌شود (plan-13).';

  @override
  String get customerSectionPlaceholder =>
      'جزئیات هنگام تکمیل ماژول اینجا نمایش داده می‌شود.';

  @override
  String get customerNewPlaceholderBody =>
      'فرم مشتری جدید اینجا قرار می‌گیرد (plan-13).';

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
  String get reportsMonthlyIncomePlaceholder =>
      'گزارش درآمد ماهانه اینجا قرار می‌گیرد (plan-16).';

  @override
  String get reportsThisMonthIncomeTitle => 'درآمد این ماه';

  @override
  String reportsThisMonthIncomeSubtitle(String amount) {
    return 'درآمد: $amount';
  }

  @override
  String get reportsMonthlyIncomeCardLabel => 'پرداخت‌های دریافت‌شده';

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
      'No unpaid orders match this filter.';

  @override
  String get reportsUnpaidFilterSection => 'Delivery window';

  @override
  String get reportsUnpaidFilterAll => 'All';

  @override
  String get reportsUnpaidFilterOverdue => 'Overdue';

  @override
  String get reportsUnpaidFilterDueSoon => 'Due in 7 days';

  @override
  String get reportsUnpaidSortSection => 'Sort';

  @override
  String get reportsUnpaidSortAmount => 'Amount';

  @override
  String get reportsUnpaidSortDueDate => 'Due date';

  @override
  String get reportsMonthlyCompareToggle => 'Compare to previous month';

  @override
  String get reportsMonthlyPreviousPaymentsLabel => 'Previous month (payments)';

  @override
  String get reportsMonthlyDeltaLabel => 'Change from previous month';

  @override
  String get reportsMonthlyDeltaSame => 'No change';

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
      'با رضایت دو طرف: برای مرور و نمایش در فهرست عمومی فعال کنید (plan-14).';

  @override
  String get catalogSharedPlaceholder =>
      'فهرست طرح‌های اشتراکی هنگام اتصال آنلاین اینجا نمایش داده می‌شود (plan-14).';

  @override
  String get catalogEmptyMyDesigns => 'هنوز طرحی نیست.';

  @override
  String get catalogAddDesignCta => 'افزودن طرح';

  @override
  String get catalogAddDesignPlaceholder =>
      'افزودن از دوربین / گالری فقط روی اندروید و iOS (plan-14).';

  @override
  String get catalogDetailTitle => 'قلم کاتالوگ';

  @override
  String catalogDetailPlaceholder(String id) {
    return 'قلم کاتالوگ $id — صفحه جزئیات به‌زودی.';
  }

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
      'جزئیات فروشگاه اینجا نمایش داده می‌شود (plan-15).';

  @override
  String get settingsCurrentUserTitle => 'کاربر جاری';

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
  String get settingsUsersPlaceholder =>
      'مدیریت کاربران در plan-15 پیاده می‌شود.';

  @override
  String get settingsBackupRestoreTitle => 'پشتیبان و بازیابی';

  @override
  String get settingsBackupRestoreSubtitleOwner =>
      'خروجی امن و بازیابی دادهٔ فروشگاه';

  @override
  String get settingsBackupRestorePlaceholder =>
      'پشتیبان/بازیابی در plan-15 پیاده می‌شود.';

  @override
  String get settingsMuteNotificationsTitle => 'بی‌صدا کردن اعلان‌ها';

  @override
  String get settingsMuteNotificationsSubtitle =>
      'بی‌صدا کردن بنر و نشان (تاریخچه حفظ می‌شود).';

  @override
  String get settingsNotificationsInboxTitle => 'صندوق اعلان‌ها';

  @override
  String get settingsNotificationsInboxSubtitle =>
      'تاریخچه و فیلترها (plan-15).';

  @override
  String get settingsNotificationsPlaceholder =>
      'صندوق اعلان‌ها در plan-15 پیاده می‌شود.';

  @override
  String get settingsSyncDiagnosticsTitle => 'همگام‌سازی و تشخیص';

  @override
  String get settingsNetworkStatusTitle => 'شبکه';

  @override
  String get settingsNetworkStatusOnline => 'متصل';

  @override
  String get settingsNetworkStatusOffline => 'آفلاین — کار محلی';

  @override
  String get settingsSyncDiagnosticsSubtitle =>
      'آخرین همگام‌سازی، صف، صندوق خروج (plan-15).';

  @override
  String get settingsSyncDiagnosticsPlaceholder =>
      'همگام‌سازی و تشخیص در plan-15 پیاده می‌شود.';

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
      'صفحات پورتال توسعه‌دهنده در plan-18 پیاده می‌شود.';

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
  String get themeSystem => 'سیستم';

  @override
  String get themeLight => 'روشن';

  @override
  String get themeDark => 'تیره';

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
  String get settingsComingSoon => 'به‌زودی.';

  @override
  String get loading => 'در حال بارگذاری…';

  @override
  String get genericError => 'خطایی رخ داد.';

  @override
  String get resetCta => 'بازنشانی';

  @override
  String get licenseExpiredReadOnly => 'مجوز منقضی — حالت فقط‌خواندنی.';

  @override
  String moneyAfn(String amount) {
    return '$amount افغانی';
  }

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
  String get ordersComposerStyleTitle => 'استایل';

  @override
  String get ordersComposerStyleRequired => 'استایل را انتخاب کنید (الزامی)';

  @override
  String get ordersComposerStyleLabel => 'طرح / استایل';

  @override
  String get ordersComposerStyleHint => 'مثال: کرزی، یقه، جیب…';

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
  String get ordersComposerTotalHint => 'مثال: 150000';

  @override
  String get ordersComposerPaidLabel => 'پرداخت اولیه (افغانی)';

  @override
  String get ordersComposerPaidHint => 'مثال: 50000';

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
  String get ordersComposerRecentOrdersTitle => 'سفارش‌های اخیر';

  @override
  String get ordersComposerRecentOrdersSubtitle => 'برای این مشتری';

  @override
  String ordersComposerRecentOrderRowSubtitle(String date, String remaining) {
    return '$date • مانده $remaining';
  }

  @override
  String get saveCta => 'ذخیره';

  @override
  String get customersCreated => 'مشتری ایجاد شد.';

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
  String get notifSeedWelcomeTitle => 'به افغان پراید خوش آمدید';

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
      'فعال‌سازی به سرور متصل می‌شود (plan-06).';

  @override
  String get subscriptionRefreshStatusCta => 'به‌روزرسانی وضعیت مجوز';

  @override
  String get subscriptionRefreshComingSoon =>
      'به‌روزرسانی آنلاین با اتصال API در دسترس خواهد بود.';

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
  String get settingsUsersLimitsTitle => 'محدودیت کاربران';

  @override
  String get settingsUsersLimitsBody =>
      'فروشگاه آزمایشی: حداکثر ۲ کاربر. فروشگاه پرداخت‌شده: حداکثر ۵ کاربر. حساب مالک حذف نمی‌شود.';

  @override
  String get settingsUsersAddCta => 'افزودن کاربر';

  @override
  String get settingsUsersAddDisabledHint =>
      'مدیریت کاربر به سرور متصل می‌شود (plan-15).';

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
  String get settingsBackupOwnerPasswordNote =>
      'پشتیبان و بازیابی به رمز ورود مالک نیاز دارد (plan-15).';

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
  String get settingsNotificationsFiltersTitle => 'فیلترها (پیش‌نمایش)';

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
  String get settingsDiagnosticsExportSoon =>
      'خروجی تشخیص با عرضهٔ همگام‌سازی در دسترس خواهد بود.';

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
  String get devPortalOnlineRequired =>
      'ابزارهای توسعه‌دهنده به اتصال آنلاین و حساب تأییدشده نیاز دارند.';

  @override
  String get devPortalRetryCta => 'تلاش مجدد';

  @override
  String get devPortalStubAction => 'API در این نسخه متصل نیست.';

  @override
  String get devPortalEnvBadge => 'محیط: توسعه';

  @override
  String get devPortalStatShops => 'کل فروشگاه‌ها';

  @override
  String get devPortalStatActiveExpired => 'فعال / منقضی';

  @override
  String get devPortalStatTrials => 'آزمایش‌های جاری';

  @override
  String get devPortalStatActivations => 'فعال‌سازی‌ها (دوره)';

  @override
  String get devPortalApiHealthTitle => 'سلامت API';

  @override
  String get devPortalApiHealthUnknown => 'نامشخص — به API متصل شوید';

  @override
  String get devPortalCodesStub =>
      'کدهای فعال‌سازی: جستجو، ایجاد و لغو از API مدیریت بارگذاری می‌شود (plan-18).';

  @override
  String get devPortalShopsStub =>
      'فروشگاه‌ها و مجوزها: فهرست و جزئیات از API مدیریت بارگذاری می‌شود.';

  @override
  String get devPortalResetsStub =>
      'درخواست‌های بازنشانی رمز: صف پشتیبانی از API مدیریت بارگذاری می‌شود.';

  @override
  String get devPortalDiagStub =>
      'پشتیبانی: پیوند به بسته‌های خروجی از تنظیمات → همگام‌سازی و تشخیص.';

  @override
  String get settingsShopProfileTitle => 'پروفایل فروشگاه';

  @override
  String get shopProfileIntro =>
      'این نام فروشگاه به‌عنوان برچسب طراح روی اقلام کاتالوگ نمایش داده می‌شود. تماس تا اتصال فاکتور برای مرجع شماست.';

  @override
  String get shopProfileNameLabel => 'نام فروشگاه';

  @override
  String get shopProfileNameHint => 'مثال: خیاطی پراید';

  @override
  String get shopProfileNameRequired => 'نام فروشگاه الزامی است.';

  @override
  String get shopProfileNameTooShort => 'نام فروشگاه بسیار کوتاه است.';

  @override
  String get shopProfileShopPhoneLabel => 'تلفن فروشگاه (اختیاری)';

  @override
  String get shopProfileShopPhoneHint => 'مثال: 0700000000';

  @override
  String get shopProfileAddressLabel => 'آدرس (اختیاری)';

  @override
  String get shopProfileAddressHint => 'خیابان، منطقه، شهر…';

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
}
