import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Activites/Activity_Detail.dart';
import 'common/global_colors.dart';
import 'home/home.dart';
import 'services/dynamicLinking.dart';
import 'data/data.dart';
import 'authentication/login.dart';
import 'services/AuthService.dart';
import 'data/User.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
            primaryColor: Color(primary),
            accentColor: Color(primary),
            cursorColor: Color(primary),
            primarySwatch: Colors.teal),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> _showOnBoarding(SharedPreferences prefs) async {
    prefs.containsKey('onBoarding')
        ? prefs.setBool('onBoarding', false)
        : prefs.setBool('onBoarding', true);
    if (!prefs.containsKey('verified')) prefs.setBool('verified', false);
    return prefs.getBool('onBoarding');
  }

  void checkUser(DocumentReference ref) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    _showOnBoarding(prefs).then((show) async {
      if (show)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OnBoarding()));
      else {
        DocumentSnapshot doc;
        bool verified = prefs.getBool('verified');
        bool profileSetupCompleted = prefs.getBool('profile_setup') ?? false;
        bool loggedIn = await AuthService().isUserLoggedIn();
        if (loggedIn && verified && profileSetupCompleted ) {
          await CurrentUser.initialize(prefs);
          if (ref != null) doc = await ref.get();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ref != null
                      ? ActivityLink(activity: doc)
                      : MainHome()));
        } else
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    configOneSignal();
    DynamicLinkService.retrieveDynamicLink(context)
        .then((ref) => checkUser(ref));
  }

  Future<void> configOneSignal() async {
    // //Remove this method to stop OneSignal Debugging
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.init("cca66cd9-2af7-478f-b9d0-9b798db42679",
        iOSSettings: {
          OSiOSSettings.autoPrompt: false,
          OSiOSSettings.inAppLaunchUrl: true
        });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    // await OneSignal.shared
    //     .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.0,
                    child: Icon(
                      Icons.directions_bike,
                      size: 50.0,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Chalo!!!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
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
}

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<SliderModel> slide = new List<SliderModel>();
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);
  @override
  void initState() {
    slide = getSlide();
    print('inside onboarding');
    super.initState();
  }

  Widget pageDot(bool isCurrent) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrent ? 10.0 : 6.0,
      width: isCurrent ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrent ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          controller: pageController,
          itemCount: slide.length,
          onPageChanged: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          itemBuilder: (context, index) {
            return SliderTile(
              img: slide[index].setImagePath1(),
              title: slide[index].setTitle1(),
              des: slide[index].setDes1(),
            );
          }),
      bottomSheet: currentIndex != slide.length - 1
          ? Container(
              height: Platform.isIOS ? 70 : 60,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pageController.animateToPage(slide.length - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: Text('SKIP'),
                  ),
                  Row(
                    children: <Widget>[
                      for (int i = 0; i < slide.length; i++)
                        currentIndex == i ? pageDot(true) : pageDot(false)
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      pageController.animateToPage(currentIndex + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: Text('NEXT'),
                  ),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              height: Platform.isIOS ? 70 : 60,
              child: FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
    );
  }
}

class SliderTile extends StatelessWidget {
  final String img, title, des;
  SliderTile({this.img, this.title, this.des});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffC9DEEE),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                img,
                width: 350.0,
                height: 350.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                des,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
