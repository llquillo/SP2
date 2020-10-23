import 'package:flutter/material.dart';
import './auth.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Regustered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Login Demo'),
      ),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.0,
          ),
          new Container(
            alignment: Alignment(-0.5, 0.7),
            child: new Text(
              "Hello.",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontSize: 62.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            alignment: Alignment(-0.6, 0.9),
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildInputs() + buildSubmitButtons(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          new Container(
            width: 250.0,
            child: new TextFormField(
              decoration: new InputDecoration(labelText: 'Email'),
              validator: (value) =>
                  value.isEmpty ? 'Email can\'t be empty' : null,
              onSaved: (value) => _email = value,
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            ),
          ),
          new Container(
            width: 250.0,
            child: new TextFormField(
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) =>
                  value.isEmpty ? 'Password can\'t be empty' : null,
              onSaved: (value) => _password = value,
              style: new TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            ),
          )
        ],
      )
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        SizedBox(
          height: 10.0,
        ),
        new MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(8.0),
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Login',
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          onPressed: validateAndSubmit,
        ),
        new MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(8.0),
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Create an Account',
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        SizedBox(
          height: 15.0,
        ),
        new MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(8.0),
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Create an Account',
            style: new TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          onPressed: validateAndSubmit,
        ),
        new MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(8.0), //removes the padding in button
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Already have an account? Login.',
            style: new TextStyle(
              fontSize: 14.0,
            ),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
