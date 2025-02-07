# 🛍️ 찜토리 | ZZIMTORY
![Thumbnail](https://github.com/user-attachments/assets/6775bdfb-4744-4b78-aac9-bea35314e9ca)
> **zzimtory**: 찜(wished items) + inventory의 합성어로,  
> 사이트에 구애받지 않고 구매하고 싶은 아이템을 모아볼 수 있는 앱입니다.

---
## 🔖 프로젝트 정보

#### 프로젝트명: 찜토리
#### 앱 종류: 쇼핑 아이템 스크랩 서비스
#### 프로젝트기간: 2025. 01. 16 ~

---

## 🎨 와이어프레임 & 브레인스토밍
> 와이어프레임: 🔗[와이어프레임](https://www.figma.com/design/ZBIlbGTRGHxvG2LRIfhgFa/5%EC%9D%B4%EC%86%8C?node-id=1997-1703&t=2VVt5xhOttojt4mG-0)
> 
> 브레인스토밍: 🔗[브레인스토밍](https://www.figma.com/board/PxpdEOfOImqD8jZ3EcrRbR/5%EC%9D%B4%EC%86%8C?node-id=0-1&p=f&t=RMfIBLlg6RNEjK9p-0)
---

## 👥 팀원 소개 및 역할
| 김하민 | 최성준 | 백서희 | 김동글 | 이명지 |
| --- | --- | --- | --- | --- |
| 검색화면 | 메인 화면 | 아이템 상세화면 | 아이디어 기획 | 네트워크 및 소셜 로그인 |
| 검색결과화면 | 메인 상세화면 | 아이템 웹뷰 | 앱 아이콘 디자인 | 데이터베이스 |

---

## 🔧 요구사항
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
  - SnapKit: 코드 기반 오토레이아웃 설정
  - RxSwift/RxCocoa: 반응형 프로그래밍 및 데이터 바인딩
  - Moya: 네트워크 추상화 레이어
  - Kingfisher: 이미지 캐싱 및 로딩
  - Firebase
    - Auth: 사용자 인증
    - Database: 실시간 데이터베이스
  - 소셜 로그인 SDK
    - GoogleSignIn
    - KakaoSDK
    - NaverThirdPartyLogin
    - AuthenticationServices (Apple Login)
#### API
  - Naver Shopping API: 상품 검색 및 정보 제공

---
## 💫 주요 기능
### 🔐 소셜 로그인
- Apple, Google, Kakao, Naver 계정으로 로그인 지원
- Firebase Auth를 통한 통합 인증 시스템
- 자동 로그인 및 로그아웃
- 회원 탈퇴 기능

### 🔍 상품 검색
- 네이버 쇼핑 API 연동을 통한 상품 검색
- 실시간 검색어 기반 상품 목록 제공
- 스와이프 카드 형태의 직관적인 상품 탐색
  - 좌/우 스와이프: 상품 넘기기
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

---
## 📱 시연 영상
🔗 [시연 영상 보러가기](https://youtube.com/shorts/HqwDDmTSEos)
