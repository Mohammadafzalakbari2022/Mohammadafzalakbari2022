// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Pushto Pashto (`ps`).
class AppLocalizationsPs extends AppLocalizations {
  AppLocalizationsPs([String locale = 'ps']) : super(locale);

  @override
  String get appTitle => 'افغان پراید';

  @override
  String get tabOrders => 'امرونه';

  @override
  String get tabCustomers => 'د پیرودونکو لیست';

  @override
  String get tabOrdersList => 'د پیرو لیست';

  @override
  String get tabCatalog => 'کتلاګ';

  @override
  String get tabReports => 'راپورونه';

  @override
  String get tabSettings => 'تنظیمات';

  @override
  String get loginTitle => 'ننوتل';

  @override
  String get loginSubtitle => 'د خپلې هټۍ کارن نوم او پاسورډ ولیکئ.';

  @override
  String get loginMockHint =>
      'په دې نسخه کې هر غیرخالي کارن نوم او پاسورډ په محلي ډول ننوتل کوي.';

  @override
  String get loginShopIdLabel => 'د هټۍ پېژند (اختیاري)';

  @override
  String get loginShopIdHint => 'یوازې که ستاسو هټۍ تاسو ته پېژند درکړی وي';

  @override
  String get loginSigningInHint =>
      'مهرباني وکړئ انتظار وکړئ. په ورو انټرنټ کې تر یوې دقیقې پورې وخت نیسي.';

  @override
  String get loginCreatingShopHint =>
      'مهرباني وکړئ انتظار وکړئ. د هټۍ جوړول ممکن یو څه وخت ونیسي.';

  @override
  String get loginInvalidCredentials =>
      'د هټۍ پېژند، کارن نوم یا پاسورډ سم نه دی. وګورئ او بیا هڅه وکړئ.';

  @override
  String get loginNoInternet => 'انټرنټ نشته. شبکه وګورئ او بیا هڅه وکړئ.';

  @override
  String get loginOfflineNotSetUp =>
      'د آفلاین ننوتلو لپاره یو ځل په انټرنټ کې ننوځئ.';

  @override
  String get loginOfflineShopIdRequired =>
      'د آفلاین ننوتلو لپاره د هټۍ پېژندنه ولیکئ.';

  @override
  String get loginConnectionSlow =>
      'اړیکه ورو ده یا قطع شوه. لږ انتظار وکړئ او بیا هڅه وکړئ.';

  @override
  String get loginServerBusy => 'اوس خدمت ګڼ دی. څو دقیقې وروسته بیا هڅه وکړئ.';

  @override
  String get loginSomethingWrong => 'اوس ننوتل نشو. مهرباني وکړئ بیا هڅه وکړئ.';

  @override
  String get loginShopCreateFailed =>
      'اوس هټۍ نشوه جوړېدای. مهرباني وکړئ بیا هڅه وکړئ.';

  @override
  String get loginForgotPasswordSubmitting => 'ستاسو غوښتنه لیږل کېږي…';

  @override
  String get loginForgotPasswordSubmitHint =>
      'مهرباني وکړئ انتظار وکړئ. په ورو انټرنټ کې ممکن یو څه وخت ونیسي.';

  @override
  String get loginForgotPasswordFailed =>
      'اوس غوښتنه نشوه لیږل. مهرباني وکړئ بیا هڅه وکړئ.';

  @override
  String get loginUsernameLabel => 'کارن نوم';

  @override
  String get loginUsernameHint => 'ستاسو د هټۍ د ننوتلو نوم';

  @override
  String get loginPasswordLabel => 'پاسورډ';

  @override
  String get loginPasswordShowA11y => 'پاسورډ ښکاره کړئ';

  @override
  String get loginPasswordHideA11y => 'پاسورډ پټ کړئ';

  @override
  String get loginSignInCta => 'ننوتل';

  @override
  String get loginForgotPasswordCta => 'پاسورډ هیر شوی؟';

  @override
  String get loginForgotPasswordTitle => 'پاسورډ بیا تنظیم';

  @override
  String get loginForgotPasswordBody =>
      'د هټۍ پېژند او کارن نوم ولیکئ. کله چې غوښتنه په قطار کې راشي، پراختیاګر له پراختیا پورټل څخه نوی پاسورډ ټاکلی شي.';

  @override
  String get loginForgotPasswordSubmit => 'غوښتنه وسپارئ';

  @override
  String get loginForgotPasswordQueued =>
      'که حساب شتون ولري، د ملاتړ لپاره د بیا تنظیم غوښتنه په قطار کې ثبت شوه.';

  @override
  String get loginForgotPasswordFieldsRequired =>
      'د هټۍ پېژند او کارن نوم اړین دي.';

  @override
  String get settingsPushTokenTitle => 'د فشاري خبرتیا توکن (ازمایښتي)';

  @override
  String get settingsPushTokenHint =>
      'د FCM وسیلې توکن ولګوئ، پلیټفارم وټاکئ، بیا خوندي کړئ. سرور د راتلونکي لیږد لپاره ساتي.';

  @override
  String get settingsPushTokenFieldLabel => 'د وسیلې توکن';

  @override
  String get settingsPushPlatformLabel => 'پلیټفارم';

  @override
  String get settingsPushRegisterCta => 'توکن په سرور خوندي کړئ';

  @override
  String get settingsPushRegisterOk => 'توکن خوندي شو.';

  @override
  String get settingsPushRegisterFail => 'توکن نشو خوندي کېدلی.';

  @override
  String devPortalShopsLoadError(String error) {
    return 'هټۍ نشې بارولای: $error';
  }

  @override
  String devPortalResetsLoadError(String error) {
    return 'د بیا تنظیم قطار نشو بارولای: $error';
  }

  @override
  String get devPortalResetsEmpty => 'د پاسورډ بیا تنظیم غوښتنې په تمه نشته.';

  @override
  String get devPortalResetsSetPasswordTitle => 'نوی پاسورډ ټاکل';

  @override
  String get devPortalResetsSetPasswordHint => 'لږترلږه ۶ توري.';

  @override
  String get devPortalResetsResolveCta => 'پاسورډ پلي کړئ';

  @override
  String get devPortalResetsResolved => 'پاسورډ تازه شو.';

  @override
  String devPortalResetsResolveFailed(String error) {
    return 'تازه کول ناکام: $error';
  }

  @override
  String get loginFieldRequired => 'اړین';

  @override
  String get loginDevContinue => 'پرته له حساب دوام (پراختیا)';

  @override
  String get loginApiHint => 'د هټۍ پېژند، کارن نوم او پاسورډ سره ننوځئ.';

  @override
  String get loginSigningIn => 'ننوتل روان دي…';

  @override
  String get loginApiUnauthorized =>
      'د هټۍ پېژند، کارن نوم یا پاسورډ سم نه دی. وګورئ او بیا هڅه وکړئ.';

  @override
  String loginApiError(String error) {
    return 'ننوتل ناکام: $error';
  }

  @override
  String get loginShopCreateSectionTitle => 'نوې هټۍ جوړول';

  @override
  String get loginShopCreateSubtitle =>
      'خپله خیاطي هټۍ ثبت کړئ او د مالک په توګه ننوځئ.';

  @override
  String get loginShopCreateNameLabel => 'د هټۍ نوم';

  @override
  String get loginShopCreateOwnerUsernameLabel => 'د مالک کارن نوم';

  @override
  String get loginShopCreateOwnerPasswordLabel => 'د مالک پاسورډ';

  @override
  String get loginShopCreateCta => 'هټۍ جوړول او ننوتل';

  @override
  String get loginShopCreating => 'هټۍ جوړېږي…';

  @override
  String loginShopCreateError(String error) {
    return 'هټۍ نشوه جوړېدلی: $error';
  }

  @override
  String modulePlaceholder(String moduleName) {
    return '$moduleName — انټرفیس ژر راځي.';
  }

  @override
  String get dashboardTitle => 'ډشبورډ';

  @override
  String get dashboardSubtitle => 'شاخصونه او لنډلارې به له محلي ډیټا بار شي.';

  @override
  String get dashboardKpisPlaceholder => 'نن په یوه کتنه';

  @override
  String get dashboardKpiNewOrders => 'نوي امرونه';

  @override
  String get dashboardKpiInProgress => 'روان';

  @override
  String get dashboardKpiReady => 'چمتو';

  @override
  String get dashboardKpiUnpaid => 'نه ورکړل شوې پاتې';

  @override
  String get dashboardKpiValuePlaceholder => '—';

  @override
  String get dashboardOpenMenuTooltip => 'ډشبورډ پرانیزئ';

  @override
  String get dashboardOrdersPipelineTitle => 'د امرونو لړۍ';

  @override
  String get dashboardRecentIncomeTitle => 'عاید — وروستۍ ۷ ورځې';

  @override
  String get dashboardActivitySectionTitle => 'همغږي او خبرتیاوې';

  @override
  String get subscriptionTitle => 'ګډون';

  @override
  String get subscriptionBody =>
      'د حساب پی له لارې (لاندې ګامونه کله چې خپور شي)، د هټۍ مالک په توګه د تادیې غوښتنه، یا د ملاتړ فعالولو کوډ سره نوي کړئ. پای ته رسېدو وروسته سمون محدود دی؛ خپل معلومات لیدلی شئ.';

  @override
  String get subscriptionBillingSectionTitle => 'تادیه او نوي کول';

  @override
  String get subscriptionListTileSubtitle => 'جواز، ازمایښت او فعالول';

  @override
  String get licenseDevControlsTitle => 'جواز (یوازې پراختیا)';

  @override
  String get licenseStatusTrial => 'ازمایښتي';

  @override
  String get licenseStatusPaid => 'ورکړل شوی';

  @override
  String get licenseStatusExpired => 'پای ته رسېدلی';

  @override
  String get ordersNewTitle => 'نوی امر';

  @override
  String get ordersNewCta => 'نوی امر';

  @override
  String get ordersComposerPlaceholderBody => 'د امر فورمه به دلته راشي.';

  @override
  String get ordersDetailTitle => 'د امر جزئیات';

  @override
  String ordersDetailPlaceholderBody(String orderId) {
    return 'امر $orderId — جزئیات ژر راځي.';
  }

  @override
  String get orderStatusNew => 'نوی';

  @override
  String get orderStatusInProgress => 'روان';

  @override
  String get orderStatusReady => 'چمتو';

  @override
  String get orderStatusDelivered => 'تحویلي شوی';

  @override
  String get orderStatusCancelled => 'لغوه شوی';

  @override
  String get ordersListEmpty => 'تر اوسه امر نشته';

  @override
  String ordersDeliveryOn(String date) {
    return 'تحویلي: $date';
  }

  @override
  String ordersTakenOn(String dateTime) {
    return 'اخیستل: $dateTime';
  }

  @override
  String get ordersWebDataHint =>
      'د ویب مخکتنه له نمونې ډیټا کار اخلي (Isar په اندروید/iOS/ډیسکټاپ کې).';

  @override
  String ordersNumberPrefix(String number) {
    return 'شم. $number';
  }

  @override
  String get ordersSearchHint => 'د امر شمیره، پیرودونکی یا تلیفون ولټوئ';

  @override
  String get ordersDateChipAny => 'ټولې نیټې';

  @override
  String get ordersDateChipToday => 'نن تحویلي';

  @override
  String get ordersDateChipThisWeek => 'دا اونۍ تحویلي';

  @override
  String get ordersDateChipCustom => 'خپلواکه موده';

  @override
  String get ordersDateCustomPickerHelp => 'د تحویلي نیټې له مخې فلټر (شامل).';

  @override
  String ordersCustomerFilterChip(String name) {
    return 'پیرودونکی: $name';
  }

  @override
  String get ordersCustomerFilterUnknown => 'د پیرودونکي فلټر فعال دی';

  @override
  String get ordersClearFilterA11y => 'فلټر پاک کړئ';

  @override
  String get ordersOnlyUnpaidChip => 'یوازې نه ورکړل شوي';

  @override
  String get ordersFilterOverdueChip => 'وروسته پاتې';

  @override
  String get ordersFilterDeliveredTodayChip => 'نن تحویلي شوي';

  @override
  String ordersRemainingChip(String amount) {
    return 'پاتې: $amount';
  }

  @override
  String get ordersFilteredEmpty => 'ستاسو لټون یا فلټر سره امر نه مېښي.';

  @override
  String get ordersFilterSheetTitle => 'فلټرونه';

  @override
  String get ordersFilterQuickSection => 'چټک فلټرونه';

  @override
  String get ordersFilterDeliverySection => 'د تحویلي نیټه';

  @override
  String get ordersFilterStatusSection => 'حالت';

  @override
  String get ordersFilterClearAll => 'ټول پاک کړئ';

  @override
  String get ordersFilterApply => 'پلي کړئ';

  @override
  String get listToolbarSearchTooltip => 'لټون';

  @override
  String get listToolbarFilterTooltip => 'فلټرونه';

  @override
  String get appShellTapTitleForMenu => 'د ډشبورډ مینو لپاره ټک وکړئ';

  @override
  String get ordersDetailFromNewBanner =>
      'لارښوونه: د رسید چاپ یا د فاکتور شریکولو لپاره پورته توډبار وکاروئ.';

  @override
  String get ordersComposerPostSaveSubtitle =>
      'چاپ، شریکول یا بشپړ امر پرانیزئ.';

  @override
  String get ordersDetailNotFound => 'دا امر ونه موندل شو.';

  @override
  String get ordersDetailChangeStatus => 'حالت بدل کړئ';

  @override
  String get ordersDetailChangeStatusSubtitle => 'چمتو / تحویلي شوی / لغوه';

  @override
  String get ordersDetailConfirmTitle => 'تایید';

  @override
  String ordersDetailConfirmBody(String status) {
    return 'حالت $status ته بدل شي؟';
  }

  @override
  String get ordersDetailConfirmCta => 'تایید';

  @override
  String ordersDetailStatusUpdated(String status) {
    return 'حالت تازه شو: $status';
  }

  @override
  String get ordersDetailSectionCustomer => 'پیرودونکی';

  @override
  String get ordersDetailSectionMeasurements => 'پیمانې';

  @override
  String get ordersDetailSectionStyle => 'سټایل';

  @override
  String get ordersDetailSectionInternalNotes => 'داخلي یادښتونه';

  @override
  String get ordersDetailSectionPayments => 'ورکړې';

