import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  double? longitude;
  double? latitude;
  String? city;
  String? littlecity;

  LocationHelper({this.longitude, this.latitude});

  Future<void> getLocation() async {
    loc.Location location = loc.Location();
    loc.LocationData locationData;
    bool serviceenabled = await location.serviceEnabled();
    loc.PermissionStatus permissionStatus = await location.hasPermission();
    try {
      if (serviceenabled == false) {
        serviceenabled = await location.requestService();
        if (serviceenabled == false) {
          print("sERVICE FALSE");
          return;
        }
      }
      if (permissionStatus == loc.PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != loc.PermissionStatus.granted) {
          print("pERMISSION DENIED");
          return;
        }
      }
      locationData = await location.getLocation();
      longitude = locationData.longitude!;
      latitude = locationData.latitude!;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude!, longitude!); // dikkat et
      city = placemarks[0].administrativeArea;
      littlecity = placemarks[0].subAdministrativeArea;
    } catch (e) {
      print(e);
    }
  }
}
