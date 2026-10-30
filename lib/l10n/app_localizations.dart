import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Gebetsglas'**
  String get appTitle;

  /// No description provided for @tabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tabOverview;

  /// No description provided for @tabCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get tabCategories;

  /// No description provided for @tabGlass.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get tabGlass;

  /// No description provided for @tabJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get tabJournal;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Your prayer jar'**
  String get homeGreeting;

  /// No description provided for @homeGreetingSub.
  ///
  /// In en, this message translates to:
  /// **'What is on your heart today?'**
  String get homeGreetingSub;

  /// No description provided for @ctaDraw.
  ///
  /// In en, this message translates to:
  /// **'Draw today'**
  String get ctaDraw;

  /// No description provided for @ctaDrawSub.
  ///
  /// In en, this message translates to:
  /// **'Draw one prayer request from the jar'**
  String get ctaDrawSub;

  /// No description provided for @statRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get statRequests;

  /// No description provided for @statPrayers.
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get statPrayers;

  /// No description provided for @statStreakDays.
  ///
  /// In en, this message translates to:
  /// **'Streak (days)'**
  String get statStreakDays;

  /// No description provided for @recentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently prayed'**
  String get recentTitle;

  /// No description provided for @recentEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing prayed yet ✨'**
  String get recentEmpty;

  /// No description provided for @recentEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Draw a request and keep it in your journal.'**
  String get recentEmptySub;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer journal'**
  String get journalTitle;

  /// No description provided for @journalEmpty.
  ///
  /// In en, this message translates to:
  /// **'No journal yet'**
  String get journalEmpty;

  /// No description provided for @journalEmptySub.
  ///
  /// In en, this message translates to:
  /// **'When you pray for a request, it is recorded here with a date.'**
  String get journalEmptySub;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @drawTitle.
  ///
  /// In en, this message translates to:
  /// **'Draw from the jar'**
  String get drawTitle;

  /// No description provided for @allChips.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allChips;

  /// No description provided for @drawScopeAll.
  ///
  /// In en, this message translates to:
  /// **'Prayer jar – all categories'**
  String get drawScopeAll;

  /// No description provided for @drawScopeOne.
  ///
  /// In en, this message translates to:
  /// **'Jar: {scope}'**
  String drawScopeOne(String scope);

  /// No description provided for @drawBtn.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get drawBtn;

  /// No description provided for @drawAgain.
  ///
  /// In en, this message translates to:
  /// **'Draw again'**
  String get drawAgain;

  /// No description provided for @drawAgainNew.
  ///
  /// In en, this message translates to:
  /// **'Draw new'**
  String get drawAgainNew;

  /// No description provided for @drawCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your request for now'**
  String get drawCardTitle;

  /// No description provided for @prayedShort.
  ///
  /// In en, this message translates to:
  /// **'Prayed ✓'**
  String get prayedShort;

  /// No description provided for @prayedFull.
  ///
  /// In en, this message translates to:
  /// **'Prayed – save to journal'**
  String get prayedFull;

  /// No description provided for @drawEmpty.
  ///
  /// In en, this message translates to:
  /// **'No requests yet – add some first 🙏'**
  String get drawEmpty;

  /// No description provided for @drawRecorded.
  ///
  /// In en, this message translates to:
  /// **'Saved to journal 🙏'**
  String get drawRecorded;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get addCategory;

  /// No description provided for @categoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get categoriesEmpty;

  /// No description provided for @categoriesEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Create categories, e.g. family, friends or thanksgiving.'**
  String get categoriesEmptySub;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryMsg.
  ///
  /// In en, this message translates to:
  /// **'“{name}” and all its requests will be deleted.'**
  String deleteCategoryMsg(String name);

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'{name} created'**
  String categoryCreated(String name);

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted'**
  String get categoryDeleted;

  /// No description provided for @addRequest.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get addRequest;

  /// No description provided for @requestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No requests yet'**
  String get requestsEmpty;

  /// No description provided for @requestsEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Tap add below to enter your first prayer request.'**
  String get requestsEmptySub;

  /// No description provided for @requestCreated.
  ///
  /// In en, this message translates to:
  /// **'Request created'**
  String get requestCreated;

  /// No description provided for @requestDeleted.
  ///
  /// In en, this message translates to:
  /// **'Request deleted'**
  String get requestDeleted;

  /// No description provided for @prayedRecorded.
  ///
  /// In en, this message translates to:
  /// **'Prayed – saved to journal 🙏'**
  String get prayedRecorded;

  /// No description provided for @prayedCount.
  ///
  /// In en, this message translates to:
  /// **'{count}x prayed'**
  String prayedCount(int count);

  /// No description provided for @prayedBtn.
  ///
  /// In en, this message translates to:
  /// **'Prayed'**
  String get prayedBtn;

  /// No description provided for @neverPrayed.
  ///
  /// In en, this message translates to:
  /// **'Never prayed'**
  String get neverPrayed;

  /// No description provided for @lastPrayedAt.
  ///
  /// In en, this message translates to:
  /// **'Last prayed: {date}'**
  String lastPrayedAt(String date);

  /// No description provided for @deleteRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete request'**
  String get deleteRequestTitle;

  /// No description provided for @deleteRequestMsg.
  ///
  /// In en, this message translates to:
  /// **'“{name}” will be deleted.'**
  String deleteRequestMsg(String name);

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get nameRequired;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get labelDescription;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New prayer request'**
  String get newRequest;

  /// No description provided for @editRequest.
  ///
  /// In en, this message translates to:
  /// **'Edit request'**
  String get editRequest;

  /// No description provided for @labelRequest.
  ///
  /// In en, this message translates to:
  /// **'Prayer request'**
  String get labelRequest;

  /// No description provided for @inputRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get inputRequired;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @reminderSection.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get reminderSection;

  /// No description provided for @reminderToggle.
  ///
  /// In en, this message translates to:
  /// **'Enable reminder'**
  String get reminderToggle;

  /// No description provided for @reminderToggleSub.
  ///
  /// In en, this message translates to:
  /// **'A random prayer request as push notification every day'**
  String get reminderToggleSub;

  /// No description provided for @nextReminderAt.
  ///
  /// In en, this message translates to:
  /// **'Next reminder: {date}'**
  String nextReminderAt(String date);

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get reminderTime;

  /// No description provided for @categoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesLabel;

  /// No description provided for @addCategoriesFirst.
  ///
  /// In en, this message translates to:
  /// **'Create categories first.'**
  String get addCategoriesFirst;

  /// No description provided for @reminderOff.
  ///
  /// In en, this message translates to:
  /// **'Reminder turned off'**
  String get reminderOff;

  /// No description provided for @reminderOn.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder active ✓'**
  String get reminderOn;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled on this device'**
  String get notificationsDisabled;

  /// No description provided for @chooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one category'**
  String get chooseCategory;

  /// No description provided for @timePickerHelp.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get timePickerHelp;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Gebetsglas – time to pray'**
  String get notificationTitle;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutName.
  ///
  /// In en, this message translates to:
  /// **'Gebetsglas'**
  String get aboutName;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'Rebuild of Jona\'s app – privacy first: All data stays on your device. No account, no server, no tracking.'**
  String get aboutText;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get testNotification;

  /// No description provided for @testNotificationSub.
  ///
  /// In en, this message translates to:
  /// **'Check that push notifications arrive on this device'**
  String get testNotificationSub;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent ✓'**
  String get testNotificationSent;

  /// No description provided for @scheduleFailed.
  ///
  /// In en, this message translates to:
  /// **'Reminder could not be scheduled – please try again'**
  String get scheduleFailed;

  /// No description provided for @diagTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagTitle;

  /// No description provided for @diagNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications allowed'**
  String get diagNotifications;

  /// No description provided for @diagExactAlarms.
  ///
  /// In en, this message translates to:
  /// **'On-time delivery (exact alarms)'**
  String get diagExactAlarms;

  /// No description provided for @diagExactHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to enable, then allow “Alarms & reminders” in the system settings'**
  String get diagExactHint;

  /// No description provided for @diagScheduled.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get diagScheduled;

  /// No description provided for @diagScheduledNone.
  ///
  /// In en, this message translates to:
  /// **'No reminder scheduled'**
  String get diagScheduledNone;

  /// No description provided for @diagRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get diagRefresh;

  /// No description provided for @diagYes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get diagYes;

  /// No description provided for @diagNo.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get diagNo;
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
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
