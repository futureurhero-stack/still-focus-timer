# 📦 패키지 이름 변경 완료

## ✅ 변경 사항

### 이전 패키지 이름
- `com.example.momo` ❌ (Google Play에서 사용 불가)

### 새로운 패키지 이름
- `com.focusflow.app` ✅ (Google Play에서 사용 가능)

---

## 🔧 변경된 파일들

### 1. `android/app/build.gradle.kts`
```kotlin
namespace = "com.focusflow.app"
applicationId = "com.focusflow.app"
```

### 2. `android/app/src/main/kotlin/com/focusflow/app/MainActivity.kt`
```kotlin
package com.focusflow.app
```

### 3. `android/app/src/main/AndroidManifest.xml`
```xml
android:label="FocusFlow"
```

---

## ⚠️ 중요 주의사항

### 패키지 이름 변경 후 반드시 해야 할 일

1. **새로 빌드해야 함**:
   ```bash
   flutter clean
   flutter build appbundle --release
   ```

2. **Google Play Console에서 새 앱으로 등록**:
   - 기존에 `com.example.momo`로 업로드한 앱이 있다면
   - **새 앱으로 등록**해야 합니다 (패키지 이름이 다르므로)
   - 또는 기존 앱을 삭제하고 새로 등록

3. **키스토어는 그대로 사용 가능**:
   - 키스토어 파일은 패키지 이름과 무관하므로 그대로 사용 가능

---

## 📝 패키지 이름 규칙

### 올바른 패키지 이름 형식
- ✅ `com.focusflow.app`
- ✅ `io.focusflow.app`
- ✅ `net.focusflow.app`
- ✅ `org.focusflow.app`

### 잘못된 패키지 이름
- ❌ `com.example.*` (예제용, 사용 불가)
- ❌ `android.*` (시스템 예약)
- ❌ `java.*` (시스템 예약)
- ❌ `test.*` (테스트용)

---

## 🚀 다음 단계

1. **빌드**:
   ```bash
   flutter clean
   flutter build appbundle --release
   ```

2. **Google Play Console**:
   - 새 앱으로 등록 (또는 기존 앱 삭제 후 재등록)
   - 패키지 이름: `com.focusflow.app`
   - AAB 파일 업로드

---

## 💡 팁

- 패키지 이름은 **한 번 설정하면 변경하기 어렵습니다**
- 도메인을 가지고 있다면: `com.yourdomain.appname` 형식 권장
- 도메인이 없다면: `com.appname` 또는 `io.appname` 형식 사용

---

**변경 완료!** 이제 `com.focusflow.app` 패키지 이름으로 Google Play에 출시할 수 있습니다! 🎉


