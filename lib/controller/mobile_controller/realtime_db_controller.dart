
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../model/NoiseModel.dart';


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
  final Stopwatch _chrono = Stopwatch();

  RealtimeDataController({
    String refName = "detect_data",
  }):   _alertCounterRef = FirebaseDatabase.instance.ref(refName).child("alert_counter"),
        _messagesRef = FirebaseDatabase.instance.ref(refName).child('info_noise'),
        _error = null ;

  bool get isInitialized => initialized;

  DatabaseReference get alertCounterRef => _alertCounterRef;
  DatabaseReference get messagesRef => _messagesRef;
  FirebaseException? get error => _error;

  Future<void> init({
    void Function(DatabaseEvent event)? onCounterChanged,
    void Function(FirebaseException exception)? onError,
    required void Function(DatabaseEvent event) onMessageReceived,
  }) async {
    initialized = true;

    final responseQuery = _messagesRef.limitToLast(1);

    _receiveMessagesSubscription = responseQuery.onChildAdded.listen(
          (DatabaseEvent event) {
            if(kDebugMode){
              _chrono.stop();
              debugPrint('Noise saved in db: ${event.snapshot.value}');
              debugPrint('##### Response serveur, Temps d\'ecoulé (ms): ${_chrono.elapsedMilliseconds} milli sec');
              //debugPrint('##### Temps d\'ecoulé: ${_chrono.elapsedMicroseconds} Micro sec');
            }
            onMessageReceived(event);
          },
      onError: (Object o) {
        final error = o as FirebaseException;
        onError!(error);
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
      _chrono.start();
      print("************* START CHRONO *********************");
    }
    await _messagesRef.push().set(data.toMap());
    await _alertCounterRef.set(ServerValue.increment(1));
  }

  void deleteMessage(DataSnapshot snapshot) async {
    final ref = _messagesRef.child(snapshot.key!);
    await ref.remove();
  }
}




