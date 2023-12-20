import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:community_charts_common/community_charts_common.dart';
import 'earnings.dart';

class EarningsWeeklyChart extends StatelessWidget {
  final List<charts.Series<WeeklyEarningsModel, int>> seriesList;
  final bool? animate;
  final domainGridLineColor = Color(r: 70, g: 70, b: 80);
  final primaryGridLineColor = Color(r: 70, g: 70, b: 80, a: 60);
  final double? target;

  final customTickFormatter = charts.BasicNumericTickFormatterSpec((num? value) {
    if (value == 0) {
      return "M";
    } else if (value == 1) {
      return "T";
    } else if (value == 2) {
      return "W";
    } else if (value == 3) {
      return "T";
    } else if (value == 4) {
      return "F";
    } else if (value == 5) {
      return "S";
    } else if (value == 6) {
      return "S";
    } else
      return 'N';
  });

  EarningsWeeklyChart(this.seriesList, {this.animate, this.target});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList,
      defaultRenderer: new charts.LineRendererConfig(
        includeArea: true,
        stacked: true,
        includePoints: true,
        areaOpacity: 0.3,
        roundEndCaps: true,
      ),

      secondaryMeasureAxis: new charts.NumericAxisSpec(
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
                new charts.LineStyleSpec(color: charts.MaterialPalette.white),
          )),

      /// Assign a custom style for the domain axis.
      ///
      /// This is an OrdinalAxisSpec to match up with BarChart's default
      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
      /// other charts).
      domainAxis: new charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 7),
        tickFormatterSpec: customTickFormatter,
        renderSpec: new charts.GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
              fontSize: 12, // size in Pts.
              color: charts.MaterialPalette.white),

          // Change the line colors to match text color.
          lineStyle: new charts.LineStyleSpec(
              color: domainGridLineColor, thickness: 1),
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
            lineStyle: new charts.LineStyleSpec(
                color: primaryGridLineColor, thickness: 1),
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
