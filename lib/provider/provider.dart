import 'dart:async';
import 'dart:math';

import 'package:decibel_meter/ui/widgets/realtime_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';

class MicData extends ChangeNotifier {
  bool isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;
  int dB = 0;
  int calibration = 0;
  int minimum = 0, maximum = 0;
  int average = 0;
  bool doReset = false;

  void toggleResetCall() {
    doReset = !doReset;
    minimum = 0;
    maximum = 0;
    average = 0;
    notifyListeners();
  }

  void calculateMinMaxAvg(List<ChartData> chartData) {
    List<int> dbList = [];
    int avg = 0;
    for (ChartData data in chartData) {
      dbList.add(data.decibel);
      avg += data.decibel;
    }
    if (dbList.isNotEmpty) {
      average = (avg ~/ dbList.length);
      minimum = dbList.reduce(min);
      maximum = dbList.reduce(max);
    }
    notifyListeners();
  }

  void calibrate(int newCalibration) {
    calibration = newCalibration;
    notifyListeners();
  }

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
      dB = noiseReading.meanDecibel.toInt() + calibration;
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
