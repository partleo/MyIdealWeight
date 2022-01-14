import 'package:charts_flutter/flutter.dart' as charts;

class DeveloperSeries {
  final String date;
  final double amount;
  final charts.Color barColor;

  DeveloperSeries({
        required this.date,
        required this.amount,
        required this.barColor
      });
}