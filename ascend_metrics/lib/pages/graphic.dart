import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_ForcePoint> data = [
    _ForcePoint(100, 35),
    _ForcePoint(200, 28),
    _ForcePoint(300, 34),
    _ForcePoint(400, 32),
    _ForcePoint(500, 40)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Column(children: [
          SfCartesianChart(
              title: ChartTitle(text: 'Force over time'),
              
              primaryXAxis: NumericAxis(
                title: AxisTitle(text: 'Time (ms)')
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Force (kg)')
              ),

              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enableMouseWheelZooming: true,
                enableDoubleTapZooming: true,
                enablePanning: true),
              
              //plotAreaBorderWidth: 5,
              //plotAreaBorderColor: Colors.red,
              //plotAreaBackgroundColor: Colors.lightGreen,

              palette: const <Color>[Colors.teal],

              series: <CartesianSeries<_ForcePoint, num>>[
                LineSeries<_ForcePoint, num>(
                    dataSource: data,
                    xValueMapper: (_ForcePoint points, _) => points.time,
                    yValueMapper: (_ForcePoint points, _) => points.force,
                    xAxisName: "Time in MS",
                    yAxisName: "Force in KG",

                    markerSettings: const MarkerSettings(isVisible: true),
                    name: 'Sales')
              ]),
        ]));
  }
}

class _ForcePoint {
  _ForcePoint(this.time, this.force);

  final int time;
  final double force;
}