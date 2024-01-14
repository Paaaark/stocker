import 'package:stocker/models/data_type_helper.dart';
import 'package:stocker/models/query_params.dart';

abstract class DataModel {
  late final DataType dataType;

  /// Returns all the parameters of the data as a map
  Map<QueryParam, String> getParams();

  /// Returns a summary of the name and the parameters
  String getSummary();

  /// Returns syncfusion CartesianSeries compatible with CartesianChart
  dynamic getCartesianSeries();
}
