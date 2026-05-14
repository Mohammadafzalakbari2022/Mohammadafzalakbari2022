// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Pushto Pashto (`ps`).
class AppLocalizationsPs extends AppLocalizations {
  AppLocalizationsPs([String locale = 'ps']) : super(locale);

  @override
  String get appTitle => 'Pride';

  @override
  String get tabOrders => 'امرونه';

  @override
  String get tabCustomers => 'پیرودونکي';

  @override
  String get tabCatalog => 'کتلاګ';

  @override
  String get tabReports => 'راپورونه';

  @override
  String get tabSettings => 'تنظیمات';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Use your shop username and password. The server will verify this when the API is connected (plan-04).';

  @override
  String get loginMockHint =>
      'In this build, any non-empty username and password will sign you in locally.';

  @override
  String get loginShopIdLabel => 'Shop ID (optional)';

  @override
  String get loginShopIdHint => 'Leave blank for single-shop dev';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginUsernameHint => 'Your shop login name';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSignInCta => 'Sign in';

  @override
  String get loginFieldRequired => 'Required';

  @override
  String get loginDevContinue => 'Continue without account (dev)';

  @override
  String get loginApiHint =>
      'API_BASE_URL is set. The server verifies shop ID, username, and password (POST /auth/login).';

  @override
  String get loginSigningIn => 'Signing in…';

  @override
  String get loginApiUnauthorized => 'Invalid shop, username, or password.';

  @override
  String loginApiError(String error) {
    return 'Could not sign in: $error';
  }

  @override
  String get loginShopCreateSectionTitle => 'New shop (API)';

  @override
  String get loginShopCreateSubtitle =>
      'Create a shop on the server and sign in as owner (plan-04).';

  @override
  String get loginShopCreateNameLabel => 'Shop name';

  @override
  String get loginShopCreateOwnerUsernameLabel => 'Owner username';

  @override
  String get loginShopCreateOwnerPasswordLabel => 'Owner password';

  @override
  String get loginShopCreateCta => 'Create shop & sign in';

  @override
  String get loginShopCreating => 'Creating shop…';

  @override
  String loginShopCreateError(String error) {
    return 'Could not create shop: $error';
  }

