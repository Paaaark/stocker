import 'package:flutter/material.dart';
import 'package:stocker/models/data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianChart extends StatefulWidget {
  final List<CartesianSeries> cartesianSeries;
  final List<DataModel> dataSeries;
  final int flex;
  final Function onZoom;
  final Function onCreateAxisController;
  final int chartIndex;

  CartesianChart.createChart(this.dataSeries, this.flex, this.onZoom,
      this.onCreateAxisController, this.chartIndex, {super.key})
      : cartesianSeries = dataSeries
            .map<CartesianSeries>((entry) => entry.getCartesianSeries())
            .toList();

  @override
  State<CartesianChart> createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Stack(children: [
        SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            initialVisibleMinimum: DateTime.parse("2023-07-01"),
            initialVisibleMaximum: DateTime.parse("2024-01-10"),
            initialZoomPosition: 0,
            initialZoomFactor: 1,
            autoScrollingMode: AutoScrollingMode.end,
            name: 'primaryXAxis',
            onRendererCreated: (DateTimeAxisController controller) {
              widget.onCreateAxisController(controller, widget.chartIndex);
            },
          ),
          primaryYAxis: const NumericAxis(
            anchorRangeToVisiblePoints: true,
          ),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            zoomMode: ZoomMode.x,
            enablePanning: true,
            enableMouseWheelZooming: true,
          ),
          onZoomStart: (ZoomPanArgs args) {
            if (args.axis?.name == 'primaryXAxis') {
              widget.onZoom(args.currentZoomPosition, args.currentZoomFactor);
            }
          },
          onZooming: (ZoomPanArgs args) {
            if (args.axis?.name == 'primaryXAxis') {
              widget.onZoom(args.currentZoomPosition, args.currentZoomFactor);
            }
          },
          series: widget.cartesianSeries,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 11),
          child: Row(
            children: [
              for (dynamic series in widget.dataSeries)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Chip(
                    label: Text(series.getSummary()),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
