# Quizcraft

## 概要
Quizcraftはテキストから自動でクイズを作成することができるアプリケーションです。<br>
このアプリケーションを使用することで、ユーザーは簡単にクイズを生成し、覚えておきたい知識の復習に使うことができます。<br>
他のユーザーにシェアして挑戦してもらうこともできます。<br>
レスポンシブ対応しているのでスマホからもご確認いただけます。

![アプリのデモ](https://github.com/Hayate603/QuizCraft/blob/main/quizcraft-ezgif.com-cut.gif?raw=true)

URL: https://quiz-craft-new-6bafbe70ad3e.herokuapp.com/<br>
ヘッダーかタイトルの右側のゲストログインボタンから、メールアドレスとパスワードを入力せずにログインできます。

## 開発の経緯
私は読書が趣味ですが、ただ読むだけでは記憶に残りにくいと感じていました。<br>
調べたところ、クイズ形式で勉強することが記憶の定着に非常に効果的であるとわかりました。[参考リンク](https://yuchrszk.blogspot.com/2016/11/blog-post_30.html)。<br>
確かに読んでいるだけだと、記憶に残っているところと残ってないところが自分で把握しずらいため、クイズ形式で勉強するのは効果的だと思いました。<br>
しかし、資格試験などならともかく、自分が記憶したい内容のクイズは存在しないことが多いため、自分でつくるしかありませんが、作るのに手間がかかるためなかなか手がつきません。学生だったときもノートにしか書いていない内容があったため、簡単にクイズにできたら便利だと思ったことがあります。<br>
このような背景から、自動でクイズを作成し、記憶の定着を助けるツールを作りたいと思い、Quizcraftの開発を始めました。

### 使用技術
- **フレームワーク**: Ruby on Rails 7.1.3.2
- **データベース**: MySQL
- **Webサーバー**: Puma
- **フロントエンド**: Importmap, Turbo, Stimulus, Rails UJS
- **アセット管理**: Sprockets, Sass-Rails
- **認証**: Devise, Omniauth (Google, Facebook)
- **テスト**: RSpec, FactoryBot, Capybara
- **その他**: Google Cloud Vision, Rails-i18n, RQrcode, Ruby-OpenAI
- **コンテナ化**: Docker

## 構成図
![構成図](https://github.com/Hayate603/QuizCraft/blob/main/quizcraft.png?raw=true)

## ER図
![ER図](https://github.com/Hayate603/QuizCraft/blob/main/quizcraft-puml.png?raw=true)


## 機能
- ユーザー登録とログイン機能(devise)
- クイズ作成
- 画像からテキストを抽出
- テキストから自動でクイズ生成
- お気に入り機能
- クイズへの回答,結果表示
- ゲストログイン機能
- ページネーション

## テスト
- RSpec
  - 単体テスト(model)
  - 統合テスト(system)
