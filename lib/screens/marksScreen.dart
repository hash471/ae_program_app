import '../models/batchExam.dart';
import '../models/studentMarks.dart';
import '../providers/auth.dart';
import '../providers/batchExams.dart';
import '../providers/batches.dart';
import '../providers/centres.dart';
import '../providers/studentMarks.dart';
import '../screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarksScreen extends StatefulWidget {
  static const routeName = '/marksScreen';
  @override
  _MarksScreenState createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  bool _isInit = true;
  List<TextEditingController> _controller = [];
  List<String> centres = [];
  List<String> batches = [];
  List<String> examTypes = [];
  List<String> examNames = [];
  //List<Student> students = [];
  List<StudentMark> students = [];
  List<BatchExam> batchExams = [];
  String selectedCentre;
  String selectedBatch;
  String selectedExam;
  String selectedExamName;
  int maxMarks;
  int erroredIndex;
  bool studentChanged = true;
  bool batchSelected = false;
  bool rememberMe = false;
  bool attendanceMarked = false;
  bool attendancePresent = false;
  bool batchesloaded = true;
  bool studentsloaded = true;
  bool marksPresent = false;
  bool error = false;

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
      this.students = [];
      this.studentChanged = true;
    });
    Provider.of<BatchList>(context, listen: false).refreshBatches();
    this.batches = Provider.of<BatchList>(context, listen: false).getBatchNames;
    this.selectedBatch = this.batches[0];
    Provider.of<BatchList>(context, listen: false)
        .fetchBatches(this.selectedCentre);
  }

  selectExams(BuildContext ctx) async {
    setState(() {
      this.examNames.add("");
      this.selectedExamName = "";
      this.examNames = [];
      this.examNames.add("Select Exam");
      this.selectedExamName = "Select Exam";
    });
    List<String> results = [];
    setState(() {
      this.students = [];
      batchSelected = true;
      this.studentChanged = true;
    });
    this.examTypes = [];
    await Provider.of<BatchExams>(context, listen: false)
        .fetchBatchExams(ctx, this.selectedBatch, this.selectedCentre);
    results = Provider.of<BatchExams>(context, listen: false)
        .getExamTypes(this.selectedBatch);
    setState(() {
      results.forEach((element) {
        this.examTypes.add(element);
      });
    });
  }

  selectExamNames(BuildContext ctx) async {
    List<String> results = [];
    setState(() {
      this.students = [];
      this.studentChanged = true;
    });
    results = Provider.of<BatchExams>(context, listen: false)
        .getExamNames(this.selectedExam);
    this.examNames = [];
    this.examNames.add('Select Exam');
    this.selectedExamName = 'Select Exam';
    setState(() {
      results.forEach((element) {
        this.examNames.add(element);
      });
    });
  }

  selectStudents(BuildContext ctx) async {
    this.studentChanged = true;
    Provider.of<StudentMarks>(context, listen: false)
        .fetchStudentMarks(ctx, this.selectedBatch, this.selectedExamName);
    setState(() {
      this.maxMarks = Provider.of<BatchExams>(context, listen: false)
          .maxMarks(this.selectedExamName);
      this.studentChanged = false;
    });
  }

  void submit(BuildContext ctx) async {
    final data = Provider.of<StudentMarks>(ctx, listen: false);
    final orderSt = await data.addMarks(this.students);
    Navigator.of(ctx).popUntil(ModalRoute.withName('/'));
  }

  void goAhead(BuildContext ctx) async {
    print(students[0].marks);
    final deviceSize = MediaQuery.of(context).size;
    setState(() {
      this.attendanceMarked = true;
    });
    this.error = false;
    for (int i = 0; i < this.students.length; i++) {
      this.students[i].marks = int.parse(_controller[i].text);
    }
    this.students.forEach((id) {
      id.examName = selectedExamName;
      if (id.marks < 0 || id.marks > maxMarks) {
        this.error = true;
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
                  Container(
                    height: deviceSize.height * 0.01,
                  ),
                  this.error
                      ? Container(child: Text("Marks are Improper"))
                      : Container(child: Text("Marks for $selectedExamName")),
                  Container(
                    height: deviceSize.height * 0.015,
                  ),
                  ButtonTheme(
                    minWidth: deviceSize.width * 0.4,
                    height: deviceSize.height * 0.035,
                    child: RaisedButton(
                      color: Color(0xff83BB40),
                      onPressed: error
                          ? null
                          : attendancePresent ? null : () => submit(context),
                      child: Text(
                        error
                            ? "Error"
                            : attendancePresent ? "Submitted" : "SUBMIT",
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
    if (studentsloaded) {
      print('fetching students');
      this.students = Provider.of<StudentMarks>(context).getStudentMarks;
      for (int i = 0; i < students.length; i++) {
        _controller.add(new TextEditingController());
        _controller[i].text = this.students[i].marks.toString();
      }
    }
    this.studentsloaded = Provider.of<StudentMarks>(context).getLoader();
    this.marksPresent = Provider.of<StudentMarks>(context).getStatus;
    this.batchesloaded = Provider.of<BatchList>(context).getStatus();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: deviceSize.height * 0.12,
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
                    Text('MARKS',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: deviceSize.height * 0.025,
                        )),
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
                      items:
                          centres.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                              width: deviceSize.width * 0.33,
                              child: Text(value)),
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
                        selectExams(context);
                      },
                      items:
                          batches.map<DropdownMenuItem<String>>((String value) {
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
            this.batchSelected
                ? Container(
                    height: deviceSize.height * 0.08,
                    width: deviceSize.width,
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: deviceSize.height * 0.05,
                          alignment: Alignment.center,
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          width: deviceSize.width * 0.43,
                          child: DropdownButton<String>(
                            value: selectedExam,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                              color: Colors.brown,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                selectedExam = newValue;
                              });
                              selectExamNames(context);
                            },
                            items: examTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                    width: deviceSize.width * 0.33,
                                    child: Text(value)),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          width: deviceSize.width * 0.43,
                          height: deviceSize.height * 0.05,
                          alignment: Alignment.center,
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedExamName,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.brown),
                            onChanged: (String newValue) {
                              setState(() {
                                selectedExamName = newValue;
                              });
                              selectStudents(context);
                            },
                            items: examNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(value,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    height: deviceSize.height * 0.08,
                  ),
            Container(height: deviceSize.height * 0.03),
            studentChanged
                ? Container(
                    height: deviceSize.height * 0.05,
                  )
                : Container(
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
                          width: deviceSize.width * 0.15,
                        ),
                        Text("Max Marks : "),
                        Container(
                          width: deviceSize.width * 0.02,
                        ),
                        Text(
                          "$maxMarks",
                          style: TextStyle(fontSize: deviceSize.height * 0.025),
                        ),
                      ],
                    ),
                  ),
            Container(
              color: Colors.grey,
              height: 1,
            ),
            Container(
              height: deviceSize.height * 0.02,
            ),
            this.studentChanged
                ? Container(
                    height: deviceSize.height * 0.52,
                    child: Text('Select the Exams'),
                  )
                : Container(
                    height: deviceSize.height * 0.52,
                    child: this.studentsloaded
                        ? SplashScreen()
                        : students.length == 0
                            ? Center(child: Text('No Student data found'))
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
                                                  height:
                                                      deviceSize.height * 0.07,
                                                  width:
                                                      deviceSize.height * 0.07,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                      deviceSize.width * 0.06,
                                                ),
                                                Container(
                                                  width: deviceSize.width * 0.5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        height:
                                                            deviceSize.height *
                                                                0.012,
                                                      ),
                                                      Text(
                                                        '${students[index].rollNo}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      Container(
                                                        height:
                                                            deviceSize.height *
                                                                0.012,
                                                      ),
                                                      Text(
                                                        '${students[index].name}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                      deviceSize.width * 0.12,
                                                  child: Container(
                                                    width:
                                                        deviceSize.width * 0.1,
                                                  ),
                                                ),
                                                Container(
                                                  width: deviceSize.width * 0.1,
                                                  child: marksPresent
                                                      ? Text(
                                                          '${students[index].marks}')
                                                      : TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              _controller[
                                                                  index],
                                                          decoration:
                                                              InputDecoration(
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide: (int.parse(_controller[index].text) <
                                                                                0 ||
                                                                            int.parse(_controller[index].text) >
                                                                                30)
                                                                        ? BorderSide(
                                                                            color: Colors
                                                                                .red)
                                                                        : BorderSide(
                                                                            color:
                                                                                Colors.blue),
                                                                  ),
                                                                  fillColor: index ==
                                                                          erroredIndex
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .blue),
                                                          //   onChanged: (value) {
                                                          //     int marks =
                                                          //         int.parse(
                                                          //             value);
                                                          //     students[index]
                                                          //         .marks = marks;
                                                          //     _controller[index]
                                                          //         .text = students[index]
                                                          //         .marks.toString();
                                                          //   },
                                                        ),
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
                  ),
            this.marksPresent
                ? ButtonTheme(
                    minWidth: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.grey,
                      onPressed: () => goAhead(context),
                      child: Text(
                        "Marks Already Submitted",
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
                        this.marksPresent
                            ? "Attendance Marked"
                            : "SUBMIT MARKS",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
