import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stocker/models/technical_indicator_daily.dart';
import 'package:stocker/models/time_series_daily.dart';

/// To add an item in this enum,
/// Also add an entry to dataTypeEnumToString in this file
enum DataType {
  stockDaily,
  sma,
  rsi,
  obv,
  stoch,
}

enum QueryParam {
  interval,
  timePeriod,
  seriesType,
}

class APIService {
  static const String baseUrl = "https://www.alphavantage.co/query";
  static const String timeSeriesDaily = "function=TIME_SERIES_DAILY";

  static const Map<DataType, String> dataTypeEnumToString = {
    DataType.stockDaily: "TIME_SERIES_DAILY",
    DataType.sma: "SMA",
    DataType.rsi: "RSI",
    DataType.obv: "OBV",
    DataType.stoch: "STOCH",
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
  static Future<dynamic> fetchDataByType(String symbol, DataType dataType,
      {String interval = "weekly",
      String timePeriod = "10",
      String seriesType = "open"}) async {
    dynamic url;
    switch (dataType) {
      case DataType.stockDaily:
        url =
            "$baseUrl?function=${dataTypeEnumToString[dataType]}&symbol=$symbol&apikey=demo";
        break;
      case DataType.sma:
        url =
            "$baseUrl?function=${dataTypeEnumToString[dataType]}&symbol=$symbol&interval=$interval&time_period=$timePeriod&series_type=$seriesType&apikey=demo";
        break;
      case DataType.rsi:
        url =
            "$baseUrl?function=${dataTypeEnumToString[dataType]}&symbol=$symbol&interval=weekly&time_period=10&series_type=open&apikey=demo";
        break;
      case DataType.obv:
        url =
            "$baseUrl?function=${dataTypeEnumToString[dataType]}&symbol=$symbol&interval=weekly&apikey=demo";
        break;
      case DataType.stoch:
        url =
            "$baseUrl?function=${dataTypeEnumToString[dataType]}&symbol=$symbol&interval=daily&apikey=demo";
        break;
    }

    url = Uri.parse(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);
      if (dataType == DataType.stockDaily) {
        return TimeSeriesDaily.fromJSON(fetchedData);
      }
      if ([DataType.sma, DataType.rsi, DataType.obv, DataType.stoch]
          .contains(dataType)) {
        return TechnicalIndicatorDaily.fromJSON(fetchedData);
      }
    }
  }
}
