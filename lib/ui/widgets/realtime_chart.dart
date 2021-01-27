import 'dart:async';

import 'package:decibel_meter/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SfChart extends StatefulWidget {
  @override
  _SfChartState createState() => _SfChartState();
}

class _SfChartState extends State<SfChart> {
  _SfChartState() {
    timer = Timer.periodic(Duration(milliseconds: 250), updateData);
  }

  Timer timer;
  ChartSeriesController _chartSeriesController;
  int count = 0;
  List<ChartData> _chartData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getLiveLineChart();
  }

  SfCartesianChart _getLiveLineChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(
            interval: 15,
            desiredIntervals: 6,
            visibleMinimum: count < 90 ? 0 : (count - 90).toDouble(),
            visibleMaximum: count < 90 ? 90 : (count).toDouble(),
            majorGridLines: MajorGridLines(width: 1),
            axisLine: AxisLine(width: 0),
            labelStyle: TextStyle(color: Colors.lightBlue)),
        primaryYAxis: NumericAxis(
            maximum: 100.0,
            visibleMinimum: 0,
            visibleMaximum: 100,
            axisLine: AxisLine(width: 0),
            labelStyle: TextStyle(color: Colors.lightBlue)),
        series: <LineSeries<ChartData, int>>[
          LineSeries<ChartData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: _chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (ChartData sales, _) => sales.time,
            yValueMapper: (ChartData sales, _) => sales.decibel,
          )
        ]);
  }

  void updateData(Timer timer) {
    if (Provider.of<MicData>(context, listen: false).doReset) {
      _chartData = [];
      count = 0;
      Provider.of<MicData>(context, listen: false).toggleResetCall();
    }
    if (!Provider.of<MicData>(context, listen: false).isRecording)
      return;
    else if (_chartData.length >= 90) {
      _chartData.add(
          ChartData(count, Provider.of<MicData>(context, listen: false).dB));
      _chartData.removeAt(0);
      _chartSeriesController.updateDataSource(
        addedDataIndexes: <int>[_chartData.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartData.add(
          ChartData(count, Provider.of<MicData>(context, listen: false).dB));
      // _chartSeriesController.updateDataSource(
      //   addedDataIndexes: <int>[_chartData.length - 1],
      // );
      //// there is a weired error in graph when uncommented above lines.
      //// dunno why.
    }
    Provider.of<MicData>(context, listen: false).calculateMinMaxAvg(_chartData);
    count++;
  }
}

class ChartData {
  ChartData(this.time, this.decibel);
  final num time;
  final num decibel;
}
