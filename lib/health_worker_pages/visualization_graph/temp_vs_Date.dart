import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/health_worker_pages/vaccine_stats_page/vaccine_stats_page.dart';
import 'package:flutter/material.dart';

class TempVSDateChart extends StatefulWidget {
  final String patientId;

  TempVSDateChart({this.patientId});

  @override
  _TempVSDateChartState createState() => _TempVSDateChartState();
}

class _TempVSDateChartState extends State<TempVSDateChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                    element.data()["latest_time_change"].toDate().toString(),
                    int.parse(element.data()["temperature"]),
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
                      "Temperature Vs Date",
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
        new charts.ChartTitle('Date/Time',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Temperature',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
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
        id: 'Temperature Vs Time',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}
