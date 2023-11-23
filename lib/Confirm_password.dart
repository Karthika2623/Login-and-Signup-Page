import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Login_Page.dart';
import 'get_otp_res_data.dart';
import 'Otp_verification.dart';

class ConfirmPassword extends StatefulWidget {
  @override
  _ConfirmPasswordState createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  bool isSecured1 = true;
  bool isSecured2=true;

  final _formKey = GlobalKey<FormState>();
  TextEditingController user_idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController c_passwordController = TextEditingController();




  void Change_Password(String user_id, password) async {
    try {
      Response response = await post(
          Uri.parse(
              'https://vinsupinfotech.com/FMS/public/api/change_password'),
          body: {
            'user_id': user_id,
            'password': password,
          });
      if (response.statusCode == 200) {
        var data=jsonDecode(response.body.toString());
        print(data['token']);
        if (_formKey.currentState!.validate() && passwordController.text == c_passwordController.text) {
          print('Password Changed Successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // duration: Duration(seconds: 1),
              content: Text(
                'Password changed successfully',
                style: TextStyle(fontSize: 20.0,
                    color: Colors.white),
              ),
              backgroundColor: Colors.teal,
              action: SnackBarAction(
                label: 'Ok',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please check your User ID'),
            backgroundColor: Colors.teal,duration: Duration(seconds: 1),),
        );
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void initState() {
    super.initState();
    user_idController = new TextEditingController(text: OTPVerifi.user_id.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.teal.shade200,
        title: Text(
          'Change Password',
          style: TextStyle(fontSize: 25.0, color: Colors.teal),
        ),
      ),
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
                  child: Image.asset('assets/otp.png'),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                showCursor: true,
                controller: user_idController,
                decoration: InputDecoration(
                  hintText: OTPVerifi.user_id.toString(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  fillColor: Colors.teal.withOpacity(0.2),
                  filled: true,
                  prefixIcon: Icon(Icons.perm_identity),
                ),
                validator: (value) {
                  return value!.isEmpty ? 'Enter User-Id' : null;
                },

              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: isSecured1,
                // showCursor: true,
                controller: passwordController,
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
                        isSecured1 = !isSecured1;
                      });
                    },
                    icon: Icon(
                      isSecured1 ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter Password';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: c_passwordController,
                obscureText: isSecured2,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  fillColor: Colors.teal.withOpacity(0.2),
                  filled: true,
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isSecured2 = !isSecured2;
                      });
                    },
                    icon: Icon(
                      isSecured2 ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
                validator: (value) {
                  return value!.isEmpty ? 'Enter Confirm Password' : null;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (passwordController.text !=
                      c_passwordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '"Password does not match. Please re-type again."'),
                          backgroundColor: Colors.teal),
                    );
                  }
                  Change_Password(user_idController.text.toString(), passwordController.text.toString());
                },
                child: Text('Reset Password',
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
