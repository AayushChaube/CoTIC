import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../themes/custom_colors.dart';
import '../../widgets/custom_button.dart';

class AddVaccineDetialPageWithEdit extends StatelessWidget {
  final String vaccine_Id;

  AddVaccineDetialPageWithEdit({this.vaccine_Id});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Vaccine",
            style: Theme.of(context).textTheme.headline6,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bottom: TabBar(
            physics: BouncingScrollPhysics(),
            indicatorWeight: 3.0,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                child: Text(
                  "Vaccine Details",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              Tab(
                child: Text(
                  "Vaccine History",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VaccineDetails(vaccine_Id: vaccine_Id),
            VaccineHistory(vaccine_Id: vaccine_Id),
          ],
        ),
      ),
    );
  }
}

class VaccineDetails extends StatelessWidget {
  final String vaccine_Id;

  const VaccineDetails({Key key, this.vaccine_Id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Vaccines")
          .doc(vaccine_Id)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            return Container(
              color: Theme.of(context).backgroundColor,
              child: ListView(
                physics: BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                children: [
                  SizedBox(height: 2.0),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      leading: Text(
                        "Vaccine Name:",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        snapshot.data.data()["vaccine_name"],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      leading: Text(
                        "Vaccine Due Age:",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        snapshot.data.data()["due_Age"],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      leading: Text(
                        "Vaccine Max Age:",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        snapshot.data.data()["max_Age"],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      leading: Text(
                        "Vaccine Route:",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        snapshot.data.data()["route"],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      leading: Text(
                        "Vaccine Site:",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        snapshot.data.data()["site"],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      leading: Text(
                        "Remaining Stock:",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        snapshot.data.data()["remaining_vaccine"].toString() +
                            " units",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  SizedBox(height: 7.0),
                  CustomButton(
                    desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
                    buttonHeight: 60.0,
                    buttonTitle: "Edit Stock",
                    buttonColor: CustomColors.primaryBlue,
                    textColor: Colors.white,
                    buttonRadius: 3.0,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditVaccineStockPage(
                          vaccine_Id: vaccine_Id,
                          remainingStock:
                              snapshot.data.data()["remaining_vaccine"],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class VaccineHistory extends StatelessWidget {
  final String vaccine_Id;

  const VaccineHistory({Key key, this.vaccine_Id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Vaccines")
              .doc(vaccine_Id)
              .collection("History")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.separated(
                padding: EdgeInsets.all(7.0),
                itemBuilder: (context, index) => Card(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: ListTile(
                        title: getProcess(
                            snapshot.data.docs[index].data()["process"],
                            context),
                        trailing: Text(
                          snapshot.data.docs[index]
                              .data()["stock_number"]
                              .toString(),
                          style: Theme.of(context).textTheme.headline5,
                          softWrap: true,
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => SizedBox.shrink(),
                itemCount: snapshot.data.size);
          }),
    );
  }

  Text getProcess(String process, BuildContext context) {
    if (process == "add") {
      return Text(
        "Added",
        style: Theme.of(context).textTheme.headline5,
        softWrap: true,
      );
    } else {
      return Text(
        "Used",
        style: Theme.of(context).textTheme.headline5,
        softWrap: true,
      );
    }
  }
}

class EditVaccineStockPage extends StatefulWidget {
  final String vaccine_Id;
  final int remainingStock;

  EditVaccineStockPage({this.vaccine_Id, this.remainingStock});

  @override
  _EditVaccineStockPageState createState() => _EditVaccineStockPageState();
}

class _EditVaccineStockPageState extends State<EditVaccineStockPage> {
  final TextEditingController stockController = TextEditingController();

  bool _add;

  @override
  void initState() {
    _add = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          "Add Stock",
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(15.0),
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: 10.0),
          ListTile(
            title: Text(
              "Stock Available: ",
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            trailing: Text(
              widget.remainingStock.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: stockController,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Stock to be changed",
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 55,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _add = true),
                    child: Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                          color: _add == true
                              ? CustomColors.primaryBlue
                              : Colors.transparent,
                          border: Border.all(
                              color: _add == false
                                  ? Colors.black
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Text(
                          "Add",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    _add == true ? Colors.white : Colors.black,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _add = false),
                    child: Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                          color: _add == false
                              ? CustomColors.primaryBlue
                              : Colors.transparent,
                          border: Border.all(
                              color: _add == true
                                  ? Colors.black
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Text(
                          "Remove",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    _add == false ? Colors.white : Colors.black,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          CustomButton(
            desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
            buttonHeight: 60.0,
            buttonTitle: "Update Stock",
            buttonColor: CustomColors.primaryBlue,
            textColor: Colors.white,
            buttonRadius: 3.0,
            onPressed: () async {
              int newStock = widget.remainingStock;
              if (_add == true) {
                newStock = newStock + int.parse(stockController.text);
              } else {
                newStock = newStock - int.parse(stockController.text);
              }

              final String historyId = Uuid().v4();
              if (newStock <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Please do not empty the vaccine stock"),
                ));
              } else {
                await FirebaseFirestore.instance
                    .collection("Vaccines")
                    .doc(widget.vaccine_Id)
                    .update({
                  "remaining_vaccine": newStock,
                  "latest_stock_UID": historyId,
                });
                await FirebaseFirestore.instance
                    .collection("Vaccines")
                    .doc(widget.vaccine_Id)
                    .collection("History")
                    .doc(historyId)
                    .set({
                  "uid": historyId,
                  "stock_number": int.parse(stockController.text),
                  "process": _add == true ? "add" : "subtract",
                  "timestamp": DateTime.now(),
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Stock Updated"),
                    action: SnackBarAction(
                        label: "Ok",
                        onPressed: () => Navigator.of(context).pop()),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