  @override
  String get ordersDetailSectionAudit => 'تاریخچه';

  @override
  String get ordersDetailSectionPlaceholder =>
      'جزئیات به د ماډل جوړېدو سره دلته ښکاري.';

  @override
  String get ordersDetailAuditIntro =>
      'په دې وسیله محلي ریکارډ معلومات. بشپړ د حالت بدلون تاریخچه لا ثبت نه ده؛ د نیټې لپاره ورکړې وګورئ.';

  @override
  String get ordersAuditInternalId => 'داخلي پېژند';

  @override
  String get ordersAuditCopyIdTooltip => 'پېژند کاپي کړئ';

  @override
  String get ordersAuditCopiedId => 'د امر پېژند کاپي شوه';

  @override
  String get ordersAuditCreatedAt => 'جوړ شو';

  @override
  String get ordersAuditUpdatedAt => 'وروستی تازه کول';

  @override
  String get ordersAuditStatus => 'حالت';

  @override
  String get ordersAuditDelivery => 'د تحویلي نیټه';

  @override
  String get ordersAuditPaymentsTitle => 'د ورکړو دفتر';

  @override
  String get ordersAuditPaymentsEmpty => 'تر اوسه د دې امر لپاره ورکړه نشته.';

  @override
  String ordersAuditPaymentsLine(int count, String first, String last) {
    return '$count د ورکړو کرښې · لومړی $first · وروستی $last';
  }

  @override
  String get ordersDetailSnapshotEmpty => 'هېڅ ثبت نشوی.';

  @override
  String ordersDetailMeasurementsFromProfile(String label) {
    return 'د پروفایل «$label» پر بنسټ عکس.';
  }

  @override
  String get ordersDetailMeasurementsNotes => 'په امر باندې یادښتونه';

  @override
  String get ordersDetailLockedHint =>
      'دا امر قفل دی ځکه تحویلي شوی یا لغوه شوی دی.';

  @override
  String get ordersDetailLockedStillInternalNotes =>
      'لا هم لاندې داخلي یادښتونه سمولی شئ.';

  @override
  String get ordersInternalNotesDialogTitle => 'داخلي یادښتونه';

  @override
  String get ordersInternalNotesHint =>
      'یوازې کارکوونکو — پیرودونکي ته نه ښکاري.';

  @override
  String get ordersInternalNotesSaved => 'داخلي یادښتونه خوندي شول.';

  @override
  String get licenseReadOnlyHint =>
      'یوازې لوستل: د جواز د پای په دوره کې سمون بند دی.';

  @override
  String get ownerPasswordTitle => 'د مالک پاسورډ';

  @override
  String get ownerPasswordLabel => 'د مالک پاسورډ ولیکئ';

  @override
  String get ownerPasswordMismatch =>
      'دا پاسورډ د دې وسیلې د مالک پاسورډ سره نه سمون خوري.';

  @override
  String get ordersDetailChangeStatusSoon =>
      'د حالت بدلون به د تایید جریان پرانیزي.';

  @override
  String get addPaymentCta => 'ورکړه زیاتول';

  @override
  String get addAdjustmentCta => 'سمون زیاتول';

  @override
  String get paymentAdjustmentHint =>
      'د ثبت شویو ورکړو کمولو لپاره منفي بېله ولیکئ (یوازې زیاتېدونکی دفتر).';

  @override
  String get paymentLedgerAdjustmentTag => 'سمون';

  @override
  String get paymentAdjustmentAdded => 'سمون ثبت شو';

  @override
  String get paymentAdded => 'ورکړه زیاته شوه';

  @override
  String get paymentsEmpty => 'تر اوسه هېڅ ورکړه نشته.';

  @override
  String get paymentAmountLabel => 'بېله';

  @override
  String get paymentAmountHint => 'بېلګه: 300';

  @override
  String paymentAmount(String amount) {
    return 'بېله: $amount';
  }

  @override
  String get paymentTotal => 'ټول';

  @override
  String get paymentPaid => 'ورکړل شوی';

  @override
  String get paymentRemaining => 'پاتې';

  @override
  String get customersSearchHint => 'نوم یا تلیفون ولټوئ';

  @override
  String get customersEmptyTitle => 'تر اوسه پیرودونکی نشته';

  @override
  String get customersAddCta => 'پیرودونکی زیاتول';

  @override
  String get customersFilteredEmpty => 'ستاسو لټون سره پیرودونکی نه مېښي.';

  @override
  String get customersPhoneMissing => 'تلیفون نشته';

  @override
  String get customerProfileTitle => 'پیرودونکی';

  @override
  String get customerNotFound => 'دا پیرودونکی ونه موندل شو.';

  @override
  String get customerInfoSection => 'د پیرودونکي معلومات';

  @override
  String get customerMeasurementProfilesSection => 'د پیمانو پروفایلونه';

  @override
  String get customerTodayOrdersTitle => 'نن امرونه';

  @override
  String get customerNoTodayOrders => 'نن امر نشته.';

  @override
  String get customerOrderHistoryTitle => 'د امرونو تاریخچه';

  @override
  String get customerNoOrders => 'تر اوسه د دې پیرودونکي لپاره امر نشته.';

  @override
  String get customerViewAllOrders => 'د دې پیرودونکي ټول امرونه وګورئ';

  @override
  String get customerViewAllOrdersSoon =>
      'دا به د پیرودونکي فلټر سره امرونه پرانیزي.';

  @override
  String get customerSectionPlaceholder =>
      'جزئیات به د ماډل جوړېدو سره دلته ښکاري.';

  @override
  String get customerNewPlaceholderBody =>
      'د نوي پیرودونکي فورمه به دلته راشي.';

  @override
  String get measurementUnitCm => 'سانتي‌متر';

  @override
  String get measurementUnitInch => 'انچ';

  @override
  String get measurementProfilesEmpty =>
      'لا خوندي پروفایل نشته. په نوو امرونو کې بیا کارولو لپاره یو زیات کړئ.';

  @override
  String get measurementProfilesAddCta => 'پروفایل زیاتول';

  @override
  String get measurementProfileEditorTitleNew => 'نوی د پیمانو پروفایل';

  @override
  String get measurementProfileEditorTitleEdit => 'د پیمانو پروفایل سمول';

  @override
  String get measurementProfileLabelField => 'د پروفایل نوم';

  @override
  String get measurementProfileBodyField => 'پیمانې';

  @override
  String get measurementProfileNotesField => 'اضافي یادښتونه';

  @override
  String get measurementProfileUnitSection => 'واحد';

  @override
  String get measurementProfileSaveAsNew => 'نوې پروفایل په توګه خوندي کړئ';

  @override
  String get measurementProfileCreated => 'پروفایل خوندي شو';

  @override
  String get measurementProfileUpdated => 'پروفایل تازه شو';

  @override
  String get measurementProfilePickSheetTitle => 'خوندي پروفایلونه';

  @override
  String get settingsMeasurementTypesTitle => 'د اندازې ساحې';

  @override
  String get settingsMeasurementTypesSubtitle =>
      'د پیرودونکي پروفایل او امرونو لپاره لیبلونه';

  @override
  String get settingsMeasurementUnitTitle => 'د اندازې تلو واحد';

  @override
  String get settingsMeasurementUnitSubtitle =>
      'په نوي امر کې د جامو اندازې ثبتولو لپاره';

  @override
  String get tasksTitle => 'دندې';

  @override
  String get tasksSettingsSubtitle => 'ساده دندو لیست (آفلاین)';

  @override
  String get tasksSearchHint => 'دندې ولټوئ';

  @override
  String get tasksFilterAll => 'ټول';

  @override
  String get tasksFilterOpen => 'خلاص';

  @override
  String get tasksFilterDone => 'ترسره شوي';

  @override
  String get tasksEmpty => 'تر اوسه دنده نشته. خپله لومړۍ دنده زیاته کړئ.';

  @override
  String get tasksEmptyFiltered => 'په دې فلټر کې دنده نشته.';

  @override
  String get tasksAddTitle => 'دنده زیاتول';

  @override
  String get tasksEditTitle => 'دنده سمول';

  @override
  String get tasksTitleLabel => 'سرلیک';

  @override
  String get tasksNotesLabel => 'یادښتونه';

  @override
  String get tasksDueDatePick => 'د سررسید نیټه وټاکئ';

  @override
  String get tasksDueDateNone => 'سررسید نشته';

  @override
  String get tasksDueDateSet => 'ټاکل';

  @override
  String get tasksDueDateClear => 'سررسید پاک کړئ';

  @override
  String tasksDueDateShort(String date) {
    return 'سررسید: $date';
  }

  @override
  String tasksDueDateValue(String date) {
    return 'د سررسید نیټه: $date';
  }

  @override
  String get tasksSave => 'خوندي کول';

  @override
  String get tasksDeleteAction => 'ړنګول';

  @override
  String get tasksDeleteTitle => 'دنده ړنګ شي؟';

  @override
  String get tasksDeleteBody => 'دا به ستاسو له لیست څخه لرې کړي.';

  @override
  String get tasksDeleteCancel => 'لغوه';

  @override
  String get tasksDeleteConfirm => 'ړنګول';

  @override
  String get measurementTypesScreenTitle => 'د پیمانو ساحې';

  @override
  String get measurementTypesEmpty =>
      'لا ساحه نشته. هغه اندازې زیاتې کړئ چې هټۍ ثبتوي.';

  @override
  String get measurementTypesAddCta => 'ساحه زیاتول';

  @override
  String get measurementTypesFieldNameLabel => 'د ساحې نوم';

  @override
  String get measurementTypesRenameTitle => 'د ساحې نوم بدلول';

  @override
  String get measurementTypesDeleteTitle => 'ساحه لرې شي؟';

  @override
  String get measurementTypesDeleteBody =>
      'ساحه د نوو پیمانو لپاره پټه کېږي. په پروفایلونو او امرونو کې خوندي ارزښتونه پاتې کېږي.';

  @override
  String get measurementTypesActiveLabel => 'په کار کې';

  @override
  String get measurementTypesInactiveLabel => 'پټ';

  @override
  String get measurementTypesReorderHint => 'د ترتیب لپاره کش کړئ';

  @override
  String get measurementTypesCreated => 'ساحه زیاته شوه';

  @override
  String get measurementTypesUpdated => 'ساحه تازه شوه';

  @override
  String get measurementTypesDeleted => 'ساحه لرې شوه';

  @override
  String get reportsOverviewTitle => 'راپورونه';

  @override
  String get reportsUnpaidCardTitle => 'نه ورکړل شوی';

  @override
  String reportsUnpaidCardSubtitle(String amount) {
    return 'ټول پاتې: $amount';
  }

  @override
  String get reportsMonthlyIncomeTitle => 'میاشتنی عاید';

  @override
  String get reportsMonthlyIncomeSubtitle =>
      'ورکړې او پاتې بېلې د میاشتې تقویم له مخې';

  @override
  String get reportsThisMonthOpenUnpaidTitle => 'خلاص امرونه نه ورکړل شوي';

  @override
  String reportsThisMonthOpenUnpaidSubtitle(String amount) {
    return 'نوی / روان / چمتو: $amount';
  }

  @override
  String get reportsOrdersSummaryTitle => 'امرونه د حالت له مخې';

  @override
  String get reportsOrdersSummaryEmpty => 'تر اوسه امر نشته.';

  @override
  String get reportsDeliveredReportTitle => 'تحویلي شوی';

  @override
  String get reportsDeliveredCardTitle => 'تحویلي شوي امرونه';

  @override
  String get reportsDeliveredCardSubtitle => 'د تحویلي میاشتې له مخې';

  @override
  String get reportsDeliveredEmpty => 'په دې میاشت کې تحویلي شوی امر نشته.';

  @override
  String get reportsPaymentsLedgerTitle => 'د ورکړو دفتر';

  @override
  String get reportsPaymentsLedgerSubtitle => 'ورکړې د نیټې مودې له مخې لیست';

  @override
  String get reportsPaymentsPickRange => 'د نیټې موده وټاکئ';

  @override
  String get reportsPaymentsApplyRange => 'پلي کړئ';

  @override
  String get reportsPaymentsSelectedRangeLabel => 'ټاکل شوې موده';

  @override
  String reportsPaymentsRangeValue(String from, String to) {
    return '$from → $to';
  }

  @override
  String get reportsPaymentsTotalLabel => 'ټول';

  @override
  String get reportsPaymentsEmpty => 'په دې نیټې موده کې ورکړه نشته.';

  @override
  String get reportsPaymentsUnknownOrder => 'نامعلوم امر';

  @override
  String get reportsPaymentsAdjustmentChip => 'سمون';

  @override
  String reportsPaymentsSectionHeader(String title, String total) {
    return '$title — $total';
  }

  @override
  String reportsPaymentsWeekOfLabel(String weekStart) {
    return 'د اونۍ پیل $weekStart';
  }

  @override
  String get reportsPaymentsGroupByLabel => 'ډلې';

  @override
  String get reportsPaymentsGroupByDay => 'ورځ';

  @override
  String get reportsPaymentsGroupByWeek => 'اونۍ';

  @override
  String get reportsPaymentsGroupByMonth => 'میاشت';

  @override
  String get reportsMonthlyIncomePlaceholder =>
      'د میاشتې عاید راپور به دلته راشي.';

  @override
  String get reportsThisMonthIncomeTitle => 'د دې میاشتې عاید';

  @override
  String reportsThisMonthIncomeSubtitle(String amount) {
    return 'عاید: $amount';
  }

  @override
  String get reportsMonthlyIncomeCardLabel => 'ترلاسه شوې ورکړې';

  @override
  String get reportsMonthlyDailyPaymentsLabel => 'ورځنی ورکړې (د دې میاشتې)';

  @override
  String get reportsMonthlyUnpaidDueTitle =>
      'نه ورکړل شوی (د دې میاشتې سررسید)';

  @override
  String get reportsMonthlyUnpaidDueBody =>
      'د هغو امرونو پاتې بېلو مجموعه چې تحویلي نیټه یې په دې میاشت کې ده.';

  @override
  String get reportsPrevMonth => 'تیره میاشت';

  @override
  String get reportsNextMonth => 'بله میاشت';

  @override
  String get reportsUnpaidTotalLabel => 'ټول پاتې';

  @override
  String get reportsUnpaidEmpty => 'نه ورکړل شوی امر نشته.';

