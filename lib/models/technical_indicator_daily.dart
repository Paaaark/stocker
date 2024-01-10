import 'package:stocker/services/api_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Map<String, String> indicatorToSubheading = {
  "Simple Moving Average (SMA)": "SMA",
  "Relative Strength Index (RSI)": "RSI",
  "On Balance Volume (OBV)": "OBV",
  "Stochastic (STOCH)": "SlowK",
};
Map<String, String> indicatorToHeading = {
  "Simple Moving Average (SMA)": "Technical Analysis: SMA",
  "Relative Strength Index (RSI)": "Technical Analysis: RSI",
  "On Balance Volume (OBV)": "Technical Analysis: OBV",
  "Stochastic (STOCH)": "Technical Analysis: STOCH",
};
Map<String, DataType> indicatorToEnum = {
  "Simple Moving Average (SMA)": DataType.sma,
  "Relative Strength Index (RSI)": DataType.rsi,
  "On Balance Volume (OBV)": DataType.obv,
  "Stochastic (STOCH)": DataType.stoch,
};

class TechnicalIndicatorDaily {
  late final DataType dataType;
  late final String symbol;
  late final Map<DateTime, DateValuePair> data;

  TechnicalIndicatorDaily.fromJSON(Map<String, dynamic> json) {
    Map<DateTime, DateValuePair> myData = {};
    Map<String, dynamic> metaData = json['Meta Data'];
    String indicator = metaData['2: Indicator'];
    Map<String, dynamic> indicatorData = json[indicatorToHeading[indicator]];
    final List<String> fetchedDates = indicatorData.keys.toList();

    print(indicatorData);

    for (var date in fetchedDates) {
      myData[DateTime.parse(date)] =
          DateValuePair.makePair(date, indicatorData[date], indicator);
    }

    data = myData;
    symbol = metaData["1: Symbol"];
    dataType = indicatorToEnum[indicator]!;
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

  DateValuePair.makePair(
      String dateStr, Map<String, dynamic> json, String indicator)
      : date = DateTime.parse(dateStr),
        value = double.parse(json[indicatorToSubheading[indicator]]);
}
