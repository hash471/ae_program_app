import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();

  final _pwdController = TextEditingController();

  String err = '';

  Future login(BuildContext ctx) async {
    Provider.of<Auth>(ctx, listen: false)
        .signIn(this._emailController.text, this._pwdController.text, ctx)
        .then((value) => {setError()});
    print('checking');
  }

  void setError() {
    setState(() {
      this.err = 'Invalid Email/Password';
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              children: <Widget>[
                Container(height: deviceSize.height * 0.1),
                Container(
                  width: deviceSize.width * 0.4,
                  child: Image.asset(
                    'lib/assets/aelogo.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(height: deviceSize.height * 0.1),
                Container(
                  height: deviceSize.height * 0.51,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.white.withOpacity(0.2), BlendMode.dstATop),
                      image: new AssetImage(
                        'lib/assets/agriculture.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color.fromRGBO(255, 255, 255, 0.19),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: deviceSize.height * 0.53,
              ),
              Container(
                width: deviceSize.width * 0.7,
                height: deviceSize.height * 0.07,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    Container(width: deviceSize.width * 0.02),
                    Container(
                      width: deviceSize.width * 0.5,
                      //   height: deviceSize.height * 0.2,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          counterText: "",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: deviceSize.width * 0.7,
                height: deviceSize.height * 0.07,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    Container(width: deviceSize.width * 0.02),
                    Container(
                      width: deviceSize.width * 0.5,

                      //   height: deviceSize.height * 0.2,
                      child: TextField(
                        obscureText: true,
                        controller: _pwdController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          counterText: "",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: deviceSize.height * 0.05),
              Container(
                child: ButtonTheme(
                  minWidth: deviceSize.width * 0.7,
                  height: deviceSize.height * 0.06,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () => login(context),
                    //  shape:
                    // RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(30),
                    // ),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceSize.height * 0.024),
                    ),
                  ),
                ),
              ),
              Container(
                child: Text('$err'),
              )
            ],
          )
        ],
      ),
    ));
  }
}