  @override
  String get reportsUnpaidFilteredEmpty =>
      'په دې فلټر کې نه ورکړل شوی امر نشته.';

  @override
  String get reportsUnpaidFilterSection => 'د تحویلي موده';

  @override
  String get reportsUnpaidFilterAll => 'ټول';

  @override
  String get reportsUnpaidFilterOverdue => 'وروسته پاتې';

  @override
  String get reportsUnpaidFilterDueSoon => 'په ۷ ورځو کې سررسید';

  @override
  String get reportsUnpaidAmountSection => 'پاتې بېله';

  @override
  String get reportsUnpaidAmountAny => 'هره بېله';

  @override
  String get reportsUnpaidAmountUnder5000 => 'د ۵٬۰۰۰ لاندې';

  @override
  String get reportsUnpaidAmount5000to20000 => '۵٬۰۰۰ – ۲۰٬۰۰۰';

  @override
  String get reportsUnpaidAmountOver20000 => 'د ۲۰٬۰۰۰ پورته';

  @override
  String get reportsUnpaidSortSection => 'ترتیب';

  @override
  String get reportsUnpaidSortAmount => 'بېله';

  @override
  String get reportsUnpaidSortDueDate => 'د سررسید نیټه';

  @override
  String get reportsMonthlyCompareToggle => 'د تیرې میاشتې سره پرتله';

  @override
  String get reportsMonthlyPreviousPaymentsLabel => 'تیره میاشت (ورکړې)';

  @override
  String get reportsMonthlyDeltaLabel => 'د تیرې میاشتې څخه بدلون';

  @override
  String get reportsMonthlyDeltaSame => 'بدلون نشته';

  @override
  String reportsRemainingChip(String amount) {
    return '$amount پاتې';
  }

  @override
  String get catalogMyDesigns => 'زما ډیزاینونه';

  @override
  String get catalogSharedDesigns => 'شریک ډیزاینونه';

  @override
  String get catalogGridView => 'ګریډ لید';

  @override
  String get catalogListView => 'لیست لید';

  @override
  String get catalogSearchHint => 'ډیزاین یا د هټۍ نوم ولټوئ';

  @override
  String get catalogSortTooltip => 'ترتیب';

  @override
  String get catalogSortSheetTitle => 'ډیزاینونه ترتیب کړئ';

  @override
  String get catalogSortSectionTitle => 'ترتیب له مخې';

  @override
  String get catalogSortNewest => 'لومړی نوي';

  @override
  String get catalogSortOldest => 'لومړی زړي';

  @override
  String get catalogSortNameAsc => 'نوم الف-ی';

  @override
  String get catalogSortNameDesc => 'نوم ی-الف';

  @override
  String get catalogResetSort => 'بیا تنظیم';

  @override
  String get catalogApplySort => 'پلي کړئ';

  @override
  String get catalogSharedDirectoryEmpty => 'په شریک فهرست کې لا نه دی.';

  @override
  String get catalogCommunityReadOnlyBanner =>
      'شریک فهرست — یوازې لید. د بلې هټۍ ننوتل نشئ سمولی یا ړنګولی.';

  @override
  String get catalogSharingToggleTitle => 'د کتلاګ شریکول فعال کړئ';

  @override
  String get catalogSharingToggleSubtitle =>
      'دوه اړخیزه: د عامه فهرست لیدلو او ښودلو لپاره فعال کړئ.';

  @override
  String get catalogSharedPlaceholder =>
      'شریک ډیزاینونه به آنلاین کې دلته ښکاره شي.';

  @override
  String get catalogEmptyMyDesigns => 'لا ډیزاین نشته.';

  @override
  String get catalogAddDesignCta => 'ډیزاین زیاتول';

  @override
  String get catalogViewDescription => 'تشریح';

  @override
  String get catalogDescriptionSheetTitle => 'تشریح';

  @override
  String get catalogNoDescription => 'د دې ډیزاین لپاره تشریح نشته.';

  @override
  String get catalogViewerManageA11y => 'ډیزاین مدیریت';

  @override
  String get catalogAddDesignPlaceholder =>
      'د کیمرې/ګالري زیاتول یوازې په اندروید/iOS کې.';

  @override
  String get catalogDetailTitle => 'د کتلاګ توکی';

  @override
  String catalogDetailPlaceholder(String id) {
    return 'کتلاګ توکی $id — جزئیات ژر راځي.';
  }

  @override
  String get settingsSectionAccountAndShop => 'حساب او هټۍ';

  @override
  String get settingsSectionUsers => 'کارنان';

  @override
  String get settingsSectionBackupRestore => 'بیکاپ او بیرته راوړل';

  @override
  String get settingsSectionNotifications => 'خبرتیاوې';

  @override
  String get settingsSectionSyncDiagnostics => 'سنک او تشخیص';

  @override
  String get settingsSectionAppearanceLanguage => 'بڼه او ژبه';

  @override
  String get settingsSectionAbout => 'په اړه';

  @override
  String get settingsSectionDeveloper => 'پراختیاګر';

  @override
  String get settingsShopTileTitle => 'د هټۍ پروفایل';

  @override
  String get settingsShopTileSubtitle => 'د هټۍ جزئیات به دلته ښکاري.';

  @override
  String get settingsCurrentUserTitle => 'حساب';

  @override
  String get settingsAccountTitle => 'حساب';

  @override
  String get settingsAccountUsernameLabel => 'کارن نوم';

  @override
  String get settingsAccountUsernameHint =>
      'کارن نوم د هټۍ مالک ټاکي؛ دلته نشي بدلېدلی.';

  @override
  String get settingsAccountRoleLabel => 'رول';

  @override
  String get settingsAccountChangePasswordTitle => 'پاسورډ بدلول';

  @override
  String get settingsAccountChangePasswordSubtitle =>
      'د راتلونکي ننوتلو لپاره پاسورډ تازه کړئ.';

  @override
  String get settingsAccountCurrentPasswordLabel => 'اوسنی پاسورډ';

  @override
  String get settingsAccountNewPasswordLabel => 'نوی پاسورډ';

  @override
  String get settingsAccountConfirmPasswordLabel => 'نوی پاسورډ تایید';

  @override
  String get settingsAccountChangePasswordCta => 'پاسورډ تازه کړئ';

  @override
  String get settingsAccountChangePasswordOk =>
      'پاسورډ تازه شو. بل ځل له نوي پاسورډ سره ننوځئ.';

  @override
  String settingsAccountChangePasswordFail(String error) {
    return 'پاسورډ نشو تازه کېدلی: $error';
  }

  @override
  String get settingsAccountPasswordMismatch => 'نوي پاسورډونه سره نه خوري.';

  @override
  String get settingsAccountOfflineHint =>
      'د پاسورډ بدلولو لپاره سرور ته وصل شئ.';

  @override
  String get settingsAccountForgotPasswordCta =>
      'د ملاتړ له لارې د پاسورډ بیا تنظیم غوښتنه';

  @override
  String get settingsUsersReadOnlyHint =>
      'یوازې د هټۍ مالک کارن زیاتولی یا لرې کولی شي.';

  @override
  String get settingsSignOutTitle => 'وتل';

  @override
  String get settingsSignOutSubtitle => 'په دې وسیله کې دا ناسته پای ته ورکړئ';

  @override
  String get settingsSignOutDialogTitle => 'وتل؟';

  @override
  String get settingsSignOutDialogBody => 'د دوام لپاره بیا باید ننوځئ.';

  @override
  String get settingsSignOutCancel => 'لغوه';

  @override
  String get settingsSignOutConfirm => 'وتل';

  @override
  String get settingsRoleOwner => 'مالک';

  @override
  String get settingsRoleUser => 'کارن';

  @override
  String get settingsOwnerOnly => 'یوازې مالک';

  @override
  String get settingsUsersTitle => 'کارن مدیریت';

  @override
  String get settingsUsersSubtitleOwner =>
      'ازمایښت: ۲ کارن • ورکړل شوی: ۵ کارن';

  @override
  String get settingsUsersPlaceholder => 'د کارنو مدیریت به ژر پلي شي.';

  @override
  String get settingsBackupRestoreTitle => 'بیکاپ او بیرته راوړل';

  @override
  String get settingsBackupRestoreSubtitleOwner =>
      'د هټۍ ډیټا په خوندي ډول صادرول او بیرته راوړل';

  @override
  String get settingsBackupRestorePlaceholder =>
      'بیکاپ/بیرته راوړل به ژر پلي شي.';

  @override
  String get settingsMuteNotificationsTitle => 'خبرتیاوې بې غږ';

  @override
  String get settingsMuteNotificationsSubtitle =>
      'په اپ کې بنرونه او نښې بې غږ کړئ (تاریخ ساتل کېږي).';

  @override
  String get settingsNotificationsInboxTitle => 'د خبرتیاو صندوق';

  @override
  String get settingsNotificationsInboxSubtitle => 'تاریخ او فلټرونه.';

  @override
  String get settingsNotificationsPlaceholder =>
      'د خبرتیاو صندوق به ژر پلي شي.';

  @override
  String get settingsSyncDiagnosticsTitle => 'سنک او تشخیص';

  @override
  String get settingsNetworkStatusTitle => 'شبکه';

  @override
  String get settingsNetworkStatusOnline => 'نښلول شوی';

  @override
  String get settingsNetworkStatusOffline => 'آفلاین — محلي کار';

  @override
  String get settingsApiServerTitle => 'API پالنه';

  @override
  String get settingsApiServerNotConfigured =>
      'URL نه دی. د چلولو یا build کې --dart-define=API_BASE_URL=https://... وکاروئ.';

  @override
  String settingsApiServerConfigured(String url) {
    return 'بنسټ URL: $url';
  }

  @override
  String get settingsApiTestConnection => 'پیوستون ازموینه';

  @override
  String get settingsApiTestNeedOnline =>
      'د پالن ازموینې لپاره انټرنټ ته ونښلئ.';

  @override
  String get settingsApiHealthOk => 'پالن ځواب ورکړ (GET /health).';

  @override
  String settingsApiHealthFailed(String message) {
    return 'پالن نشي رسېدلی: $message';
  }

  @override
  String get settingsSyncDiagnosticsSubtitle => 'وروستی سنک، قطار، صندوق.';

  @override
  String get settingsSyncDiagnosticsPlaceholder => 'سنک او تشخیص به ژر پلي شي.';

  @override
  String get settingsAppearanceLanguageTitle => 'بڼه او ژبه';

  @override
  String get settingsAppearanceLanguageSubtitle => 'تم او ژبه';

  @override
  String get settingsAboutTitle => 'په اړه';

  @override
  String get settingsAboutSubtitle => 'د اپ معلومات او نسخه';

  @override
  String get settingsVersionTitle => 'نسخه';

  @override
  String get settingsBuildTitle => 'بسته';

  @override
  String get settingsDeveloperPortalTitle => 'د پراختیاګر پورټل';

  @override
  String get settingsDeveloperPortalSubtitle =>
      'پرمختللې وسیلې (یوازې د پراختیاګر حسابونه).';

  @override
  String get settingsDeveloperPortalPlaceholder =>
      'د پراختیاګر پورټل پاڼې به ژر پلي شي.';

  @override
  String get settingsDevRolesTitle => 'د رول بدلونونه (پراختیا)';

  @override
  String get settingsDevRoleOwnerTitle => 'د مالک حساب تقلید';

  @override
  String get settingsDevRoleOwnerSubtitle => 'یوازې د مالک برخې خلاصوي.';

  @override
  String get settingsDevRoleDeveloperTitle => 'د پراختیاګر حساب تقلید';

  @override
  String get settingsDevRoleDeveloperSubtitle => 'د پراختیا پورټل ننوت ښیي.';

  @override
  String get settingsThemeTitle => 'تم';

  @override
  String get themeSystem => 'سیستم';

  @override
  String get themeLight => 'روښانه';

  @override
  String get themeDark => 'تیاره';

  @override
  String get settingsSectionSoundFeedback => 'غږ او غبرګون';

  @override
  String get settingsUiSoundsTitle => 'د انټرفیس غږونه';

  @override
  String get settingsUiSoundsSubtitle =>
      'کله چې خوندي، ړنګ یا بشپړ کړئ لنډ غږ.';

  @override
  String get settingsUiHapticsTitle => 'لمسی لرزش';

  @override
  String get settingsUiHapticsSubtitle => 'د بریالۍ کړنې لپاره سپک لرزش.';

  @override
  String get settingsUiHapticsWebHint => 'په ویب کې لرزش نشته.';

  @override
  String get settingsSoundPreviewSuccess => 'بریالی';

  @override
  String get settingsSoundPreviewError => 'تېروتنه';

  @override
  String get settingsSoundPreviewDelete => 'ړنګول';

  @override
  String get ordersDetailPaymentProgress => 'د تادیې پرمختګ';

  @override
  String get ordersComposerProgressTitle => 'د امر پرمختګ';

  @override
  String ordersComposerProgressCount(int done, int total) {
    return '$done له $total ګامونو';
  }

  @override
  String get ordersComposerProgressCustomer => 'پیرودونکی';

  @override
  String get ordersComposerProgressMeasurements => 'اندازې';

  @override
  String get ordersComposerProgressStyle => 'سټایل';

  @override
  String get ordersComposerProgressFabric => 'کپړه';

  @override
  String get ordersComposerProgressDelivery => 'سپارل';

  @override
  String get ordersComposerProgressPayment => 'تادیه';

  @override
  String get settingsLanguageTitle => 'ژبه';

  @override
  String get languageSystem => 'سیستم';

  @override
  String get languageEnglish => 'انګلیسي';

  @override
  String get languageDari => 'دري';

  @override
  String get languagePashto => 'پښتو';

  @override
  String get settingsDateCalendarTitle => 'د نیټې تقویم';

  @override
  String get settingsDateCalendarSubtitle =>
      'په اپ کې نیټې څنګه ښکاري او غوره کېږي';

  @override
  String get dateCalendarGregorian => 'میلادي (عیسوي)';

  @override
  String get dateCalendarSolarHijri => 'لمریز هجري (افغان)';

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
  String get datePickerSolarHijriTitle => 'نیټه وټاکئ (لمریز هجري)';

  @override
  String get datePickerSolarHijriRangeTitle => 'د نیټې موده وټاکئ (لمریز هجري)';

  @override
  String get datePickerYearLabel => 'کال';

  @override
  String get datePickerMonthLabel => 'میاشت';

