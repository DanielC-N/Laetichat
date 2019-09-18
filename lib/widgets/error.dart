import 'package:flutter/material.dart';

class ErrorHandlerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text('Erreur : mot de passe incorrect !'),
      ),
      children: <Widget>[
        _getButtonOpt(context),
      ],
    );
  }

  Widget _getButtonOpt(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () { Navigator.pop(context); },
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
