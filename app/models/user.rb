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

  enum gender: %w[Male Female Undisclosed]
  enum role: %w[Player]
  enum status: %w[Active Inactive]
  enum online_status: %w[Offline Online]
  enum login_type: %w[Email Facebook Google Apple]

  # validates :confirmation_token, presence: true, uniqueness: { case_sensitive: false }
  # validates :username, presence: true, uniqueness: { case_sensitive: false }
  # validates :contact_number, presence: true
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :birthday, presence: true

  def verified?
    verified_at.present? ? "Verified" : "Unverified"
  end
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

  def email_required?
    return login_type == "Email"
  end

  def password_required?
    return false
    super
  end

  def self.serializer
    {
      methods: %i[image_path],
      include: []
    }
  end

  def name
    "#{first_name} #{last_name}"
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
