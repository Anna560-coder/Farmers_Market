import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
          'Location services are disabled. Please enable location services in your device settings.',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
            'Location permissions are denied. Please allow location access in your device settings.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Please enable location access in your device settings.',
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
          timeLimit: Duration(seconds: 15),
        ),
      );

      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  static Future<String?> getAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        List<String> addressParts = [];

        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        return addressParts.isNotEmpty
            ? addressParts.join(', ')
            : 'Unknown Location';
      }
      return 'Unknown Location';
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return 'Unknown Location';
    }
  }

  static Future<Position?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations[0];
        return Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
      return null;
    } catch (e) {
      print('Error getting coordinates from address: $e');
      return null;
    }
  }

  static Future<String?> getCurrentLocationAddress() async {
    try {
      Position? position = await getCurrentLocation();
      if (position != null) {
        final address = await getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (address != null && address != 'Unknown Location') {
          print('GPS Location detected: $address');
          return address;
        }
      }

      final ipLocation = await _getLocationFromIP();
      if (ipLocation != null) {
        print('IP Location detected: $ipLocation');
        return ipLocation;
      }

      return null;
    } catch (e) {
      print('Error getting current location address: $e');

      try {
        final ipLocation = await _getLocationFromIP();
        if (ipLocation != null) {
          print('IP Location detected (fallback): $ipLocation');
          return ipLocation;
        }
        return null;
      } catch (ipError) {
        print('Error getting location from IP: $ipError');
        return null;
      }
    }
  }

  static Future<String?> getAccurateLocationAddress() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();

        await Future.delayed(const Duration(seconds: 2));
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      }

      if (serviceEnabled) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 0,
            timeLimit: Duration(seconds: 20),
          ),
        );

        final address = await getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (address != 'Unknown Location') {
          print('Accurate GPS Location detected: $address');
          return address;
        }
      }

      return await _getLocationFromIP();
    } catch (e) {
      print('Error getting accurate location: $e');
      return await _getLocationFromIP();
    }
  }

  static Future<String?> _getLocationFromIP() async {
    try {
      final services = [
        'https://ipapi.co/json/',
        'https://ipinfo.io/json',
        'http://ip-api.com/json/',
      ];

      for (String serviceUrl in services) {
        try {
          final response = await http
              .get(
                Uri.parse(serviceUrl),
                headers: {'Accept': 'application/json'},
              )
              .timeout(const Duration(seconds: 10));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            String? city, region, country;

            if (serviceUrl.contains('ip-api.com')) {
              if (data['status'] == 'success') {
                city = data['city'] ?? '';
                region = data['regionName'] ?? '';
                country = data['country'] ?? '';
              }
            } else if (serviceUrl.contains('ipapi.co')) {
              city = data['city'] ?? '';
              region = data['region'] ?? '';
              country = data['country_name'] ?? '';
            } else if (serviceUrl.contains('ipinfo.io')) {
              city = data['city'] ?? '';
              region = data['region'] ?? '';
              country = data['country'] ?? '';
            }

            if (city != null && city.isNotEmpty) {
              List<String> addressParts = [];
              if (city.isNotEmpty) addressParts.add(city);
              if (region != null && region.isNotEmpty) addressParts.add(region);
              if (country != null && country.isNotEmpty)
                addressParts.add(country);

              final location = addressParts.join(', ');
              print('IP Location detected: $location from $serviceUrl');

              if (country != null &&
                  country.toLowerCase().contains('south africa')) {
                if (city.toLowerCase().contains('johannesburg') ||
                    city.toLowerCase().contains('cape town') ||
                    city.toLowerCase().contains('durban')) {
                  print('Detected major city, might be ISP server location');
                }
              }

              return location;
            }
          }
        } catch (e) {
          print('Error with service $serviceUrl: $e');
          continue;
        }
      }

      return null;
    } catch (e) {
      print('Error getting location from IP: $e');
      return null;
    }
  }

  static String getDefaultSouthAfricanLocation() {
    return 'Bloemfontein, Free State, South Africa';
  }

  static Future<String?> getSouthAfricanLocation() async {
    try {
      Position? position = await getCurrentLocation();
      if (position != null) {
        final address = await getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (address != null && address != 'Unknown Location') {
          print('GPS Location detected: $address');
          return address;
        }
      }

      final ipLocation = await _getLocationFromIP();
      if (ipLocation != null) {
        print('IP Location detected: $ipLocation');

        if (ipLocation.toLowerCase().contains('south africa')) {
          if (ipLocation.toLowerCase().contains('johannesburg') ||
              ipLocation.toLowerCase().contains('cape town') ||
              ipLocation.toLowerCase().contains('durban')) {
            print('Detected major city, might be ISP server location');

            return getDefaultSouthAfricanLocation();
          }
          return ipLocation;
        }
      }

      return getDefaultSouthAfricanLocation();
    } catch (e) {
      print('Error getting South African location: $e');
      return getDefaultSouthAfricanLocation();
    }
  }

  static Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  static Future<Map<String, dynamic>> getLocationServiceStatus() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      return {
        'serviceEnabled': serviceEnabled,
        'permission': permission.toString(),
        'hasPermission':
            permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'serviceEnabled': false,
        'permission': 'unknown',
        'hasPermission': false,
      };
    }
  }
}
