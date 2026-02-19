# 🎨 FocusFlow 앱 아이콘 설정 가이드

## 📋 개요

Flutter 앱 아이콘을 Android와 iOS에 맞게 설정하는 방법입니다.

## 🛠️ 설정 방법

### 1단계: 아이콘 이미지 준비

**필요한 이미지:**
- `assets/icons/app_icon.png` - **1024x1024px** PNG (투명 배경 가능)
- `assets/icons/app_icon_foreground.png` - **1024x1024px** PNG (Android Adaptive Icon용, 투명 배경)

**아이콘 디자인 요구사항:**
- ✅ 정사각형 (1:1 비율)
- ✅ 최소 1024x1024 픽셀
- ✅ PNG 형식
- ✅ 투명 배경 가능 (iOS는 자동으로 제거됨)
- ✅ 안전 영역: 중앙 80% 영역에 중요한 요소 배치 (Android Adaptive Icon)

### 2단계: 폴더 구조 생성

프로젝트 루트에 다음 폴더를 생성하세요:

```
momo/
├── assets/
│   └── icons/
│       ├── app_icon.png              # 메인 아이콘 (1024x1024)
│       └── app_icon_foreground.png  # Android Adaptive Icon 전경 (1024x1024)
```

### 3단계: 패키지 설치 및 아이콘 생성

```bash
# 1. 패키지 설치
flutter pub get

# 2. 아이콘 생성 (Android & iOS)
flutter pub run flutter_launcher_icons
```

또는:

```bash
dart run flutter_launcher_icons
```

### 4단계: 확인

아이콘이 생성되었는지 확인:

**Android:**
- `android/app/src/main/res/mipmap-*/ic_launcher.png`
- `android/app/src/main/res/mipmap-*/ic_launcher_round.png`
- `android/app/src/main/res/mipmap-*/ic_launcher_foreground.png` (Adaptive Icon)

**iOS:**
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` 폴더 내 여러 크기

## 🎨 FocusFlow 아이콘 디자인 가이드

### 색상 팔레트
- **Primary**: `#FF6B35` (딥 오렌지)
- **Secondary**: `#4A3F6B` (딥 퍼플)
- **Background**: `#1A1625` (다크)

### 아이콘 컨셉 제안
1. **타이머/집중** - 원형 타이머 또는 시계 아이콘
2. **에너지** - 번개 또는 화살표
3. **성장** - 나무 또는 그래프
4. **단순함** - 미니멀한 기하학적 도형

### Android Adaptive Icon
- **Foreground**: 아이콘의 주요 요소 (중앙 80% 영역)
- **Background**: `#FF6B35` (Primary 색상) 또는 그라디언트

## 📱 플랫폼별 요구사항

### Android
- **기본 아이콘**: 48dp, 72dp, 96dp, 144dp, 192dp
- **Adaptive Icon**: 
  - Foreground: 108x108dp (안전 영역: 72x72dp)
  - Background: 108x108dp
- **Round Icon**: 자동 생성됨

### iOS
- **App Icon**: 20pt, 29pt, 40pt, 60pt, 76pt, 83.5pt, 1024pt
- **투명도**: 자동으로 제거됨 (`remove_alpha_ios: true`)

## 🔧 고급 설정

### pubspec.yaml 커스터마이징

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
  
  # Android 전용 설정
  android_adaptive_icon_background: "#FF6B35"
  android_adaptive_icon_foreground: "assets/icons/app_icon_foreground.png"
  
  # iOS 전용 설정
  remove_alpha_ios: true
  
  # 특정 플랫폼만 설정
  # web: false
  # windows: false
  # macos: false
  
  # 최소 SDK 버전
  min_sdk_android: 21
```

### 수동 설정 (패키지 사용 안 함)

**Android:**
1. `android/app/src/main/res/` 폴더에 각 해상도별 아이콘 배치
2. `AndroidManifest.xml`에서 아이콘 경로 확인

**iOS:**
1. Xcode에서 `ios/Runner.xcworkspace` 열기
2. `Assets.xcassets` > `AppIcon`에서 각 크기별 아이콘 설정

## ✅ 체크리스트

- [ ] `assets/icons/app_icon.png` 생성 (1024x1024)
- [ ] `assets/icons/app_icon_foreground.png` 생성 (1024x1024, 선택사항)
- [ ] `pubspec.yaml`에 `flutter_launcher_icons` 설정 추가
- [ ] `flutter pub get` 실행
- [ ] `flutter pub run flutter_launcher_icons` 실행
- [ ] Android 빌드 테스트
- [ ] iOS 빌드 테스트

## 🐛 문제 해결

### 아이콘이 생성되지 않을 때
```bash
# 캐시 정리 후 재시도
flutter clean
flutter pub get
flutter pub run flutter_launcher_icons
```

### Android Adaptive Icon이 제대로 표시되지 않을 때
- `android_adaptive_icon_foreground` 경로 확인
- Foreground 이미지가 투명 배경인지 확인
- Background 색상이 올바른지 확인

### iOS 아이콘이 투명할 때
- `remove_alpha_ios: true` 설정 확인
- 또는 Xcode에서 수동으로 투명도 제거

## 📚 참고 자료

- [flutter_launcher_icons 패키지](https://pub.dev/packages/flutter_launcher_icons)
- [Android Adaptive Icons 가이드](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)
- [iOS App Icon 가이드](https://developer.apple.com/design/human-interface-guidelines/app-icons)

---

**팁**: 아이콘 디자인은 [Figma](https://www.figma.com/), [Canva](https://www.canva.com/), 또는 [AppIcon.co](https://www.appicon.co/) 같은 도구를 사용하면 쉽게 만들 수 있습니다!


