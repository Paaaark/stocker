class TimeSeriesDaily {
  late final Map<DateTime, DataPointDaily> data;
  final String symbol;

  TimeSeriesDaily.fromJSON(Map<String, dynamic> json, this.symbol) {
    Map<DateTime, DataPointDaily> myData = {};
    final List<String> fetchedDates = json.keys.toList();
    for (var date in fetchedDates) {
      myData[DateTime.parse(date)] =
          DataPointDaily.fromJSONAndDate(json[date], DateTime.parse(date));
    }
    data = myData;
  }

  DataPointDaily? getDataByDate(DateTime targetDate) => data[targetDate];
  List<DataPointDaily> asList() => data.values.toList();
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
