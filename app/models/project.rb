class Project < ActiveRecord::Base
  validates :title, :vision, :need, :benefit, :description, :contact_name, :contact_email, :contact_phone, :organization_id, :presence => true
  validates :title, :description, :uniqueness => true
  belongs_to :organization
  belongs_to :developer, class_name: "User"
  has_one :org_admin, through: :organization
  validate :validatePhoneNumber, on: :create



  def self.search(query)
    where("description like ? or title like ?" , "%#{query}%", "%#{query}%")
  end

  def validatePhoneNumber
    errors.add(:contact_phone, "Please enter a valid 10 digit phone number") unless
      /\W*([2-9][0-8][0-9])\W*([2-9][0-9]{2})\W*([0-9]{4})(\se?x?t?(\d*))?/ =~ self.contact_phone
  end

  # def project_notification(record)
  #   @record = record
  #    mail to: "danyell85@gmail.com", subject: "You project got selected."
  # end

end
