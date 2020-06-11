import 'package:chaloapp/Boradcast/CollabrationList.dart';
import 'package:chaloapp/common/Collaboratorlist.dart';
import 'package:chaloapp/common/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CollabrationCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Recommandation',
              style: TextStyle(
                fontSize: 15,
                color: Color(primary),
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CollabratorList()));
              },
              child: Text(
                'See All',
                style: TextStyle(
                  color: Color(primary),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: CollabrationList.length,
            padding: EdgeInsets.only(right: 16.0),
//            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, int index) {
              return GestureDetector(
                onTap: () => print('card clicked'),
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        child: Image.asset(
                          CollabrationList[index].imageUrl,
                          height: 80,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        CollabrationList[index].text,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${CollabrationList[index].secondaryText} Reviews",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
