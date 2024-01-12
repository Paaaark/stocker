import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stocker/widgets/cartesian_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stocker/services/api_service.dart';

List<DataType> dataTypeCategoryOne = [
  DataType.stockDaily,
  DataType.sma,
];

class StockChartSkeleton extends StatefulWidget {
  const StockChartSkeleton({
    super.key,
  });

  @override
  State<StockChartSkeleton> createState() => _StockChartSkeletonState();
}

class _StockChartSkeletonState extends State<StockChartSkeleton> {
  bool showSettings = false;
  bool isLoading = true;
  String symbol = "IBM";
  List<DataType> dataTypeOptions = DataType.values;
  List<DataType> dataTypes = [
    DataType.stockDaily,
  ];
  List<CartesianChart> charts = [];
  List<List<CartesianSeries>> cartesianSeries = [[]];
  List<List<dynamic>> dataSeries = [[]];

  List<DateTimeAxisController> axisControllers = [];

  @override
  void initState() {
    super.initState();
    waitForData(dataTypes);
    charts.add(CartesianChart.createChart(
      cartesianSeries[0],
      3,
      onZoom,
      onCreateAxisController,
      0,
      1,
    ));
    setState(() {});
  }

  void waitForData(List<DataType> dataTypes) async {
    // Turn on loading mode to fetch the data
    isLoading = true;
    setState(() {});

    // Fetch the data using APIService
    for (DataType dataType in dataTypes) {
      dynamic tempHolder = await APIService.fetchDataByType(symbol, dataType);
      if (dataTypeCategoryOne.contains(dataType)) {
        dataSeries[0].add(tempHolder);
        cartesianSeries[0].add(tempHolder.getCartesianSeries());
      } else {
        dataSeries.add([tempHolder]);
        cartesianSeries.add([tempHolder.getCartesianSeries()]);
        charts.add(CartesianChart.createChart(
          cartesianSeries[cartesianSeries.length - 1],
          1,
          onZoom,
          onCreateAxisController,
          0,
          1,
        ));
      }
    }

    // When loading is done, display it on the screen
    isLoading = false;
    setState(() {});
  }

  void toggleShowSettings() {
    /// When closing the settings, update the charts
    if (showSettings == true) {
      waitForData(dataTypes);
    }
    showSettings = !showSettings;
    setState(() {});
  }

  void addDataType() {
    dataTypes.add(DataType.stockDaily);
    setState(() {});
  }

  void onSelectDataType(int index, DataType value) {
    setState(() {
      dataTypes[index] = value;
    });
  }

  // Synchronized zooming between all charts
  void onZoom(double currentZoomPosition, double currentZoomFactor) {
    for (DateTimeAxisController axisController in axisControllers) {
      axisController.zoomPosition = currentZoomPosition;
      axisController.zoomFactor = currentZoomFactor;
    }
    setState(() {});
  }

  // When a new chart is rendered, add its controller to the list
  void onCreateAxisController(DateTimeAxisController axisController) {
    axisControllers.add(axisController);
    print("Axis Controller Added!");
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 1 + (charts.length - 1) * 0.33,
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
                  if (isLoading) const Text("Loading..."),
                  if (!isLoading) ...charts,
                ],
              ),
            ),
            if (showSettings)

              /// #TODO: Use Animated Modal Barrier
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
                    for (var i = 0; i < dataTypes.length; i++)
                      _seriesDropdownButton(dataTypes[i], i),
                    IconButton(
                      onPressed: addDataType,
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

  DropdownButton _seriesDropdownButton(DataType selectedDataType, int index) {
    return DropdownButton<DataType>(
      value: selectedDataType,
      items: dataTypeOptions.map<DropdownMenuItem<DataType>>((DataType value) {
        return DropdownMenuItem<DataType>(
          value: value,
          child: Text(APIService.dataTypeEnumToString[value]!),
        );
      }).toList(),
      onChanged: (DataType? value) => {onSelectDataType(index, value!)},
    );
  }
}
