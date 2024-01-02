import 'package:flutter/material.dart';
import 'package:stocker/models/time_series_daily.dart';
import 'package:stocker/services/api_service.dart';

class MainScreen extends StatelessWidget {
  Future<TimeSeriesDaily> timeSeriesDaily =
      APIService.getTimeSeriesDaily("IBM");

  @override
  Widget build(BuildContext context) {
    print("Hello");
    return Scaffold(
      body: FutureBuilder<TimeSeriesDaily>(
        future: timeSeriesDaily,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
                "${snapshot.data?.getDataByDate(DateTime.parse("2023-12-29"))?.getOpen()}");
          } else {
            return const Text("Still Loading");
          }
        },
      ),
    );
  }
}
