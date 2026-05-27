import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:app/models/radio_station.dart';

class RadioProvider extends ChangeNotifier {
  List<RadioStation> _stations = [];
  RadioStation? _currentStation;

  // History for Back button
  final List<RadioStation> _history = [];
  
  // Shuffle history (unplayed stations)
  List<RadioStation> _unplayedShuffle = [];

  // Playback States
  bool _isPlaying = false;
  bool _isBuffering = true;
  String? _errorMsg;
  
  // Volume & Mute (0 to 100)
  int _volume = 100;
  int _lastHearableVolume = 100;
  bool _isMuted = false;

  List<RadioStation> get stations => _stations;
  RadioStation? get currentStation => _currentStation;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;
  String? get errorMsg => _errorMsg;
  int get volume => _volume;
  bool get isMuted => _isMuted;
  
  bool get canBack => _history.isNotEmpty;

  void setStations(List<RadioStation> stations) {
    // Sort stations alphabetically by name, matching Go code
    stations.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _stations = stations;
    
    // Set a random initial station if none is selected yet
    if (_currentStation == null && _stations.isNotEmpty) {
      _currentStation = _randomRadio();
    }
    notifyListeners();
  }

  void loadStations(String jsonData) {
    try {
      final List<dynamic> jsonList = jsonDecode(jsonData);
      final List<RadioStation> loaded = jsonList.map((json) => RadioStation.fromJson(json)).toList();
      setStations(loaded);
    } catch (e) {
      debugPrint("Error loading stations: $e");
    }
  }

  void setCurrentStation(RadioStation station, {bool addToHistory = true}) {
    if (_currentStation != null && _currentStation!.id != station.id) {
      if (addToHistory) {
        _history.add(_currentStation!);
      }
    }
    _currentStation = station;
    _isPlaying = false; // reset playing state on station change
    _isBuffering = true; // reset buffering state on station change
    _errorMsg = null; // reset error state on station change
    notifyListeners();
  }

  void goBack() {
    if (canBack) {
      final prev = _history.removeLast();
      setCurrentStation(prev, addToHistory: false);
    }
  }

  RadioStation _randomRadio() {
    if (_unplayedShuffle.isEmpty) {
      _unplayedShuffle = List.from(_stations);
    }
    final rand = math.Random();
    final idx = rand.nextInt(_unplayedShuffle.length);
    final station = _unplayedShuffle.removeAt(idx);
    return station;
  }

  void playShuffle() {
    if (_stations.isNotEmpty) {
      final station = _randomRadio();
      setCurrentStation(station);
    }
  }

  // Playback state updates (usually called by player listeners)
  void setPlaybackState(bool isPlaying, bool isBuffering) {
    bool changed = false;
    if (_isPlaying != isPlaying) {
      _isPlaying = isPlaying;
      changed = true;
    }
    if (_isBuffering != isBuffering) {
      _isBuffering = isBuffering;
      changed = true;
    }
    if (isPlaying && _errorMsg != null) {
      _errorMsg = null;
      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
  }

  void setError(String? errorMsg) {
    if (_errorMsg != errorMsg) {
      _errorMsg = errorMsg;
      notifyListeners();
    }
  }

  // Volume controls (called by UI)
  void setVolume(int value) {
    _volume = value.clamp(0, 100);
    if (_volume > 0) {
      _lastHearableVolume = _volume;
      _isMuted = false;
    } else {
      _isMuted = true;
    }
    notifyListeners();
  }

  void toggleMute() {
    if (_isMuted) {
      _isMuted = false;
      _volume = _lastHearableVolume;
    } else {
      _isMuted = true;
      _volume = 0;
    }
    notifyListeners();
  }
}
