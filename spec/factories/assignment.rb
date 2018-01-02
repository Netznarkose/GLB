FactoryBot.define do
  factory :assignment do
    creator_id { create(:admin).id }
    recipient_id { create(:editor).id }
    from_date Date.today
    to_date Date.today + 3.month
    entry_id { create(:entry).id }
  end
end
