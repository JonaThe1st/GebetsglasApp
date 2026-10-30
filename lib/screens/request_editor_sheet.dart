import 'package:flutter/material.dart';

import '../models/prayer_request.dart';

/// Bottom-Sheet zum Anlegen/Bearbeiten eines Gebetsanliegens.
Future<PrayerRequest?> showRequestEditor(
  BuildContext context, {
  required int categoryId,
  PrayerRequest? existing,
}) async {
  return showModalBottomSheet<PrayerRequest>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) =>
        RequestEditorSheet(categoryId: categoryId, existing: existing),
  );
}

class RequestEditorSheet extends StatefulWidget {
  final int categoryId;
  final PrayerRequest? existing;

  const RequestEditorSheet({
    super.key,
    required this.categoryId,
    this.existing,
  });

  @override
  State<RequestEditorSheet> createState() => _RequestEditorSheetState();
}

class _RequestEditorSheetState extends State<RequestEditorSheet> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _description =
      TextEditingController(text: widget.existing?.description ?? '');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final request = PrayerRequest(
      id: widget.existing?.id,
      categoryId: widget.existing?.categoryId ?? widget.categoryId,
      name: _name.text.trim(),
      description: _description.text.trim(),
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
      prayedCount: widget.existing?.prayedCount ?? 0,
      lastPrayedAt: widget.existing?.lastPrayedAt,
    );
    Navigator.pop(context, request);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing == null
                  ? 'Neues Gebetsanliegen'
                  : 'Anliegen bearbeiten',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Gebetsanliegen',
                prefixIcon: Icon(Icons.favorite_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Bitte eingeben' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Beschreibung (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Speichern'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
