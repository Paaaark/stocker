import 'package:stocker/models/data_type_helper.dart';
import 'package:stocker/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:stocker/widgets/custom_dropdown_menu.dart';

/// Methods to edit: getParamsByType, getParamInputWidgetByType,
enum QueryParam {
  interval,
  timePeriod,
  seriesType,
  stockDataLineType,
}

Map<QueryParam, String> defaultParams = {
  QueryParam.interval: "weekly",
  QueryParam.timePeriod: "10",
  QueryParam.seriesType: "open",
  QueryParam.stockDataLineType: "candle",
};

class QueryParamsHelper {
  static Map<QueryParam, String> getParamsByType(DataType dataType) {
    switch (dataType) {
      case DataType.stockDaily:
        return _filterParam([QueryParam.stockDataLineType]);
      case DataType.sma:
      case DataType.rsi:
        return _filterParam([QueryParam.timePeriod, QueryParam.seriesType]);
      case DataType.obv:
        return _filterParam([]);
    }
    return {};
  }

  static Widget getParamInputWidgetByType(
    QueryParam param,
    Function update,
    String defaultVal,
  ) {
    switch (param) {
      case QueryParam.interval:
        return CustomDropdownMenu(
          items: const [
            "1min",
            "5min",
            "15min",
            "30min",
            "60min",
            "daily",
            "weekly",
            "monthly"
          ],
          thisQueryParam: param,
          update: update,
          defaultVal: defaultVal,
        );
      case QueryParam.seriesType:
        return CustomDropdownMenu(
          items: const [
            'open',
            'close',
            'high',
            'low',
          ],
          thisQueryParam: param,
          update: update,
          defaultVal: defaultVal,
        );
      case QueryParam.stockDataLineType:
        return CustomDropdownMenu(
          items: const ['candle', 'bar', 'line'],
          thisQueryParam: param,
          update: update,
          defaultVal: defaultVal,
        );
      case QueryParam.timePeriod:
        return _TextInput(
          initialValue: defaultVal,
          thisQueryParam: param,
          update: update,
        );
    }

    return const Text("...");
  }

  static String helpMessage(QueryParam param) {
    switch (param) {
      case QueryParam.interval:
        return "Time interval between two consecutive data points";
      case QueryParam.timePeriod:
        return "Number of data points used to calculate each indicator";
      case QueryParam.seriesType:
        return "The desired price type";
    }
    return "";
  }

  static Map<QueryParam, String> _filterParam(List<QueryParam> targetKeys) {
    List<String> targetValues = [];
    for (QueryParam key in targetKeys) {
      targetValues.add(defaultParams[key]!);
    }
    return Map.fromIterables(targetKeys, targetValues);
  }
}

class _TextInput extends StatefulWidget {
  String initialValue;
  QueryParam thisQueryParam;
  Function update;
  _TextInput(
      {required this.initialValue,
      required this.thisQueryParam,
      required this.update,
      super.key});

  @override
  State<_TextInput> createState() => __TextInputState();
}

class __TextInputState extends State<_TextInput> {
  @override
  void initState() {
    widget.update(widget.thisQueryParam, (value) => widget.initialValue,
        ifAbsent: () => widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: TextFormField(
        initialValue: widget.initialValue,
        onChanged: (text) => {
          widget.update(widget.thisQueryParam, (value) => text),
        },
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).highlightColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 10,
          ),
        ),
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
