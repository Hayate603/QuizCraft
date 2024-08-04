# Quizcraft

## 概要
Quizcraftはテキストから自動でクイズを作成するアプリケーションです。
このアプリケーションを使用することで、ユーザーは簡単にクイズを生成し、他のユーザーにシェアして挑戦してもらうことができます。
レスポンシブ対応しているのでスマホからもご確認いただけます。

![アプリのデモ](https://github.com/Hayate603/QuizCraft/blob/docs/readme/quizcraft-ezgif.com-cut.gif?raw=true)

URL: https://quiz-craft-new-6bafbe70ad3e.herokuapp.com/<br>
ヘッダーかタイトルの右側のゲストログインボタンから、メールアドレスとパスワードを入力せずにログインできます。

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
![構成図](https://github.com/Hayate603/QuizCraft/blob/docs/readme/quizcraft.png?raw=true)

## ER図
![ER図](https://github.com/Hayate603/QuizCraft/blob/docs/readme/quizcraft-puml.png?raw=true)


## 機能
- ユーザー登録とログイン機能(devise)
- クイズ作成
- 画像からテキストを抽出
- テキストから自動でクイズ生成
- お気に入り機能
- クイズへの回答,結果表示
- ゲストログイン機能

## テスト
- RSpec
  - 単体テスト(model)
  - 統合テスト(system)