  @override
  String modulePlaceholder(String moduleName) {
    return '$moduleName — UI coming soon.';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardSubtitle =>
      'KPIs and shortcuts will load from local data (plan-09).';

  @override
  String get dashboardKpisPlaceholder => 'Today at a glance';

  @override
  String get dashboardKpiNewOrders => 'New orders';

  @override
  String get dashboardKpiInProgress => 'In progress';

  @override
  String get dashboardKpiReady => 'Ready';

  @override
  String get dashboardKpiUnpaid => 'Unpaid balance';

  @override
  String get dashboardKpiValuePlaceholder => '—';

  @override
  String get dashboardOpenMenuTooltip => 'Open menu';

  @override
  String get subscriptionTitle => 'ګډون';

  @override
  String get subscriptionBody =>
      'د نوي کولو یا د فعالولو کوړ د بلینګ نښلولو وخت کې (plan-06). د پای په دوره کې سمون محدود دی؛ لیست او جزئیات لیدل شته.';

  @override
  String get subscriptionListTileSubtitle => 'جواز، ازمایښت او فعالول';

  @override
  String get licenseDevControlsTitle => 'License (dev only)';

  @override
  String get licenseStatusTrial => 'Trial';

  @override
  String get licenseStatusPaid => 'Paid';

  @override
  String get licenseStatusExpired => 'Expired';

  @override
  String get ordersNewTitle => 'New order';

  @override
  String get ordersNewCta => 'New order';

  @override
  String get ordersComposerPlaceholderBody =>
      'Order composer will go here (plan-11).';

  @override
  String get ordersDetailTitle => 'Order details';

  @override
  String ordersDetailPlaceholderBody(String orderId) {
    return 'Order $orderId — details UI coming soon (plan-12).';
  }

  @override
  String get orderStatusNew => 'New';

  @override
  String get orderStatusInProgress => 'In progress';

  @override
  String get orderStatusReady => 'Ready';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get ordersListEmpty => 'No orders yet';

  @override
  String ordersDeliveryOn(String date) {
    return 'Delivery: $date';
  }

  @override
  String get ordersWebDataHint =>
      'Web preview uses in-memory sample data (Isar runs on Android/iOS/desktop).';

  @override
  String ordersNumberPrefix(String number) {
    return 'No. $number';
  }

  @override
  String get ordersSearchHint => 'Search order number, customer, or phone';

  @override
  String get ordersDateChipAny => 'All dates';

  @override
  String get ordersDateChipToday => 'Delivery today';

  @override
  String get ordersDateChipThisWeek => 'Delivery this week';

  @override
  String get ordersDateChipCustom => 'Custom range';

  @override
  String get ordersDateCustomPickerHelp =>
      'Filter by delivery date (inclusive).';

  @override
  String ordersCustomerFilterChip(String name) {
    return 'Customer: $name';
  }

  @override
  String get ordersCustomerFilterUnknown => 'Customer filter on';

  @override
  String get ordersClearFilterA11y => 'Clear filter';

  @override
  String get ordersOnlyUnpaidChip => 'Only unpaid';

  @override
  String get ordersFilterOverdueChip => 'Overdue';

  @override
  String get ordersFilterDeliveredTodayChip => 'Delivered today';

  @override
  String ordersRemainingChip(String amount) {
    return 'Remaining: $amount';
  }

  @override
  String get ordersFilteredEmpty => 'No orders match your search or filters.';

  @override
  String get ordersDetailNotFound => 'This order could not be found.';

  @override
  String get ordersDetailChangeStatus => 'Change status';

  @override
  String get ordersDetailChangeStatusSubtitle => 'Ready / Delivered / Cancel';

  @override
  String get ordersDetailConfirmTitle => 'Confirm';

  @override
  String ordersDetailConfirmBody(String status) {
    return 'Change status to $status?';
  }

  @override
  String get ordersDetailConfirmCta => 'Confirm';

  @override
  String ordersDetailStatusUpdated(String status) {
    return 'Status updated: $status';
  }

  @override
  String get ordersDetailSectionCustomer => 'Customer';

  @override
  String get ordersDetailSectionMeasurements => 'Measurements';

  @override
  String get ordersDetailSectionStyle => 'Style';

  @override
  String get ordersDetailSectionInternalNotes => 'Internal notes';

  @override
  String get ordersDetailSectionPayments => 'Payments';

  @override
  String get ordersDetailSectionAudit => 'Audit';

  @override
  String get ordersDetailSectionPlaceholder =>
      'Details will appear here as the module is built.';

  @override
  String get ordersDetailAuditIntro =>
      'Local record metadata on this device. Full status-change history is not logged yet; use Payments for dated ledger entries.';

  @override
  String get ordersAuditInternalId => 'Internal ID';

  @override
  String get ordersAuditCopyIdTooltip => 'Copy ID';

  @override
  String get ordersAuditCopiedId => 'Copied order ID';

  @override
  String get ordersAuditCreatedAt => 'Created';

  @override
  String get ordersAuditUpdatedAt => 'Last updated';

  @override
  String get ordersAuditStatus => 'Status';

  @override
  String get ordersAuditDelivery => 'Delivery date';

  @override
  String get ordersAuditPaymentsTitle => 'Payment ledger';

  @override
  String get ordersAuditPaymentsEmpty => 'No payment rows for this order yet.';

  @override
  String ordersAuditPaymentsLine(int count, String first, String last) {
    return '$count payment rows · earliest $first · latest $last';
  }

  @override
  String get ordersDetailSnapshotEmpty => 'Nothing recorded.';

  @override
  String ordersDetailMeasurementsFromProfile(String label) {
    return 'Snapshot based on profile “$label”.';
  }

  @override
  String get ordersDetailMeasurementsNotes => 'Notes on order';

  @override
  String get ordersDetailLockedHint =>
      'This order is locked because it is Delivered or Cancelled (plan-12).';

  @override
  String get ordersDetailLockedStillInternalNotes =>
      'You can still edit internal notes below.';

  @override
  String get ordersInternalNotesDialogTitle => 'Internal notes';

  @override
  String get ordersInternalNotesHint =>
      'Staff-only — not shown to the customer.';

  @override
  String get ordersInternalNotesSaved => 'Internal notes saved.';

  @override
  String get licenseReadOnlyHint =>
      'Read-only mode: editing is disabled while the license is expired.';

  @override
  String get ownerPasswordTitle => 'Owner password';

  @override
  String get ownerPasswordLabel => 'Enter owner password';

  @override
  String get ownerPasswordMismatch =>
      'That password does not match the owner password for this device.';

  @override
  String get ordersDetailChangeStatusSoon =>
      'Status changes will open a confirmation flow (plan-12).';

  @override
  String get addPaymentCta => 'Add payment';

  @override
  String get addAdjustmentCta => 'Add adjustment';

  @override
  String get paymentAdjustmentHint =>
      'Use a negative amount to reduce recorded payments (append-only ledger).';

  @override
  String get paymentLedgerAdjustmentTag => 'سمون';

  @override
  String get paymentAdjustmentAdded => 'Adjustment recorded';

  @override
  String get paymentAdded => 'Payment added';

  @override
  String get paymentsEmpty => 'تر اوسه هېڅ ورکړه نشته.';

  @override
  String get paymentAmountLabel => 'بېله';

  @override
  String get paymentAmountHint => 'بېله ولیکئ (بې اعشار)';

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
  String get customersSearchHint => 'Search name or phone';

  @override
  String get customersEmptyTitle => 'No customers yet';

  @override
  String get customersAddCta => 'Add customer';

  @override
  String get customersFilteredEmpty => 'No customers match your search.';

  @override
  String get customersPhoneMissing => 'No phone';

  @override
  String get customerProfileTitle => 'Customer';

  @override
  String get customerNotFound => 'This customer could not be found.';

  @override
  String get customerInfoSection => 'Customer info';

  @override
  String get customerMeasurementProfilesSection => 'Measurement profiles';

  @override
  String get customerTodayOrdersTitle => 'Today’s orders';

  @override
  String get customerNoTodayOrders => 'No orders for today.';

  @override
  String get customerViewAllOrders => 'View all orders for this customer';

  @override
  String get customerViewAllOrdersSoon =>
      'This will open Orders with a customer filter (plan-13).';

  @override
  String get customerSectionPlaceholder =>
      'Details will appear here as the module is built.';

  @override
  String get customerNewPlaceholderBody =>
      'New customer form will go here (plan-13).';

  @override
  String get measurementUnitCm => 'Centimeters';

  @override
  String get measurementUnitInch => 'Inches';

  @override
  String get measurementProfilesEmpty =>
      'No saved profiles yet. Add one to reuse measurements on new orders.';

  @override
  String get measurementProfilesAddCta => 'Add profile';

  @override
  String get measurementProfileEditorTitleNew => 'New measurement profile';

  @override
  String get measurementProfileEditorTitleEdit => 'Edit measurement profile';

  @override
  String get measurementProfileLabelField => 'Profile name';

  @override
  String get measurementProfileBodyField => 'Measurements';

  @override
  String get measurementProfileNotesField => 'Extra notes';

  @override
  String get measurementProfileUnitSection => 'Unit';

  @override
  String get measurementProfileSaveAsNew => 'Save as new profile';

  @override
  String get measurementProfileCreated => 'Profile saved';

  @override
  String get measurementProfileUpdated => 'Profile updated';

  @override
  String get measurementProfilePickSheetTitle => 'Saved profiles';

  @override
  String get settingsMeasurementTypesTitle => 'د اندازې ساحې';

  @override
  String get settingsMeasurementTypesSubtitle =>
      'د پیرودونکي پروفایل او امرونو لپاره لیبلونه';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get tasksSettingsSubtitle => 'Simple to-do list (offline)';

  @override
  String get tasksSearchHint => 'Search tasks';

  @override
  String get tasksFilterAll => 'All';

  @override
  String get tasksFilterOpen => 'Open';

  @override
  String get tasksFilterDone => 'Done';

  @override
  String get tasksEmpty => 'No tasks yet. Add your first task.';

  @override
  String get tasksEmptyFiltered => 'No tasks match this filter.';

  @override
  String get tasksAddTitle => 'Add task';

  @override
  String get tasksEditTitle => 'Edit task';

  @override
  String get tasksTitleLabel => 'Title';

  @override
  String get tasksNotesLabel => 'Notes';

  @override
  String get tasksDueDatePick => 'Pick due date';

  @override
  String get tasksDueDateNone => 'No due date';

  @override
  String get tasksDueDateSet => 'Set';

  @override
  String get tasksDueDateClear => 'Clear due date';

  @override
  String tasksDueDateShort(String date) {
    return 'Due: $date';
  }

  @override
  String tasksDueDateValue(String date) {
    return 'Due date: $date';
  }

  @override
  String get tasksSave => 'Save';

  @override
  String get tasksDeleteAction => 'Delete';

  @override
  String get tasksDeleteTitle => 'Delete task?';

  @override
  String get tasksDeleteBody => 'This will remove the task from your list.';

  @override
  String get tasksDeleteCancel => 'Cancel';

  @override
  String get tasksDeleteConfirm => 'Delete';

  @override
  String get measurementTypesScreenTitle => 'Measurement fields';

  @override
  String get measurementTypesEmpty =>
      'No fields yet. Add the sizes your shop records.';

  @override
  String get measurementTypesAddCta => 'Add field';

  @override
  String get measurementTypesFieldNameLabel => 'Field name';

  @override
  String get measurementTypesRenameTitle => 'Rename field';

  @override
  String get measurementTypesDeleteTitle => 'Remove field?';

  @override
  String get measurementTypesDeleteBody =>
      'The field is hidden for new measurements. Values already saved on profiles and orders stay as they are.';

  @override
  String get measurementTypesActiveLabel => 'In use';

  @override
  String get measurementTypesInactiveLabel => 'Hidden';

  @override
  String get measurementTypesReorderHint => 'Drag to reorder';

  @override
  String get measurementTypesCreated => 'Field added';

  @override
  String get measurementTypesUpdated => 'Field updated';

  @override
  String get measurementTypesDeleted => 'Field removed';

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
  String get reportsPaymentsLedgerTitle => 'Payments ledger';

  @override
  String get reportsPaymentsLedgerSubtitle => 'List payments by date range';

  @override
  String get reportsPaymentsPickRange => 'Pick date range';

  @override
  String get reportsPaymentsApplyRange => 'Apply';

  @override
  String get reportsPaymentsSelectedRangeLabel => 'Selected range';

  @override
  String reportsPaymentsRangeValue(String from, String to) {
    return '$from → $to';
  }

  @override
  String get reportsPaymentsTotalLabel => 'Total';

  @override
  String get reportsPaymentsEmpty => 'No payments in this date range.';

  @override
  String get reportsPaymentsUnknownOrder => 'Unknown order';

  @override
  String get reportsPaymentsAdjustmentChip => 'Adjustment';

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
      'د میاشتې عاید راپور به دلته راشي (plan-16).';

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
    return '$amount پاتې';
  }

