class User < ApplicationRecord
  has_many :auth_providers, dependent: :destroy

  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
      message: 'Email not in correct format.'
    }

  def token_set?
    self.auth_token.present?
  end

  def token_not_set?
    !token_set?
  end

  def destroy_auth_token!
    self.auth_token = nil
    self.save
  end

  def any_errors?
    self.errors.any?
  end

  def no_errors?
    self.errors.blank?
  end
end
