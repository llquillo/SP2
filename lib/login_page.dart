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
  String _confirmPassword;
  String _name;
  String pass1, pass2;
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
              .createUserWithEmailAndPassword(_email, _password, _name);
          print('Registered user: $userId');
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
      backgroundColor: Color(0xffB7DCFF),
      appBar: AppBar(
        title: Text('App Name'),
      ),
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
            ),
            new Container(
              alignment: Alignment(-0.5, 0.7),
              child: new Text(
                "Kumusta.",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 50.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              alignment: Alignment(-0.6, 0.9),
              padding: EdgeInsets.all(14.0),
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
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.2,
              child: new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) =>
                    value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value,
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.2,
              child: new TextFormField(
                decoration: new InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value,
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        )
      ];
    } else {
      return [
        Column(
          children: [
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.2,
              child: new TextFormField(
                decoration: new InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value.isEmpty ? 'Name can\'t be empty' : null,
                onSaved: (value) => _name = value,
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.2,
              child: new TextFormField(
                decoration: new InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value,
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.2,
              child: new TextFormField(
                decoration: new InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value.isEmpty
                    ? 'Password can\'t be empty'
                    : pass2 == (pass1 = value)
                        ? null
                        : 'Passwords don\'t match',
                onSaved: (value) => _password = value,
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.2,
              child: new TextFormField(
                decoration: new InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) => value.isEmpty
                    ? 'Confirm your password'
                    : pass1 == (pass2 = value)
                        ? null
                        : 'Passwords don\'t match',
                onSaved: (value) => _confirmPassword = value,
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        )
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        SizedBox(
          height: 10.0,
        ),
        new MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(10.0),
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Login',
            style: new TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          onPressed: validateAndSubmit,
        ),
        new MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(10.0),
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Create an Account',
            style: new TextStyle(
              fontSize: 16.0,
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
          padding: EdgeInsets.all(10.0),
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Create an Account',
            style: new TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            validateAndSubmit();
            print(pass1);
            print(pass2);
          },
        ),
        new MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(10.0), //removes the padding in button
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Already have an account? Login.',
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
