import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/health_worker_pages/vaccine_stats_page/vaccine_stats_page.dart';
import 'package:flutter/material.dart';

class SpoVsDate extends StatefulWidget {
  final String patientId;

  const SpoVsDate({Key key, this.patientId}) : super(key: key);

  @override
  _SpoVsDateState createState() => _SpoVsDateState();
}

class _SpoVsDateState extends State<SpoVsDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Patients")
            .doc(widget.patientId)
            .collection("History")
            .orderBy("latest_time_change", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              List<QueryDocumentSnapshot> query = snapshot.data.docs;
              if (query.isEmpty) {
                return Center(
                  child: Text("Insufficient Data"),
                );
              }
              List<OrdinalSales> lsit1 = [];
              query.forEach((element) {
                lsit1.add(
                  OrdinalSales(
                    element
                            .data()["latest_time_change"]
                            .toDate()
                            .day
                            .toString() +
                        "/" +
                        element
                            .data()["latest_time_change"]
                            .toDate()
                            .month
                            .toString() +
                        "/" +
                        element
                            .data()["latest_time_change"]
                            .toDate()
                            .year
                            .toString() +
                        ":" +
                        element
                            .data()["latest_time_change"]
                            .toDate()
                            .hour
                            .toString() +
                        ":" +
                        element
                            .data()["latest_time_change"]
                            .toDate()
                            .minute
                            .toString(),
                    int.parse(element.data()["spo"]),
                  ),
                );
              });
              return Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Spo2 Vs Date",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Expanded(
                      child: _SimpleBarChart.withSampleData(lsit1),
                    ),
                  ],
                ),
              );

            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  _SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory _SimpleBarChart.withSampleData(List<OrdinalSales> sales) {
    return new _SimpleBarChart(
      _createSampleData(sales),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.ChartTitle(
          'Date/Time',
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
        new charts.ChartTitle(
          'SPO2',
          behaviorPosition: charts.BehaviorPosition.start,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
      ],
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      List<OrdinalSales> sales) {
    final data = sales;

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'SP02 Vs Time',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}
