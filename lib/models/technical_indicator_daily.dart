import 'package:stocker/services/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TechnicalIndicatorDaily {
  late final DataType dataType;
  late final String symbol;
  late final Map<DateTime, DateValuePair> data;

  Map<String, String> indicatorToHeading = {
    "Simple Moving Average (SMA)": "Technical Analysis: SMA",
  };
  Map<String, DataType> indicatorToEnum = {
    "Simple Moving Average (SMA)": DataType.sma,
  };

  TechnicalIndicatorDaily.fromJSON(Map<String, dynamic> json) {
    Map<DateTime, DateValuePair> myData = {};
    Map<String, dynamic> metaData = json['Meta Data'];
    Map<String, dynamic> indicatorData =
        json[indicatorToHeading[metaData['2: Indicator']]];
    final List<String> fetchedDates = indicatorData.keys.toList();

    for (var date in fetchedDates) {
      myData[DateTime.parse(date)] =
          DateValuePair.makePair(date, indicatorData[date]);
    }

    data = myData;
    symbol = metaData["1: Symbol"];
    dataType = indicatorToEnum[metaData['2: Indicator']]!;
  }

  List<DateValuePair> asList() => data.values.toList();

  LineSeries<DateValuePair, DateTime> getCartesianSeries() {
    return LineSeries<DateValuePair, DateTime>(
      dataSource: asList(),
      xValueMapper: (DateValuePair data, _) => data.date,
      yValueMapper: (DateValuePair data, _) => data.value,
    );
  }
}

class DateValuePair {
  DateTime date;
  double value;

  DateValuePair.makePair(String dateStr, Map<String, dynamic> json)
      : date = DateTime.parse(dateStr),
        value = double.parse(json['SMA']);
}
