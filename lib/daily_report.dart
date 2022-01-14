import 'dart:convert';
import 'dart:core';

class DailyReport {
  String date;
  double weight;
  int moderate, strenuous, steps;

  DailyReport({
    required this.date,
    required this.weight,
    required this.moderate,
    required this.strenuous,
    required this.steps,
  });

  factory DailyReport.fromJson(Map<String, dynamic> jsonData) {
    return DailyReport(
      date: jsonData['date'],
      weight: jsonData['weight'],
      moderate: jsonData['moderate'],
      strenuous: jsonData['strenuous'],
      steps: jsonData['steps'],
    );
  }

  static Map<String, dynamic> toMap(DailyReport report) => {
    'date': report.date,
    'weight': report.weight,
    'moderate': report.moderate,
    'strenuous': report.strenuous,
    'steps': report.steps,
  };

  static String encode(List<DailyReport> reports) => json.encode(
    reports
        .map<Map<String, dynamic>>((music) => DailyReport.toMap(music))
        .toList(),
  );

  static List<DailyReport> decode(String reports) =>
      (json.decode(reports) as List<dynamic>)
          .map<DailyReport>((item) => DailyReport.fromJson(item))
          .toList();
}