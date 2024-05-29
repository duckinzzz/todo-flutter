class Task {
  final String id;
  String title;
  String description;
  final String categoryId;
  bool isCompleted;
  bool isFavourite;
  DateTime createdAt;

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.categoryId,
      this.isCompleted = false,
      this.isFavourite = false,
      required this.createdAt});

  void update({required String title, String? description}) {
    this.title = title;
    if (description != null) {
      this.description = description;
    }
  }
}
