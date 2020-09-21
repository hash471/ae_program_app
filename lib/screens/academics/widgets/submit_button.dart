import 'package:app/providers/academics_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final buttonSize = Size(
      MediaQuery.of(context).size.width,
      kToolbarHeight,
    );
    return Consumer<AcademicsProvider>(
      builder: (context, provider, child) {
        return SizedBox.fromSize(
          size: buttonSize,
          child: FlatButton(
            child: Text(
              'Submit',
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
