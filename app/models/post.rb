class Post < ApplicationRecord
  belongs_to :user
  belongs_to :parent_post, class_name: 'Post', optional: true
  has_many :sugesstions, class_name: 'Post', foreign_key: :parent_post_id, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, through: :comments

  has_many :likes, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :content, presence: true
end
