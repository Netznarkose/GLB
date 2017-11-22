FactoryBot.define do
  factory :comment, class: Comment do
    user_id { FactoryBot.create(:admin).id }
    entry_id { FactoryBot.create(:entry).id }
    comment 'Test comment!'
  end
end
