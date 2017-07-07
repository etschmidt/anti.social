class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts, dependent: :destroy

	validates :name, presence: true, length: { maximum: 85 }
	validates :email, presence: true, length: { maximum: 100 }

	is_impressionable :counter_cache => true, :unique => :request_hash

def self.search(search)
  search.present? ? where('name LIKE ?', "%#{search}%") : all
end

end
