import 'package:flutter/material.dart';
import 'enums.dart';

class MapDefinition {
  final String id;
  final String name;
  final MapTheme theme;
  final int unlockCoins;
  final int unlockDistance; // total lifetime distance required
  final Color skyTop;
  final Color skyBottom;
  final Color roadColor;
  final Color groundColor;
  final List<WeatherType> possibleWeather;

  const MapDefinition({
    required this.id,
    required this.name,
    required this.theme,
    this.unlockCoins = 0,
    this.unlockDistance = 0,
    required this.skyTop,
    required this.skyBottom,
    required this.roadColor,
    required this.groundColor,
    this.possibleWeather = const [WeatherType.clear],
  });
}
