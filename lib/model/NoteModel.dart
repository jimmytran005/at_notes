// This is the class that models the Note instances
class NoteModel {
  late String id;
  late String title;
  late String body;
  late String sharedWith;
  late String sharedBy;
  late bool isShared;
  late DateTime creation_date;

  NoteModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.creation_date,
      required this.sharedWith,
      required this.sharedBy,
      required this.isShared});
}
