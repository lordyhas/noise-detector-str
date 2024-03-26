
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../model/NoiseModel.dart';


class RealtimeDataController {
  late final DatabaseReference _alertCounterRef;
  late final DatabaseReference _messagesRef;
  late final DatabaseReference _responseWebRef;
  //late StreamSubscription<DatabaseEvent> _counterSubscription;
  late StreamSubscription<DatabaseEvent> _receiveMessagesSubscription;
  FirebaseException? _error;

  final FirebaseDatabase database = FirebaseDatabase.instance;

  bool initialized = false;

  // Chrono
  Stopwatch chrono = Stopwatch();

  RealtimeDataController({
    String refName = "detect_data",
    //this.database = FirebaseDatabase.instance,
  }):   _alertCounterRef = FirebaseDatabase.instance.ref(refName).child("alert_counter"),
        _messagesRef = FirebaseDatabase.instance.ref(refName).child('info_noise'),
        _error = null ;

  bool get isInitialized => initialized;

  DatabaseReference get alertCounterRef => _alertCounterRef;
  DatabaseReference get messagesRef => _messagesRef;
  FirebaseException? get error => _error;

  Future<void> init({
    void Function(DatabaseEvent event)? onCounterChanged,
    void Function(FirebaseException exception, String? type)? onError,
    required void Function(DatabaseEvent event)? onMessageReceived,
  }) async {

    //if (!kIsWeb) await _alertCounterRef.keepSynced(true);

    initialized = true;

    /*_counterSubscription = _alertCounterRef.onValue.listen(
          (DatabaseEvent event) {
          _error = null;
          //_counter = (event.snapshot.value ?? 0) as int;
          onCounterChanged!(event);
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        onError!(error, "Counter Error");
        _error = error;
      },
    );*/


    // limit the number of response to one instance only
    //final responseQuery = _responseWebRef.limitToLast(1);
    final responseQuery = _messagesRef.limitToLast(1);

    _receiveMessagesSubscription = responseQuery.onChildAdded.listen(
          (DatabaseEvent event) {
            if(kDebugMode){
              chrono.stop();
              debugPrint('Noise saved in db: ${event.snapshot.value}');
              debugPrint('##### Temps d\'ecoulé (ms): ${chrono.elapsedMilliseconds} milli sec');
              debugPrint('##### Temps d\'ecoulé: ${chrono.elapsedMicroseconds} Micro sec');
            }
            onMessageReceived!(event);
          },
      onError: (Object o) {
        final error = o as FirebaseException;
        onError!(error, "Message Error");
        _error = error;
        if (kDebugMode) {
          print('Error: ${error.code} ${error.message}');
        }
      },
    );
  }

  void close(){
    _receiveMessagesSubscription.cancel();
    //_counterSubscription.cancel();
  }

  Future<void> sendMessage(NoiseModel data) async {
    if (kDebugMode) {
      chrono.start();
      print("************* START CHRONO *********************");
    }
    await _messagesRef.push().set(data.toMap());
    await _alertCounterRef.set(ServerValue.increment(1));
  }

  Future<void> deleteMessage(DataSnapshot snapshot) async {
    final messageRef = _messagesRef.child(snapshot.key!);
    await messageRef.remove();
  }
}
