@echo off
REM FocusFlow Android 키스토어 생성 스크립트
REM 이 스크립트는 Windows에서 키스토어를 생성합니다.

echo ========================================
echo FocusFlow Android 키스토어 생성
echo ========================================
echo.

REM 프로젝트 루트로 이동
cd /d "%~dp0"

REM 키스토어 파일이 이미 존재하는지 확인
if exist "android\app\focusflow-release-key.jks" (
    echo [경고] 키스토어 파일이 이미 존재합니다!
    echo 파일: android\app\focusflow-release-key.jks
    echo.
    set /p overwrite="기존 파일을 덮어쓰시겠습니까? (y/N): "
    if /i not "%overwrite%"=="y" (
        echo 취소되었습니다.
        pause
        exit /b
    )
)

echo.
echo 키스토어를 생성합니다...
echo.
echo 다음 정보를 입력하세요:
echo - 키스토어 비밀번호 (안전하게 보관하세요!)
echo - 키 별칭 비밀번호 (키스토어 비밀번호와 동일하게 하려면 Enter)
echo - 이름, 조직, 위치 등 정보
echo.

REM 키스토어 생성
keytool -genkey -v -keystore android\app\focusflow-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias focusflow

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo 키스토어 생성 완료!
    echo ========================================
    echo.
    echo 키스토어 위치: android\app\focusflow-release-key.jks
    echo.
    echo 다음 단계:
    echo 1. android\key.properties.example 파일을 key.properties로 복사
    echo 2. key.properties 파일에 비밀번호와 정보 입력
    echo 3. 키스토어 파일을 안전한 곳에 백업하세요!
    echo.
) else (
    echo.
    echo ========================================
    echo 키스토어 생성 실패
    echo ========================================
    echo.
    echo Java JDK가 설치되어 있는지 확인하세요:
    echo java -version
    echo.
)

pause

