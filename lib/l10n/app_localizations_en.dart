// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pride';

  @override
  String get tabOrders => 'Orders';

  @override
  String get tabCustomers => 'Customer list';

  @override
  String get tabOrdersList => 'Orders list';

  @override
  String get tabCatalog => 'Catalog';

  @override
  String get tabReports => 'Reports';

  @override
  String get tabSettings => 'Settings';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Enter your shop username and password to open your shop.';

  @override
  String get loginMockHint =>
      'In this build, any non-empty username and password will sign you in locally.';

  @override
  String get loginShopIdLabel => 'Shop ID (optional)';

  @override
  String get loginShopIdHint => 'Only if your shop gave you a shop ID';

  @override
  String get loginSigningInHint =>
      'Please wait. On slow internet this can take up to a minute.';

  @override
  String get loginCreatingShopHint =>
      'Please wait while your shop is being set up. This can take a moment.';

  @override
  String get loginInvalidCredentials =>
      'Shop ID, username, or password is not correct. Please check and try again.';

  @override
  String get loginNoInternet =>
      'No internet connection. Check your network and try again.';

  @override
  String get loginOfflineNotSetUp =>
      'Sign in once while online on this device to enable offline sign-in.';

  @override
  String get loginOfflineShopIdRequired =>
      'Enter your Shop ID to sign in offline.';

  @override
  String get loginConnectionSlow =>
      'The connection is slow or timed out. Please wait a moment and try again.';

  @override
  String get loginServerBusy =>
      'The service is busy right now. Please try again in a few minutes.';

  @override
  String get loginSomethingWrong =>
      'Could not sign in right now. Please try again.';

  @override
  String get loginShopCreateFailed =>
      'Could not create your shop right now. Please try again.';

  @override
  String get loginForgotPasswordSubmitting => 'Sending your request…';

  @override
  String get loginForgotPasswordSubmitHint =>
      'Please wait. This may take a moment on slow internet.';

  @override
  String get loginForgotPasswordFailed =>
      'Could not send your request right now. Please try again.';

  @override
  String get loginUsernameLabel => 'Username';

  @override
  String get loginUsernameHint => 'Your shop login name';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSignInCta => 'Sign in';

  @override
  String get loginForgotPasswordCta => 'Forgot password?';

  @override
  String get loginForgotPasswordTitle => 'Reset password';

  @override
  String get loginForgotPasswordBody =>
      'Enter your shop ID and username. A developer can set a new password from the Developer Portal when your request appears in the queue.';

  @override
  String get loginForgotPasswordSubmit => 'Submit request';

  @override
  String get loginForgotPasswordQueued =>
      'If the account exists, a reset request was queued for support.';

  @override
  String get loginForgotPasswordFieldsRequired =>
      'Shop ID and username are required.';

  @override
  String get settingsPushTokenTitle => 'Push notification token (beta)';

  @override
  String get settingsPushTokenHint =>
      'Paste an FCM device token, choose platform, then save. The server stores it for future push delivery.';

  @override
  String get settingsPushTokenFieldLabel => 'Device token';

  @override
  String get settingsPushPlatformLabel => 'Platform';

  @override
  String get settingsPushRegisterCta => 'Save token to server';

  @override
  String get settingsPushRegisterOk => 'Token saved.';

  @override
  String get settingsPushRegisterFail => 'Could not save token.';

  @override
  String devPortalShopsLoadError(String error) {
    return 'Could not load shops: $error';
  }

  @override
  String devPortalResetsLoadError(String error) {
    return 'Could not load reset queue: $error';
  }

  @override
  String get devPortalResetsEmpty => 'No pending password reset requests.';

  @override
  String get devPortalResetsSetPasswordTitle => 'Set new password';

  @override
  String get devPortalResetsSetPasswordHint => 'At least 6 characters.';

  @override
  String get devPortalResetsResolveCta => 'Apply password';

  @override
  String get devPortalResetsResolved => 'Password updated.';

  @override
  String devPortalResetsResolveFailed(String error) {
    return 'Could not update: $error';
  }

  @override
  String get loginFieldRequired => 'Required';

  @override
  String get loginDevContinue => 'Continue without account (dev)';

  @override
  String get loginApiHint =>
      'Sign in with your shop ID, username, and password.';

  @override
  String get loginSigningIn => 'Signing in…';

  @override
  String get loginApiUnauthorized =>
      'Shop ID, username, or password is not correct. Please check and try again.';

  @override
  String loginApiError(String error) {
    return 'Could not sign in: $error';
  }

  @override
  String get loginShopCreateSectionTitle => 'Create a new shop';

  @override
  String get loginShopCreateSubtitle =>
      'Register your tailoring shop and sign in as the owner.';

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
      'Today\'s KPIs and shortcuts from your shop data.';

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
  String get dashboardOpenMenuTooltip => 'Open dashboard';

  @override
  String get dashboardOrdersPipelineTitle => 'Order pipeline';

  @override
  String get dashboardRecentIncomeTitle => 'Income — last 7 days';

  @override
  String get dashboardActivitySectionTitle => 'Sync & notifications';

  @override
  String get subscriptionTitle => 'Subscription';

  @override
  String get subscriptionBody =>
      'Renew with Hesab Pay (steps below when published), submit a payment claim as shop owner, or enter an activation code from support. While expired, editing is limited; you can still view your data.';

  @override
  String get subscriptionBillingSectionTitle => 'Pay & renew';

  @override
  String get subscriptionListTileSubtitle => 'License, trial, and activation';

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
  String get ordersComposerPlaceholderBody => 'Order composer will go here.';

  @override
  String get ordersDetailTitle => 'Order details';

  @override
  String ordersDetailPlaceholderBody(String orderId) {
    return 'Order $orderId — details UI coming soon.';
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
  String ordersTakenOn(String dateTime) {
    return 'Taken: $dateTime';
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
  String get ordersFilterSheetTitle => 'Filters';

  @override
  String get ordersFilterQuickSection => 'Quick filters';

  @override
  String get ordersFilterDeliverySection => 'Delivery date';

  @override
  String get ordersFilterStatusSection => 'Status';

  @override
  String get ordersFilterClearAll => 'Clear all';

  @override
  String get ordersFilterApply => 'Apply';

  @override
  String get listToolbarSearchTooltip => 'Search';

  @override
  String get listToolbarFilterTooltip => 'Filters';

  @override
  String get appShellTapTitleForMenu => 'Tap to open dashboard menu';

  @override
  String get ordersDetailFromNewBanner =>
      'Tip: use the toolbar above to print the receipt or share the invoice.';

  @override
  String get ordersComposerPostSaveSubtitle =>
      'Print, share, or open the full order.';

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
      'This order is locked because it is Delivered or Cancelled.';

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
      'Status changes will open a confirmation flow.';

  @override
  String get addPaymentCta => 'Add payment';

  @override
  String get addAdjustmentCta => 'Add adjustment';

  @override
  String get paymentAdjustmentHint =>
      'Use a negative amount to reduce recorded payments (append-only ledger).';

  @override
  String get paymentLedgerAdjustmentTag => 'Adjustment';

  @override
  String get paymentAdjustmentAdded => 'Adjustment recorded';

  @override
  String get paymentAdded => 'Payment added';

  @override
  String get paymentsEmpty => 'No payments yet.';

  @override
  String get paymentAmountLabel => 'Amount';

  @override
  String get paymentAmountHint => 'Example: 300';

  @override
  String paymentAmount(String amount) {
    return 'Amount: $amount';
  }

  @override
  String get paymentTotal => 'Total';

  @override
  String get paymentPaid => 'Paid';

  @override
  String get paymentRemaining => 'Remaining';

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
  String get customerOrderHistoryTitle => 'Order history';

  @override
  String get customerNoOrders => 'No orders yet for this customer.';

  @override
  String get customerViewAllOrders => 'View all orders for this customer';

  @override
  String get customerViewAllOrdersSoon =>
      'This will open Orders with a customer filter.';

  @override
  String get customerSectionPlaceholder =>
      'Details will appear here as the module is built.';

  @override
  String get customerNewPlaceholderBody => 'New customer form will go here.';

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
  String get settingsMeasurementTypesTitle => 'Measurement fields';

  @override
  String get settingsMeasurementTypesSubtitle =>
      'Labels for customer profiles and orders';

  @override
  String get settingsMeasurementUnitTitle => 'Default measurement unit';

  @override
  String get settingsMeasurementUnitSubtitle =>
      'Used when entering cloth measurements on new orders';

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
  String get reportsOverviewTitle => 'Reports';

  @override
  String get reportsUnpaidCardTitle => 'Unpaid';

  @override
  String reportsUnpaidCardSubtitle(String amount) {
    return 'Total remaining: $amount';
  }

  @override
  String get reportsMonthlyIncomeTitle => 'Monthly income';

  @override
  String get reportsMonthlyIncomeSubtitle =>
      'Payments and balances by calendar month';

  @override
  String get reportsThisMonthOpenUnpaidTitle => 'Open orders unpaid';

  @override
  String reportsThisMonthOpenUnpaidSubtitle(String amount) {
    return 'New / in progress / ready: $amount';
  }

  @override
  String get reportsOrdersSummaryTitle => 'Orders by status';

  @override
  String get reportsOrdersSummaryEmpty => 'No orders yet.';

  @override
  String get reportsDeliveredReportTitle => 'Delivered';

  @override
  String get reportsDeliveredCardTitle => 'Delivered orders';

  @override
  String get reportsDeliveredCardSubtitle => 'By delivery month';

  @override
  String get reportsDeliveredEmpty => 'No delivered orders in this month.';

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
    return 'Week of $weekStart';
  }

  @override
  String get reportsPaymentsGroupByLabel => 'Group by';

  @override
  String get reportsPaymentsGroupByDay => 'Day';

  @override
  String get reportsPaymentsGroupByWeek => 'Week';

  @override
  String get reportsPaymentsGroupByMonth => 'Month';

  @override
  String get reportsMonthlyIncomePlaceholder =>
      'Monthly income report will go here.';

  @override
  String get reportsThisMonthIncomeTitle => 'This month income';

  @override
  String reportsThisMonthIncomeSubtitle(String amount) {
    return 'Income: $amount';
  }

  @override
  String get reportsMonthlyIncomeCardLabel => 'Payments received';

  @override
  String get reportsMonthlyDailyPaymentsLabel => 'Daily payments (this month)';

  @override
  String get reportsMonthlyUnpaidDueTitle => 'Unpaid (due this month)';

  @override
  String get reportsMonthlyUnpaidDueBody =>
      'Sum of remaining balances on orders with a delivery date in this month.';

  @override
  String get reportsPrevMonth => 'Previous month';

  @override
  String get reportsNextMonth => 'Next month';

  @override
  String get reportsUnpaidTotalLabel => 'Total remaining';

  @override
  String get reportsUnpaidEmpty => 'No unpaid orders.';

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
  String get reportsUnpaidAmountSection => 'Remaining balance';

  @override
  String get reportsUnpaidAmountAny => 'Any amount';

  @override
  String get reportsUnpaidAmountUnder5000 => 'Under 5,000';

  @override
  String get reportsUnpaidAmount5000to20000 => '5,000 – 20,000';

  @override
  String get reportsUnpaidAmountOver20000 => 'Over 20,000';

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
    return '$amount remaining';
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
      'Mutual opt-in: enable to browse and be listed in public directory.';

  @override
  String get catalogSharedPlaceholder =>
      'Shared designs directory will appear here when online.';

  @override
  String get catalogEmptyMyDesigns => 'No designs yet.';

  @override
  String get catalogAddDesignCta => 'Add design';

  @override
  String get catalogViewDescription => 'Description';

  @override
  String get catalogDescriptionSheetTitle => 'Description';

  @override
  String get catalogNoDescription => 'No description for this design.';

  @override
  String get catalogViewerManageA11y => 'Manage design';

  @override
  String get catalogAddDesignPlaceholder =>
      'Camera / Gallery add will be implemented on Android/iOS only.';

  @override
  String get catalogDetailTitle => 'Catalog item';

  @override
  String catalogDetailPlaceholder(String id) {
    return 'Catalog item $id — detail screen coming soon.';
  }

  @override
  String get settingsSectionAccountAndShop => 'Account & shop';

  @override
  String get settingsSectionUsers => 'Users';

  @override
  String get settingsSectionBackupRestore => 'Backup & restore';

  @override
  String get settingsSectionNotifications => 'Notifications';

  @override
  String get settingsSectionSyncDiagnostics => 'Sync & diagnostics';

  @override
  String get settingsSectionAppearanceLanguage => 'Appearance & language';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsSectionDeveloper => 'Developer';

  @override
  String get settingsShopTileTitle => 'Shop profile';

  @override
  String get settingsShopTileSubtitle => 'Shop details will appear here.';

  @override
  String get settingsCurrentUserTitle => 'Account';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsAccountUsernameLabel => 'Username';

  @override
  String get settingsAccountUsernameHint =>
      'Usernames are set by the shop owner and cannot be changed here.';

  @override
  String get settingsAccountRoleLabel => 'Role';

  @override
  String get settingsAccountChangePasswordTitle => 'Change password';

  @override
  String get settingsAccountChangePasswordSubtitle =>
      'Update the password for this account on this device.';

  @override
  String get settingsAccountCurrentPasswordLabel => 'Current password';

  @override
  String get settingsAccountNewPasswordLabel => 'New password';

  @override
  String get settingsAccountConfirmPasswordLabel => 'Confirm new password';

  @override
  String get settingsAccountChangePasswordCta => 'Update password';

  @override
  String get settingsAccountChangePasswordOk =>
      'Password updated. Use the new password next time you sign in.';

  @override
  String settingsAccountChangePasswordFail(String error) {
    return 'Could not update password: $error';
  }

  @override
  String get settingsAccountPasswordMismatch => 'New passwords do not match.';

  @override
  String get settingsAccountOfflineHint =>
      'Connect to the server to change your password.';

  @override
  String get settingsAccountForgotPasswordCta =>
      'Request password reset from support';

  @override
  String get settingsUsersReadOnlyHint =>
      'Only the shop owner can add or remove users.';

  @override
  String get settingsSignOutTitle => 'Sign out';

  @override
  String get settingsSignOutSubtitle => 'End this session on this device';

  @override
  String get settingsSignOutDialogTitle => 'Sign out?';

  @override
  String get settingsSignOutDialogBody =>
      'You will need to sign in again to continue.';

  @override
  String get settingsSignOutCancel => 'Cancel';

  @override
  String get settingsSignOutConfirm => 'Sign out';

  @override
  String get settingsRoleOwner => 'Owner';

  @override
  String get settingsRoleUser => 'User';

  @override
  String get settingsOwnerOnly => 'Owner only';

  @override
  String get settingsUsersTitle => 'Manage users';

  @override
  String get settingsUsersSubtitleOwner => 'Trial: 2 users • Paid: 5 users';

  @override
  String get settingsUsersPlaceholder =>
      'Users management will be implemented (create/remove users, limits, owner protections).';

  @override
  String get settingsBackupRestoreTitle => 'Backup & restore';

  @override
  String get settingsBackupRestoreSubtitleOwner =>
      'Export and restore shop data safely';

  @override
  String get settingsBackupRestorePlaceholder =>
      'Backup/restore will be implemented (merge restore, owner password confirmation, restore summary).';

  @override
  String get settingsMuteNotificationsTitle => 'Mute notifications';

  @override
  String get settingsMuteNotificationsSubtitle =>
      'Silence in-app banners and badges (history is kept).';

  @override
  String get settingsNotificationsInboxTitle => 'Notifications inbox';

  @override
  String get settingsNotificationsInboxSubtitle => 'History and filters.';

  @override
  String get settingsNotificationsPlaceholder =>
      'Notifications inbox will be implemented.';

  @override
  String get settingsSyncDiagnosticsTitle => 'Sync & diagnostics';

  @override
  String get settingsNetworkStatusTitle => 'Network';

  @override
  String get settingsNetworkStatusOnline => 'Connected';

  @override
  String get settingsNetworkStatusOffline => 'Offline — working locally';

  @override
  String get settingsApiServerTitle => 'API server';

  @override
  String get settingsApiServerNotConfigured =>
      'No URL set. Use --dart-define=API_BASE_URL=https://your-api when you run or build.';

  @override
  String settingsApiServerConfigured(String url) {
    return 'Base URL: $url';
  }

  @override
  String get settingsApiTestConnection => 'Test connection';

  @override
  String get settingsApiTestNeedOnline =>
      'Connect to the internet to test the server.';

  @override
  String get settingsApiHealthOk => 'Server responded OK (GET /health).';

  @override
  String settingsApiHealthFailed(String message) {
    return 'Could not reach server: $message';
  }

  @override
  String get settingsSyncDiagnosticsSubtitle =>
      'Last sync, queue, and pending changes.';

  @override
  String get settingsSyncDiagnosticsPlaceholder =>
      'Sync status and diagnostics appear here.';

  @override
  String get settingsAppearanceLanguageTitle => 'Appearance & language';

  @override
  String get settingsAppearanceLanguageSubtitle => 'Theme and language';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsAboutSubtitle => 'App info and version';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String get settingsBuildTitle => 'Package';

  @override
  String get settingsDeveloperPortalTitle => 'Developer Portal';

  @override
  String get settingsDeveloperPortalSubtitle =>
      'Advanced tools (developer accounts only).';

  @override
  String get settingsDeveloperPortalPlaceholder =>
      'Developer Portal screens will be implemented.';

  @override
  String get settingsDevRolesTitle => 'Dev role toggles';

  @override
  String get settingsDevRoleOwnerTitle => 'Simulate owner account';

  @override
  String get settingsDevRoleOwnerSubtitle =>
      'Shows owner-only sections unlocked.';

  @override
  String get settingsDevRoleDeveloperTitle => 'Simulate developer account';

  @override
  String get settingsDevRoleDeveloperSubtitle =>
      'Shows Developer Portal entry.';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsSectionSoundFeedback => 'Sound & feedback';

  @override
  String get settingsUiSoundsTitle => 'UI sounds';

  @override
  String get settingsUiSoundsSubtitle =>
      'Short sounds when you save, delete, or complete an action.';

  @override
  String get settingsUiHapticsTitle => 'Haptic feedback';

  @override
  String get settingsUiHapticsSubtitle =>
      'Light vibration on successful actions.';

  @override
  String get settingsUiHapticsWebHint => 'Haptics are not available on web.';

  @override
  String get settingsSoundPreviewSuccess => 'Success';

  @override
  String get settingsSoundPreviewError => 'Error';

  @override
  String get settingsSoundPreviewDelete => 'Delete';

  @override
  String get ordersDetailPaymentProgress => 'Payment progress';

  @override
  String get ordersComposerProgressTitle => 'Order progress';

  @override
  String ordersComposerProgressCount(int done, int total) {
    return '$done of $total steps';
  }

  @override
  String get ordersComposerProgressCustomer => 'Customer';

  @override
  String get ordersComposerProgressMeasurements => 'Measures';

  @override
  String get ordersComposerProgressStyle => 'Style';

  @override
  String get ordersComposerProgressFabric => 'Fabric';

  @override
  String get ordersComposerProgressDelivery => 'Delivery';

  @override
  String get ordersComposerProgressPayment => 'Payment';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageDari => 'Dari';

  @override
  String get languagePashto => 'Pashto';

  @override
  String get settingsDateCalendarTitle => 'Date calendar';

  @override
  String get settingsDateCalendarSubtitle =>
      'How dates are shown and picked in the app';

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
  String get settingsComingSoon => 'Coming soon.';

  @override
  String get loading => 'Loading…';

  @override
  String get genericError => 'Something went wrong.';

  @override
  String get resetCta => 'Reset';

  @override
  String get licenseGraceReadOnlySnack =>
      'Read-only until your license is verified online.';

  @override
  String get licenseClockTamperSnack =>
      'Read-only: device clock looks inconsistent. Open Subscription while online to verify.';

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
  String get ordersComposerTotalHint => 'Example: 1500';

  @override
  String get ordersComposerPaidLabel => 'Initial paid (AFN)';

  @override
  String get ordersComposerPaidHint => 'Example: 500';

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
  String get ordersComposerValidationTitle => 'Complete required steps';

  @override
  String get ordersComposerValidationBody =>
      'Fill in the following before saving this order:';

  @override
  String get ordersComposerRecentOrdersTitle => 'Recent orders';

  @override
  String get ordersComposerRecentOrdersSubtitle => 'For this customer';

  @override
  String ordersComposerRecentOrderRowSubtitle(String date, String remaining) {
    return '$date • $remaining remaining';
  }

  @override
  String get ordersComposerMeasurementsSheetTitle => 'Measurements';

  @override
  String get ordersComposerMeasurementsNoTypesBody =>
      'Add measurement types in Settings → Measurement types first.';

  @override
  String ordersComposerMeasurementsProfileAutoLabel(String date) {
    return 'Pattern #$date';
  }

  @override
  String get ordersComposerSaveMeasurementsToProfile =>
      'Save as customer profile';

  @override
  String get ordersComposerSaveMeasurementsToProfileSubtitle =>
      'Updates saved measurements on the selected customer.';

  @override
  String get ordersComposerAddMeasurementsCta => 'Add measurements';

  @override
  String get ordersComposerStyleTitle => 'Style';

  @override
  String get ordersComposerFabricTitle => 'Customer fabric';

  @override
  String get ordersComposerFabricOptional =>
      'Optional — cloth the customer brings';

  @override
  String ordersComposerFabricSummary(String name, String color, String id) {
    return '$name • $color • ID $id';
  }

  @override
  String ordersComposerFabricPartialSummary(String name, String color) {
    return '$name • $color';
  }

  @override
  String get ordersComposerFabricUnset => 'No fabric recorded';

  @override
  String get ordersComposerFabricSheetTitle => 'Customer fabric';

  @override
  String get ordersComposerFabricNameLabel => 'Fabric name';

  @override
  String get ordersComposerFabricNameHint => 'Select or type';

  @override
  String get ordersComposerFabricColorLabel => 'Fabric color';

  @override
  String get ordersComposerFabricColorHint => 'Select or type';

  @override
  String get ordersComposerFabricIdLabel => 'Fabric ID';

  @override
  String get ordersComposerFabricIdHint =>
      'Assigned automatically when you save';

  @override
  String get ordersComposerFabricClearCta => 'Clear fabric';

  @override
  String get ordersComposerStyleRequired => 'Add style (required)';

  @override
  String get ordersComposerStyleSummary => 'Style selected';

  @override
  String get ordersComposerStyleSheetTitle => 'Order style';

  @override
  String get ordersComposerStyleMainTitle => 'Main cloth style';

  @override
  String get ordersComposerStyleCustomLabel => 'Style name';

  @override
  String get ordersComposerStyleCustomHint => 'Select above or type custom';

  @override
  String get ordersComposerStyleFiguresTitle => 'Design figures';

  @override
  String get ordersComposerStyleNoFigures =>
      'No design figures yet — add them in Settings → Order style.';

  @override
  String get ordersComposerStyleClearFigures => 'Clear all selections';

  @override
  String get ordersComposerCatalogDesignTitle => 'Complete design from catalog';

  @override
  String get ordersComposerCatalogDesignNone => 'No catalog design selected';

  @override
  String get ordersComposerCatalogChooseCta => 'Choose from catalog';

  @override
  String get ordersComposerCatalogClearCta => 'Clear design';

  @override
  String get ordersComposerCatalogPickerTitle => 'My designs';

  @override
  String get ordersComposerCatalogPickerEmpty =>
      'No designs in your catalog yet. Add designs in the Catalog tab.';

  @override
  String get customerLastCatalogDesignLabel => 'Last catalog design';

  @override
  String get orderDetailCatalogDesignTitle => 'Complete design';

  @override
  String get receiptCatalogDesignLabel => 'Design';

  @override
  String get invoiceCatalogDesignLabel => 'Catalog design';

  @override
  String get invoiceCatalogDesignerLabel => 'Designer';

  @override
  String get settingsStyleHubTitle => 'Order style';

  @override
  String get settingsStyleTileTitle => 'Order style';

  @override
  String get settingsStyleTileSubtitle => 'Style names and design figures';

  @override
  String get settingsFabricHubTitle => 'Customer fabric';

  @override
  String get settingsFabricHubSubtitle => 'Preset names and colors for orders';

  @override
  String get settingsFabricNamesTitle => 'Fabric names';

  @override
  String get settingsFabricNamesSubtitle =>
      'Cotton, wool, and other cloth types';

  @override
  String get settingsFabricNamesEmpty => 'No fabric names yet.';

  @override
  String get settingsFabricNameAddCta => 'Add fabric name';

  @override
  String get settingsFabricNameFieldLabel => 'Name';

  @override
  String get settingsFabricNameRenameTitle => 'Rename fabric';

  @override
  String get settingsFabricNameDeleteTitle => 'Delete fabric name?';

  @override
  String get settingsFabricNameDeleteBody =>
      'This removes the name from the list. Existing orders are not changed.';

  @override
  String get settingsFabricColorsTitle => 'Fabric colors';

  @override
  String get settingsFabricColorsSubtitle => 'Navy, cream, and other colors';

  @override
  String get settingsFabricColorsEmpty => 'No fabric colors yet.';

  @override
  String get settingsFabricColorAddCta => 'Add fabric color';

  @override
  String get settingsFabricColorFieldLabel => 'Color';

  @override
  String get settingsFabricColorRenameTitle => 'Rename color';

  @override
  String get settingsFabricColorDeleteTitle => 'Delete fabric color?';

  @override
  String get settingsFabricColorDeleteBody =>
      'This removes the color from the list. Existing orders are not changed.';

  @override
  String get settingsFabricActiveLabel => 'In use';

  @override
  String get settingsFabricInactiveLabel => 'Hidden';

  @override
  String get settingsStyleNamesTitle => 'Cloth style names';

  @override
  String get settingsStyleNamesSubtitle =>
      'Qasimi, Kandahari, and custom names';

  @override
  String get settingsStyleNamesEmpty => 'No style names yet.';

  @override
  String get settingsStyleNameAddCta => 'Add style name';

  @override
  String get settingsStyleNameFieldLabel => 'Name';

  @override
  String get settingsStyleNameRenameTitle => 'Rename style';

  @override
  String get settingsStyleNameDeleteTitle => 'Delete style?';

  @override
  String get settingsStyleNameDeleteBody =>
      'This removes the name from the list. Existing orders are not changed.';

  @override
  String get settingsStylePartsTitle => 'Garment parts';

  @override
  String get settingsStylePartsSubtitle => 'Sleeve, collar, pocket, and more';

  @override
  String get settingsStylePartsEmpty => 'No parts yet.';

  @override
  String get settingsStylePartAddCta => 'Add part';

  @override
  String get settingsStylePartFieldLabel => 'Part name';

  @override
  String get settingsStylePartRenameTitle => 'Rename part';

  @override
  String get settingsStylePartDeleteTitle => 'Delete part?';

  @override
  String get settingsStylePartDeleteBody =>
      'Figures for this part are also removed.';

  @override
  String get settingsStyleFiguresTitle => 'Design figures';

  @override
  String get settingsStyleFiguresSubtitle => 'All tailoring design images';

  @override
  String get settingsStyleFiguresEmpty => 'No design figures yet.';

  @override
  String get settingsStyleFigurePartLabel => 'Garment part';

  @override
  String get settingsStyleFigureAddCta => 'Add figure';

  @override
  String get settingsStyleFigureNameLabel => 'Figure name';

  @override
  String get settingsStyleFigureDeleteTitle => 'Delete figure?';

  @override
  String get settingsStyleFigureDeleteBody =>
      'This removes the design from your catalog.';

  @override
  String get settingsStyleFigureWebOnlyBody =>
      'Adding custom images is available on Android and iOS. Bundled figures still work on web.';

  @override
  String get settingsStyleActiveLabel => 'Active';

  @override
  String get settingsStyleInactiveLabel => 'Inactive';

  @override
  String get saveCta => 'Save';

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
  String get saved => 'Saved.';

  @override
  String get deleted => 'Deleted.';

  @override
  String get editCta => 'Edit';

  @override
  String get deleteCta => 'Delete';

  @override
  String deleteByTypingConfirmHint(String expected) {
    return 'Type “$expected” below to confirm.';
  }

  @override
  String get deleteByTypingConfirmFieldLabel => 'Confirmation';

  @override
  String get deleteByTypingConfirmMismatch =>
      'That does not match. Check spelling and try again.';

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
  String get dashboardLicenseGraceBanner =>
      'You have been offline too long since the server verified your license. Open Subscription and refresh while online.';

  @override
  String get dashboardLicenseClockTamperBanner =>
      'Device time may have been changed. Connect online and refresh your license on Subscription to keep editing.';

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
  String get shellAppBarSyncA11y => 'Sync status';

  @override
  String get shellAppBarNotificationsA11y => 'Notifications';

  @override
  String get shellAppBarNotificationsMutedA11y => 'Notifications (muted)';

  @override
  String get shellSyncStatusOfflineChip => 'Offline';

  @override
  String get shellSyncTooltipNever =>
      'Server sync is not connected yet. Your data stays on this device.';

  @override
  String get shellSyncTooltipOffline =>
      'No network. You can keep working; changes stay on this device.';

  @override
  String shellSyncTooltipLast(String when) {
    return 'Last successful sync: $when';
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
  String get settingsNotifMarkAllRead => 'Mark all read';

  @override
  String get subscriptionCurrentStatusTitle => 'Current status';

  @override
  String get subscriptionReadOnlyHint => 'View-only mode until you renew.';

  @override
  String get subscriptionGraceReadOnlyHint =>
      'Read-only until the server can verify your license. Connect to the internet and tap Refresh status below.';

  @override
  String get subscriptionClockTamperHint =>
      'Read-only until the server confirms your license after a device time check. Tap Refresh status while online.';

  @override
  String get subscriptionActivationTitle => 'Activation';

  @override
  String get subscriptionActivationCodeLabel => 'Activation code';

  @override
  String get subscriptionActivationCodeHint =>
      'Enter code when billing is connected';

  @override
  String get subscriptionActivateCta => 'Activate';

  @override
  String get subscriptionActivationComingSoon =>
      'Activation will connect to the server.';

  @override
  String get subscriptionRefreshStatusCta => 'Refresh license status';

  @override
  String get subscriptionRefreshComingSoon =>
      'Online refresh will be available when the API is connected.';

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
  String get subscriptionBillingPlansTitle => 'Plans & prices (AFN)';

  @override
  String get subscriptionBillingPrice1Year => '1 year';

  @override
  String get subscriptionBillingPrice2Year => '2 years';

  @override
  String get subscriptionBillingPriceLifetime => 'Lifetime';

  @override
  String get subscriptionBillingHesabPayTitle => 'Pay with Hesab Pay';

  @override
  String get subscriptionBillingCashTitle => 'Pay in cash';

  @override
  String get subscriptionBillingContactTitle =>
      'After payment — contact support';

  @override
  String get subscriptionBillingCopyAccount => 'Copy account number';

  @override
  String get subscriptionBillingCopied => 'Copied';

  @override
  String subscriptionBillingOfflineCache(String when) {
    return 'Showing saved payment info from $when. Connect to refresh.';
  }

  @override
  String get subscriptionBillingNotPublished =>
      'Payment instructions are not published yet. Ask your distributor to publish them in Developer Portal → Billing, or enter an activation code below.';

  @override
  String subscriptionBillingLoadError(String error) {
    return 'Could not load payment info: $error';
  }

  @override
  String get subscriptionPaymentClaimTitle => 'I have paid (Hesab Pay)';

  @override
  String get subscriptionPaymentClaimOwnerOnly =>
      'Only the shop owner can submit a payment claim.';

  @override
  String get subscriptionPaymentClaimPlanTier => 'Plan';

  @override
  String get subscriptionPaymentClaimPlanOneYear => '1 year';

  @override
  String get subscriptionPaymentClaimPlanTwoYear => '2 years';

  @override
  String get subscriptionPaymentClaimPlanLifetime => 'Lifetime';

  @override
  String get subscriptionPaymentClaimTransactionId => 'Transaction ID';

  @override
  String get subscriptionPaymentClaimTransactionHint =>
      'From your Hesab Pay receipt';

  @override
  String get subscriptionPaymentClaimPayerPhone => 'Your phone (optional)';

  @override
  String get subscriptionPaymentClaimNotes => 'Notes (optional)';

  @override
  String get subscriptionPaymentClaimSubmit => 'Submit payment claim';

  @override
  String get subscriptionPaymentClaimSubmitting => 'Submitting…';

  @override
  String get subscriptionPaymentClaimSubmitSuccess =>
      'Payment claim submitted. We will review and send your activation code.';

  @override
  String subscriptionPaymentClaimSubmitError(String error) {
    return 'Could not submit: $error';
  }

  @override
  String get subscriptionPaymentClaimHistoryTitle => 'Your payment claims';

  @override
  String get subscriptionPaymentClaimStatusPending => 'Pending review';

  @override
  String get subscriptionPaymentClaimStatusApproved => 'Approved';

  @override
  String get subscriptionPaymentClaimStatusRejected => 'Rejected';

  @override
  String get subscriptionPaymentClaimCodeLabel => 'Activation code';

  @override
  String get subscriptionBillingWhatsapp => 'WhatsApp';

  @override
  String get subscriptionBillingTelegram => 'Telegram';

  @override
  String get subscriptionBillingPhone => 'Phone';

  @override
  String get devPortalTabBilling => 'Billing';

  @override
  String get devPortalBillingIntro =>
      'Set Hesab Pay account details, prices (AFN), and payment steps in each language. Turn on Published so every shop sees them under Settings → Subscription. Review payment claims below and approve to create activation codes.';

  @override
  String devPortalBillingLoadError(String error) {
    return 'Could not load billing profile: $error';
  }

  @override
  String get devPortalBillingProfileTitle => 'Hesab Pay profile';

  @override
  String get devPortalBillingPublished => 'Published (visible to shops)';

  @override
  String get devPortalBillingAccountName => 'Account name';

  @override
  String get devPortalBillingAccountNumber => 'Account number';

  @override
  String get devPortalBillingMerchantId => 'Merchant / reference ID';

  @override
  String get devPortalBillingPrice1Year => 'Price 1 year (AFN)';

  @override
  String get devPortalBillingPrice2Year => 'Price 2 years (AFN)';

  @override
  String get devPortalBillingPriceLifetime => 'Price lifetime (AFN)';

  @override
  String get devPortalBillingPaymentStepsEn => 'Payment steps (English)';

  @override
  String get devPortalBillingPaymentStepsFa => 'Payment steps (Dari)';

  @override
  String get devPortalBillingPaymentStepsPs => 'Payment steps (Pashto)';

  @override
  String get devPortalBillingActivationStepsEn =>
      'Activation delivery (English)';

  @override
  String get devPortalBillingActivationStepsFa => 'Activation delivery (Dari)';

  @override
  String get devPortalBillingActivationStepsPs =>
      'Activation delivery (Pashto)';

  @override
  String get devPortalBillingCashNoteEn => 'Cash payment note (English)';

  @override
  String get devPortalBillingCashNoteFa => 'Cash payment note (Dari)';

  @override
  String get devPortalBillingCashNotePs => 'Cash payment note (Pashto)';

  @override
  String get devPortalBillingWhatsapp => 'WhatsApp (E.164)';

  @override
  String get devPortalBillingTelegram => 'Telegram handle';

  @override
  String get devPortalBillingPhone => 'Direct phone (E.164)';

  @override
  String get devPortalBillingSave => 'Save billing profile';

  @override
  String get devPortalBillingSaveSuccess => 'Billing profile saved.';

  @override
  String devPortalBillingSaveError(String error) {
    return 'Save failed: $error';
  }

  @override
  String get devPortalBillingClaimsTitle => 'Payment claims';

  @override
  String get devPortalBillingClaimsPending => 'Pending';

  @override
  String get devPortalBillingClaimsAll => 'All';

  @override
  String get devPortalBillingClaimApprove => 'Approve & create code';

  @override
  String get devPortalBillingClaimReject => 'Reject';

  @override
  String get devPortalBillingClaimRejectNotes => 'Reason (optional)';

  @override
  String get devPortalBillingClaimApproved => 'Claim approved.';

  @override
  String get devPortalBillingClaimRejected => 'Claim rejected.';

  @override
  String get devPortalBillingNoClaims => 'No payment claims.';

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
  String get orderDeleteMenu => 'Delete order';

  @override
  String get orderDeleteConfirmTitle => 'Delete this order?';

  @override
  String get orderDeleteConfirmBody =>
      'The order will be removed from your list on this device.';

  @override
  String get orderDeleted => 'Order removed';

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
  String customersRowSince(String date) {
    return 'Customer since $date';
  }

  @override
  String get reportsThisMonthIncomeEmpty =>
      'No payments recorded this month yet.';

  @override
  String get reportsOpenUnpaidEmpty =>
      'No open orders with a remaining balance.';

  @override
  String reportsOrdersByStatusCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders',
      one: '1 order',
    );
    return '$_temp0';
  }

  @override
  String get settingsUsersLimitsTitle => 'User limits';

  @override
  String get settingsUsersLimitsBody =>
      'Trial shops: up to 2 users. Paid shops: up to 5 users. The owner account cannot be deleted.';

  @override
  String get settingsUsersAddCta => 'Add user';

  @override
  String get settingsUsersAddDisabledHint =>
      'User management will connect to the server.';

  @override
  String get settingsUsersListTitle => 'Team';

  @override
  String get settingsUsersOwnerRowTitle => 'Shop owner';

  @override
  String get settingsUsersOwnerRowSubtitle => 'Full access';

  @override
  String get settingsUsersEmptyRowTitle => 'Additional users';

  @override
  String get settingsUsersEmptyRowSubtitle => 'No other users yet';

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
      'Backup and restore will require the owner’s login password.';

  @override
  String get settingsBackupSectionTitle => 'Backup';

  @override
  String get settingsBackupOptionDataOnly => 'Data only';

  @override
  String get settingsBackupOptionDataOnlySubtitle =>
      'Orders, customers, payments, catalog metadata — smaller file';

  @override
  String get settingsBackupOptionDataAndImages => 'Data + catalog images';

  @override
  String get settingsBackupOptionDataAndImagesSubtitle =>
      'Includes design photos stored on this device';

  @override
  String get settingsBackupCreateCta => 'Create backup';

  @override
  String get settingsRestoreSectionTitle => 'Restore';

  @override
  String get settingsRestoreMergeNote =>
      'Restore always merges into your current data (never replaces everything).';

  @override
  String get settingsRestorePickCta => 'Choose backup file';

  @override
  String get settingsBackupRestoreComingSoon =>
      'Catalog images are not included in v1 backups yet.';

  @override
  String get settingsBackupWebNotSupported =>
      'Backup and restore require the native app (Isar). Use Android, iOS, or desktop — not Web.';

  @override
  String get settingsBackupExportDone => 'Backup file saved.';

  @override
  String get settingsBackupRestoreDone => 'Restore completed.';

  @override
  String get settingsBackupRestoreSummaryTitle => 'Restore summary';

  @override
  String settingsBackupSummaryLineCustomers(int inserted, int updated) {
    return 'Customers: $inserted new, $updated merged';
  }

  @override
  String settingsBackupSummaryLineMeasurements(
    int types,
    int profiles,
    int lines,
  ) {
    return 'Measurements: $types field types, $profiles profiles, $lines saved values';
  }

  @override
  String settingsBackupSummaryLineOrders(int count) {
    return 'Orders: $count written';
  }

  @override
  String settingsBackupSummaryLinePayments(int inserted, int skipped) {
    return 'Payments: $inserted added, $skipped skipped (already existed)';
  }

  @override
  String settingsBackupSummaryLineSnapshots(int headers, int items) {
    return 'Measurement snapshots: $headers headers, $items lines';
  }

  @override
  String settingsBackupSummaryLineNotifications(int inserted, int skipped) {
    return 'Notifications: $inserted added, $skipped skipped';
  }

  @override
  String get settingsBackupInvalidFile => 'Could not read this backup file.';

  @override
  String get settingsNotificationsFiltersTitle => 'Filters';

  @override
  String get settingsNotifFilterAll => 'All';

  @override
  String get settingsNotifFilterOrders => 'Orders';

  @override
  String get settingsNotifFilterLicense => 'License';

  @override
  String get settingsNotifFilterBackup => 'Backup';

  @override
  String get settingsNotificationsInboxEmpty => 'No notifications yet';

  @override
  String get settingsNotificationsInboxEmptyHint =>
      'History will appear here for order, license, and backup events.';

  @override
  String get settingsNotificationsInboxFilterEmpty =>
      'No notifications match this filter.';

  @override
  String get settingsSyncLastSyncTitle => 'Last successful sync';

  @override
  String get settingsSyncLastSyncNever =>
      'Not synced yet (offline-first; API pending)';

  @override
  String get settingsSyncQueuedTitle => 'Queued local changes';

  @override
  String get settingsSyncQueuedZero => 'None waiting';

  @override
  String settingsSyncQueuedCount(int count) {
    return '$count waiting to sync';
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
      'Pull from the server, then push the local queue when API_BASE_URL is set and you are signed in online.';

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
  String get settingsSyncRetryEditingBlocked =>
      'Sync is paused in read-only mode. Open Subscription when you are online.';

  @override
  String settingsSyncRetrySuccess(int pushed, int pulled) {
    return 'Sync OK: pushed $pushed mutation(s); received $pulled server change(s).';
  }

  @override
  String settingsSyncRetryFailed(String detail) {
    return 'Sync failed: $detail';
  }

  @override
  String get settingsSyncOutboxTitle => 'Outbox';

  @override
  String get settingsSyncOutboxPlaceholderTitle => 'Queued changes';

  @override
  String get settingsSyncOutboxPlaceholderSubtitle =>
      'Retry and details will appear when sync is enabled';

  @override
  String get settingsSyncOutboxPendingListTitle => 'Pending mutations (local)';

  @override
  String get settingsSyncOutboxPendingEmpty => 'Nothing queued for sync.';

  @override
  String get settingsDiagnosticsExportCta => 'Export diagnostics bundle';

  @override
  String get settingsDiagnosticsExportBusy => 'Preparing bundle…';

  @override
  String get settingsDiagnosticsExportSuccess =>
      'Diagnostics bundle ready to share.';

  @override
  String settingsDiagnosticsExportError(String error) {
    return 'Could not export diagnostics: $error';
  }

  @override
  String get settingsSyncDiagnosticsFooter =>
      'Support can ask for this bundle to troubleshoot sync issues.';

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
  String get devPortalTabAccount => 'My password';

  @override
  String get devPortalMyPasswordTitle => 'Change your password';

  @override
  String get devPortalMyPasswordSubtitle =>
      'Username cannot be changed here. Use your current password, then choose a new one (at least 6 characters).';

  @override
  String get devPortalCurrentPasswordLabel => 'Current password';

  @override
  String get devPortalNewPasswordLabel => 'New password';

  @override
  String get devPortalConfirmPasswordLabel => 'Confirm new password';

  @override
  String get devPortalPasswordMismatch =>
      'New password and confirmation do not match.';

  @override
  String get devPortalChangePasswordCta => 'Update password';

  @override
  String get devPortalChangePasswordOk =>
      'Password updated. Use the new password next time you sign in.';

  @override
  String get devPortalChangePasswordFail => 'Could not update password.';

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
      'Connect to the internet to test public API health. Admin lists (shops, codes, resets) need the deployed admin APIs.';

  @override
  String get devPortalAdviceOnlineTitle => 'Developer tools';

  @override
  String get devPortalAdviceOnlineBody =>
      'Use Billing to publish Hesab Pay instructions for all shops. Overview shows API health and stats. Codes, Shops, and Resets need a developer account on the API.';

  @override
  String get devPortalShopsEmpty => 'No shops on the server yet.';

  @override
  String devPortalShopRowUsers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users',
      one: '1 user',
    );
    return '$_temp0';
  }

  @override
  String devPortalShopSignedUp(String date) {
    return 'Signed up: $date';
  }

  @override
  String devPortalShopTrialStarted(String date) {
    return 'Trial started: $date';
  }

  @override
  String get devPortalShopUsersHeader => 'Accounts';

  @override
  String get devPortalShopUserOwnerBadge => 'Owner';

  @override
  String get devPortalShopUserDeletedBadge => 'Removed';

  @override
  String get devPortalShopUserPasswordNote =>
      'Password is stored hashed on the server. Use the Password resets tab to set a new one.';

  @override
  String get devPortalShopDisabledLabel => 'Disabled';

  @override
  String get devPortalShopActionsTooltip => 'Shop actions';

  @override
  String get devPortalShopDisableCta => 'Disable shop';

  @override
  String get devPortalShopEnableCta => 'Enable shop';

  @override
  String get devPortalShopExtendCta => 'Extend license…';

  @override
  String get devPortalShopExtendTitle => 'Extend license';

  @override
  String get devPortalShopExtendHint =>
      'Days to add from today or current expiry (whichever is later).';

  @override
  String get devPortalShopExtendDaysLabel => 'Days';

  @override
  String get devPortalShopActionOk => 'Done.';

  @override
  String get devPortalShopPushTestCta => 'Test push…';

  @override
  String get devPortalShopPushTitle => 'Test push notification';

  @override
  String get devPortalShopPushNotifTitleLabel => 'Notification title';

  @override
  String get devPortalShopPushBodyLabel => 'Message';

  @override
  String devPortalShopPushResult(int success, int failed, String reason) {
    return 'Sent: $success, failed: $failed. Reason: $reason.';
  }

  @override
  String devPortalCodesLoadError(String error) {
    return 'Could not load codes: $error';
  }

  @override
  String get devPortalCodesEmpty =>
      'No activation codes yet. Generate one to issue paid time.';

  @override
  String get devPortalCodesCreateTitle => 'New activation code';

  @override
  String get devPortalCodesPlanDaysLabel => 'Paid days added on redeem';

  @override
  String get devPortalCodesMaxUsesLabel => 'Max redemptions';

  @override
  String get devPortalCodesCreateCta => 'Generate code';

  @override
  String devPortalCodesCreated(String code) {
    return 'Created: $code';
  }

  @override
  String get devPortalCodesCreateFail => 'Could not create code.';

  @override
  String get devPortalCodesRevokeTitle => 'Revoke code';

  @override
  String devPortalCodesRevokeBody(String code) {
    return 'Shops can no longer redeem “$code”.';
  }

  @override
  String get devPortalCodesRevoked => 'Code revoked.';

  @override
  String get devPortalCodesRevokeFail => 'Could not revoke.';

  @override
  String get devPortalCodesRevokeCta => 'Revoke';

  @override
  String get devPortalCodesDetailTitle => 'Activation code';

  @override
  String get devPortalCodesCopyCta => 'Copy code';

  @override
  String get devPortalCodesShareCta => 'Share code';

  @override
  String get devPortalCodesCopied => 'Code copied to clipboard.';

  @override
  String get devPortalCodesShareSubject => 'Afghan Pride activation code';

  @override
  String devPortalCodesShareMessage(String code, int days) {
    return 'Afghan Pride — subscription activation\n\nCode: $code\nPaid days when redeemed: $days\n\nIn the shop app: Settings → Subscription → enter this code.\nSingle-use unless noted otherwise.';
  }

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
  String get devPortalStatActivations => 'Code creates (audit)';

  @override
  String get devPortalApiHealthTitle => 'API health';

  @override
  String get devPortalApiHealthUnknown => 'Unknown — connect to the API';

  @override
  String get devPortalCodesStub =>
      'Activation codes: search, create, and revoke will load from the admin API.';

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
  String get devPortalAdminAuditTitle => 'Admin audit log';

  @override
  String get devPortalAdminAuditNeedSignIn =>
      'Sign in with the API, then pull to refresh.';

  @override
  String devPortalAdminAuditLine(int count, int schema) {
    return 'GET /admin/audit-log — $count row(s), schema v$schema';
  }

  @override
  String get settingsShopProfileTitle => 'Shop profile';

  @override
  String get shopProfileIntro =>
      'Name, logo, address, and thank-you message appear on printed receipts and shared invoices. Notes below are for your own reference only.';

  @override
  String get shopProfileNameLabel => 'Shop name';

  @override
  String get shopProfileNameHint => 'Example: Karzai Tailoring Shop';

  @override
  String get shopProfileNameRequired => 'Shop name is required.';

  @override
  String get shopProfileNameTooShort => 'Shop name is too short.';

  @override
  String get shopProfileShopPhoneLabel => 'Shop phone (optional)';

  @override
  String get shopProfileShopPhoneHint => 'Example: 0701234567';

  @override
  String get shopProfileAddressLabel => 'Address (optional)';

  @override
  String get shopProfileAddressHint => 'Example: Karte Char, Kabul';

  @override
  String get shopProfileReceiptThanksLabel =>
      'Receipt thank-you message (optional)';

  @override
  String get shopProfileReceiptThanksHint =>
      'Example: Thank you for your business!';

  @override
  String get shopProfileNotesLabel => 'Notes (optional)';

  @override
  String get shopProfileNotesHint => 'Hours, landmarks, tax ID…';

  @override
  String get shopProfileSaved => 'Shop profile saved.';

  @override
  String get shopProfileReadOnlyBanner =>
      'License expired — you can view this profile but not edit it.';

  @override
  String get settingsCurrentUserGuest => 'Guest';

  @override
  String settingsShopIdChip(String shopId) {
    return 'Shop $shopId';
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

  @override
  String get settingsSectionPrinter => 'Printer';

  @override
  String get settingsPrinterTileTitle => 'Thermal printer';

  @override
  String get settingsPrinterTileSubtitle =>
      'Network receipt printer (58 / 80 mm)';

  @override
  String get settingsPrinterScreenTitle => 'Thermal printer';

  @override
  String get settingsPrinterIntro =>
      'Send receipts to a network ESC/POS printer (usually raw TCP on port 9100). Enter the printer’s IP address or hostname on your Wi‑Fi or LAN.';

  @override
  String get settingsPrinterAsciiNotice =>
      'Receipts use a simple printer character set. Names or notes outside Latin letters and digits may print as “?” on the slip.';

  @override
  String get settingsPrinterHostLabel => 'Printer address';

  @override
  String get settingsPrinterHostHint => 'Example: 192.168.1.50';

  @override
  String get settingsPrinterPortLabel => 'Port';

  @override
  String get settingsPrinterPaperWidthLabel => 'Paper width';

  @override
  String get settingsPrinterPaper58Label => '58 mm';

  @override
  String get settingsPrinterPaper80Label => '80 mm';

  @override
  String get settingsPrinterSaved => 'Printer settings saved.';

  @override
  String get settingsPrinterTestCta => 'Test print';

  @override
  String get settingsPrinterTestHeadline => 'Afghan Pride';

  @override
  String get settingsPrinterTestDetail =>
      'Test print — if you can read this, the connection works.';

  @override
  String get settingsPrinterTestOk => 'Test page sent to the printer.';

  @override
  String settingsPrinterTestFail(String detail) {
    return 'Test print failed: $detail';
  }

  @override
  String get settingsPrinterWebUnavailable =>
      'Thermal printing is available on the Android and iOS apps. Use a device with the app installed to print; the web app does not send jobs to hardware printers.';

  @override
  String get settingsPrinterHostEmptyError =>
      'Enter the printer address to save or test.';

  @override
  String get settingsPrinterPortInvalidError => 'Enter a valid port (1–65535).';

  @override
  String get orderPrintReceiptTooltip => 'Print receipt';

  @override
  String get orderPrintReceiptNeedPrinter =>
      'Set the printer address under Settings → Thermal printer.';

  @override
  String get orderPrintReceiptOk => 'Receipt sent to the printer.';

  @override
  String orderPrintReceiptFail(String detail) {
    return 'Printing failed: $detail';
  }

  @override
  String get receiptCustomerLabel => 'Customer';

  @override
  String get receiptPhoneLabel => 'Phone';

  @override
  String get receiptDeliveryLabel => 'Delivery';

  @override
  String get receiptStatusLabel => 'Status';

  @override
  String get receiptMeasurementsLabel => 'Measurements';

  @override
  String get receiptStyleLabel => 'Style notes';

  @override
  String get receiptFabricLabel => 'Customer fabric';

  @override
  String get receiptFabricNameLabel => 'Fabric';

  @override
  String get receiptFabricColorLabel => 'Color';

  @override
  String get receiptFabricIdLabel => 'Fabric ID';

  @override
  String get orderDetailFabricTitle => 'Customer fabric';

  @override
  String get receiptInternalNotesHeader => 'Internal notes';

  @override
  String get receiptTotalLabel => 'Total';

  @override
  String get receiptPaidLabel => 'Paid';

  @override
  String get receiptBalanceLabel => 'Balance';

  @override
  String get receiptPaymentsHeader => 'Payments';

  @override
  String get receiptShopPhoneLabel => 'Shop phone';

  @override
  String get receiptShopAddressLabel => 'Address';

  @override
  String get receiptShareDivider => '--------------------------------';

  @override
  String get receiptShareSectionRule => '================================';

  @override
  String get settingsPrinterRetryHint =>
      'If the printer is busy, the app retries the connection a few times automatically.';

  @override
  String get shopProfileLogoSectionTitle => 'Invoice header logo';

  @override
  String get shopProfileLogoSubtitle =>
      'Shown at the top of thermal receipts and shared invoice text (Android / iOS). Square images work best.';

  @override
  String get shopProfileLogoPickCta => 'Choose image';

  @override
  String get shopProfileLogoRemoveCta => 'Remove logo';

  @override
  String get shopProfileLogoSaved => 'Logo saved.';

  @override
  String get shopProfileLogoWebHint =>
      'Logo upload is available in the Android and iOS apps.';

  @override
  String get shopProfileLogoStatusOnFile =>
      'Logo saved on this device for receipts.';

  @override
  String get shopProfileLogoDefaultCaption =>
      'Default logo on receipts until you upload your own.';

  @override
  String get defaultShopName => 'My tailoring shop';

  @override
  String get defaultShopAddress => 'Kabul, Afghanistan';

  @override
  String get defaultShopPhone => '0701234567';

  @override
  String get orderShareInvoiceTooltip => 'Share invoice';

  @override
  String get orderShareInvoicePdfCta => 'Share PDF invoice';

  @override
  String get orderShareContactPermissionDenied =>
      'Contacts permission is off — invoice shared, but the customer was not saved to your phone.';

  @override
  String get orderShareInvoiceSharedSheet =>
      'Choose WhatsApp or another app to send the PDF invoice.';

  @override
  String orderShareInvoiceFail(String detail) {
    return 'Share failed: $detail';
  }

  @override
  String orderShareInvoiceSubject(String orderNo) {
    return 'Order $orderNo';
  }

  @override
  String orderShareInvoiceWhatsappCaption(String orderNo, String customerName) {
    return 'Invoice for order $orderNo — $customerName';
  }

  @override
  String orderShareContactSaved(String name) {
    return 'Saved $name to your phone contacts.';
  }

  @override
  String get orderShareWhatsappOpened => 'Invoice PDF opened in WhatsApp.';

  @override
  String get receiptFooterThanks => 'Thank you for your business!';

  @override
  String get settingsDeveloperPortalCheckFailed =>
      'Could not verify developer access. Tap to retry.';

  @override
  String get settingsDeveloperPortalRetry => 'Retry';

  @override
  String get dashboardSyncRunning => 'Syncing…';

  @override
  String get dashboardSyncTapToRun => 'Tap to sync now';

  @override
  String get dashboardTasksSectionTitle => 'Tasks';

  @override
  String dashboardTasksOpenCount(int count) {
    return '$count open';
  }

  @override
  String get dashboardTasksViewAll => 'View all tasks';

  @override
  String get shopFinanceTitle => 'Shop finance';

  @override
  String get shopFinanceSubtitle => 'Rent, daily costs, and food & drinks';

  @override
  String get shopFinanceOverviewTitle => 'Overview';

  @override
  String get shopFinanceRentTitle => 'Rent';

  @override
  String get shopFinanceExpensesTitle => 'Expenses';

  @override
  String get shopFinanceMonthOutflow => 'This month outflow';

  @override
  String get shopFinanceRentDue => 'Rent due';

  @override
  String get shopFinanceRentPaid => 'Rent paid this month';

  @override
  String get shopFinanceExpenseDaily => 'Daily expenses';

  @override
  String get shopFinanceExpenseFood => 'Food & drinks';

  @override
  String get shopFinanceExpenseOther => 'Other';

  @override
  String get shopFinanceAddRent => 'Set rent';

  @override
  String get shopFinanceRecordRentPayment => 'Record rent payment';

  @override
  String get shopFinanceAddExpense => 'Add expense';

  @override
  String get shopFinanceAmountLabel => 'Amount (AFN)';

  @override
  String get shopFinanceDueDateLabel => 'Due date';

  @override
  String get shopFinancePeriodMonthsLabel => 'Period (months)';

  @override
  String get shopFinanceNoteLabel => 'Note';

  @override
  String get shopFinanceCategoryLabel => 'Category';

  @override
  String get shopFinanceDateLabel => 'Date';

  @override
  String get shopFinanceClearPeriodTitle => 'Clear old expenses?';

  @override
  String get shopFinanceClearPeriodBody =>
      'Expenses before the selected date will be removed from your list.';

  @override
  String get shopFinanceRentDueNotificationTitle => 'Rent due soon';

  @override
  String shopFinanceRentDueNotificationBody(String amount, String date) {
    return 'Rent of $amount is due on $date';
  }

  @override
  String get shopFinanceEmptyRent =>
      'No rent schedule yet. Set your monthly rent.';

  @override
  String get shopFinanceEmptyExpenses => 'No expenses recorded yet.';

  @override
  String get shopFinanceSave => 'Save';

  @override
  String get shopFinanceChartsExpensesByCategory => 'Expenses by category';

  @override
  String get appGuideCloseTooltip => 'Close tip';

  @override
  String get appGuideSkipAll => 'Skip all tips';

  @override
  String get appGuideGotIt => 'Got it';

  @override
  String get appGuideOrdersTitle => 'Orders';

  @override
  String get appGuideOrdersBody =>
      'Create and track tailoring orders. Open an order to change status, payments, and delivery date.';

  @override
  String get appGuideCustomersTitle => 'Customers';

  @override
  String get appGuideCustomersBody =>
      'Save customer names, phone numbers, and measurement profiles for faster new orders.';

  @override
  String get appGuideCatalogTitle => 'Catalog';

  @override
  String get appGuideCatalogBody =>
      'Share design photos with customers using your shop catalog.';

  @override
  String get appGuideReportsTitle => 'Reports';

  @override
  String get appGuideReportsBody =>
      'See income, unpaid orders, and delivery reports for your shop.';

  @override
  String get appGuideSettingsTitle => 'Settings';

  @override
  String get appGuideSettingsBody =>
      'Set shop profile, printers, style library, and subscription here.';

  @override
  String get appGuideDashboardTitle => 'Dashboard';

  @override
  String get appGuideDashboardBody =>
      'Swipe from the left edge (or tap the menu icon) for search, sync, and shortcuts.';
}
