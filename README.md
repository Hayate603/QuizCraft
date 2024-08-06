# Quizcraft

## 概要
Quizcraftはテキストから自動でクイズを作成することができるアプリケーションです。<br>
このアプリケーションを使用することで、ユーザーは簡単にクイズを生成し、覚えておきたい知識の復習に使うことができます。<br>
他のユーザーにシェアして挑戦してもらうこともできます。<br>
レスポンシブ対応しているのでスマホからもご確認いただけます。

URL: https://quiz-craft-new-6bafbe70ad3e.herokuapp.com/<br>
ヘッダーかタイトルの右側のゲストログインボタンから、メールアドレスとパスワードを入力せずにログインできます。

## 使い方と機能

### ゲストログイン
![ゲストログイン](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E3%82%B1%E3%82%99%E3%82%B9%E3%83%88%E3%83%AD%E3%82%AF%E3%82%99%E3%82%A4%E3%83%B3.png?raw=true)

ゲストログインボタンをクリックすることで、登録せずにアプリの機能を試すことができます。<br>
メールアドレスで登録する場合はメールでアカウント有効化する必要があります。<br>
ゲストログインではアカウント情報更新機能以外は試すことができます。

### ページの説明
![ページの説明](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E3%83%AD%E3%82%AF%E3%82%99%E3%82%A4%E3%83%B3%E5%BE%8C%E3%83%98%E3%83%83%E3%82%BF%E3%82%99%E3%83%BC.png?raw=true)

QuizCraftをクリックするとホームページ兼クイズ一覧のページにいきます。<br>
マイクイズは自分で作成したクイズの一覧ページです。<br>
お気に入りはお気に入りしたクイズの一覧ページです。

### クイズの作成
![クイズの作成](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E6%96%B0%E3%81%97%E3%81%84%E3%82%AF%E3%82%A4%E3%82%B9%E3%82%99.png?raw=true) ![クイズ作成](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E3%82%AF%E3%82%A4%E3%82%B9%E3%82%99%E4%BD%9C%E6%88%90.png?raw=true)

「クイズ作成」ボタンから新しいクイズを作成するページに行けます。<br>
クイズのタイトルの入力は必須です。説明は任意です。<br>
入力が終わったら、クイズ作成ボタンを押します。

### 新しい質問を追加
![新しい質問を追加](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E6%96%B0%E3%81%97%E3%81%84%E8%B3%AA%E5%95%8F%E3%82%92%E8%BF%BD%E5%8A%A0.png?raw=true)

クイズ詳細ページの「質問を追加」ボタンをクリックすることで質問作成画面にいけます。

### 画像からテキストに変換してクイズ作成
![画像からテキストに変換](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/quizcraft-ezgif.com-cut.gif?raw=true)

画像を選択して「画像からテキストを抽出」ボタンを押すことで画像からテキストを抽出できます。<br>
「ChatGPTで質問を作成」ボタンを押すこと抽出したテキストからクイズが作成されフォームに入力された形式で返ってきます。

### 質問を作成ボタンを押す
![質問を作成](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E8%B3%AA%E5%95%8F%E3%82%92%E4%BD%9C%E6%88%90.gif?raw=true)

フォームに入力されたテキストを編集する必要があれば編集し、「質問を作成」ボタン、または「すべての質問を作成」ボタンを押してクイズを完成させます。<br>
「質問を作成」ボタンは個別に質問を作成するボタンです。<br>
「すべての質問を作成」ボタンはすべてのフォームの質問を作成するボタンです。押すと入力に問題がない質問は作成され、入力に問題があるところにはエラーが表示されます。

### クイズ形式の選択とクイズ開始
![クイズ形式の選択](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E6%8E%A1%E7%82%B9%E5%BD%A2%E5%BC%8F.png?raw=true)

クイズ詳細ページの「クイズの形式」でクイズの形式を選択できます。<br>
選択肢には「自己採点形式」と「入力形式」があります。<br>
「クイズを実行する」ボタンからクイズを開始できます。

### 自己採点形式
![自己採点形式](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E8%87%AA%E5%B7%B1%E6%8E%A1%E7%82%B9%E7%AD%94%E3%81%88%E6%9C%AA%E8%A1%A8%E7%A4%BA.png?raw=true) ![自己採点形式](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E8%87%AA%E5%B7%B1%E6%8E%A1%E7%82%B9%E7%AD%94%E3%81%88%E8%A1%A8%E7%A4%BA.png?raw=true)

自己採点形式では自分で回答を考えたあとに、「答えを見る」を押して答えを確認して正解、不正解を選択して自己採点をしてきます。

### 入力形式
![入力形式](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E5%85%A5%E5%8A%9B%E5%BD%A2%E5%BC%8F.png?raw=true)

ユーザーが直接答えを入力していく形式のクイズです。<br>
完全に一致しないと不正解となってしまうので自己採点形式のほうがおすすめです。

### クイズ結果の表示
![クイズ結果の表示](https://github.com/Hayate603/QuizCraft/blob/fix/data-and-readme/%E3%82%AF%E3%82%A4%E3%82%B9%E3%82%99%E7%B5%90%E6%9E%9C%E8%A1%A8%E7%A4%BA.png?raw=true)

クイズが終了するとクイズの結果が表示されます。

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

## 追加中または追加予定の機能・技術
- **カテゴリ機能**: クイズをカテゴリ別に分類し、ユーザーが興味のある分野からクイズを選びやすくする。
- **検索機能**: クイズや質問をキーワードで検索できるようにする。
- **過去のクイズの結果を確認できる機能**: ユーザーが以前に回答したクイズの結果をいつでも確認できるようにする。
- **別のクイズの質問から新たにクイズを作れる機能**: 間違えやすい問題をまとめて新しいクイズを作成できるようにする。
- **CircleCI**: 継続的インテグレーション/デリバリーを導入し、テストとデプロイを自動化する。
- **AWS**: クラウドインフラストラクチャを使用してアプリケーションをホスティングし、スケーラビリティを向上させる。