  @override
  String get catalogMyDesigns => 'My designs';

  @override
  String get catalogSharedDesigns => 'Shared designs';

  @override
  String get catalogGridView => 'Grid view';

  @override
  String get catalogListView => 'List view';

  @override
  String get catalogSearchHint => 'Search design or shop name';

  @override
  String get catalogSortTooltip => 'Sort';

  @override
  String get catalogSortSheetTitle => 'Sort designs';

  @override
  String get catalogSortSectionTitle => 'Sort by';

  @override
  String get catalogSortNewest => 'Newest first';

  @override
  String get catalogSortOldest => 'Oldest first';

  @override
  String get catalogSortNameAsc => 'Name A–Z';

  @override
  String get catalogSortNameDesc => 'Name Z–A';

  @override
  String get catalogResetSort => 'Reset';

  @override
  String get catalogApplySort => 'Apply';

  @override
  String get catalogSharedDirectoryEmpty =>
      'No shared listings in the directory yet.';

  @override
  String get catalogCommunityReadOnlyBanner =>
      'Shared directory entry — view only. You cannot edit or delete another shop’s listing.';

  @override
  String get catalogSharingToggleTitle => 'Enable catalog sharing';

  @override
  String get catalogSharingToggleSubtitle =>
      'Mutual opt-in: enable to browse and be listed in public directory (plan-14).';

