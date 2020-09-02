import 'package:flutter/material.dart';
import '../common/global_colors.dart';
import '../common/Collaboratorlist.dart';

List<List<String>> allactivityList;
List<String> activityNames;
String selectedActivity;

class CollabratorList extends StatefulWidget {
  @override
  _CollabratorListState createState() => _CollabratorListState();
}

class _CollabratorListState extends State<CollabratorList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            onPressed: () {
              Navigator.pop(context, {
                'selected': selectedActivity,
                'activityList': activityNames
              });
            },
            child: Text(
              "",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        title: Text(
          "All Collaborators",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 1.0,
        centerTitle: true,
        backgroundColor: Color(primary),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ListView.builder(
            itemCount: CollabrationList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => Details(
//                          imgUrl: imgUrl,
//                          placeName: title,
//                          rating: rating,
//                        )));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      color: Color(0xffE9F4F9),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                        child: Image.asset(
                          CollabrationList[index].imageUrl,
                          height: 80,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              CollabrationList[index].text,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff4E6059)),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              CollabrationList[index].text,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff89A097)),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "200",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff4E6059)),
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 10, right: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff139157)),
                          child: Column(
                            children: [
                              Text(
                                CollabrationList[index].secondaryText,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
