Jiho
====

概要
----

Let google Home speak at the specified time

Google Homeを定時に喋らせます。
音楽を鳴らすこともできます。

Google Homeを喋らせるコマンドは[yamahei/rubycast](https://github.com/yamahei/rubycast)を使います。
このプロジェクトは定時起動のスクリプトと時報リストの編集UIを提供します。

セットアップ
------------

```
$ git clone https://github.com/yamahei/jiho.git
$ cd jiho
$ bundle install
$ cd cmd
$ git clone https://github.com/yamahei/rubycast.git
$ cd rubycast
$ bundle install
$ cd ..
$ bundle exec ruby app.rb
```
