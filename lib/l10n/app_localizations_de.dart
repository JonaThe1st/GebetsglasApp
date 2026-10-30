// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Gebetsglas';

  @override
  String get tabOverview => 'Übersicht';

  @override
  String get tabCategories => 'Kategorien';

  @override
  String get tabGlass => 'Glas';

  @override
  String get tabJournal => 'Tagebuch';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get homeGreeting => 'Dein Gebetsglas';

  @override
  String get homeGreetingSub => 'Was liegt dir heute auf dem Herzen?';

  @override
  String get ctaDraw => 'Heute ziehen';

  @override
  String get ctaDrawSub => 'Zieh ein Gebetsanliegen aus dem Glas';

  @override
  String get statRequests => 'Anliegen';

  @override
  String get statPrayers => 'Gebete';

  @override
  String get statStreakDays => 'Serie (Tage)';

  @override
  String get recentTitle => 'Zuletzt gebetet';

  @override
  String get recentEmpty => 'Noch nichts gebetet ✨';

  @override
  String get recentEmptySub =>
      'Zieh ein Anliegen und halte es mit dem Tagebuch fest.';

  @override
  String get journalTitle => 'Gebetstagebuch';

  @override
  String get journalEmpty => 'Noch kein Tagebuch';

  @override
  String get journalEmptySub =>
      'Wenn du ein Anliegen betest, wird es hier mit Datum festgehalten.';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get drawTitle => 'Glas ziehen';

  @override
  String get allChips => 'Alle';

  @override
  String get drawScopeAll => 'Gebetsglas – aus allen Kategorien';

  @override
  String drawScopeOne(String scope) {
    return 'Glas: $scope';
  }

  @override
  String get drawBtn => 'Ziehen';

  @override
  String get drawAgain => 'Nochmal ziehen';

  @override
  String get drawAgainNew => 'Neu ziehen';

  @override
  String get drawCardTitle => 'Dein Anliegen für jetzt';

  @override
  String get prayedShort => 'Gebetet ✓';

  @override
  String get prayedFull => 'Gebetet – ins Tagebuch';

  @override
  String get drawEmpty => 'Keine Anliegen vorhanden – leg zuerst welche an 🙏';

  @override
  String get drawRecorded => 'Im Tagebuch festgehalten 🙏';

  @override
  String get categoriesTitle => 'Kategorien';

  @override
  String get addCategory => 'Kategorie';

  @override
  String get categoriesEmpty => 'Noch keine Kategorien';

  @override
  String get categoriesEmptySub =>
      'Lege Kategorien an, z. B. Familie, Freunde oder Danksagung.';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteCategoryTitle => 'Kategorie löschen';

  @override
  String deleteCategoryMsg(String name) {
    return '„$name\" und alle darin enthaltenen Anliegen werden gelöscht.';
  }

  @override
  String categoryCreated(String name) {
    return '$name angelegt';
  }

  @override
  String get categoryDeleted => 'Kategorie gelöscht';

  @override
  String get addRequest => 'Anliegen';

  @override
  String get requestsEmpty => 'Noch keine Anliegen';

  @override
  String get requestsEmptySub =>
      'Tippe unten auf Hinzufügen, um dein erstes Gebetsanliegen einzutragen.';

  @override
  String get requestCreated => 'Anliegen angelegt';

  @override
  String get requestDeleted => 'Anliegen gelöscht';

  @override
  String get prayedRecorded => 'Gebetet – im Tagebuch festgehalten 🙏';

  @override
  String prayedCount(int count) {
    return '${count}x gebetet';
  }

  @override
  String get prayedBtn => 'Gebetet';

  @override
  String get neverPrayed => 'Noch nie gebetet';

  @override
  String lastPrayedAt(String date) {
    return 'Zuletzt gebetet: $date';
  }

  @override
  String get deleteRequestTitle => 'Anliegen löschen';

  @override
  String deleteRequestMsg(String name) {
    return '„$name\" wird gelöscht.';
  }

  @override
  String get newCategory => 'Neue Kategorie';

  @override
  String get editCategory => 'Kategorie bearbeiten';

  @override
  String get labelName => 'Name';

  @override
  String get nameRequired => 'Bitte Name eingeben';

  @override
  String get labelDescription => 'Beschreibung (optional)';

  @override
  String get save => 'Speichern';

  @override
  String get newRequest => 'Neues Gebetsanliegen';

  @override
  String get editRequest => 'Anliegen bearbeiten';

  @override
  String get labelRequest => 'Gebetsanliegen';

  @override
  String get inputRequired => 'Bitte eingeben';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get reminderSection => 'Tägliche Erinnerung';

  @override
  String get reminderToggle => 'Erinnerung aktivieren';

  @override
  String get reminderToggleSub =>
      'Täglich ein zufälliges Anliegen als Push-Mitteilung';

  @override
  String nextReminderAt(String date) {
    return 'Nächste Erinnerung: $date';
  }

  @override
  String get reminderTime => 'Uhrzeit';

  @override
  String get categoriesLabel => 'Kategorien';

  @override
  String get addCategoriesFirst => 'Lege zuerst Kategorien an.';

  @override
  String get reminderOff => 'Erinnerung ausgeschaltet';

  @override
  String get reminderOn => 'Tägliche Erinnerung aktiv ✓';

  @override
  String get notificationsDisabled =>
      'Benachrichtigungen sind auf dem Gerät deaktiviert';

  @override
  String get chooseCategory => 'Bitte wähle mindestens eine Kategorie';

  @override
  String get timePickerHelp => 'Erinnerungszeit';

  @override
  String get notificationTitle => 'Gebetsglas – Zeit zu beten';

  @override
  String get languageSection => 'Sprache';

  @override
  String get languageSystem => 'System';

  @override
  String get aboutTitle => 'Über';

  @override
  String get aboutName => 'Gebetsglas';

  @override
  String get aboutText =>
      'Neuauflage der App von Jona – datensparsam: Alle Daten bleiben lokal auf deinem Gerät. Kein Konto, kein Server, kein Tracking.';

  @override
  String get cancel => 'Abbrechen';
}
