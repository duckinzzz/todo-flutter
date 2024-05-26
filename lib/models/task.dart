class Task {
  final String id;
  final String title;
  final String description;
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
}
