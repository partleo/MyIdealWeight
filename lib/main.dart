import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_management_app/daily_report.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:weight_management_app/date_provider.dart';
import 'package:weight_management_app/flat_button.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'developer_chart.dart';
import 'developer_series.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      canvasColor: const Color(0xFFFFFFFF),
      fontFamily: 'Nunito',
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        headline3: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
        bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xFF1E7EA4)),
        bodyText2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Color(0xFF1E7EA4)),
      ),
    ),
    home: const Home()
));

//AnimationController controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
class App {
  static Future init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
  }
}



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dailyWeight = 0.0;
  int exerciseModerate = 0;
  int exerciseStrenuous = 0;
  int steps = 0;


  String date = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );


  @override
  void initState() {
    date = getCurrentDate();

    sharedPreferencesUpdateListener();

    //WidgetsBinding.instance!.addPostFrameCallback((_){  });
/*
    getDailyReports2().then((List<DailyReport> result){
      setState(() {
        List<DailyReport> dailyReports = result;

        DailyReport report = getDailyReport(dailyReports, date);
        weight = report.weight;
        exerciseModerate = report.moderate;
        exerciseStrenuous = report.strenuous;
        steps = report.steps;


      });
    });
    */



    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'My Ideal Weight',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E7EA4),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1E7EA4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Image(
                    image: AssetImage('assets/app-launcher-icon.png'),
                    width: 72,
                    height: 72,
                  ),
                  Text(
                    'MENU',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            drawerItem(Icons.access_alarm, 'Home', 0),
            drawerItem(Icons.access_alarm, 'Exercise', 1),
            drawerItem(Icons.access_alarm, 'Weight loss', 2),
            drawerItem(Icons.access_alarm, 'Steps', 3),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        children: [
          Container(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomFlatButton(
                        text: displayTime(exerciseModerate),
                        callback: () {
                          showNumberPicker('totalME');
                        },
                      ),
                      CustomFlatButton(
                        text: 'ADD',
                        callback: () {
                          showNumberPicker('addME');
                        },
                      ),
                    ]
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomFlatButton(
                        text: displayTime(exerciseStrenuous),
                        callback: () {
                          showNumberPicker('totalSE');
                        },
                      ),
                      CustomFlatButton(
                        text: 'ADD',
                        callback: () {
                          showNumberPicker('addSE');
                        },
                      ),
                    ]
                ),
                CustomFlatButton(
                  text: "Daily weight: $dailyWeight",
                  callback: () {
                    showPickerArray();
                  },
                ),

              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3.0),
            child: DeveloperChart(
              title: "Weight",
              data: getMultiDataListForChart(['weight']),
              chartType: "line_chart",
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3.0),
            child: DeveloperChart(
              title: "Moderate",
              data: getMultiDataListForChart(['moderate', 'strenuous']),
              chartType: "bar_chart",
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: [
                Text(
                    'Steps'
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  List<List<DeveloperSeries>> getMultiDataListForChart(List<String> valueTypes) {
    List<List<DeveloperSeries>> list = [];
    valueTypes.forEach((valueType) {
      Color color;
      if (valueType == 'weight') {
        color = Colors.red;
      } else if (valueType == 'moderate') {
        color = Colors.blue;
      } else if (valueType == 'strenuous') {
        color = Colors.green;
      } else {
        color = Colors.yellow;
      }
      list.add(getDataForChart(valueType, color));
    });
    return list;
  }


  List<DeveloperSeries> getDataForChart(String valueType, Color color) {
    List<DeveloperSeries> developerSeries = [];
    listOfDailyReports.forEach((report) {
      developerSeries.add(
          DeveloperSeries(
            date: report.date,
            amount: getValueType(report, valueType),
            barColor: charts.ColorUtil.fromDartColor(color),
          )
      );
    });
    return developerSeries;
  }

double getValueType(DailyReport report, valueType) {
  switch (valueType) {
    case 'weight': {
      return report.weight;
    }
    case 'moderate': {
      return  report.moderate.toDouble();
    }
    case 'strenuous': {
      return report.strenuous.toDouble();
    }
    case 'steps': {
      return report.steps.toDouble();
    }
  }
  return 0.0;
}




  Future<List<DailyReport>> getDailyReports2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = prefs.getString('daily_reports')
        ?? DailyReport.encode(listOfDailyReports);
    List<DailyReport> reports = DailyReport.decode(encodedData);
    return Future.value(reports);
  }

  setDailyReports2(List<DailyReport> reports) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedData = await DailyReport.encode(reports);
    prefs.setString('daily_reports', encodedData);
  }

  DailyReport getDailyReport2(String date) {
    List<DailyReport> reports = listOfDailyReports;
    if (reports.where((item) => item.date == date).isNotEmpty) {
      return reports.firstWhere((element) => element.date == date);
    } else {
      final report = DailyReport(date: date, weight: 0.0, moderate: 0, strenuous: 0, steps: 0);
      return report;
    }
  }

  setDailyReport2(DailyReport report) {
    List<DailyReport> reports = listOfDailyReports;
    if (reports.where((item) => item.date == report.date).isNotEmpty) {
      DailyReport r = reports.firstWhere((item) => item.date == report.date);
      setState(() {
        r.weight = report.weight;
        r.moderate = report.moderate;
        r.strenuous = report.strenuous;
        r.steps = report.steps;
      });
    } else {
      reports.add(report);
    }
    setDailyReports2(reports);
  }


  updateDailyReport2(double? weight, int? moderate, int? strenuous, int? steps) {
    DailyReport report = getDailyReport2(getCurrentDate());
    report.weight = weight ?? report.weight;
    report.moderate = moderate ?? report.moderate;
    report.strenuous = strenuous ?? report.strenuous;
    report.steps = steps ?? report.steps;
    setDailyReport2(report);
  }


  /*
  getDailyReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = prefs.getString('daily_reports')
        ?? DailyReport.encode([]);
    final reports = DailyReport.decode(encodedData);
    return reports;
  }

   */

  setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double value = prefs.getDouble(key) ?? 0.0;
    return value;
  }

  setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(key) ?? false;
    return value;
  }

  Container drawerItem(IconData icon, String title, int page) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF1E7EA4), size: 36.0,),
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF1E7EA4),
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'SansCondensed',
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          pageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
      ),
    );
  }





  ElevatedButton setRegularButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFF58E18),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 3.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        primary: const Color(0xFF5f86AD), // <-- Button color
        onPrimary: Colors.white24, // <-- Splash color
      ),
    );
  }




  showNumberPicker(String exercise) {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 23, suffix: Text(' h')),
        const NumberPickerColumn(begin: 0, end: 59, suffix: Text(' min'), jump: 5),
      ]),
      delimiter: <PickerDelimiter>[
        PickerDelimiter(
          child: Container(
            width: 20.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      confirmText: 'OK',
      cancelText: 'CANCEL',
      confirmTextStyle: Theme.of(context).textTheme.bodyText1,
      cancelTextStyle: Theme.of(context).textTheme.bodyText1,
      selectedTextStyle: Theme.of(context).textTheme.bodyText2,
      textStyle: Theme.of(context).textTheme.bodyText2,
      title: Text(
        'Select duration',
        style: Theme.of(context).textTheme.headline1,
      ),
      onConfirm: (Picker picker, List<int> value) {
        setState(() {
          int duration = Duration(hours: picker.getSelectedValues()[0], minutes: picker.getSelectedValues()[1]).inMinutes;


          switch (exercise) {
            case 'addME': {
              exerciseModerate = exerciseModerate + duration;
              break;
            }
            case 'addSE': {
              exerciseStrenuous = exerciseStrenuous + duration;
              break;
            }
            case 'totalME': {
              exerciseModerate = duration;
              break;
            }
            case 'totalSE': {
              exerciseStrenuous = duration;
              break;
            }
          }

          updateDailyReport2(null, exerciseModerate, exerciseStrenuous, null);


          //date = getCurrentDate();

        });
      },
    ).showDialog(context);
  }

  Iterable<double> get getDoubles sync* {
    double i = 0.0;
    while (true) yield i = double.parse((i + 0.1).toStringAsFixed(1));;
  }

  Iterable<int> get getIntegers sync* {
    int i = 0;
    while (true) yield i++;
  }


  String getPickerData() {
    final pickerData = '''
[
    ${getDoubles.skip(0).take(2000).toList()}
]
    ''';
    return pickerData;
  }

  int getCurrentWeightListIndex() {
    final list = getDoubles.skip(0).take(50).toList();
    return list.indexOf(double.parse((dailyWeight).toStringAsFixed(1)));
  }





  showPickerArray() {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(
            getPickerData()
        ), isArray: true
        ),
        selecteds: [getCurrentWeightListIndex()],
        hideHeader: true,
        title: Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          setState(() {
            dailyWeight = double.parse(picker.getSelectedValues()[0]);
            updateDailyReport2(dailyWeight, null, null, null);
          });
        }
    ).showDialog(context);
  }





  List<DailyReport> listOfDailyReports = [];

  void sharedPreferencesUpdateListener() async  {
    getDailyReports2().then((List<DailyReport> result){

      print("HERE WE ARE");

      if (result != listOfDailyReports) {
        setState(() {
          listOfDailyReports = result;


          DailyReport report = getDailyReport2(date);
          dailyWeight = report.weight;
          exerciseModerate = report.moderate;
          exerciseStrenuous = report.strenuous;
          steps = report.steps;


        });
      }
      Future.delayed(Duration(milliseconds: 1000), () async {
        sharedPreferencesUpdateListener();
      });
    });

  }




}
