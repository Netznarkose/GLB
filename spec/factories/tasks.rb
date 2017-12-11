FactoryBot.define do
  factory :task do
    assigned_from_user { create(:admin).id }
    assigned_to_user { create(:editor).id }
    assigned_at_date Date.today
    assigned_to_date Date.today + 3.month
    assigned_entry { create(:entry).id }
  end
end
