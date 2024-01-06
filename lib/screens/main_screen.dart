import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stocker/models/time_series_daily.dart';
import 'package:stocker/services/api_service.dart';
import 'package:stocker/widgets/candle_chart.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TimeSeriesDaily? timeSeriesDaily;
  bool isLoading = true;
  String symbol = "IBM";

  void waitForData() async {
    timeSeriesDaily = await APIService.getTimeSeriesDaily(symbol);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    waitForData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Text("Still Loading!")
            : StaggeredGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 2,
                    mainAxisCellCount: 1,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: CandleChart(timeSeriesDaily: timeSeriesDaily),
                    ),
                  ),
                  const StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: SizedBox(
                      width: 200,
                      child: Center(
                        child: Text("Item 2"),
                      ),
                    ),
                  ),
                  const StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: SizedBox(
                      width: 200,
                      child: Center(
                        child: Text("Item 3"),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
