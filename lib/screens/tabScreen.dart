import '../models/batch.dart';
import '../models/centre.dart';
import '../models/dashBoard.dart';
import '../models/student.dart';
import '../models/trainer.dart';
import '../providers/auth.dart';
import '../providers/batches.dart';
import '../providers/centres.dart';
import '../providers/students.dart';
import '../screens/attendanceScreen.dart';
import '../screens/marksScreen.dart';
import '../screens/scheduleScreen.dart';
import '../screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabScreen extends StatefulWidget {
  static const routeName = '/mainScreen';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  static const BACKURL =
      'http://LmsApp-env.iy5h5ssp8k.ap-south-1.elasticbeanstalk.com';
  bool _isInit = true;
  Trainer trainer;
  List<String> centres = [];
  List<String> batches = [];
  List<Student> students = [];
  String selectedCentre;
  String selectedBatch;
  bool batchSelected = false;
  int selectedIndex = 0;
  bool dashStartedLoading = false;
  bool dashLoaded = false;
  DashBoard dashBoard;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final authData = Provider.of<Auth>(context);
      Provider.of<CentreList>(context).fetchCentres();
      setState(() {
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  loadDashData() async {
    this.dashStartedLoading = true;
    final url = '$BACKURL/api/appDash/getData';
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final userMap = jsonDecode(response.body) as Map<String, dynamic>;
      List oData = userMap['results'];
      if (oData == null || oData.isEmpty) {
      } else {
        oData.forEach((id) => {this.dashBoard = DashBoard.fromJson(id)});
        this.trainer = Provider.of<Auth>(context, listen: false).getTrainer();
        setState(() {
          this.dashLoaded = true;
        });
      }
    } catch (error) {
      throw (error);
    }
  }

  selectBatchs() {
    setState(() {
      batchSelected = false;
    });
    Provider.of<BatchList>(context, listen: false).refreshBatches();
    this.batches = Provider.of<BatchList>(context, listen: false).getBatchNames;
    this.selectedBatch = this.batches[0];
    Provider.of<BatchList>(context, listen: false)
        .fetchBatches(this.selectedCentre);
  }

  // selectStudents() async {
  //   setState(() {
  //     batchSelected = true;
  //   });
  //   Provider.of<StudentList>(context, listen: false)
  //       .fetchStudents(this.selectedBatch);
  // }

  selectAttendance(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AttendanceScreen.routeName);
  }

  selectMarks(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(MarksScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    if (!dashStartedLoading) {
      loadDashData();
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            // Container(
            //   height: deviceSize.height * 0.03,
            // ),
            dashLoaded
                ? Container(
                    height: deviceSize.height * 0.8,
                    child: Column(
                      children: <Widget>[
                        Container(height: deviceSize.height * 0.05),
                        Container(
                          height: deviceSize.height * 0.13,
                          width: deviceSize.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 7.0,
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                size: deviceSize.height * 0.07,
                              ),
                              Container(
                                width: deviceSize.width * 0.6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: deviceSize.height * 0.034,
                                    ),
                                    Text(
                                      "${trainer.name}",
                                      style: TextStyle(
                                          fontSize: deviceSize.height * 0.025),
                                    ),
                                    Container(
                                      height: deviceSize.height * 0.01,
                                    ),
                                    Container(
                                      child: Text("${trainer.expertise}", overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize:
                                                  deviceSize.height * 0.017)),
                                     
                                    )
                                  ],
                                ),
                              )
                              // ListTile(
                              //   title: Text("${trainer.name}"),
                              //   subtitle: Text("${trainer.expertise}"),
                              // )
                            ],
                          ),
                        ),
                        Container(height: deviceSize.height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: deviceSize.height * 0.2,
                              width: deviceSize.width * 0.42,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(5.0)),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 7.0,
                                    ),
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text("Centres"),
                                  Text(
                                    "${dashBoard.totalCentres}",
                                    style: TextStyle(
                                        fontSize: deviceSize.height * 0.07),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: deviceSize.height * 0.2,
                              width: deviceSize.width * 0.42,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(5.0)),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 7.0,
                                    ),
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text("Projects"),
                                  Text(
                                    "${dashBoard.totalProjects}",
                                    style: TextStyle(
                                        fontSize: deviceSize.height * 0.07),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(height: deviceSize.height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: deviceSize.height * 0.2,
                              width: deviceSize.width * 0.42,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(5.0)),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 7.0,
                                    ),
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text("Batches"),
                                  Text(
                                    "${dashBoard.activeBatches}/${dashBoard.totalBatches}",
                                    style: TextStyle(
                                        fontSize: deviceSize.height * 0.04),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: deviceSize.height * 0.2,
                              width: deviceSize.width * 0.42,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(5.0)),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 7.0,
                                    ),
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text("Students"),
                                  Text(
                                    "${dashBoard.activeStudents}/${dashBoard.totalStudents}",
                                    style: TextStyle(
                                        fontSize: deviceSize.height * 0.04),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: deviceSize.height * 0.8, child: SplashScreen()),
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(width: 0.5, color: Colors.grey))),
              height: deviceSize.height * 0.08,
              child: Row(
                children: <Widget>[
                  Container(
                    width: deviceSize.width * 0.22,
                    child: InkWell(
                      onTap: () => selectAttendance(context),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: deviceSize.height * 0.01,
                          ),
                          Icon(
                            Icons.fingerprint,
                            size: deviceSize.height * 0.04,
                            color: this.selectedIndex == 1
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          Text(
                            'Attendance',
                            style: TextStyle(
                                fontSize: deviceSize.height * 0.015,
                                color: this.selectedIndex == 1
                                    ? Colors.blue
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: deviceSize.width * 0.22,
                    child: InkWell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: deviceSize.height * 0.01,
                          ),
                          Icon(
                            Icons.insert_drive_file,
                            size: deviceSize.height * 0.04,
                            color: this.selectedIndex == 2
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          Text(
                            'Academics',
                            style: TextStyle(
                                fontSize: deviceSize.height * 0.015,
                                color: this.selectedIndex == 2
                                    ? Colors.blue
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: deviceSize.width * 0.12,
                    child: InkWell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: deviceSize.height * 0.006,
                          ),
                          Container(
                              width: deviceSize.width * 0.12,
                              height: deviceSize.width * 0.11,
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(Icons.home,
                                  size: deviceSize.height * 0.04,
                                  color: Colors.white))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: deviceSize.width * 0.22,
                    child: InkWell(
                      onTap: () => selectMarks(context),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: deviceSize.height * 0.01,
                          ),
                          Icon(
                            Icons.list,
                            size: deviceSize.height * 0.04,
                            color: this.selectedIndex == 3
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          Text(
                            'Marks',
                            style: TextStyle(
                                fontSize: deviceSize.height * 0.015,
                                color: this.selectedIndex == 3
                                    ? Colors.blue
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: deviceSize.width * 0.22,
                    child: InkWell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: deviceSize.height * 0.01,
                          ),
                          Icon(
                            Icons.account_box,
                            size: deviceSize.height * 0.04,
                            color: this.selectedIndex == 4
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          Text(
                            'Inventory',
                            style: TextStyle(
                                fontSize: deviceSize.height * 0.015,
                                color: this.selectedIndex == 4
                                    ? Colors.blue
                                    : Colors.grey),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
