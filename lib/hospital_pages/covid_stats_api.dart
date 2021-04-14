import 'dart:convert';

import 'package:covidtracer/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CovidStatsApi extends StatefulWidget {
  @override
  _CovidStatsApiState createState() => _CovidStatsApiState();
}

class _CovidStatsApiState extends State<CovidStatsApi> {
  Future<void> onRefresh() async {
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "COVID STATS",
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder(
          future: RequestHelper.getRequest(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    primary: false,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "India",
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: CustomColors.primaryBlue,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Active\nCases",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      snapshot.data["activeCases"].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 1.0),
                                    Text(
                                      "(${snapshot.data["activeCasesNew"].toString()}↑)",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Recovered\nCases",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      snapshot.data["recovered"].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 1.0),
                                    Text(
                                      "(${snapshot.data["recoveredNew"].toString()}↑)",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.lightGreenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Total\nDeaths",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      snapshot.data["deaths"].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 1.0),
                                    Text(
                                      "(${snapshot.data["deathsNew"].toString()}↑)",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Total\nCases",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      snapshot.data["totalCases"].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(height: 1.0),
                                    Text(
                                      "(${(snapshot.data["totalCases"] - snapshot.data["previousDayTests"]).toString()}↑)",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.lightGreenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Regions",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          child: ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data["regionData"].length,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CityCovidData(
                                    region: snapshot.data["regionData"][index]
                                        ["region"],
                                    deceased: snapshot.data["regionData"][index]
                                        ["deceased"],
                                    newDeceased: snapshot.data["regionData"]
                                        [index]["newDeceased"],
                                    newInfected: snapshot.data["regionData"]
                                        [index]["newInfected"],
                                    newRecovered: snapshot.data["regionData"]
                                        [index]["newRecovered"],
                                    recovered: snapshot.data["regionData"]
                                        [index]["recovered"],
                                    totalInfected: snapshot.data["regionData"]
                                        [index]["totalInfected"],
                                    dateTime:
                                        snapshot.data["lastUpdatedAtApify"],
                                  ),
                                ),
                              ),
                              title: Text(
                                snapshot.data["regionData"][index]["region"],
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                              ),
                            ),
                            separatorBuilder: (context, index) => Divider(
                              thickness: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Text(snapshot.error),
                );
            }
          },
        ),
      ),
    );
  }
}

class CityCovidData extends StatelessWidget {
  final String region;
  final int totalInfected;
  final int newInfected;
  final int recovered;
  final int newRecovered;
  final int deceased;
  final int newDeceased;
  final String dateTime;

  const CityCovidData({
    this.region = "",
    this.totalInfected = 0,
    this.newInfected = 0,
    this.recovered = 0,
    this.newRecovered = 0,
    this.deceased = 0,
    this.newDeceased = 0,
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          region,
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.white,
              ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            dateTime.substring(8, 10) +
                " " +
                getMonth(
                  int.parse(
                    dateTime.substring(5, 7),
                  ),
                ) +
                " " +
                dateTime.substring(0, 4),
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: CustomColors.primaryBlue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        "Active\nCases",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        totalInfected.toString(),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.0),
                      Text(
                        "(${newInfected.toString()}↑)",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        "Recovered\nCases",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        recovered.toString(),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 1.0),
                      Text(
                        "(${newRecovered.toString()}↑)",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.lightGreenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        "Total\nDeaths",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        deceased.toString(),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.0),
                      Text(
                        "(${newDeceased.toString()}↑)",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              // Expanded(
              //   child: Container(
              //     padding: EdgeInsets.all(20.0),
              //     decoration: BoxDecoration(
              //       color: Colors.green,
              //       borderRadius: BorderRadius.circular(5.0),
              //     ),
              //     child: Column(
              //       mainAxisSize: MainAxisSize.max,
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         SizedBox(height: 10.0),
              //         Text(
              //           "Total\nCases",
              //           style: Theme.of(context).textTheme.headline5.copyWith(
              //                 color: Colors.white,
              //               ),
              //           textAlign: TextAlign.center,
              //         ),
              //         SizedBox(height: 10.0),
              //         Text(
              //           snapshot.data["totalCases"].toString(),
              //           style: Theme.of(context).textTheme.headline5.copyWith(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //         ),
              //         SizedBox(height: 1.0),
              //         Text(
              //           "(${(snapshot.data["totalCases"] - snapshot.data["previousDayTests"]).toString()}↑)",
              //           style: Theme.of(context).textTheme.headline5.copyWith(
              //                 color: Colors.lightGreenAccent,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //           textAlign: TextAlign.center,
              //         ),
              //         SizedBox(height: 10.0),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: 10.0,
              // ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  String getMonth(int month) {
    switch (month) {
      case 1:
        return "Januaury";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June ";
      default:
        return "April";
    }
  }

  String getPeriod(DayPeriod dayPeriod) {
    switch (dayPeriod.index) {
      case 0:
        return "am";
      case 1:
        return "pm";
      default:
        return "pm";
    }
  }
}

class RequestHelper {
  static Future<dynamic> getRequest() async {
    http.Response response = await http.get(
      Uri.https(
        "api.apify.com",
        "/v2/key-value-stores/toDWvRj1JpTXiM8FF/records/LATEST",
        {'q': '{http}'},
      ),
    );

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        return "failed";
      }
    } catch (e) {
      return "failed";
    }
  }
}
