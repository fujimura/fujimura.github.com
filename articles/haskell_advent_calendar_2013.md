%Haskellプロジェクトのひな形生成ツールを作った

##

みなさん、Haskellで新しく何かを書き始める時ってどうしてますか。最近の定番ディレクトリ構成は`/src`にコード、`/test`にテストコードってパターンが多いですね。それ自作するの、辛くないですか。

数ヶ月前に何かを作ろうと思い`cabal init`を実行した時、「もう自分で`/src`と`/test`ディレクトリ作って`/test/Spec.hs`書くのはウンザリ」と感じ、作ろうとしていた何かをそっちのけでHaskellプロジェクトのひな形生成ツールを作り始めました。それが[hi](https://github.com/fujimura/hi)です。

例えばRubyだと[bundler](http://bundler.io)というライブラリを使って、下記のように新しいプロジェクトを生成できます。

```
$ bundle gem foo
      create  foo/Gemfile
      create  foo/Rakefile
      create  foo/LICENSE.txt
      create  foo/README.md
      create  foo/.gitignore
      create  foo/foo.gemspec
      create  foo/lib/foo.rb
      create  foo/lib/foo/version.rb
Initializating git repo in /Users/fujimura/foo
```

こういうものを作りたいと思ったわけです。色々考えた結果、下記のようなデザインにすることにしました。

- 対話式インターフェース無し
- できるだけ少ないオプション
- 複数テンプレートをサポート
- テンプレートはgitリポジトリ形式の指定
- 設定ファイルで可能

テンプレートをgitリポジトリにするあたりは[grunt-init](http://gruntjs.com/project-scaffolding)というJavaScriptのライブラリを参考にしました。対話式インターフェース無し、少ないオプションなどは僕の趣味です。

結果的に、こんな感じで新しいプロジェクトを生成できるようになりました。
テストをHspecで書く場合の定番ディレクトリ構成をデフォルトテンプレートにしています。

```
$ hi --package-name "foo-bar-baz" --module-name "Foo.Bar.Baz"
Creating new project from repository: git://github.com/fujimura/hi-hspec.git
    create  foo-bar-baz/.gitignore
    create  foo-bar-baz/LICENSE
    create  foo-bar-baz/README.md
    create  foo-bar-baz/foo-bar-baz.cabal
    create  foo-bar-baz/src/Foo/Bar/Baz.hs
    create  foo-bar-baz/src/Foo/Bar/Baz/Internal.hs
    create  foo-bar-baz/test/Foo/Bar/BazSpec.hs
    create  foo-bar-baz/test/Spec.hs
```

もちろんビルド可能です。失敗するテストケースを一件入れてあります。

```
$ cabal test
Building foo-bar-baz-0.0.0...
Preprocessing library foo-bar-baz-0.0.0...
In-place registering foo-bar-baz-0.0.0...
Preprocessing test suite 'spec' for foo-bar-baz-0.0.0...
Running 1 test suites...
Test suite spec: RUNNING...

Foo.Bar.Baz
  someFunction
    - should work fine FAILED [1]

1) Foo.Bar.Baz.someFunction should work fine
expected: False
 but got: True

Randomized with seed 4611685480328648939

Finished in 0.0003 seconds
1 example, 1 failure
Test suite spec: FAIL
Test suite logged to: dist/test/foo-bar-baz-0.0.0-spec.log
0 of 1 test suites (0 of 1 test cases) passed.
```

テスト無し、フラットなディレクトリ構成のテンプレートもあります。

```
$ hi-m Bar -p bar -r git@github.com:fujimura/hi-flat.git
Creating new project from repository: git@github.com:fujimura/hi-flat.git
    create  bar/.gitignore
    create  bar/LICENSE
    create  bar/Main.hs
    create  bar/Bar.hs
    create  bar/README.md
    create  bar/bar.cabal
```

テンプレートは自作可能です。[Making your own project template](https://github.com/fujimura/hi#making-your-own-project-template)を参照ください。

以下、実装時のこぼれ話です。

コーディング規約は[tibbe/haskell-style-guide](https://github.com/tibbe/haskell-style-guide)を踏襲しました。が、あんまり厳密にはやっていません。いわゆる[full import](http://d.hatena.ne.jp/camlspotter/20101212/1292165692)はしないようにしています。自分で書いたコードを読むにあたっても圧倒的にわかりやすかった。

Hackageには、tarballを作ってcabalのコマンドからアップロードするのですが、その前に一応出来たものが正しく動くかテストを実行したいところです。一連の作業をやってくれる[便利なスクリプト](https://github.com/hspec/hspec/blob/7e67dc4918781f1c57aea17836ea8f35f8a0bf72/mk-sdist.sh)がHspecのリポジトリにあったので有難く真似させて頂きました。

エディタはVimを使っています。[ghc-mod](https://github.com/kazu-yamamoto/ghc-mod) + [syntastic](https://github.com/scrooloose/syntastic)で保存されたらコンパイルしてエラーがあれば表示されるようにしてます。あと[stylish-haskell](https://github.com/jaspervdj/stylish-haskell)でコードのフォーマットをしてます。これは[Vimからで実行できます](https://github.com/jaspervdj/stylish-haskell#vim-integration)。

最初スケッチ的な実装をした後、TDDで書き直しました。私、Haskellで関数ごとに細かいユニットテストをするのは割に合わないという認識でして、今回はいちばん外側からのみテストする戦略をとりました。具体的にはテスト用ディレクトリの中で実際に`$ hi`を実行し、結果を検証するという方法です。テスト後のディレクトリのお掃除などは自分で頑張っていたのですが([bracket_](http://hackage.haskell.org/package/base-4.6.0.1/docs/Control-Exception.html#v:bracket_)を使えばOK)、途中でHspecに[before](http://hackage.haskell.org/package/hspec-1.7.2.1/docs/Test-Hspec.html#v:before)などが入ったのでそれを使いました。タイミング良かった。最終的にはメインの関数だけは個別にテストするようにしました[*](https://github.com/fujimura/hi/blob/b8531241ea796b24dd7075b817d48a5af8d4d315/test/HiSpec.hs)。言うまでもなくこの戦略だと並列実行するとテストがコケるのでそこは残念です。今後は外側からのテストは最小限にしたい。

他にも色々な苦労と迷走がありました。モジュール構成が変、テンプレートに依存したテストケースが多い、など未解決のしょぼいポイントも多々あります。追加予定の機能もいくつか。興味がある方はコードを読んでみてください。リポジトリは[https://github.com/fujimura/hi](https://github.com/fujimura/hi)です。
