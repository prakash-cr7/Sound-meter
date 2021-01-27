import 'dart:async';

import 'package:decibel_meter/provider/noise_levels.dart';
import 'package:decibel_meter/provider/provider.dart';
import 'package:decibel_meter/ui/widgets/realtime_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState() {
    timer = Timer.periodic(Duration(milliseconds: 500), getdB);
  }

  SharedPreferences sharedPreferences;
  Color bgColor;
  bool switchStatus = true;
  Timer timer;
  int dB = 0;
  int calibration = 0;

  void initSp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getSwitch();
  }

  void getSwitch() {
    bool s = sharedPreferences.getBool('switchStatus');
    if (s != null) {
      switchStatus = s;
    } else
      switchStatus = true;
    switchStatus ? bgColor = Colors.black : bgColor = Colors.white;
    setState(() {});
  }

  void getdB(Timer timer) {
    dB = Provider.of<MicData>(context, listen: false).dB;
  }

  @override
  void initState() {
    initSp();
    Provider.of<MicData>(context, listen: false).initNoiseMeter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.ideographic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      dB.toString(),
                      style: TextStyle(
                        fontSize: 130,
                        color: Colors.lightBlue,
                      ),
                    ),
                    Text(
                      'dB',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.lightBlue,
                          textBaseline: TextBaseline.alphabetic),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  noiseLabel(dB),
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.red),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MIN = ${Provider.of<MicData>(context, listen: false).minimum}',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.lightBlue),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Text(
                        'AVG = ${Provider.of<MicData>(context, listen: false).average}',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.lightBlue),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Text(
                        'MAX = ${Provider.of<MicData>(context, listen: false).maximum}',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.lightBlue),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                SizedBox(height: height * 0.32, child: SfChart()),
                SizedBox(
                  height: height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                        child: Icon(
                          Icons.change_history,
                          color: Colors.white,
                          size: 30,
                        ),
                        backgroundColor: Colors.grey[700],
                        tooltip: 'Calibration',
                        onPressed: () {
                          HapticFeedback.vibrate();
                          calibrationAlert(context, bgColor, () {
                            Provider.of<MicData>(context, listen: false)
                                .calibrate(calibration);
                            Navigator.pop(context);
                          });
                        }),
                    SizedBox(width: width * 0.06),
                    FloatingActionButton(
                        child: Icon(
                          Provider.of<MicData>(context, listen: true)
                                  .isRecording
                              ? Icons.stop
                              : Icons.play_arrow,
                          size: 30,
                        ),
                        backgroundColor:
                            Provider.of<MicData>(context, listen: true)
                                    .isRecording
                                ? Colors.red
                                : Color(0xff02d39a),
                        onPressed: () {
                          HapticFeedback.vibrate();
                          Provider.of<MicData>(context, listen: false)
                                  .isRecording
                              ? Provider.of<MicData>(context, listen: false)
                                  .stop()
                              : Provider.of<MicData>(context, listen: false)
                                  .start();
                        }),
                    SizedBox(width: width * 0.06),
                    FloatingActionButton(
                        child: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 30,
                        ),
                        backgroundColor: Colors.grey[700],
                        onPressed: () {
                          HapticFeedback.vibrate();
                          Provider.of<MicData>(context, listen: false)
                              .toggleResetCall();
                        }),
                  ],
                )
              ],
            ),
          ),
          Positioned(
              top: 55,
              right: 30,
              child: Switch(
                value: switchStatus,
                inactiveTrackColor: Colors.lightBlue,
                onChanged: (value) {
                  switchStatus = value;
                  setState(() {});
                  value == true
                      ? bgColor = Colors.black
                      : bgColor = Colors.white;
                  sharedPreferences.setBool('switchStatus', value);
                },
              ))
        ],
      ),
    );
  }

  Future<Widget> calibrationAlert(
      BuildContext _, Color bgColor, Function onPressed) {
    return showDialog(
        context: _,
        builder: (_) {
          return StatefulBuilder(builder: (_, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              title: Text(
                'Calibration',
                style: TextStyle(color: Colors.lightBlue),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    calibration.toString(),
                    style: TextStyle(color: Colors.lightBlue, fontSize: 65),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                        activeTrackColor: Colors.lightBlue,
                        inactiveTrackColor: Colors.grey,
                        thumbColor: Colors.blue,
                        trackHeight: 05,
                        thumbShape:
                            RoundSliderThumbShape(disabledThumbRadius: 10),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 20),
                        overlayColor: Colors.lightBlue[200]),
                    child: Slider(
                      min: -20,
                      max: 20,
                      value: calibration.toDouble(),
                      onChanged: (double number) {
                        calibration = number.round();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(_);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.lightBlue),
                    )),
                TextButton(
                    onPressed: onPressed,
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.lightBlue),
                    ))
              ],
            );
          });
        });
  }
}
