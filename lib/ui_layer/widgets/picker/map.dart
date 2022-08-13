import 'dart:developer';

import 'package:driver/ui_layer/helpers/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert';
import 'package:location/location.dart' as lc;
import 'address_result.dart';

class MapScreen extends StatefulWidget {
  final Widget pinWidget;
  final String apiKey;
  final LatLng initialLocation;
  final String appBarTitle;
  final String searchHint;
  final String addressTitle;
  final String confirmButtonText;
  final String language;
  final String country;
  final String addressPlaceHolder;
  final Color confirmButtonColor;
  final Color pinColor;
  final Color confirmButtonTextColor;
  const MapScreen(
      {Key? key,
      required this.apiKey,
      required this.appBarTitle,
      required this.searchHint,
      required this.addressTitle,
      required this.confirmButtonText,
      required this.language,
      this.country = "",
      required this.confirmButtonColor,
      required this.pinColor,
      required this.confirmButtonTextColor,
      required this.addressPlaceHolder,
      required this.pinWidget,
      required this.initialLocation})
      : super(key: key);
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  bool loading = false;
  String _currentAddress = "";
  LatLng? _latLng;
  String _shortName = "";
  CameraPosition? _kGooglePlex;

  CameraPosition cameraPosition(LatLng target) => CameraPosition(
      bearing: 192.8334901395799,
      target: target,
      tilt: 59.440717697143555,
      zoom: 14.4746);

