import 'package:flutter/material.dart';
import 'package:stocker/models/time_series_daily.dart';
import 'package:stocker/services/api_service.dart';
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
                margin: const EdgeInsets.all(40),
                child: SfCartesianChart(
                  title: ChartTitle(
                      text: symbol,
                      textStyle: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      )),
                  primaryXAxis: DateTimeAxis(
                    autoScrollingMode: AutoScrollingMode.end,
                  ),
                  primaryYAxis: NumericAxis(
                    visibleMinimum: 120,
                    visibleMaximum: 180,
                    anchorRangeToVisiblePoints: true,
                  ),
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    zoomMode: ZoomMode.x,
                    enablePanning: true,
                  ),
                  series: <CartesianSeries>[
                    // Renders hiloOpenCloseSeries
                    CandleSeries<DataPointDaily, DateTime>(
                      dataSource: timeSeriesDaily!.asList(),
                      enableSolidCandles: true,
                      xValueMapper: (DataPointDaily data, _) => data.date,
                      lowValueMapper: (DataPointDaily data, _) => data.low,
                      highValueMapper: (DataPointDaily data, _) => data.high,
                      openValueMapper: (DataPointDaily data, _) => data.open,
                      closeValueMapper: (DataPointDaily data, _) => data.close,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
