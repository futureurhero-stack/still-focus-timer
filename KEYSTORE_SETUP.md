# 🔐 Android 키스토어(Keystore) 생성 가이드

## 📋 개요

Android 앱을 Google Play Store에 출시하려면 앱을 서명해야 합니다. 
키스토어 파일은 앱의 디지털 서명에 사용되며, 한 번 생성하면 **절대 잃어버리면 안 됩니다!**

## ⚠️ 중요 주의사항

- ✅ **키스토어 파일을 안전한 곳에 백업하세요**
- ✅ **키스토어 비밀번호를 안전하게 보관하세요**
- ✅ **키 별칭(alias)과 비밀번호를 기록해두세요**
- ❌ **키스토어를 잃어버리면 앱 업데이트가 불가능합니다**
- ❌ **키스토어를 Git에 커밋하지 마세요** (`.gitignore`에 추가)

---

## 🛠️ 1단계: 키스토어 파일 생성

### Windows (PowerShell 또는 CMD)

```bash
# 프로젝트 루트에서 실행
cd C:\Project\flutter_project\momo

# 키스토어 생성 명령어
keytool -genkey -v -keystore android/app/focusflow-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias focusflow
```

### 명령어 설명

- `-genkey`: 새 키 쌍 생성
- `-v`: 상세 출력 (verbose)
- `-keystore`: 키스토어 파일 경로 및 이름
  - `android/app/focusflow-release-key.jks` (권장 위치)
- `-keyalg RSA`: RSA 알고리즘 사용
- `-keysize 2048`: 키 크기 (2048비트 권장)
- `-validity 10000`: 유효 기간 (일 단위, 약 27년)
- `-alias focusflow`: 키 별칭 (나중에 사용)

### 입력할 정보

명령어 실행 후 다음 정보를 입력하세요:

```
키스토어 비밀번호 입력: [비밀번호 입력]
새 비밀번호 다시 입력: [비밀번호 확인]

이름과 성을 입력하십시오.
  [Unknown]: FocusFlow Team

조직 단위 이름을 입력하십시오.
  [Unknown]: Development

조직 이름을 입력하십시오.
  [Unknown]: FocusFlow

구/군/시 이름을 입력하십시오?
  [Unknown]: Seoul

시/도 이름을 입력하십시오.
  [Unknown]: Seoul

이 조직의 두 자리 국가 코드를 입력하십시오.
  [Unknown]: KR

CN=FocusFlow Team, OU=Development, O=FocusFlow, L=Seoul, ST=Seoul, C=KR이(가) 맞습니까?
  [아니오]: y

focusflow에 대한 키 비밀번호를 입력하십시오.
        (RETURN과 동일한 경우 키스토어 비밀번호): [Enter 또는 별도 비밀번호]
```

**팁**: 키 별칭 비밀번호는 키스토어 비밀번호와 동일하게 설정하는 것이 편리합니다 (Enter만 누르면 됨).

---

## 🔍 2단계: 키스토어 정보 확인

생성된 키스토어의 정보를 확인하려면:

```bash
keytool -list -v -keystore android/app/focusflow-release-key.jks
```

비밀번호를 입력하면 키스토어의 상세 정보가 표시됩니다.

---

## 📝 3단계: key.properties 파일 생성

프로젝트 루트에 `android/key.properties` 파일을 생성합니다.

```properties
storePassword=여기에_키스토어_비밀번호
keyPassword=여기에_키_별칭_비밀번호
keyAlias=focusflow
storeFile=app/focusflow-release-key.jks
```

**⚠️ 보안 주의**: 이 파일은 Git에 커밋하지 마세요!

---

## 🔧 4단계: build.gradle.kts 설정

`android/app/build.gradle.kts` 파일을 수정하여 키스토어를 사용하도록 설정합니다.

### 변경 전 (현재)
```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
    }
}
```

### 변경 후
```kotlin
// key.properties 파일 읽기
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... 기존 설정 ...

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

---

## 🚀 5단계: 서명된 APK/AAB 빌드

### APK 빌드
```bash
flutter build apk --release
```

### App Bundle 빌드 (Google Play Store 권장)
```bash
flutter build appbundle --release
```

빌드된 파일 위치:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

---

## 🔒 보안 체크리스트

- [ ] 키스토어 파일을 안전한 곳에 백업 (USB, 클라우드 등)
- [ ] `key.properties` 파일을 `.gitignore`에 추가
- [ ] 키스토어 파일을 `.gitignore`에 추가
- [ ] 비밀번호를 안전한 비밀번호 관리자에 저장
- [ ] 팀원과 공유할 때는 안전한 방법 사용 (암호화된 채널)

---

## 📁 .gitignore 설정

`android/` 폴더의 `.gitignore` 또는 프로젝트 루트의 `.gitignore`에 추가:

```
# 키스토어 파일
*.jks
*.keystore
key.properties
```

---

## 🐛 문제 해결

### "keytool을 찾을 수 없습니다" 오류

Java JDK가 설치되어 있는지 확인:
```bash
java -version
```

JDK가 없다면 설치:
- [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
- [OpenJDK](https://adoptium.net/)

### "키스토어가 손상되었습니다" 오류

- 키스토어 파일이 완전히 다운로드/복사되었는지 확인
- 파일 권한 확인
- 다른 위치에서 다시 생성 시도

### 비밀번호를 잊어버렸을 때

**복구 불가능합니다!** 새 키스토어를 생성해야 하며, 기존 앱과는 다른 앱으로 인식됩니다.

---

## 📚 참고 자료

- [Android 앱 서명 가이드](https://developer.android.com/studio/publish/app-signing)
- [Flutter 앱 빌드 가이드](https://docs.flutter.dev/deployment/android)
- [Google Play 앱 서명](https://support.google.com/googleplay/android-developer/answer/9842756)

---

## 💡 팁

1. **Google Play App Signing 사용**: Google Play Console에서 앱 서명을 관리하면 키스토어를 잃어버려도 복구 가능
2. **키스토어 별칭**: 여러 앱을 관리할 때는 각각 다른 별칭 사용
3. **유효 기간**: 10000일(약 27년)은 충분히 길지만, 필요시 더 길게 설정 가능
4. **키 크기**: 2048비트는 현재 표준, 4096비트도 가능하지만 빌드 시간이 더 걸림

---

**⚠️ 마지막 경고**: 키스토어 파일과 비밀번호를 안전하게 보관하세요. 잃어버리면 앱 업데이트가 불가능합니다!