  @override
  String get datePickerDayLabel => 'ورځ';

  @override
  String get dateRangeFromLabel => 'له';

  @override
  String get dateRangeToLabel => 'تر';

  @override
  String get settingsComingSoon => 'ژر راځي.';

  @override
  String get loading => 'بارېږي…';

  @override
  String get genericError => 'یو څه ستونزه رامنځته شوه.';

  @override
  String get resetCta => 'بیا تنظیم';

  @override
  String get licenseGraceReadOnlySnack =>
      'یوازې لوستل تر هغه چې جواز آنلاین تایید شي.';

  @override
  String get licenseClockTamperSnack =>
      'یوازې لوستل: د وسیلې وخت ناسم ښکاري. آنلاین ګډون پرانیزئ او تایید کړئ.';

  @override
  String get licenseExpiredReadOnly => 'جواز پای ته رسېدلی — یوازې لوستل.';

  @override
  String moneyAfn(String amount) {
    return '$amount افغانی';
  }

  @override
  String get ordersComposerCustomerTitle => 'پیرودونکی';

  @override
  String get ordersComposerCustomerRequired => 'پیرودونکی وټاکئ (اړین)';

  @override
  String get ordersComposerMeasurementsTitle => 'پیمانې';

  @override
  String get ordersComposerMeasurementsRequired => 'پیمانې زیاتې کړئ (اړین)';

  @override
  String get ordersComposerMeasurementsSummary => 'پیمانې ثبت شوې';

  @override
  String get ordersComposerMeasurementsLabel => 'د پیمانو یادښتونه';

  @override
  String get ordersComposerMeasurementsHint =>
      'پیمانې ولیکئ یا د پیرودونکي خوندي پروفایل بار کړئ.';

  @override
  String get ordersComposerLoadProfileCta => 'له خوندي پروفایل بار کړئ';

  @override
  String ordersComposerProfileLinked(String name) {
    return 'له پروفایل: $name';
  }

  @override
  String get ordersComposerPaymentTitle => 'ورکړه';

  @override
  String get ordersComposerPaymentRequired => 'ټولې بېلې ولیکئ (اړین)';

  @override
  String ordersComposerPaymentSummary(
    String total,
    String paid,
    String remaining,
  ) {
    return 'ټول $total • ورکړل شوی $paid • پاتې $remaining';
  }

  @override
  String get ordersComposerTotalLabel => 'ټوله بېله (افغانی)';

  @override
  String get ordersComposerTotalHint => 'بېلګه: 1500';

  @override
  String get ordersComposerPaidLabel => 'لومړنۍ ورکړه (افغانی)';

  @override
  String get ordersComposerPaidHint => 'بېلګه: 500';

  @override
  String get ordersComposerDueLabel => 'پاتې';

  @override
  String get ordersComposerPaymentSheetTitle => 'Payment';

  @override
  String get ordersComposerPaymentInitialOnSaveHint =>
      'Initial payment is recorded when you save the order.';

  @override
  String get ordersPaymentInitialExceedsTotal =>
      'لومړنۍ ورکړه د امر ټولې بېلې څخه زیاته نشي.';

  @override
  String get ordersPaymentExceedsRemaining =>
      'ورکړه د پاتې پیسو څخه زیاته نشي.';

  @override
  String get ordersPaymentTotalBelowPaid =>
      'د امر ټوله بېله له ورکړل شوي پیسو څخه لږه نشي.';

  @override
  String get ordersPaymentSheetSavedTitle => 'Payments';

  @override
  String get ordersPaymentHistoryTitle => 'Payment history';

  @override
  String get ordersPaymentSignedHint =>
      'مثبت ولیکئ زیاتولو لپاره. د دې ساحې څخه کمولو لپاره منفي (لکه -500).';

  @override
  String ordersPaymentDepositLabel(int n) {
    return 'ورکړه $n';
  }

  @override
  String get ordersPaymentNextPaymentLabel => 'راتلونکې ورکړه';

  @override
  String get ordersPaymentRecordCta => 'ثبت';

  @override
  String get ordersPaymentNegativeInvalid => 'پیسې صفر څخه لږې نشي.';

  @override
  String get ordersPaymentNextMustBePositive => 'راتلونکې ورکړه باید مثبت وي.';

  @override
  String get ordersEditConfirmTitle => 'بدلونونه خوندي شي؟';

  @override
  String get ordersEditConfirmBody => 'دا امر ستاسو بدلونونو سره تازه شي؟';

  @override
  String get ordersDetailEditCustomerTitle => 'پیرودونکی سمول';

  @override
  String get ordersDetailCustomerPickFromList => 'له لیست څخه غوره کړئ';

  @override
  String get ordersDetailCustomerHistoryTitle => 'د پیرودونکي د بدلون تاریخچه';

  @override
  String ordersDetailCustomerHistoryChange(
    String fromName,
    String fromPhone,
    String toName,
    String toPhone,
  ) {
    return 'مخکې $fromName ($fromPhone) → اوس $toName ($toPhone)';
  }

  @override
  String get ordersStatusChangeConfirmTitle => 'حالت بدل شي؟';

  @override
  String ordersStatusChangeConfirmBody(String status) {
    return 'د امر حالت $status ته بدل شي؟';
  }

  @override
  String get ordersCancelOrderConfirmTitle => 'دا امر لغوه شي؟';

  @override
  String get ordersCancelOrderConfirmBody =>
      'د لغوه کولو تایید لپاره د پیرودونکي نوم ولیکئ.';

  @override
  String get ordersDetailEditCta => 'سمون';

  @override
  String get ordersComposerDeliveryDateTitle => 'د تحویلي نیټه';

  @override
  String get ordersComposerDeliveryDateUnset => 'د تحویلي نیټه وټاکئ';

  @override
  String get ordersComposerSaveCta => 'امر خوندي کړئ';

  @override
  String get ordersComposerSaved => 'امر خوندي شو.';

  @override
  String get ordersComposerResetTitle => 'فورمه بیا تنظیم شي؟';

  @override
  String get ordersComposerResetBody => 'ټول ډک شوي ساحې به پاک شي.';

  @override
  String get ordersComposerSelectCustomerFirstTitle => 'لومړی پیرودونکی وټاکئ';

  @override
  String get ordersComposerSelectCustomerFirstBody =>
      'مهرباني وکړئ مخکې له دوامه پیرودونکی وټاکئ.';

  @override
  String get ordersComposerValidationTitle => 'اړین ګامونه بشپړ کړئ';

  @override
  String get ordersComposerValidationBody =>
      'د دې امر خوندي کولو مخکې لاندې برخې ډکې کړئ:';

  @override
  String get ordersComposerRecentOrdersTitle => 'وروستي امرونه';

  @override
  String get ordersComposerRecentOrdersSubtitle => 'د دې پیرودونکي لپاره';

  @override
  String ordersComposerRecentOrderRowSubtitle(String date, String remaining) {
    return '$date • پاتې $remaining';
  }

  @override
  String get ordersComposerMeasurementsSheetTitle => 'پیمانې';

  @override
  String get ordersComposerMeasurementsNoTypesBody =>
      'لومړی په تنظیمات → د پیمانو ډولونه زیات کړئ.';

  @override
  String ordersComposerMeasurementsProfileAutoLabel(String date) {
    return 'نمونه #$date';
  }

  @override
  String get ordersComposerSaveMeasurementsToProfile =>
      'د پیرودونکي پروفایل په توګه خوندي کړئ';

  @override
  String get ordersComposerSaveMeasurementsToProfileSubtitle =>
      'د ټاکل شوي پیرودونکي خوندي پیمانې تازه کېږي.';

  @override
  String get ordersComposerAddMeasurementsCta => 'پیمانې زیات کړئ';

  @override
  String get ordersComposerStyleTitle => 'سټایل';

  @override
  String get ordersComposerFabricTitle => 'د پیرودونکي کپړه';

  @override
  String get ordersComposerFabricOptional =>
      'اختیاري — کپړه چې پیرودونکی راوړي';

  @override
  String ordersComposerFabricSummary(String name, String color, String id) {
    return '$name • $color • پېژند $id';
  }

  @override
  String ordersComposerFabricPartialSummary(String name, String color) {
    return '$name • $color';
  }

  @override
  String get ordersComposerFabricUnset => 'کپړه ثبت شوې نه ده';

  @override
  String get ordersComposerFabricSheetTitle => 'د پیرودونکي کپړه';

  @override
  String get ordersComposerFabricNameLabel => 'د کپړې نوم';

  @override
  String get ordersComposerFabricNameHint => 'غوره کړئ یا ولیکئ';

  @override
  String get ordersComposerFabricColorLabel => 'د کپړې رنګ';

  @override
  String get ordersComposerFabricColorHint => 'غوره کړئ یا ولیکئ';

  @override
  String get ordersComposerFabricIdLabel => 'د کپړې پېژند';

  @override
  String get ordersComposerFabricIdHint =>
      'په خوندي کولو سره په اوتومات ډول ورکړیږي';

  @override
  String get ordersComposerFabricClearCta => 'کپړه پاک کړئ';

  @override
  String get ordersComposerStyleRequired => 'سټایل اضافه کړئ (اړین)';

  @override
  String get ordersComposerStyleSummary => 'سټایل وټاکل شو';

  @override
  String get ordersComposerStyleSheetTitle => 'د امر سټایل';

  @override
  String get ordersComposerStyleMainTitle => 'د جامې اصلي سټایل نوم';

  @override
  String get ordersComposerStyleCustomLabel => 'د سټایل نوم';

  @override
  String get ordersComposerStyleCustomHint => 'پورته وټاکئ یا خپل ولیکئ';

  @override
  String get ordersComposerStyleFiguresTitle => 'د ډیزاین شکلونه';

  @override
  String get ordersComposerStyleNoFigures =>
      'لا ډیزاین شکل نشته — په تنظیمات → د امر سټایل کې زیات کړئ.';

  @override
  String get ordersComposerStyleClearFigures => 'ټول انتخابونه پاک کړئ';

  @override
  String get ordersComposerCatalogDesignTitle => 'بشپړ ډیزاین له کتلاګ';

  @override
  String get ordersComposerCatalogDesignNone => 'کتلاګ ډیزاین نه دی ټاکل شوی';

  @override
  String get ordersComposerCatalogChooseCta => 'له کتلاګ وټاکئ';

  @override
  String get ordersComposerCatalogClearCta => 'ډیزاین پاک کړئ';

  @override
  String get ordersComposerCatalogPickerTitle => 'زما ډیزاینونه';

  @override
  String get ordersComposerCatalogPickerEmpty =>
      'ستاسو کتلاګ کې لا ډیزاین نشته. په کتلاګ ټب کې ډیزاین اضافه کړئ.';

  @override
  String get customerLastCatalogDesignLabel => 'وروستی کتلاګ ډیزاین';

  @override
  String get orderDetailCatalogDesignTitle => 'بشپړ ډیزاین';

  @override
  String get receiptCatalogDesignLabel => 'ډیزاین';

  @override
  String get invoiceCatalogDesignLabel => 'کتلاګ ډیزاین';

  @override
  String get invoiceCatalogDesignerLabel => 'ډیزاینر';

  @override
  String get settingsStyleHubTitle => 'د امر سټایل';

  @override
  String get settingsStyleTileTitle => 'د امر سټایل';

  @override
  String get settingsStyleTileSubtitle => 'د سټایل نومونه او د ډیزاین شکلونه';

  @override
  String get settingsFabricHubTitle => 'د پیرودونکي کپړه';

  @override
  String get settingsFabricHubSubtitle => 'د امرونو لپاره نومونه او رنګونه';

  @override
  String get settingsFabricNamesTitle => 'د کپړو نومونه';

  @override
  String get settingsFabricNamesSubtitle => 'پنبه، وړۍ او نور ډولونه';

  @override
  String get settingsFabricNamesEmpty => 'لا نوم نشته.';

  @override
  String get settingsFabricNameAddCta => 'نوم زیات کړئ';

  @override
  String get settingsFabricNameFieldLabel => 'نوم';

  @override
  String get settingsFabricNameRenameTitle => 'نوم بدل کړئ';

  @override
  String get settingsFabricNameDeleteTitle => 'د کپړې نوم ړنګ کړئ؟';

  @override
  String get settingsFabricNameDeleteBody =>
      'له لیست څخه لرې کېږي. پخواني امرونه بدل نه کېږي.';

  @override
  String get settingsFabricColorsTitle => 'د کپړو رنګونه';

  @override
  String get settingsFabricColorsSubtitle => 'تور نیلي، کرېم او نور';

  @override
  String get settingsFabricColorsEmpty => 'لا رنګ نشته.';

  @override
  String get settingsFabricColorAddCta => 'رنګ زیات کړئ';

  @override
  String get settingsFabricColorFieldLabel => 'رنګ';

  @override
  String get settingsFabricColorRenameTitle => 'رنګ بدل کړئ';

  @override
  String get settingsFabricColorDeleteTitle => 'رنګ ړنګ کړئ؟';

  @override
  String get settingsFabricColorDeleteBody =>
      'له لیست څخه لرې کېږي. پخواني امرونه بدل نه کېږي.';

  @override
  String get settingsFabricActiveLabel => 'فعال';

  @override
  String get settingsFabricInactiveLabel => 'پټ';

  @override
  String get settingsStyleNamesTitle => 'د جامې سټایل نومونه';

  @override
  String get settingsStyleNamesSubtitle => 'قاسمي، کندهاري او نور';

  @override
  String get settingsStyleNamesEmpty => 'لا نوم نشته.';

  @override
  String get settingsStyleNameAddCta => 'نوم زیات کړئ';

  @override
  String get settingsStyleNameFieldLabel => 'نوم';

  @override
  String get settingsStyleNameRenameTitle => 'نوم بدل کړئ';

  @override
  String get settingsStyleNameDeleteTitle => 'نوم ړنګ کړئ؟';

  @override
  String get settingsStyleNameDeleteBody =>
      'له لست څخه لرې کېږي. پخواني امرونه بدل نه کېږي.';

  @override
  String get settingsStylePartsTitle => 'د جامې برخې';

  @override
  String get settingsStylePartsSubtitle => 'اوږه، یخن، جیب او نور';

  @override
  String get settingsStylePartsEmpty => 'لا برخه نشته.';

  @override
  String get settingsStylePartAddCta => 'برخه زیات کړئ';

