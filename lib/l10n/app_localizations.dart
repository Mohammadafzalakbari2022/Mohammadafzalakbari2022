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
  /// **'Customer list'**
  String get tabCustomers;

  /// No description provided for @tabOrdersList.
  ///
  /// In en, this message translates to:
  /// **'Orders list'**
  String get tabOrdersList;

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
  /// **'Enter your shop username and password to open your shop.'**
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
  /// **'Only if your shop gave you a shop ID'**
  String get loginShopIdHint;

  /// No description provided for @loginSigningInHint.
  ///
  /// In en, this message translates to:
  /// **'Please wait. On slow internet this can take up to a minute.'**
  String get loginSigningInHint;

  /// No description provided for @loginCreatingShopHint.
  ///
  /// In en, this message translates to:
  /// **'Please wait while your shop is being set up. This can take a moment.'**
  String get loginCreatingShopHint;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Shop ID, username, or password is not correct. Please check and try again.'**
  String get loginInvalidCredentials;

  /// No description provided for @loginNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get loginNoInternet;

  /// No description provided for @loginOfflineNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'Sign in once while online on this device to enable offline sign-in.'**
  String get loginOfflineNotSetUp;

  /// No description provided for @loginOfflineShopIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your Shop ID to sign in offline.'**
  String get loginOfflineShopIdRequired;

  /// No description provided for @loginConnectionSlow.
  ///
  /// In en, this message translates to:
  /// **'The connection is slow or timed out. Please wait a moment and try again.'**
  String get loginConnectionSlow;

  /// No description provided for @loginServerBusy.
  ///
  /// In en, this message translates to:
  /// **'The service is busy right now. Please try again in a few minutes.'**
  String get loginServerBusy;

  /// No description provided for @loginSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in right now. Please try again.'**
  String get loginSomethingWrong;

  /// No description provided for @loginShopCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create your shop right now. Please try again.'**
  String get loginShopCreateFailed;

  /// No description provided for @loginForgotPasswordSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Sending your request…'**
  String get loginForgotPasswordSubmitting;

  /// No description provided for @loginForgotPasswordSubmitHint.
  ///
  /// In en, this message translates to:
  /// **'Please wait. This may take a moment on slow internet.'**
  String get loginForgotPasswordSubmitHint;

  /// No description provided for @loginForgotPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send your request right now. Please try again.'**
  String get loginForgotPasswordFailed;

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

  /// No description provided for @loginPasswordShowA11y.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginPasswordShowA11y;

  /// No description provided for @loginPasswordHideA11y.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginPasswordHideA11y;

  /// No description provided for @loginSignInCta.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignInCta;

  /// No description provided for @loginForgotPasswordCta.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPasswordCta;

  /// No description provided for @loginForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get loginForgotPasswordTitle;

  /// No description provided for @loginForgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your shop ID and username. A developer can set a new password from the Developer Portal when your request appears in the queue.'**
  String get loginForgotPasswordBody;

  /// No description provided for @loginForgotPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get loginForgotPasswordSubmit;

  /// No description provided for @loginForgotPasswordQueued.
  ///
  /// In en, this message translates to:
  /// **'If the account exists, a reset request was queued for support.'**
  String get loginForgotPasswordQueued;

  /// No description provided for @loginForgotPasswordFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'Shop ID and username are required.'**
  String get loginForgotPasswordFieldsRequired;

  /// No description provided for @settingsPushTokenTitle.
  ///
  /// In en, this message translates to:
  /// **'Push notification token (beta)'**
  String get settingsPushTokenTitle;

  /// No description provided for @settingsPushTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Paste an FCM device token, choose platform, then save. The server stores it for future push delivery.'**
  String get settingsPushTokenHint;

  /// No description provided for @settingsPushTokenFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Device token'**
  String get settingsPushTokenFieldLabel;

  /// No description provided for @settingsPushPlatformLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get settingsPushPlatformLabel;

  /// No description provided for @settingsPushRegisterCta.
  ///
  /// In en, this message translates to:
  /// **'Save token to server'**
  String get settingsPushRegisterCta;

  /// No description provided for @settingsPushRegisterOk.
  ///
  /// In en, this message translates to:
  /// **'Token saved.'**
  String get settingsPushRegisterOk;

  /// No description provided for @settingsPushRegisterFail.
  ///
  /// In en, this message translates to:
  /// **'Could not save token.'**
  String get settingsPushRegisterFail;

  /// No description provided for @devPortalShopsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load shops: {error}'**
  String devPortalShopsLoadError(String error);

  /// No description provided for @devPortalResetsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load reset queue: {error}'**
  String devPortalResetsLoadError(String error);

  /// No description provided for @devPortalResetsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pending password reset requests.'**
  String get devPortalResetsEmpty;

  /// No description provided for @devPortalResetsSetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get devPortalResetsSetPasswordTitle;

  /// No description provided for @devPortalResetsSetPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters.'**
  String get devPortalResetsSetPasswordHint;

  /// No description provided for @devPortalResetsResolveCta.
  ///
  /// In en, this message translates to:
  /// **'Apply password'**
  String get devPortalResetsResolveCta;

  /// No description provided for @devPortalResetsResolved.
  ///
  /// In en, this message translates to:
  /// **'Password updated.'**
  String get devPortalResetsResolved;

  /// No description provided for @devPortalResetsResolveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update: {error}'**
  String devPortalResetsResolveFailed(String error);

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

  /// No description provided for @loginApiHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your shop ID, username, and password.'**
  String get loginApiHint;

  /// No description provided for @loginSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get loginSigningIn;

  /// No description provided for @loginApiUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Shop ID, username, or password is not correct. Please check and try again.'**
  String get loginApiUnauthorized;

  /// No description provided for @loginApiError.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in: {error}'**
  String loginApiError(String error);

  /// No description provided for @loginShopCreateSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new shop'**
  String get loginShopCreateSectionTitle;

  /// No description provided for @loginShopCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register your tailoring shop and sign in as the owner.'**
  String get loginShopCreateSubtitle;

  /// No description provided for @loginShopCreateNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get loginShopCreateNameLabel;

  /// No description provided for @loginShopCreateOwnerUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner username'**
  String get loginShopCreateOwnerUsernameLabel;

  /// No description provided for @loginShopCreateOwnerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Owner password'**
  String get loginShopCreateOwnerPasswordLabel;

  /// No description provided for @loginShopCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Create shop & sign in'**
  String get loginShopCreateCta;

  /// No description provided for @loginShopCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating shop…'**
  String get loginShopCreating;

  /// No description provided for @loginShopCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create shop: {error}'**
  String loginShopCreateError(String error);

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
  /// **'Today\'s KPIs and shortcuts from your shop data.'**
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
  /// **'Open dashboard'**
  String get dashboardOpenMenuTooltip;

  /// No description provided for @dashboardOrdersPipelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Order pipeline'**
  String get dashboardOrdersPipelineTitle;

  /// No description provided for @dashboardRecentIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Income — last 7 days'**
  String get dashboardRecentIncomeTitle;

  /// No description provided for @dashboardActivitySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync & notifications'**
  String get dashboardActivitySectionTitle;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Renew with Hesab Pay (steps below when published), submit a payment claim as shop owner, or enter an activation code from support. While expired, editing is limited; you can still view your data.'**
  String get subscriptionBody;

  /// No description provided for @subscriptionBillingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay & renew'**
  String get subscriptionBillingSectionTitle;

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
  /// **'Order composer will go here.'**
  String get ordersComposerPlaceholderBody;

  /// No description provided for @ordersDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get ordersDetailTitle;

  /// No description provided for @ordersDetailPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Order {orderId} — details UI coming soon.'**
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

  /// No description provided for @ordersTakenOn.
  ///
  /// In en, this message translates to:
  /// **'Taken: {dateTime}'**
  String ordersTakenOn(String dateTime);

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

  /// No description provided for @ordersFilterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get ordersFilterSheetTitle;

  /// No description provided for @ordersFilterQuickSection.
  ///
  /// In en, this message translates to:
  /// **'Quick filters'**
  String get ordersFilterQuickSection;

  /// No description provided for @ordersFilterDeliverySection.
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get ordersFilterDeliverySection;

  /// No description provided for @ordersFilterStatusSection.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ordersFilterStatusSection;

  /// No description provided for @ordersFilterClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get ordersFilterClearAll;

  /// No description provided for @ordersFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get ordersFilterApply;

  /// No description provided for @listToolbarSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get listToolbarSearchTooltip;

  /// No description provided for @listToolbarFilterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get listToolbarFilterTooltip;

  /// No description provided for @appShellTapTitleForMenu.
  ///
  /// In en, this message translates to:
  /// **'Tap to open dashboard menu'**
  String get appShellTapTitleForMenu;

  /// No description provided for @ordersDetailFromNewBanner.
  ///
  /// In en, this message translates to:
  /// **'Tip: use the toolbar above to print the receipt or share the invoice.'**
  String get ordersDetailFromNewBanner;

  /// No description provided for @ordersComposerPostSaveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Print, share, or open the full order.'**
  String get ordersComposerPostSaveSubtitle;

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

  /// No description provided for @ordersDetailAuditIntro.
  ///
  /// In en, this message translates to:
  /// **'Local record metadata on this device. Full status-change history is not logged yet; use Payments for dated ledger entries.'**
  String get ordersDetailAuditIntro;

  /// No description provided for @ordersAuditInternalId.
  ///
  /// In en, this message translates to:
  /// **'Internal ID'**
  String get ordersAuditInternalId;

  /// No description provided for @ordersAuditCopyIdTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get ordersAuditCopyIdTooltip;

  /// No description provided for @ordersAuditCopiedId.
  ///
  /// In en, this message translates to:
  /// **'Copied order ID'**
  String get ordersAuditCopiedId;

  /// No description provided for @ordersAuditCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get ordersAuditCreatedAt;

  /// No description provided for @ordersAuditUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get ordersAuditUpdatedAt;

  /// No description provided for @ordersAuditStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ordersAuditStatus;

  /// No description provided for @ordersAuditDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get ordersAuditDelivery;

  /// No description provided for @ordersAuditPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment ledger'**
  String get ordersAuditPaymentsTitle;

  /// No description provided for @ordersAuditPaymentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payment rows for this order yet.'**
  String get ordersAuditPaymentsEmpty;

  /// No description provided for @ordersAuditPaymentsLine.
  ///
  /// In en, this message translates to:
  /// **'{count} payment rows · earliest {first} · latest {last}'**
  String ordersAuditPaymentsLine(int count, String first, String last);

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
  /// **'This order is locked because it is Delivered or Cancelled.'**
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
  /// **'Status changes will open a confirmation flow.'**
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
  /// **'Example: 300'**
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

  /// No description provided for @customerOrderHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get customerOrderHistoryTitle;

  /// No description provided for @customerNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet for this customer.'**
  String get customerNoOrders;

  /// No description provided for @customerViewAllOrders.
  ///
  /// In en, this message translates to:
  /// **'View all orders for this customer'**
  String get customerViewAllOrders;

  /// No description provided for @customerViewAllOrdersSoon.
  ///
  /// In en, this message translates to:
  /// **'This will open Orders with a customer filter.'**
  String get customerViewAllOrdersSoon;

  /// No description provided for @customerSectionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Details will appear here as the module is built.'**
  String get customerSectionPlaceholder;

  /// No description provided for @customerNewPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'New customer form will go here.'**
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

  /// No description provided for @settingsMeasurementUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Default measurement unit'**
  String get settingsMeasurementUnitTitle;

  /// No description provided for @settingsMeasurementUnitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used when entering cloth measurements on new orders'**
  String get settingsMeasurementUnitSubtitle;

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

  /// No description provided for @reportsPaymentsSectionHeader.
  ///
  /// In en, this message translates to:
  /// **'{title} — {total}'**
  String reportsPaymentsSectionHeader(String title, String total);

  /// No description provided for @reportsPaymentsWeekOfLabel.
  ///
  /// In en, this message translates to:
  /// **'Week of {weekStart}'**
  String reportsPaymentsWeekOfLabel(String weekStart);

  /// No description provided for @reportsPaymentsGroupByLabel.
  ///
  /// In en, this message translates to:
  /// **'Group by'**
  String get reportsPaymentsGroupByLabel;

  /// No description provided for @reportsPaymentsGroupByDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get reportsPaymentsGroupByDay;

  /// No description provided for @reportsPaymentsGroupByWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get reportsPaymentsGroupByWeek;

  /// No description provided for @reportsPaymentsGroupByMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get reportsPaymentsGroupByMonth;

  /// No description provided for @reportsMonthlyIncomePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Monthly income report will go here.'**
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

  /// No description provided for @reportsMonthlyDailyPaymentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily payments (this month)'**
  String get reportsMonthlyDailyPaymentsLabel;

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

  /// No description provided for @reportsUnpaidAmountSection.
  ///
  /// In en, this message translates to:
  /// **'Remaining balance'**
  String get reportsUnpaidAmountSection;

  /// No description provided for @reportsUnpaidAmountAny.
  ///
  /// In en, this message translates to:
  /// **'Any amount'**
  String get reportsUnpaidAmountAny;

  /// No description provided for @reportsUnpaidAmountUnder5000.
  ///
  /// In en, this message translates to:
  /// **'Under 5,000'**
  String get reportsUnpaidAmountUnder5000;

  /// No description provided for @reportsUnpaidAmount5000to20000.
  ///
  /// In en, this message translates to:
  /// **'5,000 – 20,000'**
  String get reportsUnpaidAmount5000to20000;

  /// No description provided for @reportsUnpaidAmountOver20000.
  ///
  /// In en, this message translates to:
  /// **'Over 20,000'**
  String get reportsUnpaidAmountOver20000;

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
  /// **'Mutual opt-in: enable to browse and be listed in public directory.'**
  String get catalogSharingToggleSubtitle;

  /// No description provided for @catalogSharedPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Shared designs directory will appear here when online.'**
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

  /// No description provided for @catalogViewDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get catalogViewDescription;

  /// No description provided for @catalogDescriptionSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get catalogDescriptionSheetTitle;

  /// No description provided for @catalogNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description for this design.'**
  String get catalogNoDescription;

  /// No description provided for @catalogViewerManageA11y.
  ///
  /// In en, this message translates to:
  /// **'Manage design'**
  String get catalogViewerManageA11y;

  /// No description provided for @catalogAddDesignPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Camera / Gallery add will be implemented on Android/iOS only.'**
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
  /// **'Shop details will appear here.'**
  String get settingsShopTileSubtitle;

  /// No description provided for @settingsCurrentUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsCurrentUserTitle;

  /// No description provided for @settingsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountTitle;

  /// No description provided for @settingsAccountUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get settingsAccountUsernameLabel;

  /// No description provided for @settingsAccountUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Usernames are set by the shop owner and cannot be changed here.'**
  String get settingsAccountUsernameHint;

  /// No description provided for @settingsAccountRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get settingsAccountRoleLabel;

  /// No description provided for @settingsAccountChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingsAccountChangePasswordTitle;

  /// No description provided for @settingsAccountChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update the password for this account on this device.'**
  String get settingsAccountChangePasswordSubtitle;

  /// No description provided for @settingsAccountCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get settingsAccountCurrentPasswordLabel;

  /// No description provided for @settingsAccountNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get settingsAccountNewPasswordLabel;

  /// No description provided for @settingsAccountConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get settingsAccountConfirmPasswordLabel;

  /// No description provided for @settingsAccountChangePasswordCta.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get settingsAccountChangePasswordCta;

  /// No description provided for @settingsAccountChangePasswordOk.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Use the new password next time you sign in.'**
  String get settingsAccountChangePasswordOk;

  /// No description provided for @settingsAccountChangePasswordFail.
  ///
  /// In en, this message translates to:
  /// **'Could not update password: {error}'**
  String settingsAccountChangePasswordFail(String error);

  /// No description provided for @settingsAccountPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'New passwords do not match.'**
  String get settingsAccountPasswordMismatch;

  /// No description provided for @settingsAccountOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Connect to the server to change your password.'**
  String get settingsAccountOfflineHint;

  /// No description provided for @settingsAccountForgotPasswordCta.
  ///
  /// In en, this message translates to:
  /// **'Request password reset from support'**
  String get settingsAccountForgotPasswordCta;

  /// No description provided for @settingsUsersReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Only the shop owner can add or remove users.'**
  String get settingsUsersReadOnlyHint;

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
  /// **'Users management will be implemented (create/remove users, limits, owner protections).'**
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
  /// **'Backup/restore will be implemented (merge restore, owner password confirmation, restore summary).'**
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
  /// **'History and filters.'**
  String get settingsNotificationsInboxSubtitle;

  /// No description provided for @settingsNotificationsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Notifications inbox will be implemented.'**
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

  /// No description provided for @settingsApiServerTitle.
  ///
  /// In en, this message translates to:
  /// **'API server'**
  String get settingsApiServerTitle;

  /// No description provided for @settingsApiServerNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'No URL set. Use --dart-define=API_BASE_URL=https://your-api when you run or build.'**
  String get settingsApiServerNotConfigured;

  /// No description provided for @settingsApiServerConfigured.
  ///
  /// In en, this message translates to:
  /// **'Base URL: {url}'**
  String settingsApiServerConfigured(String url);

  /// No description provided for @settingsApiTestConnection.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get settingsApiTestConnection;

  /// No description provided for @settingsApiTestNeedOnline.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to test the server.'**
  String get settingsApiTestNeedOnline;

  /// No description provided for @settingsApiHealthOk.
  ///
  /// In en, this message translates to:
  /// **'Server responded OK (GET /health).'**
  String get settingsApiHealthOk;

  /// No description provided for @settingsApiHealthFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reach server: {message}'**
  String settingsApiHealthFailed(String message);

  /// No description provided for @settingsSyncDiagnosticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last sync, queue, and pending changes.'**
  String get settingsSyncDiagnosticsSubtitle;

  /// No description provided for @settingsSyncDiagnosticsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Sync status and diagnostics appear here.'**
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
  /// **'Developer Portal screens will be implemented.'**
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

  /// No description provided for @settingsSectionSoundFeedback.
  ///
  /// In en, this message translates to:
  /// **'Sound & feedback'**
  String get settingsSectionSoundFeedback;

  /// No description provided for @settingsUiSoundsTitle.
  ///
  /// In en, this message translates to:
  /// **'UI sounds'**
  String get settingsUiSoundsTitle;

  /// No description provided for @settingsUiSoundsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Short sounds when you save, delete, or complete an action.'**
  String get settingsUiSoundsSubtitle;

  /// No description provided for @settingsUiHapticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get settingsUiHapticsTitle;

  /// No description provided for @settingsUiHapticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light vibration on successful actions.'**
  String get settingsUiHapticsSubtitle;

  /// No description provided for @settingsUiHapticsWebHint.
  ///
  /// In en, this message translates to:
  /// **'Haptics are not available on web.'**
  String get settingsUiHapticsWebHint;

  /// No description provided for @settingsSoundPreviewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get settingsSoundPreviewSuccess;

  /// No description provided for @settingsSoundPreviewError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get settingsSoundPreviewError;

  /// No description provided for @settingsSoundPreviewDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsSoundPreviewDelete;

  /// No description provided for @ordersDetailPaymentProgress.
  ///
  /// In en, this message translates to:
  /// **'Payment progress'**
  String get ordersDetailPaymentProgress;

  /// No description provided for @ordersComposerProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Order progress'**
  String get ordersComposerProgressTitle;

  /// No description provided for @ordersComposerProgressCount.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} steps'**
  String ordersComposerProgressCount(int done, int total);

  /// No description provided for @ordersComposerProgressCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get ordersComposerProgressCustomer;

  /// No description provided for @ordersComposerProgressMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Measures'**
  String get ordersComposerProgressMeasurements;

  /// No description provided for @ordersComposerProgressStyle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get ordersComposerProgressStyle;

  /// No description provided for @ordersComposerProgressFabric.
  ///
  /// In en, this message translates to:
  /// **'Fabric'**
  String get ordersComposerProgressFabric;

  /// No description provided for @ordersComposerProgressDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get ordersComposerProgressDelivery;

  /// No description provided for @ordersComposerProgressPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get ordersComposerProgressPayment;

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

  /// No description provided for @licenseGraceReadOnlySnack.
  ///
  /// In en, this message translates to:
  /// **'Read-only until your license is verified online.'**
  String get licenseGraceReadOnlySnack;

  /// No description provided for @licenseClockTamperSnack.
  ///
  /// In en, this message translates to:
  /// **'Read-only: device clock looks inconsistent. Open Subscription while online to verify.'**
  String get licenseClockTamperSnack;

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
  /// **'Example: 1500'**
  String get ordersComposerTotalHint;

  /// No description provided for @ordersComposerPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial paid (AFN)'**
  String get ordersComposerPaidLabel;

  /// No description provided for @ordersComposerPaidHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 500'**
  String get ordersComposerPaidHint;

  /// No description provided for @ordersComposerDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get ordersComposerDueLabel;

  /// No description provided for @ordersComposerPaymentSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get ordersComposerPaymentSheetTitle;

  /// No description provided for @ordersComposerPaymentInitialOnSaveHint.
  ///
  /// In en, this message translates to:
  /// **'Initial payment is recorded when you save the order.'**
  String get ordersComposerPaymentInitialOnSaveHint;

  /// No description provided for @ordersPaymentInitialExceedsTotal.
  ///
  /// In en, this message translates to:
  /// **'Initial payment cannot exceed the order total.'**
  String get ordersPaymentInitialExceedsTotal;

  /// No description provided for @ordersPaymentExceedsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Payment cannot exceed the remaining balance.'**
  String get ordersPaymentExceedsRemaining;

  /// No description provided for @ordersPaymentTotalBelowPaid.
  ///
  /// In en, this message translates to:
  /// **'Order total cannot be less than amount already paid.'**
  String get ordersPaymentTotalBelowPaid;

  /// No description provided for @ordersPaymentSheetSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get ordersPaymentSheetSavedTitle;

  /// No description provided for @ordersPaymentHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get ordersPaymentHistoryTitle;

  /// No description provided for @ordersPaymentSignedHint.
  ///
  /// In en, this message translates to:
  /// **'Type a positive amount to add or set. Type a minus amount (e.g. -500) to deduct from this field.'**
  String get ordersPaymentSignedHint;

  /// No description provided for @ordersPaymentDepositLabel.
  ///
  /// In en, this message translates to:
  /// **'Deposit {n}'**
  String ordersPaymentDepositLabel(int n);

  /// No description provided for @ordersPaymentNextPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get ordersPaymentNextPaymentLabel;

  /// No description provided for @ordersPaymentRecordCta.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get ordersPaymentRecordCta;

  /// No description provided for @ordersPaymentNegativeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot go below zero.'**
  String get ordersPaymentNegativeInvalid;

  /// No description provided for @ordersPaymentNextMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Next payment must be a positive amount.'**
  String get ordersPaymentNextMustBePositive;

  /// No description provided for @ordersEditConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Save changes?'**
  String get ordersEditConfirmTitle;

  /// No description provided for @ordersEditConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Update this order with your changes?'**
  String get ordersEditConfirmBody;

  /// No description provided for @ordersDetailEditCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get ordersDetailEditCustomerTitle;

  /// No description provided for @ordersDetailCustomerPickFromList.
  ///
  /// In en, this message translates to:
  /// **'Choose from list'**
  String get ordersDetailCustomerPickFromList;

  /// No description provided for @ordersDetailCustomerHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer change history'**
  String get ordersDetailCustomerHistoryTitle;

  /// No description provided for @ordersDetailCustomerHistoryChange.
  ///
  /// In en, this message translates to:
  /// **'Was {fromName} ({fromPhone}) → now {toName} ({toPhone})'**
  String ordersDetailCustomerHistoryChange(
    String fromName,
    String fromPhone,
    String toName,
    String toPhone,
  );

  /// No description provided for @ordersStatusChangeConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Change status?'**
  String get ordersStatusChangeConfirmTitle;

  /// No description provided for @ordersStatusChangeConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Change order status to {status}?'**
  String ordersStatusChangeConfirmBody(String status);

  /// No description provided for @ordersCancelOrderConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get ordersCancelOrderConfirmTitle;

  /// No description provided for @ordersCancelOrderConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Type the customer name to confirm cancellation.'**
  String get ordersCancelOrderConfirmBody;

  /// No description provided for @ordersDetailEditCta.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get ordersDetailEditCta;

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

  /// No description provided for @ordersComposerValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete required steps'**
  String get ordersComposerValidationTitle;

  /// No description provided for @ordersComposerValidationBody.
  ///
  /// In en, this message translates to:
  /// **'Fill in the following before saving this order:'**
  String get ordersComposerValidationBody;

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

  /// No description provided for @ordersComposerMeasurementsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get ordersComposerMeasurementsSheetTitle;

  /// No description provided for @ordersComposerMeasurementsNoTypesBody.
  ///
  /// In en, this message translates to:
  /// **'Add measurement types in Settings → Measurement types first.'**
  String get ordersComposerMeasurementsNoTypesBody;

  /// No description provided for @ordersComposerMeasurementsProfileAutoLabel.
  ///
  /// In en, this message translates to:
  /// **'Pattern #{date}'**
  String ordersComposerMeasurementsProfileAutoLabel(String date);

  /// No description provided for @ordersComposerSaveMeasurementsToProfile.
  ///
  /// In en, this message translates to:
  /// **'Save as customer profile'**
  String get ordersComposerSaveMeasurementsToProfile;

  /// No description provided for @ordersComposerSaveMeasurementsToProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Updates saved measurements on the selected customer.'**
  String get ordersComposerSaveMeasurementsToProfileSubtitle;

  /// No description provided for @ordersComposerAddMeasurementsCta.
  ///
  /// In en, this message translates to:
  /// **'Add measurements'**
  String get ordersComposerAddMeasurementsCta;

  /// No description provided for @ordersComposerStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get ordersComposerStyleTitle;

  /// No description provided for @ordersComposerFabricTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer fabric'**
  String get ordersComposerFabricTitle;

  /// No description provided for @ordersComposerFabricOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional — cloth the customer brings'**
  String get ordersComposerFabricOptional;

  /// No description provided for @ordersComposerFabricSummary.
  ///
  /// In en, this message translates to:
  /// **'{name} • {color} • ID {id}'**
  String ordersComposerFabricSummary(String name, String color, String id);

  /// No description provided for @ordersComposerFabricPartialSummary.
  ///
  /// In en, this message translates to:
  /// **'{name} • {color}'**
  String ordersComposerFabricPartialSummary(String name, String color);

  /// No description provided for @ordersComposerFabricUnset.
  ///
  /// In en, this message translates to:
  /// **'No fabric recorded'**
  String get ordersComposerFabricUnset;

  /// No description provided for @ordersComposerFabricSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer fabric'**
  String get ordersComposerFabricSheetTitle;

  /// No description provided for @ordersComposerFabricNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Fabric name'**
  String get ordersComposerFabricNameLabel;

  /// No description provided for @ordersComposerFabricNameHint.
  ///
  /// In en, this message translates to:
  /// **'Select or type'**
  String get ordersComposerFabricNameHint;

  /// No description provided for @ordersComposerFabricColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Fabric color'**
  String get ordersComposerFabricColorLabel;

  /// No description provided for @ordersComposerFabricColorHint.
  ///
  /// In en, this message translates to:
  /// **'Select or type'**
  String get ordersComposerFabricColorHint;

  /// No description provided for @ordersComposerFabricIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Fabric ID'**
  String get ordersComposerFabricIdLabel;

  /// No description provided for @ordersComposerFabricIdHint.
  ///
  /// In en, this message translates to:
  /// **'Assigned automatically when you save'**
  String get ordersComposerFabricIdHint;

  /// No description provided for @ordersComposerFabricClearCta.
  ///
  /// In en, this message translates to:
  /// **'Clear fabric'**
  String get ordersComposerFabricClearCta;

  /// No description provided for @ordersComposerStyleRequired.
  ///
  /// In en, this message translates to:
  /// **'Add style (required)'**
  String get ordersComposerStyleRequired;

  /// No description provided for @ordersComposerStyleSummary.
  ///
  /// In en, this message translates to:
  /// **'Style selected'**
  String get ordersComposerStyleSummary;

  /// No description provided for @ordersComposerStyleSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Order style'**
  String get ordersComposerStyleSheetTitle;

  /// No description provided for @ordersComposerStyleMainTitle.
  ///
  /// In en, this message translates to:
  /// **'Main cloth style'**
  String get ordersComposerStyleMainTitle;

  /// No description provided for @ordersComposerStyleCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Style name'**
  String get ordersComposerStyleCustomLabel;

  /// No description provided for @ordersComposerStyleCustomHint.
  ///
  /// In en, this message translates to:
  /// **'Select above or type custom'**
  String get ordersComposerStyleCustomHint;

  /// No description provided for @ordersComposerStyleFiguresTitle.
  ///
  /// In en, this message translates to:
  /// **'Design figures'**
  String get ordersComposerStyleFiguresTitle;

  /// No description provided for @ordersComposerStyleNoFigures.
  ///
  /// In en, this message translates to:
  /// **'No design figures yet — add them in Settings → Order style.'**
  String get ordersComposerStyleNoFigures;

  /// No description provided for @ordersComposerStyleClearFigures.
  ///
  /// In en, this message translates to:
  /// **'Clear all selections'**
  String get ordersComposerStyleClearFigures;

  /// No description provided for @ordersComposerCatalogDesignTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete design from catalog'**
  String get ordersComposerCatalogDesignTitle;

  /// No description provided for @ordersComposerCatalogDesignNone.
  ///
  /// In en, this message translates to:
  /// **'No catalog design selected'**
  String get ordersComposerCatalogDesignNone;

  /// No description provided for @ordersComposerCatalogChooseCta.
  ///
  /// In en, this message translates to:
  /// **'Choose from catalog'**
  String get ordersComposerCatalogChooseCta;

  /// No description provided for @ordersComposerCatalogClearCta.
  ///
  /// In en, this message translates to:
  /// **'Clear design'**
  String get ordersComposerCatalogClearCta;

  /// No description provided for @ordersComposerCatalogPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'My designs'**
  String get ordersComposerCatalogPickerTitle;

  /// No description provided for @ordersComposerCatalogPickerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No designs in your catalog yet. Add designs in the Catalog tab.'**
  String get ordersComposerCatalogPickerEmpty;

  /// No description provided for @customerLastCatalogDesignLabel.
  ///
  /// In en, this message translates to:
  /// **'Last catalog design'**
  String get customerLastCatalogDesignLabel;

  /// No description provided for @orderDetailCatalogDesignTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete design'**
  String get orderDetailCatalogDesignTitle;

  /// No description provided for @receiptCatalogDesignLabel.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get receiptCatalogDesignLabel;

  /// No description provided for @invoiceCatalogDesignLabel.
  ///
  /// In en, this message translates to:
  /// **'Catalog design'**
  String get invoiceCatalogDesignLabel;

  /// No description provided for @invoiceCatalogDesignerLabel.
  ///
  /// In en, this message translates to:
  /// **'Designer'**
  String get invoiceCatalogDesignerLabel;

  /// No description provided for @settingsStyleHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Order style'**
  String get settingsStyleHubTitle;

  /// No description provided for @settingsStyleTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Order style'**
  String get settingsStyleTileTitle;

  /// No description provided for @settingsStyleTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Style names and design figures'**
  String get settingsStyleTileSubtitle;

  /// No description provided for @settingsFabricHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer fabric'**
  String get settingsFabricHubTitle;

  /// No description provided for @settingsFabricHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preset names and colors for orders'**
  String get settingsFabricHubSubtitle;

  /// No description provided for @settingsFabricNamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fabric names'**
  String get settingsFabricNamesTitle;

  /// No description provided for @settingsFabricNamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cotton, wool, and other cloth types'**
  String get settingsFabricNamesSubtitle;

  /// No description provided for @settingsFabricNamesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fabric names yet.'**
  String get settingsFabricNamesEmpty;

  /// No description provided for @settingsFabricNameAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add fabric name'**
  String get settingsFabricNameAddCta;

  /// No description provided for @settingsFabricNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsFabricNameFieldLabel;

  /// No description provided for @settingsFabricNameRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename fabric'**
  String get settingsFabricNameRenameTitle;

  /// No description provided for @settingsFabricNameDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete fabric name?'**
  String get settingsFabricNameDeleteTitle;

  /// No description provided for @settingsFabricNameDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the name from the list. Existing orders are not changed.'**
  String get settingsFabricNameDeleteBody;

  /// No description provided for @settingsFabricColorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fabric colors'**
  String get settingsFabricColorsTitle;

  /// No description provided for @settingsFabricColorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Navy, cream, and other colors'**
  String get settingsFabricColorsSubtitle;

  /// No description provided for @settingsFabricColorsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fabric colors yet.'**
  String get settingsFabricColorsEmpty;

  /// No description provided for @settingsFabricColorAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add fabric color'**
  String get settingsFabricColorAddCta;

  /// No description provided for @settingsFabricColorFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get settingsFabricColorFieldLabel;

  /// No description provided for @settingsFabricColorRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename color'**
  String get settingsFabricColorRenameTitle;

  /// No description provided for @settingsFabricColorDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete fabric color?'**
  String get settingsFabricColorDeleteTitle;

  /// No description provided for @settingsFabricColorDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the color from the list. Existing orders are not changed.'**
  String get settingsFabricColorDeleteBody;

  /// No description provided for @settingsFabricActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get settingsFabricActiveLabel;

  /// No description provided for @settingsFabricInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get settingsFabricInactiveLabel;

  /// No description provided for @settingsStyleNamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloth style names'**
  String get settingsStyleNamesTitle;

  /// No description provided for @settingsStyleNamesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Qasimi, Kandahari, and custom names'**
  String get settingsStyleNamesSubtitle;

  /// No description provided for @settingsStyleNamesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No style names yet.'**
  String get settingsStyleNamesEmpty;

  /// No description provided for @settingsStyleNameAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add style name'**
  String get settingsStyleNameAddCta;

  /// No description provided for @settingsStyleNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsStyleNameFieldLabel;

  /// No description provided for @settingsStyleNameRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename style'**
  String get settingsStyleNameRenameTitle;

  /// No description provided for @settingsStyleNameDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete style?'**
  String get settingsStyleNameDeleteTitle;

  /// No description provided for @settingsStyleNameDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the name from the list. Existing orders are not changed.'**
  String get settingsStyleNameDeleteBody;

  /// No description provided for @settingsStylePartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Garment parts'**
  String get settingsStylePartsTitle;

  /// No description provided for @settingsStylePartsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sleeve, collar, pocket, and more'**
  String get settingsStylePartsSubtitle;

  /// No description provided for @settingsStylePartsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No parts yet.'**
  String get settingsStylePartsEmpty;

  /// No description provided for @settingsStylePartAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add part'**
  String get settingsStylePartAddCta;

  /// No description provided for @settingsStylePartFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Part name'**
  String get settingsStylePartFieldLabel;

  /// No description provided for @settingsStylePartRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename part'**
  String get settingsStylePartRenameTitle;

  /// No description provided for @settingsStylePartDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete part?'**
  String get settingsStylePartDeleteTitle;

  /// No description provided for @settingsStylePartDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Figures for this part are also removed.'**
  String get settingsStylePartDeleteBody;

  /// No description provided for @settingsStyleFiguresTitle.
  ///
  /// In en, this message translates to:
  /// **'Design figures'**
  String get settingsStyleFiguresTitle;

  /// No description provided for @settingsStyleFiguresSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All tailoring design images'**
  String get settingsStyleFiguresSubtitle;

  /// No description provided for @settingsStyleFiguresEmpty.
  ///
  /// In en, this message translates to:
  /// **'No design figures yet.'**
  String get settingsStyleFiguresEmpty;

  /// No description provided for @settingsStyleFigurePartLabel.
  ///
  /// In en, this message translates to:
  /// **'Garment part'**
  String get settingsStyleFigurePartLabel;

  /// No description provided for @settingsStyleFigureAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add figure'**
  String get settingsStyleFigureAddCta;

  /// No description provided for @settingsStyleFigureNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Figure name'**
  String get settingsStyleFigureNameLabel;

  /// No description provided for @settingsStyleFigureDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete figure?'**
  String get settingsStyleFigureDeleteTitle;

  /// No description provided for @settingsStyleFigureDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the design from your catalog.'**
  String get settingsStyleFigureDeleteBody;

  /// No description provided for @settingsStyleFigureWebOnlyBody.
  ///
  /// In en, this message translates to:
  /// **'Adding custom images is available on Android and iOS. Bundled figures still work on web.'**
  String get settingsStyleFigureWebOnlyBody;

  /// No description provided for @settingsStyleActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get settingsStyleActiveLabel;

  /// No description provided for @settingsStyleInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get settingsStyleInactiveLabel;

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

  /// No description provided for @deleteByTypingConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Type “{expected}” below to confirm.'**
  String deleteByTypingConfirmHint(String expected);

  /// No description provided for @deleteByTypingConfirmFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get deleteByTypingConfirmFieldLabel;

  /// No description provided for @deleteByTypingConfirmMismatch.
  ///
  /// In en, this message translates to:
  /// **'That does not match. Check spelling and try again.'**
  String get deleteByTypingConfirmMismatch;

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

  /// No description provided for @dashboardLicenseGraceBanner.
  ///
  /// In en, this message translates to:
  /// **'You have been offline too long since the server verified your license. Open Subscription and refresh while online.'**
  String get dashboardLicenseGraceBanner;

  /// No description provided for @dashboardLicenseClockTamperBanner.
  ///
  /// In en, this message translates to:
  /// **'Device time may have been changed. Connect online and refresh your license on Subscription to keep editing.'**
  String get dashboardLicenseClockTamperBanner;

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

  /// No description provided for @subscriptionGraceReadOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Read-only until the server can verify your license. Connect to the internet and tap Refresh status below.'**
  String get subscriptionGraceReadOnlyHint;

  /// No description provided for @subscriptionClockTamperHint.
  ///
  /// In en, this message translates to:
  /// **'Read-only until the server confirms your license after a device time check. Tap Refresh status while online.'**
  String get subscriptionClockTamperHint;

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
  /// **'Activation will connect to the server.'**
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

  /// No description provided for @subscriptionActivationCodeHintApi.
  ///
  /// In en, this message translates to:
  /// **'Enter the activation code from your distributor.'**
  String get subscriptionActivationCodeHintApi;

  /// No description provided for @subscriptionApplying.
  ///
  /// In en, this message translates to:
  /// **'Applying…'**
  String get subscriptionApplying;

  /// No description provided for @subscriptionRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing…'**
  String get subscriptionRefreshing;

  /// No description provided for @subscriptionRedeemSuccess.
  ///
  /// In en, this message translates to:
  /// **'License updated.'**
  String get subscriptionRedeemSuccess;

  /// No description provided for @subscriptionRedeemError.
  ///
  /// In en, this message translates to:
  /// **'Activation failed: {error}'**
  String subscriptionRedeemError(String error);

  /// No description provided for @subscriptionRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh: {error}'**
  String subscriptionRefreshError(String error);

  /// No description provided for @subscriptionBillingPlansTitle.
  ///
  /// In en, this message translates to:
  /// **'Plans & prices (AFN)'**
  String get subscriptionBillingPlansTitle;

  /// No description provided for @subscriptionBillingPrice1Year.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get subscriptionBillingPrice1Year;

  /// No description provided for @subscriptionBillingPrice2Year.
  ///
  /// In en, this message translates to:
  /// **'2 years'**
  String get subscriptionBillingPrice2Year;

  /// No description provided for @subscriptionBillingPriceLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get subscriptionBillingPriceLifetime;

  /// No description provided for @subscriptionBillingHesabPayTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay with Hesab Pay'**
  String get subscriptionBillingHesabPayTitle;

  /// No description provided for @subscriptionBillingPaymentLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan or tap to pay'**
  String get subscriptionBillingPaymentLinkTitle;

  /// No description provided for @subscriptionBillingPaymentLinkDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Open Hesab Pay payment link'**
  String get subscriptionBillingPaymentLinkDefaultLabel;

  /// No description provided for @subscriptionBillingCopyPaymentLink.
  ///
  /// In en, this message translates to:
  /// **'Copy payment link'**
  String get subscriptionBillingCopyPaymentLink;

  /// No description provided for @subscriptionBillingPaymentLinkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the payment link on this device.'**
  String get subscriptionBillingPaymentLinkOpenFailed;

  /// No description provided for @subscriptionBillingCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay in cash'**
  String get subscriptionBillingCashTitle;

  /// No description provided for @subscriptionBillingContactTitle.
  ///
  /// In en, this message translates to:
  /// **'After payment — contact support'**
  String get subscriptionBillingContactTitle;

  /// No description provided for @subscriptionBillingCopyAccount.
  ///
  /// In en, this message translates to:
  /// **'Copy account number'**
  String get subscriptionBillingCopyAccount;

  /// No description provided for @subscriptionBillingCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get subscriptionBillingCopied;

  /// No description provided for @subscriptionBillingOfflineCache.
  ///
  /// In en, this message translates to:
  /// **'Showing saved payment info from {when}. Connect to refresh.'**
  String subscriptionBillingOfflineCache(String when);

  /// No description provided for @subscriptionBillingNotPublished.
  ///
  /// In en, this message translates to:
  /// **'Payment instructions are not published yet. Ask your distributor to publish them in Developer Portal → Billing, or enter an activation code below.'**
  String get subscriptionBillingNotPublished;

  /// No description provided for @subscriptionBillingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load payment info: {error}'**
  String subscriptionBillingLoadError(String error);

  /// No description provided for @subscriptionPaymentClaimTitle.
  ///
  /// In en, this message translates to:
  /// **'I have paid (Hesab Pay)'**
  String get subscriptionPaymentClaimTitle;

  /// No description provided for @subscriptionPaymentClaimOwnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the shop owner can submit a payment claim.'**
  String get subscriptionPaymentClaimOwnerOnly;

  /// No description provided for @subscriptionPaymentClaimPlanTier.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get subscriptionPaymentClaimPlanTier;

  /// No description provided for @subscriptionPaymentClaimPlanOneYear.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get subscriptionPaymentClaimPlanOneYear;

  /// No description provided for @subscriptionPaymentClaimPlanTwoYear.
  ///
  /// In en, this message translates to:
  /// **'2 years'**
  String get subscriptionPaymentClaimPlanTwoYear;

  /// No description provided for @subscriptionPaymentClaimPlanLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get subscriptionPaymentClaimPlanLifetime;

  /// No description provided for @subscriptionPaymentClaimTransactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get subscriptionPaymentClaimTransactionId;

  /// No description provided for @subscriptionPaymentClaimTransactionHint.
  ///
  /// In en, this message translates to:
  /// **'From your Hesab Pay receipt'**
  String get subscriptionPaymentClaimTransactionHint;

  /// No description provided for @subscriptionPaymentClaimPayerPhone.
  ///
  /// In en, this message translates to:
  /// **'Your phone (optional)'**
  String get subscriptionPaymentClaimPayerPhone;

  /// No description provided for @subscriptionPaymentClaimNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get subscriptionPaymentClaimNotes;

  /// No description provided for @subscriptionPaymentClaimSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit payment claim'**
  String get subscriptionPaymentClaimSubmit;

  /// No description provided for @subscriptionPaymentClaimSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get subscriptionPaymentClaimSubmitting;

  /// No description provided for @subscriptionPaymentClaimSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment claim submitted. We will review and send your activation code.'**
  String get subscriptionPaymentClaimSubmitSuccess;

  /// No description provided for @subscriptionPaymentClaimSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Could not submit: {error}'**
  String subscriptionPaymentClaimSubmitError(String error);

  /// No description provided for @subscriptionPaymentClaimHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your payment claims'**
  String get subscriptionPaymentClaimHistoryTitle;

  /// No description provided for @subscriptionPaymentClaimStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get subscriptionPaymentClaimStatusPending;

  /// No description provided for @subscriptionPaymentClaimStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get subscriptionPaymentClaimStatusApproved;

  /// No description provided for @subscriptionPaymentClaimStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get subscriptionPaymentClaimStatusRejected;

  /// No description provided for @subscriptionPaymentClaimCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Activation code'**
  String get subscriptionPaymentClaimCodeLabel;

  /// No description provided for @subscriptionBillingWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get subscriptionBillingWhatsapp;

  /// No description provided for @subscriptionBillingTelegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get subscriptionBillingTelegram;

  /// No description provided for @subscriptionBillingPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get subscriptionBillingPhone;

  /// No description provided for @devPortalTabBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get devPortalTabBilling;

  /// No description provided for @devPortalBillingIntro.
  ///
  /// In en, this message translates to:
  /// **'Set Hesab Pay account details, payment link (QR + button for shops), prices (AFN), and payment steps in each language. Copy-paste templates: docs/BILLING_DEVELOPER_PORTAL_COPY_EN.md. Turn on Published so shops see them under Settings → Subscription. Review payment claims below.'**
  String get devPortalBillingIntro;

  /// No description provided for @devPortalBillingLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load billing profile: {error}'**
  String devPortalBillingLoadError(String error);

  /// No description provided for @devPortalBillingProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Hesab Pay profile'**
  String get devPortalBillingProfileTitle;

  /// No description provided for @devPortalBillingPublished.
  ///
  /// In en, this message translates to:
  /// **'Published (visible to shops)'**
  String get devPortalBillingPublished;

  /// No description provided for @devPortalBillingAccountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get devPortalBillingAccountName;

  /// No description provided for @devPortalBillingAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get devPortalBillingAccountNumber;

  /// No description provided for @devPortalBillingMerchantId.
  ///
  /// In en, this message translates to:
  /// **'Merchant / reference ID'**
  String get devPortalBillingMerchantId;

  /// No description provided for @devPortalBillingPaymentLink.
  ///
  /// In en, this message translates to:
  /// **'Hesab Pay payment link (HTTPS URL)'**
  String get devPortalBillingPaymentLink;

  /// No description provided for @devPortalBillingPaymentLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Full link from Hesab Pay. Shops see a QR code and open this URL.'**
  String get devPortalBillingPaymentLinkHint;

  /// No description provided for @devPortalBillingPaymentLinkLabelEn.
  ///
  /// In en, this message translates to:
  /// **'Link button name (English)'**
  String get devPortalBillingPaymentLinkLabelEn;

  /// No description provided for @devPortalBillingPaymentLinkLabelFa.
  ///
  /// In en, this message translates to:
  /// **'Link button name (Dari)'**
  String get devPortalBillingPaymentLinkLabelFa;

  /// No description provided for @devPortalBillingPaymentLinkLabelPs.
  ///
  /// In en, this message translates to:
  /// **'Link button name (Pashto)'**
  String get devPortalBillingPaymentLinkLabelPs;

  /// No description provided for @devPortalBillingPrice1Year.
  ///
  /// In en, this message translates to:
  /// **'Price 1 year (AFN)'**
  String get devPortalBillingPrice1Year;

  /// No description provided for @devPortalBillingPrice2Year.
  ///
  /// In en, this message translates to:
  /// **'Price 2 years (AFN)'**
  String get devPortalBillingPrice2Year;

  /// No description provided for @devPortalBillingPriceLifetime.
  ///
  /// In en, this message translates to:
  /// **'Price lifetime (AFN)'**
  String get devPortalBillingPriceLifetime;

  /// No description provided for @devPortalBillingPaymentStepsEn.
  ///
  /// In en, this message translates to:
  /// **'Payment steps (English)'**
  String get devPortalBillingPaymentStepsEn;

  /// No description provided for @devPortalBillingPaymentStepsFa.
  ///
  /// In en, this message translates to:
  /// **'Payment steps (Dari)'**
  String get devPortalBillingPaymentStepsFa;

  /// No description provided for @devPortalBillingPaymentStepsPs.
  ///
  /// In en, this message translates to:
  /// **'Payment steps (Pashto)'**
  String get devPortalBillingPaymentStepsPs;

  /// No description provided for @devPortalBillingActivationStepsEn.
  ///
  /// In en, this message translates to:
  /// **'Activation delivery (English)'**
  String get devPortalBillingActivationStepsEn;

  /// No description provided for @devPortalBillingActivationStepsFa.
  ///
  /// In en, this message translates to:
  /// **'Activation delivery (Dari)'**
  String get devPortalBillingActivationStepsFa;

  /// No description provided for @devPortalBillingActivationStepsPs.
  ///
  /// In en, this message translates to:
  /// **'Activation delivery (Pashto)'**
  String get devPortalBillingActivationStepsPs;

  /// No description provided for @devPortalBillingCashNoteEn.
  ///
  /// In en, this message translates to:
  /// **'Cash payment note (English)'**
  String get devPortalBillingCashNoteEn;

  /// No description provided for @devPortalBillingCashNoteFa.
  ///
  /// In en, this message translates to:
  /// **'Cash payment note (Dari)'**
  String get devPortalBillingCashNoteFa;

  /// No description provided for @devPortalBillingCashNotePs.
  ///
  /// In en, this message translates to:
  /// **'Cash payment note (Pashto)'**
  String get devPortalBillingCashNotePs;

  /// No description provided for @devPortalBillingWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp (E.164)'**
  String get devPortalBillingWhatsapp;

  /// No description provided for @devPortalBillingTelegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram handle'**
  String get devPortalBillingTelegram;

  /// No description provided for @devPortalBillingPhone.
  ///
  /// In en, this message translates to:
  /// **'Direct phone (E.164)'**
  String get devPortalBillingPhone;

  /// No description provided for @devPortalBillingSave.
  ///
  /// In en, this message translates to:
  /// **'Save billing profile'**
  String get devPortalBillingSave;

  /// No description provided for @devPortalBillingSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Billing profile saved.'**
  String get devPortalBillingSaveSuccess;

  /// No description provided for @devPortalBillingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String devPortalBillingSaveError(String error);

  /// No description provided for @devPortalBillingClaimsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment claims'**
  String get devPortalBillingClaimsTitle;

  /// No description provided for @devPortalBillingClaimsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get devPortalBillingClaimsPending;

  /// No description provided for @devPortalBillingClaimsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get devPortalBillingClaimsAll;

  /// No description provided for @devPortalBillingClaimApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve & create code'**
  String get devPortalBillingClaimApprove;

  /// No description provided for @devPortalBillingClaimReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get devPortalBillingClaimReject;

  /// No description provided for @devPortalBillingClaimRejectNotes.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get devPortalBillingClaimRejectNotes;

  /// No description provided for @devPortalBillingClaimApproved.
  ///
  /// In en, this message translates to:
  /// **'Claim approved.'**
  String get devPortalBillingClaimApproved;

  /// No description provided for @devPortalBillingClaimRejected.
  ///
  /// In en, this message translates to:
  /// **'Claim rejected.'**
  String get devPortalBillingClaimRejected;

  /// No description provided for @devPortalBillingNoClaims.
  ///
  /// In en, this message translates to:
  /// **'No payment claims.'**
  String get devPortalBillingNoClaims;

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

  /// No description provided for @orderDeleteMenu.
  ///
  /// In en, this message translates to:
  /// **'Delete order'**
  String get orderDeleteMenu;

  /// No description provided for @orderDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this order?'**
  String get orderDeleteConfirmTitle;

  /// No description provided for @orderDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The order will be removed from your list on this device.'**
  String get orderDeleteConfirmBody;

  /// No description provided for @orderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Order removed'**
  String get orderDeleted;

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

  /// No description provided for @customersRowSince.
  ///
  /// In en, this message translates to:
  /// **'Customer since {date}'**
  String customersRowSince(String date);

  /// No description provided for @reportsThisMonthIncomeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded this month yet.'**
  String get reportsThisMonthIncomeEmpty;

  /// No description provided for @reportsOpenUnpaidEmpty.
  ///
  /// In en, this message translates to:
  /// **'No open orders with a remaining balance.'**
  String get reportsOpenUnpaidEmpty;

  /// No description provided for @reportsOrdersByStatusCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 order} other{{count} orders}}'**
  String reportsOrdersByStatusCount(int count);

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

  /// No description provided for @settingsUsersLimitsBodyTrial.
  ///
  /// In en, this message translates to:
  /// **'Trial: up to {max} users. {count} in use. The owner account cannot be deleted.'**
  String settingsUsersLimitsBodyTrial(int max, int count);

  /// No description provided for @settingsUsersLimitsBodyPaid.
  ///
  /// In en, this message translates to:
  /// **'Up to {max} users for this shop. {count} in use. The owner account cannot be deleted.'**
  String settingsUsersLimitsBodyPaid(int max, int count);

  /// No description provided for @settingsUsersAtLimit.
  ///
  /// In en, this message translates to:
  /// **'User limit reached ({count} of {max}).'**
  String settingsUsersAtLimit(int count, int max);

  /// No description provided for @settingsUsersLimitsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load user limits: {error}. Tap Retry or try Add user (the server will enforce limits).'**
  String settingsUsersLimitsLoadFailed(String error);

  /// No description provided for @settingsUsersLicenseExpired.
  ///
  /// In en, this message translates to:
  /// **'Your shop license has expired. Renew or activate before adding users.'**
  String get settingsUsersLicenseExpired;

  /// No description provided for @settingsUsersNotOwnerBanner.
  ///
  /// In en, this message translates to:
  /// **'Signed in as a team member. Only the shop owner account can add or remove users.'**
  String get settingsUsersNotOwnerBanner;

  /// No description provided for @settingsUsersNeedOnline.
  ///
  /// In en, this message translates to:
  /// **'Stay online and signed in with the server to manage users.'**
  String get settingsUsersNeedOnline;

  /// No description provided for @settingsUsersOfflineCacheNote.
  ///
  /// In en, this message translates to:
  /// **'Offline — showing the last saved team list. Connect to refresh or add users.'**
  String get settingsUsersOfflineCacheNote;

  /// No description provided for @devPortalOfflineCacheNote.
  ///
  /// In en, this message translates to:
  /// **'Offline — showing last saved data. Connect to refresh or make changes.'**
  String get devPortalOfflineCacheNote;

  /// No description provided for @settingsUsersTileNeedApiSession.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the server to manage users'**
  String get settingsUsersTileNeedApiSession;

  /// No description provided for @settingsUsersAddCta.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get settingsUsersAddCta;

  /// No description provided for @settingsUsersAddDisabledHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the server and stay online to add or remove users.'**
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

  /// No description provided for @settingsUsersSubtitleTeam.
  ///
  /// In en, this message translates to:
  /// **'View accounts on the server (read-only unless you are the owner).'**
  String get settingsUsersSubtitleTeam;

  /// No description provided for @settingsUsersLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load users: {error}'**
  String settingsUsersLoadError(String error);

  /// No description provided for @settingsUsersRetryCta.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get settingsUsersRetryCta;

  /// No description provided for @settingsUsersDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove user?'**
  String get settingsUsersDeleteConfirmTitle;

  /// No description provided for @settingsUsersDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'They will no longer be able to sign in.'**
  String get settingsUsersDeleteConfirmBody;

  /// No description provided for @settingsUsersDeleteCta.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get settingsUsersDeleteCta;

  /// No description provided for @settingsUsersAddDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get settingsUsersAddDialogTitle;

  /// No description provided for @settingsUsersAddUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get settingsUsersAddUsernameLabel;

  /// No description provided for @settingsUsersAddPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get settingsUsersAddPasswordLabel;

  /// No description provided for @settingsUsersAddSubmitCta.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get settingsUsersAddSubmitCta;

  /// No description provided for @settingsUsersAddError.
  ///
  /// In en, this message translates to:
  /// **'Could not add user: {error}'**
  String settingsUsersAddError(String error);

  /// No description provided for @settingsUsersAddedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'User created.'**
  String get settingsUsersAddedSnackbar;

  /// No description provided for @settingsUsersRemovedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'User removed.'**
  String get settingsUsersRemovedSnackbar;

  /// No description provided for @settingsBackupOwnerPasswordNote.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore will require the owner’s login password.'**
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
  /// **'Filters'**
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

  /// No description provided for @settingsNotificationsInboxFilterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications match this filter.'**
  String get settingsNotificationsInboxFilterEmpty;

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

  /// No description provided for @settingsSyncLocalSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Local data snapshot'**
  String get settingsSyncLocalSnapshotTitle;

  /// No description provided for @settingsSyncLocalOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get settingsSyncLocalOrders;

  /// No description provided for @settingsSyncLocalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get settingsSyncLocalCustomers;

  /// No description provided for @settingsSyncLocalPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get settingsSyncLocalPayments;

  /// No description provided for @settingsSyncLocalTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get settingsSyncLocalTasks;

  /// No description provided for @settingsSyncLocalNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsSyncLocalNotifications;

  /// No description provided for @settingsSyncLocalUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications'**
  String get settingsSyncLocalUnread;

  /// No description provided for @settingsSyncRetryTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get settingsSyncRetryTitle;

  /// No description provided for @settingsSyncRetrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pull from the server, then push the local queue when API_BASE_URL is set and you are signed in online.'**
  String get settingsSyncRetrySubtitle;

  /// No description provided for @settingsSyncRetryOffline.
  ///
  /// In en, this message translates to:
  /// **'You appear offline. Connect to the internet and try again.'**
  String get settingsSyncRetryOffline;

  /// No description provided for @settingsSyncRetryConfigureApi.
  ///
  /// In en, this message translates to:
  /// **'Set API_BASE_URL at build time, then open Settings → API connection.'**
  String get settingsSyncRetryConfigureApi;

  /// No description provided for @settingsSyncRetrySignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your online server account first.'**
  String get settingsSyncRetrySignIn;

  /// No description provided for @settingsSyncRetryLicenseExpired.
  ///
  /// In en, this message translates to:
  /// **'The server refused sync because the license is expired. Open Subscription.'**
  String get settingsSyncRetryLicenseExpired;

  /// No description provided for @settingsSyncRetryEditingBlocked.
  ///
  /// In en, this message translates to:
  /// **'Sync is paused in read-only mode. Open Subscription when you are online.'**
  String get settingsSyncRetryEditingBlocked;

  /// No description provided for @settingsSyncRetrySuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync OK: pushed {pushed} mutation(s); received {pulled} server change(s).'**
  String settingsSyncRetrySuccess(int pushed, int pulled);

  /// No description provided for @settingsSyncRetryFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {detail}'**
  String settingsSyncRetryFailed(String detail);

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

  /// No description provided for @settingsDiagnosticsExportBusy.
  ///
  /// In en, this message translates to:
  /// **'Preparing bundle…'**
  String get settingsDiagnosticsExportBusy;

  /// No description provided for @settingsDiagnosticsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics bundle ready to share.'**
  String get settingsDiagnosticsExportSuccess;

  /// No description provided for @settingsDiagnosticsExportError.
  ///
  /// In en, this message translates to:
  /// **'Could not export diagnostics: {error}'**
  String settingsDiagnosticsExportError(String error);

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

  /// No description provided for @devPortalTabAccount.
  ///
  /// In en, this message translates to:
  /// **'My password'**
  String get devPortalTabAccount;

  /// No description provided for @devPortalMyPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change your password'**
  String get devPortalMyPasswordTitle;

  /// No description provided for @devPortalMyPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be changed here. Use your current password, then choose a new one (at least 6 characters).'**
  String get devPortalMyPasswordSubtitle;

  /// No description provided for @devPortalCurrentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get devPortalCurrentPasswordLabel;

  /// No description provided for @devPortalNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get devPortalNewPasswordLabel;

  /// No description provided for @devPortalConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get devPortalConfirmPasswordLabel;

  /// No description provided for @devPortalPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'New password and confirmation do not match.'**
  String get devPortalPasswordMismatch;

  /// No description provided for @devPortalChangePasswordCta.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get devPortalChangePasswordCta;

  /// No description provided for @devPortalChangePasswordOk.
  ///
  /// In en, this message translates to:
  /// **'Password updated. Use the new password next time you sign in.'**
  String get devPortalChangePasswordOk;

  /// No description provided for @devPortalChangePasswordFail.
  ///
  /// In en, this message translates to:
  /// **'Could not update password.'**
  String get devPortalChangePasswordFail;

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

  /// No description provided for @devPortalAdviceOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'You appear offline'**
  String get devPortalAdviceOfflineTitle;

  /// No description provided for @devPortalAdviceOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to test public API health. Admin lists (shops, codes, resets) need the deployed admin APIs.'**
  String get devPortalAdviceOfflineBody;

  /// No description provided for @devPortalAdviceOnlineTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer tools'**
  String get devPortalAdviceOnlineTitle;

  /// No description provided for @devPortalAdviceOnlineBody.
  ///
  /// In en, this message translates to:
  /// **'Use Billing to publish Hesab Pay instructions for all shops. Overview shows API health and stats. Codes, Shops, and Resets need a developer account on the API.'**
  String get devPortalAdviceOnlineBody;

  /// No description provided for @devPortalShopsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No shops on the server yet.'**
  String get devPortalShopsEmpty;

  /// No description provided for @devPortalShopRowUsers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 user} other{{count} users}}'**
  String devPortalShopRowUsers(int count);

  /// No description provided for @devPortalShopSignedUp.
  ///
  /// In en, this message translates to:
  /// **'Signed up: {date}'**
  String devPortalShopSignedUp(String date);

  /// No description provided for @devPortalShopTrialStarted.
  ///
  /// In en, this message translates to:
  /// **'Trial started: {date}'**
  String devPortalShopTrialStarted(String date);

  /// No description provided for @devPortalShopUsersHeader.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get devPortalShopUsersHeader;

  /// No description provided for @devPortalShopUserOwnerBadge.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get devPortalShopUserOwnerBadge;

  /// No description provided for @devPortalShopUserDeletedBadge.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get devPortalShopUserDeletedBadge;

  /// No description provided for @devPortalShopUserPasswordNote.
  ///
  /// In en, this message translates to:
  /// **'Password is stored hashed on the server. Use the Password resets tab to set a new one.'**
  String get devPortalShopUserPasswordNote;

  /// No description provided for @devPortalShopDisabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get devPortalShopDisabledLabel;

  /// No description provided for @devPortalShopActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Shop actions'**
  String get devPortalShopActionsTooltip;

  /// No description provided for @devPortalShopDisableCta.
  ///
  /// In en, this message translates to:
  /// **'Disable shop'**
  String get devPortalShopDisableCta;

  /// No description provided for @devPortalShopEnableCta.
  ///
  /// In en, this message translates to:
  /// **'Enable shop'**
  String get devPortalShopEnableCta;

  /// No description provided for @devPortalShopExtendCta.
  ///
  /// In en, this message translates to:
  /// **'Extend license…'**
  String get devPortalShopExtendCta;

  /// No description provided for @devPortalShopExtendTitle.
  ///
  /// In en, this message translates to:
  /// **'Extend license'**
  String get devPortalShopExtendTitle;

  /// No description provided for @devPortalShopExtendHint.
  ///
  /// In en, this message translates to:
  /// **'Days to add from today or current expiry (whichever is later).'**
  String get devPortalShopExtendHint;

  /// No description provided for @devPortalShopExtendDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get devPortalShopExtendDaysLabel;

  /// No description provided for @devPortalShopSetMaxUsersCta.
  ///
  /// In en, this message translates to:
  /// **'Set user limit…'**
  String get devPortalShopSetMaxUsersCta;

  /// No description provided for @devPortalShopSetMaxUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'User limit (paid shop)'**
  String get devPortalShopSetMaxUsersTitle;

  /// No description provided for @devPortalShopSetMaxUsersHint.
  ///
  /// In en, this message translates to:
  /// **'Maximum active users including the owner (1–20). Cannot be less than current users.'**
  String get devPortalShopSetMaxUsersHint;

  /// No description provided for @devPortalShopMaxUsersLabel.
  ///
  /// In en, this message translates to:
  /// **'Max users'**
  String get devPortalShopMaxUsersLabel;

  /// No description provided for @devPortalShopRowMaxUsers.
  ///
  /// In en, this message translates to:
  /// **'Limit: {max} users ({count} in use)'**
  String devPortalShopRowMaxUsers(int max, int count);

  /// No description provided for @devPortalShopTrialUserLimitNote.
  ///
  /// In en, this message translates to:
  /// **'Trial: 2 users (fixed)'**
  String get devPortalShopTrialUserLimitNote;

  /// No description provided for @devPortalShopActionOk.
  ///
  /// In en, this message translates to:
  /// **'Done.'**
  String get devPortalShopActionOk;

  /// No description provided for @devPortalShopPushTestCta.
  ///
  /// In en, this message translates to:
  /// **'Test push…'**
  String get devPortalShopPushTestCta;

  /// No description provided for @devPortalShopPushTitle.
  ///
  /// In en, this message translates to:
  /// **'Test push notification'**
  String get devPortalShopPushTitle;

  /// No description provided for @devPortalShopPushNotifTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification title'**
  String get devPortalShopPushNotifTitleLabel;

  /// No description provided for @devPortalShopPushBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get devPortalShopPushBodyLabel;

  /// No description provided for @devPortalShopPushResult.
  ///
  /// In en, this message translates to:
  /// **'Sent: {success}, failed: {failed}. Reason: {reason}.'**
  String devPortalShopPushResult(int success, int failed, String reason);

  /// No description provided for @devPortalCodesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load codes: {error}'**
  String devPortalCodesLoadError(String error);

  /// No description provided for @devPortalCodesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activation codes yet. Generate one to issue paid time.'**
  String get devPortalCodesEmpty;

  /// No description provided for @devPortalCodesCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'New activation code'**
  String get devPortalCodesCreateTitle;

  /// No description provided for @devPortalCodesPlanDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid days added on redeem'**
  String get devPortalCodesPlanDaysLabel;

  /// No description provided for @devPortalCodesMaxUsesLabel.
  ///
  /// In en, this message translates to:
  /// **'Max redemptions'**
  String get devPortalCodesMaxUsesLabel;

  /// No description provided for @devPortalCodesCreateCta.
  ///
  /// In en, this message translates to:
  /// **'Generate code'**
  String get devPortalCodesCreateCta;

  /// No description provided for @devPortalCodesCreated.
  ///
  /// In en, this message translates to:
  /// **'Created: {code}'**
  String devPortalCodesCreated(String code);

  /// No description provided for @devPortalCodesCreateFail.
  ///
  /// In en, this message translates to:
  /// **'Could not create code.'**
  String get devPortalCodesCreateFail;

  /// No description provided for @devPortalCodesRevokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke code'**
  String get devPortalCodesRevokeTitle;

  /// No description provided for @devPortalCodesRevokeBody.
  ///
  /// In en, this message translates to:
  /// **'Shops can no longer redeem “{code}”.'**
  String devPortalCodesRevokeBody(String code);

  /// No description provided for @devPortalCodesRevoked.
  ///
  /// In en, this message translates to:
  /// **'Code revoked.'**
  String get devPortalCodesRevoked;

  /// No description provided for @devPortalCodesRevokeFail.
  ///
  /// In en, this message translates to:
  /// **'Could not revoke.'**
  String get devPortalCodesRevokeFail;

  /// No description provided for @devPortalCodesRevokeCta.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get devPortalCodesRevokeCta;

  /// No description provided for @devPortalCodesDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Activation code'**
  String get devPortalCodesDetailTitle;

  /// No description provided for @devPortalCodesCopyCta.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get devPortalCodesCopyCta;

  /// No description provided for @devPortalCodesShareCta.
  ///
  /// In en, this message translates to:
  /// **'Share code'**
  String get devPortalCodesShareCta;

  /// No description provided for @devPortalCodesCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard.'**
  String get devPortalCodesCopied;

  /// No description provided for @devPortalCodesShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Afghan Pride activation code'**
  String get devPortalCodesShareSubject;

  /// No description provided for @devPortalCodesShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Afghan Pride — subscription activation\n\nCode: {code}\nPaid days when redeemed: {days}\n\nIn the shop app: Settings → Subscription → enter this code.\nSingle-use unless noted otherwise.'**
  String devPortalCodesShareMessage(String code, int days);

  /// No description provided for @devPortalApiHealthPrompt.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh and call GET /health.'**
  String get devPortalApiHealthPrompt;

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
  /// **'Code creates (audit)'**
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
  /// **'Activation codes: search, create, and revoke will load from the admin API.'**
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
  /// **'For a full device bundle, use Settings → Sync & Diagnostics → Export diagnostics bundle.'**
  String get devPortalDiagStub;

  /// No description provided for @devPortalDiagLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'This device (offline cache)'**
  String get devPortalDiagLocalTitle;

  /// No description provided for @devPortalDiagLocalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Counts from local storage — useful when the admin API is offline.'**
  String get devPortalDiagLocalSubtitle;

  /// No description provided for @devPortalDiagCountLoading.
  ///
  /// In en, this message translates to:
  /// **'…'**
  String get devPortalDiagCountLoading;

  /// No description provided for @devPortalAdminAuditTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin audit log'**
  String get devPortalAdminAuditTitle;

  /// No description provided for @devPortalAdminAuditNeedSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with the API, then pull to refresh.'**
  String get devPortalAdminAuditNeedSignIn;

  /// No description provided for @devPortalAdminAuditLine.
  ///
  /// In en, this message translates to:
  /// **'GET /admin/audit-log — {count} row(s), schema v{schema}'**
  String devPortalAdminAuditLine(int count, int schema);

  /// No description provided for @settingsShopProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop profile'**
  String get settingsShopProfileTitle;

  /// No description provided for @shopProfileIntro.
  ///
  /// In en, this message translates to:
  /// **'Name, logo, address, and thank-you message appear on printed receipts and shared invoices. Notes below are for your own reference only.'**
  String get shopProfileIntro;

  /// No description provided for @shopProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop name'**
  String get shopProfileNameLabel;

  /// No description provided for @shopProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Karzai Tailoring Shop'**
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
  /// **'Example: 0701234567'**
  String get shopProfileShopPhoneHint;

  /// No description provided for @shopProfileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get shopProfileAddressLabel;

  /// No description provided for @shopProfileAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Karte Char, Kabul'**
  String get shopProfileAddressHint;

  /// No description provided for @shopProfileReceiptThanksLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt thank-you message (optional)'**
  String get shopProfileReceiptThanksLabel;

  /// No description provided for @shopProfileReceiptThanksHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Thank you for your business!'**
  String get shopProfileReceiptThanksHint;

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

  /// No description provided for @settingsSectionPrinter.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get settingsSectionPrinter;

  /// No description provided for @settingsPrinterTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Thermal printer'**
  String get settingsPrinterTileTitle;

  /// No description provided for @settingsPrinterTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Network receipt printer (58 / 80 mm)'**
  String get settingsPrinterTileSubtitle;

  /// No description provided for @settingsPrinterScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Thermal printer'**
  String get settingsPrinterScreenTitle;

  /// No description provided for @settingsPrinterIntro.
  ///
  /// In en, this message translates to:
  /// **'Send receipts to a network ESC/POS printer (usually raw TCP on port 9100). Enter the printer’s IP address or hostname on your Wi‑Fi or LAN.'**
  String get settingsPrinterIntro;

  /// No description provided for @settingsPrinterAsciiNotice.
  ///
  /// In en, this message translates to:
  /// **'Receipts use a simple printer character set. Names or notes outside Latin letters and digits may print as “?” on the slip.'**
  String get settingsPrinterAsciiNotice;

  /// No description provided for @settingsPrinterHostLabel.
  ///
  /// In en, this message translates to:
  /// **'Printer address'**
  String get settingsPrinterHostLabel;

  /// No description provided for @settingsPrinterHostHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 192.168.1.50'**
  String get settingsPrinterHostHint;

  /// No description provided for @settingsPrinterPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get settingsPrinterPortLabel;

  /// No description provided for @settingsPrinterPaperWidthLabel.
  ///
  /// In en, this message translates to:
  /// **'Paper width'**
  String get settingsPrinterPaperWidthLabel;

  /// No description provided for @settingsPrinterPaper58Label.
  ///
  /// In en, this message translates to:
  /// **'58 mm'**
  String get settingsPrinterPaper58Label;

  /// No description provided for @settingsPrinterPaper80Label.
  ///
  /// In en, this message translates to:
  /// **'80 mm'**
  String get settingsPrinterPaper80Label;

  /// No description provided for @settingsPrinterSaved.
  ///
  /// In en, this message translates to:
  /// **'Printer settings saved.'**
  String get settingsPrinterSaved;

  /// No description provided for @settingsPrinterTestCta.
  ///
  /// In en, this message translates to:
  /// **'Test print'**
  String get settingsPrinterTestCta;

  /// No description provided for @settingsPrinterTestHeadline.
  ///
  /// In en, this message translates to:
  /// **'Afghan Pride'**
  String get settingsPrinterTestHeadline;

  /// No description provided for @settingsPrinterTestDetail.
  ///
  /// In en, this message translates to:
  /// **'Test print — if you can read this, the connection works.'**
  String get settingsPrinterTestDetail;

  /// No description provided for @settingsPrinterTestOk.
  ///
  /// In en, this message translates to:
  /// **'Test page sent to the printer.'**
  String get settingsPrinterTestOk;

  /// No description provided for @settingsPrinterTestFail.
  ///
  /// In en, this message translates to:
  /// **'Test print failed: {detail}'**
  String settingsPrinterTestFail(String detail);

  /// No description provided for @settingsPrinterWebUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Thermal printing is available on the Android and iOS apps. Use a device with the app installed to print; the web app does not send jobs to hardware printers.'**
  String get settingsPrinterWebUnavailable;

  /// No description provided for @settingsPrinterHostEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Enter the printer address to save or test.'**
  String get settingsPrinterHostEmptyError;

  /// No description provided for @settingsPrinterPortInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid port (1–65535).'**
  String get settingsPrinterPortInvalidError;

  /// No description provided for @orderPrintReceiptTooltip.
  ///
  /// In en, this message translates to:
  /// **'Print receipt'**
  String get orderPrintReceiptTooltip;

  /// No description provided for @orderPrintReceiptNeedPrinter.
  ///
  /// In en, this message translates to:
  /// **'Set the printer address under Settings → Thermal printer.'**
  String get orderPrintReceiptNeedPrinter;

  /// No description provided for @orderPrintReceiptOk.
  ///
  /// In en, this message translates to:
  /// **'Receipt sent to the printer.'**
  String get orderPrintReceiptOk;

  /// No description provided for @orderPrintReceiptFail.
  ///
  /// In en, this message translates to:
  /// **'Printing failed: {detail}'**
  String orderPrintReceiptFail(String detail);

  /// No description provided for @receiptCustomerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get receiptCustomerLabel;

  /// No description provided for @receiptPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get receiptPhoneLabel;

  /// No description provided for @receiptDeliveryLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get receiptDeliveryLabel;

  /// No description provided for @receiptStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get receiptStatusLabel;

  /// No description provided for @receiptMeasurementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get receiptMeasurementsLabel;

  /// No description provided for @invoicePridePromoLine.
  ///
  /// In en, this message translates to:
  /// **'Invoice created and sent with Afghan Pride'**
  String get invoicePridePromoLine;

  /// No description provided for @receiptStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Style notes'**
  String get receiptStyleLabel;

  /// No description provided for @receiptFabricLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer fabric'**
  String get receiptFabricLabel;

  /// No description provided for @receiptFabricNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Fabric'**
  String get receiptFabricNameLabel;

  /// No description provided for @receiptFabricColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get receiptFabricColorLabel;

  /// No description provided for @receiptFabricIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Fabric ID'**
  String get receiptFabricIdLabel;

  /// No description provided for @orderDetailFabricTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer fabric'**
  String get orderDetailFabricTitle;

  /// No description provided for @receiptInternalNotesHeader.
  ///
  /// In en, this message translates to:
  /// **'Internal notes'**
  String get receiptInternalNotesHeader;

  /// No description provided for @receiptTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get receiptTotalLabel;

  /// No description provided for @receiptPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get receiptPaidLabel;

  /// No description provided for @receiptBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get receiptBalanceLabel;

  /// No description provided for @receiptPaymentsHeader.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get receiptPaymentsHeader;

  /// No description provided for @receiptShopPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop phone'**
  String get receiptShopPhoneLabel;

  /// No description provided for @receiptShopAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get receiptShopAddressLabel;

  /// No description provided for @receiptShareDivider.
  ///
  /// In en, this message translates to:
  /// **'--------------------------------'**
  String get receiptShareDivider;

  /// No description provided for @receiptShareSectionRule.
  ///
  /// In en, this message translates to:
  /// **'================================'**
  String get receiptShareSectionRule;

  /// No description provided for @settingsPrinterRetryHint.
  ///
  /// In en, this message translates to:
  /// **'If the printer is busy, the app retries the connection a few times automatically.'**
  String get settingsPrinterRetryHint;

  /// No description provided for @shopProfileLogoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice header logo'**
  String get shopProfileLogoSectionTitle;

  /// No description provided for @shopProfileLogoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shown at the top of thermal receipts and shared invoice text (Android / iOS). Square images work best.'**
  String get shopProfileLogoSubtitle;

  /// No description provided for @shopProfileLogoPickCta.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get shopProfileLogoPickCta;

  /// No description provided for @shopProfileLogoRemoveCta.
  ///
  /// In en, this message translates to:
  /// **'Remove logo'**
  String get shopProfileLogoRemoveCta;

  /// No description provided for @shopProfileLogoSaved.
  ///
  /// In en, this message translates to:
  /// **'Logo saved.'**
  String get shopProfileLogoSaved;

  /// No description provided for @shopProfileLogoWebHint.
  ///
  /// In en, this message translates to:
  /// **'Logo upload is available in the Android and iOS apps.'**
  String get shopProfileLogoWebHint;

  /// No description provided for @shopProfileLogoStatusOnFile.
  ///
  /// In en, this message translates to:
  /// **'Logo saved on this device for receipts.'**
  String get shopProfileLogoStatusOnFile;

  /// No description provided for @shopProfileLogoDefaultCaption.
  ///
  /// In en, this message translates to:
  /// **'Default logo on receipts until you upload your own.'**
  String get shopProfileLogoDefaultCaption;

  /// No description provided for @defaultShopName.
  ///
  /// In en, this message translates to:
  /// **'My tailoring shop'**
  String get defaultShopName;

  /// No description provided for @defaultShopAddress.
  ///
  /// In en, this message translates to:
  /// **'Kabul, Afghanistan'**
  String get defaultShopAddress;

  /// No description provided for @defaultShopPhone.
  ///
  /// In en, this message translates to:
  /// **'0701234567'**
  String get defaultShopPhone;

  /// No description provided for @orderShareInvoiceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share invoice'**
  String get orderShareInvoiceTooltip;

  /// No description provided for @orderShareInvoicePdfCta.
  ///
  /// In en, this message translates to:
  /// **'Share PDF invoice'**
  String get orderShareInvoicePdfCta;

  /// No description provided for @orderShareContactPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission is off — invoice shared, but the customer was not saved to your phone.'**
  String get orderShareContactPermissionDenied;

  /// No description provided for @orderShareInvoiceSharedSheet.
  ///
  /// In en, this message translates to:
  /// **'Choose WhatsApp or another app to send the PDF invoice.'**
  String get orderShareInvoiceSharedSheet;

  /// No description provided for @orderShareInvoiceFail.
  ///
  /// In en, this message translates to:
  /// **'Share failed: {detail}'**
  String orderShareInvoiceFail(String detail);

  /// No description provided for @orderShareInvoiceSubject.
  ///
  /// In en, this message translates to:
  /// **'Order {orderNo}'**
  String orderShareInvoiceSubject(String orderNo);

  /// No description provided for @orderShareInvoiceWhatsappCaption.
  ///
  /// In en, this message translates to:
  /// **'Invoice for order {orderNo} — {customerName}'**
  String orderShareInvoiceWhatsappCaption(String orderNo, String customerName);

  /// No description provided for @orderShareContactSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved {name} to your phone contacts.'**
  String orderShareContactSaved(String name);

  /// No description provided for @orderShareWhatsappOpened.
  ///
  /// In en, this message translates to:
  /// **'Invoice PDF opened in WhatsApp.'**
  String get orderShareWhatsappOpened;

  /// No description provided for @orderShareWhatsappPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Add a valid customer phone number to share the invoice on WhatsApp.'**
  String get orderShareWhatsappPhoneInvalid;

  /// No description provided for @receiptFooterThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business!'**
  String get receiptFooterThanks;

  /// No description provided for @settingsDeveloperPortalCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify developer access. Tap to retry.'**
  String get settingsDeveloperPortalCheckFailed;

  /// No description provided for @settingsDeveloperPortalRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get settingsDeveloperPortalRetry;

  /// No description provided for @dashboardSyncRunning.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get dashboardSyncRunning;

  /// No description provided for @dashboardSyncTapToRun.
  ///
  /// In en, this message translates to:
  /// **'Tap to sync now'**
  String get dashboardSyncTapToRun;

  /// No description provided for @dashboardTasksSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get dashboardTasksSectionTitle;

  /// No description provided for @dashboardTasksOpenCount.
  ///
  /// In en, this message translates to:
  /// **'{count} open'**
  String dashboardTasksOpenCount(int count);

  /// No description provided for @dashboardTasksViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all tasks'**
  String get dashboardTasksViewAll;

  /// No description provided for @shopFinanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop finance'**
  String get shopFinanceTitle;

  /// No description provided for @shopFinanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rent, daily costs, and food & drinks'**
  String get shopFinanceSubtitle;

  /// No description provided for @shopFinanceOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get shopFinanceOverviewTitle;

  /// No description provided for @shopFinanceRentTitle.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get shopFinanceRentTitle;

  /// No description provided for @shopFinanceExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get shopFinanceExpensesTitle;

  /// No description provided for @shopFinanceMonthOutflow.
  ///
  /// In en, this message translates to:
  /// **'This month outflow'**
  String get shopFinanceMonthOutflow;

  /// No description provided for @shopFinanceRentDue.
  ///
  /// In en, this message translates to:
  /// **'Rent due'**
  String get shopFinanceRentDue;

  /// No description provided for @shopFinanceRentPaid.
  ///
  /// In en, this message translates to:
  /// **'Rent paid this month'**
  String get shopFinanceRentPaid;

  /// No description provided for @shopFinanceExpenseDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily expenses'**
  String get shopFinanceExpenseDaily;

  /// No description provided for @shopFinanceExpenseFood.
  ///
  /// In en, this message translates to:
  /// **'Food & drinks'**
  String get shopFinanceExpenseFood;

  /// No description provided for @shopFinanceExpenseOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get shopFinanceExpenseOther;

  /// No description provided for @shopFinanceAddRent.
  ///
  /// In en, this message translates to:
  /// **'Set rent'**
  String get shopFinanceAddRent;

  /// No description provided for @shopFinanceRecordRentPayment.
  ///
  /// In en, this message translates to:
  /// **'Record rent payment'**
  String get shopFinanceRecordRentPayment;

  /// No description provided for @shopFinanceAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get shopFinanceAddExpense;

  /// No description provided for @shopFinanceAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (AFN)'**
  String get shopFinanceAmountLabel;

  /// No description provided for @shopFinanceDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get shopFinanceDueDateLabel;

  /// No description provided for @shopFinancePeriodMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Period (months)'**
  String get shopFinancePeriodMonthsLabel;

  /// No description provided for @shopFinanceNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get shopFinanceNoteLabel;

  /// No description provided for @shopFinanceCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get shopFinanceCategoryLabel;

  /// No description provided for @shopFinanceDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get shopFinanceDateLabel;

  /// No description provided for @shopFinanceClearPeriodTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear old expenses?'**
  String get shopFinanceClearPeriodTitle;

  /// No description provided for @shopFinanceClearPeriodBody.
  ///
  /// In en, this message translates to:
  /// **'Expenses before the selected date will be removed from your list.'**
  String get shopFinanceClearPeriodBody;

  /// No description provided for @shopFinanceRentDueNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Rent due soon'**
  String get shopFinanceRentDueNotificationTitle;

  /// No description provided for @shopFinanceRentDueNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Rent of {amount} is due on {date}'**
  String shopFinanceRentDueNotificationBody(String amount, String date);

  /// No description provided for @shopFinanceEmptyRent.
  ///
  /// In en, this message translates to:
  /// **'No rent schedule yet. Set your monthly rent.'**
  String get shopFinanceEmptyRent;

  /// No description provided for @shopFinanceEmptyExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded yet.'**
  String get shopFinanceEmptyExpenses;

  /// No description provided for @shopFinanceSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get shopFinanceSave;

  /// No description provided for @shopFinanceChartsExpensesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expenses by category'**
  String get shopFinanceChartsExpensesByCategory;

  /// No description provided for @appGuideCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close tip'**
  String get appGuideCloseTooltip;

  /// No description provided for @appGuideSkipAll.
  ///
  /// In en, this message translates to:
  /// **'Skip all tips'**
  String get appGuideSkipAll;

  /// No description provided for @appGuideGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get appGuideGotIt;

  /// No description provided for @appGuideOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get appGuideOrdersTitle;

  /// No description provided for @appGuideOrdersBody.
  ///
  /// In en, this message translates to:
  /// **'Create and track tailoring orders. Open an order to change status, payments, and delivery date.'**
  String get appGuideOrdersBody;

  /// No description provided for @appGuideCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get appGuideCustomersTitle;

  /// No description provided for @appGuideCustomersBody.
  ///
  /// In en, this message translates to:
  /// **'Save customer names, phone numbers, and measurement profiles for faster new orders.'**
  String get appGuideCustomersBody;

  /// No description provided for @appGuideCatalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get appGuideCatalogTitle;

  /// No description provided for @appGuideCatalogBody.
  ///
  /// In en, this message translates to:
  /// **'Share design photos with customers using your shop catalog.'**
  String get appGuideCatalogBody;

  /// No description provided for @appGuideReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get appGuideReportsTitle;

  /// No description provided for @appGuideReportsBody.
  ///
  /// In en, this message translates to:
  /// **'See income, unpaid orders, and delivery reports for your shop.'**
  String get appGuideReportsBody;

  /// No description provided for @appGuideSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get appGuideSettingsTitle;

  /// No description provided for @appGuideSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Set shop profile, printers, style library, and subscription here.'**
  String get appGuideSettingsBody;

  /// No description provided for @appGuideDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get appGuideDashboardTitle;

  /// No description provided for @appGuideDashboardBody.
  ///
  /// In en, this message translates to:
  /// **'Swipe from the left edge (or tap the menu icon) for search, sync, and shortcuts.'**
  String get appGuideDashboardBody;
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
