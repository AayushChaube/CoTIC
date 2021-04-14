import 'package:covidtracer/health_worker_pages/patients_page/patient_HISTORY_record.dart';
import 'package:covidtracer/health_worker_pages/visualization_graph/spo_vs_date.dart';
import 'package:covidtracer/health_worker_pages/visualization_graph/temp_vs_Date.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThirdTab extends StatelessWidget {
  final String id;

  const ThirdTab({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: GridView.count(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          primary: false,
          padding: const EdgeInsets.all(15.0),
          children: [
            CustomCardWidget(
              tileIcon: FaIcon(FontAwesomeIcons.file),
              tileTitle: "Records",
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PatientHistoryRecordData(id),
              )),
            ),
            CustomCardWidget(
              tileIcon: FaIcon(FontAwesomeIcons.chartPie),
              tileTitle: "Visualization",
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VisualizationPage(patientId: id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCardWidget extends StatelessWidget {
  final Widget tileIcon;
  final String tileTitle;
  final VoidCallback onPressed;

  const CustomCardWidget({
    Key key,
    @required this.tileIcon,
    @required this.tileTitle,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tileIcon,
            SizedBox(height: 10.0),
            Text(
              tileTitle,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}

class VisualizationPage extends StatelessWidget {
  final String patientId;

  const VisualizationPage({Key key, this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryBlue,
        centerTitle: true,
        title: Text(
          "Visualization Page",
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(7.0),
        physics: BouncingScrollPhysics(),
        children: [
          Card(
            elevation: 5.0,
            child: ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TempVSDateChart(
                    patientId: patientId,
                  ),
                ),
              ),
              title: Text(
                "Temperature Vs Date",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Card(
            elevation: 5.0,
            child: ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SpoVsDate(
                    patientId: patientId,
                  ),
                ),
              ),
              title: Text(
                "SpO2 Vs Date",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
