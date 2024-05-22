import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iseeapp2/QRCode/QRScan.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../session/SessionManager.dart';
import 'detail_dialog.dart';
import 'log_in.dart';
import 'profile_dialog.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String myLocation = '';
  List<Marker> markers = [];
  String address = '';
  final MapController mapController = MapController();
  String _username = '';
  @override
  void initState() {
    super.initState();
    _loadSession();
    print("==================vo Home page roi ne, username = " + _username);
    _requestLocationPermission();
    _getCurrentLocation();
  }
  // _loadSession() async {
  //   String? username = await SessionManager.getSession('username');
  //   if (username == null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => LogIn()),
  //     );
  //   } else {
  //     print("==================vo Home page roi ne, username = " + _username + '------------------' + username);
  //     setState(() {
  //       _username = username;
  //     });
  //   }
  // }
  _loadSession() async {
    String? username = await SessionManager.getSession('username');
    print("==================vo Home page roi ne, username = " + _username + '------------------' + username!);
    setState(() {
      _username = username ?? '';
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB1FFD9),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: AppBar(
          backgroundColor: const Color(0xFFB1FFD9),
          title: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/location.png',
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    'S',
                    style: TextStyle(
                      fontSize: 38,
                      fontFamily: 'Modak',
                      color: const Color(0xFF1EC9FF),
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black, // Màu của viền
                          offset: Offset(0, 0), // Độ lệch của viền
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'E',
                    style: TextStyle(
                      fontSize: 38,
                      fontFamily: 'Modak',
                      color: const Color(0xFFFFE712),
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black, // Màu của viền
                          offset: Offset(0, 0), // Độ lệch của viền
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'E',
                    style: TextStyle(
                      fontSize: 38,
                      fontFamily: 'Modak',
                      color: const Color(0xFF22FD45),
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black, // Màu của viền
                          offset: Offset(0, 0), // Độ lệch của viền
                        ),
                      ],                    ),
                  ),
                ],
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProfileDialog(); // Hiển thị dialog
                        },
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/avatar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // =======================================================================================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 665,
                  width: 450,
                  child: Stack(
                    children: [
                      Visibility(
                        visible: true,
                        child: FlutterMap(
                          options: MapOptions(
                            // center: routpoints[0],
                            zoom: 18,
                            onPositionChanged: (position, hasGesture) {},
                          ),
                          nonRotatedChildren: [
                            AttributionWidget.defaultWidget(
                              source: 'OpenStreetMap contributors',
                              onSourceTapped: null,
                            ),
                          ],
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.iseeapp2',
                            ),
                            PolylineLayer(
                              polylineCulling: false,
                              polylines: [
                                // Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
                              ],
                            ),
                            MarkerLayer(
                              markers: markers,
                            ),
                          ],
                          mapController: mapController,
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                mapController.move(mapController.center, mapController.zoom + 1);
                              },
                              child: Icon(Icons.add),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                mapController.move(mapController.center, mapController.zoom - 1);
                              },
                              child: Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // =======================================================================================
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: BottomAppBar(

          color: const Color(0xFFB1FFD9),
          // alignment: Alignment.bottomCenter,

          height: 100,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Ink(
                  decoration: ShapeDecoration(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DetailDialog(); // Hiển thị dialog
                        },
                      );
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/avatar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40),
                FloatingActionButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRScan()),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                    color: const Color(0xFFFFFFFF),
                  ),
                  backgroundColor: const Color(0xFF0D5E37),
                  shape: CircleBorder(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    // Kiểm tra xem đã có quyền truy cập vị trí chưa
    if (await Permission.location.isDenied) {
      // Nếu chưa, yêu cầu quyền truy cập
      await Permission.location.request();
    }
  }
  Future<void> _getCurrentLocation() async {
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        print("=============================================" + address);
        _moveToLocation(address);
      }
    }
  }
  // Hàm để lấy vị trí từ địa chỉ và di chuyển trung tâm của bản đồ đến đó
  Future<void> _moveToLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;

        // Tạo Marker mới với popup
        Marker marker = Marker(
          width: 200.0,
          height: 80.0,
          point: LatLng(latitude, longitude),
          builder: (context) => Stack(  // Use Stack for efficient layering
            children: [
              InkWell(  // Handle marker clicks
                onTap: () {
                  // Implement your on-click logic here (e.g., show info window)
                },
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 60.0,
                ),
              ),
              Positioned(  // Position text precisely within the marker
                bottom: 0.0,  // Place text at the bottom
                right: 0.0,   // Align text to the right
                child: Container(
                  padding: EdgeInsets.all(4.0),  // Add some padding around text
                  decoration: BoxDecoration(
                    color: Colors.white,  // Text background color
                    borderRadius: BorderRadius.circular(4.0),  // Rounded corners
                  ),
                  child: Text(
                    address,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10.0,  // Adjust font size as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
        );


        setState(() {
          markers.add(marker);
        });

        mapController.move(LatLng(latitude, longitude), mapController.zoom);
      } else {
        print("Không tìm thấy vị trí cho địa chỉ này.");
      }
    } catch (e) {
      print("Đã xảy ra lỗi: $e");
    }

  }
}
