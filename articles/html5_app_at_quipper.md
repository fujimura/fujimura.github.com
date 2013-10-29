%QuipperでHTML5アプリを作ってる話

##

9月からQuipperという会社で働いています。
今日はリリース前というのに同僚がすごい勢いでブログエントリを書いている。

- [Quipper のスピード感](http://blog.kyanny.me/entry/quipper-sense-of-speed)
- [自分の強みを生かすこと on Quipper](http://mizchi.hatenablog.com/entry/2013/10/22/124107)
- [Github Issues を利用したリリースマネージャのお仕事](http://hakobera.hatenablog.com/entry/2013/10/22/133014)
- [Quipperでのおじさんエンジニアの立ち位置](http://dagezi.hatenablog.com/entry/2013/10/22/135057)

同調圧力に負け、僕も書くことにした。

最近、いわゆるHTML5アプリ(HTML+CSS+JavaScriptのクライアント)を作った。もうすぐリリース。
そこで色々新しいテクノロジーを使ったので、私見を交えつつ簡単にご報告します。

## Chaplin.js

素のBackboneだと、ブートやインスタンス管理の仕組みを作るのが面倒。ここ一年でそれっぽいものを2度作ったので、もうやりたくなかった。
[Chaplin.js](http://chaplinjs.org/)はレールがひいてあり、インスタンス管理も行き届いてる。 Brunchで雛形つくれるのもよかった。

ChaplinはmediatorというApplicatin wideなメッセージングシステムがある。ViewとModelの通信などで大変便利。しかし、これは可読性を一気に下げるえげつないgoto文になるのでほどほどにすべき。

## Brunch

今回のクライアントのコードは、最初はAPI用のRailsアプリにassetとして載せていた。あるときこれをやめた。理由は重いのと、CommonJSがそのままだと使えないこと(ChaplinはCommonJSかRequireJS必須)、あと、本質的じゃないこと。RailsはHTML5アプリ(この呼称間違ってるからやめたい)のアセンブラーではない。Gruntにするか[Brunch](brunch.io)にするか悩み、Chaplinと相性のよいBrunchにした。

## テスト

テストで使ってるライブラリはphantomjs, mocha, chai, sinon, fakerなど。
こんな感じのci用のスクリプトを用意してる。


    #! /bin/sh
    set -e

    export BRUNCH_ENV=ci
    gem install sass --install-dir=./gems
    gem install compass --install-dir=./gems
    npm install brunch
    npm install mocha-phantomjs
    npm install bower
    npm install

    ./node_modules/bower/bin/bower install
    ./node_modules/brunch/bin/brunch build

    ./node_modules/mocha-phantomjs/bin/mocha-phantomjs public/test/index.html

## その他

CoffeeScriptは当然採択。生JavaScriptはきつい。underscore.jsとリスト内包表記でバリバリとリスト操作してる。

テンプレートエンジンはHandlebars、これはHaml系に慣れてないメンバーが多かったから。今考えるとHaml、Jadeなど閉じタグの無いものにすべきだった。Handlebarsはやはり冗長で生産性低い。タグの閉じ忘れにも何度か苦しめられた。

データバインディングはbackbone.stickit。信頼のNew York Timesプロダクト。使いやすく便利なんだけど、APIや仕様との相性の都合もあって、ちょっとしか使ってない。

CSSはScssで書いた。BEMなどのメソドロジーは使ってない。色は `_colors.scss` 内に書いた変数で管理、ボタン用のmixinを使うなど、よくある感じです。今考えるとTwitter Bootstrapを使えばよかったと思う。

jQuery.Deferredを多用した。パフォーマンス向上、可読性アップ、描画タイミングを揃えて見栄えを良くする、画像先読みなど大活躍だった。

フロントエンドのライブラリはbowerで管理。ただfont-awesomeなど例外はある。


## まとめ

Chaplin.jsはなかなか良いです。もう素のBackbone.jsは書きたくない。

API*2 + clientを一度に動かすrake taskとかも書いたので、いつか紹介したい。まじ辛かった。

個人的にはそろそろWeb API書きたいなーとも思います。

あと、プロジェクトの合間にHaskellで`bundle gem`、`grunt init`的なことをする[hi](https://github.com/fujimura/hi)ってライブラリを書いたので、試してみてね！

エンジニアも募集してるので、面白いなーと思ったら、[こちら](http://www.quipper.com/japan/careers)か[僕](twitter.com/ffu_)までご連絡ください。
