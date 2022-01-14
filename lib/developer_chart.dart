import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'developer_series.dart';


class DeveloperChart extends StatelessWidget {
  final List<List<DeveloperSeries>> data;
  final String title;
  final String chartType;

  DeveloperChart({required this.title, required this.data,  required this.chartType});




  @override
  Widget build(BuildContext context) {

    return Container(
      height: 300,
      padding: EdgeInsets.all(25),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: <Widget>[
              Text(
                "Tähän joku otsikko",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: getChartType(chartType),
              )
            ],
          ),
        ),
      ),
    );
  }

  getChartType(String chartType) {
    switch (chartType) {
      case 'bar_chart': {

        List<charts.Series<DeveloperSeries, String>> series = [
          charts.Series(
              id: "developers",
              data: data[0],
              domainFn: (DeveloperSeries series, _) => series.date,
              measureFn: (DeveloperSeries series, _) => series.amount,
              colorFn: (DeveloperSeries series, _) => series.barColor
          ),
          charts.Series(
              id: "developers",
              data: data[1],
              domainFn: (DeveloperSeries series, _) => series.date,
              measureFn: (DeveloperSeries series, _) => series.amount+1,
              colorFn: (DeveloperSeries series, _) => series.barColor
          )
        ];

        return charts.BarChart(series, animate: true);
      }
      case 'line_chart': {


        List<charts.Series<DeveloperSeries, int>> series = [
          charts.Series(
              id: "developers",
              data: data[0],
              domainFn: (DeveloperSeries series, _) => 0,
              measureFn: (DeveloperSeries series, _) => series.amount,
              colorFn: (DeveloperSeries series, _) => series.barColor
          )
        ];

        return charts.LineChart(series, animate: true);
      }
    }
  }

}