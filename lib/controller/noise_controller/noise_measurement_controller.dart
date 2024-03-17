import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';



part 'noise_controller_state.dart';

class NoiseMeasurementController extends Cubit<NoiseState> {
  NoiseMeasurementController() : super(NoiseState());
}
