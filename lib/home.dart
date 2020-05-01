import 'package:chaloapp/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: FlutterMap(
              options: new MapOptions(
                  center: new LatLng(35.22, -101.83), minZoom: 10.0),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/abdulquadir123/ck9kbtkmm0ngc1ipif8vq6qbv/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw",
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw',
                      'id': 'mapbox.mapbox-streets-v8'
                    }),
              ],
            ),

//            appBar: AppBar(
//              automaticallyImplyLeading: false,
//              title: Text(
//                "",
//                style: TextStyle(
//                  color: Color(primary),
//                ),
//              ),
//              actions: <Widget>[
//                CircleAvatar(
//                  child: ClipOval(
//                    child: Image.asset(
//                      'images/bgcover.jpg',
//                      height: 40,
//                      width: 50,
//                      fit: BoxFit.cover,
//                    ),
//                  ),
//                ),
//                SizedBox(
//                  width: 20,
//                ),
//              ],
//              elevation: 0.0,
//              backgroundColor: Colors.transparent,
//            ),
          ),
          Positioned(
            top: 60.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 10,
                      spreadRadius: 2)
                ],
              ),
              child: TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 15, bottom: 5, top: 7),
                    width: 40,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.asset(
                            'images/bgcover.jpg',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  hintText: "Search Users",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 11.0, top: 5.0),
                ),
              ),
            ),
          ),
        ],
      ),
//      appBar: AppBar(
//        automaticallyImplyLeading: false,
//        title: Text(
//          "",
//          style: TextStyle(
//            color: Color(primary),
//          ),
//        ),
//        actions: <Widget>[
//          CircleAvatar(
//            child: ClipOval(
//              child: Image.asset(
//                'images/bgcover.jpg',
//                height: 40,
//                width: 50,
//                fit: BoxFit.cover,
//              ),
//            ),
//          ),
//          SizedBox(
//            width: 20,
//          ),
//        ],
//        elevation: 0.0,
//        backgroundColor: Colors.transparent,
//      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        color: Colors.white,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 25,
          backgroundColor: Colors.white,
          unselectedItemColor: Color(secondary),
          fixedColor: Color(primary),
          elevation: 0.0,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text(""),
              icon: Icon(
                FontAwesomeIcons.mapMarkerAlt,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(
                FontAwesomeIcons.list,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(
                Icons.wifi_tethering,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(
                FontAwesomeIcons.commentDots,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(
                Icons.dashboard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
