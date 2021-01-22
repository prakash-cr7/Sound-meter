import 'dart:async';

import 'package:decibel_meter/provider/provider.dart';
import 'package:decibel_meter/ui/widgets/realtime_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState() {
    timer = Timer.periodic(Duration(milliseconds: 500), getdB);
  }

  Color bgColor = Colors.black;
  bool switchStatus = true;
  Timer timer;
  int dB = 0;
  void getdB(Timer timer) {
    dB = Provider.of<MicData>(context, listen: false).dB;
  }

  @override
  void initState() {
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
                  'Normal conversation',
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
                        'MIN = 34',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.lightBlue),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Text(
                        'AVG = 58',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.lightBlue),
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      Text(
                        'MAX = 84',
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
                        onPressed: null),
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
                      onPressed: null,
                    ),
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
                },
              ))
        ],
      ),
    );
  }
}
