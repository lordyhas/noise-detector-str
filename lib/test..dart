

import 'package:flutter/foundation.dart';

class Measure {
  final String message;
  Measure(this.message);

  final Stopwatch _time = Stopwatch();

  void timeUp(void Function() onRun){
    _time.start();
    onRun();
    _time.stop();
    debugPrint("");
    debugPrint('##### $message (Temps ecoulé): ${_time.elapsedMilliseconds} milli sec');
  }

  get time => _time;
}

