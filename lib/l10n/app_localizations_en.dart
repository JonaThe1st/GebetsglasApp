// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gebetsglas';

  @override
  String get tabOverview => 'Overview';

  @override
  String get tabCategories => 'Categories';

  @override
  String get tabGlass => 'Glass';

  @override
  String get tabJournal => 'Journal';

  @override
  String get tabSettings => 'Settings';

  @override
  String get homeGreeting => 'Your prayer jar';

  @override
  String get homeGreetingSub => 'What is on your heart today?';

  @override
  String get ctaDraw => 'Draw today';

  @override
  String get ctaDrawSub => 'Draw one prayer request from the jar';

  @override
  String get statRequests => 'Requests';

  @override
  String get statPrayers => 'Prayers';

  @override
  String get statStreakDays => 'Streak (days)';

  @override
  String get recentTitle => 'Recently prayed';

  @override
  String get recentEmpty => 'Nothing prayed yet ✨';

  @override
  String get recentEmptySub => 'Draw a request and keep it in your journal.';

  @override
  String get journalTitle => 'Prayer journal';

  @override
  String get journalEmpty => 'No journal yet';

  @override
  String get journalEmptySub =>
      'When you pray for a request, it is recorded here with a date.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get drawTitle => 'Draw from the jar';

  @override
  String get allChips => 'All';

  @override
  String get drawScopeAll => 'Prayer jar – all categories';

  @override
  String drawScopeOne(String scope) {
    return 'Jar: $scope';
  }

  @override
  String get drawBtn => 'Draw';

  @override
  String get drawAgain => 'Draw again';

  @override
  String get drawAgainNew => 'Draw new';

  @override
  String get drawCardTitle => 'Your request for now';

  @override
  String get prayedShort => 'Prayed ✓';

  @override
  String get prayedFull => 'Prayed – save to journal';

  @override
  String get drawEmpty => 'No requests yet – add some first 🙏';

  @override
  String get drawRecorded => 'Saved to journal 🙏';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get addCategory => 'Category';

  @override
  String get categoriesEmpty => 'No categories yet';

  @override
  String get categoriesEmptySub =>
      'Create categories, e.g. family, friends or thanksgiving.';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteCategoryTitle => 'Delete category';

  @override
  String deleteCategoryMsg(String name) {
    return '“$name” and all its requests will be deleted.';
  }

  @override
  String categoryCreated(String name) {
    return '$name created';
  }

  @override
  String get categoryDeleted => 'Category deleted';

  @override
  String get addRequest => 'Request';

  @override
  String get requestsEmpty => 'No requests yet';

  @override
  String get requestsEmptySub =>
      'Tap add below to enter your first prayer request.';

  @override
  String get requestCreated => 'Request created';

  @override
  String get requestDeleted => 'Request deleted';

  @override
  String get prayedRecorded => 'Prayed – saved to journal 🙏';

  @override
  String prayedCount(int count) {
    return '${count}x prayed';
  }

  @override
  String get prayedBtn => 'Prayed';

  @override
  String get neverPrayed => 'Never prayed';

  @override
  String lastPrayedAt(String date) {
    return 'Last prayed: $date';
  }

  @override
  String get deleteRequestTitle => 'Delete request';

  @override
  String deleteRequestMsg(String name) {
    return '“$name” will be deleted.';
  }

  @override
  String get newCategory => 'New category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get labelName => 'Name';

  @override
  String get nameRequired => 'Please enter a name';

  @override
  String get labelDescription => 'Description (optional)';

  @override
  String get save => 'Save';

  @override
  String get newRequest => 'New prayer request';

  @override
  String get editRequest => 'Edit request';

  @override
  String get labelRequest => 'Prayer request';

  @override
  String get inputRequired => 'Please enter';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get reminderSection => 'Daily reminder';

  @override
  String get reminderToggle => 'Enable reminder';

  @override
  String get reminderToggleSub =>
      'A random prayer request as push notification every day';

  @override
  String nextReminderAt(String date) {
    return 'Next reminder: $date';
  }

  @override
  String get reminderTime => 'Time';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get addCategoriesFirst => 'Create categories first.';

  @override
  String get reminderOff => 'Reminder turned off';

  @override
  String get reminderOn => 'Daily reminder active ✓';

  @override
  String get notificationsDisabled =>
      'Notifications are disabled on this device';

  @override
  String get chooseCategory => 'Please select at least one category';

  @override
  String get timePickerHelp => 'Reminder time';

  @override
  String get notificationTitle => 'Gebetsglas – time to pray';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutName => 'Gebetsglas';

  @override
  String get aboutText =>
      'Rebuild of Jona\'s app – privacy first: All data stays on your device. No account, no server, no tracking.';

  @override
  String get cancel => 'Cancel';
}
