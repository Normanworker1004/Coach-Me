import 'dart:math';

/// Bar chart example
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:community_charts_common/community_charts_common.dart' as common;
// import 'package:charts_common/chart_canvas.dart' as chart_canvas;

class StackedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool? animate;

  StackedBarChart(this.seriesList, {this.animate});

  /// Creates a stacked [BarChart] with sample data and no transition.
  factory StackedBarChart.withSampleData() {
    return new StackedBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList as List<common.Series<dynamic, String>>,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      primaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: true,
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
      ),

      // defaultRenderer: charts.BarRendererConfig(cornerStrategy: _MyCornerStrategy(), groupingType: charts.BarGroupingType.stacked, stackHorizontalSeparator: 16.0, //strokeWidthPx: 2.0,
      // ),

      customSeriesRenderers: [],
      //barRendererDecorator: ,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final tableSalesData = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 15),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
        colorFn: (OrdinalSales sales, _) =>
            common.Color(r: 200, g: 20, b: 20, a: 205),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class _BarDeco extends common.BarRendererDecorator {
  @override
  void decorate(Iterable<common.ImmutableBarRendererElement> barElements,
      common.ChartCanvas canvas, common.GraphicsFactory graphicsFactory,
      {Rectangle<num>? drawBounds,
      double? animationPercent,
      bool? renderingVertically,
      bool rtl = false}) {
    // TODO: implement decorate
  }
}

class _MyCornerStrategy extends common.CornerStrategy {
  @override
  int getRadius(int barWidth) {
    return 20;
  }
}
