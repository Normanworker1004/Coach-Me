import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:community_charts_common/community_charts_common.dart';
import 'chart_data_model.dart';

class MonthDataChart extends StatelessWidget {
  final List<charts.Series<StatsDataModel, DateTime>> seriesList;
  final bool? animate;
  final gridLineColor = Color(r: 70, g: 70, b: 80);
  final DateTime? month;
  final DateTime currentMonth =
      DateTime(DateTime.now().year, DateTime.now().month);
  final double? target;

  MonthDataChart(this.seriesList, {this.animate, this.month, this.target});

  @override
  Widget build(BuildContext context) {
    final starts = (month != null ? month! : currentMonth);
    return new charts.TimeSeriesChart(
      seriesList   ,
      defaultRenderer: new charts.LineRendererConfig(
        includeArea: true,
        stacked: true,
        includePoints: true,
        areaOpacity: 0.3,
      ),

      secondaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 7),
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
            labelStyle: new charts.TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: charts.MaterialPalette.white,
            ),

            // Change the line colors to match text color.
            lineStyle:
                new charts.LineStyleSpec(color: charts.MaterialPalette.white),
          )),

      /// Assign a custom style for the domain axis.
      ///
      /// This is an OrdinalAxisSpec to match up with BarChart's default
      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
      /// other charts).
      domainAxis: new charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'dd',
            transitionFormat: 'dd',
          ),
        ),
        tickProviderSpec: charts.DayTickProviderSpec(increments: [5]),
        viewport: charts.DateTimeExtents(
            start: DateTime(starts.year, starts.month, 0),
            end: DateTime(starts.year, starts.month + 1, 1)),
        showAxisLine: false,
        renderSpec: new charts.GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: charts.MaterialPalette.white),

          // Change the line colors to match text color.
          lineStyle:
              new charts.LineStyleSpec(color: gridLineColor, thickness: 1),
        ),
      ),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(desiredTickCount: 6),
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
            labelStyle: new charts.TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: charts.MaterialPalette.white,
            ),

            // Change the line colors to match text color.
            lineStyle:
                new charts.LineStyleSpec(color: gridLineColor, thickness: 1),
          )),

      animate: animate,
      behaviors: [
        new charts.RangeAnnotation(
          [
            new charts.LineAnnotationSegment(
              target!,
              charts.RangeAnnotationAxisType.measure,
              startLabel: 'Target',
              color: (target != null && target != 0)
                  ? Color(r: 20, g: 39, b: 230, a: 250)
                  : Color(r: 20, g: 39, b: 230, a: 0),
              strokeWidthPx: 4.0,
            ),
          ],
        )
      ],
    );
  }
}
