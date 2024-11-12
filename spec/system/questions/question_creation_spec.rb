require 'rails_helper'

RSpec.describe 'Question Management', type: :system do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz, user:) }

  before do
    sign_in user
  end

  describe '質問の作成', js: true do
    context '有効な場合' do
      it '問題文と答えがあれば質問を作成できること', js: true do
        visit new_quiz_question_path(quiz)
        fill_in '質問テキスト', with: 'これは新しい質問です'
        fill_in '正解', with: '答え'
        click_button '質問を作成'

        expect(page).to have_content('質問が作成されました。')
        expect(page).to have_content('画像をアップロードしてください')
      end
    end

    context '無効な場合' do
      it '問題文がなければ質問を作成できないこと' do
        visit new_quiz_question_path(quiz)
        fill_in '質問テキスト', with: ''
        fill_in '正解', with: '答え'
        click_button '質問を作成'

        expect(page).to have_content('質問テキストを入力してください')
      end

      it '答えがなければ質問を作成できないこと' do
        visit new_quiz_question_path(quiz)
        fill_in '質問テキスト', with: 'これは新しい質問です'
        fill_in '正解', with: ''
        click_button '質問を作成'

        expect(page).to have_content('正解を入力してください')
      end
    end

    context 'ログインしていないユーザーの場合' do
      before do
        sign_out user
      end

      it '質問作成ページにアクセスできず、ログインページにリダイレクトされること' do
        visit new_quiz_question_path(quiz)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('ログインしてください。')
      end
    end
  end

  describe '複数質問の作成', js: true do
    context '有効な場合' do
      it '複数の有効な質問が一括で作成されること' do
        visit new_quiz_question_path(quiz)
        fill_in '質問テキスト', with: '質問1'
        fill_in '正解', with: '答え1'
        click_button '質問を追加'

        within '#generated-questions' do
          fill_in '質問テキスト', with: '質問2'
          fill_in '正解', with: '答え2'
        end

        click_button 'すべての質問を作成'

        expect(page).to have_content('すべての質問が正常に作成されました。')
      end
    end

    context '無効な場合' do
      it '無効な質問が含まれる場合、エラーメッセージが表示されること' do
        visit new_quiz_question_path(quiz)
        fill_in '質問テキスト', with: '質問1'
        fill_in '正解', with: '答え1'
        click_button '質問を追加'

        within '#generated-questions' do
          fill_in '質問テキスト', with: ''
          fill_in '正解', with: '答え2'
        end

        click_button 'すべての質問を作成'

        expect(page).to have_content('質問テキストを入力してください')
        expect(page).to have_content('1件の質問が正常に保存されました。')
        within '#generated-questions' do
          expect(find_field('質問テキスト').value).to eq ''
          expect(find_field('正解').value).to eq '答え2'
        end
      end
    end
  end

  describe '画像からテキストを抽出して質問を生成', js: true do
    context '有効な画像の場合' do
      it '画像をアップロードしてテキストから質問を生成できること' do
        visit new_quiz_question_path(quiz)
        attach_file('画像をアップロードしてください', Rails.root.join('spec/fixtures/test_image.jpg'))
        click_button '画像からテキストを抽出'

        expect(page).to have_content('画像からテキストを抽出しました。')
      end
    end
  end

  describe 'テキストからAIを使って質問を生成', js: true do
    context '有効なテキストの場合' do
      it 'テキストから質問を生成できること' do
        visit new_quiz_question_path(quiz)
        fill_in 'テキストを入力してください', with: 'これはサンプルテキストです。'
        click_button 'AIで質問を生成'

        expect(page).to have_content('質問が生成されました。')
      end
    end
  end

  describe '動的に追加された質問フォーム', js: true do
    it '動的に追加されたフォームから質問を作成できること' do
      visit new_quiz_question_path(quiz)
      click_button '質問を追加'

      within '#generated-questions' do
        fill_in '質問テキスト', with: 'これは追加された質問です'
        fill_in '正解', with: '追加された答え'
        click_button '質問を作成'
      end

      expect(page).to have_content('質問が作成されました。')
    end
  end
end
