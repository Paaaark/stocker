import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stocker/models/time_series_daily.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SingleStockChart extends StatelessWidget {
  const SingleStockChart({
    super.key,
    required this.timeSeriesDaily,
  });

  final TimeSeriesDaily? timeSeriesDaily;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 1,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Single Stock Chart: ${timeSeriesDaily!.symbol}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.displayLarge?.color,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: TextField(
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Theme.of(context).highlightColor,
                        hintText: 'Ticker & Enter...',
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  child: IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.settings),
                    color: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SfCartesianChart(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
