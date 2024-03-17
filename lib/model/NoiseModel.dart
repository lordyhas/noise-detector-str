
class NoiseModel {
  final int id;
  final String dateTime;
  final String noiseValue;
  final String deviceName;
  final Map<String, String> location;

//<editor-fold desc="Data Methods">
   NoiseModel({
    required this.id,
    required this.dateTime,
    required this.noiseValue,
    required this.deviceName,
    required this.location,
  });

  bool? selected = false;

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