class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  # attr_accessible :entry_id, :user_id, :comment
  validates :comment, presence: true
  validates :user_id, presence: true
  validates :entry_id, presence: true
end
