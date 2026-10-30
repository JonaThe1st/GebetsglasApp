class Category {
  final int? id;
  final String name;
  final String description;
  final DateTime createdAt;

  const Category({
    this.id,
    required this.name,
    this.description = '',
    required this.createdAt,
  });

  factory Category.fromMap(Map<String, Object?> map) => Category(
        id: map['id'] as int,
        name: map['name'] as String,
        description: (map['description'] as String?) ?? '',
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  Category copyWith({String? name, String? description}) => Category(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        createdAt: createdAt,
      );
}

class CategoryWithCount extends Category {
  final int requestCount;
  CategoryWithCount(
    Category category,
    this.requestCount,
  ) : super(
          id: category.id,
          name: category.name,
          description: category.description,
          createdAt: category.createdAt,
        );

  factory CategoryWithCount.fromRow(Map<String, Object?> row) =>
      CategoryWithCount(Category.fromMap(row), row['cnt'] as int);
}
