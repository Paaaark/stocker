import 'package:flutter/material.dart';
import 'package:stocker/models/query_params.dart';
import 'package:stocker/widgets/custom_dropdown_menu.dart';

class ChartHeader extends StatefulWidget {
  final String symbol;
  final Function refetchAllData;
  final Function toggleShowSettings;
  final Function updateInterval;
  late final Map<QueryParam, String> intervalInput;

  ChartHeader(
      {required this.symbol,
      required this.refetchAllData,
      required this.toggleShowSettings,
      required this.updateInterval,
      super.key}) {
    intervalInput = {QueryParam.interval: "daily"};
  }

  @override
  State<ChartHeader> createState() => _ChartHeaderState();
}

class _ChartHeaderState extends State<ChartHeader> {
  final TextEditingController _tickerFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Stock Chart: ${widget.symbol}",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.displayLarge?.color,
            ),
          ),
        ),
        Expanded(
          child: CustomDropdownMenu(
            items: const [
              "1min",
              "5min",
              "15min",
              "30min",
              "60min",
              "daily",
              "weekly",
              "monthly",
            ],
            thisQueryParam: QueryParam.interval,
            update: (_, String newValue) {
              widget.intervalInput.update(
                QueryParam.interval,
                (value) => newValue,
              );
              widget.updateInterval(newValue);
            },
            defaultVal: widget.intervalInput[QueryParam.interval]!,
            width: null,
          ),
        ),
        const Expanded(
          flex: 2,
          child: SizedBox(),
        ),
        Expanded(
          child: SizedBox(
            height: 34,
            child: TextField(
              controller: _tickerFieldController,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).highlightColor,
                hintText: 'Ticker & Enter...',
              ),
              style: const TextStyle(
                fontSize: 14,
              ),
              onSubmitted: ((value) {
                widget.refetchAllData(value);
                setState(() {
                  _tickerFieldController.clear();
                });
              }),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          child: IconButton(
            onPressed: () => {
              widget.toggleShowSettings(),
            },
            icon: const Icon(Icons.add),
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ],
    );
  }
}
