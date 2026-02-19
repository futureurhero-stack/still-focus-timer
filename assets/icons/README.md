# 📱 아이콘 파일 위치

이 폴더에 다음 아이콘 파일을 추가하세요:

## 필요한 파일

1. **app_icon.png** (필수)
   - 크기: 1024x1024 픽셀
   - 형식: PNG
   - 용도: Android와 iOS 기본 아이콘

2. **app_icon_foreground.png** (선택사항, Android Adaptive Icon용)
   - 크기: 1024x1024 픽셀
   - 형식: PNG (투명 배경)
   - 용도: Android Adaptive Icon의 전경 이미지
   - 참고: 이 파일이 없으면 `app_icon.png`가 사용됩니다

## 아이콘 생성 방법

### 방법 1: 온라인 도구 사용
- [AppIcon.co](https://www.appicon.co/) - 무료 아이콘 생성기
- [IconKitchen](https://icon.kitchen/) - Google의 Adaptive Icon 생성기
- [Canva](https://www.canva.com/) - 디자인 도구

### 방법 2: 직접 디자인
- Figma, Adobe Illustrator, Sketch 등 사용
- 1024x1024 픽셀 정사각형으로 제작
- FocusFlow 브랜드 색상 사용:
  - Primary: `#FF6B35`
  - Secondary: `#4A3F6B`

## 아이콘 생성 명령어

아이콘 파일을 추가한 후 다음 명령어를 실행하세요:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

또는:

```bash
dart run flutter_launcher_icons
```

## 디자인 팁

- ✅ 단순하고 명확한 디자인
- ✅ 작은 크기에서도 인식 가능
- ✅ FocusFlow의 집중/타이머 컨셉 반영
- ✅ Android Adaptive Icon: 중앙 80% 영역에 주요 요소 배치


