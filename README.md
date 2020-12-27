Jiho
====

概要
----

Let google Home speak at the specified time

Google Homeを定時に喋らせます。
音楽を鳴らすこともできます。

Raspberry piで使うことを前提に作っているため、Windows環境では意図的にエラーを出していますのでご注意ください。

![](localhost_4567_index.html.png)

音楽を鳴らす場合は、MP3ファイルへのURLを指定してください。
未確認ですがHTTPSじゃないと鳴らない気がします。。

セットアップ
------------
### Rubyのインストール

Rubyは2.7系以上が無難です。
Bundlerも併せてインストールしてください。

### アプリのインストール

```
$ git clone https://github.com/yamahei/jiho.git
$ cd jiho
$ bundle install
```

### mDNS（avahi-browseコマンド）のインストール

```
$ sudo apt-get install avahi-daemon libnss-mdns avahi-utils
```


起動
----

```
$ bundle exec ruby app.rb
```
[http://localhost:4567/](http://localhost:4567/)で時報編集画面が開きます。
ラズパイで動かしている場合は`localhost`部分はラズパイのIPを指定してください。

----

その他（言い訳）
----------------

### 作り始めた動機

このアプリは、元々[noelportugal/google-home-notifier](https://github.com/noelportugal/google-home-notifier)を改造して作ったアプリ[yamahei/google-home-notifier](https://github.com/yamahei/google-home-notifier)で運用していました。
最近調子が悪いのと、コードの取り回しが良くないので、Rubyで作り直そう、というのが発端です。

### 泥臭い実装

mDNSとCASTV2をクリアしなくてはいけないのですが、情報が少なく、やっと見つけた[julbouln/rubycast](https://github.com/julbouln/rubycast)を元に[yamahei/rubycast](https://github.com/yamahei/rubycast)を作りました。
これはこれで、GoogleHomeの名前を指定してメッセージ（or MP3）を流せるのですが、Eventmachineのネストの問題があり、複数台のGoogleHomeでの運用を解決できず、断念しました。

このため、本アプリもかなり泥臭い実装になっています。
mDNSは[jiho/lib/search_googlehome.rb](https://github.com/yamahei/jiho/blob/main/lib/search_googlehome.rb)でコマンド化、CASTV2は[jiho/lib/send_googlehome.rb](https://github.com/yamahei/jiho/blob/main/lib/send_googlehome.rb)でコマンド化して、別プロセスで動かしています。

### まだ怪しい挙動

ひとまず試験運用落として動かしていますが、テキスト読み上げを連続で投げると喋らなくなったりします。
これはCASTV2の終了処理がイマイチな可能性と、（Text To Speechではなく）Google Translate TTSの応答の可能性があります。