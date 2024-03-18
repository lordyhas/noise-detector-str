
class NoiseModel {
  final dynamic id;
  final String dateTime;
  final double noiseValue;
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
    id,
    String? dateTime,
    double? noiseValue,
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
      id: map['id'],
      dateTime: map['dateTime'] as String,
      noiseValue: map['noiseValue'] as double,
      deviceName: map['deviceName'] as String,
      location: map['location'] as Map<String, String>,
    );
  }

//</editor-fold>
}