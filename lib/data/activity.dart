//import 'package:flutter/material.dart';
//
//List<HorizontalList> Hlist = new List<HorizontalList>();
//
////HorizontalList(imagesUrl: 'bc',title:  'hhj');
//class HorizontalList extends StatelessWidget {
//  String imagesUrl;
//  String title;
//  HorizontalList({this.imagesUrl, this.title});
//
//  void ChooseActivtiy(String Url, String Caption) {
//    HorizontalList ListObj = new HorizontalList();
//
//    Hlist.add(ListObj);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      height: 100,
//      child: ListView(
//        scrollDirection: Axis.horizontal,
//        children: <Widget>[
//          for (int i = 0; i < Hlist.length; i++)
//            DisplayList(
//              image_Location: Hlist[i].imagesUrl,
//              image_title: Hlist[i].title,
//            ),
//        ],
//      ),
//    );
//  }
//}
//
//class DisplayList extends StatelessWidget {
//  final String image_Location;
//  final String image_title;
//
//  DisplayList({this.image_Location, this.image_title});
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.all(2.0),
//      child: Container(
//        width: 100,
//        child: ListTile(
//          title: Image.asset(
//            image_Location,
//            width: 100,
//            height: 100,
//          ),
//          subtitle: Container(
//            alignment: Alignment.topCenter,
//            child: Text(
//              image_title,
//              style: TextStyle(
//                fontSize: 13,
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class ActivityList extends StatelessWidget {
//  String dbimageUrl;
//  String dbtitle;
//
