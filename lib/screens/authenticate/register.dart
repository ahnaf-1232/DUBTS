import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;

  Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey =GlobalKey<FormState>();


  String email = '';
  String password = '';
  String error='';
  bool loading=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign Up'),
        actions: <Widget>[
          TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Sign In'),
              onPressed: () {
                widget.toggleView();
              }
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your email',
                ),
                validator: (val){
                  val!.isEmpty ? 'Please enter an email': null;
                },
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Set password',
                ),
                obscureText: true,
                validator: (val){
                  val!.length<6 ? 'Password must be at least 6 digit long': null;
                },
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              OutlinedButton(
                // color: Colors.pink,
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      loading=true;
                    });
                    dynamic result= await _auth.register(email, password);
                    if (result== null){
                      setState(() {
                        error= 'please enter valid credentials.';
                        loading=false;
                      });
                    }

                    print(email);
                    print(password);
                  }

                },
                child: const Text('Register'),

              ),
              SizedBox(height: 12.0),
              Text(
          error,
      )
            ],
          ),
        ),
      ),
    );
  }
}
