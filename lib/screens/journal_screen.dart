import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/database.dart';
import '../widgets/common.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<Map<String, Object?>> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await AppDatabase.instance.getJournalDetail(limit: 500);
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final entriesByDay = <String, List<Map<String, Object?>>>{};
    for (final e in _entries) {
      final day = DateFormat('yyyy-MM-dd')
          .format(DateTime.fromMillisecondsSinceEpoch(e['prayed_at'] as int));
      entriesByDay.putIfAbsent(day, () => []).add(e);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Gebetstagebuch'), centerTitle: false),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? const EmptyState(
                  icon: Icons.menu_book_outlined,
                  title: 'Noch kein Tagebuch',
                  subtitle:
                      'Wenn du ein Anliegen betest, wird es hier mit Datum festgehalten.',
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      ...entriesByDay.entries.map((group) {
                        final day = DateTime.parse(group.key);
                        final label = _dayLabel(day);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                label,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: scheme.primary,
                                    ),
                              ),
                            ),
                            ...group.value.map((e) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8),
                                  child: GlassCard(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Row(
                                      children: [
                                        Icon(Icons.favorite,
                                            size: 18, color: scheme.error),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e['request_name'] as String,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                e['category_name'] as String,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: scheme
                                                            .onSurfaceVariant),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          DateFormat('HH:mm').format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  e['prayed_at'] as int)),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color:
                                                      scheme.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
    );
  }

  String _dayLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return 'Heute';
    if (day == today.subtract(const Duration(days: 1))) return 'Gestern';
    return DateFormat('EEEE, d. MMMM yyyy', 'de_DE').format(day);
  }
}
