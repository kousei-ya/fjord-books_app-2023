# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:one)

    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    click_on '日報'
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Railsについて'
    fill_in '内容', with: '初めて触ったがものすごく便利です'
    click_button '登録する'

    assert_text '日報が作成されました。'
    assert_text 'Railsについて'
    assert_text '初めて触ったがものすごく便利です'
    click_on '日報の一覧に戻る'
  end

  test 'should update Report' do
    visit report_url(@report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: 'テストについて'
    fill_in '内容', with: 'ブラウザが立ち上がってテストしてくれるのがとても便利です'
    click_button '更新する'

    assert_text '日報が更新されました'
    assert_text 'テストについて'
    assert_text 'ブラウザが立ち上がってテストしてくれるのがとても便利です'
    click_on '日報の一覧に戻る'
  end

  test 'should destroy Report' do
    visit report_url(@report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました'

    visit reports_url
    assert_no_text 'テストについて'
  end
end
