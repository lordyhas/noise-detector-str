import 'dart:async';

import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noise_detector_str/noise_m.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';


class MobileUIApp extends StatelessWidget {
  const MobileUIApp({super.key});

  void requestPermission() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      //Permission.storage,
      Permission.microphone,
    ].request();
    debugPrint("${statuses[Permission.location]}");

    //return statuses;
  }

  // This widget is the root of the mobile application.
  @override
  Widget build(BuildContext context) {
    requestPermission();
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

  bool _isRecording = false;
  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late final NoiseMeter noiseMeter;

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  final _progress = 90.0;

  @override
  void initState() {
    super.initState();
    noiseMeter = NoiseMeter();
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) =>
      setState(() => _latestReading = noiseReading);

  void onError(Object error) {
    print(error);
    stop();
  }

  double getNoisedB(double? noise){
   if(noise == null || noise.isInfinite) {
     return 0.0;
   }
    return noise;
  }


  /// Start noise sampling.
  Future<void> start() async {
    // Create a noise meter, if not already done.


    // Listen to the noise stream.
    _noiseSubscription = noiseMeter.noise.listen(onData, onError: onError);
    setState(() => _isRecording = true);
  }

  /// Stop sampling.
  void stop() {
    _noiseSubscription?.cancel();
    setState(() => _isRecording = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Noise detector"), // Where noise ?
        actions: [
          IconButton(
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
                onPressed: _isRecording ? stop : start,
                child: _isRecording ? const Text("Stop") : const Text("Record") ,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isRecording ? Colors.red : Colors.green,
        onPressed: _isRecording ? stop : start,
        child: _isRecording ? const Icon(Icons.stop) : const Icon(Icons.mic),
      ),

    );
  }
}
