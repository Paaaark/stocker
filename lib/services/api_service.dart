import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stocker/models/time_series_daily.dart';

enum DataType {
    stock_daily,
}

class APIService {
  static const String baseUrl = "https://www.alphavantage.co/query";
  static const String timeSeriesDaily = "function=TIME_SERIES_DAILY";
  
  static const Map<DataType, String> dataTypeEnumToString = {
    DataType.stock_daily: "TIME_SERIES_DAILY",
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
  static Future<dynamic> fetchDataByType(String symbol, DataType dataType) async {
    final url = Uri.parse("$baseUrl?function=${dataTypeEnumToString[dataType]}&symbol=$symbol&apikey=demo");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);
      if (dataType == DataType.stock_daily) {
        return TimeSeriesDaily.fromJSON(fetchedData);
      }
    }
  }
}


