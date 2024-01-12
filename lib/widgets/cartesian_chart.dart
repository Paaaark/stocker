import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CartesianChart extends StatefulWidget {
  final List<CartesianSeries> cartesianSeries;
  final int flex;
  final Function onZoom;
  final Function onCreateAxisController;
  final double initialZoomPosition;
  final double initialZoomFactor;

  const CartesianChart.createChart(
      this.cartesianSeries,
      this.flex,
      this.onZoom,
      this.onCreateAxisController,
      this.initialZoomPosition,
      this.initialZoomFactor,
      {super.key});

  @override
  State<CartesianChart> createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: widget.flex,
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            initialVisibleMinimum: DateTime.parse("2023-07-01"),
            initialVisibleMaximum: DateTime.parse("2024-01-10"),
            initialZoomPosition: widget.initialZoomPosition,
            initialZoomFactor: widget.initialZoomFactor,
            autoScrollingMode: AutoScrollingMode.end,
            name: 'primaryXAxis',
            onRendererCreated: (DateTimeAxisController controller) {
              widget.onCreateAxisController(controller);
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
          series: widget.cartesianSeries,
        ));
  }
}
