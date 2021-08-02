class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  belongs_to :region
  belongs_to :province
  belongs_to :city

  has_one_attached :image
  before_validation :generate_confirmation_token

  enum gender: %w[Male Female]
  enum role: %w[Player]
  enum status: %w[Active Inactive]

  validates :confirmation_token, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :contact_number, presence: true
  validates :name, presence: true
  validates :birthday, presence: true

  def image_path
    return Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) if image.attached?
  end

  def generate_verification_code
    code =  (SecureRandom.random_number(9e5) + 1e5).to_i
    count = User.where(verification_code: code).count
    while count.positive?
      code = (SecureRandom.random_number(9e5) + 1e5).to_i
      count = User.where(verification_code: code).count
    end
    self.verification_code = code
    self.verification_sent_at = Date.today
  end

  def code_expired?
    return true if verification_sent_at.present? && verification_sent_at + 1.days < Date.today
    false
  end

  def total_in_app_currency
    in_app_currency_transactions.sum(:amount)
  end

  def password_required?
    return false
    # return false if skip_password_validation
    super
  end

  private

  def generate_confirmation_token
    return if confirmation_token.present?

    token = SecureRandom.uuid
    count = User.where(confirmation_token: token).count
    while count.positive?
      token = SecureRandom.uuid
      count = User.where(confirmation_token: token).count
    end
    self.confirmation_token = token
  end
end
