import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:noise_detector_str/model/NoiseModel.dart';
import 'package:noise_meter/noise_meter.dart';

import '../realtime_db_controller.dart';



part 'noise_controller_state.dart';

class NoiseMeasurementController extends Cubit<NoiseState> {
  NoiseMeasurementController(NoiseModel value) :
        super(NoiseState(noiseData: value));



  RealtimeDataController realtimeData = RealtimeDataController();

  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late final NoiseMeter noiseMeter;

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  final _progress = 90.0;

  void changeValue(NoiseModel value){
    emit(state..noiseData.copyWith());
  }

}
