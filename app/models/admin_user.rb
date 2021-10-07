class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  
  has_one_attached :image
  has_and_belongs_to_many :networks
  accepts_nested_attributes_for :networks

  enum status: ["Active", "Inactive"]
  enum role: ["Super Admin", "Admin", "DJ"]

  scope :djs, -> { where(:role => "DJ")}
  # Ex:- scope :active, -> {where(:active => true)}

  def super_admin?
    role == "Super Admin"
  end

  def admin?
    role == "Admin"
  end

  def dj?
    role == "DJ"  
  end


  def image_path
    return Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) if image.attached?
  end
  
  def password_required?
    return false
    super
  end
end
