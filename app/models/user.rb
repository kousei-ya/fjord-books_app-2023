# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :user_icon

  validate :verify_file_type

  private

  def verify_file_type
    return unless user_icon.attached?

    unless user_icon.blob.image?
      errors.add(:user_icon, I18n.t('errors.messages.invariable_error'))
      return
    end

    allowed_file_types = %w[image/jpeg image/gif image/png]
    unless allowed_file_types.include?(user_icon.blob.content_type)
      errors.add(:user_icon, I18n.t('errors.messages.invalid_type'))
    end
  end
end
