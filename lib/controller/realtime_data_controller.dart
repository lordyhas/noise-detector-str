
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';


class RealtimeDataController {
  late DatabaseReference _counterRef;
  late DatabaseReference _messagesRef;
  late StreamSubscription<DatabaseEvent> _counterSubscription;
  late StreamSubscription<DatabaseEvent> _messagesSubscription;
  FirebaseException? _error;

  bool initialized = false;

  RealtimeDataController({
    String refName = "detect_data"
  }):
        _counterRef = FirebaseDatabase.instance.ref(refName), _error = null ;


  Future<void> init() async {
    //_counterRef = FirebaseDatabase.instance.ref('counter_noise');

    final database = FirebaseDatabase.instance;

    _messagesRef = database.ref('message_noise');

    database.setLoggingEnabled(false);

    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
      await _counterRef.keepSynced(true);
    }

    //setState(() {
    initialized = true;
    //});

    try {
      final counterSnapshot = await _counterRef.get();

      debugPrint(
        'Connected to directly configured database and read '
            '${counterSnapshot.value}',
      );
    } catch (err) {
      debugPrint("$err");
    }

    /*_counterSubscription = _counterRef.onValue.listen(
          (DatabaseEvent event) {
        //setState(() {
          _error = null;
          _counter = (event.snapshot.value ?? 0) as int;
        //});
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        setState(() {
          _error = error;
        });
      },
    );*/

    final messagesQuery = _messagesRef.limitToLast(10);

    _messagesSubscription = messagesQuery.onChildAdded.listen(
          (DatabaseEvent event) {
        print('Child added: ${event.snapshot.value}');
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        print('Error: ${error.code} ${error.message}');
      },
    );
  }

  void close(){
    //_messagesSubscription.cancel();
    _counterSubscription.cancel();
  }

  Future<void> _incrementAsTransaction() async {
    try {
      final transactionResult = await _counterRef.runTransaction((mutableData) {
        return Transaction.success((mutableData as int? ?? 0) + 1);
      });

      if (transactionResult.committed) {
        final newMessageRef = _messagesRef.push();
        await newMessageRef.set(<String, String>{
          ///_kTestKey: '$_kTestValue ${transactionResult.snapshot.value}',
        });
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> _deleteMessage(DataSnapshot snapshot) async {
    final messageRef = _messagesRef.child(snapshot.key!);
    await messageRef.remove();
  }
}






class NoiseModel {
  final int id;
  final String dateTime;
  final String noiseValue;
  final String deviceName;
  final Map<String, String> location;

//<editor-fold desc="Data Methods">
  const NoiseModel({
    required this.id,
    required this.dateTime,
    required this.noiseValue,
    required this.deviceName,
    required this.location,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is NoiseModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              dateTime == other.dateTime &&
              noiseValue == other.noiseValue &&
              deviceName == other.deviceName &&
              location == other.location);

  @override
  int get hashCode =>
      id.hashCode ^
      dateTime.hashCode ^
      noiseValue.hashCode ^
      deviceName.hashCode ^
      location.hashCode;

  @override
  String toString() {
    return 'DataModel{'
        ' id: $id,'
        ' dateTime: $dateTime,'
        ' noiseValue: $noiseValue,'
        ' deviceName: $deviceName,'
        ' location: $location,'
        '}';
  }

  NoiseModel copyWith({
    int? id,
    String? dateTime,
    String? noiseValue,
    String? deviceName,
    Map<String, String>? location,
  }) {
    return NoiseModel(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      noiseValue: noiseValue ?? this.noiseValue,
      deviceName: deviceName ?? this.deviceName,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'dateTime': this.dateTime,
      'noiseValue': this.noiseValue,
      'deviceName': this.deviceName,
      'location': this.location,
    };
  }

  factory NoiseModel.fromMap(Map<String, dynamic> map) {
    return NoiseModel(
      id: map['id'] as int,
      dateTime: map['dateTime'] as String,
      noiseValue: map['noiseValue'] as String,
      deviceName: map['deviceName'] as String,
      location: map['location'] as Map<String, String>,
    );
  }

//</editor-fold>
}