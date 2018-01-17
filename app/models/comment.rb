class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  validates :comment, :user_id, :entry_id, presence: true
  scope :split_first, -> { order("updated_at DESC").limit(1) }
  scope :split_tale, -> { order("updated_at DESC").offset(1) }
end
