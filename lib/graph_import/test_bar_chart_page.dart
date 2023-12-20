import 'package:flutter/material.dart';
import 'package:cme/graph_import/graphs/hours_of_training.dart';

class TestBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Bar Chart'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            height: 300,
            child: StackedBarChart.withSampleData(),
          ),
        ],
      ),
    );
  }
}
