import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/map_definition.dart';

class MapCatalog {
  MapCatalog._();

  static const String defaultMapId = 'city_highway';

  static const List<MapDefinition> all = [
    MapDefinition(
      id: 'city_highway',
      name: 'City Highway',
      theme: MapTheme.cityHighway,
      skyTop: Color(0xFF1A237E),
      skyBottom: Color(0xFF311B92),
      roadColor: Color(0xFF263238),
      groundColor: Color(0xFF1B1B1B),
      possibleWeather: [WeatherType.clear, WeatherType.rain, WeatherType.night],
    ),
    MapDefinition(
      id: 'desert',
      name: 'Desert Run',
      theme: MapTheme.desert,
      unlockCoins: 15000,
      skyTop: Color(0xFFFF6F00),
      skyBottom: Color(0xFFFFB300),
      roadColor: Color(0xFF3E2723),
      groundColor: Color(0xFFBF8E5C),
      possibleWeather: [WeatherType.clear, WeatherType.sandstorm],
    ),
    MapDefinition(
      id: 'snow',
      name: 'Snow Mountain',
      theme: MapTheme.snowMountain,
      unlockCoins: 40000,
      skyTop: Color(0xFF263238),
      skyBottom: Color(0xFF607D8B),
      roadColor: Color(0xFFCFD8DC),
      groundColor: Color(0xFFECEFF1),
      possibleWeather: [WeatherType.snow, WeatherType.fog],
    ),
    MapDefinition(
      id: 'neon_city',
      name: 'Neon Cyber City',
      theme: MapTheme.neonCyberCity,
      unlockCoins: 80000,
      skyTop: Color(0xFF1A0033),
      skyBottom: Color(0xFF12005E),
      roadColor: Color(0xFF0D0F1F),
      groundColor: Color(0xFF1A1033),
      possibleWeather: [WeatherType.night, WeatherType.rain],
    ),
    MapDefinition(
      id: 'forest',
      name: 'Forest Highway',
      theme: MapTheme.forestHighway,
      unlockCoins: 25000,
      skyTop: Color(0xFF1B5E20),
      skyBottom: Color(0xFF2E7D32),
      roadColor: Color(0xFF263238),
      groundColor: Color(0xFF1B5E20),
      possibleWeather: [WeatherType.clear, WeatherType.fog],
    ),
    MapDefinition(
      id: 'coastal',
      name: 'Coastal Road',
      theme: MapTheme.coastalRoad,
      unlockCoins: 55000,
      skyTop: Color(0xFF01579B),
      skyBottom: Color(0xFF4FC3F7),
      roadColor: Color(0xFF263238),
      groundColor: Color(0xFFFFE082),
      possibleWeather: [WeatherType.clear, WeatherType.rain],
    ),
  ];

  static MapDefinition byId(String id) => all.firstWhere((m) => m.id == id);
}
