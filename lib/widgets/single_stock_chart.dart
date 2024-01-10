import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stocker/models/time_series_daily.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stocker/services/api_service.dart';

class SingleStockChart extends StatefulWidget {
  const SingleStockChart({
    super.key,
  });

  @override
  State<SingleStockChart> createState() => _SingleStockChartState();
}

class _SingleStockChartState extends State<SingleStockChart> {
  bool showSettings = false;
  bool isLoading = true;
  String symbol = "IBM";
  List<DataType> dataTypes = [
    DataType.sma,
  ];
  List<DataType> dataTypeOptions = [
    DataType.stockDaily,
    DataType.sma,
  ];
  List<CartesianSeries> cartesianSeries = [];
  List<dynamic> dataSeries = [];

  void toggleShowSettings() {
    showSettings = !showSettings;
    setState(() {});
  }

  void waitForData(DataType dataType) async {
    // Turn on loading mode to fetch the data
    isLoading = true;
    setState(() {});

    // Fetch the data using APIService
    dynamic tempHolder = await APIService.fetchDataByType(symbol, dataType);
    dataSeries.add(tempHolder);
    cartesianSeries.add(dataSeries[dataSeries.length - 1].getCartesianSeries());

    // When loading is done, display it on the screen
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    waitForData(DataType.sma);
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 1,
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Single Stock Chart: $symbol",
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
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
                          onPressed: () => {
                            toggleShowSettings(),
                          },
                          icon: const Icon(Icons.settings),
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: isLoading
                        ? const Text("Loading...")
                        : SfCartesianChart(
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
                            series: cartesianSeries,
                          ),
                  ),
                ],
              ),
            ),
            if (showSettings)
              ModalBarrier(
                color: Colors.black.withAlpha(200),
                onDismiss: () {
                  toggleShowSettings();
                },
              ),
            if (showSettings)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Series"),
                    ...dataTypeOptions.map<Widget>((DataType selectedDataType) {
                      return _seriesDropdownButton(
                          selectedDataType, dataTypeOptions);
                    }).toList(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

DropdownButton _seriesDropdownButton(
    DataType selectedDataType, List<DataType> dataTypeOptions) {
  return DropdownButton<DataType>(
    value: selectedDataType,
    items: dataTypeOptions.map<DropdownMenuItem<DataType>>((DataType value) {
      return DropdownMenuItem<DataType>(
        value: value,
        child: Text(APIService.dataTypeEnumToString[value]!),
      );
    }).toList(),
    onChanged: (DataType? value) => {},
  );
}
