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
    print("FetchDataByType called");
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
            "$baseUrl?function=${DataTypeHelper.dataTypeEnumToString[dataType]}&symbol=$symbol&interval=${params[QueryParam.interval]}&time_period=${params[QueryParam.timePeriod]}&series_type=${params[QueryParam.seriesType]}&apikey=$API_KEY";
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

    print(url);
    url = Uri.parse(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);

      print(fetchedData);

      if (fetchedData.containsKey("Error Message")) {
        throw Exception();
      }

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
      for (DataModel item in row) {
        try {
          print("Iteration in refetchAllData: ${item?.dataType}");
          newRow.add(await fetchDataByType(
              newSymbol, item.dataType, item.getParams()));
        } catch (e) {
          print(e);
          rethrow;
        }
      }
      newData.add(newRow);
    }

    return newData;
  }

  static Future<List<Map<String, String>>> getBestMatchingSymbols(
      String target) async {
    List<Map<String, String>> bestMatches = [];

    Uri url = Uri.parse(
        "$baseUrl?function=SYMBOL_SEARCH&keywords=$target&apikey=$API_KEY");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);
      print(fetchedData);
      for (Map<String, dynamic> bestMatch in fetchedData["bestMatches"]) {
        Map<String, String> match = {
          "symbol": bestMatch["1. symbol"],
          "name": bestMatch["2. name"],
          "region": bestMatch["4. region"],
        };

        bestMatches.add(match);
      }
    }

    return bestMatches;
  }
}
