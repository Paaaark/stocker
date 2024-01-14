import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stocker/models/data_model.dart';
import 'package:stocker/models/data_type_helper.dart';
import 'package:stocker/models/query_params.dart';
import 'package:stocker/widgets/cartesian_chart.dart';
import 'package:stocker/widgets/loading_spinner.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:stocker/services/api_service.dart';

List<DataType> dataTypeCategoryOne = [
  DataType.stockDaily,
  DataType.sma,
];

Map<QueryParam, String> queryParamtoString = {
  QueryParam.interval: "Interval",
  QueryParam.timePeriod: "Time Period",
  QueryParam.seriesType: "Series Type",
};

class StockChartSkeleton extends StatefulWidget {
  const StockChartSkeleton({
    super.key,
  });

  @override
  State<StockChartSkeleton> createState() => _StockChartSkeletonState();
}

class _StockChartSkeletonState extends State<StockChartSkeleton> {
  bool showIndicatorOptions = false;
  bool showIndicatorParameters = false;
  bool isLoading = true;
  bool symbolNotFound = false;
  String symbol = "IBM";

  List<DataType> dataTypeOptions = DataType.values;
  List<DataType> dataTypes = [];
  List<CartesianChart> charts = [];
  List<List<DataModel>> dataSeries = [[]];

  List<Widget> indicatorParamsWidget = [];
  Map<QueryParam, String> indicatorParamsInput = {};

  List<Widget> bestMatchWidgets = [];

  List<DateTimeAxisController> axisControllers = [];

  final TextEditingController _tickerFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addIndicator(DataType.stockDaily, {});
    setState(() {});
  }

  void addIndicator(DataType dataType, Map<QueryParam, String> params) async {
    // Turn on loading mode to fetch the data
    isLoading = true;
    showIndicatorOptions = false;
    setState(() {});

    dataTypes.add(dataType);
    // Fetch the data using APIService
    dynamic tempHolder =
        await APIService.fetchDataByType(symbol, dataType, params);
    if (dataTypeCategoryOne.contains(dataType)) {
      dataSeries[0].add(tempHolder);
      CartesianChart temp = CartesianChart.createChart(
          dataSeries[0], 3, onZoom, onCreateAxisController, 0);
      if (charts.isEmpty) {
        charts.add(temp);
      } else {
        charts[0] = temp;
      }
    } else {
      dataSeries.add([tempHolder]);
      charts.add(CartesianChart.createChart(
        dataSeries[dataSeries.length - 1],
        1,
        onZoom,
        onCreateAxisController,
        dataSeries.length - 1,
      ));
    }

    // When loading is done, display it on the screen
    isLoading = false;
    setState(() {});
  }

  void toggleShowSettings() {
    showIndicatorOptions = !showIndicatorOptions;
    showIndicatorParameters = false;
    setState(() {});
  }

  void toggleIndicatorParamsByDataType(DataType dataType) {
    indicatorParamsWidget.clear();
    indicatorParamsInput.clear();

    /// Add the top text showing the dataType
    indicatorParamsWidget.add(
      Text(
        DataTypeHelper.dataTypeEnumToString[dataType]!,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );

    /// Add an option for each QueryParam
    QueryParamsHelper.getParamsByType(dataType).forEach((key, value) {
      indicatorParamsWidget.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  queryParamtoString[key]!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              QueryParamsHelper.getParamInputWidgetByType(
                  key, indicatorParamsInput.update),
            ],
          ),
        ),
      );
    });

    /// Add the bottom confirm buttons
    indicatorParamsWidget.add(Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              toggleShowSettings();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).highlightColor,
            ),
            child: const Text("Cancel"),
          ),
          const SizedBox(width: 50),
          TextButton(
            onPressed: () {
              addIndicator(dataType, indicatorParamsInput);
              showIndicatorParameters = false;
              setState(() {});
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).highlightColor,
            ),
            child: const Text("Confirm and Add"),
          ),
        ],
      ),
    ));

    showIndicatorOptions = false;
    showIndicatorParameters = true;
    setState(() {});
  }

  void refetchAllData(String newSymbol) async {
    setState(() => isLoading = true);

    try {
      dataSeries = await APIService.refetchAllData(dataSeries, newSymbol);

      for (var i = 0; i < charts.length; i++) {
        charts[i] = CartesianChart.createChart(
          dataSeries[i],
          i == 0 ? 3 : 1,
          onZoom,
          onCreateAxisController,
          0,
        );
      }
      symbol = newSymbol;
    } catch (e) {
      await symbolNotFoundFunction(newSymbol);
    }

    setState(() => isLoading = false);
  }

  Future<void> symbolNotFoundFunction(String newSymbol) async {
    bestMatchWidgets.clear();

    symbolNotFound = true;
    bestMatchWidgets.add(Text("Couldn't find $newSymbol. Did you mean..."));

    List<Map<String, String>> bestMatches =
        await APIService.getBestMatchingSymbols(newSymbol);
    for (Map<String, String> bestMatch in bestMatches) {
      bestMatchWidgets.add(TextButton(
          onPressed: () {
            symbolNotFound = false;
            refetchAllData(bestMatch["symbol"]!);
          },
          child: Text(
              "${bestMatch["name"]} (${bestMatch["symbol"]}), ${bestMatch["region"]}")));
    }
  }

  void toggleIndicatorParamsByExistingSeries(dynamic dataSeries) {}

  // Synchronized zooming between all charts
  void onZoom(double currentZoomPosition, double currentZoomFactor) {
    for (DateTimeAxisController axisController in axisControllers) {
      axisController.zoomPosition = currentZoomPosition;
      axisController.zoomFactor = currentZoomFactor;
    }
    setState(() {});
  }

  // When a new chart is rendered, add its controller to the list
  void onCreateAxisController(
      DateTimeAxisController axisController, int index) {
    if (index < axisControllers.length) {
      axisControllers[index] = axisController;
    } else {
      axisControllers.add(axisController);
    }
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
              !symbolNotFound
                  ? Container(
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
                                  "Stock Chart: $symbol",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
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
                                    controller: _tickerFieldController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor:
                                          Theme.of(context).highlightColor,
                                      hintText: 'Ticker & Enter...',
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    onSubmitted: ((value) {
                                      refetchAllData(value);
                                      setState(() {
                                        _tickerFieldController.clear();
                                      });
                                    }),
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                child: IconButton(
                                  onPressed: () => {
                                    toggleShowSettings(),
                                  },
                                  icon: const Icon(Icons.add),
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ],
                          ),
                          if (isLoading)
                            const Expanded(
                                child: Center(child: LoadingSpinner())),
                          if (!isLoading) ...charts,
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: bestMatchWidgets,
                    )),
              if (showIndicatorOptions || showIndicatorParameters)

                /// #TODO: Use Animated Modal Barrier
                ModalBarrier(
                  color: Colors.black.withAlpha(200),
                  onDismiss: () {
                    toggleShowSettings();
                  },
                ),
              if (showIndicatorOptions)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Add a technical indicator"),
                      for (var dataType in dataTypeOptions)
                        _indicatorOptionButton(
                            dataType, toggleIndicatorParamsByDataType),
                    ],
                  ),
                ),
              if (showIndicatorParameters)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicatorParamsWidget,
                ),
            ],
          ),
        ));
  }

  TextButton _indicatorOptionButton(
      DataType dataType, Function toggleIndicatorParams) {
    return TextButton(
      onPressed: () => toggleIndicatorParams(dataType),
      child: Text(DataTypeHelper.dataTypeEnumToString[dataType]!),
    );
  }
}
