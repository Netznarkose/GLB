FactoryGirl.define do
  factory :comment, class: Comment do
    user_id { FactoryGirl.create(:admin).id }
    entry_id { FactoryGirl.create(:entry).id }
    comment 'Test comment!'
  end
end
