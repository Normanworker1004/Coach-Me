import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:community_charts_common/community_charts_common.dart';
import 'earnings.dart';

class EarningsYearlyChart extends StatelessWidget {
  final List<charts.Series<EarningsModel, DateTime?>> seriesList;
  final bool? animate;
  final gridLineColor = Color(r: 70, g: 70, b: 80);
  final double? target;
  final int? year;
  final int currentYear = (new DateTime.now()).year;

  EarningsYearlyChart(this.seriesList, {this.animate, this.target, this.year});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList as List<Series<dynamic, DateTime>>,
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
            format: 'm',
            transitionFormat: 'm',
          ),
        ),
        tickProviderSpec: charts.DayTickProviderSpec(increments: [60]),
        viewport: charts.DateTimeExtents(
            start: DateTime((year != null ? year! : currentYear), 1, 1),
            end: DateTime((year != null ? year! : currentYear), 12, 31)),
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
              (target != null) ? target! : 0,
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
