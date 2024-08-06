# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ゲストユーザーを作成
guest_user = User.create!(
  email: 'guest@example.com',
  password: 'guestpassword',
  confirmed_at: Time.zone.now
)

# ゲストユーザーを配列に追加
users = [guest_user]

# 他のユーザーを作成
4.times do |n|
  users << User.create!(
    email: "user#{n + 1}@example.com",
    password: 'password',
    confirmed_at: Time.zone.now
  )
end

# 全てのクイズデータを準備
all_quizzes = [
  {
    title: "ファンタジーの世界",
    description: "ファンタジー世界に関するクイズです。",
    questions: [
      { question_text: "ドラゴンの弱点は何ですか？", correct_answer: "水" },
      { question_text: "エルフの特徴は何ですか？", correct_answer: "尖った耳" },
      { question_text: "魔法使いがよく使う杖の素材は？", correct_answer: "オークの木" },
      { question_text: "ファンタジー作品でよく見られる生き物は？", correct_answer: "ユニコーン" },
      { question_text: "中世ファンタジーの舞台によく登場する場所は？", correct_answer: "城" },
      { question_text: "ドラゴンが守る宝物は何？", correct_answer: "金銀財宝" },
      { question_text: "魔法使いの帽子の特徴は？", correct_answer: "尖っている" },
      { question_text: "ドラゴンが住むとされる場所は？", correct_answer: "山" },
      { question_text: "ファンタジー作品で登場する魔法の剣の名前は？", correct_answer: "エクスカリバー" },
      { question_text: "ゴブリンの特性は？", correct_answer: "小柄でずる賢い" }
    ]
  },
  {
    title: "映画トリビア",
    description: "映画に関するトリビアを問うクイズです。",
    questions: [
      { question_text: "『バック・トゥ・ザ・フューチャー』の主人公の名前は？", correct_answer: "マーティ・マクフライ" },
      { question_text: "『スター・ウォーズ』の製作者は？", correct_answer: "ジョージ・ルーカス" },
      { question_text: "『ゴッドファーザー』の原作者は誰？", correct_answer: "マリオ・プーゾ" },
      { question_text: "『タイタニック』のヒロインの名前は？", correct_answer: "ローズ" },
      { question_text: "『インセプション』のテーマは？", correct_answer: "夢の中の夢" },
      { question_text: "『アバター』の舞台はどこ？", correct_answer: "パンドラ" },
      { question_text: "『ハリー・ポッター』でハリーの敵役の名前は？", correct_answer: "ヴォルデモート" },
      { question_text: "『ジュラシック・パーク』で復活した動物は？", correct_answer: "恐竜" },
      { question_text: "『ロード・オブ・ザ・リング』で指輪を運ぶのは誰？", correct_answer: "フロド・バギンズ" },
      { question_text: "『マトリックス』の主人公の名前は？", correct_answer: "ネオ" },
      { question_text: "『ゴーストバスターズ』の職業は？", correct_answer: "幽霊退治" },
      { question_text: "『ET』で少年がETにあげたお菓子は？", correct_answer: "M&M's" }
    ]
  },
  {
    title: "音楽の歴史",
    description: "音楽の歴史と名曲に関するクイズです。",
    questions: [
      { question_text: "ビートルズのメンバーで唯一左利きだったのは誰？", correct_answer: "ポール・マッカートニー" },
      { question_text: "モーツァルトの出身国は？", correct_answer: "オーストリア" },
      { question_text: "『レクイエム』を作曲したのは誰？", correct_answer: "モーツァルト" },
      { question_text: "クラシック音楽で「四季」を作曲したのは誰？", correct_answer: "ヴィヴァルディ" },
      { question_text: "『ボレロ』を作曲したのは誰？", correct_answer: "ラヴェル" },
      { question_text: "『カーペンターズ』の代表曲は？", correct_answer: "Top of the World" },
      { question_text: "エルヴィス・プレスリーのニックネームは？", correct_answer: "ロックンロールの王" },
      { question_text: "ビートルズのデビューアルバムのタイトルは？", correct_answer: "Please Please Me" },
      { question_text: "『ムーンライト・ソナタ』を作曲したのは誰？", correct_answer: "ベートーヴェン" },
      { question_text: "マイケル・ジャクソンの愛称は？", correct_answer: "キング・オブ・ポップ" }
    ]
  },
  {
    title: "サッカーの基本",
    description: "サッカーの基本知識を問うクイズです。",
    questions: [
      { question_text: "サッカーで一試合の時間は何分ですか？", correct_answer: "90分" },
      { question_text: "ワールドカップが開催される周期は何年ごと？", correct_answer: "4年" },
      { question_text: "サッカーのフィールドの広さは最大何メートル？", correct_answer: "120メートル" },
      { question_text: "サッカーボールの直径は約何センチ？", correct_answer: "22センチ" },
      { question_text: "オフサイドが成立する条件は？", correct_answer: "相手ゴールに最も近いプレイヤーがボールを受けるときに前にいる" },
      { question_text: "FIFAとは何の略？", correct_answer: "Fédération Internationale de Football Association" },
      { question_text: "ペナルティキックの距離は？", correct_answer: "11メートル" },
      { question_text: "サッカーの主審は何人いる？", correct_answer: "1人" },
      { question_text: "サッカーでのハットトリックとは？", correct_answer: "1試合で3ゴールを決めること" }
    ]
  },
  {
    title: "料理知識テスト",
    description: "料理に関する知識を問うクイズです。",
    questions: [
      { question_text: "イタリアの代表的なパスタ料理は？", correct_answer: "スパゲッティ" },
      { question_text: "和食でよく使われる調味料は？", correct_answer: "醤油" },
      { question_text: "フランス料理で使われるバターの種類は？", correct_answer: "無塩バター" },
      { question_text: "インドの代表的なカレー料理は？", correct_answer: "チキンカレー" },
      { question_text: "メキシコ料理で使われるトウモロコシの粉は何と呼ばれる？", correct_answer: "マサ" },
      { question_text: "和食の伝統的なスープは？", correct_answer: "味噌汁" },
      { question_text: "中国料理でよく使われる香辛料は？", correct_answer: "五香粉" },
      { question_text: "イタリア料理でトマトとバジルを使ったパスタは何？", correct_answer: "ペペロンチーノ" },
      { question_text: "日本の伝統的な朝食には何が含まれる？", correct_answer: "ご飯、味噌汁、魚" }
    ]
  },
  {
    title: "文学の世界",
    description: "世界の有名な文学作品に関するクイズです。",
    questions: [
      { question_text: "『ハムレット』を書いたのは誰？", correct_answer: "シェイクスピア" },
      { question_text: "『赤毛のアン』の舞台はどこの国？", correct_answer: "カナダ" },
      { question_text: "『ドリアン・グレイの肖像』の著者は？", correct_answer: "オスカー・ワイルド" },
      { question_text: "『大いなる遺産』の著者は？", correct_answer: "チャールズ・ディケンズ" },
      { question_text: "『パラダイス・ロスト』の著者は？", correct_answer: "ジョン・ミルトン" },
      { question_text: "『戦争と平和』の著者は？", correct_answer: "レフ・トルストイ" },
      { question_text: "『百年の孤独』の著者は？", correct_answer: "ガブリエル・ガルシア・マルケス" },
      { question_text: "『アリス・イン・ワンダーランド』の作者は？", correct_answer: "ルイス・キャロル" },
      { question_text: "『オデュッセイア』の主人公は？", correct_answer: "オデュッセウス" }
    ]
  },
  {
    title: "世界史の基本",
    description: "世界の歴史に関する基本的な知識を問うクイズです。",
    questions: [
      { question_text: "ナポレオンが生まれた国は？", correct_answer: "フランス" },
      { question_text: "アメリカ独立宣言が採択された年は？", correct_answer: "1776年" },
      { question_text: "ローマ帝国が分裂したのは何年？", correct_answer: "395年" },
      { question_text: "世界初の印刷本が出版された国は？", correct_answer: "ドイツ" },
      { question_text: "ルネサンスの始まりはどの国？", correct_answer: "イタリア" },
      { question_text: "冷戦が終結した年は？", correct_answer: "1991年" },
      { question_text: "第一次世界大戦が勃発した年は？", correct_answer: "1914年" },
      { question_text: "第二次世界大戦が終結した年は？", correct_answer: "1945年" },
      { question_text: "中国で長城が建設されたのは何朝？", correct_answer: "秦朝" },
      { question_text: "ナチス・ドイツの指導者は？", correct_answer: "アドルフ・ヒトラー" },
      { question_text: "ソ連の初代指導者は？", correct_answer: "レーニン" }
    ]
  },
  {
    title: "アニメの知識",
    description: "人気アニメに関する知識を問うクイズです。",
    questions: [
      { question_text: "『進撃の巨人』の主人公の名前は？", correct_answer: "エレン・イェーガー" },
      { question_text: "『ナルト』の主人公が持つ尾獣の名前は？", correct_answer: "九尾" },
      { question_text: "『ドラゴンボール』の主人公の名前は？", correct_answer: "孫悟空" },
      { question_text: "『ワンピース』の主人公の夢は？", correct_answer: "海賊王になること" },
      { question_text: "『名探偵コナン』の主人公が飲んだ薬の名前は？", correct_answer: "APTX4869" },
      { question_text: "『セーラームーン』の変身後の名前は？", correct_answer: "セーラームーン" },
      { question_text: "『エヴァンゲリオン』でシンジが操縦するエヴァの番号は？", correct_answer: "初号機" },
      { question_text: "『ポケットモンスター』の主人公のパートナーは？", correct_answer: "ピカチュウ" },
      { question_text: "『デスノート』で主人公が使うノートの名前は？", correct_answer: "デスノート" },
      { question_text: "『銀魂』の主人公の名前は？", correct_answer: "坂田銀時" },
      { question_text: "『コードギアス』の主人公の名前は？", correct_answer: "ルルーシュ" },
      { question_text: "『攻殻機動隊』の主人公の名前は？", correct_answer: "草薙素子" }
    ]
  },
  {
    title: "動物の豆知識",
    description: "動物に関する豆知識を問うクイズです。",
    questions: [
      { question_text: "世界最大の鳥は？", correct_answer: "ダチョウ" },
      { question_text: "最も長寿な哺乳類は？", correct_answer: "ゾウ" },
      { question_text: "海で最も大きな哺乳類は？", correct_answer: "シロナガスクジラ" },
      { question_text: "陸上で最も速い動物は？", correct_answer: "チーター" },
      { question_text: "砂漠に住む動物で水分を体内に蓄えるのは？", correct_answer: "ラクダ" },
      { question_text: "コアラが主に食べる植物は？", correct_answer: "ユーカリ" },
      { question_text: "パンダの食事の主成分は？", correct_answer: "竹" },
      { question_text: "シマウマの模様の特徴は？", correct_answer: "縦縞" },
      { question_text: "フクロウが夜行性である理由は？", correct_answer: "夜間に獲物を捕まえるため" },
      { question_text: "カンガルーが持つ特別な器官は？", correct_answer: "育児嚢" }
    ]
  },
  {
    title: "植物の世界",
    description: "植物に関する知識を問うクイズです。",
    questions: [
      { question_text: "日本で最も広く栽培されている果物は？", correct_answer: "りんご" },
      { question_text: "コーヒー豆は何の植物の種子？", correct_answer: "コーヒーの木" },
      { question_text: "日本の国花は？", correct_answer: "桜" },
      { question_text: "最も高く育つ木は？", correct_answer: "セコイア" },
      { question_text: "サボテンが乾燥地帯で生き残るために進化したものは？", correct_answer: "水を蓄える能力" },
      { question_text: "竹は植物のどの部分で成長する？", correct_answer: "根" },
      { question_text: "ジャガイモはどの部分が食べられる？", correct_answer: "地下茎" },
      { question_text: "ラベンダーの花の色は？", correct_answer: "紫" },
      { question_text: "最も早く成長する草は？", correct_answer: "竹" }
    ]
  },
  {
    title: "宇宙の神秘",
    description: "宇宙に関する知識を問うクイズです。",
    questions: [
      { question_text: "太陽系で最も大きな惑星は？", correct_answer: "木星" },
      { question_text: "最も近い星系は？", correct_answer: "アルファ・ケンタウリ" },
      { question_text: "太陽に最も近い惑星は？", correct_answer: "水星" },
      { question_text: "地球の唯一の天然衛星は？", correct_answer: "月" },
      { question_text: "火星の空は何色？", correct_answer: "赤" },
      { question_text: "月面にはどんな特徴的な地形がある？", correct_answer: "クレーター" },
      { question_text: "ブラックホールの中心部は何と呼ばれる？", correct_answer: "特異点" },
      { question_text: "宇宙で最も一般的な元素は？", correct_answer: "水素" },
      { question_text: "銀河系の中心には何があるとされている？", correct_answer: "超大質量ブラックホール" }
    ]
  },
  {
    title: "数学の基礎",
    description: "数学の基本的な問題を問うクイズです。",
    questions: [
      { question_text: "円の面積を求める公式は？", correct_answer: "πr²" },
      { question_text: "ピタゴラスの定理は何の定理？", correct_answer: "直角三角形" },
      { question_text: "3.1415は何の数？", correct_answer: "円周率" },
      { question_text: "2の10乗は？", correct_answer: "1024" },
      { question_text: "直線の方程式は？", correct_answer: "y=mx+b" },
      { question_text: "確率の範囲は？", correct_answer: "0から1" },
      { question_text: "2次方程式の解の公式は？", correct_answer: "-b±√(b²-4ac)/2a" },
      { question_text: "三角形の内角の和は？", correct_answer: "180度" },
      { question_text: "直角を作る角度は？", correct_answer: "90度" }
    ]
  },
  {
    title: "テクノロジーの進化",
    description: "テクノロジーとその進化に関するクイズです。",
    questions: [
      { question_text: "最初のパソコンはどこで作られた？", correct_answer: "アメリカ" },
      { question_text: "スマートフォンの普及が始まったのは何年頃？", correct_answer: "2007年" },
      { question_text: "インターネットの発明者は？", correct_answer: "ティム・バーナーズ＝リー" },
      { question_text: "最初の商用メールサービスは何年に開始された？", correct_answer: "1971年" },
      { question_text: "ビデオゲームの最初の家庭用コンソールは？", correct_answer: "アタリ" },
      { question_text: "ソーシャルメディアの黎明期を代表するサイトは？", correct_answer: "MySpace" },
      { question_text: "最初のスマートウォッチはどこで開発された？", correct_answer: "日本" },
      { question_text: "クラウドコンピューティングが一般化したのは何年代？", correct_answer: "2000年代" },
      { question_text: "人工知能の基礎を築いた数学者は？", correct_answer: "アラン・チューリング" }
    ]
  },
  {
    title: "芸術の歴史",
    description: "芸術とその歴史に関するクイズです。",
    questions: [
      { question_text: "『モナリザ』を描いた画家は？", correct_answer: "レオナルド・ダ・ヴィンチ" },
      { question_text: "ピカソの代表的な作風は？", correct_answer: "キュビズム" },
      { question_text: "印象派を代表する画家は？", correct_answer: "クロード・モネ" },
      { question_text: "『ひまわり』を描いた画家は？", correct_answer: "フィンセント・ファン・ゴッホ" },
      { question_text: "『最後の晩餐』を描いたのは？", correct_answer: "レオナルド・ダ・ヴィンチ" },
      { question_text: "『考える人』を作った彫刻家は？", correct_answer: "オーギュスト・ロダン" },
      { question_text: "『ゲルニカ』はどの戦争を描いた作品？", correct_answer: "スペイン内戦" },
      { question_text: "ルネサンス期の彫刻家で有名なのは？", correct_answer: "ミケランジェロ" },
      { question_text: "シュルレアリスムの代表的な画家は？", correct_answer: "サルバドール・ダリ" }
    ]
  },
  {
    title: "言語の起源",
    description: "言語に関するクイズです。",
    questions: [
      { question_text: "英語はどこの国の言語？", correct_answer: "イギリス" },
      { question_text: "フランス語で「ありがとう」は？", correct_answer: "メルシー" },
      { question_text: "スペイン語で「おはよう」は？", correct_answer: "ブエノス・ディアス" },
      { question_text: "イタリア語で「愛」は？", correct_answer: "アモーレ" },
      { question_text: "ドイツ語で「ビール」は？", correct_answer: "ビア" },
      { question_text: "中国語で「こんにちは」は？", correct_answer: "ニーハオ" },
      { question_text: "韓国語で「ありがとう」は？", correct_answer: "カムサハムニダ" },
      { question_text: "日本語で「お元気ですか？」", correct_answer: "お元気ですか？" },
      { question_text: "ポルトガル語で「乾杯」は？", correct_answer: "サウデ" }
    ]
  },
  {
    title: "日本の伝統文化",
    description: "日本の伝統文化に関するクイズです。",
    questions: [
      { question_text: "茶道の発祥地は？", correct_answer: "日本" },
      { question_text: "桜の名所として有名な都市は？", correct_answer: "京都" },
      { question_text: "日本の伝統的な衣装は？", correct_answer: "着物" },
      { question_text: "日本の武士が使用した武器は？", correct_answer: "刀" },
      { question_text: "日本の伝統的な舞踊は？", correct_answer: "能" },
      { question_text: "日本の三味線音楽のジャンルは？", correct_answer: "津軽三味線" },
      { question_text: "茶道で使われるお茶は？", correct_answer: "抹茶" },
      { question_text: "日本の伝統的な絵画技法は？", correct_answer: "浮世絵" },
      { question_text: "日本の伝統的な夏祭りは？", correct_answer: "盆踊り" }
    ]
  },
  {
    title: "現代のポップカルチャー",
    description: "現代のポップカルチャーに関するクイズです。",
    questions: [
      { question_text: "『アベンジャーズ』シリーズの最初の作品は？", correct_answer: "アイアンマン" },
      { question_text: "『ゲーム・オブ・スローンズ』の原作者は？", correct_answer: "ジョージ・R・R・マーティン" },
      { question_text: "『ハリー・ポッター』シリーズの主人公の名前は？", correct_answer: "ハリー・ポッター" },
      { question_text: "『ストレンジャー・シングス』の舞台は？", correct_answer: "ホーキンス" },
      { question_text: "『ブレイキング・バッド』の主人公の職業は？", correct_answer: "化学教師" },
      { question_text: "『マーベル・シネマティック・ユニバース』に登場するキャプテンは？", correct_answer: "キャプテン・アメリカ" },
      { question_text: "『ビッグバン・セオリー』の登場人物の職業は？", correct_answer: "物理学者" },
      { question_text: "『ダークナイト』でバットマンが対峙する敵は？", correct_answer: "ジョーカー" },
      { question_text: "『ホビット』シリーズの舞台は？", correct_answer: "中つ国" }
    ]
  },
  {
    title: "旅行と観光",
    description: "世界の旅行と観光に関するクイズです。",
    questions: [
      { question_text: "エッフェル塔がある都市は？", correct_answer: "パリ" },
      { question_text: "世界で最も訪問されている観光地は？", correct_answer: "タイムズスクエア" },
      { question_text: "日本の首都は？", correct_answer: "東京" },
      { question_text: "アメリカの自由の女神像がある都市は？", correct_answer: "ニューヨーク" },
      { question_text: "オーストラリアの有名な建築物は？", correct_answer: "オペラハウス" },
      { question_text: "中国の長城はどれくらいの長さ？", correct_answer: "21,196キロメートル" },
      { question_text: "エジプトのピラミッドはどこの砂漠にある？", correct_answer: "サハラ砂漠" },
      { question_text: "イタリアのピサの斜塔がある都市は？", correct_answer: "ピサ" },
      { question_text: "ブラジルのカーニバルで有名な都市は？", correct_answer: "リオデジャネイロ" },
      { question_text: "インドのタージ・マハルはどこにある？", correct_answer: "アーグラ" }
    ]
  },
  {
    title: "食べ物と飲み物",
    description: "世界の食べ物と飲み物に関するクイズです。",
    questions: [
      { question_text: "イタリアの代表的な料理は？", correct_answer: "ピザ" },
      { question_text: "フランスの伝統的なパンの名前は？", correct_answer: "バゲット" },
      { question_text: "日本の伝統的な飲み物は？", correct_answer: "日本酒" },
      { question_text: "中国の有名な紅茶は？", correct_answer: "プーアル茶" },
      { question_text: "アメリカの人気ファーストフードは？", correct_answer: "ハンバーガー" },
      { question_text: "イギリスのアフタヌーンティーでよく出されるお菓子は？", correct_answer: "スコーン" },
      { question_text: "インドの代表的な飲み物は？", correct_answer: "チャイ" },
      { question_text: "メキシコの伝統的な料理は？", correct_answer: "タコス" },
      { question_text: "ギリシャの伝統的なサラダは？", correct_answer: "ギリシャサラダ" },
      { question_text: "タイのスパイシーなスープの名前は？", correct_answer: "トムヤムクン" }
    ]
  },
  {
    title: "音楽の歴史とジャンル",
    description: "音楽の歴史やジャンルに関するクイズです。",
    questions: [
      { question_text: "クラシック音楽の三大作曲家の一人は？", correct_answer: "モーツァルト" },
      { question_text: "ジャズの王と言われるトランペット奏者は？", correct_answer: "ルイ・アームストロング" },
      { question_text: "ビートルズの代表曲は？", correct_answer: "ヘイ・ジュード" },
      { question_text: "ロックの女王と呼ばれるアーティストは？", correct_answer: "ティナ・ターナー" },
      { question_text: "ヒップホップの発祥の地は？", correct_answer: "アメリカ" },
      { question_text: "ブルースの起源は？", correct_answer: "アフリカ系アメリカ人の音楽" },
      { question_text: "オペラ『カルメン』の作曲家は？", correct_answer: "ビゼー" },
      { question_text: "日本の伝統的な音楽の一つは？", correct_answer: "邦楽" },
      { question_text: "エレクトロニカの代表的なアーティストは？", correct_answer: "エイフェックス・ツイン" },
      { question_text: "『四季』を作曲したのは？", correct_answer: "ヴィヴァルディ" },
      { question_text: "バロック音楽の代表的な作曲家は？", correct_answer: "バッハ" }
    ]
  },
  {
    title: "科学の不思議",
    description: "科学の様々な分野に関するクイズです。",
    questions: [
      { question_text: "光は何秒で地球を一周する？", correct_answer: "約0.133秒" },
      { question_text: "アルキメデスの原理とは？", correct_answer: "浮力に関する法則" },
      { question_text: "エジソンが発明した有名なものは？", correct_answer: "電球" },
      { question_text: "酸とアルカリを混ぜるとできるものは？", correct_answer: "塩と水" },
      { question_text: "DNAの二重らせん構造を発見した科学者は？", correct_answer: "ワトソンとクリック" },
      { question_text: "ニュートンが発見した物理法則は？", correct_answer: "万有引力の法則" },
      { question_text: "太陽系で一番大きい惑星は？", correct_answer: "木星" },
      { question_text: "水が沸騰する温度は？", correct_answer: "100℃" },
      { question_text: "鉄が錆びる原因となる化学反応は？", correct_answer: "酸化" },
      { question_text: "素粒子の標準模型とは？", correct_answer: "基本粒子と力の相互作用を説明する理論" }
    ]
  },
  {
    title: "世界の神話と伝説",
    description: "世界各地の神話や伝説に関するクイズです。",
    questions: [
      { question_text: "ギリシャ神話の最高神は？", correct_answer: "ゼウス" },
      { question_text: "北欧神話の終末を何と呼ぶ？", correct_answer: "ラグナロク" },
      { question_text: "エジプト神話で死者の神は？", correct_answer: "オシリス" },
      { question_text: "日本神話の太陽の神は？", correct_answer: "天照大神" },
      { question_text: "インド神話の破壊と再生の神は？", correct_answer: "シヴァ" },
      { question_text: "ギリシャ神話で愛と美の女神は？", correct_answer: "アフロディーテ" },
      { question_text: "ケルト神話で知恵の神は？", correct_answer: "ルー" },
      { question_text: "ローマ神話の戦争の神は？", correct_answer: "マルス" },
      { question_text: "メソポタミア神話の洪水伝説に登場する人物は？", correct_answer: "ギルガメッシュ" },
      { question_text: "ポリネシア神話での創造神は？", correct_answer: "タアロア" },
      { question_text: "アステカ神話での太陽と戦争の神は？", correct_answer: "ウィツィロポチトリ" }
    ]
  },
  {
    title: "現代社会と政治",
    description: "現代社会や政治に関するクイズです。",
    questions: [
      { question_text: "国際連合の本部はどこにある？", correct_answer: "ニューヨーク" },
      { question_text: "EUの正式名称は？", correct_answer: "欧州連合" },
      { question_text: "G7に参加する国の数は？", correct_answer: "7カ国" },
      { question_text: "日本の首相は誰？", correct_answer: "現在の首相の名前" },
      { question_text: "アメリカの独立記念日はいつ？", correct_answer: "7月4日" },
      { question_text: "中国の一党制の政党は？", correct_answer: "中国共産党" },
      { question_text: "世界で最も人口が多い国は？", correct_answer: "中国" },
      { question_text: "国際オリンピック委員会の略称は？", correct_answer: "IOC" },
      { question_text: "NATOの正式名称は？", correct_answer: "北大西洋条約機構" },
      { question_text: "世界貿易機関の略称は？", correct_answer: "WTO" }
    ]
  },
  {
    title: "健康とフィットネス",
    description: "健康とフィットネスに関するクイズです。",
    questions: [
      { question_text: "1日に必要な水分摂取量は？", correct_answer: "約2リットル" },
      { question_text: "ジョギングに適した時間は？", correct_answer: "朝" },
      { question_text: "ヨガの発祥の国は？", correct_answer: "インド" },
      { question_text: "タンパク質が豊富な食べ物は？", correct_answer: "卵" },
      { question_text: "体重を減らすためには何が重要？", correct_answer: "カロリー制限" },
      { question_text: "筋トレで重要な栄養素は？", correct_answer: "プロテイン" },
      { question_text: "有酸素運動の例は？", correct_answer: "ランニング" },
      { question_text: "ビタミンCが豊富な果物は？", correct_answer: "オレンジ" },
      { question_text: "心拍数を測るデバイスは？", correct_answer: "心拍計" },
      { question_text: "ストレス解消に役立つ運動は？", correct_answer: "メディテーション" }
    ]
  },
  {
    title: "宇宙と天文学",
    description: "宇宙や天文学に関するクイズです。",
    questions: [
      { question_text: "地球から最も近い星は？", correct_answer: "太陽" },
      { question_text: "太陽系の惑星の数は？", correct_answer: "8" },
      { question_text: "月の表面にある大きな盆地を何と呼ぶ？", correct_answer: "クレーター" },
      { question_text: "銀河系の中心にあると考えられている天体は？", correct_answer: "ブラックホール" },
      { question_text: "宇宙の年齢は約何年？", correct_answer: "138億年" },
      { question_text: "最初の人工衛星の名前は？", correct_answer: "スプートニク1号" },
      { question_text: "宇宙飛行士が使用する乗り物は？", correct_answer: "宇宙船" },
      { question_text: "火星の探査機の名前は？", correct_answer: "キュリオシティ" },
      { question_text: "太陽系外惑星を発見するための技術は？", correct_answer: "トランジット法" },
      { question_text: "宇宙望遠鏡の名前は？", correct_answer: "ハッブル" },
      { question_text: "最も明るい恒星は？", correct_answer: "シリウス" },
      { question_text: "銀河系の形は？", correct_answer: "渦巻き" }
    ]
  },
  {
    title: "世界の祭りと文化",
    description: "世界各地の伝統的な祭りと文化に関するクイズです。",
    questions: [
      { question_text: "リオのカーニバルが行われる国は？", correct_answer: "ブラジル" },
      { question_text: "日本の祭りで「盆踊り」が行われる季節は？", correct_answer: "夏" },
      { question_text: "ドイツで行われるビールの祭りは？", correct_answer: "オクトーバーフェスト" },
      { question_text: "インドで色を投げ合う祭りは？", correct_answer: "ホーリー" },
      { question_text: "スペインで行われるトマト祭りは？", correct_answer: "ラ・トマティーナ" },
      { question_text: "メキシコの死者の日に飾られるものは？", correct_answer: "オフレンダ" },
      { question_text: "アメリカの感謝祭で食べられる料理は？", correct_answer: "ターキー" },
      { question_text: "タイの水掛け祭りの名前は？", correct_answer: "ソンクラーン" },
      { question_text: "中国の春節に飾られるものは？", correct_answer: "赤いランタン" },
      { question_text: "フランスで行われる美食の祭りは？", correct_answer: "バスティーユデー" }
    ]
  },
  {
    title: "テクノロジーと未来",
    description: "最新のテクノロジーや未来の予測に関するクイズです。",
    questions: [
      { question_text: "AIの正式名称は？", correct_answer: "人工知能" },
      { question_text: "自動運転技術を持つ車のことを何という？", correct_answer: "自律走行車" },
      { question_text: "量子コンピュータが使う単位は？", correct_answer: "キュービット" },
      { question_text: "VRの正式名称は？", correct_answer: "仮想現実" },
      { question_text: "IoTは何の略？", correct_answer: "モノのインターネット" },
      { question_text: "5Gは何世代の通信技術？", correct_answer: "第5世代" },
      { question_text: "3Dプリンターで製造できるものは？", correct_answer: "様々な物品" },
      { question_text: "ビッグデータを解析するための技術は？", correct_answer: "データマイニング" },
      { question_text: "宇宙旅行を提供する企業は？", correct_answer: "スペースX" },
      { question_text: "クラウドコンピューティングの代表的なサービスは？", correct_answer: "AWS" },
      { question_text: "バーチャルリアリティの対義語は？", correct_answer: "現実" }
    ]
  },
  {
    title: "動物の世界",
    description: "動物に関するクイズです。",
    questions: [
      { question_text: "地球上で最も大きい動物は？", correct_answer: "シロナガスクジラ" },
      { question_text: "最速の陸上動物は？", correct_answer: "チーター" },
      { question_text: "コアラの主食は？", correct_answer: "ユーカリの葉" },
      { question_text: "アルマジロの防御方法は？", correct_answer: "体を丸める" },
      { question_text: "北極に生息する唯一のクマは？", correct_answer: "ホッキョクグマ" },
      { question_text: "カンガルーの子供は何と呼ばれる？", correct_answer: "ジョーイ" },
      { question_text: "ゾウの牙は何でできている？", correct_answer: "象牙" },
      { question_text: "クマノミと共生する動物は？", correct_answer: "イソギンチャク" },
      { question_text: "フラミンゴの色がピンクである理由は？", correct_answer: "食べ物に含まれるカロテノイド" },
      { question_text: "ハチが作る甘い物質は？", correct_answer: "ハチミツ" }
    ]
  },
  {
    title: "ビデオゲームの世界",
    description: "ビデオゲームやその歴史に関するクイズです。",
    questions: [
      { question_text: "マリオシリーズの主人公の職業は？", correct_answer: "配管工" },
      { question_text: "ソニック・ザ・ヘッジホッグのライバルは？", correct_answer: "エッグマン" },
      { question_text: "ゼルダの伝説でリンクが持つ武器は？", correct_answer: "マスターソード" },
      { question_text: "ポケットモンスターの初代御三家は？", correct_answer: "フシギダネ、ヒトカゲ、ゼニガメ" },
      { question_text: "ファイナルファンタジーシリーズで登場する召喚獣は？", correct_answer: "バハムート" },
      { question_text: "任天堂の人気キャラクターである緑の恐竜の名前は？", correct_answer: "ヨッシー" },
      { question_text: "グランド・セフト・オートシリーズの舞台は？", correct_answer: "架空の都市" },
      { question_text: "ストリートファイターシリーズの主人公は？", correct_answer: "リュウ" },
      { question_text: "パックマンが食べるものは？", correct_answer: "ドット" },
      { question_text: "マインクラフトで作られるブロックの素材は？", correct_answer: "多種多様" }
    ]
  },
  {
    title: "ファッションとスタイル",
    description: "ファッションとスタイルに関するクイズです。",
    questions: [
      { question_text: "パリのファッションウィークが行われる時期は？", correct_answer: "春と秋" },
      { question_text: "デニムの発祥地は？", correct_answer: "アメリカ" },
      { question_text: "アイコニックな赤い靴底で知られるデザイナーは？", correct_answer: "クリスチャン・ルブタン" },
      { question_text: "ココ・シャネルが創設したブランドは？", correct_answer: "シャネル" },
      { question_text: "H&Mの本社がある国は？", correct_answer: "スウェーデン" },
      { question_text: "ビンテージファッションとは何？", correct_answer: "古着や過去のスタイルを取り入れたファッション" },
      { question_text: "ファストファッションとは？", correct_answer: "低価格で提供される最新のファッション" },
      { question_text: "バーバリーのトレードマークのパターンは？", correct_answer: "チェック" },
      { question_text: "イタリアの高級スーツブランドは？", correct_answer: "アルマーニ" },
      { question_text: "ファッションにおけるカプセルワードローブとは？", correct_answer: "必要最小限のアイテムで構成されるコーディネートの基本" }
    ]
  },
  {
    title: "世界の文学",
    description: "世界中の著名な文学作品に関するクイズです。",
    questions: [
      { question_text: "『罪と罰』を書いたのは誰？", correct_answer: "フョードル・ドストエフスキー" },
      { question_text: "『風と共に去りぬ』の舞台はどこ？", correct_answer: "アメリカ南部" },
      { question_text: "『フランケンシュタイン』の著者は？", correct_answer: "メアリー・シェリー" },
      { question_text: "『1984』の著者は？", correct_answer: "ジョージ・オーウェル" },
      { question_text: "『白鯨』を書いた作家は？", correct_answer: "ハーマン・メルヴィル" }
    ]
  },
  {
    title: "世界の音楽",
    description: "世界各国の音楽に関するクイズです。",
    questions: [
      { question_text: "「ベサメ・ムーチョ」はどこの国の曲？", correct_answer: "メキシコ" },
      { question_text: "アイルランドの伝統的な楽器は？", correct_answer: "ハープ" },
      { question_text: "「オ・ソレ・ミオ」はどの国の歌？", correct_answer: "イタリア" },
      { question_text: "「カルメン」の作曲家は？", correct_answer: "ジョルジュ・ビゼー" },
      { question_text: "フラメンコの発祥地はどこ？", correct_answer: "スペイン" }
    ]
  },
  {
    title: "天文学の基礎",
    description: "天文学に関する基本的な知識を問うクイズです。",
    questions: [
      { question_text: "冥王星は何年に惑星から外された？", correct_answer: "2006年" },
      { question_text: "太陽系で最も暑い惑星は？", correct_answer: "金星" },
      { question_text: "「北斗七星」はどの星座に含まれる？", correct_answer: "おおぐま座" },
      { question_text: "最も近い銀河は？", correct_answer: "アンドロメダ銀河" },
      { question_text: "地球から月までの平均距離は？", correct_answer: "約38万キロメートル" }
    ]
  },
  {
    title: "歴史的な発明",
    description: "歴史に名を残した発明や発見に関するクイズです。",
    questions: [
      { question_text: "電話を発明したのは誰？", correct_answer: "アレクサンダー・グラハム・ベル" },
      { question_text: "ペニシリンを発見したのは？", correct_answer: "アレクサンダー・フレミング" },
      { question_text: "ライト兄弟が初めて飛行したのは何年？", correct_answer: "1903年" },
      { question_text: "ラジウムを発見したのは？", correct_answer: "マリー・キュリー" },
      { question_text: "世界初のコンピュータの名前は？", correct_answer: "ENIAC" }
    ]
  },
  {
    title: "世界の宗教",
    description: "世界の宗教に関する知識を問うクイズです。",
    questions: [
      { question_text: "キリスト教の聖典は？", correct_answer: "聖書" },
      { question_text: "イスラム教の預言者は誰？", correct_answer: "ムハンマド" },
      { question_text: "仏教の創始者は？", correct_answer: "釈迦" },
      { question_text: "ヒンドゥー教の主要な聖典は？", correct_answer: "ヴェーダ" },
      { question_text: "ユダヤ教の安息日は何曜日？", correct_answer: "土曜日" }
    ]
  }
]

# ユーザーごとにクイズを割り当てる（事前に決める）
assigned_quizzes = {
  users[0] => all_quizzes[0, 7],  # 例えば、ユーザー1には最初の7つのクイズを割り当て
  users[1] => all_quizzes[7, 7],  # ユーザー2には次の7つ
  users[2] => all_quizzes[14, 7], # ユーザー3にはその次の7つ
  users[3] => all_quizzes[21, 7], # ユーザー4にはさらに次の7つ
  users[4] => all_quizzes[28, 7]  # ユーザー5には残りの7つ
}

# 割り当てたクイズを各ユーザーに作成
assigned_quizzes.each do |user, quizzes|
  quizzes.each do |quiz_data|
    quiz = Quiz.create!(
      title: quiz_data[:title],
      description: quiz_data[:description],
      user: user
    )

    quiz_data[:questions].each do |q|
      question = Question.new(
        question_text: q[:question_text],
        correct_answer: q[:correct_answer]
      )

      # 質問とクイズの関連付けを行い、質問を保存
      question.quizzes << quiz
      if question.save
        puts "Created question: #{question.question_text}"
      else
        puts "Error creating question: #{question.errors.full_messages.join(', ')}"
      end
    end
  end
end

puts "Seeding completed successfully."
