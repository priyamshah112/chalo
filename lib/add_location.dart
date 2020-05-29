import "package:chaloapp/global_colors.dart";
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:chaloapp/global_colors.dart';

const kApiKey =
    'pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw';

class GetLocation extends StatefulWidget {
  GetLocation({Key key}) : super(key: key);
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Add Location",
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Done",
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: FlutterMap(
              options: new MapOptions(
                  center: new LatLng(19.0760, 72.8777), minZoom: 10.0),
              layers: [
                new TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/abdulquadir123/ck9kbtkmm0ngc1ipif8vq6qbv/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw',
                    'id': 'mapbox.mapbox-streets-v8'
                  },
                ),
                new MarkerLayerOptions(
                  markers: [
                    new Marker(
                      width: 80.0,
                      height: 80.0,
                      point: new LatLng(19.0760, 72.8777),
                      builder: (ctx) => new Container(
                        child: Icon(
                          Icons.location_on,
//                          color: Color(secondary),
                          size: 45.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 20.0,
            left: 15.0,
            right: 15.0,
            child: MapBoxPlaceSearchWidget(
              apiKey: kApiKey,
              searchHint: 'Search Place',
              limit: 15,
              onSelected: (place) {},
              context: context,
            ),
          )
        ],
      ),
    );
  }
}
