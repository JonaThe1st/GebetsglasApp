import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/database.dart';
import '../models/category.dart';
import '../services/notification_service.dart';
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

    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _hour = hour;
      _minute = minute;
      _selectedCategoryIds = selected;
      _categories = cats;
      _loading = false;
    });
  }

  Future<void> _saveAndSchedule() async {
    await _settings.setEnabled(_enabled);
    await _settings.setTime(_hour, _minute);
    await _settings.setCategoryIds(_selectedCategoryIds);

    if (!_enabled) {
      await NotificationService.instance.cancelDaily();
      if (!mounted) return;
      showSnack(context, 'Erinnerung ausgeschaltet');
      return;
    }
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) {
      setState(() => _enabled = false);
      await _settings.setEnabled(false);
      if (!mounted) return;
      showSnack(context, 'Benachrichtigungen sind auf dem Gerät deaktiviert');
      return;
    }
    final selectedCats = _categories
        .where((c) => _selectedCategoryIds.contains(c.id))
        .toList();
    if (selectedCats.isEmpty) {
      if (!mounted) return;
      showSnack(context, 'Bitte wähle mindestens eine Kategorie');
      return;
    }
    await NotificationService.instance
        .scheduleDaily(hour: _hour, minute: _minute, categories: selectedCats);
    if (!mounted) return;
    showSnack(context, 'Tägliche Erinnerung aktiv ✓');
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
      helpText: 'Erinnerungszeit',
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
    final time = TimeOfDay(hour: _hour, minute: _minute);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen'), centerTitle: false),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ─── Tägliche Erinnerung ───
                Text('Tägliche Erinnerung',
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
                        title: const Text('Erinnerung aktivieren',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: const Text(
                            'Täglich ein zufälliges Anliegen als Push-Mitteilung'),
                        value: _enabled,
                        onChanged: (value) {
                          setState(() => _enabled = value);
                          _saveAndSchedule();
                        },
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.schedule),
                        title: const Text('Uhrzeit'),
                        subtitle: Text(DateFormat('HH:mm').format(
                            DateTime(2026, 1, 1, time.hour, time.minute))),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _pickTime,
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Kategorien',
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
                            'Lege zuerst Kategorien an.',
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

                // ─── Über ───
                Text('Über',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gebetsglas',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(
                        'Neuauflage der App von Jona – datensparsam: '
                        'Alle Daten bleiben lokal auf deinem Gerät. '
                        'Kein Konto, kein Server, kein Tracking.',
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
