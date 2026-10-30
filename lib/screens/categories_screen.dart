import 'package:flutter/material.dart';

import '../db/database.dart';
import '../models/category.dart';
import '../widgets/common.dart';
import 'category_editor_sheet.dart';
import 'requests_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<CategoryWithCount> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await AppDatabase.instance.getCategories();
    if (!mounted) return;
    setState(() {
      _categories = cats;
      _loading = false;
    });
  }

  Future<void> _addCategory() async {
    final category = await showCategoryEditor(context);
    if (category == null) return;
    await AppDatabase.instance.insertCategory(category);
    if (!mounted) return;
    showSnack(context, '${category.name} angelegt');
    _load();
  }

  Future<void> _editCategory(CategoryWithCount cat) async {
    final updated = await showCategoryEditor(context, existing: cat);
    if (updated == null) return;
    await AppDatabase.instance.updateCategory(updated);
    _load();
  }

  Future<void> _deleteCategory(CategoryWithCount cat) async {
    final ok = await confirmDelete(
      context,
      title: 'Kategorie löschen',
      message:
          '„${cat.name}" und alle darin enthaltenen Anliegen werden gelöscht.',
    );
    if (!ok) return;
    await AppDatabase.instance.deleteCategory(cat.id!);
    if (!mounted) return;
    showSnack(context, 'Kategorie gelöscht');
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategorien'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCategory,
        icon: const Icon(Icons.add),
        label: const Text('Kategorie'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const EmptyState(
                  icon: Icons.folder_open,
                  title: 'Noch keine Kategorien',
                  subtitle:
                      'Lege Kategorien an, z. B. Familie, Freunde oder Danksagung.',
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RequestsScreen(category: cat),
                              ),
                            );
                            _load();
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: scheme.primary.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.favorite_outline,
                                  color: scheme.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cat.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    if (cat.description.isNotEmpty)
                                      Text(
                                        cat.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: scheme.secondaryContainer
                                      .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${cat.requestCount}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: scheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') _editCategory(cat);
                                  if (value == 'delete') _deleteCategory(cat);
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                      value: 'edit',
                                      child: ListTile(
                                        leading:
                                            Icon(Icons.edit_outlined),
                                        title: Text('Bearbeiten'),
                                        dense: true,
                                      )),
                                  PopupMenuItem(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete_outline),
                                        title: Text('Löschen'),
                                        dense: true,
                                      )),
                                ],
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
}
