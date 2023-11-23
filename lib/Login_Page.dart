import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'SignUpPage.dart';
import 'Forgot_password.dart';
import 'package:http/http.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isSecured=true;
  final _formKey=GlobalKey<FormState>();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();


  void login(String email , password) async {
    try{
      Response response = await post(
          Uri.parse('https://vinsupinfotech.com/FMS/public/api/login'),
          body: {
            'email' : email,
            'password' : password
          }
      );
      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print('Login successfully');
        // clearText();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Login Successfully'
            ),
            backgroundColor: Colors.teal,
            duration: Duration(seconds: 2),
          ),
        );
      }else{
        print('Failed');
        if(response.statusCode == 401){
          print('Account not registered');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Please check your email and password'
              ),
              backgroundColor: Colors.teal,
              duration: Duration(seconds: 2),
            ),
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Login Failed'
              ),
              backgroundColor:Colors.teal,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Container(
                  child: Image.asset('assets/login.png'),
                ),
              ),
              SizedBox(
                height: 60.0,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  fillColor: Colors.teal.withOpacity(0.2),
                  filled: true,
                  prefixIcon:  Icon(Icons.mail),
                ),
                validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText:isSecured,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  fillColor: Colors.teal.withOpacity(0.2),
                  filled: true,
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isSecured=!isSecured;
                      });
                    },
                    icon: Icon(isSecured?Icons.visibility_off: Icons.visibility,
                    ),
                  ),
                ),
                validator: (value){
                  return value! .isEmpty ? 'Enter Password':null;
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));
                    },
                    child:Text(
                      'Forgot Password?',style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                onPressed: () {
                  login(emailController.text.toString(),
                      passwordController.text.toString());

                  // final form = _formKey.currentState;
                  if (_formKey.currentState!.validate()) {
                    // print('Login submitted');
                  }
                },
                child:  Text(
                  "Log In",
                  style: TextStyle(fontSize: 20,color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding:  EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('New User?'),
                  TextButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpPage()));
                  },
                    child:Text(
                      'Create Account',style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void show_Simple_Snackbar(BuildContext context) {
    Flushbar(
      backgroundColor: Colors.teal.shade700,
      duration: Duration(seconds: 1),
      message: "Login Successfully",
    )..show(context);
  }
}