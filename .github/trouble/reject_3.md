### 4️⃣ AppStore 심사 거절 이슈: 구글 로그인 문제
## 📝 문제
- 1.0 버전 출시 과정에서 구글 로그인 시 크래시가 발생해 3차 심사 거절 통보를 받음.
    
<img width="600" src="https://github.com/user-attachments/assets/49faa968-0077-4210-9e3d-1f079219aaa3">

## 🎯 원인
- 구글 로그인을 하면 앱 크래시 발생.

## ⚡️ 해결방안
- Firebase에서 새로운 GoogleService-Info.plist를 발급 받았는데, Xcode info.plist에서는 이전 URLScheme을 사용하고 있었음.
- info.plist의 URLScheme를 최신 버전으로 수정함.
- 2차와 동일하게 답신과 구글 로그인이 잘 작동하는 영상을 첨부해서 보냄.

<img width="800" src="https://github.com/user-attachments/assets/765b0973-3584-4aea-846b-7b6c075d83d2">

## ✅ 결과
- 출시 성공.
