import 'package:flutter/material.dart';

import '../db/database.dart';
import '../models/category.dart';
import '../models/prayer_request.dart';
import '../widgets/common.dart';
import 'request_editor_sheet.dart';

class RequestsScreen extends StatefulWidget {
  final CategoryWithCount category;

  const RequestsScreen({super.key, required this.category});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<PrayerRequest> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final reqs = await AppDatabase.instance.getRequests(widget.category.id!);
    if (!mounted) return;
    setState(() {
      _requests = reqs;
      _loading = false;
    });
  }

  Future<void> _add() async {
    final request = await showRequestEditor(context, categoryId: widget.category.id!);
    if (request == null) return;
    await AppDatabase.instance.insertRequest(request);
    if (!mounted) return;
    showSnack(context, 'Anliegen angelegt');
    _load();
  }

  Future<void> _edit(PrayerRequest req) async {
    final updated = await showRequestEditor(
      context,
      categoryId: widget.category.id!,
      existing: req,
    );
    if (updated == null) return;
    await AppDatabase.instance.updateRequest(updated);
    _load();
  }

  Future<void> _delete(PrayerRequest req) async {
    final ok = await confirmDelete(
      context,
      title: 'Anliegen löschen',
      message: '„${req.name}" wird gelöscht.',
    );
    if (!ok) return;
    await AppDatabase.instance.deleteRequest(req.id!);
    if (!mounted) return;
    showSnack(context, 'Anliegen gelöscht');
    _load();
  }

  Future<void> _pray(PrayerRequest req) async {
    await AppDatabase.instance.recordPrayer(req);
    if (!mounted) return;
    showSnack(context, 'Gebetet – im Tagebuch festgehalten 🙏');
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Anliegen'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _requests.isEmpty
              ? EmptyState(
                  icon: Icons.favorite_border,
                  title: 'Noch keine Anliegen',
                  subtitle:
                      'Tippe unten auf Hinzufügen, um dein erstes Gebetsanliegen einzutragen.',
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                    itemCount: _requests.length,
                    itemBuilder: (context, index) {
                      final req = _requests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          onTap: () => _showDetail(req),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      req.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'edit') _edit(req);
                                      if (value == 'delete') _delete(req);
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                          value: 'edit',
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.edit_outlined),
                                            title: Text('Bearbeiten'),
                                            dense: true,
                                          )),
                                      PopupMenuItem(
                                          value: 'delete',
                                          child: ListTile(
                                            leading:
                                                Icon(Icons.delete_outline),
                                            title: Text('Löschen'),
                                            dense: true,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              if (req.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    req.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: scheme.onSurfaceVariant),
                                  ),
                                ),
                              Row(
                                children: [
                                  Icon(Icons.menu_book_outlined,
                                      size: 15, color: scheme.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${req.prayedCount}x gebetet',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: scheme.primary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.tonalIcon(
                                  onPressed: () => _pray(req),
                                  icon: const Icon(Icons.favorite),
                                  label: const Text('Gebetet'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showDetail(PrayerRequest req) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(req.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            if (req.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(req.description,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 14),
            Text(
              req.lastPrayedAt == null
                  ? 'Noch nie gebetet'
                  : 'Zuletzt gebetet: '
                      '${req.lastPrayedAt!.day}.${req.lastPrayedAt!.month}.'
                      '${req.lastPrayedAt!.year}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(ctx).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _pray(req);
                },
                icon: const Icon(Icons.favorite),
                label: const Text('Gebetet – ins Tagebuch'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
