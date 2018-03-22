# Gemfile

`ruby "2.4.0"`
みたいに書いておかないといけない？


# Procfile

foremanで使うやつ
プロセス管理できるとか

`<process type>: <command>`

```
web: bundle exec ruby app.rb -p $PORT
```


# Config.ru

Rackで使うやつ

```
require_relative 'app.rb'

run Sinatra::Application
```

がいる？
なくてもherokuでは動いてるのでなくてもいいのかもしれない


# heroku

1. heroku login
2. heroku create
3. heroku config:set SLACK_API_TOKEN=...
4. git remote heroku master
5. git push heroku master
