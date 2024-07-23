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
User.create!(
  email: 'guest@example.com',
  password: 'guestpassword',
  confirmed_at: Time.zone.now
)

# ユーザーを作成
users = []
5.times do |n|
  users << User.create!(
    email: "user#{n + 1}@example.com",
    password: 'password',
    confirmed_at: Time.zone.now
  )
end

# 各ユーザーに異なるクイズを作成
users.each_with_index do |user, index|
  quizzes = [
    {
      title: "日本の歴史クイズ",
      description: "日本の歴史に関するクイズです。",
      questions: [
        { question_text: "日本で最初の元号は何ですか？", correct_answer: "大化" },
        { question_text: "明治維新は何年に始まりましたか？", correct_answer: "1868年" },
        { question_text: "戦国時代に天下統一を果たした武将は誰ですか？", correct_answer: "豊臣秀吉" },
        { question_text: "東京が首都になったのは何年ですか？", correct_answer: "1869年" },
        { question_text: "鎌倉幕府を開いたのは誰ですか？", correct_answer: "源頼朝" }
      ]
    },
    {
      title: "科学クイズ",
      description: "基本的な科学知識に関するクイズです。",
      questions: [
        { question_text: "水の化学記号は何ですか？", correct_answer: "H2O" },
        { question_text: "地球の重力加速度は約何m/s²ですか？", correct_answer: "9.8" },
        { question_text: "光の速さは約何km/sですか？", correct_answer: "300000" },
        { question_text: "ニュートンが発見した法則は何ですか？", correct_answer: "万有引力の法則" },
        { question_text: "酸素は周期表の何番目の元素ですか？", correct_answer: "8" }
      ]
    },
    {
      title: "文学クイズ",
      description: "有名な文学作品に関するクイズです。",
      questions: [
        { question_text: "『源氏物語』の作者は誰ですか？", correct_answer: "紫式部" },
        { question_text: "『吾輩は猫である』の著者は誰ですか？", correct_answer: "夏目漱石" },
        { question_text: "『ハムレット』の著者は誰ですか？", correct_answer: "シェイクスピア" },
        { question_text: "『ドン・キホーテ』の著者は誰ですか？", correct_answer: "セルバンテス" },
        { question_text: "『戦争と平和』の著者は誰ですか？", correct_answer: "トルストイ" }
      ]
    },
    {
      title: "スポーツクイズ",
      description: "スポーツに関する知識を問うクイズです。",
      questions: [
        { question_text: "オリンピックは何年ごとに開催されますか？", correct_answer: "4年" },
        { question_text: "サッカーのワールドカップは何年ごとに開催されますか？", correct_answer: "4年" },
        { question_text: "野球で完全試合を達成するために必要なアウトの数は？", correct_answer: "27" },
        { question_text: "テニスのグランドスラムは全部でいくつありますか？", correct_answer: "4つ" },
        { question_text: "オリンピックのマラソンの距離は何kmですか？", correct_answer: "42.195km" }
      ]
    },
    {
      title: "映画クイズ",
      description: "映画に関する知識を問うクイズです。",
      questions: [
        { question_text: "『タイタニック』の監督は誰ですか？", correct_answer: "ジェームズ・キャメロン" },
        { question_text: "『スター・ウォーズ』の主人公の名前は？", correct_answer: "ルーク・スカイウォーカー" },
        { question_text: "『ゴッドファーザー』の原作を書いたのは誰ですか？", correct_answer: "マリオ・プーゾ" },
        { question_text: "『ハリー・ポッター』シリーズの作者は誰ですか？", correct_answer: "J.K.ローリング" },
        { question_text: "『ロード・オブ・ザ・リング』の舞台はどこですか？", correct_answer: "中つ国" }
      ]
    }
  ]

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
