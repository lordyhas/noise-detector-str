
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


class RealTimeBD {
  late DatabaseReference _counterRef;
  late StreamSubscription<DatabaseEvent> _counterSubscription;
  FirebaseException? _error;

  RealTimeBD({
    String refName = "detect_data"
  }):
        _counterRef = FirebaseDatabase.instance.ref(refName), _error = null ;

  void close(){
    //_messagesSubscription.cancel();
    _counterSubscription.cancel();
  }
}


class DataModel {
  final int id;
  final String dateTime;
  final String noiseValue;
  final String deviceName;
  final Map<String, String> location;

//<editor-fold desc="Data Methods">
  const DataModel({
    required this.id,
    required this.dateTime,
    required this.noiseValue,
    required this.deviceName,
    required this.location,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is DataModel &&
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

  DataModel copyWith({
    int? id,
    String? dateTime,
    String? noiseValue,
    String? deviceName,
    Map<String, String>? location,
  }) {
    return DataModel(
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

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      id: map['id'] as int,
      dateTime: map['dateTime'] as String,
      noiseValue: map['noiseValue'] as String,
      deviceName: map['deviceName'] as String,
      location: map['location'] as Map<String, String>,
    );
  }

//</editor-fold>
}