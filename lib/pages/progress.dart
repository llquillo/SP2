import 'package:flutter/material.dart';
import 'package:sample_firebase/pages/common_widgets/page_title.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class Progress extends StatefulWidget {
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  List<String> week = new List<String>();
  List<_xpData> data = new List();
  List<_xpData> tempData = new List();
  int totalXP = 0;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    databaseReference.once().then((DataSnapshot snapshot) {
      setState(() {
        _initDatabase(snapshot);
      });
    });
  }

  DateTime findFirstDate(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  List<String> findWeek(DateTime dateTime) {
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(
              'd MMM',
            ).format(findFirstDate(dateTime).add(Duration(days: value))))
        .toList();
  }

  Future<void> _initDatabase(snapshot) async {
    Map<dynamic, dynamic> databaseTemp =
        Map<dynamic, dynamic>.from(snapshot.value["Points"]);
    databaseTemp.forEach(
        (key, value) => {tempData.add(_xpData(value["Date"], value["XP"]))});

    var i = 0;
    while (i < tempData.length - 1) {
      print(tempData[i].date);
      if (tempData[i].date == tempData[i + 1].date) {
        tempData[i].xp += tempData[i + 1].xp;
        tempData.remove(tempData[i + 1]);
        i = 0;
      } else {
        i++;
      }
    }
    for (var i = 0; i < tempData.length; i++) {
      print("${tempData[i].date} : ${tempData[i].xp}");
    }
    for (var j = 0; j < tempData.length; j++) {
      totalXP += tempData[j].xp;
    }
    DateTime today = DateTime.now();
    week = findWeek(today);
    for (var j = 0; j < week.length; j++) {
      bool flag = false;
      for (var k = 0; k < tempData.length; k++) {
        if (tempData[k].date == week[j]) {
          data.add(_xpData(week[j], tempData[k].xp));
          flag = true;
        }
      }
      if (!flag) {
        data.add(_xpData(week[j], 0));
      }
    }

    for (var i = 0; i < data.length; i++) {
      print("${data[i].date} : ${data[i].xp}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageTitle(
      pageTitle: "Progress",
      pageGreeting: "",
      pageChild: pageContent(context),
    );
  }

  Widget pageContent(context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              childAspectRatio: (MediaQuery.of(context).size.width /
                  2 /
                  (((MediaQuery.of(context).size.height) - 230) / 3)),
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Text("Streak:",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Total points:",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        SizedBox(height: 10),
                        Text("$totalXP",
                            style: GoogleFonts.montserrat(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ))
              ],
            ),
          ),
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: "Progress Tracker"),
              legend: Legend(isVisible: false),
              series: <ChartSeries<_xpData, String>>[
                LineSeries<_xpData, String>(
                    dataSource: data,
                    xValueMapper: (_xpData point, _) => point.date,
                    yValueMapper: (_xpData point, _) => point.xp,
                    name: "xp",
                    dataLabelSettings: DataLabelSettings(isVisible: false))
              ]),
        ],
      ),
    );
  }
}

class _xpData {
  _xpData(this.date, this.xp);
  String date;
  int xp;
}
