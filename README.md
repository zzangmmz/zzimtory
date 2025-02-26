# 🛍️ 찜토리 | ZZIMTORY
![Thumbnail](https://github.com/user-attachments/assets/6775bdfb-4744-4b78-aac9-bea35314e9ca)
> **zzimtory**란 찜(wished items) + inventory의 합성어로,  
> 사이트에 구애받지 않고 구매하고 싶은 아이템을 모아볼 수 있는 앱입니다.
---
## 목차
[1. 프로젝트 정보](#-프로젝트-정보)

[2. 시연 영상](#-시연-영상)

[3. 버전 요구사항](#-버전-요구사항)

[4. 기술 스택](#%EF%B8%8F-기술-스택)

[5. 주요 기능](#-주요-기능)

[6. 트러블 슈팅](#-트러블-슈팅)

[7. 와이어프레임 & 브레인스토밍](#-와이어프레임--브레인스토밍)

[8. 팀원 소개 및 역할](#-팀원-소개-및-역할)

[9. 코드 컨벤션 & 브랜치 전략](#-코드-컨벤션--브랜치-전략)


---
## 🔖 프로젝트 정보

#### 프로젝트명: 찜토리
#### 앱 종류: 쇼핑 아이템 스크랩 서비스
#### 프로젝트기간: 2025. 01. 16 ~ 2025.02.28

---
## 📱 시연 영상
🔗 [시연 영상 보러가기](https://youtube.com/shorts/HqwDDmTSEos)

---

## 🔧 버전 요구사항
- Xcode 버전: 16.1 이상
- iOS 지원 버전: iOS 16.0 이상
- Swift 버전: Swift 5 이상

---

## 🛠️ 기술 스택
#### 최소 지원 버전: iOS 16.0
#### 아키텍처: MVVM
#### UI 프레임워크
  - UIKit: iOS UI 개발의 기본 프레임워크
#### 사용 라이브러리
  - SnapKit
      - 체이닝 문법으로 레이아웃 로직 한 눈에 파악 가능
      - 제약 조건의 업데이트와 조건부 변경이 가능
  - RxSwift/RxCocoa
      - 데이터 혹은 상태 변경을 간편하게 관리
      - 변경 사항이 있을 때마다 해당 요소를 직접 변경하는 것이 아닌, 데이터 흐름을 구독하는 구독자가 변경이 이뤄졌을 때의 동작을 수행하는 것으로 데이터 바인딩 과정을 간편화
  - Moya
      - API 호출마다 URL Session을 반복적으로 사용하는 것 대신 Moya의 TargetType 프로토콜로 엔드포인트 깔끔하게 정의해 코드 가독성을 높임
  - Kingfisher
      - 상품 이미지를 많이 다루는 환경이기에 빠르고 부드러운 사용자 경험을 제공
      - 네트워크 요청을 줄이고 앱 성능을 최적화
  - Firebase
    - Auth: 간편한 SNS 로그인을 빠르고 안전하게 구현하기 위해 사용
    - Database: 유저 데이터와 유저의 주머니 데이터만 저장이 필요했기에 데이터 구조가 복잡하지 않은 플랫폼에 적합한 Firebase Realtime Database 사용
  - 소셜 로그인 SDK
    - GoogleSignIn
    - KakaoSDK
    - NaverThirdPartyLogin
    - AuthenticationServices (Apple Login)
  - [Shuffle](https://github.com/mac-gallagher/Shuffle): 카드 스와이프 화면
#### API
  - Naver Shopping API: 상품 검색 및 정보 제공

---
## 💫 주요 기능
### 🔐 소셜 로그인
- Apple, Google, Kakao, Naver 계정으로 로그인 지원
- Firebase Auth를 통한 통합 인증 시스템
- 자동 로그인 및 로그아웃
- 회원 탈퇴

### 🔍 상품 검색
- 네이버 쇼핑 API 연동을 통한 상품 검색
- 실시간 검색어 기반 상품 목록 제공
- 스와이프 카드 형태의 직관적인 상품 탐색
  - 왼쪽 스와이프: 상품 넘기기
  - 오른쪽 스와이프: 전체 주머니에 담기
  - 위로 스와이프: 주머니에 상품 담기
- 그리드 레이아웃의 상품 목록 제공

### 📦 주머니(Pocket) 기능
- 사용자별 커스텀 주머니 생성/관리
- 주머니 이름 설정 및 수정
- 주머니 내 상품 관리
  - 상품 추가/삭제
  - 다른 주머니로 상품 이동
- 주머니 목록 정렬 (오름차순/내림차순)
- 주머니 내 상품 검색 기능

### 🛍️ 상품 상세 정보
- 상품 이미지, 가격, 판매처 정보 제공
- 유사 상품 추천
- 상품 공유 기능
- 웹사이트 연동을 통한 구매 페이지 이동
- 주머니 담기/빼기 기능

### 👤 마이페이지
- 사용자 프로필 정보 표시
- 로그아웃 및 회원 탈퇴
- 이용약관 확인
- 앱 설정 관리

### 🔄 데이터 동기화
- Firebase Realtime Database를 활용한 실시간 데이터 동기화
- 사용자별 주머니 및 상품 정보 백업

---
## 💣 트러블 슈팅
[1️⃣ 하나의 옵저버블을 여러 곳에서 구독해 의도하지 않았던 구독자에게도 이벤트가 전달되는 문제](https://github.com/zzangmmz/zzimtory/blob/main/.github/trouble/observable_side_effects.md)

[2️⃣ AppStore 심사 거절 이슈: 비회원 플로우](https://github.com/zzangmmz/zzimtory/blob/main/.github/trouble/reject_1.md)

[3️⃣ AppStore 심사 거절 이슈: 로그인의 필요성](https://github.com/zzangmmz/zzimtory/blob/main/.github/trouble/reject_2.md)

[4️⃣ AppStore 심사 거절 이슈: 구글 로그인 문제](https://github.com/zzangmmz/zzimtory/blob/main/.github/trouble/reject_3.md)

---
## 🎨 와이어프레임 & 브레인스토밍
> 와이어프레임: 🔗[와이어프레임](https://www.figma.com/design/ZBIlbGTRGHxvG2LRIfhgFa/5%EC%9D%B4%EC%86%8C?node-id=1997-1703&t=2VVt5xhOttojt4mG-0)
> 
> 브레인스토밍: 🔗[브레인스토밍](https://www.figma.com/board/PxpdEOfOImqD8jZ3EcrRbR/5%EC%9D%B4%EC%86%8C?node-id=0-1&p=f&t=RMfIBLlg6RNEjK9p-0)
---

## 👥 팀원 소개 및 역할
| 김하민 | 최성준 | 백서희 | 김동글 | 이명지 |
| --- | --- | --- | --- | --- |
| 검색화면 및 검색결과화면 | 메인 화면 | 아이템 상세화면 | 아이디어 기획 | 네트워크 및 소셜 로그인 |
| 마이페이지 | 메인 상세화면 | 아이템 웹뷰 | PPT 제작 | 데이터베이스 |
| 온보딩 화면 |  | 로그인 화면 |  | 마이페이지 |
|  |  |  |  | 메인 상세화면 |

---
## 📝 코드 컨벤션 & 브랜치 전략
### 코딩 컨벤션
- **SwiftLint 기본 룰**  
  [SwiftLint 공식 문서](https://github.com/realm/SwiftLint/blob/main/README_KR.md)

### 커밋 컨벤션
| 태그 | 설명 |
|:---:|---|
| **[feat]** | 새로운 기능 추가 |
| **[fix]** | 버그 수정 |
| **[docs]** | 문서 수정 |
| **[style]** | 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우 |
| **[refactor]** | 코드 리팩토링 |
| **[test]** | 테스트 코드, 리팩토링 테스트 코드 추가 |
| **[chore]** | 빌드 업무 수정, 패키지 매니저 수정, 파일 이동, 에셋 추가 등 |
| **[rename]** | 파일 혹은 폴더명을 수정 |

### 브랜치 전략
1. **메인 브랜치**: 프로젝트 기본 세팅
2. **개발 브랜치**: 메인 브랜치를 기준으로 생성
3. **기능 브랜치**:  
   - 브랜치 이름 형식: `작업번호-작업-제목` (예: `1-feature/detail`)
4. **작업 관리**:
   - 작업을 백로그에 [기록 → 할 일 → 진행 중 → PR → 완료] 로 관리
5. **코드 리뷰**:
   - 팀원의 70%가 승인 시 머지 가능
   - PR 템플릿 작성 후 머지

