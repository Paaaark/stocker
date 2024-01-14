import 'package:stocker/models/data_model.dart';
import 'package:stocker/models/data_type_helper.dart';
import 'package:stocker/models/query_params.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TimeSeriesDaily extends DataModel {
  @override
  final DataType dataType = DataType.stockDaily;
  late final Map<DateTime, DataPointDaily> data;
  late final String symbol;

  TimeSeriesDaily.fromJSONWithSymbol(Map<String, dynamic> json, this.symbol) {
    Map<DateTime, DataPointDaily> myData = {};
    final List<String> fetchedDates = json.keys.toList();
    for (var date in fetchedDates) {
      myData[DateTime.parse(date)] =
          DataPointDaily.fromJSONAndDate(json[date], DateTime.parse(date));
    }
    data = myData;
  }

  TimeSeriesDaily.fromJSON(Map<String, dynamic> json) {
    Map<DateTime, DataPointDaily> myData = {};
    Map<String, dynamic> stockData = json['Time Series (Daily)'];
    Map<String, dynamic> metaData = json['Meta Data'];
    final List<String> fetchedDates = stockData.keys.toList();
    for (var date in fetchedDates) {
      myData[DateTime.parse(date)] =
          DataPointDaily.fromJSONAndDate(stockData[date], DateTime.parse(date));
    }
    data = myData;
    symbol = metaData["2. Symbol"];
  }

  DataPointDaily? getDataByDate(DateTime targetDate) => data[targetDate];
  List<DataPointDaily> asList() => data.values.toList();

  @override
  CandleSeries<DataPointDaily, DateTime> getCartesianSeries() {
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

  @override
  Map<QueryParam, String> getParams() => {};

  @override
  String getSummary() => symbol;
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
