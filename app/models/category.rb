class Category < ApplicationRecord
  has_many :words, dependent: :destroy
  has_many :lessons, dependent: :destroy

  validates :name, presence: true, length: {maximum: 50}

  scope :search, ->search {where "name LIKE ?", "%#{search}%"}
  scope :recent, ->{order "categories.created_at DESC"}
end
