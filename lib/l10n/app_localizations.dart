import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ps.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('fa'),
    Locale('ps'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pride'**
  String get appTitle;

  /// No description provided for @tabOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get tabOrders;

  /// No description provided for @tabCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get tabCustomers;

  /// No description provided for @tabCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get tabCatalog;

  /// No description provided for @tabReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get tabReports;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your shop username and password. The server will verify this when the API is connected (plan-04).'**
  String get loginSubtitle;

  /// No description provided for @loginMockHint.
  ///
  /// In en, this message translates to:
  /// **'In this build, any non-empty username and password will sign you in locally.'**
  String get loginMockHint;

  /// No description provided for @loginShopIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop ID (optional)'**
  String get loginShopIdLabel;

  /// No description provided for @loginShopIdHint.
  ///
  /// In en, this message translates to:
  /// **'Leave blank for single-shop dev'**
  String get loginShopIdHint;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginUsernameLabel;

  /// No description provided for @loginUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Your shop login name'**
  String get loginUsernameHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginSignInCta.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignInCta;

  /// No description provided for @loginFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get loginFieldRequired;

  /// No description provided for @loginDevContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue without account (dev)'**
  String get loginDevContinue;

  /// Placeholder body for a shell tab
  ///
  /// In en, this message translates to:
  /// **'{moduleName} — UI coming soon.'**
  String modulePlaceholder(String moduleName);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'KPIs and shortcuts will load from local data (plan-09).'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardKpisPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Today at a glance'**
  String get dashboardKpisPlaceholder;

  /// No description provided for @dashboardKpiNewOrders.
  ///
  /// In en, this message translates to:
  /// **'New orders'**
  String get dashboardKpiNewOrders;

  /// No description provided for @dashboardKpiInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get dashboardKpiInProgress;

  /// No description provided for @dashboardKpiReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get dashboardKpiReady;

  /// No description provided for @dashboardKpiUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid balance'**
  String get dashboardKpiUnpaid;

  /// No description provided for @dashboardKpiValuePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get dashboardKpiValuePlaceholder;

  /// No description provided for @dashboardOpenMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get dashboardOpenMenuTooltip;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Renew or enter an activation code when billing is connected (plan-06). While expired, editing is limited; viewing lists and details stays available.'**
  String get subscriptionBody;

  /// No description provided for @subscriptionListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'License, trial, and activation'**
  String get subscriptionListTileSubtitle;

  /// No description provided for @licenseDevControlsTitle.
  ///
  /// In en, this message translates to:
  /// **'License (dev only)'**
  String get licenseDevControlsTitle;

  /// No description provided for @licenseStatusTrial.
  ///
  /// In en, this message translates to:
  /// **'Trial'**
  String get licenseStatusTrial;

  /// No description provided for @licenseStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get licenseStatusPaid;

  /// No description provided for @licenseStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get licenseStatusExpired;

  /// No description provided for @ordersNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get ordersNewTitle;

  /// No description provided for @ordersNewCta.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get ordersNewCta;

  /// No description provided for @ordersComposerPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Order composer will go here (plan-11).'**
  String get ordersComposerPlaceholderBody;

  /// No description provided for @ordersDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get ordersDetailTitle;

  /// No description provided for @ordersDetailPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Order {orderId} — details UI coming soon (plan-12).'**
  String ordersDetailPlaceholderBody(String orderId);

  /// No description provided for @orderStatusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get orderStatusNew;

  /// No description provided for @orderStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get orderStatusInProgress;

  /// No description provided for @orderStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get orderStatusReady;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @ordersListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get ordersListEmpty;

  /// No description provided for @ordersDeliveryOn.
  ///
  /// In en, this message translates to:
  /// **'Delivery: {date}'**
  String ordersDeliveryOn(String date);

  /// No description provided for @ordersWebDataHint.
  ///
  /// In en, this message translates to:
  /// **'Web preview uses in-memory sample data (Isar runs on Android/iOS/desktop).'**
  String get ordersWebDataHint;

  /// No description provided for @ordersNumberPrefix.
  ///
  /// In en, this message translates to:
  /// **'No. {number}'**
  String ordersNumberPrefix(String number);

  /// No description provided for @ordersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search order number, customer, or phone'**
  String get ordersSearchHint;

  /// No description provided for @ordersDateChipAny.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get ordersDateChipAny;

  /// No description provided for @ordersDateChipToday.
  ///
  /// In en, this message translates to:
  /// **'Delivery today'**
  String get ordersDateChipToday;

  /// No description provided for @ordersDateChipThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Delivery this week'**
  String get ordersDateChipThisWeek;

  /// No description provided for @ordersDateChipCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get ordersDateChipCustom;

  /// No description provided for @ordersDateCustomPickerHelp.
  ///
  /// In en, this message translates to:
  /// **'Filter by delivery date (inclusive).'**
  String get ordersDateCustomPickerHelp;

  /// No description provided for @ordersCustomerFilterChip.
  ///
  /// In en, this message translates to:
  /// **'Customer: {name}'**
  String ordersCustomerFilterChip(String name);

  /// No description provided for @ordersCustomerFilterUnknown.
  ///
  /// In en, this message translates to:
  /// **'Customer filter on'**
  String get ordersCustomerFilterUnknown;

  /// No description provided for @ordersClearFilterA11y.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get ordersClearFilterA11y;

  /// No description provided for @ordersOnlyUnpaidChip.
  ///
  /// In en, this message translates to:
  /// **'Only unpaid'**
  String get ordersOnlyUnpaidChip;

  /// No description provided for @ordersFilterOverdueChip.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get ordersFilterOverdueChip;

  /// No description provided for @ordersFilterDeliveredTodayChip.
  ///
  /// In en, this message translates to:
  /// **'Delivered today'**
  String get ordersFilterDeliveredTodayChip;

  /// No description provided for @ordersRemainingChip.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {amount}'**
  String ordersRemainingChip(String amount);

  /// No description provided for @ordersFilteredEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders match your search or filters.'**
  String get ordersFilteredEmpty;

  /// No description provided for @ordersDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'This order could not be found.'**
  String get ordersDetailNotFound;

  /// No description provided for @ordersDetailChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get ordersDetailChangeStatus;

  /// No description provided for @ordersDetailChangeStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready / Delivered / Cancel'**
  String get ordersDetailChangeStatusSubtitle;

  /// No description provided for @ordersDetailConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get ordersDetailConfirmTitle;

  /// No description provided for @ordersDetailConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Change status to {status}?'**
  String ordersDetailConfirmBody(String status);

  /// No description provided for @ordersDetailConfirmCta.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get ordersDetailConfirmCta;

  /// No description provided for @ordersDetailStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated: {status}'**
  String ordersDetailStatusUpdated(String status);

  /// No description provided for @ordersDetailSectionCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get ordersDetailSectionCustomer;

  /// No description provided for @ordersDetailSectionMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get ordersDetailSectionMeasurements;

  /// No description provided for @ordersDetailSectionStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get ordersDetailSectionStyle;

  /// No description provided for @ordersDetailSectionInternalNotes.
  ///
  /// In en, this message translates to:
  /// **'Internal notes'**
  String get ordersDetailSectionInternalNotes;

  /// No description provided for @ordersDetailSectionPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get ordersDetailSectionPayments;

  /// No description provided for @ordersDetailSectionAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit'**
  String get ordersDetailSectionAudit;

  /// No description provided for @ordersDetailSectionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Details will appear here as the module is built.'**
  String get ordersDetailSectionPlaceholder;

  /// No description provided for @ordersDetailSnapshotEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded.'**
  String get ordersDetailSnapshotEmpty;

  /// No description provided for @ordersDetailMeasurementsFromProfile.
  ///
  /// In en, this message translates to:
  /// **'Snapshot based on profile “{label}”.'**
  String ordersDetailMeasurementsFromProfile(String label);

  /// No description provided for @ordersDetailMeasurementsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes on order'**
  String get ordersDetailMeasurementsNotes;

  /// No description provided for @ordersDetailLockedHint.
  ///
  /// In en, this message translates to:
  /// **'This order is locked because it is Delivered or Cancelled (plan-12).'**
  String get ordersDetailLockedHint;

  /// No description provided for @ordersDetailLockedStillInternalNotes.
  ///
  /// In en, this message translates to:
  /// **'You can still edit internal notes below.'**
  String get ordersDetailLockedStillInternalNotes;

  /// No description provided for @ordersInternalNotesDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Internal notes'**
  String get ordersInternalNotesDialogTitle;

  /// No description provided for @ordersInternalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Staff-only — not shown to the customer.'**
  String get ordersInternalNotesHint;

  /// No description provided for @ordersInternalNotesSaved.
  ///
  /// In en, this message translates to:
  /// **'Internal notes saved.'**
  String get ordersInternalNotesSaved;

  /// No description provided for @licenseReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Read-only mode: editing is disabled while the license is expired.'**
  String get licenseReadOnlyHint;

  /// No description provided for @ownerPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner password'**
  String get ownerPasswordTitle;

  /// No description provided for @ownerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter owner password'**
  String get ownerPasswordLabel;

  /// No description provided for @ownerPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'That password does not match the owner password for this device.'**
  String get ownerPasswordMismatch;

  /// No description provided for @ordersDetailChangeStatusSoon.
  ///
  /// In en, this message translates to:
  /// **'Status changes will open a confirmation flow (plan-12).'**
  String get ordersDetailChangeStatusSoon;

  /// No description provided for @addPaymentCta.
  ///
  /// In en, this message translates to:
  /// **'Add payment'**
  String get addPaymentCta;

  /// No description provided for @addAdjustmentCta.
  ///
  /// In en, this message translates to:
  /// **'Add adjustment'**
  String get addAdjustmentCta;

  /// No description provided for @paymentAdjustmentHint.
  ///
  /// In en, this message translates to:
  /// **'Use a negative amount to reduce recorded payments (append-only ledger).'**
  String get paymentAdjustmentHint;

  /// No description provided for @paymentLedgerAdjustmentTag.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get paymentLedgerAdjustmentTag;

  /// No description provided for @paymentAdjustmentAdded.
  ///
  /// In en, this message translates to:
  /// **'Adjustment recorded'**
  String get paymentAdjustmentAdded;

  /// No description provided for @paymentAdded.
  ///
  /// In en, this message translates to:
  /// **'Payment added'**
  String get paymentAdded;

  /// No description provided for @paymentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get paymentsEmpty;

  /// No description provided for @paymentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get paymentAmountLabel;

  /// No description provided for @paymentAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount (no decimals)'**
  String get paymentAmountHint;

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount}'**
  String paymentAmount(String amount);

  /// No description provided for @paymentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get paymentTotal;

  /// No description provided for @paymentPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentPaid;

  /// No description provided for @paymentRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get paymentRemaining;

  /// No description provided for @customersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or phone'**
  String get customersSearchHint;

  /// No description provided for @customersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get customersEmptyTitle;

  /// No description provided for @customersAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get customersAddCta;

  /// No description provided for @customersFilteredEmpty.
  ///
  /// In en, this message translates to:
  /// **'No customers match your search.'**
  String get customersFilteredEmpty;

  /// No description provided for @customersPhoneMissing.
  ///
  /// In en, this message translates to:
  /// **'No phone'**
  String get customersPhoneMissing;

  /// No description provided for @customerProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerProfileTitle;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'This customer could not be found.'**
  String get customerNotFound;

  /// No description provided for @customerInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Customer info'**
  String get customerInfoSection;

  /// No description provided for @customerMeasurementProfilesSection.
  ///
  /// In en, this message translates to:
  /// **'Measurement profiles'**
  String get customerMeasurementProfilesSection;

  /// No description provided for @customerTodayOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Today’s orders'**
  String get customerTodayOrdersTitle;

  /// No description provided for @customerNoTodayOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders for today.'**
  String get customerNoTodayOrders;

  /// No description provided for @customerViewAllOrders.
  ///
  /// In en, this message translates to:
  /// **'View all orders for this customer'**
  String get customerViewAllOrders;

  /// No description provided for @customerViewAllOrdersSoon.
  ///
  /// In en, this message translates to:
  /// **'This will open Orders with a customer filter (plan-13).'**
  String get customerViewAllOrdersSoon;

  /// No description provided for @customerSectionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Details will appear here as the module is built.'**
  String get customerSectionPlaceholder;

  /// No description provided for @customerNewPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'New customer form will go here (plan-13).'**
  String get customerNewPlaceholderBody;

  /// No description provided for @measurementUnitCm.
  ///
  /// In en, this message translates to:
  /// **'Centimeters'**
  String get measurementUnitCm;

  /// No description provided for @measurementUnitInch.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get measurementUnitInch;

  /// No description provided for @measurementProfilesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved profiles yet. Add one to reuse measurements on new orders.'**
  String get measurementProfilesEmpty;

  /// No description provided for @measurementProfilesAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add profile'**
  String get measurementProfilesAddCta;

  /// No description provided for @measurementProfileEditorTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New measurement profile'**
  String get measurementProfileEditorTitleNew;

  /// No description provided for @measurementProfileEditorTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit measurement profile'**
  String get measurementProfileEditorTitleEdit;

  /// No description provided for @measurementProfileLabelField.
  ///
  /// In en, this message translates to:
  /// **'Profile name'**
  String get measurementProfileLabelField;

  /// No description provided for @measurementProfileBodyField.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurementProfileBodyField;

  /// No description provided for @measurementProfileNotesField.
  ///
  /// In en, this message translates to:
  /// **'Extra notes'**
  String get measurementProfileNotesField;

  /// No description provided for @measurementProfileUnitSection.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get measurementProfileUnitSection;

  /// No description provided for @measurementProfileSaveAsNew.
  ///
  /// In en, this message translates to:
  /// **'Save as new profile'**
  String get measurementProfileSaveAsNew;

  /// No description provided for @measurementProfileCreated.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get measurementProfileCreated;

  /// No description provided for @measurementProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get measurementProfileUpdated;

  /// No description provided for @measurementProfilePickSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved profiles'**
  String get measurementProfilePickSheetTitle;

  /// No description provided for @settingsMeasurementTypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurement fields'**
  String get settingsMeasurementTypesTitle;

  /// No description provided for @settingsMeasurementTypesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Labels for customer profiles and orders'**
  String get settingsMeasurementTypesSubtitle;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @tasksSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Simple to-do list (offline)'**
  String get tasksSettingsSubtitle;

  /// No description provided for @tasksSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tasks'**
  String get tasksSearchHint;

  /// No description provided for @tasksFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tasksFilterAll;

  /// No description provided for @tasksFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get tasksFilterOpen;

  /// No description provided for @tasksFilterDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tasksFilterDone;

  /// No description provided for @tasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet. Add your first task.'**
  String get tasksEmpty;

  /// No description provided for @tasksEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'No tasks match this filter.'**
  String get tasksEmptyFiltered;

  /// No description provided for @tasksAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get tasksAddTitle;

  /// No description provided for @tasksEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get tasksEditTitle;

  /// No description provided for @tasksTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tasksTitleLabel;

  /// No description provided for @tasksNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tasksNotesLabel;

  /// No description provided for @tasksDueDatePick.
  ///
  /// In en, this message translates to:
  /// **'Pick due date'**
  String get tasksDueDatePick;

  /// No description provided for @tasksDueDateNone.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get tasksDueDateNone;

  /// No description provided for @tasksDueDateSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get tasksDueDateSet;

  /// No description provided for @tasksDueDateClear.
  ///
  /// In en, this message translates to:
  /// **'Clear due date'**
  String get tasksDueDateClear;

  /// No description provided for @tasksDueDateShort.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String tasksDueDateShort(String date);

  /// No description provided for @tasksDueDateValue.
  ///
  /// In en, this message translates to:
  /// **'Due date: {date}'**
  String tasksDueDateValue(String date);

  /// No description provided for @tasksSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get tasksSave;

  /// No description provided for @tasksDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tasksDeleteAction;

  /// No description provided for @tasksDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete task?'**
  String get tasksDeleteTitle;

  /// No description provided for @tasksDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove the task from your list.'**
  String get tasksDeleteBody;

  /// No description provided for @tasksDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tasksDeleteCancel;

  /// No description provided for @tasksDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tasksDeleteConfirm;

  /// No description provided for @measurementTypesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurement fields'**
  String get measurementTypesScreenTitle;

  /// No description provided for @measurementTypesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fields yet. Add the sizes your shop records.'**
  String get measurementTypesEmpty;

  /// No description provided for @measurementTypesAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add field'**
  String get measurementTypesAddCta;

  /// No description provided for @measurementTypesFieldNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Field name'**
  String get measurementTypesFieldNameLabel;

  /// No description provided for @measurementTypesRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename field'**
  String get measurementTypesRenameTitle;

  /// No description provided for @measurementTypesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove field?'**
  String get measurementTypesDeleteTitle;

  /// No description provided for @measurementTypesDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The field is hidden for new measurements. Values already saved on profiles and orders stay as they are.'**
  String get measurementTypesDeleteBody;

  /// No description provided for @measurementTypesActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get measurementTypesActiveLabel;

  /// No description provided for @measurementTypesInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get measurementTypesInactiveLabel;

  /// No description provided for @measurementTypesReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get measurementTypesReorderHint;

  /// No description provided for @measurementTypesCreated.
  ///
  /// In en, this message translates to:
  /// **'Field added'**
  String get measurementTypesCreated;

  /// No description provided for @measurementTypesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Field updated'**
  String get measurementTypesUpdated;

  /// No description provided for @measurementTypesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Field removed'**
  String get measurementTypesDeleted;

  /// No description provided for @reportsOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsOverviewTitle;

  /// No description provided for @reportsUnpaidCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get reportsUnpaidCardTitle;

  /// No description provided for @reportsUnpaidCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total remaining: {amount}'**
  String reportsUnpaidCardSubtitle(String amount);

  /// No description provided for @reportsMonthlyIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly income'**
  String get reportsMonthlyIncomeTitle;

  /// No description provided for @reportsMonthlyIncomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payments and balances by calendar month'**
  String get reportsMonthlyIncomeSubtitle;

  /// No description provided for @reportsThisMonthOpenUnpaidTitle.
  ///
  /// In en, this message translates to:
  /// **'Open orders unpaid'**
  String get reportsThisMonthOpenUnpaidTitle;

  /// No description provided for @reportsThisMonthOpenUnpaidSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New / in progress / ready: {amount}'**
  String reportsThisMonthOpenUnpaidSubtitle(String amount);

  /// No description provided for @reportsOrdersSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders by status'**
  String get reportsOrdersSummaryTitle;

  /// No description provided for @reportsOrdersSummaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet.'**
  String get reportsOrdersSummaryEmpty;

  /// No description provided for @reportsDeliveredReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get reportsDeliveredReportTitle;

  /// No description provided for @reportsDeliveredCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivered orders'**
  String get reportsDeliveredCardTitle;

  /// No description provided for @reportsDeliveredCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'By delivery month'**
  String get reportsDeliveredCardSubtitle;

  /// No description provided for @reportsDeliveredEmpty.
  ///
  /// In en, this message translates to:
  /// **'No delivered orders in this month.'**
  String get reportsDeliveredEmpty;

  /// No description provided for @reportsPaymentsLedgerTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments ledger'**
  String get reportsPaymentsLedgerTitle;

  /// No description provided for @reportsPaymentsLedgerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'List payments by date range'**
  String get reportsPaymentsLedgerSubtitle;

  /// No description provided for @reportsPaymentsPickRange.
  ///
  /// In en, this message translates to:
  /// **'Pick date range'**
  String get reportsPaymentsPickRange;

  /// No description provided for @reportsPaymentsApplyRange.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get reportsPaymentsApplyRange;

  /// No description provided for @reportsPaymentsSelectedRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected range'**
  String get reportsPaymentsSelectedRangeLabel;

  /// No description provided for @reportsPaymentsRangeValue.
  ///
  /// In en, this message translates to:
  /// **'{from} → {to}'**
  String reportsPaymentsRangeValue(String from, String to);

  /// No description provided for @reportsPaymentsTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get reportsPaymentsTotalLabel;

  /// No description provided for @reportsPaymentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments in this date range.'**
  String get reportsPaymentsEmpty;

  /// No description provided for @reportsPaymentsUnknownOrder.
  ///
  /// In en, this message translates to:
  /// **'Unknown order'**
  String get reportsPaymentsUnknownOrder;

  /// No description provided for @reportsPaymentsAdjustmentChip.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get reportsPaymentsAdjustmentChip;

  /// No description provided for @reportsMonthlyIncomePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Monthly income report will go here (plan-16).'**
  String get reportsMonthlyIncomePlaceholder;

  /// No description provided for @reportsThisMonthIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'This month income'**
  String get reportsThisMonthIncomeTitle;

  /// No description provided for @reportsThisMonthIncomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Income: {amount}'**
  String reportsThisMonthIncomeSubtitle(String amount);

  /// No description provided for @reportsMonthlyIncomeCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Payments received'**
  String get reportsMonthlyIncomeCardLabel;

  /// No description provided for @reportsMonthlyUnpaidDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Unpaid (due this month)'**
  String get reportsMonthlyUnpaidDueTitle;

  /// No description provided for @reportsMonthlyUnpaidDueBody.
  ///
  /// In en, this message translates to:
  /// **'Sum of remaining balances on orders with a delivery date in this month.'**
  String get reportsMonthlyUnpaidDueBody;

  /// No description provided for @reportsPrevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get reportsPrevMonth;

  /// No description provided for @reportsNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get reportsNextMonth;

  /// No description provided for @reportsUnpaidTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total remaining'**
  String get reportsUnpaidTotalLabel;

  /// No description provided for @reportsUnpaidEmpty.
  ///
  /// In en, this message translates to:
  /// **'No unpaid orders.'**
  String get reportsUnpaidEmpty;

  /// No description provided for @reportsUnpaidFilteredEmpty.
  ///
  /// In en, this message translates to:
  /// **'No unpaid orders match this filter.'**
  String get reportsUnpaidFilteredEmpty;

  /// No description provided for @reportsUnpaidFilterSection.
  ///
  /// In en, this message translates to:
  /// **'Delivery window'**
  String get reportsUnpaidFilterSection;

  /// No description provided for @reportsUnpaidFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reportsUnpaidFilterAll;

  /// No description provided for @reportsUnpaidFilterOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get reportsUnpaidFilterOverdue;

  /// No description provided for @reportsUnpaidFilterDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due in 7 days'**
  String get reportsUnpaidFilterDueSoon;

  /// No description provided for @reportsUnpaidSortSection.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get reportsUnpaidSortSection;

  /// No description provided for @reportsUnpaidSortAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get reportsUnpaidSortAmount;

  /// No description provided for @reportsUnpaidSortDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get reportsUnpaidSortDueDate;

  /// No description provided for @reportsMonthlyCompareToggle.
  ///
  /// In en, this message translates to:
  /// **'Compare to previous month'**
  String get reportsMonthlyCompareToggle;

  /// No description provided for @reportsMonthlyPreviousPaymentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Previous month (payments)'**
  String get reportsMonthlyPreviousPaymentsLabel;

  /// No description provided for @reportsMonthlyDeltaLabel.
  ///
  /// In en, this message translates to:
  /// **'Change from previous month'**
  String get reportsMonthlyDeltaLabel;

  /// No description provided for @reportsMonthlyDeltaSame.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get reportsMonthlyDeltaSame;

  /// No description provided for @reportsRemainingChip.
  ///
  /// In en, this message translates to:
  /// **'{amount} remaining'**
  String reportsRemainingChip(String amount);

  /// No description provided for @catalogMyDesigns.
  ///
  /// In en, this message translates to:
  /// **'My designs'**
  String get catalogMyDesigns;

  /// No description provided for @catalogSharedDesigns.
  ///
  /// In en, this message translates to:
  /// **'Shared designs'**
  String get catalogSharedDesigns;

  /// No description provided for @catalogGridView.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get catalogGridView;

  /// No description provided for @catalogListView.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get catalogListView;

  /// No description provided for @catalogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search design or shop name'**
  String get catalogSearchHint;

  /// No description provided for @catalogSortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get catalogSortTooltip;

  /// No description provided for @catalogSortSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort designs'**
  String get catalogSortSheetTitle;

  /// No description provided for @catalogSortSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get catalogSortSectionTitle;

  /// No description provided for @catalogSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get catalogSortNewest;

  /// No description provided for @catalogSortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get catalogSortOldest;

  /// No description provided for @catalogSortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get catalogSortNameAsc;

  /// No description provided for @catalogSortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name Z–A'**
  String get catalogSortNameDesc;

  /// No description provided for @catalogResetSort.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get catalogResetSort;

  /// No description provided for @catalogApplySort.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get catalogApplySort;

  /// No description provided for @catalogSharedDirectoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No shared listings in the directory yet.'**
  String get catalogSharedDirectoryEmpty;

  /// No description provided for @catalogCommunityReadOnlyBanner.
  ///
  /// In en, this message translates to:
  /// **'Shared directory entry — view only. You cannot edit or delete another shop’s listing.'**
  String get catalogCommunityReadOnlyBanner;

  /// No description provided for @catalogSharingToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable catalog sharing'**
  String get catalogSharingToggleTitle;

  /// No description provided for @catalogSharingToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mutual opt-in: enable to browse and be listed in public directory (plan-14).'**
  String get catalogSharingToggleSubtitle;

  /// No description provided for @catalogSharedPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Shared designs directory will appear here when online (plan-14).'**
  String get catalogSharedPlaceholder;

  /// No description provided for @catalogEmptyMyDesigns.
  ///
  /// In en, this message translates to:
  /// **'No designs yet.'**
  String get catalogEmptyMyDesigns;

  /// No description provided for @catalogAddDesignCta.
  ///
  /// In en, this message translates to:
  /// **'Add design'**
  String get catalogAddDesignCta;

  /// No description provided for @catalogAddDesignPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Camera / Gallery add will be implemented on Android/iOS only (plan-14).'**
  String get catalogAddDesignPlaceholder;

  /// No description provided for @catalogDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog item'**
  String get catalogDetailTitle;

  /// No description provided for @catalogDetailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Catalog item {id} — detail screen coming soon.'**
  String catalogDetailPlaceholder(String id);

  /// No description provided for @settingsSectionAccountAndShop.
  ///
  /// In en, this message translates to:
  /// **'Account & shop'**
  String get settingsSectionAccountAndShop;

  /// No description provided for @settingsSectionUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get settingsSectionUsers;

  /// No description provided for @settingsSectionBackupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsSectionBackupRestore;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsSectionSyncDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Sync & diagnostics'**
  String get settingsSectionSyncDiagnostics;

  /// No description provided for @settingsSectionAppearanceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Appearance & language'**
  String get settingsSectionAppearanceLanguage;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsSectionDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsSectionDeveloper;

  /// No description provided for @settingsShopTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get settingsShopTileTitle;

  /// No description provided for @settingsShopTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shop details will appear here (plan-15).'**
  String get settingsShopTileSubtitle;

  /// No description provided for @settingsCurrentUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Current user'**
  String get settingsCurrentUserTitle;

  /// No description provided for @settingsSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOutTitle;

  /// No description provided for @settingsSignOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'End this session on this device'**
  String get settingsSignOutSubtitle;

  /// No description provided for @settingsSignOutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get settingsSignOutDialogTitle;

  /// No description provided for @settingsSignOutDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to continue.'**
  String get settingsSignOutDialogBody;

  /// No description provided for @settingsSignOutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsSignOutCancel;

  /// No description provided for @settingsSignOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOutConfirm;

  /// No description provided for @settingsRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get settingsRoleOwner;

  /// No description provided for @settingsRoleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get settingsRoleUser;

  /// No description provided for @settingsOwnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Owner only'**
  String get settingsOwnerOnly;

  /// No description provided for @settingsUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage users'**
  String get settingsUsersTitle;

  /// No description provided for @settingsUsersSubtitleOwner.
  ///
  /// In en, this message translates to:
  /// **'Trial: 2 users • Paid: 5 users'**
  String get settingsUsersSubtitleOwner;

  /// No description provided for @settingsUsersPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Users management will be implemented in plan-15 (create/remove users, limits, owner protections).'**
  String get settingsUsersPlaceholder;

  /// No description provided for @settingsBackupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackupRestoreTitle;

  /// No description provided for @settingsBackupRestoreSubtitleOwner.
  ///
  /// In en, this message translates to:
  /// **'Export and restore shop data safely'**
  String get settingsBackupRestoreSubtitleOwner;

  /// No description provided for @settingsBackupRestorePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Backup/restore will be implemented in plan-15 (merge restore, owner password confirmation, restore summary).'**
  String get settingsBackupRestorePlaceholder;

  /// No description provided for @settingsMuteNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Mute notifications'**
  String get settingsMuteNotificationsTitle;

  /// No description provided for @settingsMuteNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Silence in-app banners and badges (history is kept).'**
  String get settingsMuteNotificationsSubtitle;

  /// No description provided for @settingsNotificationsInboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications inbox'**
  String get settingsNotificationsInboxTitle;

  /// No description provided for @settingsNotificationsInboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'History and filters (plan-15).'**
  String get settingsNotificationsInboxSubtitle;

  /// No description provided for @settingsNotificationsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Notifications inbox will be implemented in plan-15.'**
  String get settingsNotificationsPlaceholder;

  /// No description provided for @settingsSyncDiagnosticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync & diagnostics'**
  String get settingsSyncDiagnosticsTitle;

  /// No description provided for @settingsNetworkStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get settingsNetworkStatusTitle;

  /// No description provided for @settingsNetworkStatusOnline.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get settingsNetworkStatusOnline;

  /// No description provided for @settingsNetworkStatusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline — working locally'**
  String get settingsNetworkStatusOffline;

  /// No description provided for @settingsSyncDiagnosticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last sync, queue, outbox (plan-15).'**
  String get settingsSyncDiagnosticsSubtitle;

  /// No description provided for @settingsSyncDiagnosticsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Sync & diagnostics will be implemented in plan-15.'**
  String get settingsSyncDiagnosticsPlaceholder;

  /// No description provided for @settingsAppearanceLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance & language'**
  String get settingsAppearanceLanguageTitle;

  /// No description provided for @settingsAppearanceLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme and language'**
  String get settingsAppearanceLanguageSubtitle;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutTitle;

  /// No description provided for @settingsAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App info and version'**
  String get settingsAboutSubtitle;

  /// No description provided for @settingsVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersionTitle;

  /// No description provided for @settingsBuildTitle.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get settingsBuildTitle;

  /// No description provided for @settingsDeveloperPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer Portal'**
  String get settingsDeveloperPortalTitle;

  /// No description provided for @settingsDeveloperPortalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced tools (developer accounts only).'**
  String get settingsDeveloperPortalSubtitle;

  /// No description provided for @settingsDeveloperPortalPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Developer Portal screens will be implemented in plan-18.'**
  String get settingsDeveloperPortalPlaceholder;

  /// No description provided for @settingsDevRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Dev role toggles'**
  String get settingsDevRolesTitle;

  /// No description provided for @settingsDevRoleOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Simulate owner account'**
  String get settingsDevRoleOwnerTitle;

  /// No description provided for @settingsDevRoleOwnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows owner-only sections unlocked.'**
  String get settingsDevRoleOwnerSubtitle;

  /// No description provided for @settingsDevRoleDeveloperTitle.
  ///
  /// In en, this message translates to:
  /// **'Simulate developer account'**
  String get settingsDevRoleDeveloperTitle;

  /// No description provided for @settingsDevRoleDeveloperSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shows Developer Portal entry.'**
  String get settingsDevRoleDeveloperSubtitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageDari.
  ///
  /// In en, this message translates to:
  /// **'Dari'**
  String get languageDari;

  /// No description provided for @languagePashto.
  ///
  /// In en, this message translates to:
  /// **'Pashto'**
  String get languagePashto;

  /// No description provided for @settingsDateCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Date calendar'**
  String get settingsDateCalendarTitle;

  /// No description provided for @settingsDateCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How dates are shown and picked in the app'**
  String get settingsDateCalendarSubtitle;

  /// No description provided for @dateCalendarGregorian.
  ///
  /// In en, this message translates to:
  /// **'Gregorian (AD)'**
  String get dateCalendarGregorian;

  /// No description provided for @dateCalendarSolarHijri.
  ///
  /// In en, this message translates to:
  /// **'Solar Hijri (Afghan)'**
  String get dateCalendarSolarHijri;

  /// No description provided for @calendarMonthHamal.
  ///
  /// In en, this message translates to:
  /// **'حمل'**
  String get calendarMonthHamal;

  /// No description provided for @calendarMonthSawr.
  ///
  /// In en, this message translates to:
  /// **'ثور'**
  String get calendarMonthSawr;

  /// No description provided for @calendarMonthJawza.
  ///
  /// In en, this message translates to:
  /// **'جوزا'**
  String get calendarMonthJawza;

  /// No description provided for @calendarMonthSaratan.
  ///
  /// In en, this message translates to:
  /// **'سرطان'**
  String get calendarMonthSaratan;

  /// No description provided for @calendarMonthAsad.
  ///
  /// In en, this message translates to:
  /// **'اسد'**
  String get calendarMonthAsad;

  /// No description provided for @calendarMonthSonbola.
  ///
  /// In en, this message translates to:
  /// **'سنبله'**
  String get calendarMonthSonbola;

  /// No description provided for @calendarMonthMizan.
  ///
  /// In en, this message translates to:
  /// **'میزان'**
  String get calendarMonthMizan;

  /// No description provided for @calendarMonthAqrab.
  ///
  /// In en, this message translates to:
  /// **'عقرب'**
  String get calendarMonthAqrab;

  /// No description provided for @calendarMonthQaws.
  ///
  /// In en, this message translates to:
  /// **'قوس'**
  String get calendarMonthQaws;

  /// No description provided for @calendarMonthJadi.
  ///
  /// In en, this message translates to:
  /// **'جدی'**
  String get calendarMonthJadi;

  /// No description provided for @calendarMonthDalw.
  ///
  /// In en, this message translates to:
  /// **'دلو'**
  String get calendarMonthDalw;

  /// No description provided for @calendarMonthHut.
  ///
  /// In en, this message translates to:
  /// **'حوت'**
  String get calendarMonthHut;

  /// No description provided for @datePickerSolarHijriTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose date (Solar Hijri)'**
  String get datePickerSolarHijriTitle;

  /// No description provided for @datePickerSolarHijriRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose date range (Solar Hijri)'**
  String get datePickerSolarHijriRangeTitle;

  /// No description provided for @datePickerYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get datePickerYearLabel;

  /// No description provided for @datePickerMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get datePickerMonthLabel;

  /// No description provided for @datePickerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get datePickerDayLabel;

  /// No description provided for @dateRangeFromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get dateRangeFromLabel;

  /// No description provided for @dateRangeToLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get dateRangeToLabel;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon.'**
  String get settingsComingSoon;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get genericError;

  /// No description provided for @resetCta.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetCta;

  /// No description provided for @licenseExpiredReadOnly.
  ///
  /// In en, this message translates to:
  /// **'License expired — read-only mode.'**
  String get licenseExpiredReadOnly;

  /// No description provided for @moneyAfn.
  ///
  /// In en, this message translates to:
  /// **'{amount} AFN'**
  String moneyAfn(String amount);

  /// No description provided for @ordersComposerCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get ordersComposerCustomerTitle;

  /// No description provided for @ordersComposerCustomerRequired.
  ///
  /// In en, this message translates to:
  /// **'Select customer (required)'**
  String get ordersComposerCustomerRequired;

  /// No description provided for @ordersComposerMeasurementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get ordersComposerMeasurementsTitle;

  /// No description provided for @ordersComposerMeasurementsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add measurements (required)'**
  String get ordersComposerMeasurementsRequired;

  /// No description provided for @ordersComposerMeasurementsSummary.
  ///
  /// In en, this message translates to:
  /// **'Measurements captured'**
  String get ordersComposerMeasurementsSummary;

  /// No description provided for @ordersComposerMeasurementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurements notes'**
  String get ordersComposerMeasurementsLabel;

  /// No description provided for @ordersComposerMeasurementsHint.
  ///
  /// In en, this message translates to:
  /// **'Type measurements or load a saved customer profile.'**
  String get ordersComposerMeasurementsHint;

  /// No description provided for @ordersComposerLoadProfileCta.
  ///
  /// In en, this message translates to:
  /// **'Load from saved profile'**
  String get ordersComposerLoadProfileCta;

  /// No description provided for @ordersComposerProfileLinked.
  ///
  /// In en, this message translates to:
  /// **'From profile: {name}'**
  String ordersComposerProfileLinked(String name);

  /// No description provided for @ordersComposerStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get ordersComposerStyleTitle;

  /// No description provided for @ordersComposerStyleRequired.
  ///
  /// In en, this message translates to:
  /// **'Select style (required)'**
  String get ordersComposerStyleRequired;

  /// No description provided for @ordersComposerStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Design / style'**
  String get ordersComposerStyleLabel;

  /// No description provided for @ordersComposerStyleHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Karzai, collar, pockets…'**
  String get ordersComposerStyleHint;

  /// No description provided for @ordersComposerPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get ordersComposerPaymentTitle;

  /// No description provided for @ordersComposerPaymentRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter totals (required)'**
  String get ordersComposerPaymentRequired;

  /// No description provided for @ordersComposerPaymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Total {total} • Paid {paid} • Remaining {remaining}'**
  String ordersComposerPaymentSummary(
    String total,
    String paid,
    String remaining,
  );

  /// No description provided for @ordersComposerTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total amount (AFN)'**
  String get ordersComposerTotalLabel;

  /// No description provided for @ordersComposerTotalHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 150000'**
  String get ordersComposerTotalHint;

  /// No description provided for @ordersComposerPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial paid (AFN)'**
  String get ordersComposerPaidLabel;

  /// No description provided for @ordersComposerPaidHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 50000'**
  String get ordersComposerPaidHint;

  /// No description provided for @ordersComposerDeliveryDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get ordersComposerDeliveryDateTitle;

  /// No description provided for @ordersComposerDeliveryDateUnset.
  ///
  /// In en, this message translates to:
  /// **'Select delivery date'**
  String get ordersComposerDeliveryDateUnset;

  /// No description provided for @ordersComposerSaveCta.
  ///
  /// In en, this message translates to:
  /// **'Save order'**
  String get ordersComposerSaveCta;

  /// No description provided for @ordersComposerSaved.
  ///
  /// In en, this message translates to:
  /// **'Order saved.'**
  String get ordersComposerSaved;

  /// No description provided for @ordersComposerResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset form?'**
  String get ordersComposerResetTitle;

  /// No description provided for @ordersComposerResetBody.
  ///
  /// In en, this message translates to:
  /// **'This will clear all entered fields.'**
  String get ordersComposerResetBody;

  /// No description provided for @ordersComposerSelectCustomerFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Select customer first'**
  String get ordersComposerSelectCustomerFirstTitle;

  /// No description provided for @ordersComposerSelectCustomerFirstBody.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer before continuing.'**
  String get ordersComposerSelectCustomerFirstBody;

  /// No description provided for @ordersComposerRecentOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get ordersComposerRecentOrdersTitle;

  /// No description provided for @ordersComposerRecentOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For this customer'**
  String get ordersComposerRecentOrdersSubtitle;

  /// No description provided for @ordersComposerRecentOrderRowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{date} • {remaining} remaining'**
  String ordersComposerRecentOrderRowSubtitle(String date, String remaining);

  /// No description provided for @saveCta.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveCta;

  /// No description provided for @customersCreated.
  ///
  /// In en, this message translates to:
  /// **'Customer created.'**
  String get customersCreated;

  /// No description provided for @customerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get customerNameLabel;

  /// No description provided for @customerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Ahmad Karimi'**
  String get customerNameHint;

  /// No description provided for @customerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get customerNameRequired;

  /// No description provided for @customerNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name is too short.'**
  String get customerNameTooShort;

  /// No description provided for @customerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get customerPhoneLabel;

  /// No description provided for @customerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 0700000001'**
  String get customerPhoneHint;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get saved;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted.'**
  String get deleted;

  /// No description provided for @editCta.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editCta;

  /// No description provided for @deleteCta.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteCta;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmBody;

  /// No description provided for @catalogItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'This catalog item could not be found.'**
  String get catalogItemNotFound;

  /// No description provided for @catalogEditMetadataTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit metadata'**
  String get catalogEditMetadataTitle;

  /// No description provided for @catalogDesignNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Design name'**
  String get catalogDesignNameLabel;

  /// No description provided for @catalogDesignNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Karzai suit'**
  String get catalogDesignNameHint;

  /// No description provided for @catalogNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get catalogNotesLabel;

  /// No description provided for @catalogNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Any details you want to remember…'**
  String get catalogNotesHint;

  /// No description provided for @catalogDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String catalogDeleteConfirmBody(String name);

  /// No description provided for @catalogDesignerAndDate.
  ///
  /// In en, this message translates to:
  /// **'{shop} • {date}'**
  String catalogDesignerAndDate(String shop, String date);

  /// No description provided for @catalogSharePublicTitle.
  ///
  /// In en, this message translates to:
  /// **'Share publicly'**
  String get catalogSharePublicTitle;

  /// No description provided for @catalogSharePublicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If enabled, this design can appear in the public directory (metadata only).'**
  String get catalogSharePublicSubtitle;

  /// No description provided for @catalogSharePublicDisabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable catalog sharing in Catalog to use this.'**
  String get catalogSharePublicDisabledSubtitle;

  /// No description provided for @catalogNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get catalogNotesTitle;

  /// No description provided for @catalogNotesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get catalogNotesEmpty;

  /// No description provided for @catalogAddNotAvailableOnWeb.
  ///
  /// In en, this message translates to:
  /// **'Adding images is not available on Web.'**
  String get catalogAddNotAvailableOnWeb;

  /// No description provided for @catalogDesignNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Design name is required.'**
  String get catalogDesignNameRequired;

  /// No description provided for @catalogImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please pick an image first.'**
  String get catalogImageRequired;

  /// No description provided for @catalogCreated.
  ///
  /// In en, this message translates to:
  /// **'Design added.'**
  String get catalogCreated;

  /// No description provided for @catalogMyShopNameFallback.
  ///
  /// In en, this message translates to:
  /// **'My Shop'**
  String get catalogMyShopNameFallback;

  /// No description provided for @cameraCta.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraCta;

  /// No description provided for @galleryCta.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryCta;

  /// No description provided for @dashboardKpisSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'At a glance'**
  String get dashboardKpisSectionTitle;

  /// No description provided for @dashboardQuickLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick links'**
  String get dashboardQuickLinksTitle;

  /// No description provided for @dashboardThisMonthIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'This month income'**
  String get dashboardThisMonthIncomeTitle;

  /// No description provided for @dashboardLicenseExpiredBanner.
  ///
  /// In en, this message translates to:
  /// **'Your license is expired. Renew to edit again.'**
  String get dashboardLicenseExpiredBanner;

  /// No description provided for @dashboardTodayDeliveriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivered today'**
  String get dashboardTodayDeliveriesTitle;

  /// No description provided for @dashboardTodayDeliveriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders delivered today.'**
  String get dashboardTodayDeliveriesEmpty;

  /// No description provided for @dashboardSearchOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'Search order #, customer, phone'**
  String get dashboardSearchOrdersHint;

  /// No description provided for @dashboardSearchOrdersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search orders'**
  String get dashboardSearchOrdersTooltip;

  /// No description provided for @dashboardOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue deliveries'**
  String get dashboardOverdueTitle;

  /// No description provided for @dashboardOverdueEmpty.
  ///
  /// In en, this message translates to:
  /// **'No overdue open orders.'**
  String get dashboardOverdueEmpty;

  /// No description provided for @dashboardOverdueViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all overdue'**
  String get dashboardOverdueViewAll;

  /// No description provided for @dashboardQuickLinkOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue orders'**
  String get dashboardQuickLinkOverdue;

  /// No description provided for @dashboardQuickLinkDeliveredToday.
  ///
  /// In en, this message translates to:
  /// **'Delivered today'**
  String get dashboardQuickLinkDeliveredToday;

  /// No description provided for @shellAppBarSyncA11y.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get shellAppBarSyncA11y;

  /// No description provided for @shellAppBarNotificationsA11y.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get shellAppBarNotificationsA11y;

  /// No description provided for @shellAppBarNotificationsMutedA11y.
  ///
  /// In en, this message translates to:
  /// **'Notifications (muted)'**
  String get shellAppBarNotificationsMutedA11y;

  /// No description provided for @shellSyncStatusOfflineChip.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get shellSyncStatusOfflineChip;

  /// No description provided for @shellSyncTooltipNever.
  ///
  /// In en, this message translates to:
  /// **'Server sync is not connected yet. Your data stays on this device.'**
  String get shellSyncTooltipNever;

  /// No description provided for @shellSyncTooltipOffline.
  ///
  /// In en, this message translates to:
  /// **'No network. You can keep working; changes stay on this device.'**
  String get shellSyncTooltipOffline;

  /// No description provided for @shellSyncTooltipLast.
  ///
  /// In en, this message translates to:
  /// **'Last successful sync: {when}'**
  String shellSyncTooltipLast(String when);

  /// No description provided for @dashboardNotificationsPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent notifications'**
  String get dashboardNotificationsPreviewTitle;

  /// No description provided for @dashboardNotificationsPreviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get dashboardNotificationsPreviewEmpty;

  /// No description provided for @dashboardNotificationsMutedHint.
  ///
  /// In en, this message translates to:
  /// **'Notifications are muted. Change this in Settings → Notifications.'**
  String get dashboardNotificationsMutedHint;

  /// No description provided for @dashboardNotificationsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all notifications'**
  String get dashboardNotificationsViewAll;

  /// No description provided for @notifSeedWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Afghan Pride'**
  String get notifSeedWelcomeTitle;

  /// No description provided for @notifSeedWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Order updates and shop notices will appear here. Open any row to mark it read.'**
  String get notifSeedWelcomeBody;

  /// No description provided for @notifOrderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Order {orderNo}'**
  String notifOrderStatusTitle(String orderNo);

  /// No description provided for @notifOrderStatusBody.
  ///
  /// In en, this message translates to:
  /// **'Status updated to {status}.'**
  String notifOrderStatusBody(String status);

  /// No description provided for @settingsNotifMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get settingsNotifMarkAllRead;

  /// No description provided for @subscriptionCurrentStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Current status'**
  String get subscriptionCurrentStatusTitle;

  /// No description provided for @subscriptionReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'View-only mode until you renew.'**
  String get subscriptionReadOnlyHint;

  /// No description provided for @subscriptionActivationTitle.
  ///
  /// In en, this message translates to:
  /// **'Activation'**
  String get subscriptionActivationTitle;

  /// No description provided for @subscriptionActivationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Activation code'**
  String get subscriptionActivationCodeLabel;

  /// No description provided for @subscriptionActivationCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter code when billing is connected'**
  String get subscriptionActivationCodeHint;

  /// No description provided for @subscriptionActivateCta.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get subscriptionActivateCta;

  /// No description provided for @subscriptionActivationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Activation will connect to the server (plan-06).'**
  String get subscriptionActivationComingSoon;

  /// No description provided for @subscriptionRefreshStatusCta.
  ///
  /// In en, this message translates to:
  /// **'Refresh license status'**
  String get subscriptionRefreshStatusCta;

  /// No description provided for @subscriptionRefreshComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Online refresh will be available when the API is connected.'**
  String get subscriptionRefreshComingSoon;

  /// No description provided for @customersListView.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get customersListView;

  /// No description provided for @customersCardView.
  ///
  /// In en, this message translates to:
  /// **'Card view'**
  String get customersCardView;

  /// No description provided for @customerEditDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get customerEditDialogTitle;

  /// No description provided for @customerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Customer updated.'**
  String get customerUpdated;

  /// No description provided for @customerAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get customerAddressLabel;

  /// No description provided for @customerAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get customerAddressHint;

  /// No description provided for @customerNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get customerNotesLabel;

  /// No description provided for @customerNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get customerNotesHint;

  /// No description provided for @customerFieldEmpty.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get customerFieldEmpty;

  /// No description provided for @customerDeleteMenu.
  ///
  /// In en, this message translates to:
  /// **'Delete customer'**
  String get customerDeleteMenu;

  /// No description provided for @customerDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this customer?'**
  String get customerDeleteConfirmTitle;

  /// No description provided for @customerDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'They will be removed from your list. Existing orders stay in the Orders tab.'**
  String get customerDeleteConfirmBody;

  /// No description provided for @customerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Customer removed'**
  String get customerDeleted;

  /// No description provided for @customersFinancialSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get customersFinancialSectionTitle;

  /// No description provided for @customersFinancialFilterAll.
  ///
  /// In en, this message translates to:
  /// **'Any balance'**
  String get customersFinancialFilterAll;

  /// No description provided for @customersFilterHasUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Has unpaid orders'**
  String get customersFilterHasUnpaid;

  /// No description provided for @customersSortMostOrders.
  ///
  /// In en, this message translates to:
  /// **'Most orders'**
  String get customersSortMostOrders;

  /// No description provided for @customersRowMeta.
  ///
  /// In en, this message translates to:
  /// **'{orderCount} orders · {unpaid}'**
  String customersRowMeta(int orderCount, String unpaid);

  /// No description provided for @customersRowNoOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get customersRowNoOrdersYet;

  /// No description provided for @settingsUsersLimitsTitle.
  ///
  /// In en, this message translates to:
  /// **'User limits'**
  String get settingsUsersLimitsTitle;

  /// No description provided for @settingsUsersLimitsBody.
  ///
  /// In en, this message translates to:
  /// **'Trial shops: up to 2 users. Paid shops: up to 5 users. The owner account cannot be deleted.'**
  String get settingsUsersLimitsBody;

  /// No description provided for @settingsUsersAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get settingsUsersAddCta;

  /// No description provided for @settingsUsersAddDisabledHint.
  ///
  /// In en, this message translates to:
  /// **'User management will connect to the server (plan-15).'**
  String get settingsUsersAddDisabledHint;

  /// No description provided for @settingsUsersListTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get settingsUsersListTitle;

  /// No description provided for @settingsUsersOwnerRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop owner'**
  String get settingsUsersOwnerRowTitle;

  /// No description provided for @settingsUsersOwnerRowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full access'**
  String get settingsUsersOwnerRowSubtitle;

  /// No description provided for @settingsUsersEmptyRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional users'**
  String get settingsUsersEmptyRowTitle;

  /// No description provided for @settingsUsersEmptyRowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No other users yet'**
  String get settingsUsersEmptyRowSubtitle;

  /// No description provided for @settingsBackupOwnerPasswordNote.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore will require the owner’s login password (plan-15).'**
  String get settingsBackupOwnerPasswordNote;

  /// No description provided for @settingsBackupSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackupSectionTitle;

  /// No description provided for @settingsBackupOptionDataOnly.
  ///
  /// In en, this message translates to:
  /// **'Data only'**
  String get settingsBackupOptionDataOnly;

  /// No description provided for @settingsBackupOptionDataOnlySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Orders, customers, payments, catalog metadata — smaller file'**
  String get settingsBackupOptionDataOnlySubtitle;

  /// No description provided for @settingsBackupOptionDataAndImages.
  ///
  /// In en, this message translates to:
  /// **'Data + catalog images'**
  String get settingsBackupOptionDataAndImages;

  /// No description provided for @settingsBackupOptionDataAndImagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Includes design photos stored on this device'**
  String get settingsBackupOptionDataAndImagesSubtitle;

  /// No description provided for @settingsBackupCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get settingsBackupCreateCta;

  /// No description provided for @settingsRestoreSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get settingsRestoreSectionTitle;

  /// No description provided for @settingsRestoreMergeNote.
  ///
  /// In en, this message translates to:
  /// **'Restore always merges into your current data (never replaces everything).'**
  String get settingsRestoreMergeNote;

  /// No description provided for @settingsRestorePickCta.
  ///
  /// In en, this message translates to:
  /// **'Choose backup file'**
  String get settingsRestorePickCta;

  /// No description provided for @settingsBackupRestoreComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Catalog images are not included in v1 backups yet.'**
  String get settingsBackupRestoreComingSoon;

  /// No description provided for @settingsBackupWebNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore require the native app (Isar). Use Android, iOS, or desktop — not Web.'**
  String get settingsBackupWebNotSupported;

  /// No description provided for @settingsBackupExportDone.
  ///
  /// In en, this message translates to:
  /// **'Backup file saved.'**
  String get settingsBackupExportDone;

  /// No description provided for @settingsBackupRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Restore completed.'**
  String get settingsBackupRestoreDone;

  /// No description provided for @settingsBackupRestoreSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore summary'**
  String get settingsBackupRestoreSummaryTitle;

  /// No description provided for @settingsBackupSummaryLineCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers: {inserted} new, {updated} merged'**
  String settingsBackupSummaryLineCustomers(int inserted, int updated);

  /// No description provided for @settingsBackupSummaryLineMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements: {types} field types, {profiles} profiles, {lines} saved values'**
  String settingsBackupSummaryLineMeasurements(
    int types,
    int profiles,
    int lines,
  );

  /// No description provided for @settingsBackupSummaryLineOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders: {count} written'**
  String settingsBackupSummaryLineOrders(int count);

  /// No description provided for @settingsBackupSummaryLinePayments.
  ///
  /// In en, this message translates to:
  /// **'Payments: {inserted} added, {skipped} skipped (already existed)'**
  String settingsBackupSummaryLinePayments(int inserted, int skipped);

  /// No description provided for @settingsBackupSummaryLineSnapshots.
  ///
  /// In en, this message translates to:
  /// **'Measurement snapshots: {headers} headers, {items} lines'**
  String settingsBackupSummaryLineSnapshots(int headers, int items);

  /// No description provided for @settingsBackupSummaryLineNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications: {inserted} added, {skipped} skipped'**
  String settingsBackupSummaryLineNotifications(int inserted, int skipped);

  /// No description provided for @settingsBackupInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'Could not read this backup file.'**
  String get settingsBackupInvalidFile;

  /// No description provided for @settingsNotificationsFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters (preview)'**
  String get settingsNotificationsFiltersTitle;

  /// No description provided for @settingsNotifFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get settingsNotifFilterAll;

  /// No description provided for @settingsNotifFilterOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get settingsNotifFilterOrders;

  /// No description provided for @settingsNotifFilterLicense.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get settingsNotifFilterLicense;

  /// No description provided for @settingsNotifFilterBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsNotifFilterBackup;

  /// No description provided for @settingsNotificationsInboxEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get settingsNotificationsInboxEmpty;

  /// No description provided for @settingsNotificationsInboxEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'History will appear here for order, license, and backup events.'**
  String get settingsNotificationsInboxEmptyHint;

  /// No description provided for @settingsSyncLastSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Last successful sync'**
  String get settingsSyncLastSyncTitle;

  /// No description provided for @settingsSyncLastSyncNever.
  ///
  /// In en, this message translates to:
  /// **'Not synced yet (offline-first; API pending)'**
  String get settingsSyncLastSyncNever;

  /// No description provided for @settingsSyncQueuedTitle.
  ///
  /// In en, this message translates to:
  /// **'Queued local changes'**
  String get settingsSyncQueuedTitle;

  /// No description provided for @settingsSyncQueuedZero.
  ///
  /// In en, this message translates to:
  /// **'None waiting'**
  String get settingsSyncQueuedZero;

  /// No description provided for @settingsSyncQueuedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} waiting to sync'**
  String settingsSyncQueuedCount(int count);

  /// No description provided for @settingsSyncOutboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Outbox'**
  String get settingsSyncOutboxTitle;

  /// No description provided for @settingsSyncOutboxPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Queued changes'**
  String get settingsSyncOutboxPlaceholderTitle;

  /// No description provided for @settingsSyncOutboxPlaceholderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Retry and details will appear when sync is enabled'**
  String get settingsSyncOutboxPlaceholderSubtitle;

  /// No description provided for @settingsSyncOutboxPendingListTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending mutations (local)'**
  String get settingsSyncOutboxPendingListTitle;

  /// No description provided for @settingsSyncOutboxPendingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing queued for sync.'**
  String get settingsSyncOutboxPendingEmpty;

  /// No description provided for @settingsDiagnosticsExportCta.
  ///
  /// In en, this message translates to:
  /// **'Export diagnostics bundle'**
  String get settingsDiagnosticsExportCta;

  /// No description provided for @settingsDiagnosticsExportSoon.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics export will be available when sync ships.'**
  String get settingsDiagnosticsExportSoon;

  /// No description provided for @settingsSyncDiagnosticsFooter.
  ///
  /// In en, this message translates to:
  /// **'Support can ask for this bundle to troubleshoot sync issues.'**
  String get settingsSyncDiagnosticsFooter;

  /// No description provided for @devPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer Portal'**
  String get devPortalTitle;

  /// No description provided for @devPortalTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get devPortalTabOverview;

  /// No description provided for @devPortalTabCodes.
  ///
  /// In en, this message translates to:
  /// **'Codes'**
  String get devPortalTabCodes;

  /// No description provided for @devPortalTabShops.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get devPortalTabShops;

  /// No description provided for @devPortalTabResets.
  ///
  /// In en, this message translates to:
  /// **'Resets'**
  String get devPortalTabResets;

  /// No description provided for @devPortalTabDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get devPortalTabDiagnostics;

  /// No description provided for @devPortalOnlineRequired.
  ///
  /// In en, this message translates to:
  /// **'Developer tools require an online connection and a verified developer account.'**
  String get devPortalOnlineRequired;

  /// No description provided for @devPortalRetryCta.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get devPortalRetryCta;

  /// No description provided for @devPortalStubAction.
  ///
  /// In en, this message translates to:
  /// **'API not connected in this build.'**
  String get devPortalStubAction;

  /// No description provided for @devPortalEnvBadge.
  ///
  /// In en, this message translates to:
  /// **'Environment: dev'**
  String get devPortalEnvBadge;

  /// No description provided for @devPortalStatShops.
  ///
  /// In en, this message translates to:
  /// **'Total shops'**
  String get devPortalStatShops;

  /// No description provided for @devPortalStatActiveExpired.
  ///
  /// In en, this message translates to:
  /// **'Active / expired'**
  String get devPortalStatActiveExpired;

  /// No description provided for @devPortalStatTrials.
  ///
  /// In en, this message translates to:
  /// **'Trials running'**
  String get devPortalStatTrials;

  /// No description provided for @devPortalStatActivations.
  ///
  /// In en, this message translates to:
  /// **'Activations (period)'**
  String get devPortalStatActivations;

  /// No description provided for @devPortalApiHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'API health'**
  String get devPortalApiHealthTitle;

  /// No description provided for @devPortalApiHealthUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown — connect to the API'**
  String get devPortalApiHealthUnknown;

  /// No description provided for @devPortalCodesStub.
  ///
  /// In en, this message translates to:
  /// **'Activation codes: search, create, and revoke will load from the admin API (plan-18).'**
  String get devPortalCodesStub;

  /// No description provided for @devPortalShopsStub.
  ///
  /// In en, this message translates to:
  /// **'Shops & licenses: list and detail views will load from the admin API.'**
  String get devPortalShopsStub;

  /// No description provided for @devPortalResetsStub.
  ///
  /// In en, this message translates to:
  /// **'Password reset requests: support queue will load from the admin API.'**
  String get devPortalResetsStub;

  /// No description provided for @devPortalDiagStub.
  ///
  /// In en, this message translates to:
  /// **'Support diagnostics: link to exported bundles from Settings → Sync & Diagnostics.'**
  String get devPortalDiagStub;

  /// No description provided for @settingsShopProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get settingsShopProfileTitle;

  /// No description provided for @shopProfileIntro.
  ///
  /// In en, this message translates to:
  /// **'This shop name appears as the designer label on your catalog items. Contact fields are for your reference until invoicing is connected.'**
  String get shopProfileIntro;

  /// No description provided for @shopProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get shopProfileNameLabel;

  /// No description provided for @shopProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Pride Tailoring'**
  String get shopProfileNameHint;

  /// No description provided for @shopProfileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop name is required.'**
  String get shopProfileNameRequired;

  /// No description provided for @shopProfileNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Shop name is too short.'**
  String get shopProfileNameTooShort;

  /// No description provided for @shopProfileShopPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop phone (optional)'**
  String get shopProfileShopPhoneLabel;

  /// No description provided for @shopProfileShopPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 0700000000'**
  String get shopProfileShopPhoneHint;

  /// No description provided for @shopProfileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get shopProfileAddressLabel;

  /// No description provided for @shopProfileAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Street, area, city…'**
  String get shopProfileAddressHint;

  /// No description provided for @shopProfileNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get shopProfileNotesLabel;

  /// No description provided for @shopProfileNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Hours, landmarks, tax ID…'**
  String get shopProfileNotesHint;

  /// No description provided for @shopProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Shop profile saved.'**
  String get shopProfileSaved;

  /// No description provided for @shopProfileReadOnlyBanner.
  ///
  /// In en, this message translates to:
  /// **'License expired — you can view this profile but not edit it.'**
  String get shopProfileReadOnlyBanner;

  /// No description provided for @settingsCurrentUserGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get settingsCurrentUserGuest;

  /// No description provided for @settingsShopIdChip.
  ///
  /// In en, this message translates to:
  /// **'Shop {shopId}'**
  String settingsShopIdChip(String shopId);

  /// No description provided for @customersFilterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort & filter'**
  String get customersFilterTooltip;

  /// No description provided for @customersFilterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort & filter'**
  String get customersFilterSheetTitle;

  /// No description provided for @customersSortSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get customersSortSectionTitle;

  /// No description provided for @customersSortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get customersSortNameAsc;

  /// No description provided for @customersSortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Z–A'**
  String get customersSortNameDesc;

  /// No description provided for @customersSortRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get customersSortRecentActivity;

  /// No description provided for @customersCreatedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get customersCreatedSectionTitle;

  /// No description provided for @customersCreatedFilterAll.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get customersCreatedFilterAll;

  /// No description provided for @customersCreatedFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get customersCreatedFilterToday;

  /// No description provided for @customersCreatedFilterThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get customersCreatedFilterThisWeek;

  /// No description provided for @customersActivitySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get customersActivitySectionTitle;

  /// No description provided for @customersFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All customers'**
  String get customersFilterAll;

  /// No description provided for @customersFilterHasOrders.
  ///
  /// In en, this message translates to:
  /// **'Has orders'**
  String get customersFilterHasOrders;

  /// No description provided for @customersFilterNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get customersFilterNoOrders;

  /// No description provided for @customersApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get customersApplyFilters;

  /// No description provided for @customersResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get customersResetFilters;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa', 'ps'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'ps':
      return AppLocalizationsPs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
