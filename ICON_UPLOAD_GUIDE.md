# Still Focus Timer - 앱 아이콘 업로드 가이드

## 📤 올릴 파일 (필수 1개)

### 1. 메인 앱 아이콘

| 올릴 파일 이름 | 저장 위치 | 크기 | 형식 |
|---------------|----------|------|------|
| **app_icon.png** | `assets/icons/app_icon.png` | **1024×1024 px** | PNG |

이 파일 하나만 준비하면 됩니다. `flutter_launcher_icons`가 자동으로 모든 해상도 아이콘을 생성합니다.

---

## 📤 올릴 파일 (선택 2개)

### 2. Adaptive Icon 포어그라운드 (선택)

| 올릴 파일 이름 | 저장 위치 | 크기 | 형식 |
|---------------|----------|------|------|
| **app_icon_foreground.png** | `assets/icons/app_icon_foreground.png` | **1024×1024 px** | PNG (투명 배경) |

- 아이콘만 있고 배경이 투명한 이미지
- 없으면 `app_icon.png`가 사용됨

### 3. Adaptive Icon 배경색 (현재 설정)

- `pubspec.yaml`에 `#B08968` (Still Focus Accent)로 설정됨
- 별도 이미지 파일 불필요

---

## 📁 폴더 구조

```
momo/
└── assets/
    └── icons/
        ├── app_icon.png          ← 필수: 여기에 올리세요
        └── app_icon_foreground.png  ← 선택: 투명 배경 아이콘
```

---

## ✅ 업로드 후 할 일

1. **파일 교체**: `assets/icons/app_icon.png`를 새 파일로 덮어쓰기

2. **아이콘 생성 명령어 실행**:
```bash
dart run flutter_launcher_icons
```

3. **앱 재빌드**:
```bash
flutter clean
flutter run
```

---

## 🎨 Still Focus 디자인 가이드

| 항목 | 값 |
|------|-----|
| Primary (배경) | #EAE0D5 |
| Accent (포인트) | #B08968 |
| Adaptive Icon 배경색 | #B08968 |

- **아이콘 안전 영역**: 중앙 80% 영역에 주요 요소 배치 (모서리 잘림 방지)
- **스타일**: Liquid Glass, 프리미엄 베이지 톤

---

## 📋 체크리스트

- [ ] `app_icon.png` (1024×1024) 준비
- [ ] `assets/icons/` 폴더에 저장
- [ ] `dart run flutter_launcher_icons` 실행
- [ ] 앱에서 아이콘 확인




