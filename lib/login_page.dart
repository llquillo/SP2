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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Learn Bicol',
              style: GoogleFonts.robotoMono(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              )),
        ),
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: false,
        body: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/background.gif"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.9), BlendMode.dstATop),
            )),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    Container(
                      alignment: Alignment(-0.5, 0.7),
                      child: new Text(
                        "Kumusta?",
                        style: GoogleFonts.robotoMono(
                          textStyle: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 40.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            // decorationStyle: TextDecorationStyle.wavy,
                            decorationThickness: 1.5,
                            // fontStyle: FontStyle.italic,
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        border: Border.all(width: 2),
                        color: Color(0xffF1F8FF).withOpacity(.85),
                      ),
                      width: MediaQuery.of(context).size.width / 1.3,
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
            )));
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.4,
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Email',
                  // border: OutlineInputBorder(),
                  labelStyle: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value,
                style: GoogleFonts.robotoMono(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.4,
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Password',
                  // border: OutlineInputBorder(),
                  labelStyle: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Password can\'t be empty' : null,
                onSaved: (value) => _password = value,
                style: GoogleFonts.robotoMono(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ))
      ];
    } else {
      return [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.4,
              child: new TextFormField(
                decoration: new InputDecoration(
                  // border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Name',
                  labelStyle: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Name can\'t be empty' : null,
                onSaved: (value) => _name = value,
                style: GoogleFonts.robotoMono(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.4,
              child: new TextFormField(
                decoration: new InputDecoration(
                  // border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Email',
                  labelStyle: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                validator: (value) =>
                    value.isEmpty ? 'Email can\'t be empty' : null,
                onSaved: (value) => _email = value,
                style: GoogleFonts.robotoMono(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.4,
              child: new TextFormField(
                decoration: new InputDecoration(
                  // border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Password',
                  labelStyle: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                validator: (value) => value.isEmpty
                    ? 'Password can\'t be empty'
                    : pass2 == (pass1 = value)
                        ? null
                        : 'Passwords don\'t match',
                onSaved: (value) => _password = value,
                style: GoogleFonts.robotoMono(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.4,
              child: new TextFormField(
                decoration: new InputDecoration(
                  // border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Confirm Password',
                  labelStyle: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                validator: (value) => value.isEmpty
                    ? 'Confirm your password'
                    : pass1 == (pass2 = value)
                        ? null
                        : 'Passwords don\'t match',
                onSaved: (value) => _confirmPassword = value,
                style: GoogleFonts.robotoMono(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
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
        SizedBox(height: 10.0),
        new MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.all(10.0),
          height: 2.0,
          minWidth: 2.0,
          child: new Text(
            'Login',
            style: GoogleFonts.robotoMono(
              fontSize: 14.0,
              fontWeight: FontWeight.w800,
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
            style: GoogleFonts.robotoMono(
              fontSize: 14.0,
              fontWeight: FontWeight.w800,
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
            style: GoogleFonts.robotoMono(
              fontSize: 14.0,
              fontWeight: FontWeight.w800,
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
            style: GoogleFonts.robotoMono(
              fontWeight: FontWeight.w800,
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
  }
}
