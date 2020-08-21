import 'package:ae_program_app/models/attendance.dart';
import 'package:ae_program_app/models/student.dart';
import 'package:ae_program_app/providers/attendance.dart';
import 'package:ae_program_app/providers/auth.dart';
import 'package:ae_program_app/providers/batches.dart';
import 'package:ae_program_app/providers/centres.dart';
import 'package:ae_program_app/providers/students.dart';
import 'package:ae_program_app/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  static const routeName = '/attendanceScreen';
  @override
  AttendanceScreen_State createState() => AttendanceScreen_State();
}

class AttendanceScreen_State extends State<AttendanceScreen> {
  bool _isInit = true;
  List<String> centres = [];
  List<String> batches = [];
  //List<Student> students = [];
  List<Attendance> students = [];
  String selectedCentre;
  String selectedBatch;
  String selectedDate;
  bool batchSelected = false;
  bool rememberMe = false;
  bool attendanceMarked = false;
  bool attendancePresent = false;
  bool batchesloaded = true;
  bool studentsloaded = true;

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

  selectStudents(BuildContext ctx) async {
    setState(() {
      batchSelected = true;
    });
    this.selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    // Provider.of<StudentList>(context, listen: false)
    //     .fetchStudents(this.selectedBatch);
    Provider.of<AttendanceList>(context, listen: false)
        .fetchAttendance(ctx, this.selectedBatch, this.selectedDate);
  }

  void _onRememberMeChanged(bool newValue, int index) => setState(() {
        if (!attendancePresent) {
          if (index < 0) {
            this.students.forEach((id) {
              if (newValue) {
                id.status = 'Yes';
              } else {
                id.status = 'No';
              }
            });
            this.rememberMe = newValue;
          } else {
            this.rememberMe = false;
            if (newValue) {
              this.students[index].status = 'Yes';
            } else {
              this.students[index].status = 'No';
            }
          }
        }
      });

  void submit(BuildContext ctx) async {
    final data = Provider.of<AttendanceList>(ctx, listen: false);
    final orderSt = await data.addOrder(this.students);
    Navigator.of(ctx).popUntil(ModalRoute.withName('/'));
  }

  void goAhead(BuildContext ctx) async {
    final deviceSize = MediaQuery.of(context).size;
    setState(() {
      this.attendanceMarked = true;
    });
    int present = 0, absent = 0;
    this.students.forEach((id) {
      if (id.status == 'Yes') {
        present++;
      } else {
        absent++;
      }
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Container(
              width: deviceSize.width * 0.4,
              height: deviceSize.height * 0.23,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: deviceSize.height * 0.02,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                            onTap: () => {
                                  setState(() {
                                    this.attendanceMarked = false;
                                  }),
                                  Navigator.of(context).pop(true)
                                },
                            child: Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    height: deviceSize.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'Present',
                            style:
                                TextStyle(fontSize: deviceSize.height * 0.02),
                          ),
                          Text(
                            '$present',
                            style:
                                TextStyle(fontSize: deviceSize.height * 0.07),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            'Absent',
                            style:
                                TextStyle(fontSize: deviceSize.height * 0.02),
                          ),
                          Text(
                            '$absent',
                            style:
                                TextStyle(fontSize: deviceSize.height * 0.07),
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: deviceSize.height * 0.01,
                  ),
                  ButtonTheme(
                    minWidth: deviceSize.width * 0.4,
                    height: deviceSize.height * 0.035,
                    child: RaisedButton(
                      color: Color(0xff83BB40),
                      onPressed:
                          attendancePresent ? null : () => submit(context),
                      child: Text(
                        attendancePresent ? "Submitted" : "SUBMIT",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    this.centres = Provider.of<CentreList>(context).getCentreNames;
    this.batches = Provider.of<BatchList>(context).getBatchNames;
    // this.students = Provider.of<StudentList>(context).getStudents;
    this.students = Provider.of<AttendanceList>(context).getAttendance;
    this.attendancePresent = Provider.of<AttendanceList>(context).getStatus;
    this.batchesloaded = Provider.of<BatchList>(context).getStatus();
    this.studentsloaded = Provider.of<AttendanceList>(context).getLoader();

    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          height: deviceSize.height * 0.13,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                    )),
                Container(width: deviceSize.width * 0.05),
                Text('ATTENDANCE',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: deviceSize.height * 0.025,
                    )),
                Container(width: deviceSize.width * 0.2),
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
                    selectStudents(context);
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
                      width: deviceSize.width * 0.2,
                    ),
                    Container(
                      width: deviceSize.width * 0.1,
                      child: Checkbox(
                          activeColor: Colors.green,
                          value: rememberMe,
                          onChanged: (val) {
                            _onRememberMeChanged(val, -1);
                          }),
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
                child: this.studentsloaded
                    ? SplashScreen()
                    : students.length == 0 ? 
                    Center(child: Text('No Student data found'))
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
                                          child: Container(
                                            width: deviceSize.width * 0.1,
                                            child: Checkbox(
                                                activeColor: Colors.green,
                                                value: this
                                                            .students[index]
                                                            .status ==
                                                        'Yes'
                                                    ? true
                                                    : false,
                                                onChanged: (val) {
                                                  _onRememberMeChanged(
                                                      val, index);
                                                }),
                                          ),
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
              )
              )
            : Container(
                height: deviceSize.height * 0.64,
                child: Center(child: Text('Batch Not Selected'))),
        this.attendancePresent
            ? ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                  color: Colors.grey,
                  onPressed: () => goAhead(context),
                  child: Text(
                    "Attendance Already Marked",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                  color: Color(0xff83BB40),
                  onPressed: () => goAhead(context),
                  child: Text(
                    this.attendanceMarked
                        ? "Attendance Marked"
                        : "SUBMIT ATTENDANCE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
      ],
    ));
  }
}
