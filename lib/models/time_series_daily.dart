class TimeSeriesDaily {
  late final Map<DateTime, DataPointDaily> data;

  TimeSeriesDaily.fromJSON(Map<String, dynamic> json) {
    Map<DateTime, DataPointDaily> myData = {};
    final List<String> fetchedDates = json.keys.toList();
    for (var date in fetchedDates) {
      myData[DateTime.parse(date)] =
          DataPointDaily.fromJSONAndDate(json[date], DateTime.parse(date));
    }
    data = myData;
  }

  DataPointDaily? getDataByDate(DateTime targetDate) => data[targetDate];
}

class DataPointDaily {
  final DateTime date;
  final String open, high, low, close, volume;

  DataPointDaily.fromJSONAndDate(Map<String, dynamic> json, this.date)
      : open = json['1. open'],
        high = json['2. high'],
        low = json['3. low'],
        close = json['4. close'],
        volume = json['5. volume'];

  String getOpen() => open;
}
