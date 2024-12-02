# CLASSIN
![LOGO](https://github.com/user-attachments/assets/d5d37edd-ee8f-4305-8e82-38a18dc894d9)
### 위치기반 출석 시스템

## 🔧Stack🔧
<p align="left">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white">
  <img src="https://img.shields.io/badge/dart-0175C2?style=for-the-badge&logo=dart&logoColor=white">
  <img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white">
</p>

## 📱Platform📱
<p align="left">
  <img src="https://img.shields.io/badge/ios-000000?style=for-the-badge&logo=ios&logoColor=white">
  <img src="https://img.shields.io/badge/android-3DDC84?style=for-the-badge&logo=android&logoColor=white">
  <img src="https://img.shields.io/badge/web-4285F4?style=for-the-badge&logo=google-chrome&logoColor=white">
</p>

## 📜 개발 배경
- **교내 출석 시스템 부재**
     - 이름을 불러 출석하는 방식을 벗어나고 교수의 편의성을 위해 생각하게 되었다.

### 💡 주요 기능
- **OAuth 2.0, Supabase Authentication**
  - 구글 이메일을 통한 회원가입으로 학생 정보를 저장
  - 사용자 인증 상태를 관리하며, 로그아웃 및 세션 상태를 모니터링
  - 로그인 성공 시 사용자의 이메일과 이름을 가져와 홈 화면으로 전달
  
- **위치 기반 출석**
  - 학교 또는 지정된 위치와 사용자 간의 거리를 계산해 출석 여부를 결정
  - *Geolocator*: 사용자의 현재 GPS 위치를 확인
  - *Google Maps API*: 지도와 마커를 표시하며, 사용자가 출석 가능한 위치를 시각적으로 보여줌
 
- **출석 데이터 저장**
  - *Supabase Database*: 출석 정보를 데이터베이스에 저장
    - 저장되는 데이터:
	  - 사용자 ID, 이름, 이메일
	  - 현재 GPS 좌표 (위도/경도)
	  - 출석 시간
  
- **출석 알림**
  - 출석 완료시 DB에 학생, 시간, 위치 등 정보가 저장되고 교수에게 출석 완료 이메일 자동 전송
    

---

## 🖼 화면 구성
### 로딩 화면
<img src="https://github.com/user-attachments/assets/fa08035e-6519-4438-88ce-3af33f4949bd" width="355" height="769"/>

### 로그인 화면
<img src="https://github.com/user-attachments/assets/fd4a0289-b5bb-404f-bd26-efa142bc53a4" width="330" height="769"/>
<img src="https://github.com/user-attachments/assets/b014b4f7-4e87-48e2-a82b-18f64ba84454" width="330" height="769"/>
<img src="https://github.com/user-attachments/assets/645e5217-83ae-48a8-9ca2-240e632745ea" width="330" height="769"/>

### 메인 화면
<img src="https://github.com/user-attachments/assets/0e712191-b1da-424f-bde3-82165081e459" width="330" height="769"/>
<img src="https://github.com/user-attachments/assets/9047ed7d-3a34-4eda-9063-b235f550d268" width="330" height="769"/>
<img src="https://github.com/user-attachments/assets/08f48cd0-7dd3-4ff4-96d9-e168078359d7" width="330" height="769"/>

### 출석 완료 메일
<img width="314" alt="스크린샷 2024-11-29 오후 5 59 57" src="https://github.com/user-attachments/assets/c7a17273-4891-4517-8a0b-503a9a0894b5">

## 🎨 Figma
https://url.kr/21rlo8
