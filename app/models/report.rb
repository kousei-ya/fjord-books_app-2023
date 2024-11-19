# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :report_mentions, dependent: :destroy
  has_many :mentioning_reports, through: :report_mentions, source: :mentioned_report
  has_many :reverse_report_mentions, class_name: 'ReportMention', foreign_key: :mentioned_report_id, dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :reverse_report_mentions, source: :report

  after_save :update_mentions

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def update_mentions
    mentioned_report_ids = extract_mentioned_report_ids(content)
    report_mentions.where.not(mentioned_report_id: mentioned_report_ids).destroy_all
    mentioned_report_ids.each do |mentioned_report_id|
      report_mentions.find_or_create_by(mentioned_report_id:)
    end
  end

  def extract_mentioned_report_ids(text)
    text.scan(%r{http://localhost:3000/reports/(\d+)}).flatten.map(&:to_i)
  end
end
