import 'package:at_notes/services/at_note_service.dart';
import 'package:flutter/material.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_notes/utils/constants.dart' as constants;
import 'package:at_notes/services/at_note_service.dart';


class SharedPage extends StatelessWidget {

  final String? atSign = AtNoteService().getUserAtSign();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(
          'Shared Notes'
        ),
      ),
      body:SingleChildScrollView(

      ),
  );

/*
  Future<List<AtKey>> _getSharedKeys() async {

    return await AtClientManager.getInstance()
          .atClient
          .getAtKeys('cached.*');
  }

  Future<Map<String?, String>> _getSharedNotes() async {

    List<AtKey> sharedKyesList = await _getSharedKeys();

  }*/
}