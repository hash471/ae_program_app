import 'package:ae_program_app/models/attendance.dart';
import 'package:ae_program_app/providers/attendance.dart';
import 'package:ae_program_app/providers/auth.dart';
import 'package:ae_program_app/providers/batchExams.dart';
import 'package:ae_program_app/providers/batches.dart';
import 'package:ae_program_app/providers/centres.dart';
import 'package:ae_program_app/providers/studentMarks.dart';
import 'package:ae_program_app/providers/students.dart';
import 'package:ae_program_app/screens/attendanceScreen.dart';
import 'package:ae_program_app/screens/authScreen.dart';
import 'package:ae_program_app/screens/marksScreen.dart';
import 'package:ae_program_app/screens/scheduleScreen.dart';
import 'package:ae_program_app/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/tabScreen.dart';


void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
   // final deviceSize = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),),

        ChangeNotifierProxyProvider<Auth, StudentList>(
          update: (ctx, auth, previousStudents ) => 
          previousStudents..auth = auth,
          create: (BuildContext context) {
            return StudentList();
          }, 
          ),
          ChangeNotifierProxyProvider<Auth, StudentMarks>(
          update: (ctx, auth, previousStudents ) => 
          previousStudents..auth = auth,
          create: (BuildContext context) {
            return StudentMarks();
          }, 
          ),  
          ChangeNotifierProxyProvider<Auth, BatchExams>(
          update: (ctx, auth, previousStudents ) => 
          previousStudents..auth = auth,
          create: (BuildContext context) {
            return BatchExams();
          }, 
          ),        
        ChangeNotifierProxyProvider<Auth, CentreList>(
          update: (ctx, auth, previousCentres ) => 
          previousCentres..auth = auth,
          create: (BuildContext context) {
            return CentreList();
          }, 
          ),
          ChangeNotifierProxyProvider<Auth, AttendanceList>(
          update: (ctx, auth, previousAttendance ) => 
          previousAttendance..auth = auth,
          create: (BuildContext context) {
            return AttendanceList();
          }, 
          ),
          ChangeNotifierProxyProvider<Auth, BatchList>(
          update: (ctx, auth, previousBatches ) => 
          previousBatches..auth = auth,
          create: (BuildContext context) {
            return BatchList();
          },
          ),      
      ],
        child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
        home: auth.isAuth 
       ? TabScreen()  
       // ? ViewOrder()
        // : auth.isUser ? LoginScreen() : SignUpScreen() ,
        : FutureBuilder(
         future: auth.tryAutoLogin(ctx), 
         builder: (ctx, authResultSnapshot) =>
         authResultSnapshot.connectionState == 
                              ConnectionState.waiting ? 
                              SplashScreen()
                           : AuthScreen()), 
        
        routes: {
          TabScreen.routeName : (ctx) => TabScreen(),
          AttendanceScreen.routeName : (ctx) => AttendanceScreen(),
          ScheduleScreen.routeName : (ctx) => ScheduleScreen(),
          MarksScreen.routeName : (ctx) => MarksScreen(),
          },
        theme: ThemeData(fontFamily: 'Roboto'),
        ), 
        )
    );
  }
}