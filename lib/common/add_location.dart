import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'global_colors.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_search/mapbox_search.dart';
import '../widgets/Mapbox_Search.dart';

const kApiKey =
    'pk.eyJ1IjoiYWJkdWxxdWFkaXIxMjMiLCJhIjoiY2s5a2FmNHM3MDRudTNmbHIxMXJnazljbCJ9.znqRJyK_9-nzvIoPaSrmjw';

class GetLocation extends StatefulWidget {
  GetLocation({Key key}) : super(key: key);
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  String mapSearchValue;
  bool istap = false;
  Position position = Position(latitude: null, longitude: null);
  TextEditingController locationTextController = TextEditingController();
  void getUserLocation() async {
    try {
      Position userPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates =
          new Coordinates(userPosition.latitude, userPosition.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      setState(() {
        position = userPosition;
        mapSearchValue = first.addressLine;
        isSelected = true;
        locationTextController.text = mapSearchValue;
        LatLng latlog = new LatLng(position.latitude, position.longitude);
        _mapController.move(latlog, 12);
      });
      print("${first.featureName} : ${first.addressLine}");
    } catch (e) {
      print(e.toString());
    }
  }

  void getLocation(String address) async {
    List<Address> results =
        await Geocoder.local.findAddressesFromQuery(address);
    Coordinates coordinates = results.first.coordinates;
    setState(() {
      position = Position(
          latitude: coordinates.latitude, longitude: coordinates.longitude);
      print('${coordinates.latitude} ${coordinates.longitude}');
      LatLng latlog = new LatLng(coordinates.latitude, coordinates.longitude);
      _mapController.move(latlog, 12);
    });
  }

  final _mapController = MapController();
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getUserLocation,
        child: Icon(Icons.gps_fixed),
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
            Navigator.pop(context, null);
            // locationval.value = TextEditingValue(text: mapSearchValue);
            // locationval.selection = TextSelection.fromPosition(
            //     TextPosition(offset: locationval.text.length));
            // setState(() {});
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(
                  context,
                  mapSearchValue == null
                      ? null
                      : {'location': mapSearchValue, 'position': position});
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
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: FlutterMap(
              mapController: _mapController,
              options: new MapOptions(
                  interactive: true,
                  center: new LatLng(position.latitude ?? 19.0760,
                      position.longitude ?? 72.8777),
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
                      point: new LatLng(position.latitude ?? 19.0760,
                          position.longitude ?? 72.8777),
                      builder: (ctx) => new Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.teal,
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
            child: isSelected
                ? Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black, blurRadius: 0, spreadRadius: 0)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: locationTextController,
                                onChanged: (value) => mapSearchValue = value,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            ),
                            SizedBox(width: 15),
                            GestureDetector(
                                onTap: () {
                                  setState(() => isSelected = false);
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.teal,
                                ))
                          ],
                        ),
                      ),
                    ),
                  )
                : MapBoxPlaceSearchWidget(
                    apiKey: kApiKey,
                    searchHint: 'Search here',
                    height: 500,
                    country: 'in',
                    limit: 15,
                    onSelected: (place) {
                      setState(() {
                        MapBoxPlace temp = place;
                        mapSearchValue = temp.placeName;
                        getLocation(mapSearchValue);
                        print("search value  : $mapSearchValue");
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
