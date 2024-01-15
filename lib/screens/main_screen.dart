import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stocker/widgets/stock_chart_skeleton.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> gridChildren = [
    const StockChartSkeleton(),
  ];

  void onPressAddChart() {
    gridChildren.insert(
      gridChildren.length - 1,
      const StockChartSkeleton(),
    );
    setState(() => {});
  }

  @override
  void initState() {
    super.initState();
    gridChildren.add(
      StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: IconButton(
          onPressed: onPressAddChart,
          icon: const Icon(Icons.add_chart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: MediaQuery.sizeOf(context).width > 1200 ? 4 : 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            children: gridChildren,
          ),
        ),
      ),
    );
  }
}
