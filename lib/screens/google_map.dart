import 'package:urban_restaurant/style/colors.dart';

import 'package:urban_restaurant/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../providers/fetch_and_post.dart';

class GoogleMapScreen extends StatefulWidget {
  final double? latitude, longitude;
  final String? restaurantName;
  const GoogleMapScreen(
      {Key? key,
      required this.latitude,
      required this.longitude,
      this.restaurantName})
      : super(key: key);

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  // static const LatLng _center = LatLng(8.9806, 38.7578);
  String googleApikey = "AIzaSyCCT6MWoYFOymnKTRMBmkl6QIzRdWkEPKI";
  String location = "Search Location";
  // LatLng _lastMapPosition = _center;
  GoogleMapController? mapController;
  MapType _currentMapType = MapType.hybrid;
  final markers = <MarkerId, Marker>{};
  late LatLng pickedLocation;
  double? pickedLocLat, pickedLocLon;
  Location userLocation = Location();
  // bool activeButtons = true;

  @override
  void initState() {
    if (widget.restaurantName != null) {
      initialLocation();
    } else {
      currentLocation();
    }
    super.initState();
    // currentLocation();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

  void currentLocation() async {
    removeMarkers();
    Provider.of<Fetch>(context, listen: false).getCurrentLocation();
    double lat = Provider.of<Fetch>(context, listen: false).userLocationLat!,
        lon = Provider.of<Fetch>(context, listen: false).userLocationLon!;

    Provider.of<Fetch>(context, listen: false).userLocationLon;
    MarkerId id = const MarkerId('currentLocation');
    var pla = lat.toStringAsFixed(3);
    var plo = lon.toStringAsFixed(3);
    setState(
      () {
        final marker = Marker(
          markerId: id,
          position: LatLng(lat, lon),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow:
              InfoWindow(title: 'Current location', snippet: '$pla, $plo'),
        );
        setState(() {
          markers[id] = marker;
          mapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(lat, lon), zoom: 17.5)));
        });
        pickedLocLat = null;
        pickedLocLon = null;
        pickedLocation = LatLng(lat, lon);
        pickedLocLat = lat;
        pickedLocLon = lon;
      },
    );
  }

  void initialLocation() {
    removeMarkers();
    MarkerId id = const MarkerId('initialLocation');
    var pla = double.parse(widget.latitude!.toStringAsFixed(3));
    var plo = double.parse(widget.longitude!.toStringAsFixed(3));
    setState(
      () {
        // activeButtons = false;
        final marker = Marker(
          markerId: id,
          position: LatLng(pla, plo),
          icon: BitmapDescriptor.defaultMarkerWithHue(70),
          infoWindow: InfoWindow(
              title: widget.restaurantName != null
                  ? '${widget.restaurantName} Location'
                  : 'Your Location',
              snippet: '$pla, $plo'),
        );
        markers[id] = marker;
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(widget.latitude!, widget.longitude!),
                zoom: 17.5)));

        pickedLocLat = null;
        pickedLocLon = null;
        pickedLocation = LatLng(widget.latitude!, widget.longitude!);
        pickedLocLat = widget.latitude!;
        pickedLocLon = widget.longitude!;
      },
    );
  }

  void selectLocation(LatLng position) {
    removeMarkers();
    MarkerId id = const MarkerId('selectedLocation');
    var pla = position.latitude.toStringAsFixed(3);
    var plo = position.longitude.toStringAsFixed(3);
    setState(
      () {
        final marker = Marker(
          markerId: id,
          position: position,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow:
              InfoWindow(title: 'Picked location', snippet: '$pla, $plo'),
        );
        setState(() {
          markers[id] = marker;
        });
        pickedLocLat = null;
        pickedLocLon = null;
        pickedLocation = position;
        pickedLocLat = position.latitude;
        pickedLocLon = position.longitude;
      },
    );
  }

  void searchedLocation(double lat, double long, String location) {
    MarkerId id = const MarkerId('searchedMarker');
    setState(() {
      // activeButtons = false;
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: 17.5)));
      final marker = Marker(
        markerId: id,
        position: LatLng(lat, long),
        // draggable: true,
        // onDragStart: (value) {
        //   setState(() {
        //     // polylineCoordinates.clear();
        //     mapController?.animateCamera(CameraUpdate.newCameraPosition(
        //         CameraPosition(target: value, zoom: 17.5)));
        //     markers.removeWhere(
        //         (key, marker) => marker.markerId.value == "selectedLocation");
        //   });
        // },
        // onDragEnd: (value) {
        //   pickedLocLat = null;
        //   pickedLocLon = null;
        //   pickedLocLat = value.latitude;
        //   pickedLocLon = value.longitude;
        //   setState(() {
        //     // polylineCoordinates.clear();
        //     // drawPolyline(lat, lang, valLat, valLon);
        //     mapController?.animateCamera(CameraUpdate.newCameraPosition(
        //         CameraPosition(target: value, zoom: 16.0)));
        //   });
        // },
        icon: BitmapDescriptor.defaultMarkerWithHue(333),
        infoWindow: InfoWindow(
          title: location,
          snippet: '$lat, $long',
        ),
      );
      setState(() {
        markers[id] = marker;
      });
    });

    pickedLocLat = null;
    pickedLocLon = null;
    pickedLocation = LatLng(lat, long);
    pickedLocLat = lat;
    pickedLocLon = long;
    // Timer(const Duration(seconds: 3), () {
    //   setState(() {
    //     // activeButtons = true;
    //   });
    // });
  }

  void removeMarkers() {
    markers.removeWhere(
        (key, marker) => marker.markerId.value == "selectedLocation");
    markers.removeWhere(
        (key, marker) => marker.markerId.value == "currentLocation");
    markers.removeWhere(
        (key, marker) => marker.markerId.value == "searchedMarker");
    markers.removeWhere(
        (key, marker) => marker.markerId.value == "initialLocation");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        leading: const Row(
          children: [
            SizedBox(
              width: 5,
            ),
            CircleAvatar(
              backgroundColor: AppColors.black,
              child: BackButton(),
            ),
          ],
        ),
        title: InkWell(
            onTap: () async {
              var place = await PlacesAutocomplete.show(
                  // radius: 100,
                  context: context,
                  apiKey: googleApikey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  region: 'et',
                  components: [
                    places.Component(places.Component.country, 'et')
                  ],
                  //google_map_webservice package
                  onError: (err) {});

              if (place != null) {
                setState(() {
                  location = place.description.toString();
                });

                //form google_maps_webservice package
                final plist = places.GoogleMapsPlaces(
                  apiKey: googleApikey,
                  apiHeaders: await const GoogleApiHeaders().getHeaders(),
                  //from google_api_headers package
                );

                String placeid = place.placeId ?? "0";
                final detail = await plist.getDetailsByPlaceId(placeid);
                final geometry = detail.result.geometry!;
                final lat = geometry.location.lat;
                final lang = geometry.location.lng;

                removeMarkers();
                searchedLocation(lat, lang, location);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                child: Container(
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width * 1,
                    child: ListTile(
                      title: TitleFont(
                          text: location,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          size: 15),
                      trailing: const Icon(Icons.search),
                      // trailing: IconButton(onPressed: , icon: Icon(Icons.search)),
                      dense: true,
                    )),
              ),
            )),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  widget.latitude!,
                  widget
                      .longitude!), // need to change camera position to current location if registering or restaurant location if editing
              zoom: 16.5,
            ),
            markers: Set<Marker>.of(markers.values),
            // myLocationEnabled: true,
            mapType: _currentMapType,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: selectLocation,
            // onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18, right: 16, bottom: 16, top: 140),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: 'mapType',
                    foregroundColor: AppColors.white,
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton(
                    heroTag: 'currentLocation',
                    foregroundColor: AppColors.white,
                    onPressed: currentLocation,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.pin_drop, size: 36.0),
                  ),
                  if (widget.restaurantName != null)
                    const SizedBox(height: 16.0),
                  if (widget.restaurantName != null)
                    FloatingActionButton(
                      heroTag: 'restaurant',
                      foregroundColor: AppColors.white,
                      onPressed: initialLocation,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.restaurant, size: 36.0),
                    ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton(
                    heroTag: 'check',
                    foregroundColor: AppColors.white,
                    onPressed: () {
                      LatLng latLng = LatLng(pickedLocLat!, pickedLocLon!);
                      Navigator.pop(context, latLng);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.check, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
          // Positioned(
          //     child: )
        ],
      ),
    );
  }
}
