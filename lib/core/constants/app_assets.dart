/// Still Focus 앱 에셋 경로 상수
class AppAssets {
  AppAssets._();

  // ===== SVG 아이콘 =====
  static const String iconPlay = 'assets/icons/icon_play.svg';
  static const String iconPause = 'assets/icons/icon_pause.svg';
  static const String iconReset = 'assets/icons/icon_reset.svg';
  static const String iconHome = 'assets/icons/icon_home.svg';
  static const String iconFocus = 'assets/icons/icon_focus.svg';
  static const String iconBreak = 'assets/icons/icon_break.svg';
  static const String iconStats = 'assets/icons/bar-chart.svg';
  static const String iconSettings = 'assets/icons/settings.svg';
  static const String iconGear = 'assets/icons/icon_gear.svg';
  static const String iconNotification = 'assets/icons/icon_notification.svg';
  static const String iconSound = 'assets/icons/icon_sound.svg';
  static const String iconStar = 'assets/icons/icon_star.svg';
  static const String iconCalendar = 'assets/icons/icon_calendar.svg';
  static const String iconFlame = 'assets/icons/icon_flame.svg';
  static const String iconMoon = 'assets/icons/icon_moon.svg';
  static const String iconSun = 'assets/icons/icon_sun.svg';
  static const String iconCheck = 'assets/icons/icon_check.svg';
  static const String iconClose = 'assets/icons/icon_close.svg';
  static const String iconPlus = 'assets/icons/icon_plus.svg';
  static const String iconMinus = 'assets/icons/icon_minus.svg';
  static const String iconLock = 'assets/icons/icon_lock.svg';
  static const String iconCrown = 'assets/icons/icon_crown.svg';

  // ===== 배경 이미지 =====
  static const String bgPastelPink = 'assets/backgrounds/bg_pastel_pink.png';
  static const String bgSoftBlue = 'assets/backgrounds/bg_soft_blue.png';
  static const String bgBeigeLuxury = 'assets/backgrounds/bg_beige_luxury.png';
  static const String bgMorningLight = 'assets/backgrounds/bg_morning_light.png';
  static const String bgEveningCalm = 'assets/backgrounds/bg_evening_calm.png';
  static const String bgNightFocus = 'assets/backgrounds/bg_night_focus.png';

  // ===== 장식 =====
  static const String decoGlassBlur = 'assets/decorations/deco_glass_blur.png';
  static const String decoGradientRing = 'assets/decorations/deco_gradient_ring.png';
  static const String decoNoiseTexture = 'assets/decorations/deco_noise_texture.png';
  static const String decoPastelBlob = 'assets/decorations/deco_pastel_blob.png';

  /// 시간대별 배경 선택
  static String getBackgroundForHour(int hour) {
    if (hour >= 5 && hour < 12) return bgMorningLight;
    if (hour >= 12 && hour < 17) return bgBeigeLuxury;
    if (hour >= 17 && hour < 21) return bgEveningCalm;
    return bgNightFocus;
  }
}

