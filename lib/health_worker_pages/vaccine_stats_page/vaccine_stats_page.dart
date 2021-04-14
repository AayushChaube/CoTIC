import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidtracer/Services/sharedprefs_helper.dart';
import 'package:flutter/material.dart';

class VaccineStatsPage extends StatefulWidget {
  @override
  _VaccineStatsPageState createState() => _VaccineStatsPageState();
}

class _VaccineStatsPageState extends State<VaccineStatsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Vaccines")
            .orderBy("created", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              List<QueryDocumentSnapshot> query = snapshot.data.docs;
              query.removeWhere((element) => element.data()["assigned"] != id);
              if (query.isEmpty) {
                return Center(
                  child: Text(
                    "No Vaccine Stock Available",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                );
              }

              List<OrdinalSales> lsit1 = [];
              for (int i = query.length - 1; i >= 0; i--) {
                int sum = 0;
                String year =
                    query[i].data()["created"].toDate().day.toString() +
                        "/" +
                        query[i].data()["created"].toDate().month.toString() +
                        "/" +
                        query[i].data()["created"].toDate().year.toString();
                if (query[i].data()["given"] == true) {
                  sum = sum + query[i].data()["dose"];
                } else {
                  sum = sum + 0;
                }

                if (lsit1.where((element) => element.year == year) == true) {
                  int index =
                      lsit1.indexWhere((element) => element.year == year);
                  sum += lsit1.elementAt(index).sales;
                  lsit1.removeAt(index);
                  lsit1.insert(index, OrdinalSales(year, sum));
                }
                lsit1.add(OrdinalSales(year, sum));
              }
              lsit1.forEach((element) {
                print(element.year);
              });
              return Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  padding: EdgeInsets.all(20.0),
                  child: SimpleBarChart.withSampleData(lsit1));

            default:
              return Center(child: CircularProgressIndicator());
          }
        });
  }

  Text getDate(
      List<QueryDocumentSnapshot> query, int index, BuildContext context) {
    DateTime created = query[index].data()["created"].toDate();
    DateTime now = DateTime.now();
    Duration duration = now.difference(created);
    if (duration.inDays == 1) {
      return Text(
        "Yesterday",
        style: Theme.of(context).textTheme.subtitle1,
      );
    } else if (duration.inDays == 2) {
      return Text(
        "Day before yesterday",
        style: Theme.of(context).textTheme.subtitle1,
      );
    } else {
      return Text(
        query[index].data()["created"].toDate().day.toString() +
            "/" +
            query[index].data()["created"].toDate().month.toString() +
            "/" +
            query[index].data()["created"].toDate().year.toString(),
        style: Theme.of(context).textTheme.subtitle1,
      );
    }
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData(List<OrdinalSales> sales) {
    return new SimpleBarChart(
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
        new charts.ChartTitle('Date',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('No of doses per day',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      List<OrdinalSales> sales) {
    final data = sales;

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Vaccine given on single date',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
