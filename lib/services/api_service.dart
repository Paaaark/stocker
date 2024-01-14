import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stocker/models/data_model.dart';
import 'package:stocker/models/data_type_helper.dart';
import 'package:stocker/models/query_params.dart';
import 'package:stocker/models/technical_indicator_daily.dart';
import 'package:stocker/models/time_series_daily.dart';

class APIService {
  static const String baseUrl = "https://www.alphavantage.co/query";
  static const String timeSeriesDaily = "function=TIME_SERIES_DAILY";
  static const String API_KEY = String.fromEnvironment("API_KEY");

  /// Returns a future of daily data of the desired symbol
  static Future<TimeSeriesDaily> getTimeSeriesDaily(String symbol) async {
    final url =
        Uri.parse("$baseUrl?$timeSeriesDaily&symbol=$symbol&apikey=demo");
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
      String symbol, DataType dataType, Map<QueryParam, String> params) async {
    dynamic url;
    switch (dataType) {
      case DataType.stockDaily:
        url =
            "$baseUrl?function=${DataTypeHelper.dataTypeEnumToString[dataType]}&symbol=$symbol&outputsize=full&apikey=$API_KEY";
        break;
      case DataType.sma:
        url =
            "$baseUrl?function=${DataTypeHelper.dataTypeEnumToString[dataType]}&symbol=$symbol&interval=${params[QueryParam.interval]}&time_period=${params[QueryParam.timePeriod]}&series_type=${params[QueryParam.seriesType]}&apikey=$API_KEY";
        break;
      case DataType.rsi:
        url =
            "$baseUrl?function=${DataTypeHelper.dataTypeEnumToString[dataType]}&symbol=$symbol&interval=weekly&time_period=10&series_type=open&apikey=$API_KEY";
        break;
      case DataType.obv:
        url =
            "$baseUrl?function=${DataTypeHelper.dataTypeEnumToString[dataType]}&symbol=$symbol&interval=weekly&apikey=$API_KEY";
        break;
      case DataType.stoch:
        url =
            "$baseUrl?function=${DataTypeHelper.dataTypeEnumToString[dataType]}&symbol=$symbol&interval=daily&apikey=$API_KEY";
        break;
    }

    url = Uri.parse(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);

      print(fetchedData);

      if (dataType == DataType.stockDaily) {
        return TimeSeriesDaily.fromJSON(fetchedData);
      }
      if ([DataType.sma, DataType.rsi, DataType.obv, DataType.stoch]
          .contains(dataType)) {
        return TechnicalIndicatorDaily.fromJSON(fetchedData);
      }
    }
  }

  static Future<List<List<DataModel>>> refetchAllData(
      List<List<DataModel>> currentData, String newSymbol) async {
    List<List<DataModel>> newData = [];
    for (List<DataModel> row in currentData) {
      List<DataModel> newRow = [];
      for (dynamic item in row) {
        newRow.add(
            await fetchDataByType(newSymbol, item.dataType, item.getParams()));
      }
      newData.add(newRow);
    }

    return newData;
  }
}
