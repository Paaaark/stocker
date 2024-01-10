import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stocker/models/technical_indicator_daily.dart';
import 'package:stocker/models/time_series_daily.dart';

/// To add an item in this enum,
/// Also add an entry to dataTypeEnumToString in this file
enum DataType {
  stockDaily,
  sma,
}

class APIService {
  static const String baseUrl = "https://www.alphavantage.co/query";
  static const String timeSeriesDaily = "function=TIME_SERIES_DAILY";

  static const Map<DataType, String> dataTypeEnumToString = {
    DataType.stockDaily: "TIME_SERIES_DAILY",
    DataType.sma: "SMA",
  };

  /// Returns a future of daily data of the desired symbol
  static Future<TimeSeriesDaily> getTimeSeriesDaily(String symbol) async {
    final url = Uri.parse("$baseUrl?$timeSeriesDaily&symbol=IBM&apikey=demo");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);
      final Map<String, dynamic> fetchedTimeSeries =
          fetchedData['Time Series (Daily)'];
      final TimeSeriesDaily timeSeriesDaily =
          TimeSeriesDaily.fromJSONWithSymbol(fetchedTimeSeries, symbol);
      return timeSeriesDaily;
    }

    throw Error();
  }

  /// Returns a future of data of the desired symbol and type
  static Future<dynamic> fetchDataByType(
      String symbol, DataType dataType) async {
    dynamic url;
    switch (dataType) {
      case DataType.stockDaily:
        url =
            "$baseUrl?function=${dataTypeEnumToString[dataType]}&symbol=$symbol&apikey=demo";
        break;
      case DataType.sma:
        url =
            "$baseUrl?function=${dataTypeEnumToString[dataType]}&symbol=$symbol&interval=weekly&time_period=10&series_type=open&apikey=demo";
        break;
    }
    print(url);
    url = Uri.parse(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);
      if (dataType == DataType.stockDaily) {
        return TimeSeriesDaily.fromJSON(fetchedData);
      }
      if (dataType == DataType.sma) {
        return TechnicalIndicatorDaily.fromJSON(fetchedData);
      }
    }
  }
}
