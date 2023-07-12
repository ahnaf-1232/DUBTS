import 'package:dubts/shared/loading.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign In'),
        actions: <Widget>[
          TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Register'),
              onPressed: () {
                widget.toggleView();
              }),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your email',
                ),
                validator: (val) {
                  val!.isEmpty ? 'Please enter an email' : null;
                },
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter password',
                ),
                obscureText: true,
                validator: (val) {
                  val!.length < 6
                      ? 'Password must be at least 6 digit long'
                      : null;
                },
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              OutlinedButton(
                // color: Colors.pink,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading=true;
                    });
                    dynamic result =
                        await _auth.signInWithMail(email, password);
                    if (result == null) {
                      setState(() {
                        error = 'Could not sign in';
                        loading=false;
                      });
                    }

                    print(email);
                    print(password);
                  }
                  Navigator.pushNamed(context, '/profile');
                },
                child: Text('Sign in'),
              )
            ],
          ),
        ),

        // child: ElevatedButton(
        //   child: Text('sign in anonymously'),
        //   style: ElevatedButton.styleFrom(
        //     primary: Colors.black, // Background color
        //   ),
        //   onPressed: () async {
        //     dynamic result = await _auth.signInAnon();
        //     if(result == null){
        //       print('error signing in');
        //     } else {
        //       print('signed in');
        //       print(result);
        //     }
        //   },
        // ),
      ),
    );
  }
}
