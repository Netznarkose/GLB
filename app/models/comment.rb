class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  validates :comment, :user_id, :entry_id, presence: true
end
