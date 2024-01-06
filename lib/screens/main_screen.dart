import 'package:flutter/material.dart';
import 'package:stocker/models/time_series_daily.dart';
import 'package:stocker/services/api_service.dart';
import 'package:stocker/widgets/candle_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TimeSeriesDaily? timeSeriesDaily;
  bool isLoading = true;
  String symbol = "IBM";

  void waitForData() async {
    timeSeriesDaily = await APIService.getTimeSeriesDaily(symbol);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    waitForData();
  }

  @override
  Widget build(BuildContext context) {
    print("Build");
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Text("Still Loading!")
            : Container(
                height: 400,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: CandleChart(timeSeriesDaily: timeSeriesDaily),
              ),
      ),
    );
  }
}
