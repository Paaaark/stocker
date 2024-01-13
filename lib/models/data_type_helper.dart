/// To add an item in this enum,
/// Also add an entry to dataTypeEnumToString in this file
enum DataType {
  stockDaily,
  sma,
  rsi,
  obv,
  stoch,
}

class DataTypeHelper {
  static const Map<DataType, String> dataTypeEnumToString = {
    DataType.stockDaily: "TIME_SERIES_DAILY",
    DataType.sma: "SMA",
    DataType.rsi: "RSI",
    DataType.obv: "OBV",
    DataType.stoch: "STOCH",
  };

}