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
  bool showIndicatorsList = false;
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

  late final Map<String, Function> cartesianChartFunctions;

  final TextEditingController _tickerFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addIndicator(DataType.stockDaily, {});
    cartesianChartFunctions = {
      "onZoom": onZoom,
      "onCreateAxisController": onCreateAxisController,
      "onChipPressed": onChipPressed,
    };
    setState(() {});
  }

  void addIndicator(DataType dataType, Map<QueryParam, String> params) async {
    // Turn on loading mode to fetch the data
    isLoading = true;
    showIndicatorsList = false;
    setState(() {});

    dataTypes.add(dataType);
    // Fetch the data using APIService
    DataModel tempHolder =
        await APIService.fetchDataByType(symbol, dataType, params);
    if (dataTypeCategoryOne.contains(dataType)) {
      dataSeries[0].add(tempHolder);
      CartesianChart temp = CartesianChart.createChart(
        dataSeries: dataSeries[0],
        cartesianChartFunctions: cartesianChartFunctions,
        chartIndex: 0,
      );
      if (charts.isEmpty) {
        charts.add(temp);
      } else {
        charts[0] = temp;
      }
    } else {
      dataSeries.add([tempHolder]);
      charts.add(CartesianChart.createChart(
        dataSeries: dataSeries[dataSeries.length - 1],
        cartesianChartFunctions: cartesianChartFunctions,
        chartIndex: dataSeries.length - 1,
      ));
    }

    // When loading is done, display it on the screen
    isLoading = false;
    setState(() {});
  }

  void updateIndicator(
    DataType dataType,
    Map<QueryParam, String> params,
    int chartIndex,
    int dataIndex,
  ) async {
    setState(() {
      isLoading = true;
    });

    DataModel tempHolder =
        await APIService.fetchDataByType(symbol, dataType, params);
    dataSeries[chartIndex][dataIndex] = tempHolder;
    charts[chartIndex] = CartesianChart.createChart(
      dataSeries: dataSeries[chartIndex],
      cartesianChartFunctions: cartesianChartFunctions,
      chartIndex: chartIndex,
    );

    setState(() {
      isLoading = false;
    });
  }

  void toggleShowSettings() {
    setState(() {
      showIndicatorsList = !showIndicatorsList;
      showIndicatorParameters = false;
    });
  }

  void toggleIndicatorParamsByDataType(DataType dataType) {
    _addIndiactorParamsWidgets(dataType);

    setState(() {
      showIndicatorsList = false;
      showIndicatorParameters = true;
    });
  }

  void refetchAllData(String newSymbol) async {
    setState(() => isLoading = true);

    try {
      dataSeries = await APIService.refetchAllData(dataSeries, newSymbol);

      for (var i = 0; i < charts.length; i++) {
        charts[i] = CartesianChart.createChart(
          dataSeries: dataSeries[i],
          cartesianChartFunctions: cartesianChartFunctions,
          chartIndex: i,
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

  void onChipPressed(DataModel dataSeries, int chartIndex, int dataIndex) {
    _addIndiactorParamsWidgets(
      dataSeries.dataType,
      params: dataSeries.getParams(),
      directlyFromChart: true,
      chartIndex: chartIndex,
      dataIndex: dataIndex,
    );

    setState(() {
      showIndicatorParameters = true;
    });
  }

  void _addIndiactorParamsWidgets(
    DataType dataType, {
    Map<QueryParam, String>? params,
    bool directlyFromChart = false,
    int chartIndex = 0,
    int dataIndex = 0,
  }) {
    /// First reset all the existing widgets and inputs
    indicatorParamsWidget.clear();
    indicatorParamsInput.clear();

    /// If params is null, then initialize it with default params
    params ??= QueryParamsHelper.getParamsByType(dataType);

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
    params.forEach((key, value) {
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
                  key, indicatorParamsInput.update, value),
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
              if (directlyFromChart) {
                toggleShowSettings();
              } else {
                setState(() {
                  showIndicatorParameters = false;
                });
              }
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
              if (directlyFromChart) {
                updateIndicator(
                    dataType, indicatorParamsInput, chartIndex, dataIndex);
              } else {
                addIndicator(dataType, indicatorParamsInput);
              }
              showIndicatorParameters = false;
              setState(() {});
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).highlightColor,
            ),
            child:
                Text(directlyFromChart ? "Confirm Changes" : "Confirm and Add"),
          ),
        ],
      ),
    ));
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
              if (showIndicatorsList || showIndicatorParameters)

                /// #TODO: Use Animated Modal Barrier
                ModalBarrier(
                  color: Colors.black.withAlpha(200),
                  onDismiss: () {
                    toggleShowSettings();
                  },
                ),
              if (showIndicatorsList)
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
