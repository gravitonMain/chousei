# Interactive Message

## どういう仕組みなのん

送信するメッセージにattachmentsフィールドをつけてボタン等をつける
そのボタン等の操作に対してインタラクティブに反応するための仕組み

1. attachments付きメッセージ -> Slack
  * chat.postMessageやwebhook等で送信する（通常のクライアントでは編集できない）
2. Slack -> Client
  * いい感じのメッセージがクライアントに送られてくる
3. Client -> Slack
  * ボタン等を操作するとその情報がSlackに送られる
4. Slack -> Server
  * 設定されたサーバに押された情報が送られる
5. Server -> Slack
  * 押されたことをメッセージを編集するなどを持ってインタラクションとする
6. Slack -> Client
  * インタラクティブ！

## 具体的に！

### 1. attachments付きメッセージ -> Slack



### 2. Slack -> Client

### 3. Client -> Slack

### 4. Slack -> Server

### 5. Server -> Slack

chat.update
https://api.slack.com/methods/chat.update

### 6. Slack -> Client
