import 'package:flutter/material.dart';
import 'package:stocker/models/data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianChart extends StatefulWidget {
  final Map<String, CartesianSeries> cartesianSeries;
  final Map<String, DataModel> dataSeries;
  final bool isMainChart;
  final int flex;
  final Function onZoom;
  final Function onCreateAxisController;
  final Function onChipPressed;
  final String chartId;

  CartesianChart.createChart(
      {required this.dataSeries,
      required cartesianChartFunctions,
      required this.chartId,
      this.isMainChart = false,
      super.key})
      : cartesianSeries = dataSeries.map<String, CartesianSeries>(
            (key, value) => MapEntry(key, value.getCartesianSeries())),
        onZoom = cartesianChartFunctions["onZoom"],
        onCreateAxisController =
            cartesianChartFunctions["onCreateAxisController"],
        onChipPressed = cartesianChartFunctions["onChipPressed"],
        flex = isMainChart ? 3 : 1;

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
              widget.onCreateAxisController(controller, widget.chartId);
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
          series: widget.cartesianSeries.values.toList(),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 11),
          child: Row(
            children: [
              for (MapEntry<String, DataModel> item
                  in widget.dataSeries.entries)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: InputChip(
                    label: Text(item.value.getSummary()),
                    labelStyle: const TextStyle(
                      fontSize: 12,
                    ),
                    onPressed: () {
                      widget.onChipPressed(
                          item.value, widget.chartId, item.key);
                    },
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
