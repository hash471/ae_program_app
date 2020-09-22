import 'package:app/providers/academics_provider.dart';
import 'package:app/screens/academics/academics_screen.dart';

import './providers/attendance.dart';
import './providers/auth.dart';
import './providers/batchExams.dart';
import './providers/batches.dart';
import './providers/centres.dart';
import './providers/studentMarks.dart';
import './providers/students.dart';
import './screens/attendanceScreen.dart';
import './screens/authScreen.dart';
import './screens/marksScreen.dart';
import './screens/scheduleScreen.dart';
import './screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/tabScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, StudentList>(
          update: (ctx, auth, previousStudents) =>
              previousStudents..auth = auth,
          create: (BuildContext context) {
            return StudentList();
          },
        ),
        ChangeNotifierProxyProvider<Auth, StudentMarks>(
          update: (ctx, auth, previousStudents) =>
              previousStudents..auth = auth,
          create: (BuildContext context) {
            return StudentMarks();
          },
        ),
        ChangeNotifierProxyProvider<Auth, BatchExams>(
          update: (ctx, auth, previousStudents) =>
              previousStudents..auth = auth,
          create: (BuildContext context) {
            return BatchExams();
          },
        ),
        ChangeNotifierProxyProvider<Auth, CentreList>(
          update: (ctx, auth, previousCentres) => previousCentres..auth = auth,
          create: (BuildContext context) {
            return CentreList();
          },
        ),
        ChangeNotifierProxyProvider<Auth, AttendanceList>(
          update: (ctx, auth, previousAttendance) =>
              previousAttendance..auth = auth,
          create: (BuildContext context) {
            return AttendanceList();
          },
        ),
        ChangeNotifierProxyProvider<Auth, BatchList>(
          update: (ctx, auth, previousBatches) => previousBatches..auth = auth,
          create: (BuildContext context) {
            return BatchList();
          },
        ),
        ChangeNotifierProvider<AcademicsProvider>(
          create: (BuildContext context) => AcademicsProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? TabScreen()
              // ? ViewOrder()
              // : auth.isUser ? LoginScreen() : SignUpScreen() ,
              : FutureBuilder(
                  future: auth.tryAutoLogin(ctx),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            TabScreen.routeName: (ctx) => TabScreen(),
            AttendanceScreen.routeName: (ctx) => AttendanceScreen(),
            AcademicsScreen.routeName: (context) => AcademicsScreen(),
            ScheduleScreen.routeName: (ctx) => ScheduleScreen(),
            MarksScreen.routeName: (ctx) => MarksScreen(),
          },
          theme: ThemeData(fontFamily: 'Roboto'),
        ),
      ),
    );
  }
}
