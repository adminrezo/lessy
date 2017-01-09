class User < ApplicationRecord

  authenticates_with_sorcery!

  before_create :setup_activation
  after_create :send_activation_needed_email!

  validates :username, format: { with: /\A[a-z_\-]{1,}\z/, message: 'only allows lowercase letters, underscore and hiphen' }, allow_nil: true

  def self.find_by_authorization_token(token)
    decoded_token = JsonWebToken.decode(token)
    return nil unless decoded_token
    User.find decoded_token[:user_id]
  end

  def token(expiration = 1.day.from_now)
   JsonWebToken.encode({ user_id: self.id }, expiration)
  end

end
