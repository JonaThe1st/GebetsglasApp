class JournalEntry {
  final int? id;
  final int requestId;
  final int categoryId;
  final DateTime prayedAt;

  const JournalEntry({
    this.id,
    required this.requestId,
    required this.categoryId,
    required this.prayedAt,
  });

  factory JournalEntry.fromMap(Map<String, Object?> map) => JournalEntry(
        id: map['id'] as int,
        requestId: map['request_id'] as int,
        categoryId: map['category_id'] as int,
        prayedAt:
            DateTime.fromMillisecondsSinceEpoch(map['prayed_at'] as int),
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'request_id': requestId,
        'category_id': categoryId,
        'prayed_at': prayedAt.millisecondsSinceEpoch,
      };
}
