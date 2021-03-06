class User < ApplicationRecord
  has_many :weapons
  has_many :armors
  has_many :gears
  has_many :properties
  has_many :damage_types
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true,
                   length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  validates :password, presence: true,
                       length: { minimum: 6 },
                       allow_nil: true

  def first_name
    self.name.split.first
  end

  def last_name
    self.name.split.last
  end
end
