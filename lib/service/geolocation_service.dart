import 'package:geolocator/geolocator.dart';

class GeolocationService {
  get permission async => Geolocator.checkPermission();

  Future<LocationPermission> permissionStatus() async {
    return await Geolocator.checkPermission();
  }

 Future<Position> getCordinates() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }
}
