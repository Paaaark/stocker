import 'package:stocker/models/data_model.dart';
import 'package:stocker/models/data_type_helper.dart';
import 'package:stocker/models/query_params.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockSeries extends DataModel {
  @override
  final DataType dataType = DataType.stock;
  late final Map<DateTime, DataPointDaily> data;
  late final String symbol;
  late final String lineType;

  StockSeries.fromJSON(
    Map<String, dynamic> json, {
    String? line,
    String interval = "daily",
  }) {
    Map<DateTime, DataPointDaily> myData = {};
    Map<String, dynamic> metaData = json['Meta Data'];
    Map<String, dynamic> stockData =
        json[DataTypeHelper.dataLabelFromInterval(interval)];
    final List<String> fetchedDates = stockData.keys.toList();
    for (var date in fetchedDates) {
      myData[DateTime.parse(date)] =
          DataPointDaily.fromJSONAndDate(stockData[date], DateTime.parse(date));
    }
    data = myData;
    symbol = metaData["2. Symbol"];
    lineType = line ?? "candle";
  }

  DataPointDaily? getDataByDate(DateTime targetDate) => data[targetDate];
  List<DataPointDaily> asList() => data.values.toList();

  @override
  CartesianSeries<DataPointDaily, DateTime> getCartesianSeries() {
    switch (lineType) {
      case "line":
        return LineSeries(
          dataSource: asList(),
          xValueMapper: (DataPointDaily data, _) => data.date,
          yValueMapper: (DataPointDaily data, _) => data.close,
        );
      case "bar":
        return HiloOpenCloseSeries(
          dataSource: asList(),
          xValueMapper: (DataPointDaily data, _) => data.date,
          lowValueMapper: (DataPointDaily data, _) => data.low,
          highValueMapper: (DataPointDaily data, _) => data.high,
          openValueMapper: (DataPointDaily data, _) => data.open,
          closeValueMapper: (DataPointDaily data, _) => data.close,
        );
      case "candle":
      default:
        return CandleSeries<DataPointDaily, DateTime>(
          dataSource: asList(),
          enableSolidCandles: true,
          xValueMapper: (DataPointDaily data, _) => data.date,
          lowValueMapper: (DataPointDaily data, _) => data.low,
          highValueMapper: (DataPointDaily data, _) => data.high,
          openValueMapper: (DataPointDaily data, _) => data.open,
          closeValueMapper: (DataPointDaily data, _) => data.close,
        );
    }
  }

  @override
  Map<QueryParam, String> getParams() =>
      {QueryParam.stockDataLineType: lineType};

  @override
  String getSummary() => "$symbol: $lineType";
}

class DataPointDaily {
  final DateTime date;
  final double open, high, low, close, volume;

  DataPointDaily.fromJSONAndDate(Map<String, dynamic> json, this.date)
      : open = double.parse(json['1. open']),
        high = double.parse(json['2. high']),
        low = double.parse(json['3. low']),
        close = double.parse(json['4. close']),
        volume = double.parse(json['5. volume']);
}
