

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class ResponseController {
  static const String refName = "detect_data";

  late final DatabaseReference _responseRef;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  late StreamSubscription<DatabaseEvent> _receiveSubscription;


  ResponseController(): _responseRef = FirebaseDatabase.instance
      .ref(refName).child("web_response");

  void listen({
    required void Function(DatabaseEvent event) onMessageReceived,
    void Function(FirebaseException exception)? onError,
  }) async {
    final responseQuery = _responseRef.limitToLast(1);

    _receiveSubscription = responseQuery.onChildAdded.listen(
          (DatabaseEvent event) => onMessageReceived(event),
      onError: (Object o) {
        final error = o as FirebaseException;
        onError!(error);
      },
    );
  }

  void sendResponse(Map<String,String> map) async {
    await _responseRef.push().set(map);
  }

  void close(){
    _receiveSubscription.cancel();
    //_counterSubscription.cancel();
  }
}