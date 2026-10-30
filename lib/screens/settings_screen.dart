import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/database.dart';
import '../models/category.dart';
import '../services/notification_service.dart';
import '../l10n/app_localizations.dart';
import '../l10n/language_controller.dart';
import '../services/settings_service.dart';
import '../widgets/common.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settings = SettingsService.instance;

  List<Category> _categories = [];
  List<int> _selectedCategoryIds = [];
  bool _enabled = false;
  int _hour = 7;
  int _minute = 0;
  bool _loading = true;
  DateTime? _nextFire;
  String _language = 'system';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _settings.enabled;
    final hour = await _settings.hour;
    final minute = await _settings.minute;
    final selected = await _settings.categoryIds;
    final cats = await AppDatabase.instance.getCategories();
    final language = await _settings.language;
    final nextFireRaw = await _settings.nextFire;
    final nextFire = (nextFireRaw == null)
        ? null
        : DateTime.fromMillisecondsSinceEpoch(nextFireRaw);

    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _hour = hour;
      _minute = minute;
      _selectedCategoryIds = selected;
      _categories = cats;
      _nextFire = (nextFire != null && nextFire.isAfter(DateTime.now()))
          ? nextFire
          : null;
      _language = language;
      _loading = false;
    });
  }

  Future<void> _saveAndSchedule() async {
    final l10n = AppLocalizations.of(context)!;
    await _settings.setEnabled(_enabled);
    await _settings.setTime(_hour, _minute);
    await _settings.setCategoryIds(_selectedCategoryIds);

    if (!_enabled) {
      await NotificationService.instance.cancelDaily();
      if (!mounted) return;
      setState(() => _nextFire = null);
      showSnack(context, l10n.reminderOff);
      return;
    }
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) {
      setState(() => _enabled = false);
      await _settings.setEnabled(false);
      if (!mounted) return;
      showSnack(context, l10n.notificationsDisabled);
      return;
    }
    final selectedCats = _categories
        .where((c) => _selectedCategoryIds.contains(c.id))
        .toList();
    if (selectedCats.isEmpty) {
      if (!mounted) return;
      showSnack(context, l10n.chooseCategory);
      return;
    }
    // Exakte Alarme (unter Android 12+) machen die Zustellung auch im
    // Energiesparmodus zuverlässig – Berechtigung einmalig anfragen.
    await NotificationService.instance.requestExactAlarmPermission();

    final ok = await NotificationService.instance.scheduleDaily(
        hour: _hour,
        minute: _minute,
        categories: selectedCats,
        title: l10n.notificationTitle);
    await _refreshNextFire();
    if (!mounted) return;
    showSnack(context, ok ? l10n.reminderOn : l10n.scheduleFailed);
  }

  Future<void> _refreshNextFire() async {
    final raw = await _settings.nextFire;
    if (!mounted) return;
    setState(() {
      final nf = raw == null ? null : DateTime.fromMillisecondsSinceEpoch(raw);
      _nextFire = (nf != null && nf.isAfter(DateTime.now())) ? nf : null;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
      helpText: AppLocalizations.of(context)!.timePickerHelp,
    );
    if (picked == null) return;
    setState(() {
      _hour = picked.hour;
      _minute = picked.minute;
    });
    await _saveAndSchedule();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final time = TimeOfDay(hour: _hour, minute: _minute);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle), centerTitle: false),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ─── Tägliche Erinnerung ───
                Text(l10n.reminderSection,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                GlassCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.reminderToggle,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(l10n.reminderToggleSub),
                        value: _enabled,
                        onChanged: (value) {
                          setState(() => _enabled = value);
                          _saveAndSchedule();
                        },
                      ),
                      if (_nextFire != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              l10n.nextReminderAt(DateFormat('EEEE, dd.MM., HH:mm').format(_nextFire!)),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.schedule),
                        title: Text(l10n.reminderTime),
                        subtitle: Text(DateFormat('HH:mm').format(
                            DateTime(2026, 1, 1, time.hour, time.minute))),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _pickTime,
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.notifications_active_outlined),
                        title: Text(l10n.testNotification),
                        subtitle: Text(l10n.testNotificationSub),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final granted =
                              await NotificationService.instance
                                  .requestPermission();
                          if (!granted) {
                            if (!context.mounted) return;
                            showSnack(context, l10n.notificationsDisabled);
                            return;
                          }
                          await NotificationService.instance
                              .sendTestNotification();
                          if (!context.mounted) return;
                          showSnack(context, l10n.testNotificationSent);
                        },
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(l10n.categoriesLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((c) {
                          final selected = _selectedCategoryIds.contains(c.id);
                          return FilterChip(
                            label: Text(c.name),
                            selected: selected,
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  if (!_selectedCategoryIds.contains(c.id)) {
                                    _selectedCategoryIds.add(c.id!);
                                  }
                                } else {
                                  _selectedCategoryIds.remove(c.id);
                                }
                              });
                              _saveAndSchedule();
                            },
                          );
                        }).toList(),
                      ),
                      if (_categories.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            l10n.addCategoriesFirst,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ─── Sprache ───
                Text(l10n.languageSection,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                GlassCard(
                  child: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'system',
                        label: Text(l10n.languageSystem),
                        icon: const Icon(Icons.settings_suggest_outlined),
                      ),
                      const ButtonSegment(
                        value: 'de',
                        label: Text('Deutsch'),
                        icon: Icon(Icons.language),
                      ),
                      const ButtonSegment(
                        value: 'en',
                        label: Text('English'),
                        icon: Icon(Icons.language),
                      ),
                    ],
                    selected: {_language},
                    onSelectionChanged: (selection) async {
                      final code = selection.first;
                      setState(() => _language = code);
                      await LanguageController.setLanguage(code);
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ─── Über ───
                Text(l10n.aboutTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.aboutName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(
                        l10n.aboutText,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