  @override
  String get settingsStylePartFieldLabel => 'د برخې نوم';

  @override
  String get settingsStylePartRenameTitle => 'د برخې نوم بدل کړئ';

  @override
  String get settingsStylePartDeleteTitle => 'برخه ړنګ کړئ؟';

  @override
  String get settingsStylePartDeleteBody => 'د دې برخې شکلونه هم لرې کېږي.';

  @override
  String get settingsStyleFiguresTitle => 'د ډیزاین شکلونه';

  @override
  String get settingsStyleFiguresSubtitle => 'ټول د ډیزاین انځورونه';

  @override
  String get settingsStyleFiguresEmpty => 'لا ډیزاین شکل نشته.';

  @override
  String get settingsStyleFigurePartLabel => 'د جامې برخه';

  @override
  String get settingsStyleFigureAddCta => 'شکل زیات کړئ';

  @override
  String get settingsStyleFigureNameLabel => 'د شکل نوم';

  @override
  String get settingsStyleFigureDeleteTitle => 'شکل ړنګ کړئ؟';

  @override
  String get settingsStyleFigureDeleteBody => 'له کتلاګ څخه لرې کېږي.';

  @override
  String get settingsStyleFigureWebOnlyBody =>
      'خپل انځور په اندروید او iOS زیاتېږي. ډیفالټ شکلونه په ویب کې کار کوي.';

  @override
  String get settingsStyleActiveLabel => 'فعال';

  @override
  String get settingsStyleInactiveLabel => 'غیرفعال';

  @override
  String get saveCta => 'ساتل';

  @override
  String get customersCreated => 'پیرودونکی جوړ شو.';

  @override
  String get customerNameLabel => 'نوم';

  @override
  String get customerNameHint => 'بېلګه: احمد کریمي';

  @override
  String get customerNameRequired => 'نوم اړین دی.';

  @override
  String get customerNameTooShort => 'نوم ډېر لنډ دی.';

  @override
  String get customerPhoneLabel => 'تلیفون (اختیاري)';

  @override
  String get customerPhoneHint => 'بېلګه: 0700000001';

  @override
  String get saved => 'ساتل شو.';

  @override
  String get deleted => 'ړنګ شو.';

  @override
  String get editCta => 'سمول';

  @override
  String get deleteCta => 'ړنګول';

  @override
  String deleteByTypingConfirmHint(String expected) {
    return 'د تایید لپاره لاندې «$expected» ولیکئ.';
  }

  @override
  String get deleteByTypingConfirmFieldLabel => 'تایید';

  @override
  String get deleteByTypingConfirmMismatch => 'سمون نه خوري. املا وګورئ.';

  @override
  String get deleteConfirmTitle => 'ړنګ شي؟';

  @override
  String get deleteConfirmBody => 'دا کړنه بیرته نشي راګرځېدلی.';

  @override
  String get catalogItemNotFound => 'دا کتلاګ توکی ونه موندل شو.';

  @override
  String get catalogEditMetadataTitle => 'معلومات سمول';

  @override
  String get catalogDesignNameLabel => 'د ډیزاین نوم';

  @override
  String get catalogDesignNameHint => 'بېلګه: کرزي کورتی';

  @override
  String get catalogNotesLabel => 'یادښتونه (اختیاري)';

  @override
  String get catalogNotesHint => 'هر جز چې یادول غواړئ…';

  @override
  String catalogDeleteConfirmBody(String name) {
    return '«$name» ړنګ شي؟';
  }

  @override
  String catalogDesignerAndDate(String shop, String date) {
    return '$shop • $date';
  }

  @override
  String get catalogSharePublicTitle => 'عامه شریکول';

  @override
  String get catalogSharePublicSubtitle =>
      'که فعال وي، دا ډیزاین په عامه فهرست کې ښکاره کېدی شي (یوازې معلومات).';

  @override
  String get catalogSharePublicDisabledSubtitle =>
      'د کارولو لپاره په کتلاګ کې شریکول فعال کړئ.';

  @override
  String get catalogNotesTitle => 'یادښتونه';

  @override
  String get catalogNotesEmpty => 'یادښت نشته';

  @override
  String get catalogAddNotAvailableOnWeb => 'په ویب کې انځور زیاتول نشي.';

  @override
  String get catalogDesignNameRequired => 'د ډیزاین نوم اړین دی.';

  @override
  String get catalogImageRequired => 'لومړی انځور وټاکئ.';

  @override
  String get catalogCreated => 'ډیزاین زیات شو.';

  @override
  String get catalogMyShopNameFallback => 'زما هټۍ';

  @override
  String get cameraCta => 'کیمره';

  @override
  String get galleryCta => 'ګالري';

  @override
  String get dashboardKpisSectionTitle => 'په یوه کتنه';

  @override
  String get dashboardQuickLinksTitle => 'چټک لینکونه';

  @override
  String get dashboardThisMonthIncomeTitle => 'د دې میاشتې عاید';

  @override
  String get dashboardLicenseExpiredBanner =>
      'ستاسو جواز پای ته رسېدلی. د بیا سمون لپاره نوي کړئ.';

  @override
  String get dashboardLicenseGraceBanner =>
      'له سرور د جواز تایید وروسته ډېر وخت آفلاین یاست. ګډون پرانیزئ او آنلاین تازه کړئ.';

  @override
  String get dashboardLicenseClockTamperBanner =>
      'د وسیلې وخت ممکن بدل شوی وي. آنلاین شئ او په ګډون کې جواز تازه کړئ.';

  @override
  String get dashboardTodayDeliveriesTitle => 'نن تحویلي شوي';

  @override
  String get dashboardTodayDeliveriesEmpty => 'نن تحویلي شوی امر نشته.';

  @override
  String get dashboardSearchOrdersHint => 'د امر #، پیرودونکی، تلیفون ولټوئ';

  @override
  String get dashboardSearchOrdersTooltip => 'امرونه ولټوئ';

  @override
  String get dashboardOverdueTitle => 'وروسته پاتې تحویلۍ';

  @override
  String get dashboardOverdueEmpty => 'خلاص وروسته پاتې امر نشته.';

  @override
  String get dashboardOverdueViewAll => 'ټول وروسته پاتې وګورئ';

  @override
  String get dashboardQuickLinkOverdue => 'وروسته پاتې امرونه';

  @override
  String get dashboardQuickLinkDeliveredToday => 'نن تحویلي شوي';

  @override
  String get shellAppBarSyncA11y => 'د سنک حالت';

  @override
  String get shellAppBarNotificationsA11y => 'خبرتیاوې';

  @override
  String get shellAppBarNotificationsMutedA11y => 'خبرتیاوې (بې غږ)';

  @override
  String get shellSyncStatusOfflineChip => 'آفلاین';

  @override
  String get shellSyncTooltipNever =>
      'د سرور سنک لا نښلول شوی نه دی. ستاسو ډیټا په دې وسیله پاتې ده.';

  @override
  String get shellSyncTooltipOffline =>
      'شبکه نشته. کار دوام لري؛ بدلونونه په دې وسیله پاتې دي.';

  @override
  String shellSyncTooltipLast(String when) {
    return 'وروستی بریالی سنک: $when';
  }

  @override
  String get dashboardNotificationsPreviewTitle => 'وروستۍ خبرتیاوې';

  @override
  String get dashboardNotificationsPreviewEmpty => 'تر اوسه خبرتیا نشته.';

  @override
  String get dashboardNotificationsMutedHint =>
      'خبرتیاوې بې غږ دي. په تنظیمات → خبرتیاوې بدل کړئ.';

  @override
  String get dashboardNotificationsViewAll => 'ټولې خبرتیاوې وګورئ';

  @override
  String get notifSeedWelcomeTitle => 'افغان پراید ته ښه راغلاست';

  @override
  String get notifSeedWelcomeBody =>
      'د امر تازه معلومات او د هټۍ خبرتیاوې به دلته ښکاره شي. د لوستلو لپاره کرښه پرانیزئ.';

  @override
  String notifOrderStatusTitle(String orderNo) {
    return 'امر $orderNo';
  }

  @override
  String notifOrderStatusBody(String status) {
    return 'حالت $status ته تازه شو.';
  }

  @override
  String get settingsNotifMarkAllRead => 'ټول لوستل شوي وګرځوئ';

  @override
  String get subscriptionCurrentStatusTitle => 'اوسنی حالت';

  @override
  String get subscriptionReadOnlyHint => 'تر نوي کولو پورې یوازې لید.';

  @override
  String get subscriptionGraceReadOnlyHint =>
      'یوازې لوستل تر هغه چې سرور جواز تایید کړي. آنلاین شئ او لاندې «د جواز حالت تازه کړئ» ووهئ.';

  @override
  String get subscriptionClockTamperHint =>
      'یوازې لوستل تر هغه چې سرور د وخت ازموینې وروسته جواز تایید کړي. آنلاین «تازه کړئ» ووهئ.';

  @override
  String get subscriptionActivationTitle => 'فعالول';

  @override
  String get subscriptionActivationCodeLabel => 'د فعالولو کوډ';

  @override
  String get subscriptionActivationCodeHint =>
      'د بلینګ نښلولو وخت کې کوډ ولیکئ';

  @override
  String get subscriptionActivateCta => 'فعالول';

  @override
  String get subscriptionActivationComingSoon => 'فعالول به سرور سره ونښلوي.';

  @override
  String get subscriptionRefreshStatusCta => 'د جواز حالت تازه کړئ';

  @override
  String get subscriptionRefreshComingSoon =>
      'آنلاین تازه کول به د API نښلولو سره شتون ولري.';

  @override
  String get subscriptionActivationCodeHintApi =>
      'د خپل توزیع کوونکي فعالولو کوډ ولیکئ.';

  @override
  String get subscriptionApplying => 'پلي کېږي…';

  @override
  String get subscriptionRefreshing => 'تازه کېږي…';

  @override
  String get subscriptionRedeemSuccess => 'جواز تازه شو.';

  @override
  String subscriptionRedeemError(String error) {
    return 'فعالول ناکام: $error';
  }

  @override
  String subscriptionRefreshError(String error) {
    return 'تازه کول ناکام: $error';
  }

  @override
  String get subscriptionBillingPlansTitle => 'پلانونه او بیې (افغانۍ)';

  @override
  String get subscriptionBillingPrice1Year => '۱ کال';

  @override
  String get subscriptionBillingPrice2Year => '۲ کاله';

  @override
  String get subscriptionBillingPriceLifetime => 'تلپاتې';

  @override
  String get subscriptionBillingHesabPayTitle => 'د حساب پی له لارې تادیه';

  @override
  String get subscriptionBillingPaymentLinkTitle => 'سکین یا ټک وکړئ';

  @override
  String get subscriptionBillingPaymentLinkDefaultLabel =>
      'د حساب پی تادیې لینک خلاص کړئ';

  @override
  String get subscriptionBillingCopyPaymentLink => 'د تادیې لینک کاپي';

  @override
  String get subscriptionBillingPaymentLinkOpenFailed =>
      'په دې وسیله کې د تادیې لینک نه خلاصېد.';

  @override
  String get subscriptionBillingCashTitle => 'نغدي تادیه';

  @override
  String get subscriptionBillingContactTitle =>
      'وروسته له تادیې — له ملاتړ سره اړیکه';

  @override
  String get subscriptionBillingCopyAccount => 'د حساب شمېره کاپي';

  @override
  String get subscriptionBillingCopied => 'کاپي شو';

  @override
  String subscriptionBillingOfflineCache(String when) {
    return 'خوندي معلومات له $when. د تازه کولو لپاره انلاین شئ.';
  }

  @override
  String get subscriptionBillingNotPublished =>
      'د تادیې لارښوونې لا خپرې نه دي. له خپل توزیع‌کونکي وغواړئ په پراختیاګر پورټل → بلینګ کې خپورې کړي، یا لاندې فعالولو کوډ ولیکئ.';

  @override
  String subscriptionBillingLoadError(String error) {
    return 'د تادیې معلومات نه لوستل کېږي: $error';
  }

  @override
  String get subscriptionPaymentClaimTitle => 'ما تادیه کړې (حساب پی)';

  @override
  String get subscriptionPaymentClaimOwnerOnly =>
      'یوازې د هټۍ خاوند کولی شي غوښتنه ولیږي.';

  @override
  String get subscriptionPaymentClaimPlanTier => 'پلان';

  @override
  String get subscriptionPaymentClaimPlanOneYear => '۱ کال';

  @override
  String get subscriptionPaymentClaimPlanTwoYear => '۲ کاله';

  @override
  String get subscriptionPaymentClaimPlanLifetime => 'تلپاتې';

  @override
  String get subscriptionPaymentClaimTransactionId => 'د معاملې پېژند';

  @override
  String get subscriptionPaymentClaimTransactionHint => 'له حساب پی رسید';

  @override
  String get subscriptionPaymentClaimPayerPhone => 'ستاسو تلیفون (اختیاري)';

  @override
  String get subscriptionPaymentClaimNotes => 'یادښت (اختیاري)';

  @override
  String get subscriptionPaymentClaimSubmit => 'د تادیې غوښتنه ولیږئ';

  @override
  String get subscriptionPaymentClaimSubmitting => 'لیږل کېږي…';

  @override
  String get subscriptionPaymentClaimSubmitSuccess =>
      'غوښتنه ولیږل شوه. وروسته به فعالولو کوډ درکړل شي.';

  @override
  String subscriptionPaymentClaimSubmitError(String error) {
    return 'لیږل ناکام: $error';
  }

  @override
  String get subscriptionPaymentClaimHistoryTitle => 'ستاسو د تادیې غوښتنې';

  @override
  String get subscriptionPaymentClaimStatusPending => 'د کتنې په تمه';

  @override
  String get subscriptionPaymentClaimStatusApproved => 'منظور شو';

  @override
  String get subscriptionPaymentClaimStatusRejected => 'رد شو';

  @override
  String get subscriptionPaymentClaimCodeLabel => 'د فعالولو کوډ';

  @override
  String get subscriptionBillingWhatsapp => 'واټساپ';

  @override
  String get subscriptionBillingTelegram => 'ټیلیګرام';

  @override
  String get subscriptionBillingPhone => 'تلیفون';

  @override
  String get devPortalTabBilling => 'بلینګ';

