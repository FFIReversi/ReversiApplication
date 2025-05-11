# Reversi

[Demo影片](https://www.youtube.com/embed/FgX16MRQ7Zs?si=RAiHVdWEfGfQ6wVa)\
\
[連線Demo影片](https://www.youtube.com/embed/ZKSD3ewFwKM?si=JzZz08gJUkfuE3fk)
---
## Tech Stack
- 遊戲邏輯: C++
- UI: [Flutter](https://flutter.dev/)
- 整合: [FFI Plugin](https://pub.dev/packages/ffi)
- 後端: Python + WebSocket

## App 編譯方式
### 1. 安裝 Flutter SDK 
[官方安裝教學](https://docs.flutter.dev/get-started/install)
### 2. 安裝所需 Packages
```bash
cd "/Project/ReversiApplication"
flutter pub get
```
### 3. 編譯 Release 檔
因為Flutter跨平台的特性，所以本專案可以在以下平台使用，但在橫向大螢幕裝置上顯示效果較好
- Android
- iOS
- Windows
- macOS
- Linus
- iPadOS
- visionOS (iPadOS的移植)
#### 編譯/打包方式
```bash
flutter build <platform>
```
Platform可以為以下平台
- Windows: `windows`
- macOS: `macos`
- Android: `apk`
[iOS打包方式](https://docs.flutter.dev/deployment/ios)
[Linux打包方式](https://docs.flutter.dev/deployment/linux)
iPadOS 及 visionOS 需使用Xcode打包
iOS若要打包成.ipa格式需有 [Apple Developer Account](https://developer.apple.com/)



## Server 運行方式
1. 安裝所需套件
```bash
pip3 install asyncio websockets
```
2. 開啟 Server
```bash
cd "/Project/Server"
python3 OnlineGameRoomManager.py
```

## 系統架構
![系統架構](https://hackmd.io/_uploads/r1G59l00Jg.png)

## 使用方法及螢幕截圖
### 1. 主畫面
![Home Page](https://github.com/FFIReversi/ReversiApplication/blob/main/UploadedSrc/MainPage.png?raw=true)

**功能按鈕由上到下為**：
- 本機雙人對戰
- 本機 VS 電腦（難度低到高共三種 Level）
- 線上雙人對戰
- 歷史紀錄（讀檔）
- 結束
### 2. 遊戲畫面
![Game Page](https://github.com/FFIReversi/ReversiApplication/blob/main/UploadedSrc/GamePage.png?raw=true)

**功能**：
- 黑子先下，依黑白棋規則完成遊戲
- 畫面右方為黑子及白子的數量，黃色方框為目前玩家
- 每次倒數計時1分鐘，若時間結束之前沒有落子，則由電腦隨機落子（與AI Level 1相同）
- 右下方的Float Action Button分別為重設棋局及返回上一頁
- 若為電腦落子，則在落子點顯示呼吸燈動畫提示玩家
- 黑／白小點為可下位置，根據目前玩家顯示不同顏色
- 滑鼠放置 (Hover) 在可下位置，可以被吃的棋子會出現紅色圓點提示玩家

### 3. 遊戲結束
![Game Finish](https://github.com/FFIReversi/ReversiApplication/blob/main/UploadedSrc/GameFinish.png?raw=true)

**功能**：
- 當遊戲結束時，顯示遊戲結束畫面，並顯示獲勝方
- 若平手，則顯示黑色到白色漸層的旗子
- 下面三個按鈕包含：返回上一頁、重啟棋局及存檔


### 4. 連線對戰
![Join room](https://github.com/FFIReversi/ReversiApplication/blob/main/UploadedSrc/Network.png?raw=true)

**功能**：
- 文字輸入框輸入Room ID
- Join/Create 加入或創建房間
- Back 返回上一頁

![Online Game](https://github.com/FFIReversi/ReversiApplication/blob/main/UploadedSrc/Waiting.png?raw=true)
**功能**:
- 雙方依照黑白棋規則輪流下棋
- 若有一方斷線，棋局自動結束並判斷勝負
- 棋局結束後，自動斷線

### 5. 歷史紀錄（讀檔）
![Previous Game](https://github.com/FFIReversi/ReversiApplication/blob/main/UploadedSrc/PreviousGames.png?raw=true)
**功能**
- 列出所有已儲存的紀錄
- 查看回放或刪除紀錄

### 6. 回放
![Replay](https://github.com/FFIReversi/ReversiApplication/blob/main/UploadedSrc/Replay.png?raw=true)
**功能**
- 查看上一步及下一步
- Auto Mode為每過1秒自動下一步
- 落子後該點會有呼吸燈動畫，方便使用者查看

### 7. 動畫清單
- 頁面切換畫面（下一頁 上一頁）
- 玩家切換，黃色邊框會淡入淡出
- AI落子/回放有黃色呼吸燈效果
- 滑鼠Hover時並滑過棋子時，該棋子有放大縮小動畫
