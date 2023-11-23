import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'Confirm_Password.dart';
import 'get_otp_res_data.dart';


class OTPVerifi extends StatefulWidget {
  static var  user_id;

  @override
  State<OTPVerifi> createState() => _OTPVerifiState();
}

class _OTPVerifiState extends State<OTPVerifi> {

  bool invalidOtp = false;
  int resendTime = 60;
  late Timer countdownTimer;


  TextEditingController emailController=TextEditingController();
  TextEditingController txt1 = TextEditingController();
  TextEditingController txt2 = TextEditingController();
  TextEditingController txt3 = TextEditingController();
  TextEditingController txt4 = TextEditingController();
  TextEditingController txt5 = TextEditingController();
  TextEditingController txt6 = TextEditingController();


  void ClearText(){
    txt1.clear();
    txt2.clear();
    txt3.clear();
    txt4.clear();
    txt5.clear();
  }
  final _formKey=GlobalKey<FormState>();


  void Verify(String email, otp) async {
    try {
      var getotpuri =  Uri.https('www.vinsupinfotech.com','/FMS/public/api/get_otp', {'email': email, 'otp': otp});
      debugPrint("${getotpuri}");
      http.Response response = await http.post(
          getotpuri
      );
      debugPrint("${response.body}");
      if (jsonDecode(response.body) == "OTP Invalid") {
        debugPrint('Failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.teal,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            content: const Text('Enter Valid Otp',
              style: TextStyle(color: Colors.white,fontSize: 19),),
            action: SnackBarAction(
              label: 'Ok',
              textColor: Colors.white,
              onPressed: () {
              },
            ),
          ),
        );
      } else {
        try{
          var jsonDecodeResponse = jsonDecode(response.body);
          GetOtpResData getOtpResData = GetOtpResData.fromJson(jsonDecodeResponse);
          if(getOtpResData.status == "OTP Valid"){
            print("Otp Verified");
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ConfirmPassword(),
              ),
            );
          }
        }
        catch(e){
          debugPrint(e.toString());
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        resendTime = resendTime - 1;
      });
      if (resendTime < 1) {
        countdownTimer.cancel();
      }
    });
  }

  stopTimer() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  String strFormatting(n) => n.toString().padLeft(2, '0');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade400,
        title: const Text('OTP Verification',style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Verification Code',
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 20),
                Text(
                  'Enter the 6 digit verification code received',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    myInputBox(context, txt1),
                    myInputBox(context, txt2),
                    myInputBox(context, txt3),
                    myInputBox(context, txt4),
                    myInputBox(context, txt5),
                    myInputBox(context, txt6)
                  ],
                ),
                SizedBox(height: 40),
        
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (txt1.text.isEmpty ||
                        txt2.text.isEmpty ||
                        txt3.text.isEmpty ||
                        txt4.text.isEmpty ||
                        txt5.text.isEmpty ||
                        txt6.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Alert",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold)),
                          content: const Text("Please Enter OTP"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Container(
                                // color: Colors.green,
                                height: 70,
                                width: 100,
                                padding: EdgeInsets.all(14),
                                child:  Text(
                                  "okay",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      print('Enter otp');
                    }
                    else {
                      final otp = (txt1.text + txt2.text + txt3.text + txt4.text + txt5.text + txt6.text);
                      Verify(emailController.text.toString(), otp.toString());
                    }
                  },
                  child: Text(
                    'Verify',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Colors.teal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget myInputBox(BuildContext context, TextEditingController controller) {
  return Container(
    height: 60,
    width: 50,
    decoration: BoxDecoration(
      border: Border.all(width: 1),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    child: TextField(
      controller: controller,
      maxLength: 1,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.text,
      style:  TextStyle(fontSize: 35),
      decoration:  InputDecoration(
        counterText: '',
      ),
      onChanged: (value) {
        if (value.length == 1) {
          FocusScope.of(context).nextFocus();
        }
      },
    ),
  );
}