  @override
  String get devPortalBillingIntro =>
      'د حساب پی جزئیات، بیې (افغانۍ) او د تادیې ګامونه په هر ژبه ولیکئ. «خپور شوی» فعال کړئ ترڅو ټولې هټۍ یې په تنظیمات → ګډون وګوري. لاندې د تادیې غوښتنې وڅارئ او د فعالولو کوډ جوړولو لپاره ومنئ.';

  @override
  String devPortalBillingLoadError(String error) {
    return 'د بلینګ پروفایل بارول ناکام: $error';
  }

  @override
  String get devPortalBillingProfileTitle => 'د حساب پی پروفایل';

  @override
  String get devPortalBillingPublished => 'خپور شوی (د هټیو لپاره)';

  @override
  String get devPortalBillingAccountName => 'د حساب نوم';

  @override
  String get devPortalBillingAccountNumber => 'د حساب شمېره';

  @override
  String get devPortalBillingMerchantId => 'مرچنت / مرجع پېژند';

  @override
  String get devPortalBillingPaymentLink => 'د حساب پی تادیې لینک (HTTPS)';

  @override
  String get devPortalBillingPaymentLinkHint =>
      'بشپړ لینک له حساب پی. هټۍ QR او دا پته ګوري.';

  @override
  String get devPortalBillingPaymentLinkLabelEn => 'د لینک د تڼۍ نوم (انګلیسي)';

  @override
  String get devPortalBillingPaymentLinkLabelFa => 'د لینک د تڼۍ نوم (دري)';

  @override
  String get devPortalBillingPaymentLinkLabelPs => 'د لینک د تڼۍ نوم (پښتو)';

  @override
  String get devPortalBillingPrice1Year => 'بیه ۱ کال (افغانۍ)';

  @override
  String get devPortalBillingPrice2Year => 'بیه ۲ کاله (افغانۍ)';

  @override
  String get devPortalBillingPriceLifetime => 'تلپاتې بیه (افغانۍ)';

  @override
  String get devPortalBillingPaymentStepsEn => 'د تادیې ګامونه (انګلیسي)';

  @override
  String get devPortalBillingPaymentStepsFa => 'د تادیې ګامونه (دري)';

  @override
  String get devPortalBillingPaymentStepsPs => 'د تادیې ګامونه (پښتو)';

  @override
  String get devPortalBillingActivationStepsEn => 'کوډ ترلاسه کول (انګلیسي)';

  @override
  String get devPortalBillingActivationStepsFa => 'کوډ ترلاسه کول (دري)';

  @override
  String get devPortalBillingActivationStepsPs => 'کوډ ترلاسه کول (پښتو)';

  @override
  String get devPortalBillingCashNoteEn => 'نغدي یادښت (انګلیسي)';

  @override
  String get devPortalBillingCashNoteFa => 'نغدي یادښت (دري)';

  @override
  String get devPortalBillingCashNotePs => 'نغدي یادښت (پښتو)';

  @override
  String get devPortalBillingWhatsapp => 'واټساپ (E.164)';

  @override
  String get devPortalBillingTelegram => 'ټیلیګرام';

  @override
  String get devPortalBillingPhone => 'مستقیم تلیفون (E.164)';

  @override
  String get devPortalBillingSave => 'پروفایل خوندي کړئ';

  @override
  String get devPortalBillingSaveSuccess => 'پروفایل خوندي شو.';

  @override
  String devPortalBillingSaveError(String error) {
    return 'خوندي کول ناکام: $error';
  }

  @override
  String get devPortalBillingClaimsTitle => 'د تادیې غوښتنې';

  @override
  String get devPortalBillingClaimsPending => 'په تمه';

  @override
  String get devPortalBillingClaimsAll => 'ټول';

  @override
  String get devPortalBillingClaimApprove => 'منظور او کوډ جوړول';

  @override
  String get devPortalBillingClaimReject => 'رد';

  @override
  String get devPortalBillingClaimRejectNotes => 'دلیل (اختیاري)';

  @override
  String get devPortalBillingClaimApproved => 'غوښتنه منظور شوه.';

  @override
  String get devPortalBillingClaimRejected => 'غوښتنه رد شوه.';

  @override
  String get devPortalBillingNoClaims => 'غوښتنه نشته.';

  @override
  String get customersListView => 'لیست لید';

  @override
  String get customersCardView => 'کارت لید';

  @override
  String get customerEditDialogTitle => 'پیرودونکی سمول';

  @override
  String get customerUpdated => 'پیرودونکی تازه شو.';

  @override
  String get customerAddressLabel => 'پته';

  @override
  String get customerAddressHint => 'اختیاري';

  @override
  String get customerNotesLabel => 'یادښتونه';

  @override
  String get customerNotesHint => 'اختیاري';

  @override
  String get customerFieldEmpty => '—';

  @override
  String get customerDeleteMenu => 'پیرودونکی ړنګول';

  @override
  String get customerDeleteConfirmTitle => 'دا پیرودونکی ړنګ شي؟';

  @override
  String get customerDeleteConfirmBody =>
      'له ستاسو لیست څخه لرې کېږي. موجود امرونه په امرونو ټب کې پاتې کېږي.';

  @override
  String get customerDeleted => 'پیرودونکی لرې شو';

  @override
  String get orderDeleteMenu => 'امر ړنګول';

  @override
  String get orderDeleteConfirmTitle => 'دا امر ړنګ شي؟';

  @override
  String get orderDeleteConfirmBody =>
      'امر به له دې وسیلې ستاسو لیست څخه لرې شي.';

  @override
  String get orderDeleted => 'امر لرې شو';

  @override
  String get customersFinancialSectionTitle => 'پاتې';

  @override
  String get customersFinancialFilterAll => 'هر پاتې';

  @override
  String get customersFilterHasUnpaid => 'نه ورکړل شوي امرونه لري';

  @override
  String get customersSortMostOrders => 'ډېر امرونه';

  @override
  String customersRowMeta(int orderCount, String unpaid) {
    return '$orderCount امرونه · $unpaid';
  }

  @override
  String get customersRowNoOrdersYet => 'تر اوسه امر نشته';

  @override
  String customersRowSince(String date) {
    return 'پیرودونکی له $date';
  }

  @override
  String get reportsThisMonthIncomeEmpty =>
      'په دې میاشت کې تر اوسه تادیه ثبت شوې نه ده.';

  @override
  String get reportsOpenUnpaidEmpty => 'خلاص امرونه د پاتې پور سره نشته.';

