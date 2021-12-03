class NoteModel {
  late String id;
  late String title;
  late String body;
  late DateTime creation_date;

  NoteModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.creation_date});
}
