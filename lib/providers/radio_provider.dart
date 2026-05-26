import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:app/models/radio_station.dart';

class RadioProvider extends ChangeNotifier {
  List<RadioStation> _stations = [];
  RadioStation? _currentStation;

  List<RadioStation> get stations => _stations;
  RadioStation? get currentStation => _currentStation;

  void setStations(List<RadioStation> stations) {
    _stations = stations;
    notifyListeners();
  }

  void loadStations(String jsonData) {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonData);
      final List<RadioStation> stations = jsonList.map((json) => RadioStation.fromJson(json)).toList();
      setStations(stations);
    } catch (e) {
      debugPrint("Error loading stations: $e");
    }
  }

  void setCurrentStation(RadioStation station) {
    _currentStation = station;
    notifyListeners();
  }
}