  getAddress(LatLng? location) async {
    try {
      final endpoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}'
          '&region=eg&country=egypt&key=${widget.apiKey}&language=${widget.language}';

      final response = jsonDecode((await http.get(
        Uri.parse(endpoint),
      ))
          .body);
      setState(() {
        _currentAddress = response['results'][0]['formatted_address'];
        _shortName =
            response['results'][0]['address_components'][1]['long_name'];
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _latLng = widget.initialLocation;
    _kGooglePlex = CameraPosition(
      target: widget.initialLocation,
      zoom: 14.4746,
    );
    // moveToCurrent();
  }

  Future<void> moveToCurrent() async {
    final lc.Location location = lc.Location();

    bool serviceEnabled;
    lc.PermissionStatus permissionGranted;
    lc.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == lc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != lc.PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    log(locationData.latitude.toString());
    if (locationData.latitude != null) {
      log("not true at all");
      CameraPosition cPosition = CameraPosition(
        zoom: 14.4746,
        target: LatLng(locationData.latitude!, locationData.longitude!),
      );

      controller
          .animateCamera(CameraUpdate.newCameraPosition(cPosition))
          .then((value) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex!,
              myLocationButtonEnabled: false,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              zoomGesturesEnabled: true,
              onCameraMoveStarted: () {
                setState(() {
                  loading = true;
                });
              },
              onCameraMove: (p) {
                _latLng = LatLng(p.target.latitude, p.target.longitude);
              },
              onCameraIdle: () async {
                getAddress(_latLng);
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                Future.delayed(const Duration(seconds: 2)).then((value) {
                  moveToCurrent();
                });
              },
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          widget.addressTitle,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          _shortName,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          _currentAddress == ""
                              ? widget.addressPlaceHolder
                              : _currentAddress,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (!loading)
                          GestureDetector(
                            onTap: () {
                              AddressResult addressResult = AddressResult(
                                  latlng: _latLng!, address: _currentAddress);
                              Navigator.pop(context, addressResult);
                            },
                            child: SizedBox(
                              height: 50,
                              child: Card(
                                color: kDefaultColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                child: Center(
                                  child: Text(
                                    widget.confirmButtonText,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 10,
              right: 10,
              child: GestureDetector(
                onTap: () async {
                  // searchPlace();
                  var result = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => SearchPage(
                        language: widget.language,
                        apiKey: widget.apiKey,
                        searchPlaceHolder: widget.searchHint,
                      ),
                    ),
                  );
                  if (result != null) {
                    final location = await getPlace(result);
                    CameraPosition cPosition = CameraPosition(
                      zoom: 14.4746,
                      target: LatLng(double.parse(location['lat'].toString()),
                          double.parse(location['lng'].toString())),
                    );
                    final GoogleMapController controller =
                        await _controller.future;
                    controller
                        .animateCamera(
                            CameraUpdate.newCameraPosition(cPosition))
                        .then((value) {});
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () async {
                          final lc.Location location = lc.Location();

                          bool serviceEnabled;
                          lc.PermissionStatus permissionGranted;
                          lc.LocationData locationData;

                          serviceEnabled = await location.serviceEnabled();
                          if (!serviceEnabled) {
                            serviceEnabled = await location.requestService();
                            if (!serviceEnabled) {
                              return;
                            }
                          }

                          permissionGranted = await location.hasPermission();
                          if (permissionGranted == lc.PermissionStatus.denied) {
                            permissionGranted =
                                await location.requestPermission();
                            if (permissionGranted !=
                                lc.PermissionStatus.granted) {
                              return;
                            }
                          }

                          locationData = await location.getLocation();
                          final GoogleMapController controller =
                              await _controller.future;
                          log(locationData.latitude.toString());
                          if (locationData.latitude != null) {
                            log("not true at all");
                            CameraPosition cPosition = CameraPosition(
                              zoom: 14.4746,
                              target: LatLng(locationData.latitude!,
                                  locationData.longitude!),
                            );

                            controller
                                .animateCamera(
                                    CameraUpdate.newCameraPosition(cPosition))
                                .then((value) {});
                          } else {
                            log(" true all way");

                            CameraPosition cPosition = CameraPosition(
                              zoom: 14.4746,
                              target: widget.initialLocation,
                            );

                            controller
                                .animateCamera(
                                    CameraUpdate.newCameraPosition(cPosition))
                                .then((value) {});
                          }
                        },
                        icon: const Icon(
                          Icons.my_location,
                          color: Color(0xffFFCA27),
                        ),
                        iconSize: 20,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 90,
                      height: 80,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      child: Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 18),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.searchHint,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: widget.pinWidget)
          ],
        ),
      ),
    );
  }

  getPlace(placeId) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request =
        '$baseURL?place_id=$placeId&key=${widget.apiKey}&language=${widget.language}&region=eg';
    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      return res['result']['geometry']['location'];
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}

class SearchPage extends StatefulWidget {
  final String language;
  final String apiKey;
  final String searchPlaceHolder;
  const SearchPage(
      {Key? key,
      required this.language,
      required this.apiKey,
      required this.searchPlaceHolder})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  var uuid = const Uuid();
  var _sessionToken;
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=${widget.apiKey}&sessiontoken=$_sessionToken&language=ar&region=eg';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Card(
              color: Colors.white.withOpacity(0.7),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 18,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: widget.searchPlaceHolder,
                                  hintStyle:
                                      const TextStyle(color: Colors.grey)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: _placeList.length,
              itemBuilder: (ctx, i) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, _placeList[i]["place_id"]);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.location_pin,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Text(
                                  _placeList[i]["description"],
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        ],
                      ),
                      const Divider()
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}

showGoogleMapLocationPicker(
    {required BuildContext context,
    required Widget pinWidget,
    required String apiKey,
    required String appBarTitle,
    required String searchHint,
    required String addressTitle,
    required LatLng initialLocation,
    required String confirmButtonText,
    required String language,
    required String country,
    required String addressPlaceHolder,
    required Color confirmButtonColor,
    required Color pinColor,
    required Color confirmButtonTextColor}) async {
  final pickedLocation = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => MapScreen(
              apiKey: apiKey,
              pinWidget: pinWidget,
              appBarTitle: appBarTitle,
              searchHint: searchHint,
              addressTitle: addressTitle,
              confirmButtonText: confirmButtonText,
              language: language,
              confirmButtonColor: confirmButtonColor,
              pinColor: pinColor,
              confirmButtonTextColor: confirmButtonTextColor,
              addressPlaceHolder: addressPlaceHolder,
              initialLocation: initialLocation,
            )),
  );
  return pickedLocation;
}
