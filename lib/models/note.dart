class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isPinned;
  final List<String>? checklist;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
    this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isPinned': isPinned ? 1 : 0,
      'checklist': checklist?.join(',') ?? '',
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      isPinned: map['isPinned'] == 1,
      checklist: map['checklist'] != '' ? map['checklist'].split(',') : null,
    );
  }
}
