import 'dart:async';

import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:noise_detector_str/model/NoiseModel.dart';
import 'package:noise_meter/noise_meter.dart';

import 'package:uuid/uuid.dart';

import '../controller/mobile_controller/gps.dart';
import '../controller/mobile_controller/permission_check.dart';
import '../controller/mobile_controller/realtime_db_controller.dart';


class MobileUIApp extends StatelessWidget {
  const MobileUIApp({super.key});

  // This widget is the root of the mobile application.
  @override
  Widget build(BuildContext context) {
    PermissionCheck.requestPermission();
    return MaterialApp(
      title: 'noise detector mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MobileHomePage(),
    );
  }
}

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {

  RealtimeDataController realtimeData = RealtimeDataController();

  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late final NoiseMeter noiseMeter;

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  final _progress = 90.0;

  final Stopwatch _chronoDetect = Stopwatch();
  final Stopwatch _chronoDisplay = Stopwatch();


  late final AndroidDeviceInfo androidInfo ;

  void getAndroidInfo() async {
    AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
    setState(() => androidInfo = info );
  }


  @override
  void initState() {
    super.initState();
    realtimeData.init(
        onMessageReceived: (event){
          debugPrint("############## RECEIVED ##############");
          //showDialog(context: context, builder: builder)
        },
        onError: (error){},
        onCounterChanged: (event){}
    );
    noiseMeter = NoiseMeter();
    getAndroidInfo();
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    realtimeData.close();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    setState(() => _latestReading = noiseReading);

    checkDisturbingNoise(_latestReading?.meanDecibel);
  }


  void onError(Object error) {
    debugPrint("$error");
    stopRecording();
  }

  void checkDisturbingNoise(double? value) async {
    double noise = getNoisedB(value);

    Position position = await GPSLocation.myCurrentPosition();

    //const Uuid().v1(),
    if (noise > 60){
      if(kDebugMode){
        _chronoDetect.start();
      }
      stopRecording();
      // send all information as NoiseModel to the server
      await realtimeData.sendMessage(NoiseModel(
        id: androidInfo.id,
        dateTime: DateTime.now().toString(),
        noiseValue: noise,
        deviceName: androidInfo.model,
        location: <String, String>{
          "latitude":"${position.latitude}",
          "longitude":"${position.longitude}",
        },)
      );

      if(kDebugMode){
        _chronoDetect.stop();
        debugPrint('##### Detection (Temps ecoulé): ${_chronoDetect.elapsedMilliseconds} milli sec');
        debugPrint('##### Detection (Temps ecoulé): ${_chronoDetect.elapsedMicroseconds} Micro sec');
      }
    }
  }


  double getNoisedB(double? noise){
    /// When we're not connected to the microphone we get some null value
    /// and when we start measure the micro send us -inf as first value
    return noise == null || noise.isInfinite ? 0.0 : noise;
  }


  /// Start noise sampling.
  Future<void> startRecording() async {
    // Create a noise meter, if not already done.
    // Listen to the noise stream.
    //todo : mesurer les bruits ici
    /*if(kDebugMode){
      _chronoDisplay.start();
    }*/
    _noiseSubscription = noiseMeter.noise.listen(onData, onError: onError);
    setState(() => _isRecording = true);

    /*if(kDebugMode){
      _chronoDisplay.stop();
      print("----------------");
    }*/
  }

  /// Stop sampling.
  void stopRecording() {
    _noiseSubscription?.cancel();
    setState(() => _isRecording = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Noise detector",
          style: TextStyle(color: Colors.white),
        ), // Where noise ?
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: (){},
            icon: !_isRecording
                ? const Icon(Icons.mic_off)
                : const Icon(Icons.mic),
          )
        ],
      ),
      body:  SizedBox(
        child: Center(
          child:  Column(

            children: [
              const Padding(padding: EdgeInsets.all(16.0)),
              SizedBox.square(
                //dimension: 300,
                child: CircularSeekBar(
                  width: 200,
                  height: 200,
                  maxProgress: 130,
                  progress: double.parse( //_latestReading?.maxDecibel.abs() ??
                      (getNoisedB(_latestReading?.meanDecibel) ?? 70.0).toStringAsFixed(2)),
                  barWidth: 8,
                  startAngle: 45,
                  sweepAngle: 270,
                  strokeCap: StrokeCap.round,
                  trackColor: Colors.grey,
                  progressGradientColors: const [
                    Colors.blue,
                    Colors.indigo,
                    Colors.deepPurpleAccent,
                    Colors.purple,
                  ],
                  //dashWidth: 56.25,
                  dashWidth: 56.2,
                  dashGap: 15,
                  animation: true,
                  valueNotifier: _valueNotifier,
                  child: Center(
                    child: ValueListenableBuilder(
                        valueListenable: _valueNotifier,
                        builder: (_, double value, __) => Padding(
                          padding: const EdgeInsets.only(top:0.0),
                          child: Column(
                            children: [
                              const Spacer(flex: 2,),
                              Text(value.toStringAsFixed(2),),
                              const Text('noise dB', ),
                              const Spacer()
                            ],
                          ),
                        )),
                  ),

                ),

              ),
              Center(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(_isRecording ? "Mic: ON" : "Mic: OFF",
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                          ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Noise: ${getNoisedB(_latestReading?.meanDecibel).toStringAsFixed(2)} dB',
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Max: ${_latestReading?.maxDecibel.toStringAsFixed(2)} dB',
                      ),
                    ),
                  ]),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 64.0),
                  backgroundColor: Colors.deepPurple,

                ),
                onPressed: _isRecording ? stopRecording : startRecording,
                child: Text(_isRecording ? "Stop" : "Record",
                  style: const TextStyle(color: Colors.white),
                )
              ),
              const SizedBox(height: 16.0,),
              const Spacer(),
              const ElevatedButton(
                onPressed: null, // () => Navigator.push(context,SampleHomePage.route()),
                child:  Text("Show data") ,
              ),
              const SizedBox(height: 32.0,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isRecording ? Colors.red : Colors.green,
        onPressed: _isRecording ? stopRecording : startRecording,
        child: _isRecording ? const Icon(Icons.stop) : const Icon(Icons.mic),
      ),

    );
  }
}
