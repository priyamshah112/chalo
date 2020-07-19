import 'package:chaloapp/common/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black26),
            height: 400,
            child: Image.asset("images/post/1.png", fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Colabrator Name",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                        fontFamily: heading,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: Badge(
                    text: "8.4/85 reviews",
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(25.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconText(
                        text: "Supreme Business Park, Supreme City",
                        icon: Icons.location_on,
                      ),
                      IconText(
                        text: "Mon to Sun - 6am to 7pm",
                        icon: Icons.access_time,
                      ),
                      IconText(
                        text: "www.exmaple.com",
                        icon: Icons.link,
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          color: Color(primary),
                          textColor: Colors.white,
                          child: Text(
                            "Call Now",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: bodyText,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => AssetGiffyDialog(
//                                      key: Key("Asset"),
                                      image: Image.asset(
                                        'images/coin.gif',
                                        fit: BoxFit.contain,
                                      ),
                                      title: Text(
                                        'Congratulations!!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      entryAnimation:
                                          EntryAnimation.BOTTOM_RIGHT,
                                      description: Text(
                                        'This is a men wearing jackets dialog box. This library helps you easily create fancy giffy dialog.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(),
                                      ),
//                                      onOkButtonPressed: null,
                                    ));
                          },
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        "Description".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                          color: Color(primary),
                          fontFamily: bodyText,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Ratione architecto autem quasi nisi iusto eius ex dolorum velit! Atque, veniam! Atque incidunt laudantium eveniet sint quod harum facere numquam molestias?",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                          fontFamily: bodyText,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Ratione architecto autem quasi nisi iusto eius ex dolorum velit! Atque, veniam! Atque incidunt laudantium eveniet sint quod harum facere numquam molestias?",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.0,
                          fontFamily: bodyText,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "About Venue".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                          color: Color(primary),
                          fontFamily: bodyText,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Wrap(
                        runSpacing: 7.0,
                        spacing: 5.0,
                        children: <Widget>[
                          Badge(
                            text: "Parking",
                            color: Color(primary),
                            bgcolor: Colors.white,
                          ),
                          Badge(
                            text: "Changing Room",
                            color: Color(primary),
                            bgcolor: Colors.white,
                          ),
                          Badge(
                            text: "Drinking Water",
                            color: Color(primary),
                            bgcolor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class IconText extends StatelessWidget {
  final String text;
  final IconData icon;

  const IconText({Key key, this.text, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(height: 10.0),
        Icon(
          icon,
          size: 17,
          color: Color(secondary),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontFamily: bodyText,
          ),
        ),
      ],
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color color, bgcolor, borderColor;

  const Badge({Key key, this.text, this.color, this.bgcolor, this.borderColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: bgcolor == null ? Color(primary) : bgcolor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: borderColor == null ? Color(primary) : borderColor,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == null ? Color(secondary) : color,
          fontSize: 13.0,
          fontFamily: bodyText,
        ),
      ),
    );
  }
}