  @override
  String get catalogSharedPlaceholder =>
      'Shared designs directory will appear here when online (plan-14).';

  @override
  String get catalogEmptyMyDesigns => 'No designs yet.';

  @override
  String get catalogAddDesignCta => 'Add design';

  @override
  String get catalogAddDesignPlaceholder =>
      'Camera / Gallery add will be implemented on Android/iOS only (plan-14).';

  @override
  String get catalogDetailTitle => 'Catalog item';

  @override
  String catalogDetailPlaceholder(String id) {
    return 'Catalog item $id — detail screen coming soon.';
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
  String get settingsShopTileSubtitle =>
      'د هټۍ جزئیات به دلته ښکاري (plan-15).';

  @override
  String get settingsCurrentUserTitle => 'اوسنی کارن';

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
  String get settingsUsersPlaceholder =>
      'د کارنو مدیریت به په plan-15 کې پلي شي.';

  @override
  String get settingsBackupRestoreTitle => 'بیکاپ او بیرته راوړل';

  @override
  String get settingsBackupRestoreSubtitleOwner =>
      'د هټۍ ډیټا په خوندي ډول صادرول او بیرته راوړل';

  @override
  String get settingsBackupRestorePlaceholder =>
      'بیکاپ/بیرته راوړل به په plan-15 کې پلي شي.';

  @override
  String get settingsMuteNotificationsTitle => 'خبرتیاوې بې غږ';

  @override
  String get settingsMuteNotificationsSubtitle =>
      'په اپ کې بنرونه او نښې بې غږ کړئ (تاریخ ساتل کېږي).';

  @override
  String get settingsNotificationsInboxTitle => 'د خبرتیاو صندوق';

  @override
  String get settingsNotificationsInboxSubtitle =>
      'تاریخ او فلټرونه (plan-15).';

  @override
  String get settingsNotificationsPlaceholder =>
      'د خبرتیاو صندوق به په plan-15 کې پلي شي.';

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
  String get settingsSyncDiagnosticsSubtitle =>
      'وروستی سنک، قطار، صندوق (plan-15).';

  @override
  String get settingsSyncDiagnosticsPlaceholder =>
      'سنک او تشخیص به په plan-15 کې پلي شي.';

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
      'د پراختیاګر پورټل پاڼې به په plan-18 کې پلي شي.';

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
  String get settingsLanguageTitle => 'ژبه';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageDari => 'Dari';

  @override
  String get languagePashto => 'Pashto';

  @override
  String get settingsDateCalendarTitle => 'د نیټې تقویم';

  @override
  String get settingsDateCalendarSubtitle =>
      'په اپ کې نیټې څنګه ښکاري او غوره کېږي';

  @override
  String get dateCalendarGregorian => 'Gregorian (AD)';

  @override
  String get dateCalendarSolarHijri => 'Solar Hijri (Afghan)';

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
  String get datePickerSolarHijriTitle => 'Choose date (Solar Hijri)';

  @override
  String get datePickerSolarHijriRangeTitle =>
      'Choose date range (Solar Hijri)';

  @override
  String get datePickerYearLabel => 'Year';

  @override
  String get datePickerMonthLabel => 'Month';

  @override
  String get datePickerDayLabel => 'Day';

  @override
  String get dateRangeFromLabel => 'From';

  @override
  String get dateRangeToLabel => 'To';

  @override
  String get settingsComingSoon => 'ژر راځي.';

  @override
  String get loading => 'Loading…';

  @override
  String get genericError => 'Something went wrong.';

  @override
  String get resetCta => 'بیا تنظیم';

  @override
  String get licenseExpiredReadOnly => 'License expired — read-only mode.';

  @override
  String moneyAfn(String amount) {
    return '$amount AFN';
  }

  @override
  String get ordersComposerCustomerTitle => 'Customer';

  @override
  String get ordersComposerCustomerRequired => 'Select customer (required)';

  @override
  String get ordersComposerMeasurementsTitle => 'Measurements';

  @override
  String get ordersComposerMeasurementsRequired =>
      'Add measurements (required)';

  @override
  String get ordersComposerMeasurementsSummary => 'Measurements captured';

  @override
  String get ordersComposerMeasurementsLabel => 'Measurements notes';

  @override
  String get ordersComposerMeasurementsHint =>
      'Type measurements or load a saved customer profile.';

  @override
  String get ordersComposerLoadProfileCta => 'Load from saved profile';

  @override
  String ordersComposerProfileLinked(String name) {
    return 'From profile: $name';
  }

  @override
  String get ordersComposerStyleTitle => 'Style';

  @override
  String get ordersComposerStyleRequired => 'Select style (required)';

  @override
  String get ordersComposerStyleLabel => 'Design / style';

  @override
  String get ordersComposerStyleHint => 'Example: Karzai, collar, pockets…';

  @override
  String get ordersComposerPaymentTitle => 'Payment';

  @override
  String get ordersComposerPaymentRequired => 'Enter totals (required)';

  @override
  String ordersComposerPaymentSummary(
    String total,
    String paid,
    String remaining,
  ) {
    return 'Total $total • Paid $paid • Remaining $remaining';
  }

  @override
  String get ordersComposerTotalLabel => 'Total amount (AFN)';

  @override
  String get ordersComposerTotalHint => 'Example: 150000';

  @override
  String get ordersComposerPaidLabel => 'Initial paid (AFN)';

  @override
  String get ordersComposerPaidHint => 'Example: 50000';

  @override
  String get ordersComposerDeliveryDateTitle => 'Delivery date';

  @override
  String get ordersComposerDeliveryDateUnset => 'Select delivery date';

  @override
  String get ordersComposerSaveCta => 'Save order';

  @override
  String get ordersComposerSaved => 'Order saved.';

  @override
  String get ordersComposerResetTitle => 'Reset form?';

  @override
  String get ordersComposerResetBody => 'This will clear all entered fields.';

  @override
  String get ordersComposerSelectCustomerFirstTitle => 'Select customer first';

  @override
  String get ordersComposerSelectCustomerFirstBody =>
      'Please select a customer before continuing.';

  @override
  String get ordersComposerRecentOrdersTitle => 'Recent orders';

  @override
  String get ordersComposerRecentOrdersSubtitle => 'For this customer';

  @override
  String ordersComposerRecentOrderRowSubtitle(String date, String remaining) {
    return '$date • $remaining remaining';
  }

  @override
  String get saveCta => 'ساتل';

  @override
  String get customersCreated => 'Customer created.';

  @override
  String get customerNameLabel => 'Name';

  @override
  String get customerNameHint => 'Example: Ahmad Karimi';

  @override
  String get customerNameRequired => 'Name is required.';

  @override
  String get customerNameTooShort => 'Name is too short.';

  @override
  String get customerPhoneLabel => 'Phone (optional)';

  @override
  String get customerPhoneHint => 'Example: 0700000001';

  @override
  String get saved => 'ساتل شو.';

  @override
  String get deleted => 'Deleted.';

  @override
  String get editCta => 'Edit';

  @override
  String get deleteCta => 'Delete';

  @override
  String get deleteConfirmTitle => 'Delete?';

  @override
  String get deleteConfirmBody => 'This action cannot be undone.';

  @override
  String get catalogItemNotFound => 'This catalog item could not be found.';

  @override
  String get catalogEditMetadataTitle => 'Edit metadata';

  @override
  String get catalogDesignNameLabel => 'Design name';

  @override
  String get catalogDesignNameHint => 'Example: Karzai suit';

  @override
  String get catalogNotesLabel => 'Notes (optional)';

  @override
  String get catalogNotesHint => 'Any details you want to remember…';

  @override
  String catalogDeleteConfirmBody(String name) {
    return 'Delete “$name”?';
  }

  @override
  String catalogDesignerAndDate(String shop, String date) {
    return '$shop • $date';
  }

  @override
  String get catalogSharePublicTitle => 'Share publicly';

  @override
  String get catalogSharePublicSubtitle =>
      'If enabled, this design can appear in the public directory (metadata only).';

  @override
  String get catalogSharePublicDisabledSubtitle =>
      'Enable catalog sharing in Catalog to use this.';

  @override
  String get catalogNotesTitle => 'Notes';

  @override
  String get catalogNotesEmpty => 'No notes';

  @override
  String get catalogAddNotAvailableOnWeb =>
      'Adding images is not available on Web.';

  @override
  String get catalogDesignNameRequired => 'Design name is required.';

  @override
  String get catalogImageRequired => 'Please pick an image first.';

  @override
  String get catalogCreated => 'Design added.';

  @override
  String get catalogMyShopNameFallback => 'My Shop';

  @override
  String get cameraCta => 'Camera';

  @override
  String get galleryCta => 'Gallery';

  @override
  String get dashboardKpisSectionTitle => 'At a glance';

  @override
  String get dashboardQuickLinksTitle => 'Quick links';

  @override
  String get dashboardThisMonthIncomeTitle => 'This month income';

  @override
  String get dashboardLicenseExpiredBanner =>
      'Your license is expired. Renew to edit again.';

  @override
  String get dashboardTodayDeliveriesTitle => 'Delivered today';

  @override
  String get dashboardTodayDeliveriesEmpty => 'No orders delivered today.';

  @override
  String get dashboardSearchOrdersHint => 'Search order #, customer, phone';

  @override
  String get dashboardSearchOrdersTooltip => 'Search orders';

  @override
  String get dashboardOverdueTitle => 'Overdue deliveries';

  @override
  String get dashboardOverdueEmpty => 'No overdue open orders.';

  @override
  String get dashboardOverdueViewAll => 'View all overdue';

  @override
  String get dashboardQuickLinkOverdue => 'Overdue orders';

  @override
  String get dashboardQuickLinkDeliveredToday => 'Delivered today';

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
  String get dashboardNotificationsPreviewTitle => 'Recent notifications';

  @override
  String get dashboardNotificationsPreviewEmpty => 'No notifications yet.';

  @override
  String get dashboardNotificationsMutedHint =>
      'Notifications are muted. Change this in Settings → Notifications.';

  @override
  String get dashboardNotificationsViewAll => 'View all notifications';

  @override
  String get notifSeedWelcomeTitle => 'Welcome to Afghan Pride';

  @override
  String get notifSeedWelcomeBody =>
      'Order updates and shop notices will appear here. Open any row to mark it read.';

  @override
  String notifOrderStatusTitle(String orderNo) {
    return 'Order $orderNo';
  }

  @override
  String notifOrderStatusBody(String status) {
    return 'Status updated to $status.';
  }

  @override
  String get settingsNotifMarkAllRead => 'ټول لوستل شوي وګرځوئ';

  @override
  String get subscriptionCurrentStatusTitle => 'اوسنی حالت';

  @override
  String get subscriptionReadOnlyHint => 'تر نوي کولو پورې یوازې لید.';

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
  String get subscriptionActivationComingSoon =>
      'فعالول به سرور سره ونښلوي (plan-06).';

  @override
  String get subscriptionRefreshStatusCta => 'د جواز حالت تازه کړئ';

  @override
  String get subscriptionRefreshComingSoon =>
      'آنلاین تازه کول به د API نښلولو سره شتون ولري.';

  @override
  String get subscriptionActivationCodeHintApi =>
      'Enter the activation code from your distributor.';

  @override
  String get subscriptionApplying => 'Applying…';

  @override
  String get subscriptionRefreshing => 'Refreshing…';

  @override
  String get subscriptionRedeemSuccess => 'License updated.';

  @override
  String subscriptionRedeemError(String error) {
    return 'Activation failed: $error';
  }

  @override
  String subscriptionRefreshError(String error) {
    return 'Could not refresh: $error';
  }

  @override
  String get customersListView => 'List view';

  @override
  String get customersCardView => 'Card view';

  @override
  String get customerEditDialogTitle => 'Edit customer';

  @override
  String get customerUpdated => 'Customer updated.';

  @override
  String get customerAddressLabel => 'Address';

  @override
  String get customerAddressHint => 'Optional';

  @override
  String get customerNotesLabel => 'Notes';

  @override
  String get customerNotesHint => 'Optional';

  @override
  String get customerFieldEmpty => '—';

  @override
  String get customerDeleteMenu => 'Delete customer';

  @override
  String get customerDeleteConfirmTitle => 'Delete this customer?';

  @override
  String get customerDeleteConfirmBody =>
      'They will be removed from your list. Existing orders stay in the Orders tab.';

  @override
  String get customerDeleted => 'Customer removed';

  @override
  String get customersFinancialSectionTitle => 'Balance';

  @override
  String get customersFinancialFilterAll => 'Any balance';

  @override
  String get customersFilterHasUnpaid => 'Has unpaid orders';

  @override
  String get customersSortMostOrders => 'Most orders';

  @override
  String customersRowMeta(int orderCount, String unpaid) {
    return '$orderCount orders · $unpaid';
  }

  @override
  String get customersRowNoOrdersYet => 'No orders yet';

  @override
  String get settingsUsersLimitsTitle => 'د کارنو حدونه';

  @override
  String get settingsUsersLimitsBody =>
      'ازمایښتې هټۍ: تر ۲ کارنو. ورکړل شوې هټۍ: تر ۵ کارنو. د مالک حساب نشي ړنګېدلی.';

  @override
  String get settingsUsersAddCta => 'کارن زیاتول';

  @override
  String get settingsUsersAddDisabledHint =>
      'د کارن مدیریت به سرور سره ونښلوي (plan-15).';

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
      'View accounts on the server (read-only unless you are the owner).';

  @override
  String settingsUsersLoadError(String error) {
    return 'Could not load users: $error';
  }

  @override
  String get settingsUsersRetryCta => 'Retry';

  @override
  String get settingsUsersDeleteConfirmTitle => 'Remove user?';

  @override
  String get settingsUsersDeleteConfirmBody =>
      'They will no longer be able to sign in.';

  @override
  String get settingsUsersDeleteCta => 'Remove';

  @override
  String get settingsUsersAddDialogTitle => 'Add user';

  @override
  String get settingsUsersAddUsernameLabel => 'Username';

  @override
  String get settingsUsersAddPasswordLabel => 'Password';

  @override
  String get settingsUsersAddSubmitCta => 'Create';

  @override
  String settingsUsersAddError(String error) {
    return 'Could not add user: $error';
  }

  @override
  String get settingsUsersAddedSnackbar => 'User created.';

  @override
  String get settingsUsersRemovedSnackbar => 'User removed.';

  @override
  String get settingsBackupOwnerPasswordNote =>
      'بیکاپ او بیرته راوړل به د مالک د ننوتلو پاسورډ ته اړتیا ولري (plan-15).';

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
  String get settingsNotificationsFiltersTitle => 'فلټرونه (مخکتنه)';

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
  String get settingsSyncLocalSnapshotTitle => 'Local data snapshot';

  @override
  String get settingsSyncLocalOrders => 'Orders';

  @override
  String get settingsSyncLocalCustomers => 'Customers';

  @override
  String get settingsSyncLocalPayments => 'Payments';

  @override
  String get settingsSyncLocalTasks => 'Tasks';

  @override
  String get settingsSyncLocalNotifications => 'Notifications';

  @override
  String get settingsSyncLocalUnread => 'Unread notifications';

  @override
  String get settingsSyncRetryTitle => 'Sync now';

  @override
  String get settingsSyncRetrySubtitle =>
      'Pull from the server, then push the local queue when API_BASE_URL is set and you are signed in online (plan-04).';

  @override
  String get settingsSyncRetryOffline =>
      'You appear offline. Connect to the internet and try again.';

  @override
  String get settingsSyncRetryConfigureApi =>
      'Set API_BASE_URL at build time, then open Settings → API connection.';

  @override
  String get settingsSyncRetrySignIn =>
      'Sign in with your online server account first.';

  @override
  String get settingsSyncRetryLicenseExpired =>
      'The server refused sync because the license is expired. Open Subscription.';

  @override
  String settingsSyncRetrySuccess(int pushed, int pulled) {
    return 'Sync OK: pushed $pushed mutation(s); received $pulled server change(s).';
  }

  @override
  String settingsSyncRetryFailed(String detail) {
    return 'Sync failed: $detail';
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
  String get devPortalTitle => 'Developer Portal';

  @override
  String get devPortalTabOverview => 'Overview';

  @override
  String get devPortalTabCodes => 'Codes';

  @override
  String get devPortalTabShops => 'Shops';

  @override
  String get devPortalTabResets => 'Resets';

  @override
  String get devPortalTabDiagnostics => 'Diagnostics';

  @override
  String get devPortalOnlineRequired =>
      'Developer tools require an online connection and a verified developer account.';

  @override
  String get devPortalRetryCta => 'Retry';

  @override
  String get devPortalStubAction => 'API not connected in this build.';

  @override
  String get devPortalAdviceOfflineTitle => 'You appear offline';

  @override
  String get devPortalAdviceOfflineBody =>
      'Connect to the internet to test public API health. Admin lists need the deployed admin APIs.';

  @override
  String get devPortalAdviceOnlineTitle => 'Admin list APIs not wired yet';

  @override
  String get devPortalAdviceOnlineBody =>
      'Pull down on Overview to call GET /health. Export a device bundle from Settings → Sync & Diagnostics.';

  @override
  String get devPortalApiHealthPrompt =>
      'Pull down to refresh and call GET /health.';

  @override
  String get devPortalEnvBadge => 'Environment: dev';

  @override
  String get devPortalStatShops => 'Total shops';

  @override
  String get devPortalStatActiveExpired => 'Active / expired';

  @override
  String get devPortalStatTrials => 'Trials running';

  @override
  String get devPortalStatActivations => 'Activations (period)';

  @override
  String get devPortalApiHealthTitle => 'API health';

  @override
  String get devPortalApiHealthUnknown => 'Unknown — connect to the API';

  @override
  String get devPortalCodesStub =>
      'Activation codes: search, create, and revoke will load from the admin API (plan-18).';

  @override
  String get devPortalShopsStub =>
      'Shops & licenses: list and detail views will load from the admin API.';

  @override
  String get devPortalResetsStub =>
      'Password reset requests: support queue will load from the admin API.';

  @override
  String get devPortalDiagStub =>
      'For a full device bundle, use Settings → Sync & Diagnostics → Export diagnostics bundle.';

  @override
  String get devPortalDiagLocalTitle => 'This device (offline cache)';

  @override
  String get devPortalDiagLocalSubtitle =>
      'Counts from local storage — useful when the admin API is offline.';

  @override
  String get devPortalDiagCountLoading => '…';

  @override
  String get devPortalAdminAuditTitle => 'Admin audit log (stub)';

  @override
  String get devPortalAdminAuditNeedSignIn =>
      'Sign in with the API, then pull to refresh.';

  @override
  String devPortalAdminAuditLine(int count, int schema) {
    return 'GET /admin/audit-log — $count row(s), schema v$schema';
  }

  @override
  String get settingsShopProfileTitle => 'د هټۍ پروفایل';

  @override
  String get shopProfileIntro =>
      'دا د هټۍ نوم ستاسو د کتلاګ توکو په ډیزاین لیبل کې ښکاري. د اړیکو ساحې ستاسو لپاره د مراجعې دي تر هغه چې بلینګ ونښلول شي.';

  @override
  String get shopProfileNameLabel => 'د هټۍ نوم';

  @override
  String get shopProfileNameHint => 'بېلګه: د پریډ خیاطي';

  @override
  String get shopProfileNameRequired => 'د هټۍ نوم اړین دی.';

  @override
  String get shopProfileNameTooShort => 'د هټۍ نوم ډېر لنډ دی.';

  @override
  String get shopProfileShopPhoneLabel => 'د هټۍ تلیفون (اختیاري)';

  @override
  String get shopProfileShopPhoneHint => 'بېلګه: 0700000000';

  @override
  String get shopProfileAddressLabel => 'پته (اختیاري)';

  @override
  String get shopProfileAddressHint => 'سړک، سیمه، ښار…';

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
  String get customersFilterTooltip => 'Sort & filter';

  @override
  String get customersFilterSheetTitle => 'Sort & filter';

  @override
  String get customersSortSectionTitle => 'Sort';

  @override
  String get customersSortNameAsc => 'A–Z';

  @override
  String get customersSortNameDesc => 'Z–A';

  @override
  String get customersSortRecentActivity => 'Recent activity';

  @override
  String get customersCreatedSectionTitle => 'Added';

  @override
  String get customersCreatedFilterAll => 'Any time';

  @override
  String get customersCreatedFilterToday => 'Today';

  @override
  String get customersCreatedFilterThisWeek => 'This week';

  @override
  String get customersActivitySectionTitle => 'Activity';

  @override
  String get customersFilterAll => 'All customers';

  @override
  String get customersFilterHasOrders => 'Has orders';

  @override
  String get customersFilterNoOrders => 'No orders yet';

  @override
  String get customersApplyFilters => 'Apply';

  @override
  String get customersResetFilters => 'Reset';
}
