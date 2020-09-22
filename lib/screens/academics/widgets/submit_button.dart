import 'package:app/providers/academics_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AcademicsProvider>(
      builder: (context, provider, child) {
        return ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          height: 50.0,
          child: RaisedButton(
            child: Text(
              'SUBMIT',
              style: TextStyle(color: Colors.white),
            ),
            color: Color(0xff83BB40),
            onPressed: provider.hasChanges ? provider.applyChangesToCurrent : null,
          ),
        );
      }
    );
  }
}
