
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Login_Page.dart';
import 'package:email_validator/email_validator.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController c_passwordController = TextEditingController();

  void SignUp(String name, email, password, c_password) async {
    try {
      Response response = await post(
          Uri.parse('https://vinsupinfotech.com/FMS/public/api/register'),
          body: {
            'name': name,
            'email': email,
            'password': password,
            'c_password': c_password
          });

      if (response.statusCode == 200) {
        // var data = jsonDecode(response.body.toString());
        // print(data['token']);
        // print('Signup Page successfully');
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Alert"),
            content:  Text("SignIn Successfully.."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  child: const Text("okay"),
                ),
              ),
            ],
          ),
        );
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }
  bool isSecured1 = true;
  bool isSecured2 = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .06,
                  ),
                  Image.asset(
                    'assets/signup.png',
                    width: 250,
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  Text(
                    'Sign up',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        fillColor: Colors.teal.withOpacity(0.2),
                        filled: true,
                        prefixIcon: Icon(Icons.person)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        fillColor: Colors.teal.withOpacity(0.2),
                        filled: true,
                        prefixIcon: Icon(Icons.email)),
                    // validator: (value) {
                    //   return value!.isEmpty ? 'Enter Email' : null;
                    // },

                  ),
                  SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    // showCursor: true,
                    obscureText: isSecured1,
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
                            isSecured1=!isSecured1;
                          });
                        },
                        icon: Icon(isSecured1?Icons.visibility_off: Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'retype your password';
                      }
                      return null;
                    },
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
                            isSecured2=!isSecured2;
                          });
                        },
                        icon: Icon(isSecured2?Icons.visibility_off: Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: MaterialButton(
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        SignUp(
                            nameController.text.toString(),
                            emailController.text.toString(),
                            passwordController.text.toString(),
                            c_passwordController.text.toString());
                        if (_formKey.currentState!.validate() &&
                            passwordController.text ==c_passwordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('SignUp Successfully',style: TextStyle(fontSize: 18.0,color: Colors.white),
                            ),
                              backgroundColor: Colors.teal.shade700,),);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        }else {
                          // print('Passwords do not match');
                          show_Simple_Snackbar(context);
                        }
                        if (_formKey.currentState!.validate()) {
                          print('Signup submitted');
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          },
                          child: Text("Login", style: TextStyle(color: Colors
                              .teal),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void show_Simple_Snackbar(BuildContext context) {
    Flushbar(
      backgroundColor: Colors.teal.shade700,
      duration: Duration(seconds: 3),
      message: "Password Mismatch. Please enter Correct Password!",
    )..show(context);
  }
}

