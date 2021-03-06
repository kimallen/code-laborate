class User < ActiveRecord::Base
  validates :first_name, :last_name, :email, :presence => true
  validates :email, :uniqueness => true
  has_one :current_project, class_name: "Project", foreign_key: :developer_id
  belongs_to :organization
  has_many :bookmarks, foreign_key: "developer_id"
  has_many :bookmarked_projects, through: :bookmarks, source: :project
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Paperclip Avatar
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
        namesplit = auth.info.name.split(" ")
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.first_name = namesplit.first
        user.last_name = namesplit.last
        user.password = Devise.friendly_token[0,20]
        user.org_affiliate = true
      end
  end

  def self.search(query)
    where("name like ?", "%#{query}%")
  end
end
