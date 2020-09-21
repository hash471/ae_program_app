import '../models/student.dart';
import '../providers/auth.dart';
import '../providers/batches.dart';
import '../providers/centres.dart';
import '../providers/students.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  static const routeName = '/scheduleScreen';
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool _isInit = true;
  List<String> centres = [];
  List<String> batches = [];
  List<Student> students = [];
  String selectedCentre;
  String selectedBatch;
  bool batchSelected = false;


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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    this.centres = Provider.of<CentreList>(context).getCentreNames;
    this.batches = Provider.of<BatchList>(context).getBatchNames;
    this.students = Provider.of<StudentList>(context).getStudents;
    return Column(
      children: <Widget>[
        Container(
          height: deviceSize.height * 0.1,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(width: deviceSize.width * 0.05),
                Text('ATTENDANCE',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: deviceSize.height * 0.025,
                    )),
                Container(width: deviceSize.width * 0.3),
                Text('${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: deviceSize.height * 0.023,
                    )),
                Container(width: deviceSize.width * 0.05),
                Icon(Icons.menu)
              ],
            ),
          ),
        ),
        Container(
          height: deviceSize.height * 0.08,
          width: deviceSize.width,
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: deviceSize.height * 0.05,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(width: 1)),
                width: deviceSize.width * 0.43,
                child: DropdownButton<String>(
                  value: selectedCentre,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: Colors.brown,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      selectedCentre = newValue;
                    });
                    selectBatchs();
                  },
                  items: centres.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                          width: deviceSize.width * 0.33, child: Text(value)),
                    );
                  }).toList(),
                ),
              ),
              Container(
                width: deviceSize.width * 0.43,
                height: deviceSize.height * 0.05,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(width: 1)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedBatch,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.brown),
                  onChanged: (String newValue) {
                    setState(() {
                      selectedBatch = newValue;
                    });
                    // selectStudents();
                  },
                  items: batches.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(value, overflow: TextOverflow.ellipsis),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
        Container(
          height: deviceSize.height * 0.03,
        ),
        batchSelected
            ? Container(
                height: deviceSize.height * 0.05,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: deviceSize.width * 0.05,
                    ),
                    Text("Students: (${students.length})"),
                    Container(
                      width: deviceSize.width * 0.3,
                    ),
                    Text("Present All"),
                    Container(
                      width: deviceSize.width * 0.05,
                    ),
                    Text("Holiday"),
                  ],
                ),
              )
            : Container(
                height: deviceSize.height * 0.05,
              ),
        Container(width: double.infinity, height: 0.5, color: Colors.grey),
        batchSelected
            ? Center(
                child: Container(
                height: deviceSize.height * 0.64,
                child: students.length == 0
                    ? Container(
                        height: deviceSize.height * 0.1,
                        child: CircularProgressIndicator())
                    : ListView.builder(
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(
                                  deviceSize.width * 0.03,
                                  deviceSize.height * 0.01,
                                  0,
                                  0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: deviceSize.height * 0.08,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: deviceSize.height * 0.07,
                                          width: deviceSize.height * 0.07,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          width: deviceSize.width * 0.06,
                                        ),
                                        Container(
                                          width: deviceSize.width * 0.5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                height:
                                                    deviceSize.height * 0.012,
                                              ),
                                              Text(
                                                '${students[index].rollNo}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Container(
                                                height:
                                                    deviceSize.height * 0.012,
                                              ),
                                              Text(
                                                '${students[index].name}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: deviceSize.width * 0.12,
                                        ),
                                        Container(
                                          child: Text('Present'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: deviceSize.height * 0.01,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      height: 0.5,
                                      color: Colors.grey),
                                ],
                              ));
                        },
                        itemCount: students.length),
              ))
            : Container(
                height: deviceSize.height * 0.64,
                child: Center(child: Text('Batch Not Selected'))),
        ButtonTheme(
          minWidth: double.infinity,
          height: 50,
          child: RaisedButton(
            color: Color(0xff83BB40),
            onPressed: () => null,
            child: Text(
              "SUBMIT ATTENDANCE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
