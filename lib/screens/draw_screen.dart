import 'package:flutter/material.dart';

import '../db/database.dart';
import '../models/category.dart';
import '../models/prayer_request.dart';
import '../l10n/app_localizations.dart';
import '../widgets/common.dart';

/// Das „Glas ziehen"-Erlebnis: zufälliges Anliegen mit Animation.
class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> with TickerProviderStateMixin {
  List<Category> _categories = [];
  int? _selectedCategoryId;
  bool _drawing = false;
  PrayerRequest? _drawResult;
  bool _recorded = false;

  late final AnimationController _shakeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _shake = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final cats = await AppDatabase.instance.getCategories();
    if (!mounted) return;
    setState(() => _categories = cats);
  }

  Future<void> _draw() async {
    setState(() {
      _drawing = true;
      _drawResult = null;
      _recorded = false;
    });
    _shakeController.forward(from: 0);
    await Future<void>.delayed(const Duration(milliseconds: 650));

    final db = AppDatabase.instance;
    final categoryIds =
        _selectedCategoryId == null ? null : [_selectedCategoryId!];
    final request = await db.drawRandom(categoryIds: categoryIds);
    if (!mounted) return;
    setState(() {
      _drawing = false;
      _drawResult = request;
    });
    if (request == null) {
      showSnack(context, AppLocalizations.of(context)!.drawEmpty);
    }
  }

  Future<void> _record() async {
    if (_drawResult == null) return;
    await AppDatabase.instance.recordPrayer(_drawResult!);
    if (!mounted) return;
    setState(() => _recorded = true);
    showSnack(context, AppLocalizations.of(context)!.drawRecorded);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final scope = _selectedCategoryId == null
        ? null
        : _categories
            .where((c) => c.id == _selectedCategoryId)
            .firstOrNull
            ?.name;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.drawTitle), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Kategorie-Auswahl (Scope)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: Text(l10n.allChips),
                selected: _selectedCategoryId == null,
                onSelected: (_) => setState(() => _selectedCategoryId = null),
              ),
              ..._categories.map(
                (c) => ChoiceChip(
                  label: Text(c.name),
                  selected: _selectedCategoryId == c.id,
                  onSelected: (_) =>
                      setState(() => _selectedCategoryId = c.id),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Glas
          AnimatedBuilder(
            animation: _shake,
            builder: (context, _) {
              final t = _shake.value;
              final angle = t == 0
                  ? 0.0
                  : (0.08 * (t < 0.5 ? t : 1 - t)).clamp(-0.08, 0.08) * 2;
              return Transform.rotate(
                angle: _drawing ? angle * (1 + t) : 0,
                child: Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.primaryContainer.withValues(alpha: 0.9),
                          scheme.tertiaryContainer.withValues(alpha: 0.7),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/icons/jar.png',
                      width: 76,
                      height: 76,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            scope == null ? l10n.drawScopeAll : l10n.drawScopeOne(scope),
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          // Ergebnis
          if (_drawResult != null) ...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: GlassCard(
                key: ValueKey(_drawResult!.id),
                tint: scheme.tertiaryContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite, color: scheme.error, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          l10n.drawCardTitle,
                          style: textTheme.labelLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _drawResult!.name,
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    if (_drawResult!.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(_drawResult!.description,
                          style: textTheme.bodyMedium),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _draw,
                            icon: const Icon(Icons.refresh),
                            label: Text(
                                _recorded ? l10n.drawAgainNew : l10n.drawAgain),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _recorded ? null : _record,
                            icon: Icon(
                              _recorded ? Icons.check : Icons.favorite,
                            ),
                            label: Text(_recorded
                                ? l10n.prayedShort
                                : l10n.prayedFull),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (_drawResult == null && !_drawing)
            Center(
              child: FilledButton.icon(
                onPressed: _draw,
                icon: const Icon(Icons.casino_outlined),
                label: const Text('Ziehen'),
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
