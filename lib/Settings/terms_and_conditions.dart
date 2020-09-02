import 'package:flutter/material.dart';
import '../Animation/FadeAnimation.dart';
import '../common/global_colors.dart';

class TnC extends StatefulWidget {
  @override
  _TnCState createState() => _TnCState();
}

class _TnCState extends State<TnC> {
  final _formKey = GlobalKey<FormState>();
  String message;
  bool _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Terms & Conditions",
              style: TextStyle(
                color: Colors.white,
                fontFamily: bodyText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: null,
              child: Text(
                "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: bodyText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          elevation: 1.0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: FadeAnimation(
                    1.7,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Heading",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(primary),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vulputate luctus eros viverra tristique. In pharetra id purus sit amet sollicitudin. Morbi scelerisque fringilla lectus id pulvinar. Maecenas feugiat felis rutrum auctor ornare. Curabitur finibus vulputate aliquet. Nullam urna velit, commodo id posuere at, porttitor id mi. Praesent placerat, enim id posuere hendrerit, mi quam interdum nisl, at elementum tellus sem quis ipsum. Maecenas eget sapien turpis. Vestibulum ornare sodales tincidunt. Suspendisse potenti. Morbi consectetur egestas elit. Mauris quis turpis nec felis cursus sollicitudin a nec risus. Nunc in erat ut ligula pretium facilisis.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(secondary),
                            ),
                          ),
                        ],
                      ),
                    ),
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
