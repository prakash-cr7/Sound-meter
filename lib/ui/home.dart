import 'package:decibel_meter/ui/widgets/realtime_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textBaseline: TextBaseline.ideographic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                '60',
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
                fontSize: 28, fontWeight: FontWeight.w800, color: Colors.red),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          LineChartSample2(),
          SizedBox(
            height: height * 0.04,
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
                    Icons.play_arrow,
                    size: 30,
                  ),
                  backgroundColor: Color(0xff02d39a),
                  onPressed: null),
              SizedBox(width: width * 0.06),
              FloatingActionButton(
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 30,
                  ),
                  backgroundColor: Colors.grey[700],
                  onPressed: null),
            ],
          )
        ],
      ),
    );
  }
}
