import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
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
  String mapSearchValue = null;
  String mapSearchValue1 = null;
  bool istap = false;
  Position position1;
  TextEditingController locationval = TextEditingController();
  getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      position1 = position;
      mapSearchValue = first.addressLine;
    });
    print("${first.featureName} : ${first.addressLine}");
  }
//  void getLocation() async {
//    Position pos = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    print(pos);
//    var addresses = await Geocoder.local
//        .findAddressesFromCoordinates(Coordinates(pos.latitude, pos.longitude));
//    var first = addresses.first;
//    print("${first.featureName} : ${first.addressLine}");
//    setState(() {
//      position = pos;
//      mapSearchValue = pos.latitude.toString();
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_location),
        onPressed: () {
          getLocation();
          setState(() {});
        },
      ),
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

            locationval.value = TextEditingValue(text: mapSearchValue);
            locationval.selection = TextSelection.fromPosition(
                TextPosition(offset: locationval.text.length));

            setState(() {});
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              String temp = mapSearchValue;
              mapSearchValue = null;
              Navigator.pop(context, temp != null ? temp : mapSearchValue1);
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
//        backgroundColor: Color(),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: FlutterMap(
              options: new MapOptions(
                  interactive: true,
                  center: new LatLng(
                      position1 == null ? 19.0760 : position1.latitude,
                      position1 == null ? 72.8777 : position1.longitude),
                  minZoom: 10.0),
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
                      point: new LatLng(
                          position1 == null ? 19.0760 : position1.latitude,
                          position1 == null ? 72.8777 : position1.longitude),
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
            child: mapSearchValue != null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      height: 53,
                      padding: EdgeInsets.only(left: 0, right: 0, top: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 10,
                              spreadRadius: 2)
                        ],
                      ),
                      child: Container(
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  onTap: () {
                                    if (mapSearchValue != null) {
                                      locationval.value = TextEditingValue(
                                          text: mapSearchValue);
                                    }
                                  },
                                  controller: locationval,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: mapSearchValue,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 13.0),
                                  ),
//                                    enabled: false,
                                  cursorColor: Colors.black,
//                                    controller: _textEditingController,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      mapSearchValue = null;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : MapBoxPlaceSearchWidget(
                    apiKey: kApiKey,
//
                    searchHint: 'Search here',
                    limit: 15,

                    onSelected: (place) {
                      setState(() {
                        MapBoxPlace temp = place;
                        mapSearchValue1 = temp.placeName;
                        print("search value val : ${mapSearchValue1}");

                        print("gps val : ${mapSearchValue}");
                      });
                    },
                    context: context,
                  ),
          )
        ],
      ),
    );
  }
}
