class PrayerRequest {
  final int? id;
  final int categoryId;
  final String name;
  final String description;
  final DateTime createdAt;
  final int prayedCount;
  final DateTime? lastPrayedAt;

  const PrayerRequest({
    this.id,
    required this.categoryId,
    required this.name,
    this.description = '',
    required this.createdAt,
    this.prayedCount = 0,
    this.lastPrayedAt,
  });

  factory PrayerRequest.fromMap(Map<String, Object?> map) => PrayerRequest(
        id: map['id'] as int,
        categoryId: map['category_id'] as int,
        name: map['name'] as String,
        description: (map['description'] as String?) ?? '',
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
        prayedCount: (map['prayed_count'] as int?) ?? 0,
        lastPrayedAt: map['last_prayed_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map['last_prayed_at'] as int),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'category_id': categoryId,
        'name': name,
        'description': description,
        'created_at': createdAt.millisecondsSinceEpoch,
        'prayed_count': prayedCount,
        'last_prayed_at': lastPrayedAt?.millisecondsSinceEpoch,
      };

  PrayerRequest copyWith({int? prayedCount, DateTime? lastPrayedAt}) =>
      PrayerRequest(
        id: id,
        categoryId: categoryId,
        name: name,
        description: description,
        createdAt: createdAt,
        prayedCount: prayedCount ?? this.prayedCount,
        lastPrayedAt: lastPrayedAt ?? this.lastPrayedAt,
      );
}
