import 'package:flutter/material.dart';
import 'package:stocker/models/time_series_daily.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CandleChart extends StatelessWidget {
  const CandleChart({
    super.key,
    required this.timeSeriesDaily,
  });

  final TimeSeriesDaily? timeSeriesDaily;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(
          text: timeSeriesDaily!.symbol,
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
        enableMouseWheelZooming: true,
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
    );
  }
}
