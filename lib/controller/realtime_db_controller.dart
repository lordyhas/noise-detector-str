
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../model/NoiseModel.dart';


class RealtimeDataController {
  late final DatabaseReference _alertCounterRef;
  late final DatabaseReference _messagesRef;
  late StreamSubscription<DatabaseEvent> _counterSubscription;
  late StreamSubscription<DatabaseEvent> _messagesSubscription;
  FirebaseException? _error;

  final FirebaseDatabase database = FirebaseDatabase.instance;

  bool initialized = false;

  // Chrono
  Stopwatch chrono = Stopwatch();

  RealtimeDataController({
    String refName = "detect_data",
    //this.database = FirebaseDatabase.instance,

  }):
        //database = FirebaseDatabase.instance,
        _alertCounterRef = FirebaseDatabase.instance.ref(refName).child("alert_counter"),
        _messagesRef = FirebaseDatabase.instance.ref(refName).child('info_noise'),
        _error = null ;

  bool get isInitialized => initialized;

  DatabaseReference get alertCounterRef => _alertCounterRef;
  DatabaseReference get messagesRef => _messagesRef;
  FirebaseException? get error => _error;

  Future<void> init({
    required void Function(DatabaseEvent event) onCounterChanged,
    required void Function(FirebaseException exception,[String type]) onError,
    void Function(DatabaseEvent event)? onMessageReceived,
  }) async {

    if (!kIsWeb) {
      await _alertCounterRef.keepSynced(true);
    }

    initialized = true;

    try {
      final counterSnapshot = await _alertCounterRef.get();

      debugPrint(
        'Connected to directly configured database and read '
            '${counterSnapshot.value}',
      );
    } catch (err) {
      debugPrint("$err");
    }

    _counterSubscription = _alertCounterRef.onValue.listen(
          (DatabaseEvent event) {
          _error = null;
          //_counter = (event.snapshot.value ?? 0) as int;
          onCounterChanged(event);
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        onError(error, "Counter Error");
        _error = error;
      },
    );

    final messagesQuery = _messagesRef.limitToLast(10);

    _messagesSubscription = messagesQuery.onChildAdded.listen(
          (DatabaseEvent event) {
            onMessageReceived!(event);
            if(kDebugMode){
              chrono.stop();
              debugPrint('Noise saved in db: ${event.snapshot.value}');
              debugPrint('##### Temps d\'ecoulé: ${chrono.elapsedMilliseconds} ms');
            }
          },
      onError: (Object o) {
        final error = o as FirebaseException;
        onError(error, "Message Error");
        _error = error;
        if (kDebugMode) {
          print('Error: ${error.code} ${error.message}');
        }
      },
    );
  }

  void close(){
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }

  Future<void> sendMessage(NoiseModel data) async {
    await _alertCounterRef.set(ServerValue.increment(1));

    await _messagesRef
        .push()
        .set(data.toMap());
        //.set(<String, String>{_kTestKey: '$_kTestValue $_counter'});
    if (kDebugMode) {
      chrono.start();
    }
  }

  /*Future<void> _incrementAsTransaction() async {
    try {
      final transactionResult = await _alertCounterRef.runTransaction((mutableData) {
        return Transaction.success((mutableData as int? ?? 0) + 1);
      });

      if (transactionResult.committed) {
        final newMessageRef = _messagesRef.push();
        await newMessageRef.set(<String, String>{
          ///_kTestKey: '$_kTestValue ${transactionResult.snapshot.value}',
        });
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }*/

  Future<void> deleteMessage(DataSnapshot snapshot) async {
    final messageRef = _messagesRef.child(snapshot.key!);
    await messageRef.remove();
  }
}
