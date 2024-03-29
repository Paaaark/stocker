import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:stocker/models/data_model.dart';
import 'package:stocker/models/data_type_helper.dart';
import 'package:stocker/models/query_params.dart';
import 'package:stocker/models/technical_indicator_daily.dart';
import 'package:stocker/models/stock_series.dart';

class APIService {
  static const String baseUrl = "https://www.alphavantage.co/query";
  static const String timeSeriesDaily = "function=TIME_SERIES_DAILY";
  static const String API_KEY = String.fromEnvironment("API_KEY");
  static const String OUTPUT_SIZE = "full";

  /// Returns a future of data of the desired symbol and type
  static Future<dynamic> fetchDataByType({
    required String symbol,
    required DataType dataType,
    required Map<QueryParam, String> params,
    required String interval,
  }) async {
    String dataTypeStr =
        DataTypeHelper.dataTypeEnumToString(dataType, interval: interval);
    dynamic url;
    switch (dataType) {
      case DataType.stock:
        url =
            "$baseUrl?function=$dataTypeStr&interval=$interval&symbol=$symbol&outputsize=$OUTPUT_SIZE&apikey=$API_KEY";
        break;
      case DataType.sma:
        url =
            "$baseUrl?function=$dataTypeStr&symbol=$symbol&interval=$interval&time_period=${params[QueryParam.timePeriod]}&series_type=${params[QueryParam.seriesType]}&apikey=$API_KEY";
        break;
      case DataType.rsi:
        url =
            "$baseUrl?function=$dataTypeStr&symbol=$symbol&interval=$interval&time_period=${params[QueryParam.timePeriod]}&series_type=${params[QueryParam.seriesType]}&apikey=$API_KEY";
        break;
      case DataType.obv:
        url =
            "$baseUrl?function=$dataTypeStr&symbol=$symbol&interval=$interval&apikey=$API_KEY";
        break;
      case DataType.stoch:
        url =
            "$baseUrl?function=$dataTypeStr&symbol=$symbol&interval=$interval&apikey=$API_KEY";
        break;
    }

    url = Uri.parse(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);

      if (fetchedData.containsKey("Error Message")) {
        throw Exception();
      }

      if (dataType == DataType.stock) {
        return StockSeries.fromJSON(fetchedData,
            line: params[QueryParam.stockDataLineType], interval: interval);
      }
      if ([DataType.sma, DataType.rsi, DataType.obv, DataType.stoch]
          .contains(dataType)) {
        return TechnicalIndicatorDaily.fromJSON(fetchedData);
      }
    }
  }

  static Future<Map<String, Map<String, DataModel>>> refetchAllData(
      Map<String, Map<String, DataModel>> currentData, String newSymbol,
      {String interval = "daily"}) async {
    Map<String, Map<String, DataModel>> newData = {};
    for (String id in currentData.keys) {
      Map<String, DataModel> newRow = {};
      for (String subId in currentData[id]!.keys) {
        try {
          newRow[subId] = await fetchDataByType(
            symbol: newSymbol,
            dataType: currentData[id]![subId]!.dataType,
            params: currentData[id]![subId]!.getParams(),
            interval: interval,
          );
        } catch (e) {
          rethrow;
        }
      }
      newData[id] = newRow;
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

  static String getUniqueID() {
    Random rand = Random(DateTime.now().millisecondsSinceEpoch);
    String key = "";
    for (int i = 0; i < 10; i++) {
      int x = rand.nextInt(26);
      key += String.fromCharCode(97 + x);
    }
    return key;
  }
}
