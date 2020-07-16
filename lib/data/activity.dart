import 'package:flutter/material.dart';
import '../common/global_colors.dart';
import '../common/activitylist.dart';

List<List<String>> allactivityList;
List<String> activityNames;
String selectedActivity;

class ViewActivity extends StatefulWidget {
  @override
  _ViewActivityState createState() => _ViewActivityState();
}

class _ViewActivityState extends State<ViewActivity> {
  @override
  void initState() {
    super.initState();
    ActivityList.getActivityList().then((list) {
      setState(() => allactivityList = list);
      activityNames = List<String>.generate(
          allactivityList.length, (index) => allactivityList[index][1]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context,
                {'selected': selectedActivity, 'activityList': activityNames});
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
              "Done",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        title: Text(
          "All Activities",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 1.0,
        centerTitle: true,
        backgroundColor: Color(primary),
      ),
      body: allactivityList == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    crossAxisCount: 3,
                    children: allactivityList
                        .map(
                          (activity) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 3),
                            child: InkWell(
                              onTap: () {
                                if (activity[2] == 'false') {
                                  setState(() {
                                    for (var selected in allactivityList) {
                                      if (selected[2] == 'true')
                                        selected[2] = 'false';
                                    }
                                    activity[2] = 'true';
                                  });
                                  selectedActivity = activity[1];
                                } else {
                                  setState(() => activity[2] = 'false');
                                  selectedActivity = null;
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(primary),
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    color: activity[2] == 'true'
                                        ? Color(primary)
                                        : null),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Image.network(
                                        activity[0],
                                        width: 60,
                                        height: 60,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        activity[1],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(secondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList()),
              ),
            ),
    );
  }
}
