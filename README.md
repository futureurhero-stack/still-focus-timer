# Still: Focus Timer

> 산뜻하고 깔끔한 집중 타이머 앱 – 감정 기반 포모도로로 하루를 이어가세요

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

## 📱 주요 기능

### 🏠 홈 화면

- **감정 기반 세션 시작**: "How are you feeling now?" – 4가지 기분 카드로 세션 시간 추천
- **Quick Start**: 기본 설정 시간으로 즉시 시작
- **오늘 집중 시간 & 연속 기록**: 한눈에 보는 집중 현황

### ⏱️ 포커스 타이머

- 작업 단위 중심의 세션 관리
- 원형 프로그레스 타이머 (산뜻한 미니멀 스타일)
- 일시정지/재개, 백그라운드 타이머 지원

### 📝 세션 회고

- 세션 완료 후 간단한 성과 기록
- 최근 작업 자동 추천
- 포기해도 기록 – 중단 이유 선택 (피곤함, 집중 안됨, 급한 일 등)

### 📊 집중 통계 (Analytics)

- 주간/월간 통계 차트
- 시간대별 집중 패턴 분석
- Daily Focus Story – 하루 기록 스토리 형태 제공

### ⚙️ 설정

- 한국어/영어 전환 (슬라이드 스타일)
- 기본 세션 길이 설정 (5~60분)
- 알림 설정
- 사용자 데이터 백업 지원 (앱 업데이트 후 유지)

## 🛠️ 기술 스택

- **Framework**: Flutter 3.10+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: SharedPreferences
- **Charts**: fl_chart
- **Animations**: flutter_animate
- **Notifications**: flutter_local_notifications
- **SVG Icons**: flutter_svg
- **Localization**: intl, flutter_localizations (EN/KR)

## 📁 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── app.dart                  # 라우팅 설정
│
├── core/                     # 핵심 설정
│   ├── constants/            # 상수 (색상, 문자열, 에셋)
│   ├── theme/                # Material 3 테마
│   ├── providers/            # Riverpod 프로바이더
│   └── locale/               # 로케일 설정
│
├── data/                     # 데이터 레이어
│   ├── models/               # 데이터 모델
│   └── local/                # DatabaseService (SharedPreferences)
│
├── features/                 # 기능별 모듈
│   ├── home/                 # 홈 (감정 선택, Quick Start)
│   ├── timer/                # 타이머 화면
│   ├── reflection/           # 세션 회고
│   ├── analytics/            # 통계
│   └── settings/             # 설정
│
└── shared/                   # 공유 컴포넌트
    └── widgets/              # MoodCard, GradientButton, SvgIcon 등
```

## 🚀 시작하기

### 요구사항

- Flutter 3.10 이상
- Dart 3.0 이상

### 설치

```bash
# 저장소 클론
git clone https://github.com/futureurhero-stack/still-focus-timer.git
cd momo

# 의존성 설치
flutter pub get

# 앱 실행
flutter run
```

### 빌드

```bash
# Android APK
flutter build apk

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS
flutter build ios
```

## 🎨 디자인 시스템

### 스타일

- **Material 3** 기반
- **Soft Neumorphism** – 부드러운 그림자와 라운드 카드 (28–32 radius)
- **산뜻하고 깔끔한** 미니멀 UI
- **Liquid Glass** – 타이머·카드에 가벼운 글래스 효과

### 색상 팔레트

| 용도 | 색상 | HEX |
|------|------|-----|
| Accent | 산뜻한 오렌지 | `#E87D54` |
| Primary | 연한 베이지 | `#F5F0EB` |
| Background | 밝은 배경 | `#F8F9FA` |
| Text | 진한 회색 | `#2C2C2C` |

### 감정별 색상

- 😫 하기 싫음 / 😃 괜찮음: `#E87D54`
- 😰 스트레스: `#F5A082`
- 😴 졸림: `#D4C9BC`

## 📄 라이선스

MIT License

---

Made with ❤️ for focused productivity
