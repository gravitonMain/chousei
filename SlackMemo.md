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

attachmentsを参照してね

### 2. Slack -> Client

届く

### 3. Client -> Slack

クライアントが対応してたらUIが表示されてリクエストをSlackに送る

### 4. Slack -> Server

送られてきたリクエストからSlackが登録されたサーバにリクエストを送信される

### 5. Server -> Slack

リクエストに応じたレスポンスをSlackに送る
chat.updateでやるといい感じ
https://api.slack.com/methods/chat.update

### 6. Slack -> Client

サーバからのレスポンスがClientに送られる

## Slack -> Serverのデータ

リクエストがjsonのpayloadフィールドに文字列にエンコードされて送られてくるので
jsonでパースしてからpayloadフィールドを再度パースする必要がある
actionsに操作が入ってるのでoriginal_messageを編集してoriginal_messageをchat.updateするのがベター
