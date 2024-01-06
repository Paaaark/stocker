import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stocker/models/time_series_daily.dart';

class APIService {
  static const String baseUrl = "https://www.alphavantage.co/query";
  static const String timeSeriesDaily = "function=TIME_SERIES_DAILY";

  /// Returns a future of daily data of the desired symbol
  static Future<TimeSeriesDaily> getTimeSeriesDaily(String symbol) async {
    final url = Uri.parse("$baseUrl?$timeSeriesDaily&symbol=IBM&apikey=demo");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> fetchedData = jsonDecode(response.body);
      final Map<String, dynamic> fetchedTimeSeries =
          fetchedData['Time Series (Daily)'];
      final TimeSeriesDaily timeSeriesDaily =
          TimeSeriesDaily.fromJSON(fetchedTimeSeries, symbol);
      return timeSeriesDaily;
    }

    throw Error();
  }
}
