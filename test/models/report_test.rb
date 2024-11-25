# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '日報を編集できればeditable?がtrueを返す' do
    kousei = users(:kousei)
    report = kousei.reports.create!(title: '今日も頑張った', content: '帰りましょう')

    assert report.editable?(kousei)
  end

  test '日報を編集できなければeditable?がfalseを返す' do
    bob = users(:bob)
    carol = users(:carol)
    report = bob.reports.create!(title: '今日も頑張った', content: '帰りましょう')

    assert_not report.editable?(carol)
  end

  test 'レポートを作成した日付を取得する' do
    dave = users(:dave)
    report = dave.reports.create!(title: '今日も頑張った', content: '帰りましょう', created_at: Time.zone.local(2024, 11, 18, 15, 30, 0))

    assert_equal Date.new(2024, 11, 18), report.created_on
  end

  test '日報に他の日報のURLが含まれている時に対象の日報をmentioning_reportsに追加する' do
    eve = users(:eve)
    frank = users(:frank)

    report1 = eve.reports.create!(title: 'report1', content: "いい天気ですね")
    report2 = frank.reports.create!(title: 'report2', content: "http://localhost:3000/reports/#{report1.id}")
    report3 = frank.reports.create!(title: 'report3', content: "http://localhost:3000/reports/#{report2.id}")

    assert_includes report2.mentioning_reports, report1
    assert_includes report3.mentioning_reports, report2
    assert_not_includes report2.mentioning_reports, report3
  end
end
