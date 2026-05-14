import 'enums.dart';

class SettingsData {
  final double musicVolume; // 0..1
  final double sfxVolume;
  final bool vibrationEnabled;
  final ControlScheme controlScheme;
  final bool showFps;
  final bool reducedMotion;
  final bool autoNitro;
  final String languageCode;

  const SettingsData({
    this.musicVolume = 0.6,
    this.sfxVolume = 0.85,
    this.vibrationEnabled = true,
    this.controlScheme = ControlScheme.touchSteering,
    this.showFps = false,
    this.reducedMotion = false,
    this.autoNitro = false,
    this.languageCode = 'en',
  });

  SettingsData copyWith({
    double? musicVolume,
    double? sfxVolume,
    bool? vibrationEnabled,
    ControlScheme? controlScheme,
    bool? showFps,
    bool? reducedMotion,
    bool? autoNitro,
    String? languageCode,
  }) =>
      SettingsData(
        musicVolume: musicVolume ?? this.musicVolume,
        sfxVolume: sfxVolume ?? this.sfxVolume,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
        controlScheme: controlScheme ?? this.controlScheme,
        showFps: showFps ?? this.showFps,
        reducedMotion: reducedMotion ?? this.reducedMotion,
        autoNitro: autoNitro ?? this.autoNitro,
        languageCode: languageCode ?? this.languageCode,
      );

  Map<String, dynamic> toJson() => {
        'musicVolume': musicVolume,
        'sfxVolume': sfxVolume,
        'vibrationEnabled': vibrationEnabled,
        'controlScheme': controlScheme.name,
        'showFps': showFps,
        'reducedMotion': reducedMotion,
        'autoNitro': autoNitro,
        'languageCode': languageCode,
      };

  factory SettingsData.fromJson(Map<String, dynamic> j) => SettingsData(
        musicVolume: (j['musicVolume'] as num?)?.toDouble() ?? 0.6,
        sfxVolume: (j['sfxVolume'] as num?)?.toDouble() ?? 0.85,
        vibrationEnabled: j['vibrationEnabled'] as bool? ?? true,
        controlScheme: ControlScheme.values.byName(
          j['controlScheme'] as String? ?? 'touchSteering',
        ),
        showFps: j['showFps'] as bool? ?? false,
        reducedMotion: j['reducedMotion'] as bool? ?? false,
        autoNitro: j['autoNitro'] as bool? ?? false,
        languageCode: j['languageCode'] as String? ?? 'en',
      );
}
