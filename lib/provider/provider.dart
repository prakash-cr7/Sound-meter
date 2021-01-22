import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';

class MicData extends ChangeNotifier {
  bool isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;
  int dB = 0;

  //call this in initState
  void initNoiseMeter() {
    _noiseMeter = new NoiseMeter(onError);
  }

  void onError(PlatformException e) {
    print(e.toString());
    isRecording = false;
  }

  void onData(NoiseReading noiseReading) {
    if (!isRecording) {
      isRecording = true;
    }
    if (noiseReading.meanDecibel.isFinite)
      dB = noiseReading.meanDecibel.toInt();
    notifyListeners();
  }

  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
      print('start');
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      isRecording = false;
    } catch (err) {
      print('stopRecorder error: $err');
    }
    notifyListeners();
  }
}