  @override
  String reportsOrdersByStatusCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count امرونه',
      one: '۱ امر',
    );
    return '$_temp0';
  }

  @override
  String get settingsUsersLimitsTitle => 'د کارنو حدونه';

  @override
  String get settingsUsersLimitsBody =>
      'ازمایښتې هټۍ: تر ۲ کارنو. ورکړل شوې هټۍ: تر ۵ کارنو. د مالک حساب نشي ړنګېدلی.';

  @override
  String settingsUsersLimitsBodyTrial(int max, int count) {
    return 'ازمایښت: تر $max کارنو. $count فعال. د مالک حساب نشي ړنګېدلی.';
  }

  @override
  String settingsUsersLimitsBodyPaid(int max, int count) {
    return 'د دې هټۍ لپاره تر $max کارنو. $count فعال. د مالک حساب نشي ړنګېدلی.';
  }

  @override
  String settingsUsersAtLimit(int count, int max) {
    return 'د کارونو حد ته ورسېدل ($count له $max).';
  }

  @override
  String settingsUsersLimitsLoadFailed(String error) {
    return 'د کارونو حدونه نه راغلل: $error. بیا هڅه وکړئ یا «کارن زیات کړئ» وازمویئ (سرور به حدونه تطبیق کړي).';
  }

  @override
  String get settingsUsersLicenseExpired =>
      'د هټۍ جواز پای ته رسېدلی. مخکې له کارونو زیاتولو څخه بیا فعال کړئ.';

  @override
  String get settingsUsersNotOwnerBanner =>
      'د ټیم غړي په توګه ننوتلي یاست. یوازې د هټۍ مالک حساب کارن زیاتولی یا لرې کولی شي.';

  @override
  String get settingsUsersNeedOnline =>
      'د کارونو اداره لپاره آنلاین اوسئ او له سرور سره ننوځئ.';

  @override
  String get settingsUsersOfflineCacheNote =>
      'آفلاین — وروستی خوندي لیست ښودل کیږي. د تازه کولو لپاره آنلاین اوسئ.';

  @override
  String get devPortalOfflineCacheNote =>
      'آفلاین — وروستي خوندي معلومات ښودل کیږي. د تازه کولو لپاره آنلاین اوسئ.';

  @override
  String get settingsUsersTileNeedApiSession =>
      'د کارونو اداره لپاره له سرور سره ننوځئ';

  @override
  String get settingsUsersAddCta => 'کارن زیاتول';

  @override
  String get settingsUsersAddDisabledHint =>
      'د کارن مدیریت به سرور سره ونښلوي.';

  @override
  String get settingsUsersListTitle => 'ټیم';

  @override
  String get settingsUsersOwnerRowTitle => 'د هټۍ مالک';

  @override
  String get settingsUsersOwnerRowSubtitle => 'بشپړ لاسرسی';

  @override
  String get settingsUsersEmptyRowTitle => 'اضافي کارنان';

  @override
  String get settingsUsersEmptyRowSubtitle => 'لا نور کارن نشته';

  @override
  String get settingsUsersSubtitleTeam =>
      'په سرور حسابونه وګورئ (یوازې لوستل مګر مالک نه یاست).';

  @override
  String settingsUsersLoadError(String error) {
    return 'کارنان نشول بارولای: $error';
  }

  @override
  String get settingsUsersRetryCta => 'بیا هڅه';

  @override
  String get settingsUsersDeleteConfirmTitle => 'کارن لرې شي؟';

  @override
  String get settingsUsersDeleteConfirmBody => 'نور نشي کولی ننوځي.';

  @override
  String get settingsUsersDeleteCta => 'لرې کول';

  @override
  String get settingsUsersAddDialogTitle => 'کارن زیاتول';

  @override
  String get settingsUsersAddUsernameLabel => 'کارن نوم';

  @override
  String get settingsUsersAddPasswordLabel => 'پاسورډ';

  @override
  String get settingsUsersAddSubmitCta => 'جوړول';

  @override
  String settingsUsersAddError(String error) {
    return 'کارن نشو زیاتېدلی: $error';
  }

  @override
  String get settingsUsersAddedSnackbar => 'کارن جوړ شو.';

  @override
  String get settingsUsersRemovedSnackbar => 'کارن لرې شو.';

  @override
  String get settingsBackupOwnerPasswordNote =>
      'بیکاپ او بیرته راوړل به د مالک د ننوتلو پاسورډ ته اړتیا ولري.';

  @override
  String get settingsBackupSectionTitle => 'بیکاپ';

  @override
  String get settingsBackupOptionDataOnly => 'یوازې ډیټا';

  @override
  String get settingsBackupOptionDataOnlySubtitle =>
      'امرونه، پیرودونکي، ورکړې، کتلاګ میټاډیټا — کوچنی فایل';

  @override
  String get settingsBackupOptionDataAndImages => 'ډیټا + د کتلاګ انځورونه';

  @override
  String get settingsBackupOptionDataAndImagesSubtitle =>
      'په دې وسیله کې زیرمه شوي ډیزاین انځورونه شامل دي';

  @override
  String get settingsBackupCreateCta => 'بیکاپ جوړول';

  @override
  String get settingsRestoreSectionTitle => 'بیرته راوړل';

  @override
  String get settingsRestoreMergeNote =>
      'بیرته راوړل تل ستاسو اوسني ډیټا سره یوځای کېږي (ټول ځای نه نیسي).';

  @override
  String get settingsRestorePickCta => 'د بیکاپ فایل غوره کړئ';

  @override
  String get settingsBackupRestoreComingSoon =>
      'د کتلاګ انځورونه لا تر اوسه په v1 بیکاپ کې شامل نه دي.';

  @override
  String get settingsBackupWebNotSupported =>
      'بیکاپ او بیرته راوړل اصلي اپ ته اړتیا لري (Isar). اندروید، iOS یا ډیسکټاپ وکاروئ — نه ویب.';

  @override
  String get settingsBackupExportDone => 'د بیکاپ فایل ساتل شو.';

  @override
  String get settingsBackupRestoreDone => 'بیرته راوړل بشپړ شو.';

  @override
  String get settingsBackupRestoreSummaryTitle => 'د بیرته راوړلو لنډیز';

  @override
  String settingsBackupSummaryLineCustomers(int inserted, int updated) {
    return 'پیرودونکي: $inserted نوی، $updated یوځای شوی';
  }

  @override
  String settingsBackupSummaryLineMeasurements(
    int types,
    int profiles,
    int lines,
  ) {
    return 'اندازې: $types د ساحې ډولونه، $profiles پروفایلونه، $lines ساتل شوې ارزښتونه';
  }

  @override
  String settingsBackupSummaryLineOrders(int count) {
    return 'امرونه: $count ولیکل شول';
  }

  @override
  String settingsBackupSummaryLinePayments(int inserted, int skipped) {
    return 'ورکړې: $inserted زیاتې، $skipped پرېښل شوې (دمخه وو)';
  }

  @override
  String settingsBackupSummaryLineSnapshots(int headers, int items) {
    return 'د اندازو عکسونه: $headers سرلیکونه، $items کرښې';
  }

  @override
  String settingsBackupSummaryLineNotifications(int inserted, int skipped) {
    return 'خبرتیاوې: $inserted زیاتې، $skipped پرېښل شوې';
  }

  @override
  String get settingsBackupInvalidFile => 'دا بیکاپ فایل نه شو لوستلی.';

  @override
  String get settingsNotificationsFiltersTitle => 'فلټرونه';

  @override
  String get settingsNotifFilterAll => 'ټول';

  @override
  String get settingsNotifFilterOrders => 'امرونه';

  @override
  String get settingsNotifFilterLicense => 'جواز';

  @override
  String get settingsNotifFilterBackup => 'بیکاپ';

  @override
  String get settingsNotificationsInboxEmpty => 'تر اوسه خبرتیا نشته';

  @override
  String get settingsNotificationsInboxEmptyHint =>
      'د امر، جواز او بیکاپ پیښو لپاره تاریخ به دلته ښکاري.';

  @override
  String get settingsNotificationsInboxFilterEmpty =>
      'په دې فلټر کې هېڅ خبرتیا نشته.';

  @override
  String get settingsSyncLastSyncTitle => 'وروستی بریالی سنک';

  @override
  String get settingsSyncLastSyncNever =>
      'لا سنک نشته (لومړی آفلاین؛ API پاتې)';

  @override
  String get settingsSyncQueuedTitle => 'محلي بدلونونه په قطار کې';

  @override
  String get settingsSyncQueuedZero => 'هېڅ په تمه نه دی';

  @override
  String settingsSyncQueuedCount(int count) {
    return '$count د سنک په تمه';
  }

  @override
  String get settingsSyncLocalSnapshotTitle => 'د محلي ډیټا عکس';

  @override
  String get settingsSyncLocalOrders => 'امرونه';

  @override
  String get settingsSyncLocalCustomers => 'پیرودونکي';

  @override
  String get settingsSyncLocalPayments => 'ورکړې';

  @override
  String get settingsSyncLocalTasks => 'دندې';

  @override
  String get settingsSyncLocalNotifications => 'خبرتیاوې';

  @override
  String get settingsSyncLocalUnread => 'نه لوستل شوې خبرتیاوې';

  @override
  String get settingsSyncRetryTitle => 'اوس سنک کړئ';

  @override
  String get settingsSyncRetrySubtitle =>
      'له سرور راښکته کړئ، بیا محلي قطار واستوئ کله چې API_BASE_URL ټاکل شوی او آنلاین ننوتلي یاست.';

  @override
  String get settingsSyncRetryOffline =>
      'آفلاین یاست. انټرنټ ونښلوئ او بیا هڅه وکړئ.';

  @override
  String get settingsSyncRetryConfigureApi =>
      'د بیلد په وخت کې API_BASE_URL ټاکئ، بیا تنظیمات → د API پیوستون پرانیزئ.';

  @override
  String get settingsSyncRetrySignIn => 'لومړی د آنلاین سرور حساب سره ننوځئ.';

  @override
  String get settingsSyncRetryLicenseExpired =>
      'سرور سنک رد کړ ځکه جواز پای ته رسېدلی. ګډون پرانیزئ.';

  @override
  String get settingsSyncRetryEditingBlocked =>
      'سنک په یوازې لوستل حالت کې ودرول شو. آنلاین کې ګډون پرانیزئ.';

  @override
  String settingsSyncRetrySuccess(int pushed, int pulled) {
    return 'سنک بریالی: $pushed بدلون واستول شول؛ $pulled له سرور راښکته شول.';
  }

  @override
  String settingsSyncRetryFailed(String detail) {
    return 'سنک ناکام: $detail';
  }

  @override
  String get settingsSyncOutboxTitle => 'بهرنی صندوق';

  @override
  String get settingsSyncOutboxPlaceholderTitle => 'په قطار کې بدلونونه';

  @override
  String get settingsSyncOutboxPlaceholderSubtitle =>
      'بیا هڅه او جزئیات به د سنک فعالولو سره ښکاري';

  @override
  String get settingsSyncOutboxPendingListTitle => 'په تمه بدلونونه (محلي)';

  @override
  String get settingsSyncOutboxPendingEmpty =>
      'د سنک لپاره په قطار کې هېڅ نشته.';

  @override
  String get settingsDiagnosticsExportCta => 'د تشخیص بسته صادرول';

  @override
  String get settingsDiagnosticsExportBusy => 'بسته چمتو کېږي…';

  @override
  String get settingsDiagnosticsExportSuccess =>
      'تشخیص بسته د شریکولو لپاره چمته ده.';

  @override
  String settingsDiagnosticsExportError(String error) {
    return 'تشخیص صادرول ناکام شو: $error';
  }

  @override
  String get settingsSyncDiagnosticsFooter =>
      'ملاتړ ممکن د سنک ستونزو لپاره دا بسته وغواړي.';

  @override
  String get devPortalTitle => 'د پراختیاګر پورټل';

  @override
  String get devPortalTabOverview => 'کتنه';

  @override
  String get devPortalTabCodes => 'کوډونه';

  @override
  String get devPortalTabShops => 'هټۍ';

  @override
  String get devPortalTabResets => 'بیا تنظیمونه';

  @override
  String get devPortalTabDiagnostics => 'تشخیص';

  @override
  String get devPortalTabAccount => 'زما پاسورډ';

  @override
  String get devPortalMyPasswordTitle => 'پاسورډ بدل کړئ';

  @override
  String get devPortalMyPasswordSubtitle =>
      'کارن نوم دلته نشي بدلېدلی. اوسنی پاسورډ ولیکئ، بیا نوی (لږترلږه ۶ توري).';

  @override
  String get devPortalCurrentPasswordLabel => 'اوسنی پاسورډ';

  @override
  String get devPortalNewPasswordLabel => 'نوی پاسورډ';

  @override
  String get devPortalConfirmPasswordLabel => 'نوی پاسورډ تایید';

  @override
  String get devPortalPasswordMismatch =>
      'نوی پاسورډ او تایید سره نه سمون خوري.';

  @override
  String get devPortalChangePasswordCta => 'پاسورډ تازه کړئ';

  @override
  String get devPortalChangePasswordOk =>
      'پاسورډ تازه شو. بل ځل له نوي پاسورډ سره ننوځئ.';

  @override
  String get devPortalChangePasswordFail => 'پاسورډ نشو تازه کېدلی.';

  @override
  String get devPortalOnlineRequired =>
      'د پراختیاګر وسیلې آنلاین پیوستون او تایید شوی حساب ته اړتیا لري.';

  @override
  String get devPortalRetryCta => 'بیا هڅه';

  @override
  String get devPortalStubAction => 'په دې نسخه کې API نښلول شوی نه دی.';

  @override
  String get devPortalAdviceOfflineTitle => 'آفلاین یاست';

  @override
  String get devPortalAdviceOfflineBody =>
      'د عامه API روغتیا ازموینې لپاره انټرنټ ونښلوئ. اداري لیستونه د استقرار شویو API څخه اړتیا لري.';

  @override
  String get devPortalAdviceOnlineTitle => 'د پراختیاګر وسیلې';

  @override
  String get devPortalAdviceOnlineBody =>
      'بلینګ کې د حساب پی لارښوونې ټولو هټیو لپاره خپورې کړئ. کتنه د API روغتیا او احصائیه ښیي. کوډونه، هټۍ او بیا تنظیمونه په API کې د پراختیاګر حساب ته اړتیا لري.';

  @override
  String get devPortalShopsEmpty => 'لا په سرور هټۍ نشته.';

  @override
  String devPortalShopRowUsers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کارنان',
      one: '۱ کارن',
    );
    return '$_temp0';
  }

  @override
  String devPortalShopSignedUp(String date) {
    return 'نوم لیکنه: $date';
  }

  @override
  String devPortalShopTrialStarted(String date) {
    return 'ازموینه پیل: $date';
  }

  @override
  String get devPortalShopUsersHeader => 'حسابونه';

  @override
  String get devPortalShopUserOwnerBadge => 'خاوند';

  @override
  String get devPortalShopUserDeletedBadge => 'ړنګ شوی';

  @override
  String get devPortalShopUserPasswordNote =>
      'پټنوم په سرور کې هش شوی دی. د نوي پټنوم لپاره د پټنوم بیاځای کولو برخه وکاروئ.';

  @override
  String get devPortalShopDisabledLabel => 'غیرفعال';

  @override
  String get devPortalShopActionsTooltip => 'د هټۍ کړنې';

  @override
  String get devPortalShopDisableCta => 'هټۍ غیرفعاله کړئ';

  @override
  String get devPortalShopEnableCta => 'هټۍ فعاله کړئ';

  @override
  String get devPortalShopExtendCta => 'جواز غځول…';

  @override
  String get devPortalShopExtendTitle => 'جواز غځول';

  @override
  String get devPortalShopExtendHint =>
      'د نن یا اوسني پای نیټې څخه ورځې زیاتول (هرکوم وروستی).';

  @override
  String get devPortalShopExtendDaysLabel => 'ورځې';

  @override
  String get devPortalShopSetMaxUsersCta => 'د کارونو حد ټاکل…';

  @override
  String get devPortalShopSetMaxUsersTitle => 'د کارونو حد (ورکړل شوې هټۍ)';

  @override
  String get devPortalShopSetMaxUsersHint =>
      'د مالک په ګډون فعال کارونکي (۱–۲۰). له اوسني کارونو څخه کم نشي.';

  @override
  String get devPortalShopMaxUsersLabel => 'اعظمي کارونکي';

  @override
  String devPortalShopRowMaxUsers(int max, int count) {
    return 'حد: $max کارونکي ($count فعال)';
  }

  @override
  String get devPortalShopTrialUserLimitNote => 'ازمایښت: ۲ کارونکي (ثابت)';

  @override
  String get devPortalShopActionOk => 'ترسره شو.';

  @override
  String get devPortalShopPushTestCta => 'فشاري خبرتیا ازموینه…';

  @override
  String get devPortalShopPushTitle => 'د فشاري خبرتیا ازموینه';

  @override
  String get devPortalShopPushNotifTitleLabel => 'د خبرتیا سرلیک';

  @override
  String get devPortalShopPushBodyLabel => 'پیغام';

  @override
  String devPortalShopPushResult(int success, int failed, String reason) {
    return 'لیږل شوي: $success، ناکام: $failed. دلیل: $reason.';
  }

  @override
  String devPortalCodesLoadError(String error) {
    return 'کوډونه نشول بارولای: $error';
  }

  @override
  String get devPortalCodesEmpty =>
      'لا فعالولو کوډ نشته. د پیسو وخت صادرولو لپاره یو جوړ کړئ.';

  @override
  String get devPortalCodesCreateTitle => 'نوی فعالولو کوډ';

  @override
  String get devPortalCodesPlanDaysLabel => 'د فعالولو وروسته ورکړل شوې ورځې';

  @override
  String get devPortalCodesMaxUsesLabel => 'اعظمي کارونه';

  @override
  String get devPortalCodesCreateCta => 'کوډ جوړول';

  @override
  String devPortalCodesCreated(String code) {
    return 'جوړ شو: $code';
  }

  @override
  String get devPortalCodesCreateFail => 'کوډ نشو جوړېدلی.';

  @override
  String get devPortalCodesRevokeTitle => 'کوډ لغوه کړئ';

  @override
  String devPortalCodesRevokeBody(String code) {
    return 'هټۍ نور «$code» نشي فعالولی.';
  }

  @override
  String get devPortalCodesRevoked => 'کوډ لغوه شو.';

  @override
  String get devPortalCodesRevokeFail => 'لغوه کول ناکام شو.';

  @override
  String get devPortalCodesRevokeCta => 'لغوه';

  @override
  String get devPortalCodesDetailTitle => 'د فعالولو کوډ';

  @override
  String get devPortalCodesCopyCta => 'کوډ کاپي';

  @override
  String get devPortalCodesShareCta => 'کوډ شریکول';

  @override
  String get devPortalCodesCopied => 'کوډ په کلیپ‌بورډ کې کاپي شو.';

  @override
  String get devPortalCodesShareSubject => 'د افغان پرایډ فعالولو کوډ';

  @override
  String devPortalCodesShareMessage(String code, int days) {
    return 'افغان پرایډ — د ګډون فعالول\n\nکوډ: $code\nورځې پیسې وروسته له فعالولو: $days\n\nپه اپ کې: تنظیمات → ګډون → دا کوډ ولیکئ.';
  }

  @override
  String get devPortalApiHealthPrompt =>
      'د تازه کولو لپاره ښکته کش کړئ او GET /health ووهئ.';

  @override
  String get devPortalEnvBadge => 'چاپیریال: پراختیا';

  @override
  String get devPortalStatShops => 'ټولې هټۍ';

  @override
  String get devPortalStatActiveExpired => 'فعال / پای ته رسېدلی';

  @override
  String get devPortalStatTrials => 'روان ازمایښتونه';

  @override
  String get devPortalStatActivations => 'د کوډ جوړول (ممیزي)';

  @override
  String get devPortalApiHealthTitle => 'د API روغتیا';

  @override
  String get devPortalApiHealthUnknown => 'نامعلوم — API ته ونښلوئ';

  @override
  String get devPortalCodesStub =>
      'فعالولو کوډونه: لټون، جوړول او لغوه کول له اداري API بارېږي.';

  @override
  String get devPortalShopsStub =>
      'هټۍ او جوازونه: لیست او جزئیات له اداري API بارېږي.';

  @override
  String get devPortalResetsStub =>
      'د پاسورډ بیا تنظیم غوښتنې: د ملاتړ قطار له اداري API بارېږي.';

  @override
  String get devPortalDiagStub =>
      'د بشپړې وسیلې بسته لپاره تنظیمات → سنک او تشخیص → تشخیص بسته صادرول وکاروئ.';

  @override
  String get devPortalDiagLocalTitle => 'دا وسیله (آفلاین حافظه)';

  @override
  String get devPortalDiagLocalSubtitle =>
      'له محلي ذخیرې شمېر — کله اداري API آفلاین وي ګټور دی.';

  @override
  String get devPortalDiagCountLoading => '…';

  @override
  String get devPortalAdminAuditTitle => 'د اداري ممیزي یادښت';

  @override
  String get devPortalAdminAuditNeedSignIn =>
      'له API سره ننوځئ، بیا د تازه کولو لپاره کش کړئ.';

  @override
  String devPortalAdminAuditLine(int count, int schema) {
    return 'GET /admin/audit-log — $count کرښې، طرحواره v$schema';
  }

  @override
  String get settingsShopProfileTitle => 'د هټۍ پروفایل';

  @override
  String get shopProfileIntro =>
      'نوم، لوګو، پته او مننه پیغام په چاپ شوي رسید او شریک شوي فاکتور کې ښکاري. لاندې یادښتونه یوازې ستاسو لپاره دي.';

  @override
  String get shopProfileNameLabel => 'د هټۍ نوم';

  @override
  String get shopProfileNameHint => 'بېلګه: د کرزی خیاطي';

  @override
  String get shopProfileNameRequired => 'د هټۍ نوم اړین دی.';

  @override
  String get shopProfileNameTooShort => 'د هټۍ نوم ډېر لنډ دی.';

  @override
  String get shopProfileShopPhoneLabel => 'د هټۍ تلیفون (اختیاري)';

  @override
  String get shopProfileShopPhoneHint => 'بېلګه: 0701234567';

  @override
  String get shopProfileAddressLabel => 'پته (اختیاري)';

  @override
  String get shopProfileAddressHint => 'بېلګه: کارته چار، کابل';

  @override
  String get shopProfileReceiptThanksLabel => 'د رسید مننه پیغام (اختیاري)';

  @override
  String get shopProfileReceiptThanksHint => 'بېلګه: ستاسو له سوداګرۍ مننه!';

  @override
  String get shopProfileNotesLabel => 'یادښتونه (اختیاري)';

  @override
  String get shopProfileNotesHint => 'ساعتونه، نښې، مالیاتي پېژند…';

  @override
  String get shopProfileSaved => 'د هټۍ پروفایل وسو.';

  @override
  String get shopProfileReadOnlyBanner =>
      'جواز پای ته رسېدلی — کتلای شئ خو سمون نشئ کولی.';

  @override
  String get settingsCurrentUserGuest => 'میلمه';

  @override
  String settingsShopIdChip(String shopId) {
    return 'هټۍ $shopId';
  }

  @override
  String get customersFilterTooltip => 'ترتیب او فلټر';

  @override
  String get customersFilterSheetTitle => 'ترتیب او فلټر';

  @override
  String get customersSortSectionTitle => 'ترتیب';

  @override
  String get customersSortNameAsc => 'الف-ی';

  @override
  String get customersSortNameDesc => 'ی-الف';

  @override
  String get customersSortRecentActivity => 'وروستۍ فعالیت';

  @override
  String get customersCreatedSectionTitle => 'زیات شوی';

  @override
  String get customersCreatedFilterAll => 'هر وخت';

  @override
  String get customersCreatedFilterToday => 'نن';

  @override
  String get customersCreatedFilterThisWeek => 'دا اونۍ';

  @override
  String get customersActivitySectionTitle => 'فعالیت';

  @override
  String get customersFilterAll => 'ټول پیرودونکي';

  @override
  String get customersFilterHasOrders => 'امرونه لري';

  @override
  String get customersFilterNoOrders => 'تر اوسه امر نشته';

  @override
  String get customersApplyFilters => 'پلي کړئ';

  @override
  String get customersResetFilters => 'بیا تنظیم';

  @override
  String get settingsSectionPrinter => 'چاپګر';

  @override
  String get settingsPrinterTileTitle => 'حرارتي چاپګر';

  @override
  String get settingsPrinterTileSubtitle =>
      'د شبکې رسید چاپګر (۵۸ / ۸۰ ملی‌متر)';

  @override
  String get settingsPrinterScreenTitle => 'حرارتي چاپګر';

  @override
  String get settingsPrinterIntro =>
      'رسید شبکې ESC/POS چاپګر ته واستوئ (معمولاً خام TCP په ۹۱۰۰ پورت). د وای‌فای یا LAN IP یا میزبان نوم ولیکئ.';

  @override
  String get settingsPrinterAsciiNotice =>
      'رسید ساده د چاپګر توري کاروي. له لاتیني بهر نومونه یا یادښتونه ممکن «؟» چاپ شي.';

  @override
  String get settingsPrinterHostLabel => 'د چاپګر پته';

  @override
  String get settingsPrinterHostHint => 'بېلګه: 192.168.1.50';

  @override
  String get settingsPrinterPortLabel => 'پورت';

  @override
  String get settingsPrinterPaperWidthLabel => 'د کاغذ عرض';

  @override
  String get settingsPrinterPaper58Label => '۵۸ ملی‌متر';

  @override
  String get settingsPrinterPaper80Label => '۸۰ ملی‌متر';

  @override
  String get settingsPrinterSaved => 'د چاپګر تنظیمات خوندي شول.';

  @override
  String get settingsPrinterTestCta => 'ازموینه چاپ';

  @override
  String get settingsPrinterTestHeadline => 'افغان پراید';

  @override
  String get settingsPrinterTestDetail =>
      'ازموینه چاپ — که دا لوستلی شئ، پیوستون کار کوي.';

  @override
  String get settingsPrinterTestOk => 'ازموینه پاڼه چاپګر ته واستول شوه.';

  @override
  String settingsPrinterTestFail(String detail) {
    return 'ازموینه چاپ ناکام: $detail';
  }

  @override
  String get settingsPrinterWebUnavailable =>
      'حرارتي چاپ په اندروید او iOS اپ کې شتون لري. د چاپ لپاره د اپ لرونکې وسیله وکاروئ؛ ویب اپ سخت‌افزاري چاپګر ته نه لیږي.';

  @override
  String get settingsPrinterHostEmptyError =>
      'د خوندي کولو یا ازموینې لپاره د چاپګر پته ولیکئ.';

  @override
  String get settingsPrinterPortInvalidError => 'معتبر پورت ولیکئ (۱–۶۵۵۳۵).';

  @override
  String get orderPrintReceiptTooltip => 'رسید چاپ';

  @override
  String get orderPrintReceiptNeedPrinter =>
      'د چاپګر پته په تنظیمات → حرارتي چاپګر کې ټاکئ.';

  @override
  String get orderPrintReceiptOk => 'رسید چاپګر ته واستول شو.';

  @override
  String orderPrintReceiptFail(String detail) {
    return 'چاپ ناکام: $detail';
  }

  @override
  String get receiptCustomerLabel => 'پیرودونکی';

  @override
  String get receiptPhoneLabel => 'تلیفون';

  @override
  String get receiptDeliveryLabel => 'تحویلي';

  @override
  String get receiptStatusLabel => 'حالت';

  @override
  String get receiptMeasurementsLabel => 'پیمان';

  @override
  String get invoicePridePromoLine =>
      'دا فاکتور د افغان پراید له لارې جوړ او لیږل شوی دی';

  @override
  String get receiptStyleLabel => 'د سټایل یادښتونه';

  @override
  String get receiptFabricLabel => 'د پیرودونکي کپړه';

  @override
  String get receiptFabricNameLabel => 'کپړه';

  @override
  String get receiptFabricColorLabel => 'رنګ';

  @override
  String get receiptFabricIdLabel => 'د کپړې پېژند';

  @override
  String get orderDetailFabricTitle => 'د پیرودونکي کپړه';

  @override
  String get receiptInternalNotesHeader => 'داخلي یادښتونه';

  @override
  String get receiptTotalLabel => 'ټول';

  @override
  String get receiptPaidLabel => 'ورکړل شوی';

  @override
  String get receiptBalanceLabel => 'پاتې';

  @override
  String get receiptPaymentsHeader => 'ورکړه';

  @override
  String get receiptShopPhoneLabel => 'د هټۍ تلیفون';

  @override
  String get receiptShopAddressLabel => 'پته';

  @override
  String get receiptShareDivider => '--------------------------------';

  @override
  String get receiptShareSectionRule => '================================';

  @override
  String get settingsPrinterRetryHint =>
      'که چاپګر بوخت وي، اپ په اوتومات ډول څو ځله بیا پیوستون هڅه کوي.';

  @override
  String get shopProfileLogoSectionTitle => 'د فاکتور سرلیک لوګو';

  @override
  String get shopProfileLogoSubtitle =>
      'په حرارتي رسیدونو او شریک شوي فاکتور متن سر کې (اندروید / iOS). مربع انځور غوره دی.';

  @override
  String get shopProfileLogoPickCta => 'انځور وټاکئ';

  @override
  String get shopProfileLogoRemoveCta => 'لوګو لرې کړئ';

  @override
  String get shopProfileLogoSaved => 'لوګو خوندي شو.';

  @override
  String get shopProfileLogoWebHint => 'لوګو په اندروید او iOS اپ کې شتون لري.';

  @override
  String get shopProfileLogoStatusOnFile =>
      'لوګو د رسیدونو لپاره په دې وسیله خوندي دی.';

  @override
  String get shopProfileLogoDefaultCaption =>
      'تر خپل لوګو پورته کولو پورې، ډیفالټ لوګو په رسید چاپېږي.';

  @override
  String get defaultShopName => 'زما خیاطي';

  @override
  String get defaultShopAddress => 'کابل، افغانستان';

  @override
  String get defaultShopPhone => '0701234567';

  @override
  String get orderShareInvoiceTooltip => 'فاکتور شریکول';

  @override
  String get orderShareInvoicePdfCta => 'د PDF فاکتور شریکول';

  @override
  String get orderShareContactPermissionDenied =>
      'د اړیکو اجازه بنده ده — فاکتور شریک شو، خو پیرودونکی په تلیفون کې نه دی خوندي شوی.';

  @override
  String get orderShareInvoiceSharedSheet =>
      'د PDF فاکتور لیږلو لپاره واتساپ یا بل اپ غوره کړئ.';

  @override
  String orderShareInvoiceFail(String detail) {
    return 'شریکول ناکام: $detail';
  }

  @override
  String orderShareInvoiceSubject(String orderNo) {
    return 'امر $orderNo';
  }

  @override
  String orderShareInvoiceWhatsappCaption(String orderNo, String customerName) {
    return 'د $orderNo امر فاکتور — $customerName';
  }

  @override
  String orderShareContactSaved(String name) {
    return '$name ستاسو په اړیکو کې خوندي شو.';
  }

  @override
  String get orderShareWhatsappOpened => 'د فاکتور PDF واتساپ کې پرانیستل شو.';

  @override
  String get orderShareWhatsappPhoneInvalid =>
      'د واتساپ له لارې د فاکتور لیږلو لپاره د پیرودونکي سمه شمېره ولیکئ.';

  @override
  String get receiptFooterThanks => 'ستاسو له سوداګرۍ مننه!';

  @override
  String get settingsDeveloperPortalCheckFailed =>
      'د پراختیاګر لاسرسی تایید نشو. بیا هڅه وکړئ.';

  @override
  String get settingsDeveloperPortalRetry => 'بیا هڅه';

  @override
  String get dashboardSyncRunning => 'همغږي کېږي…';

  @override
  String get dashboardSyncTapToRun => 'همغږي لپاره ټک وکړئ';

  @override
  String get dashboardTasksSectionTitle => 'دندې';

  @override
  String dashboardTasksOpenCount(int count) {
    return '$count خلاص';
  }

  @override
  String get dashboardTasksViewAll => 'ټولې دندې';

  @override
  String get shopFinanceTitle => 'د هټۍ مالي چارې';

  @override
  String get shopFinanceSubtitle => 'کرایه، ورځنۍ لګښتونه او خوراک';

  @override
  String get shopFinanceOverviewTitle => 'لنډیز';

  @override
  String get shopFinanceRentTitle => 'کرایه';

  @override
  String get shopFinanceExpensesTitle => 'لګښتونه';

  @override
  String get shopFinanceMonthOutflow => 'د دې میاشتې لګښت';

  @override
  String get shopFinanceRentDue => 'کرایه ورکړل';

  @override
  String get shopFinanceRentPaid => 'په دې میاشت کې ورکړل شوی کرایه';

  @override
  String get shopFinanceExpenseDaily => 'ورځنۍ لګښتونه';

  @override
  String get shopFinanceExpenseFood => 'خوراک او څښاک';

  @override
  String get shopFinanceExpenseOther => 'نور';

  @override
  String get shopFinanceAddRent => 'کرایه ټاکل';

  @override
  String get shopFinanceRecordRentPayment => 'د کرایې تادیه ثبت';

  @override
  String get shopFinanceAddExpense => 'لګښت زیاتول';

  @override
  String get shopFinanceAmountLabel => 'مبلغ (افغانۍ)';

  @override
  String get shopFinanceDueDateLabel => 'د سررسید نیټه';

  @override
  String get shopFinancePeriodMonthsLabel => 'موده (میاشتې)';

  @override
  String get shopFinanceNoteLabel => 'یادښت';

  @override
  String get shopFinanceCategoryLabel => 'کټګوري';

  @override
  String get shopFinanceDateLabel => 'نیټه';

  @override
  String get shopFinanceClearPeriodTitle => 'زاړه لګښتونه پاک شي؟';

  @override
  String get shopFinanceClearPeriodBody =>
      'مخکې له ټاکلې نیټې لګښتونه به له لیست څخه لرې شي.';

  @override
  String get shopFinanceRentDueNotificationTitle => 'کرایه نژدې ده';

  @override
  String shopFinanceRentDueNotificationBody(String amount, String date) {
    return 'د $amount کرایه په $date سررسید ده';
  }

  @override
  String get shopFinanceEmptyRent => 'تر اوسه کرایه نشته. میاشتنی کرایه ټاکئ.';

  @override
  String get shopFinanceEmptyExpenses => 'تر اوسه لګښت نشته.';

  @override
  String get shopFinanceSave => 'خوندي کول';

  @override
  String get shopFinanceChartsExpensesByCategory => 'لګښتونه په کټګورۍ';

  @override
  String get appGuideCloseTooltip => 'لارښود بندول';

  @override
  String get appGuideSkipAll => 'ټول لارښودونه پریږدئ';

  @override
  String get appGuideGotIt => 'پوه شوم';

  @override
  String get appGuideOrdersTitle => 'سفارشونه';

  @override
  String get appGuideOrdersBody =>
      'د خیاطۍ سفارشونه جوړ او تعقیب کړئ. د حالت، تادیې او د تحویلې نیټې لپاره سفارش پرانیزئ.';

  @override
  String get appGuideCustomersTitle => 'پیرودونکي';

  @override
  String get appGuideCustomersBody =>
      'نوم، تلیفون او اندازه‌ګیري خوندي کړئ تر څو نوی سفارش ګړندی شي.';

  @override
  String get appGuideCatalogTitle => 'کټلاګ';

  @override
  String get appGuideCatalogBody =>
      'د ډیزاین عکسونه له پیرودونکو سره د خپلې هټۍ کټلاګ له لارې شریک کړئ.';

  @override
  String get appGuideReportsTitle => 'راپورونه';

  @override
  String get appGuideReportsBody =>
      'عاید، ناپرده سفارشونه او د تحویلې راپور وګورئ.';

  @override
  String get appGuideSettingsTitle => 'تنظیمات';

  @override
  String get appGuideSettingsBody =>
      'د هټۍ پروفایل، چاپګر، سټایل کتابتون او ګډون دلته تنظیم کړئ.';

  @override
  String get appGuideDashboardTitle => 'ډشبورډ';

  @override
  String get appGuideDashboardBody =>
      'له کیڼ اړخ څخه کش کړئ (یا د مینو آیکن) د لټون، همغږي او لنډو لارو لپاره.';
}
