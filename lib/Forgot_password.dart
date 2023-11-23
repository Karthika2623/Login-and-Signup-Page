import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Otp_verification.dart';


class ForgotPasswordPage extends StatefulWidget {


  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  bool _isSecured=true;
  final _formKey=GlobalKey<FormState>();
  TextEditingController emailController=TextEditingController();

  void Forgot(String email)async{
    try{
      Response response=await post(
          Uri.parse('https://vinsupinfotech.com/FMS/public/api/forgot'),
          body: {
            'email':email,
          }) ;
      if(response.statusCode==200){
        // var data=jsonDecode(response.body.toString());
        // print(data['token']);
        // print('Forgot  succssfully');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => OTPVerifi()),);
      }
      else{
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title:  Text("Alert"),
            content:  Text("Please Enter Correct Email"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  child:  Text("okay"),
                ),
              ),
            ],
          ),
        );
        // print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade400,
        title: Text(
          'Forgot Password',style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black38,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(top: 60, left: 40, right: 40),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: 270,
                          height: 290,
                          child: Image.asset("assets/forgot.jpg"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Text('Dont worry I will help you recovery your password!..',
                    style: TextStyle(
                      fontSize: 20.0,color: Colors.teal,fontWeight: FontWeight.bold
                  ),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email'
                              : null,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            fillColor: Colors.teal,
                            hintText: 'Enter Mail',
                            prefixIcon: Icon(Icons.mail,color: Colors.teal.shade400),
                            suffixIcon: IconButton(
                              onPressed: () {
                                Forgot(emailController.text.toString());
                                if(_formKey.currentState!.validate()) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => OTPVerifi()),);
                                  print('Form Submitted');
                                }

                              },
                              icon: Icon(_isSecured?Icons.send_sharp: Icons.send,color: Colors.teal.shade400,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}