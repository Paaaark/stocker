import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Future<TimeSeriesDaily> timeSeriesDaily =
  //     APIService.getTimeSeriesDaily("IBM");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(),
      ),
    );
  }
}
