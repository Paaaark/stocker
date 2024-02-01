/// To add an item in this enum,
/// Also add an entry to dataTypeEnumToString in this file
enum DataType {
  stock,
  sma,
  rsi,
  obv,
  stoch,
}

class DataTypeHelper {
  static String dataTypeEnumToString(DataType dataType, {String? interval}) {
    switch (dataType) {
      case DataType.stock:
        switch (interval) {
          case "weekly":
            return "TIME_SERIES_WEEKLY";
          case "monthly":
            return "TIME_SERIES_MONTHLY";
          case "1min":
          case "5min":
          case "15min":
          case "30min":
          case "60min":
            return "TIME_SERIES_INTRADAY";
          case "daily":
          default:
            return "TIME_SERIES_DAILY";
        }
      case DataType.sma:
        return "SMA";
      case DataType.rsi:
        return "RSI";
      case DataType.obv:
        return "OBV";
      case DataType.stoch:
        return "STOCH";
      default:
        return "TIME_SERIES_DAILY";
    }
  }

  static String dataLabelFromInterval(String interval) {
    switch (interval) {
      case "1min":
      case "5min":
      case "15min":
      case "30min":
      case "60min":
        return "Time Series ($interval)";
      case "weekly":
        return "Weekly Time Series";
      case "monthly":
        return "Monthly Time Series";
      default:
        return "Time Series (Daily)";
    }
  }
}
