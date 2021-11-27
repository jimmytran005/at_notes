import 'package:flutter/material.dart';

class NoteModel {
  String title;
  String body;
  DateTime creation_date;

  NoteModel(
      @required this.title, @required this.body, @required this.creation_date);
}
