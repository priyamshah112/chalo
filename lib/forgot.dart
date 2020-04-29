import 'package:chaloapp/login.dart';
import 'package:flutter/material.dart';
import 'package:chaloapp/Animation/FadeAnimation.dart';
import 'package:chaloapp/global_colors.dart';

class ForgotPage extends StatefulWidget {
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 350,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 45,
                      height: 320,
                      width: width,
                      child: FadeAnimation(
                          1,
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/forgotpass.jpg'),
                                  fit: BoxFit.fill),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimation(
                        1.5,
                        Text(
                          "Forgot Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(color1),
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              fontFamily: 'Pacifico'),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FadeAnimation(
                        1.7,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Please Enter your registered Email address. we will send you instructions to reset your password.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(secondary),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 1.0, vertical: 10.0),
                                child: TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(form1),
                                    contentPadding: const EdgeInsets.only(
                                        left: 30.0,
                                        bottom: 18.0,
                                        top: 18.0,
                                        right: 30.0),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Color(color1),
                                    ),
                                    hintText: "Email Address",
                                    hintStyle: TextStyle(
                                      color: Color(formHint),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.9,
                          Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 60),
                            child: FlatButton(
                              color: Color(text3),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60.0, vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage()),
                                );
                              },
                              child: Center(
                                child: Text(
                                  "Send",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                        2,
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomePage()),
                              );
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(
                                color: Color(secondary),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
